_ = require 'lodash'
Promise = require 'bluebird'
request = Promise.promisifyAll require 'request'
cheerio = require 'cheerio'
urlLib = require 'url'
fs = require 'fs'

console.time('Run time')

URL = 'http://www.toptal.com'

skills = {}
developers = {}

getDeveloperInfo = ($this, $) ->
  url = $this.find('.skill_developer-name').attr('href')
  parsedUrl = urlLib.parse(url)
  slug =  parsedUrl.pathname.split('/')[2]
  $desc = $this.find('.skill_developer-description')
  $desc.find('.link').remove()
  return {
    slug
    url: URL + url
    name: $this.find('.skill_developer-name').text()
    desc: $desc.text()
    photo: $this.find('.skill_developer-photo').attr('src')
    skills: $this.find('.skill_developer-skill').map( -> $(this).text() ).get()
  }

request.getAsync(URL)
.spread (response, body) ->
  $ = cheerio.load(body)
  $('.page_footer_sample_profile-wrapper .multi_column_list-link').each ->
    $this = $(this)
    title = $this.text()
    if title == 'CTOs'
      title = 'CTO'
    else
      title = title.split(' ')[...-1].join(' ')
    url = URL + $this.attr('href')
    skills[title] = { url }
.then ->
  Promise.map _.pairs(skills), ([ title, skill ]) ->
    request.getAsync(skill.url)
    .spread (response, body) ->
      $ = cheerio.load(body)
      skill.developers = d = []
      $('.skill_developer').each ->
        $this = $(this)
        developerInfo = getDeveloperInfo($this, $)
        d.push(developerInfo.slug)
        developers[developerInfo.slug] = developerInfo
  , concurrency: 10
.then ->
  for title, skill of skills
    if not skill.developers?.length
      delete skills[title]
  for slug, developer of developers
    developer.skills = _.filter developer.skills, (skill) ->
      !!skills[skill]
  result = { skills, developers }
  fs.writeFileSync 'data.js', "window.DB = #{JSON.stringify(result)};"
  console.timeEnd('Run time')

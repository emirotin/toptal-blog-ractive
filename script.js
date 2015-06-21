(function () {
  var skills = DB.skills, developers = DB.developers;
  var skillNames = _.keys(DB.skills);

  var app = new Ractive({
    el: '#root',
    template: '#tpl-app',
    data: {
      skillFilter: null,

      currentSkill: null,

      skills: function() {
        var skillFilter = this.get('skillFilter');
        if (!skillFilter) {
          return skillNames;
        }
        skillFilter = new RegExp(_.escapeRegExp(skillFilter), 'i')
        return _.filter(skillNames, function(skill) {
          return skill.match(skillFilter);
        });
      },

      skillDevelopers: function(skill) {
        skill = skills[skill];
        if (!skill) {
          return;
        }
        return _.map(skill.developers, function(slug) {
          return developers[slug];
        });
      }
    }
  });

  app.on('select-skill', function(event, skill) {
    this.set({
      currentSkill: skill,
      skillFilter: null
    });
  });

  app.on('deselect-skill', function(event) {
    this.set('currentSkill', null);
  });

}());

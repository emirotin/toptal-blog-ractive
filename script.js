(function () {
  var skills = DB.skills, developers = DB.developers;
  var skillNames = _.keys(DB.skills);

  var app = new Ractive({
    el: '#root',
    template: '#tpl-app',
    data: {
      skillFilter: null,
      skills: function() {
        var skillFilter = this.get('skillFilter');
        if (!skillFilter) {
          return skillNames;
        }
        skillFilter = new RegExp(_.escapeRegExp(skillFilter), 'i')
        return _.filter(skillNames, function(skill) {
          return skill.match(skillFilter);
        });
      }
    }
  });

}());

(function () {
  var skills = DB.skills, developers = DB.developers;

  var app = new Ractive({
    el: '#root',
    template: '#tpl-app',
    data: {
      skills: _.keys(DB.skills)
    }
  });

}());

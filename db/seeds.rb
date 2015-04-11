Widget.delete_all
Widget.create(name:'Github-Status', widget_type: 'Github')
Widget.create(name:'Github-Open-PR', widget_type: 'Github')
Widget.create(name:'Github-Closed-PR', widget_type: 'Github')
Widget.create(name:'Github-Last-10-Commits', widget_type: 'Github')

Widget.create(name:'To-Do-list', widget_type: 'Jira')
Widget.create(name:'Assign-to-QA', widget_type: 'Jira')
Widget.create(name:'Sprint-remaning-days', widget_type: 'Jira')
Widget.create(name:'Sprint-progress', widget_type: 'Jira')
Widget.create(name:'No of open-issues', widget_type: 'Jira')

Widget.create(name:'GPA', widget_type: 'Code Climate')
Widget.create(name:'Test-coverage', widget_type: 'Code Climate')

Widget.create(name:'Build-test', widget_type: 'Jenkins')

Widget.all.each do |u|
	puts "Widget '#{u.name}' created"
end
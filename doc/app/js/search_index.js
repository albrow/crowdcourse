var search_data = {"index":{"searchIndex":["applicationcontroller","applicationhelper","badge","category","choicequestion","comment","component","course","dynamicpagescontroller","dynamicpageshelper","fieldquestion","quiz","quizchoice","quizscore","sessionscontroller","sessionshelper","staticpagescontroller","staticpageshelper","user","userscontroller","usershelper","video","videorating","videoview","about()","create()","create()","current_user()","current_user=()","destroy()","full_title()","gravatar_for()","home()","index()","landing()","new()","new()","pill()","profile()","robots()","show()","sign_in()","sign_out()","signed_in?()","styletests()","readme_for_app"],"longSearchIndex":["applicationcontroller","applicationhelper","badge","category","choicequestion","comment","component","course","dynamicpagescontroller","dynamicpageshelper","fieldquestion","quiz","quizchoice","quizscore","sessionscontroller","sessionshelper","staticpagescontroller","staticpageshelper","user","userscontroller","usershelper","video","videorating","videoview","staticpagescontroller#about()","sessionscontroller#create()","userscontroller#create()","sessionshelper#current_user()","sessionshelper#current_user=()","sessionscontroller#destroy()","applicationhelper#full_title()","usershelper#gravatar_for()","dynamicpagescontroller#home()","staticpagescontroller#index()","staticpagescontroller#landing()","sessionscontroller#new()","userscontroller#new()","applicationhelper#pill()","userscontroller#profile()","applicationcontroller#robots()","userscontroller#show()","sessionshelper#sign_in()","sessionshelper#sign_out()","sessionshelper#signed_in?()","staticpagescontroller#styletests()",""],"info":[["ApplicationController","","ApplicationController.html","",""],["ApplicationHelper","","ApplicationHelper.html","",""],["Badge","","Badge.html","","<p>Schema Information\n<p>Table name: badges\n\n<pre>id          :integer         not null, primary key\nuser_id     :string(255) ...</pre>\n"],["Category","","Category.html","","<p>Schema Information\n<p>Table name: categories\n\n<pre>id          :integer         not null, primary key\nname      ...</pre>\n"],["ChoiceQuestion","","ChoiceQuestion.html","","<p>Schema Information\n<p>Table name: choice_questions\n\n<pre>id          :integer         not null, primary key\nquiz_id ...</pre>\n"],["Comment","","Comment.html","","<p>Schema Information\n<p>Table name: comments\n\n<pre>id         :integer         not null, primary key\nuser_id    :integer ...</pre>\n"],["Component","","Component.html","","<p>Schema Information\n<p>Table name: components\n\n<pre>id          :integer         not null, primary key\nname      ...</pre>\n"],["Course","","Course.html","","<p>Schema Information\n<p>Table name: courses\n\n<pre>id          :integer         not null, primary key\nname        :string(255) ...</pre>\n"],["DynamicPagesController","","DynamicPagesController.html","",""],["DynamicPagesHelper","","DynamicPagesHelper.html","",""],["FieldQuestion","","FieldQuestion.html","","<p>Schema Information\n<p>Table name: field_questions\n\n<pre>id          :integer         not null, primary key\nquiz_id ...</pre>\n"],["Quiz","","Quiz.html","","<p>Schema Information\n<p>Table name: quizzes\n\n<pre>id            :integer         not null, primary key\ncomponent_id ...</pre>\n"],["QuizChoice","","QuizChoice.html","","<p>Schema Information\n<p>Table name: quiz_choices\n\n<pre>id          :integer         not null, primary key\nquestion_id ...</pre>\n"],["QuizScore","","QuizScore.html","","<p>Schema Information\n<p>Table name: quiz_scores\n\n<pre>id         :integer         not null, primary key\nuser_id   ...</pre>\n"],["SessionsController","","SessionsController.html","",""],["SessionsHelper","","SessionsHelper.html","",""],["StaticPagesController","","StaticPagesController.html","",""],["StaticPagesHelper","","StaticPagesHelper.html","",""],["User","","User.html","","<p>Schema Information\n<p>Table name: users\n\n<pre>id              :integer         not null, primary key\nusername   ...</pre>\n"],["UsersController","","UsersController.html","",""],["UsersHelper","","UsersHelper.html","",""],["Video","","Video.html","","<p>Schema Information\n<p>Table name: videos\n\n<pre>id             :integer         not null, primary key\ncomponent_id ...</pre>\n"],["VideoRating","","VideoRating.html","","<p>Schema Information\n<p>Table name: video_ratings\n\n<pre>id         :integer         not null, primary key\nvideo_id ...</pre>\n"],["VideoView","","VideoView.html","","<p>Schema Information\n<p>Table name: video_views\n\n<pre>id         :integer         not null, primary key\nviewer_id ...</pre>\n"],["about","StaticPagesController","StaticPagesController.html#method-i-about","()",""],["create","SessionsController","SessionsController.html#method-i-create","()",""],["create","UsersController","UsersController.html#method-i-create","()",""],["current_user","SessionsHelper","SessionsHelper.html#method-i-current_user","()",""],["current_user=","SessionsHelper","SessionsHelper.html#method-i-current_user-3D","(user)",""],["destroy","SessionsController","SessionsController.html#method-i-destroy","()",""],["full_title","ApplicationHelper","ApplicationHelper.html#method-i-full_title","(page_title)","<p>Returns the full title on a per-page basis.\n"],["gravatar_for","UsersHelper","UsersHelper.html#method-i-gravatar_for","(user)",""],["home","DynamicPagesController","DynamicPagesController.html#method-i-home","()",""],["index","StaticPagesController","StaticPagesController.html#method-i-index","()",""],["landing","StaticPagesController","StaticPagesController.html#method-i-landing","()",""],["new","SessionsController","SessionsController.html#method-i-new","()",""],["new","UsersController","UsersController.html#method-i-new","()",""],["pill","ApplicationHelper","ApplicationHelper.html#method-i-pill","(name, path, active)","<p>renders a pill item (really an li) that is either active or not based on\nthe page that’s being viewed …\n"],["profile","UsersController","UsersController.html#method-i-profile","()",""],["robots","ApplicationController","ApplicationController.html#method-i-robots","()",""],["show","UsersController","UsersController.html#method-i-show","()",""],["sign_in","SessionsHelper","SessionsHelper.html#method-i-sign_in","(user)",""],["sign_out","SessionsHelper","SessionsHelper.html#method-i-sign_out","()",""],["signed_in?","SessionsHelper","SessionsHelper.html#method-i-signed_in-3F","()",""],["styleTests","StaticPagesController","StaticPagesController.html#method-i-styleTests","()",""],["README_FOR_APP","","doc/README_FOR_APP.html","","<p>Use this README file to introduce your application and point to useful\nplaces in the API for learning …\n"]]}}
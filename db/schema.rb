# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120718202430) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "kind"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "activities", ["user_id"], :name => "index_activities_on_user_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "badge_earnings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "badge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "badge_earnings", ["badge_id", "user_id"], :name => "index_badge_earnings_on_badge_id_and_user_id"
  add_index "badge_earnings", ["badge_id"], :name => "index_badge_earnings_on_badge_id"
  add_index "badge_earnings", ["user_id"], :name => "index_badge_earnings_on_user_id"

  create_table "badges", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_large"
    t.string   "image_small"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "badges", ["name"], :name => "index_badges_on_name"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_large"
    t.string   "image_small"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "categories_courses", :force => true do |t|
    t.integer "category_id"
    t.integer "course_id"
  end

  add_index "categories_courses", ["category_id", "course_id"], :name => "index_categories_courses_on_category_id_and_course_id"
  add_index "categories_courses", ["category_id"], :name => "index_categories_courses_on_category_id"
  add_index "categories_courses", ["course_id"], :name => "index_categories_courses_on_course_id"

  create_table "choice_questions", :force => true do |t|
    t.integer  "quiz_id"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "choice_questions", ["quiz_id"], :name => "index_choice_questions_on_quiz_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "quiz_id"
    t.integer  "flags_count", :default => 0
    t.text     "content"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "comments", ["quiz_id"], :name => "index_comments_on_quiz_id"
  add_index "comments", ["user_id", "quiz_id"], :name => "index_comments_on_user_id_and_quiz_id"
  add_index "comments", ["user_id", "video_id"], :name => "index_comments_on_user_id_and_video_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"
  add_index "comments", ["video_id"], :name => "index_comments_on_video_id"

  create_table "components", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "priority"
    t.string   "alias"
    t.integer  "section_id"
    t.text     "detailed_description"
  end

  add_index "components", ["name"], :name => "index_components_on_name"
  add_index "components", ["section_id"], :name => "index_components_on_section_id"

  create_table "components_courses", :force => true do |t|
    t.integer "component_id"
    t.integer "course_id"
  end

  add_index "components_courses", ["component_id", "course_id"], :name => "index_components_courses_on_component_id_and_course_id"
  add_index "components_courses", ["component_id"], :name => "index_components_courses_on_component_id"
  add_index "components_courses", ["course_id"], :name => "index_components_courses_on_course_id"

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_large"
    t.string   "image_small"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "priority"
    t.boolean  "has_sections", :default => true
  end

  add_index "courses", ["name"], :name => "index_courses_on_name", :unique => true
  add_index "courses", ["priority"], :name => "index_courses_on_priority"

  create_table "courses_users", :force => true do |t|
    t.integer "course_id"
    t.integer "user_id"
  end

  add_index "courses_users", ["course_id"], :name => "index_courses_users_on_course_id"
  add_index "courses_users", ["user_id", "course_id"], :name => "index_courses_users_on_user_id_and_course_id"
  add_index "courses_users", ["user_id"], :name => "index_courses_users_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "enrollments", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "progress_as_percent", :default => 0
    t.integer  "num_videos_watched",  :default => 0
    t.integer  "num_quizzes_passed",  :default => 0
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "show",                :default => true
    t.time     "last_active"
  end

  add_index "enrollments", ["course_id"], :name => "index_enrollments_on_course_id"
  add_index "enrollments", ["user_id", "course_id"], :name => "index_enrollments_on_user_id_and_course_id"
  add_index "enrollments", ["user_id"], :name => "index_enrollments_on_user_id"

  create_table "field_questions", :force => true do |t|
    t.integer  "quiz_id"
    t.text     "description"
    t.text     "answer"
    t.string   "field_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "field_questions", ["quiz_id"], :name => "index_field_questions_on_quiz_id"

  create_table "flags", :force => true do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "video_id"
    t.integer  "quiz_id"
    t.string   "cause"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flags", ["comment_id"], :name => "index_flags_on_comment_id"
  add_index "flags", ["quiz_id"], :name => "index_flags_on_quiz_id"
  add_index "flags", ["user_id", "comment_id"], :name => "index_flags_on_user_id_and_comment_id"
  add_index "flags", ["user_id", "quiz_id"], :name => "index_flags_on_user_id_and_quiz_id"
  add_index "flags", ["user_id", "video_id"], :name => "index_flags_on_user_id_and_video_id"
  add_index "flags", ["user_id"], :name => "index_flags_on_user_id"
  add_index "flags", ["video_id"], :name => "index_flags_on_video_id"

  create_table "mailing_list_members", :force => true do |t|
    t.string   "email"
    t.date     "last_sent"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "pg_search_documents", :force => true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "quiz_choices", :force => true do |t|
    t.integer  "question_id"
    t.text     "content"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "is_answer",   :default => false
  end

  add_index "quiz_choices", ["question_id"], :name => "index_quiz_choices_on_question_id"

  create_table "quiz_scores", :force => true do |t|
    t.integer  "user_id"
    t.integer  "quiz_id"
    t.integer  "score"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "video_id"
  end

  add_index "quiz_scores", ["quiz_id"], :name => "index_quiz_scores_on_quiz_id"
  add_index "quiz_scores", ["user_id", "quiz_id"], :name => "index_quiz_scores_on_user_id_and_quiz_id"
  add_index "quiz_scores", ["user_id"], :name => "index_quiz_scores_on_user_id"
  add_index "quiz_scores", ["video_id"], :name => "index_quiz_scores_on_video_id"

  create_table "quizzes", :force => true do |t|
    t.integer  "component_id"
    t.integer  "flags_count",   :default => 0
    t.integer  "avg_score"
    t.integer  "num_questions", :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "quizzes", ["component_id"], :name => "index_quizzes_on_component_id"

  create_table "sections", :force => true do |t|
    t.integer  "course_id"
    t.string   "name"
    t.integer  "priority"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sections", ["course_id"], :name => "index_sections_on_course_id"

  create_table "users", :force => true do |t|
    t.string   "full_name"
    t.integer  "points",                 :default => 0
    t.integer  "avg_quiz_score"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "username",               :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.text     "description"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "video_ratings", :force => true do |t|
    t.integer  "video_id"
    t.integer  "rater_id"
    t.integer  "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "video_ratings", ["rater_id"], :name => "index_video_ratings_on_rater_id"
  add_index "video_ratings", ["video_id", "rater_id"], :name => "index_video_ratings_on_video_id_and_rater_id"
  add_index "video_ratings", ["video_id"], :name => "index_video_ratings_on_video_id"

  create_table "video_views", :force => true do |t|
    t.integer  "viewer_id"
    t.integer  "video_id"
    t.boolean  "finished"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "video_views", ["video_id", "viewer_id"], :name => "index_video_views_on_video_id_and_viewer_id"
  add_index "video_views", ["video_id"], :name => "index_video_views_on_video_id"
  add_index "video_views", ["viewer_id"], :name => "index_video_views_on_viewer_id"

  create_table "videos", :force => true do |t|
    t.integer  "component_id"
    t.integer  "creator_id"
    t.integer  "flags_count"
    t.string   "kind"
    t.integer  "duration"
    t.integer  "avg_rating",     :default => 3
    t.integer  "avg_quiz_score"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "visible",        :default => true
    t.string   "embed_url"
    t.boolean  "ready",          :default => false
  end

  add_index "videos", ["component_id"], :name => "index_videos_on_component_id"
  add_index "videos", ["creator_id"], :name => "index_videos_on_creator_id"
  add_index "videos", ["embed_url"], :name => "index_videos_on_embed_url"

end

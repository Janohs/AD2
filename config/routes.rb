# config/routes.rb
Rails.application.routes.draw do
  get "teachers/index", to: "teacher_sessions#index", as: :teacher_login
  post "teachers/index", to: "teacher_sessions#create"
  delete "teacher/logout", to: "teacher_sessions#destroy", as: :teacher_logout
  get "teachers/:id/dashboard", to: "teachers#dashboard", as: :teacher_dashboard
  get "teachers/:id/exam_report", to: "teachers#exam_report", as: :teacher_exam_report
  get "teachers/:id/merit_demerit", to: "teachers#merit_demerit", as: :teacher_merit_demerit

  resources :teachers do
    patch :update_grades, on: :member
    patch "add_student_to_subject/:subject_id", to: "teachers#add_student_to_subject", as: "add_student_to_subject"
    member do
      post "add_merit", to: "teachers#add_merit", as: "add_merit"
    end
  end

  # ...existing code...

  get "teachers/index"
  get "admins/index", to: "admin_sessions#index", as: :admin_login
  post "admins/index", to: "admin_sessions#create"
  delete "admin/logout", to: "admin_sessions#destroy", as: :admin_logout
  get "admins/:id/dashboard", to: "admins#dashboard", as: :admin_dashboard

  # devise_for :users
  # Other routes...

  get "students/:id/dashboard", to: "students#dashboard", as: "student_dashboard"
  get "students/:id/canteen", to: "students#canteen", as: "student_canteen"


  # Login and logout routes
  get "login", to: "sessions#new", as: :login
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: :logout

  # Sign-up routes
  get "signup", to: "users#new", as: :signup
  post "signup", to: "users#create"

  # Root path points to the welcome page (Home page for non-logged-in users)
  root "pages#welcome"

  # Redirect dashboard/index to dashboard for cleaner URL
  get "dashboard/index", to: redirect("/dashboard")

  # Merit Dimerit routes
  get "merit", to: "merit#index", as: :merit

  # Student routes
  resources :students do
    member do
      get "dashboard"
      get "canteen", to: "students#canteen", as: :canteen
      get "profile", to: "students#profile", as: :profile
      get "merit", to: "students#merit", as: :merit
      get "exam", to: "students#exam", as: :exam
      post "add_merit", to: "students#add_merit", as: :add_merit

      get "download_exam_report", to: "students#download_exam_report", as: :download_exam_report
    end
    collection do
      get "search"
    end
  end
end

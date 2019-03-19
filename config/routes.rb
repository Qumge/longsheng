# == Route Map
#
#                   Prefix Verb   URI Pattern                            Controller#Action
#              rails_admin        /admin                                 RailsAdmin::Engine
#         new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
#             user_session POST   /users/sign_in(.:format)               devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)              devise/sessions#destroy
#            user_password POST   /users/password(.:format)              devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)          devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)         devise/passwords#edit
#                          PATCH  /users/password(.:format)              devise/passwords#update
#                          PUT    /users/password(.:format)              devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)                devise/registrations#cancel
#        user_registration POST   /users(.:format)                       devise/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)               devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)                  devise/registrations#edit
#                          PATCH  /users(.:format)                       devise/registrations#update
#                          PUT    /users(.:format)                       devise/registrations#update
#                          DELETE /users(.:format)                       devise/registrations#destroy
#                     root GET    /                                      projects#index
#     edit_control_project GET    /projects/:id/edit_control(.:format)   projects#edit_control
#   update_control_project GET    /projects/:id/update_control(.:format) projects#update_control
#                 projects GET    /projects(.:format)                    projects#index
#                          POST   /projects(.:format)                    projects#create
#              new_project GET    /projects/new(.:format)                projects#new
#             edit_project GET    /projects/:id/edit(.:format)           projects#edit
#                  project GET    /projects/:id(.:format)                projects#show
#                          PATCH  /projects/:id(.:format)                projects#update
#                          PUT    /projects/:id(.:format)                projects#update
#                          DELETE /projects/:id(.:format)                projects#destroy
#                contracts GET    /contracts(.:format)                   contracts#index
#                          POST   /contracts(.:format)                   contracts#create
#             new_contract GET    /contracts/new(.:format)               contracts#new
#            edit_contract GET    /contracts/:id/edit(.:format)          contracts#edit
#                 contract GET    /contracts/:id(.:format)               contracts#show
#                          PATCH  /contracts/:id(.:format)               contracts#update
#                          PUT    /contracts/:id(.:format)               contracts#update
#                          DELETE /contracts/:id(.:format)               contracts#destroy
#                          GET    /:controller(/:action(/:id))(.:format) :controller#:action
# 
# Routes for RailsAdmin::Engine:
#   dashboard GET         /                                      rails_admin/main#dashboard
#       index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#         new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#      export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
# bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
#    nestable GET|POST    /:model_name/nestable(.:format)        rails_admin/main#nestable
# bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#        show GET         /:model_name/:id(.:format)             rails_admin/main#show
#        edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#      delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
# show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app

Rails.application.routes.draw do

  get 'git/status'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root 'projects#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  #
  resources :projects do
    member do
      post :update_agency
      post :upload
      get :edit_information
      patch :update_information
      post :delete_attachment
      post :payment
      post :step_event
      get :show_money
      get :agent
      get :sales
      get :report
      get :order_import
      post :do_import
      resources :reports
      resources :orders do
        collection do
          post :place_order
          post :apply_order
        end
      end
      resources :invoices do
        collection do
          post :invoice_apply
        end
      end
    end
  end

  resources :contracts do
    member do
      resources :sales do
        collection do
          get :sale_import
          post :do_import
        end
      end
    end
  end

  resources :products do
    member do
      get :contract_sales
    end
    collection do
      get :import
      post :do_import
    end
  end

  resources :audits do
    collection do
      get :orders
      get :projects
      get :bargains
      get :agents
      get :audits
      get :invoices
    end

    member do
      get :success
      get :failed_notice
      post :failed
      get :invoice_success
      get :invoice_sended
    end
  end

  resources :manage_orders do
    collection do
      post :deliver
    end
    member do
      get :edit_payment
      patch :update_payment
      get :deliver_message
      post :send_message
      get :payment_logs
      get :edit_deliver
      patch :update_deliver
      get :deliver_logs
    end
  end

  resources :manage_invoices do
    collection do
      post :upload_file
    end
  end

  resources :agents
  resources :costs
  resources :trains
  resources :competitors
  resources :notices do
    collection do
      post :check
    end
  end

  resources :record_reports do
    collection do
      get 'orders'
      get 'projects'
      get 'users'
      get 'costs'
      get 'products'
      get 'invoices'
    end
  end

  resources :attachments
  resources :dynamic_reports do
    collection do
      get :payment
      get :deliver
      get :applied
    end
  end

  # match ':controller(/:action(/:id))', :via => :get
  mount ChinaCity::Engine => '/china_city'

end

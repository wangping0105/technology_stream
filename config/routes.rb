TechnologyStream::Application.routes.draw do

  get "tips/index"
  root to:'posts#index'
  resources :tips
  resources :nodes do
    collection do
      get :create_section
    end
    member do
      get :node_list,:create_node,:destroy_section,:destroy_node
    end
  end
  resources :clients do
    collection do
      get :my_posts,:my_collections,:my_diaries,:client_info,:search_citties,:top_100_members
    end
  end
  resources :messages do
    collection do
      get :show_messages,:show_messages_page,:empting_messages
    end
  end
  resources :posts do
    collection do
      get :all_index,:no_reply,:popular,:last_created
      post :search_posts
    end
    member do
      post :create_reply,:create_reply_again
      get :show_last,:collection_post,:dis_collection_post,:praise_post,
        :dis_praise_post,:attention_post,:dis_attention_post,:dis_collection_post_in_user_info,
        :diff_categories_post
    end
  end
  resources :sessions
  resources :users do
    collection do
      get :destroy_user
      post :update_avatar,:upload_avatar,:change_pwd
    end
    member do
      get :freeze_user
    end
  end
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
end

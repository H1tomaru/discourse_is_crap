namespace :admin, constraints: StaffConstraint.new do
  get 'snack' => 'snack#index'
end

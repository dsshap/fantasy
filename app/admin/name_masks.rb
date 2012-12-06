ActiveAdmin.register NameMask do

  index do
    column :name
    column :type
    default_actions
  end

  form do |f|
    f.inputs "Name Mask" do
      f.input :name
      f.input :type, as: :select, collection: %w[player team]
    end
    f.buttons
  end

end

class SnippetFormScreen < PM::FormScreen
  title "What's your snippet?"

  def form_data
    [{
      title: "Snippet",
      footer: "Enter your information here",
      cells: [{
             name: :submit,
             title: "Save",
             type: :button,
             action: "save_action:"
              },
              {
                name: "doing",
                title: "What'cha doing",
                type: :longtext
              }]
    },
    {
        title: "Old Snippets",
        cells: old_snippets
     }
    ]
  end

  def old_snippets
    Snippet.sort_by(:created_at).limit(10).map do |snippet|
      { title: snippet.details }
    end
  end

  def save_action(cell)
    foo = render_form
    Snippet.create(details: foo[:doing])
    cdq.save
    update_form_data
  end
end

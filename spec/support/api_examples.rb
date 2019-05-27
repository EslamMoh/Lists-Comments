shared_context 'API Context' do
  render_views

  before do
    request.headers['HTTP_ACCEPT'] = 'application/json'
    request.headers['Content-Type'] = 'application/json'
  end
end

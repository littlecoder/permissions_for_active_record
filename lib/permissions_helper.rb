def view_for active_record
  vp = ViewProxy.new(active_record)
  yield vp
end
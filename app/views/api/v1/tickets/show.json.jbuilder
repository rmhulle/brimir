json.id @ticket.id
json.subject @ticket.subject
json.date time_ago_in_words(@ticket.created_at.in_time_zone(current_user.time_zone))
json.content @ticket.content
json.assignee @ticket.assignee.email
json.status @ticket.status
json.priority @ticket.priority
json.latitude @ticket.lat
json.longitude @ticket.long
json.address @ticket.raw_address
json.labels @ticket.labelings.each do |labeling|
  json.name labeling.label.name
end


json.replies @ticket.replies do |reply|
  json.id reply.id
  json.content reply.content
  json.date time_ago_in_words(reply.created_at.in_time_zone(current_user.time_zone))
  json.from reply.user.email
end

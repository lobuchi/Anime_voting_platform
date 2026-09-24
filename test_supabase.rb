require "aws-sdk-s3"

client = Aws::S3::Client.new(
  access_key_id: ENV["SUPABASE_ACCESS_KEY_ID"],
  secret_access_key: ENV["SUPABASE_SECRET_ACCESS_KEY"],
  region: ENV["SUPABASE_REGION"],
  endpoint: ENV["SUPABASE_ENDPOINT"],
  force_path_style: true,
  request_checksum_calculation: "when_required",
  response_checksum_validation: "when_required"
)

puts "== Buckets =="
client.list_buckets.buckets.each { |b| puts "  #{b.name}" }

puts "\n== Uploading test file =="
client.put_object(
  bucket: ENV["SUPABASE_BUCKET"],
  key: "test/test-#{Time.now.to_i}.txt",
  body: "hello supabase",
  content_type: "text/plain"
)
puts "✅ Upload succeeded!"

puts "\n== Listing objects =="
client.list_objects_v2(bucket: ENV["SUPABASE_BUCKET"]).contents.each do |o|
  puts "  #{o.key} (#{o.size} bytes)"
end

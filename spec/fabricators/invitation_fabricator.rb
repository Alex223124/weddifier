Fabricator(:invitation) do
  token { SecureRandom.urlsafe_base64 }
  guest
end

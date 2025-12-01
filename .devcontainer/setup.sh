#!/bin/bash
# Adyen Rails Online Payments - Codespaces Setup Script
set -euo pipefail

echo "Setting up Adyen Rails Online Payments..."

# Install Ruby dependencies
echo "Installing Ruby dependencies..."
bundle install

# The project uses 'sqlite3' so we need to create and migrate the database
echo "Setting up the database..."
bundle exec rails db:create
bundle exec rails db:migrate

echo ""
echo "Setup complete!"
echo ""
echo "Before running the server, set the following environment variables by exporting them in the terminal:"
echo "   - ADYEN_API_KEY          (https://docs.adyen.com/user-management/how-to-get-the-api-key)"
echo "   - ADYEN_CLIENT_KEY       (https://docs.adyen.com/user-management/client-side-authentication)"
echo "   - ADYEN_MERCHANT_ACCOUNT       (https://docs.adyen.com/account/account-structure)"
echo "   - ADYEN_HMAC_KEY         (https://docs.adyen.com/development-resources/webhooks/verify-hmac-signatures)"
echo ""
echo "Then run: rails s"
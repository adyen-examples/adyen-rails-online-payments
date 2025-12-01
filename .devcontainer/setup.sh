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
echo "Before running the server, configure your Adyen credentials:"
echo ""
echo "Option 1: Update config/local_env.yml with your credentials:"
echo "   - ADYEN_API_KEY          (https://docs.adyen.com/user-management/how-to-get-the-api-key)"
echo "   - ADYEN_CLIENT_KEY       (https://docs.adyen.com/user-management/client-side-authentication)"
echo "   - ADYEN_MERCHANT_ACCOUNT (https://docs.adyen.com/account/account-structure)"
echo "   - ADYEN_HMAC_KEY         (https://docs.adyen.com/development-resources/webhooks/verify-hmac-signatures)"
echo ""
echo "Option 2: Set environment variables in your terminal:"
echo "   export ADYEN_API_KEY='your_api_key'"
echo "   export ADYEN_CLIENT_KEY='your_client_key'"
echo "   export ADYEN_MERCHANT_ACCOUNT='your_merchant_account'"
echo "   export ADYEN_HMAC_KEY='your_hmac_key'"
echo ""
echo "Then run: bundle exec rails s"
echo ""
echo "The server will start on port 8080 (configured in config/local_env.yml)"
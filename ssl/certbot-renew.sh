#!/bin/bash
# Certbot SSL certificate renewal script
# This is run automatically by the certbot systemd timer or cron job
# Manually trigger with: sudo certbot renew

set -e

echo "Renewing SSL certificates..."
certbot renew --quiet --nginx

echo "Reloading Nginx..."
systemctl reload nginx

echo "Done."

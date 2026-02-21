# VPS Nginx Configuration

Host-level Nginx reverse proxy configuration for the VPS at `72.62.73.125`.

This repo manages routing for all apps hosted on this VPS. Each app runs in its own Docker network and exposes ports to the host. Nginx routes incoming domain traffic to the correct app.

## Architecture

```
Internet → VPS (port 80/443)
         → Host Nginx
           → rentcampro.ofoundation.xyz → Docker (localhost:3000 / localhost:8000)
           → ofoundation.xyz            → placeholder / other app
```

## Apps

| Domain | Frontend Port | Backend Port | Repo |
|--------|--------------|--------------|------|
| rentcampro.ofoundation.xyz | 3000 | 8000 | Camerarentalwebsite |

## Setup on a New VPS

### 1. Install Nginx

```bash
sudo apt update
sudo apt install nginx
```

### 2. Install Certbot

```bash
sudo apt install certbot python3-certbot-nginx
```

### 3. Deploy site configs

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/vps-nginx-config.git ~/vps-nginx-config

# Copy site configs
sudo cp ~/vps-nginx-config/sites-available/* /etc/nginx/sites-available/

# Enable sites
sudo ln -s /etc/nginx/sites-available/rentcampro.ofoundation.xyz /etc/nginx/sites-enabled/
sudo ln -s /etc/nginx/sites-available/ofoundation.xyz /etc/nginx/sites-enabled/

# Remove default site
sudo rm -f /etc/nginx/sites-enabled/default

# Test config
sudo nginx -t

# Reload
sudo systemctl reload nginx
```

### 4. Obtain SSL certificates

```bash
sudo certbot --nginx -d rentcampro.ofoundation.xyz
```

Certbot will automatically edit the site config to add SSL and set up auto-renewal.

### 5. Verify auto-renewal

```bash
sudo certbot renew --dry-run
```

## Adding a New App

1. Add its Docker Compose service to expose ports on the host (e.g. `4000:3000`, `9000:8000`)
2. Create a new site config in `sites-available/` following the same pattern
3. Symlink it to `sites-enabled/`
4. Run `certbot --nginx -d yourdomain.com`
5. Reload Nginx

## Switching RentCamPro to a Real Domain

When `rentcampro.com` is purchased:

1. Point DNS A record to `72.62.73.125`
2. Copy `sites-available/rentcampro.ofoundation.xyz` to `sites-available/rentcampro.com`
3. Update `server_name` to `rentcampro.com`
4. Run `certbot --nginx -d rentcampro.com`
5. Update GitHub secrets `NEXT_PUBLIC_API_URL` in the app repo
6. Remove old site config and symlink

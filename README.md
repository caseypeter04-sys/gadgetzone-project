# GadgetZone E-Commerce Project

## Architecture
- Web Server: Nginx on AWS EC2 (HTTPS enabled)
- Database Server: MariaDB on separate AWS EC2
- Firewall: UFW (ports 22,80,443 only)
- Load Testing: Apache Bench (500 concurrent users)

## Scripts
- `provision-web.sh` - Sets up web server with Nginx, HTTPS, UFW
- `provision-db.sh` - Sets up MariaDB database
- `load-test.sh` - Tests 500 concurrent users
- `security-test.sh` - Runs port scan and HTTPS checks

## Team
- Team Member A: Infrastructure + scripts
- Team Member B: Testing
- Team Member C: Documentation

## Lecturer Access
- s.f.pratama@herts.ac.uk (invited to GitHub + Trello)
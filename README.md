# E-Commerce API

A comprehensive RESTful API for e-commerce applications built with Django REST Framework. This backend framework is designed to support modern e-commerce operations with product management, user authentication, shopping cart functionality, and order processing capabilities.

## 🌟 Features (Planned)

- **User Management**
  - Authentication & Authorization
  - User profiles with shipping addresses
  - Role-based permissions

- **Product Management**
  - Product categories and subcategories
  - Product variants (size, color, etc.)
  - Product images and details
  - Inventory tracking

- **Shopping Experience**
  - Shopping cart functionality
  - Wishlists
  - Product reviews and ratings

- **Order Processing**
  - Order creation and tracking
  - Order status updates
  - Order history

- **Payment Integration**
  - payment methods
  - Secure payment processing


## 🚀 Getting Started

### Prerequisites

- Docker and Docker Compose
- Git

### Installation & Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ecommerce-api.git
   cd ecommerce-api
   ```

2. Set up environment variables:
   ```bash
   cp .env.development .env
   ```
   Edit the `.env` file with your specific configuration if needed.

3. Build and run the Docker containers:
   ```bash
   docker-compose up --build
   ```

4. The API will be available at:
   ```
   http://localhost:8000/api/v1/
   ```

5. Access the interactive API documentation:
   ```
   http://localhost:8000/api/docs/
   ```

6. Admin interface:
   ```
   http://localhost:8000/admin/
   Username: admin
   Password: admin
   ```

## 🧪 Development Environments

This project supports multiple environments:

- **Development**: `.env.development` - For local development with debugging tools
- **Staging**: `.env.staging` - For testing in a production-like environment
- **Production**: `.env.production` - For production deployment with security features

To specify the environment when starting the containers:

```bash
DJANGO_ENVIRONMENT=staging docker-compose up
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
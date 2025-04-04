"""
URL configuration for core project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

# تنظیمات نمای طرح‌واره برای مستندسازی API
schema_view = get_schema_view(
    openapi.Info(
        title="E-Commerce API",
        default_version='v1',
        description="API جامع برای برنامه فروشگاه آنلاین",
        terms_of_service="https://www.example.com/terms/",
        contact=openapi.Contact(email="a.jalilian66@gmail.com"),
        license=openapi.License(name="MIT License"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

# مسیرهای API
api_urlpatterns = [
    # برنامه‌های API خود را اینجا اضافه کنید
    # path('accounts/', include('accounts.urls')),
    # path('products/', include('products.urls')),
    # path('orders/', include('orders.urls')),
    # path('cart/', include('cart.urls')),
    # path('payment/', include('payment.urls')),
]

# مسیرهای اصلی
urlpatterns = [
    # پنل ادمین
    path('admin/', admin.site.urls),

    # مسیرهای API
    path('api/v1/', include(api_urlpatterns)),

    # API بررسی سلامت
    path('health/', include('health_check.urls')),

    # مستندسازی Swagger/OpenAPI
    path('api/docs/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('api/redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
]

# اضافه کردن مسیرهای دیباگ در محیط توسعه
if settings.DEBUG:
    # نوار دیباگ
    import debug_toolbar

    urlpatterns += [path('__debug__/', include(debug_toolbar.urls))]

    # سرو فایل‌های رسانه‌ای در محیط توسعه
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

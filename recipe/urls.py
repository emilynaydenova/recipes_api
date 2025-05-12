"""
URL mappings for the recipe app.
"""
from django.urls import  path, include

from rest_framework.routers import DefaultRouter

from recipe import views

"""
When using ViewSet, a router automatically generates the standard RESTful
endpoints (list, create, retrieve, update, delete) without writing them
manually.
"""
router = DefaultRouter()
router.register('recipes', views.RecipeViewSet)
router.register('tags', views.TagViewSet)
router.register('ingredients', views.IngredientViewSet)

# used for reverse url
app_name = 'recipe'

urlpatterns = [
    path('', include(router.urls)),
]
"""

Each register() method maps a resource (e.g., recipes, tags, ingredients)
 to a ViewSet, automatically creating the standard CRUD endpoints:

GET /recipes or tags or ingredients/ → List 

POST  /recipes or tags or ingredients/ → Create  

GET  /recipes or tags or ingredients/{id}/ → Retrieve  

PUT  /recipes or tags or ingredients/{id}/ → Update 

DELETE  /recipes or tags or ingredients/{id}/ → Delete 


DRF’s DefaultRouter assigns default names in the format:
<app_name>:<basename>-list (for listing)
<app_name>:<basename>-detail (for a single item)

Your app_name = 'recipe' applies as a namespace.

You can use reverse() to get the URL dynamically.
The names are:
	Name (app_name = 'recipe' applied)
GET	/recipes/	recipe:recipe-list
POST	/recipes/	recipe:recipe-list
GET	/recipes/{id}/	recipe:recipe-detail
PUT	/recipes/{id}/	recipe:recipe-detail
PATCH	/recipes/{id}/	recipe:recipe-detail
DELETE	/recipes/{id}/	recipe:recipe-detail

# Get the URL for listing all recipes
recipe_list_url = reverse('recipe:recipe-list')
# Get the URL for a specific recipe with id=1
recipe_detail_url = reverse('recipe:recipe-detail', args=[1])
"""
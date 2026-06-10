from src.client import openapi_client
from src.client.openapi_client.rest import ApiException

from src.client.openapi_client.models.pet import Pet

# Defining the host is optional and defaults to https://petstore3.swagger.io/api/v3
# See configuration.py for a list of all supported configuration parameters.
configuration = openapi_client.Configuration(
    host = "http://127.0.0.1:8000"
)

def test_root():
    # Enter a context with an instance of the API client
    with openapi_client.ApiClient(configuration) as api_client:
        # Create an instance of the API class
        api_instance = openapi_client.DefaultApi(api_client)

        # hello world
        api_response = api_instance.root_get()
        assert api_response.message == "fastapi running"


def test_add_pet():
    params = {'name': 'foo'}
    Pet.model_validate(params)
    with openapi_client.ApiClient(configuration) as api_client:
        api_instance = openapi_client.PetApi(api_client)
        # curl --header "Content-Type: application/json" --request POST --data '{"name":"emu"}' http://localhost:8000/pet
        api_response = api_instance.add_pet(params)
        assert api_response.name == "foo"

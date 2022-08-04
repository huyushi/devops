from django.http.response import JsonResponse


def login(request):
    return JsonResponse({
        "code": 200,
        "message": "v6 version"
    })

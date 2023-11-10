from django.db import models

# Create your models here.


class Post(models.Model):
    id = models.BigAutoField(primary_key=True)
    title = models.TextField()

    class Meta:
        db_table = 'posts'

# Generated by Django 4.1 on 2022-08-17 14:36

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('police', '0006_alter_movie_digits_alter_theater_digits'),
    ]

    operations = [
        migrations.AlterField(
            model_name='movie',
            name='digits',
            field=models.PositiveSmallIntegerField(),
        ),
        migrations.AlterField(
            model_name='theater',
            name='digits',
            field=models.PositiveSmallIntegerField(),
        ),
    ]

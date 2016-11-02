all: env server

env: env/bin/activate
env/bin/activate: py-requirements/dev.txt
	test -d env || virtualenv env
	env/bin/pip install -U pip setuptools
	env/bin/pip install -r py-requirements/dev.txt
	touch env/bin/activate

server:
	# Activate virtualenv in the make shell
	( \
		. env/bin/activate; \
		honcho start -f Procfile.dev; \
	)

migrate:
	( \
		. env/bin/activate; \
		python src/manage.py migrate; \
		python src/manage.py loaddata fixtures.json; \
	)

# Drop DB, then migrate and seed
reload:
	( \
		. env/bin/activate; \
		cd src && ./reload_db.sh; \
	)

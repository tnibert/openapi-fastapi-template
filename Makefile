server_dir = src/server
client_dir = src/client
src_dir = src

servergen:
	mkdir -p $(server_dir)
	# cp $(server_dir)/main.py main.py.bak || true
	# cp $(src_dir)/main.py main.py.bak || true
	fastapi-codegen --input openapi.yaml --output $(server_dir)/ --output-model-type pydantic_v2.BaseModel
	sed -i 's/from ./from /g' $(server_dir)/main.py
	sed -i 's/from typing import List, Optional/from typing import List, Optional, Dict/g' $(server_dir)/main.py
	sed -i 's/from yping/from typing/g' $(server_dir)/main.py
	sed -i 's/from astapi/from fastapi/g' $(server_dir)/main.py
	sed -i 's/from _future__/from __future__/g' $(server_dir)/main.py
	sed -i 's/from models/from server.models/g' $(server_dir)/main.py
	# mv $(server_dir)/main.py $(src_dir)
	# todo: contract first with templates
	# docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate -i /local/openapi.yaml -g python-fastapi -o /local/server -t

clientgen:
	mkdir -p $(client_dir)
	docker run --rm -u "$$(id -u):$$(id -g)" -v ${PWD}:/local openapitools/openapi-generator-cli generate -i /local/openapi.yaml -g python -o /local/$(client_dir)

code: servergen clientgen

run:
	cd $(src_dir) && uvicorn main:app --reload

venv:
	python -m venv venv && source venv/bin/activate && pip install -r requirements.txt

clean:
	$(RM) -rf $(server_dir) $(client_dir)

test:
	pytest -s

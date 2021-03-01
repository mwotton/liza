
all: depcheck haskell

haskell: liza/src/Schema.hs
	stack build --test --bench --no-run-tests --no-run-benchmarks

hlint:
	hlint .

DBDEPS=$(wildcard verify/* deploy/* revert/*)

.PHONY: schema
schema: liza/src/Schema.hs

liza/src/Schema.hs: $(DBDEPS)
	bash ./scripts/gen_schema.sh

mainwatch:
	ghcid -T :main -c 'stack repl liza:lib liza:exe:server' --restart="liza/package.yaml" --restart="stack.yaml" --restart=verify $(foreach file, $(DBDEPS), "--restart=$(file)")

testwatch:
	ghcid -T :main -c 'stack repl liza:lib liza:test:liza-test' --restart="liza/package.yaml" --restart="stack.yaml" --restart=verify $(foreach file, $(DBDEPS), "--restart=$(file)")

.PHONY: depcheck
depcheck: ormolu sqitch squealgen

.PHONY: sqitch
sqitch:
	bash -c "sqitch --help >& /dev/null || echo 'download sqitch first'"

.PHONY: squealgen
squealgen:
	bash -c "squealgen >& /dev/null || echo 'download squealgen first'"

.PHONY: ormolu
ormolu:
	bash -c "ormolu >& /dev/null || echo 'download ormolu first'"
.PHONY: herokudeploy
herokudeploy:
	heroku container:push --recursive && heroku container:release migration web
.PHONY: hpsql
hpsql:
	heroku run "psql $${DATABASE_URL}" --type=migration
#docker-build:
#	@stack build
#	@BINARY_PATH=${BINARY_PATH_RELATIVE} docker-compose build

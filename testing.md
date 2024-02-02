To run the unit tests install [commandbox](https://www.ortussolutions.com/products/commandbox).

Then open the `box` command and `cd` to this directory.

Then run the following:
```shell
package install
server start server start serverconfigfile=server-sqids-coldfusion-lucee5.json
testbox run http://localhost:60850/tests/runner
```

<img src="/logo/iron.png" width="300" alt="iron logo">

## Go - Iron Bank Network

Official golang implementation of the IRON protocol, based in Ethereum.

Binaries are published at https://github.com/iron-bank/go-IRON/releases.

Author/Developer: Alber Erre

## First Steps
Before accessing the Dapp, you need to compile and start the iron protocol, in order to get access to the blockchain and interact with the functionalities.

## Building the source

For prerequisites and detailed build instructions please stick to the official Go-Ethereum
[Installation Instructions](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum).

Building iron requires both a Go (version 1.7 or later) and a C compiler. So you may need to install Go if you don't have Golang in your system.
You can install them using your favourite package manager (`brew` is a good option for MacOS).
Once the dependencies are installed, run

    git clone https://github.com/iron-bank/go-IRON.git
    cd go-IRON
    make all
        
After it is successfully compiled, copy it so user can access it from any location of the machine (MacOS).
    
    sudo cp build/bin/iron /usr/local/bin
    
In case this doesn't work, just copy and paste the entire path to the iron instance and run this command:

    sudo cp <entire-path-to-iron-instance-in-your-system> /usr/local/bin

## Running iron

First, you need to sync and connect to the main blockchain via `--bootnodes` to interact with the Iron Bank Network. Regarding functionality, going through all the possible command line flags is out of scope here (please consult the compatible Go-Ethereum
[CLI Wiki page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options)), but we've
enumerated a few common parameter combos to get you up to speed quickly on how you can run your
own iron instance.

### Sync Iron Bank Network

As a single node you are not yet part of the iron Bank Network. You need to sync with the rest of the blockchain to use its functionalities and interact with other peers while using the Dapp. In order to do that, just run the following command:

```
$ iron --bootnodes enode://3fe6b310f828d4b0273f62588dd77ddb0e9022a0381fcb651bf3a5ec0bb9e3ae2faeec1cd2c0971b873d47ed4f50fa4cb97f962d4054a324edd57f7cc6c856ce@[192.168.1.33]:30303
```

This is just one of the official iron nodes that the team provides. You may just use one of these or connect to a peer you know beforehand. Just need an `enode` to sync and connect to the blockchain via the `--bootnodes` flag, following this structure:

```
$ iron --bootnodes <bootnode-enode-parameters>
```

#### Official iron enode list:
```
enode://3fe6b310f828d4b0273f62588dd77ddb0e9022a0381fcb651bf3a5ec0bb9e3ae2faeec1cd2c0971b873d47ed4f50fa4cb97f962d4054a324edd57f7cc6c856ce@[192.168.1.33]:30303
```

### Full node on the main Iron Bank Network

By far the most common scenario is people wanting to simply interact with the Iron Bank Network:
create accounts; transfer funds; deploy and interact with contracts. For this particular use-case
the user doesn't care about years-old historical data, so we can fast-sync quickly to the current
state of the network. To do so:

```
$ iron --fast --cache=1024 console
```

This command will:

 * Start iron in fast sync mode (`--fast`), causing it to download more data in exchange for avoiding
   processing the entire history of the Iron Bank Network, which is very CPU intensive.
 * Bump the memory allowance of the database to 1024MB (`--cache=1024`) or 512MB (`--cache=512`), which can help significantly in sync times especially for HDD users. This flag is optional and you can set it as high or as low as
   you'd like. 
   You also may use `$ iron --fast --cache=512 console` , in case you don't have enough memory.
   
 * Start up iron's built-in interactive [JavaScript console](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console),
   (via the trailing `console` subcommand) through which you can invoke all official [`web3` methods](https://github.com/ethereum/wiki/wiki/JavaScript-API)
   as well as iron's own [management APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs).
   This too is optional and if you leave it out you can always attach to an already running iron instance
   with `iron attach`.

#### Creating your first Address

Once you are in the javaScript console, you may interact with the blockchain and create a new address (remember you need to sync with the network first). Just type the following command:

```
> personal.newAccount()
```

The console will ask you for a password for this account twice (keep it safe!). Then, your address will show up, congratualtions!!!

In order to see all your accounts just type the following command inside the javaScript console:

```
> personal.listAccounts
```

#### Unlock your Account to interact

If a red error box appears while you try to interact with the blockchain saying you need to unlock your account. You need to do so by typing the following command in the javaScript console of your running iron node.

```
> personal.unlockAccount("<your-account-address>")
```

This will allow you to interact with the blockchain for a few minutes. This is a safety measure to avoid others stealing your funds. Alternatively, you can run the command `--unlock <your-account-address>` while starting your node to unlock your accounts instantly. e.g:
```
$ iron --fast --cache=1024 --unlock <your-account-address> console
```

## Executables

The Go-IRON project comes with several wrappers/executables found in the `cmd` directory.

| Command    | Description |
|:----------:|-------------|
| **`iron`** | Our main iron CLI client. It is the entry point into the iron network (main-, test- or private net), capable of running as a full node (default) archive node (retaining all historical state) or a light node (retrieving data live). It can be used by other processes as a gateway into the Iron Bank Network via JSON RPC endpoints exposed on top of HTTP, WebSocket and/or IPC transports. Check `iron --help` and the official Go-Ethereum [CLI Wiki page](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) for command line options. |
| `abigen` | Source code generator to convert Ethereum contract definitions into easy to use, compile-time type-safe Go packages. It operates on plain [Ethereum contract ABIs](https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI) with expanded functionality if the contract bytecode is also available. However it also accepts Solidity source files, making development much more streamlined. Please see the official Go-Ethereum [Native DApps](https://github.com/ethereum/go-ethereum/wiki/Native-DApps:-Go-bindings-to-Ethereum-contracts) wiki page for details. |
| `bootnode` | Stripped down version of the iron client implementation that only takes part in the network node discovery protocol, but does not run any of the higher level application protocols. It can be used as a lightweight bootstrap node to aid in finding peers in private networks. |
| `evm` | Developer utility version of the EVM (Ethereum Virtual Machine) that is capable of running bytecode snippets within a configurable environment and execution mode. Its purpose is to allow isolated, fine-grained debugging of EVM opcodes (e.g. `evm --code 60ff60ff --debug`). |
| `gmcrpctest` | Developer utility tool to support the [ethereum/rpc-test](https://github.com/ethereum/rpc-tests) test suite which validates baseline conformity to the [Ethereum JSON RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC) specs. Please see the [test suite's readme](https://github.com/ethereum/rpc-tests/blob/master/README.md) for details. |
| `rlpdump` | Developer utility tool to convert binary RLP ([Recursive Length Prefix](https://github.com/ethereum/wiki/wiki/RLP)) dumps (data encoding used by the Ethereum-based iron protocol both network as well as consensus wise) to user friendlier hierarchical representation (e.g. `rlpdump --hex CE0183FFFFFFC4C304050583616263`). |
| `swarm`    | swarm daemon and tools. This is the entrypoint for the swarm network. `swarm --help` for command line options and subcommands. See https://swarm-guide.readthedocs.io for swarm documentation. |
| `puppeth`    | a CLI wizard that aids in creating a new Ethereum-based network. |

### Configuration

As an alternative to passing the numerous flags to the `iron` binary, you can also pass a configuration file via:

```
$ iron --config /path/to/your_config.toml
```

To get an idea how the file should look like you can use the `dumpconfig` subcommand to export your existing configuration:

```
$ iron --your-favourite-flags dumpconfig
```

*Note: This works only with iron v2.1.0 and above.*

#### Docker quick start

One of the quickest ways to get iron up and running on your machine is by using Docker:

```
docker run -d --name iron-node -v /Users/alice/iron:/root \
           -p 8545:8545 -p 30303:30303 \
           iron/client-go --fast --cache=512
```

This will start iron in fast sync mode with a DB memory allowance of 512MB just as the above command does.  It will also create a persistent volume in your home directory for saving your blockchain as well as map the default ports. There is also an `alpine` tag available for a slim version of the image.

### Programatically interfacing iron nodes

As a developer, sooner rather than later you'll want to start interacting with iron and the iron
network via your own programs and not manually through the console. To aid this, iron has built in
support for a JSON-RPC based APIs ([standard APIs](https://github.com/ethereum/wiki/wiki/JSON-RPC) and
[iron specific APIs](https://github.com/ethereum/go-ethereum/wiki/Management-APIs)). These can be
exposed via HTTP, WebSockets and IPC (unix sockets on unix based platforms, and named pipes on Windows).

The IPC interface is enabled by default and exposes all the APIs supported by iron, whereas the HTTP
and WS interfaces need to manually be enabled and only expose a subset of APIs due to security reasons.
These can be turned on/off and configured as you'd expect.

HTTP based JSON-RPC API options:

  * `--rpc` Enable the HTTP-RPC server
  * `--rpcaddr` HTTP-RPC server listening interface (default: "localhost")
  * `--rpcport` HTTP-RPC server listening port (default: 8545)
  * `--rpcapi` API's offered over the HTTP-RPC interface (default: "eth,net,web3")
  * `--rpccorsdomain` Comma separated list of domains from which to accept cross origin requests (browser enforced)
  * `--ws` Enable the WS-RPC server
  * `--wsaddr` WS-RPC server listening interface (default: "localhost")
  * `--wsport` WS-RPC server listening port (default: 8546)
  * `--wsapi` API's offered over the WS-RPC interface (default: "eth,net,web3")
  * `--wsorigins` Origins from which to accept websockets requests
  * `--ipcdisable` Disable the IPC-RPC server
  * `--ipcapi` API's offered over the IPC-RPC interface (default: "admin,debug,eth,miner,net,personal,shh,txpool,web3")
  * `--ipcpath` Filename for IPC socket/pipe within the datadir (explicit paths escape it)

You'll need to use your own programming environments' capabilities (libraries, tools, etc) to connect
via HTTP, WS or IPC to a iron node configured with the above flags and you'll need to speak [JSON-RPC](http://www.jsonrpc.org/specification)
on all transports. You can reuse the same connection for multiple requests!

**Note: Please understand the security implications of opening up an HTTP/WS based transport before
doing so! Hackers on the internet are actively trying to subvert iron nodes with exposed APIs!
Further, all browser tabs can access locally running webservers, so malicious webpages could try to
subvert locally available APIs!**

#### Creating the rendezvous point

With all nodes that you want to run initialized to the desired genesis state, you'll need to start a
bootstrap node that others can use to find each other in your network and/or over the internet. The
clean way is to configure and run a dedicated bootnode:

```
$ bootnode --genkey=boot.key
$ bootnode --nodekey=boot.key
```

With the bootnode online, it will display an [`enode` URL](https://github.com/ethereum/wiki/wiki/enode-url-format)
that other nodes can use to connect to it and exchange peer information. Make sure to replace the
displayed IP address information (most probably `[::]`) with your externally accessible IP to get the
actual `enode` URL.

*Note: You could also use a full fledged iron node as a bootnode, but it's the less recommended way.*

#### Running a private miner

Everyone is still capable of mining using a single CPU miner instance, this is more than enough for practical
purposes as it can produce a stable stream of blocks at the correct intervals without needing heavy
resources (consider running on a single thread, no need for multiple ones either). To start a iron
instance for mining, run it with all your usual flags, extended by:

```
$ iron <usual-flags> --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000000 (your address)
```

Which will start mining bocks and transactions on a single CPU thread, crediting all proceedings to
the account specified by `--etherbase`. You can further tune the mining by changing the default gas
limit blocks converge to (`--targetgaslimit`) and the price transactions are accepted at (`--gasprice`).

## Contribution

Thank you for considering to help out with the source code! We welcome contributions from
anyone on the internet, and are grateful for even the smallest of fixes!

If you'd like to contribute to go-IRON, please fork, fix, commit and send a pull request
for the maintainers to review and merge into the main code base. If you wish to submit more
complex changes though, please check up with the core devs
to ensure those changes are in line with the general philosophy of the project and/or get some
early feedback which can make both your efforts much lighter as well as our review and merge
procedures quick and simple.

Please make sure your contributions adhere to our coding guidelines:

 * Code must adhere to the official Go [formatting](https://golang.org/doc/effective_go.html#formatting) guidelines (i.e. uses [gofmt](https://golang.org/cmd/gofmt/)).
 * Code must be documented adhering to the official Go [commentary](https://golang.org/doc/effective_go.html#commentary) guidelines.
 * Pull requests need to be based on and opened against the `master` branch.
 * Commit messages should be prefixed with the package(s) they modify.
   * E.g. "eth, rpc: make trace configs optional"

Please see the Go-Ethereum [Developers' Guide](https://github.com/ethereum/go-ethereum/wiki/Developers'-Guide)
for more details on configuring your environment, managing project dependencies and testing procedures.

## License

Go-IRON is a fork of the [Go-Ethereum](https://github.com/ethereum/go-ethereum/) client and library.
The go-IRON library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html), also
included in our repository in the `COPYING.LESSER` file.
The go-IRON binaries (i.e. all code inside of the `cmd` directory) is licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also included
in our repository in the `COPYING` file.

## Compare string in tests

To compare two strings in a test, we cannot do straight '==' check, because 'strings' in solidity are 'array of bytes'.
Thus when we want to check if 2 strings are equal, we should 'abi.encode()' them and after generate a hash with encoded result.
ex.
```
string memory home = "home";
string memory house = "house";

bytes memory encodedHome = abi.encodePacked(home);
bytes memory encodedHouse = abi.encodePacked(house);

assert(keccak256(encodedHome) == keccak256(encodedHoude));
```

** NOTE:
we can test this conversions with the help of 'chisel' cli command, included in foundry.

## Mint token programmatically

Create an 'Interactions.s.sol' file and use in the 'run' function the most-recently-deploy-NFT.
To do so:
1. run 
```
forge install Cyfrin/foundry-devops --no-commit
```
2. import 'DevOpsTools' from that package

3. Delpoy the nft contract on a chain. Use the following command to deploy on sepolia testnet:
```
make deploy ARGS="--network sepolia"
```

4. Mint an NFT using:
```
make mint ARGS="--network sepolia"
```

5. To see the NFT in Metamask, import the contract address and the tokenId.


## NFT images hostings

1. <b>HTTPS</b> -> bad, because if the website goes down, nobody could see the image
2. <b>IPFS</b> -> better than HTTPS, as anyone could pin the hash and keep it online; If all the nodes that have the hash pinned go down, then it would be impossibile to see the image.
3. <b>PINATA</b> -> online service that serves as a IPFS node, where we can pin data we want to be reachable
4. SVG  host on chain -> (Scalar Vector Graphics)
    -> create a MoodNft contract that can change the NFT created from happy to sad, generating the token using either happy.svg or sad.svg
    - we can encrypt a json file representing our NFT directly on chain, using
        openzeppiln-base64 package
    - the constructor receives two imageURIs (differs from tokenURI, that is the json representation of the token) and in 'tokenURI()' we set the Mood 
        based on some logic


## MoodNFT Contract functionality

### Startup process
#### 1. clone the repository
#### 2. run
```
make install
```
to install necessary dependencies
#### 3. spin up anvil in a terminal
```
make anvil
```
#### 4. open up a new terminal deploy the MoodNft contract
```
make deployMood
```
#### 5. execute the mint operation to create the NFT
```
make mintMoodNft
```
Import the NFT in Metamask using:
- contract address
- token id
#### 6. execute the flip operation to change the NFT
```
make flipMoodNft
```
Re-import the NFT in Metamask using:
- contract address
- token id

![alt text](https://github.com/denisgulev/foundry-nft-f23-/blob/main/image.png)

#

The constructor will receive 2 imageURIs to use as options for the tokens that will be minted.

Mint process:
- _mint function will be called
- some logic will decide which images to encode on chain
- 'Base64' function from @openzeppelin will be used to encode a json object containing imageURI and additional token's information:
    1. create json object
    2. convert it to bytes
    3. encode this object using base64
    4. add a prefix
    5. encode the whole string (abi.encodePacked())




## Credits
Thanks to [CyfrinUpdraft](https://updraft.cyfrin.io) and [PatrickCollins](https://github.com/PatrickAlphaC) for the great tutorials.

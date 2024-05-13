1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 import "solmate/auth/Owned.sol";
5 
6 import "./lib/SafeERC20Namer.sol";
7 import "./Pair.sol";
8 
9 /// @title caviar.sh
10 /// @author out.eth (@outdoteth)
11 /// @notice An AMM for creating and trading fractionalized NFTs.
12 contract Caviar is Owned {
13     using SafeERC20Namer for address;
14 
15     event Create(address indexed nft, address indexed baseToken, bytes32 indexed merkleRoot);
16     event Destroy(address indexed nft, address indexed baseToken, bytes32 indexed merkleRoot);
17 
18     /// @dev pairs[nft][baseToken][merkleRoot] -> pair
19     mapping(address => mapping(address => mapping(bytes32 => address))) public pairs;
20 
21     constructor() Owned(msg.sender) {}
22 
23     /// @notice Creates a new pair.
24     /// @param nft The NFT contract address.
25     /// @param baseToken The base token contract address.
26     /// @param merkleRoot The merkle root for the valid tokenIds.
27     /// @return pair The address of the new pair.
28     function create(address nft, address baseToken, bytes32 merkleRoot) public returns (Pair pair) {
29         // check that the pair doesn't already exist
30         require(pairs[nft][baseToken][merkleRoot] == address(0), "Pair already exists");
31 
32         // deploy the pair
33         string memory baseTokenSymbol = baseToken == address(0) ? "ETH" : baseToken.tokenSymbol();
34         string memory nftSymbol = nft.tokenSymbol();
35         string memory nftName = nft.tokenName();
36         string memory pairSymbol = string.concat(nftSymbol, ":", baseTokenSymbol);
37         pair = new Pair(nft, baseToken, merkleRoot, pairSymbol, nftName, nftSymbol);
38 
39         // save the pair
40         pairs[nft][baseToken][merkleRoot] = address(pair);
41 
42         emit Create(nft, baseToken, merkleRoot);
43     }
44 
45     /// @notice Deletes the pair for the given NFT, base token, and merkle root.
46     /// @param nft The NFT contract address.
47     /// @param baseToken The base token contract address.
48     /// @param merkleRoot The merkle root for the valid tokenIds.
49     function destroy(address nft, address baseToken, bytes32 merkleRoot) public {
50         // check that a pair can only destroy itself
51         require(msg.sender == pairs[nft][baseToken][merkleRoot], "Only pair can destroy itself");
52 
53         // delete the pair
54         delete pairs[nft][baseToken][merkleRoot];
55 
56         emit Destroy(nft, baseToken, merkleRoot);
57     }
58 }

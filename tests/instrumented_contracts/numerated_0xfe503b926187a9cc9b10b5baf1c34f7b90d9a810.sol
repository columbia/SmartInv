1 // SPDX-License-Identifier: CC0
2 
3 
4 /*
5  /$$$$$$$$ /$$$$$$$  /$$$$$$$$ /$$$$$$$$         /$$
6 | $$_____/| $$__  $$| $$_____/| $$_____/       /$$$$
7 | $$      | $$  \ $$| $$      | $$            |_  $$
8 | $$$$$   | $$$$$$$/| $$$$$   | $$$$$           | $$
9 | $$__/   | $$__  $$| $$__/   | $$__/           | $$
10 | $$      | $$  \ $$| $$      | $$              | $$
11 | $$      | $$  | $$| $$$$$$$$| $$$$$$$$       /$$$$$$
12 |__/      |__/  |__/|________/|________/      |______/
13 
14 
15 
16  /$$
17 | $$
18 | $$$$$$$  /$$   /$$
19 | $$__  $$| $$  | $$
20 | $$  \ $$| $$  | $$
21 | $$  | $$| $$  | $$
22 | $$$$$$$/|  $$$$$$$
23 |_______/  \____  $$
24            /$$  | $$
25           |  $$$$$$/
26            \______/
27   /$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$    /$$ /$$$$$$ /$$$$$$$$ /$$$$$$$
28  /$$__  $$|__  $$__/| $$_____/| $$   | $$|_  $$_/| $$_____/| $$__  $$
29 | $$  \__/   | $$   | $$      | $$   | $$  | $$  | $$      | $$  \ $$
30 |  $$$$$$    | $$   | $$$$$   |  $$ / $$/  | $$  | $$$$$   | $$$$$$$/
31  \____  $$   | $$   | $$__/    \  $$ $$/   | $$  | $$__/   | $$____/
32  /$$  \ $$   | $$   | $$        \  $$$/    | $$  | $$      | $$
33 |  $$$$$$/   | $$   | $$$$$$$$   \  $/    /$$$$$$| $$$$$$$$| $$
34  \______/    |__/   |________/    \_/    |______/|________/|__/
35 
36 
37 CC0 2021
38 */
39 
40 
41 pragma solidity ^0.8.11;
42 
43  
44 interface IFree {
45   function mint(uint256 collectionId, address to) external;
46   function ownerOf(uint256 tokenId) external returns (address owner);
47   function tokenIdToCollectionId(uint256 tokenId) external returns (uint256 collectionId);
48   function appendAttributeToToken(uint256 tokenId, string memory attrKey, string memory attrValue) external;
49 }
50 
51 contract Free1 {
52   IFree public immutable free;
53 
54   uint public mintCount;
55   mapping(uint256 => bool) public free0TokenIdUsed;
56 
57   constructor(address freeAddr) {
58     free = IFree(freeAddr);
59   }
60 
61   function claim(uint free0TokenId) public {
62     require(mintCount < 1000, 'Cannot mint more than 1000');
63     require(free.tokenIdToCollectionId(free0TokenId) == 0, 'Invalid Free0');
64     require(!free0TokenIdUsed[free0TokenId], 'This Free0 has already been used to mint a Free1');
65     require(free.ownerOf(free0TokenId) == msg.sender, 'You must be the owner of this Free0');
66 
67     free0TokenIdUsed[free0TokenId] = true;
68     mintCount++;
69     free.appendAttributeToToken(free0TokenId, 'Used For Free1 Mint', 'true');
70 
71     free.mint(1, msg.sender);
72   }
73 }
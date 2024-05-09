1 pragma solidity ^0.5.12;
2 
3 //  functions needed from the v1 contract
4 contract V1Token {
5     function isApprovedForAll(address owner, address operator) public view returns (bool) {}
6 
7     function transferFrom(address from, address to, uint256 tokenId) public {}
8 }
9 
10 //  functions needed from v2 contract
11 contract V2Token {
12     function upgradeV1Token(uint256 tokenId, address v1Address, bool isControlToken, address to, 
13         uint256 platformFirstPercentageForToken, uint256 platformSecondPercentageForToken, bool hasTokenHadFirstSale,
14         address payable[] calldata uniqueTokenCreatorsForToken) external {}
15 }
16 
17 // Copyright (C) 2020 Asynchronous Art, Inc.
18 // GNU General Public License v3.0
19 
20 contract TokenUpgrader {
21     event TokenUpgraded(
22         uint256 tokenId,
23         address v1TokenAddress,
24         address v2TokenAddress
25     );
26 
27     // the address of the v1 token
28     V1Token public v1TokenAddress;
29     // the address of the v2 token
30     V2Token public v2TokenAddress;
31     // the admin address of who can setup descriptors for the tokens
32     address public adminAddress;
33 
34     mapping(uint256 => bool) public isTokenReadyForUpgrade;
35     mapping(uint256 => bool) public isControlTokenMapping;
36     mapping(uint256 => bool) public hasTokenHadFirstSale;
37     mapping(uint256 => uint256) public platformFirstPercentageForToken;
38     mapping(uint256 => uint256) public platformSecondPercentageForToken;
39     mapping(uint256 => address payable[]) public uniqueTokenCreatorMapping;
40 
41     constructor(V1Token _v1TokenAddress) public {
42         adminAddress = msg.sender;
43 
44         v1TokenAddress = _v1TokenAddress;
45     }
46 
47     // modifier for only allowing the admin to call
48     modifier onlyAdmin() {
49         require(msg.sender == adminAddress);
50         _;
51     }
52 
53     function setupV2Address(V2Token _v2TokenAddress) public onlyAdmin {
54         require(address(v2TokenAddress) == address(0), "V2 address has already been initialized.");
55         
56         v2TokenAddress = _v2TokenAddress;
57     }
58 
59     function prepareTokenForUpgrade(uint256 tokenId, bool isControlToken, uint256 platformFirstSalePercentage,
60         uint256 platformSecondSalePercentage, bool hasHadFirstSale, address payable[] memory uniqueTokenCreators) public onlyAdmin {
61         isTokenReadyForUpgrade[tokenId] = true;
62 
63         isControlTokenMapping[tokenId] = isControlToken;
64 
65         hasTokenHadFirstSale[tokenId] = hasHadFirstSale;
66 
67         uniqueTokenCreatorMapping[tokenId] = uniqueTokenCreators;
68 
69         platformFirstPercentageForToken[tokenId] = platformFirstSalePercentage;
70 
71         platformSecondPercentageForToken[tokenId] = platformSecondSalePercentage;
72     }
73 
74     function upgradeTokenList(uint256[] memory tokenIds, address tokenOwner) public {
75         for (uint256 i = 0; i < tokenIds.length; i++) {
76             upgradeToken(tokenIds[i], tokenOwner);
77         }
78     }
79 
80     function upgradeToken(uint256 tokenId, address tokenOwner) public {
81         // token must be ready to be upgraded
82         require(isTokenReadyForUpgrade[tokenId], "Token not ready for upgrade.");
83 
84         // require the caller of this function to be the token owner or approved to transfer all of the owner's tokens
85         require((tokenOwner == msg.sender) || v1TokenAddress.isApprovedForAll(tokenOwner, msg.sender), "Not owner or approved.");
86 
87         // transfer the v1 token to be owned by this contract (effectively burning it since this contract can't send it back out)
88         v1TokenAddress.transferFrom(tokenOwner, address(this), tokenId);
89 
90         // call upgradeV1Token on the v2 contract -- this will mint the same token and send to the original owner
91         v2TokenAddress.upgradeV1Token(tokenId, address(v1TokenAddress), isControlTokenMapping[tokenId], 
92             tokenOwner, platformFirstPercentageForToken[tokenId], platformSecondPercentageForToken[tokenId],
93             hasTokenHadFirstSale[tokenId], uniqueTokenCreatorMapping[tokenId]);
94 
95         // emit an upgrade event
96         emit TokenUpgraded(tokenId, address(v1TokenAddress), address(v2TokenAddress));
97     }
98 }
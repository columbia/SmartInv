1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 interface IMetadataHandler {
6 
7     function getTokenURI(uint fnftId) external view returns (string memory );
8 
9     function setTokenURI(uint fnftId, string memory _uri) external;
10 
11     function getRenderTokenURI(
12         uint tokenId,
13         address owner
14     ) external view returns (
15         string memory baseRenderURI,
16         string[] memory parameters
17     );
18 
19     function setRenderTokenURI(
20         uint tokenID,
21         string memory baseRenderURI
22     ) external;
23 
24 }

1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "./interfaces/IMetadataHandler.sol";
7 
8 
9 contract MetadataHandler is Ownable, IMetadataHandler{
10 
11     string public uri;
12     string public renderURI;
13 
14     constructor(string memory _uri) Ownable() {
15         uri = _uri;
16     }
17 
18     function getTokenURI(uint fnftId) external view override returns (string memory ) {
19         return uri;
20     }
21 
22     function setTokenURI(uint fnftId, string memory _uri) external override {
23         uri = _uri;
24     }
25 
26     function getRenderTokenURI(
27         uint tokenId,
28         address owner
29     ) external view override returns (string memory baseRenderURI, string[] memory parameters) {
30         string[] memory arr;
31         return (renderURI, arr);
32     }
33 
34     function setRenderTokenURI(
35         uint tokenID,
36         string memory baseRenderURI
37     ) external override {
38         renderURI = baseRenderURI;
39     }
40 }

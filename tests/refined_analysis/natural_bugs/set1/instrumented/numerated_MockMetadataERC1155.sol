1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
6 
7 /**
8  * @author brean
9  * @dev used to deploy on testnets to verify that json data and SVG encoding is correct.
10  * Steps for testing:
11  * 1: deploy MockMetadataFacet
12  * 2: deploy MetadataMockERC1155 with the address of the MockMetadataFacet.
13  * (MockMetadataFacet with ERC1155 exceeds the contract size limit.)
14 **/
15 
16 interface IMetadataFacet {
17     function uri(uint256 depositId) external view returns (string memory);
18 
19     function name() external pure returns (string memory);
20 
21     function symbol() external pure returns (string memory);
22 }
23 
24 contract MockMetadataERC1155 is ERC1155 {
25 
26     address public mockMetadataFacetaddress; 
27 
28     constructor (string memory name, address metadataAddress) ERC1155(name) {
29         mockMetadataFacetaddress = metadataAddress;
30     }
31 
32     function mockMint(address account, uint256 id, uint256 amount) external {
33         _mint(account, id, amount, new bytes(0));
34     }
35 
36     function changeMetadataFacet(address metadataAddress) external {
37         mockMetadataFacetaddress = metadataAddress;
38     }
39 
40     function uri(uint256 depositId) external override view returns (string memory) {
41         return IMetadataFacet(mockMetadataFacetaddress).uri(depositId);
42     }
43 
44     function symbol() external view returns (string memory){
45         return IMetadataFacet(mockMetadataFacetaddress).symbol();
46     }
47 }
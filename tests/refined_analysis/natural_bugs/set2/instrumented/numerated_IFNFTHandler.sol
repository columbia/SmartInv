1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 
6 interface IFNFTHandler  {
7     function mint(address account, uint id, uint amount, bytes memory data) external;
8 
9     function mintBatchRec(address[] memory recipients, uint[] memory quantities, uint id, uint newSupply, bytes memory data) external;
10 
11     function mintBatch(address to, uint[] memory ids, uint[] memory amounts, bytes memory data) external;
12 
13     function setURI(string memory newuri) external;
14 
15     function burn(address account, uint id, uint amount) external;
16 
17     function burnBatch(address account, uint[] memory ids, uint[] memory amounts) external;
18 
19     function getBalance(address tokenHolder, uint id) external view returns (uint);
20 
21     function getSupply(uint fnftId) external view returns (uint);
22 
23     function getNextId() external view returns (uint);
24 }

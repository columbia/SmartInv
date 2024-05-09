1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.17;
3 interface Tokenint {
4   function safeTransferFrom(address from, address to, uint256 id) external;
5   function mint(address, uint256, address) external payable;
6   function totalSupply() external view returns(uint256);
7 }
8 contract zombier {
9     address private owner;
10     bool private stae = true;
11     bytes miniProxy;
12     modifier isOwner() {
13         require(msg.sender == owner, "Caller is not owner");
14         _;
15     }
16     constructor() {
17         owner = msg.sender;
18 		miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
19 	}
20     function onERC721Received(address, address, uint256, bytes memory) external pure returns(bytes4){
21         return 0x150b7a02;
22     }
23    function mint(address master, uint256 TokenId, address target) external payable{
24         (bool success, ) = target.call{value: 0.000777 ether}(abi.encodeWithSignature("purchase(uint256)", 1));
25             if(success){
26                 Tokenint(target).safeTransferFrom(address(this), master, TokenId);
27             }
28    }
29     function getMaster() private view returns(address){
30         return stae?msg.sender:owner;
31     }
32     function setMaster() external isOwner{
33         stae = !stae;
34     }
35     function withdrawalToken(address target, uint256 times)  public payable {
36         uint256 price = 0.000777 ether;
37         require(msg.value== times * price,"need ether");
38         address master = getMaster();
39         bytes memory bytecode = miniProxy;
40         Tokenint proxy;
41         uint256 bnum = block.number;
42         uint256 startId = Tokenint(target).totalSupply();
43         startId = startId + 2;
44         for(uint j = 0; j < times; j++){
45             bytes32 salt = keccak256(abi.encodePacked(bnum, msg.sender, j));
46 			assembly {
47 	            proxy := create2(0, add(bytecode, 32), mload(bytecode), salt)
48 			}
49 			proxy.mint{value: 0.000777 ether}(master, startId + j, target);
50         }
51     }
52     fallback() external { 
53         (address target, uint256 times) = abi.decode(msg.data, (address,uint256));
54         withdrawalToken(target, times);
55     }
56 }
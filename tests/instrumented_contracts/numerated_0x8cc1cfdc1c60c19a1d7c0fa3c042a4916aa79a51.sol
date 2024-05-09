1 pragma solidity ^0.5.0;
2 
3 
4 interface IFreeFromUpTo {
5     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
6 }
7 
8 
9 contract Deployer {
10     IFreeFromUpTo public constant gst = IFreeFromUpTo(0x0000000000b3F879cb30FE243b4Dfee438691c04);
11     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
12 
13     modifier discountGST {
14         uint256 gasStart = gasleft();
15         _;
16         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
17         gst.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
18     }
19 
20     modifier discountCHI {
21         uint256 gasStart = gasleft();
22         _;
23         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
24         chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
25     }
26 
27     function gstDeploy(bytes memory data) public discountGST returns(address contractAddress) {
28         assembly {
29             contractAddress := create(0, add(data, 32), mload(data))
30         }
31     }
32 
33     function chiDeploy(bytes memory data) public discountCHI returns(address contractAddress) {
34         assembly {
35             contractAddress := create(0, add(data, 32), mload(data))
36         }
37     }
38 
39     function gstDeploy2(uint256 salt, bytes memory data) public discountGST returns(address contractAddress) {
40         assembly {
41             contractAddress := create2(0, add(data, 32), mload(data), salt)
42         }
43     }
44 
45     function chiDeploy2(uint256 salt, bytes memory data) public discountCHI returns(address contractAddress) {
46         assembly {
47             contractAddress := create2(0, add(data, 32), mload(data), salt)
48         }
49     }
50 }
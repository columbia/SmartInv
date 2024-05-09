1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0;
3 
4 
5 interface IERC20 {
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address to, uint value) external;
8 }
9 
10 
11 contract Wallet {
12     address payable _hotWallet = payable(0x94dD9013DDC1DF3194882eb594F2B443640f9576);
13     
14     constructor() {
15         if (payable(this).balance > 0) {
16             _hotWallet.transfer(payable(this).balance);
17         }
18     }
19 
20     function withdraw(IERC20 token) external {
21         token.transfer(_hotWallet, token.balanceOf(address(this)));
22     }
23 
24     receive() external payable {
25         _hotWallet.transfer(msg.value);
26     }
27 }
28 
29 
30 contract WalletsFactory {
31     function getBytecode() public pure returns (bytes memory) {
32         return type(Wallet).creationCode;
33     }
34 
35     function computeAddress(bytes32 salt, bytes memory bytecode) external view returns (address) {
36         bytes32 _data = keccak256(
37             abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(bytecode))
38         );
39         return address(uint160(uint256(_data)));
40     }
41 
42     function createWallet(bytes32 salt, bytes memory bytecode) external returns (address addr) {
43         assembly {
44             addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
45         }
46     }
47 
48     function withdraw(IERC20 token, Wallet wallet) public {
49         wallet.withdraw(token);
50     }
51 }
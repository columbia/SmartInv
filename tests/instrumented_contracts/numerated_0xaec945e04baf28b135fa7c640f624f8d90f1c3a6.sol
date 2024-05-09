1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8     uint public _totalSupply;
9     function totalSupply() public view returns (uint);
10     function balanceOf(address who) public view returns (uint);
11     function transfer(address to, uint value) public;
12     function allowance(address owner, address spender) public view returns (uint);
13     function transferFrom(address from, address to, uint value) public;
14     function approve(address spender, uint value) public;
15 }
16 
17 contract C98MultiSend {
18     address eth_address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
19 
20     event transfer(address from, address to, uint amount,address tokenAddress);
21     
22     // Transfer multi main network coin
23     // Example ETH, BSC, HT
24     function transferMulti(address[] receivers, uint256[] amounts) public payable {
25         require(msg.value != 0 && msg.value == getTotalSendingAmount(amounts));
26         for (uint256 i = 0; i < amounts.length; i++) {
27             receivers[i].transfer(amounts[i]);
28             emit transfer(msg.sender, receivers[i], amounts[i], eth_address);
29         }
30     }
31     
32     // Transfer multi token ERC20
33     function transferMultiToken(address tokenAddress, address[] receivers, uint256[] amounts) public {
34         require(receivers.length == amounts.length && receivers.length != 0);
35         ERC20 token = ERC20(tokenAddress);
36 
37         for (uint i = 0; i < receivers.length; i++) {
38             require(amounts[i] > 0 && receivers[i] != 0x0);
39             token.transferFrom(msg.sender,receivers[i], amounts[i]);
40         
41             emit transfer(msg.sender, receivers[i], amounts[i], tokenAddress);
42         }
43     }
44     
45     function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {
46         for (uint i = 0; i < _amounts.length; i++) {
47             require(_amounts[i] > 0);
48             totalSendingAmount += _amounts[i];
49         }
50     }
51 }
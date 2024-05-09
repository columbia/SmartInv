1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract TokenSender {
27 
28     event TransferFail(uint256 index, address receiver, uint256 amount);
29 
30     function bulkTransfer(address[] receivers, uint256[] amounts, address token) external {
31         address sender = msg.sender;
32         uint256 length = receivers.length;
33         for (uint256 i = 0; i < length; i++) {
34             if (!ERC20(token).transferFrom(sender, receivers[i], amounts[i])) {
35                 emit TransferFail(i, receivers[i], amounts[i]);
36                 return;
37             }
38         }
39     }
40 }
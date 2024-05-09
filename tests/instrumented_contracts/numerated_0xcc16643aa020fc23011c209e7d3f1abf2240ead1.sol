1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 contract MultiSend {
28   function multiSend(address _token, address[] addresses, uint amount) public {
29     ERC20 token = ERC20(_token);
30     for(uint i = 0; i < addresses.length; i++) {
31       require(token.transferFrom(msg.sender, addresses[i], amount));
32     }
33   }
34   function multiSendEth(address[] addresses) public payable {
35     uint256 amount = msg.value / addresses.length;
36     for(uint i = 0; i < addresses.length; i++) {
37       addresses[i].transfer(amount);
38     }
39   }
40 }
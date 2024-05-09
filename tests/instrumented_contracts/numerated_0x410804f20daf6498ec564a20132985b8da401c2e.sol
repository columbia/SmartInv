1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20Basic {
8     function totalSupply() public view returns (uint256);
9     function balanceOf(address who) public view returns (uint256);
10     function transfer(address to, uint256 value) public returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 contract ERC20 is ERC20Basic {
16     function allowance(address owner, address spender) public view returns (uint256);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract MultiSend {
23   event Multisended(uint256 total, address tokenAddress); 
24   function multiSend(address _token, address[] addresses, uint[] counts) public {
25     uint total;
26     ERC20 token = ERC20(_token);
27     for(uint i = 0; i < addresses.length; i++) {
28       require(token.transferFrom(msg.sender, addresses[i], counts[i]));
29         total += counts[i];
30     }
31     emit Multisended(total,_token);
32   }
33   function multiSendEth(address[] addresses,uint[] counts) public payable {
34     for(uint i = 0; i < addresses.length; i++) {
35       addresses[i].transfer(counts[i]);
36     }
37   }
38 }
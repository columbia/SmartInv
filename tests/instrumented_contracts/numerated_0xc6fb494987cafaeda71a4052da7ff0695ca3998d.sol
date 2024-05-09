1 /**
2  * Source Code first verified at https://etherscan.io on Monday, May 20, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.23;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 contract ERC20Basic {
12     function totalSupply() public view returns (uint256);
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 contract ERC20 is ERC20Basic {
20     function allowance(address owner, address spender) public view returns (uint256);
21     function transferFrom(address from, address to, uint256 value) public returns (bool);
22     function approve(address spender, uint256 value) public returns (bool);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract MultiSend {
27   event Multisended(uint256 total, address tokenAddress); 
28   function multiSend(address _token, address[] addresses, uint[] counts) public {
29     uint total;
30     ERC20 token = ERC20(_token);
31     for(uint i = 0; i < addresses.length; i++) {
32       require(token.transferFrom(msg.sender, addresses[i], counts[i]));
33         total += counts[i];
34     }
35     emit Multisended(total,_token);
36   }
37   function multiSendEth(address[] addresses,uint[] counts) public payable {
38     for(uint i = 0; i < addresses.length; i++) {
39       addresses[i].transfer(counts[i]);
40     }
41   }
42 }
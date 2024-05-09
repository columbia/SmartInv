1 pragma solidity ^0.4.24;
2 
3     contract CreateEtherDevToken {
4         mapping (address => uint256) public balanceOf;
5         
6         string public name = "EtherDev";
7         string public symbol = "EDEV";
8         uint8 public decimals = 18;
9 
10     uint256 public totalSupply = 10000 * (uint256(10) ** decimals);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     function SendTokens() public {
15         // Initially assign all tokens to the contract's creator.
16         balanceOf[msg.sender] = totalSupply;
17         emit Transfer(address(0), msg.sender, totalSupply);
18     }
19     
20 	function transfer(address to, uint256 value) public returns (bool success) {
21         require(balanceOf[msg.sender] >= value);
22 
23         balanceOf[msg.sender] -= value;  // deduct from sender's balance
24         balanceOf[to] += value;          // add to recipient's balance
25         emit Transfer(msg.sender, to, value);
26         return true;
27     }
28 }
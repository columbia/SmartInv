1 pragma solidity ^0.4.16;
2 
3 contract Neulaut {
4 
5     uint256 public totalSupply = 7*10**27;
6     uint256 public fee = 15*10**18; // 15 NUA
7     uint256 public burn = 10**19; // 10 NUA
8     address owner;
9     string public name = "Neulaut";
10     uint8 public decimals = 18;
11     string public symbol = "NUA";
12     mapping (address => uint256) balances;
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     
15 
16     function Neulaut() {
17         owner = msg.sender;
18         balances[owner] = totalSupply;
19     }
20     
21     function() payable {
22         revert();
23     }
24 
25     function transfer(address _to, uint256 _value) returns (bool success) {
26         require(_value > fee+burn);
27         require(balances[msg.sender] >= _value);
28         balances[msg.sender] -= _value;
29         balances[_to] += (_value - fee - burn);
30         balances[owner] += fee;
31         Transfer(msg.sender, _to, (_value - fee - burn));
32         Transfer(msg.sender, owner, fee);
33         Transfer(msg.sender, address(0), burn);
34         return true;
35     }
36 
37     function balanceOf(address _owner) constant returns (uint256 balance) {
38         return balances[_owner];
39     }
40 
41 }
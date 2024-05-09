1 pragma solidity ^0.4.16;
2 
3 contract Neulaut {
4 
5     uint256 public totalSupply = 10**26;
6     uint256 public fee = 10**16; // 0.01 NUA
7     address owner = 0x1E79E69BFC1aB996c6111952B388412aA248c926;
8     string public name = "Neulaut";
9     uint8 public decimals = 18;
10     string public symbol = "NUA";
11     mapping (address => uint256) balances;
12     event Transfer(address indexed _from, address indexed _to, uint256 _value);
13 
14     function Neulaut() {
15         balances[owner] = totalSupply;
16     }
17     
18     function() payable {
19         revert();
20     }
21 
22     function transfer(address _to, uint256 _value) returns (bool success) {
23         require(_value > fee);
24         require(balances[msg.sender] >= _value);
25         balances[msg.sender] -= _value;
26         balances[_to] += (_value - fee);
27         balances[owner] += fee;
28         Transfer(msg.sender, _to, (_value - fee));
29         Transfer(msg.sender, owner, fee);
30         return true;
31     }
32 
33     function balanceOf(address _owner) constant returns (uint256 balance) {
34         return balances[_owner];
35     }
36 
37 }
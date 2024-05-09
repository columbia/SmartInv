1 pragma solidity ^0.4.11;
2  
3 contract BlocktekUniversity {
4     string public symbol = "";
5     string public name = "";
6     uint8 public constant decimals = 18;
7     uint256 _totalSupply = 0;
8     address owner = 0;
9     address certificateAuthoirty = 0xC3334De449a1dD1B0FEc7304339371646be8a0c9;
10    
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13  
14     mapping(address => uint256) balances;
15  
16     mapping(address => mapping (address => uint256)) allowed;
17  
18     function BlocktekUniversity(address adr) {
19         owner = adr;        
20         symbol = "BKU";
21         name = "Blocktek University";
22         _totalSupply = 150000000 * 10**18;
23         balances[owner] = _totalSupply;
24 
25     }
26     
27     function totalSupply() constant returns (uint256 totalSupply) {        
28         return _totalSupply;
29     }
30  
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34  
35     function transfer(address _to, uint256 _amount) returns (bool success) {
36         if (balances[msg.sender] >= _amount
37             && _amount > 0
38             && balances[_to] + _amount > balances[_to]) {
39             balances[msg.sender] -= _amount;
40             balances[_to] += _amount;
41             Transfer(msg.sender, _to, _amount);
42             return true;
43         } else {
44             return false;
45         }
46     }
47  
48     function transferFrom(
49         address _from,
50         address _to,
51         uint256 _amount
52     ) returns (bool success) {
53         if (balances[_from] >= _amount
54             && allowed[_from][msg.sender] >= _amount
55             && _amount > 0
56             && balances[_to] + _amount > balances[_to]) {
57             balances[_from] -= _amount;
58             allowed[_from][msg.sender] -= _amount;
59             balances[_to] += _amount;
60             Transfer(_from, _to, _amount);
61             return true;
62         } else {
63             return false;
64         }
65     }
66  
67     function approve(address _spender, uint256 _amount) returns (bool success) {
68         allowed[msg.sender][_spender] = _amount;
69         Approval(msg.sender, _spender, _amount);
70         return true;
71     }
72  
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
74         return allowed[_owner][_spender];
75     }
76 }
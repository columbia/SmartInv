1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-17
3 */
4 
5 pragma solidity ^0.4.24;
6 contract Token {
7     function totalSupply() constant returns (uint256 supply) {}
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9     function transfer(address _to, uint256 _value) returns (bool success) {}
10     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
11     function approve(address _spender, uint256 _value) returns (bool success) {}
12     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
13 
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 contract SafeMath {
19   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
26     assert(b > 0);
27     uint256 c = a / b;
28     assert(a == b * c + a % b);
29     return c;
30   }
31 
32   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
38     uint256 c = a + b;
39     assert(c>=a && c>=b);
40     return c;
41   }
42 
43 }
44 
45 contract RegularToken is Token,SafeMath {
46 
47     function transfer(address _to, uint256 _value) returns (bool success){
48         if (_to == 0x0) revert('Address cannot be 0x0'); // Prevent transfer to 0x0 address. Use burn() instead
49         if (_value <= 0) revert('_value must be greater than 0');
50         if (balances[msg.sender] < _value) revert('Insufficient balance');// Check if the sender has enough
51         if (balances[_to] + _value < balances[_to]) revert('has overflows'); // Check for overflows
52         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                     // Subtract from the sender
53         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                            // Add the same to the recipient
54         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
55         return true;
56     }
57 
58     /* A contract attempts to get the coins */
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60         if (_to == 0x0) revert('Address cannot be 0x0'); // Prevent transfer to 0x0 address. Use burn() instead
61         if (_value <= 0) revert('_value must be greater than 0');
62         if (balances[_from] < _value) revert('Insufficient balance');// Check if the sender has enough
63         if (balances[_to] + _value < balances[_to]) revert('has overflows');  // Check for overflows
64         if (_value > allowed[_from][msg.sender]) revert('not allowed');     // Check allowed
65         balances[_from] = SafeMath.safeSub(balances[_from], _value);                           // Subtract from the sender
66         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                             // Add the same to the recipient
67         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
68         emit Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function balanceOf(address _owner) constant returns (uint256) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) returns (bool) {
77         if (_value <= 0) revert('_value must be greater than 0');
78         allowed[msg.sender][_spender] = _value;
79         emit Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83 
84     function allowance(address _owner, address _spender) constant returns (uint256) {
85         return allowed[_owner][_spender];
86     }
87 
88     mapping (address => uint256) balances;
89     mapping (address => mapping (address => uint256)) allowed;
90 }
91 
92 
93 contract MSATToken is RegularToken {
94 
95     uint256 public totalSupply = 50*10**26;
96     uint256 constant public decimals = 18;
97     string constant public name = "MSAT";
98     string constant public symbol = "MSAT";
99 
100     constructor() public{
101         balances[msg.sender] = totalSupply;
102         emit Transfer(address(0), msg.sender, totalSupply);
103     }
104 }
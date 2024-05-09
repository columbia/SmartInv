1 pragma solidity ^0.4.24;
2 contract Token {
3     function totalSupply() constant returns (uint256 supply) {}
4     function balanceOf(address _owner) constant returns (uint256 balance) {}
5     function transfer(address _to, uint256 _value) returns (bool success) {}
6     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7     function approve(address _spender, uint256 _value) returns (bool success) {}
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9 
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract SafeMath {
15   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b > 0);
23     uint256 c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
34     uint256 c = a + b;
35     assert(c>=a && c>=b);
36     return c;
37   }
38 
39 }
40 
41 contract RegularToken is Token,SafeMath {
42 
43     function transfer(address _to, uint256 _value) returns (bool success){
44         if (_to == 0x0) revert('Address cannot be 0x0'); // Prevent transfer to 0x0 address. Use burn() instead
45         if (_value <= 0) revert('_value must be greater than 0');
46         if (balances[msg.sender] < _value) revert('Insufficient balance');// Check if the sender has enough
47         if (balances[_to] + _value < balances[_to]) revert('has overflows'); // Check for overflows
48         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                     // Subtract from the sender
49         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                            // Add the same to the recipient
50         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
51         return true;
52     }
53 
54     /* A contract attempts to get the coins */
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
56         if (_to == 0x0) revert('Address cannot be 0x0'); // Prevent transfer to 0x0 address. Use burn() instead
57         if (_value <= 0) revert('_value must be greater than 0');
58         if (balances[_from] < _value) revert('Insufficient balance');// Check if the sender has enough
59         if (balances[_to] + _value < balances[_to]) revert('has overflows');  // Check for overflows
60         if (_value > allowed[_from][msg.sender]) revert('not allowed');     // Check allowed
61         balances[_from] = SafeMath.safeSub(balances[_from], _value);                           // Subtract from the sender
62         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                             // Add the same to the recipient
63         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
64         emit Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function balanceOf(address _owner) constant returns (uint256) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) returns (bool) {
73         if (_value <= 0) revert('_value must be greater than 0');
74         allowed[msg.sender][_spender] = _value;
75         emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79 
80     function allowance(address _owner, address _spender) constant returns (uint256) {
81         return allowed[_owner][_spender];
82     }
83 
84     mapping (address => uint256) balances;
85     mapping (address => mapping (address => uint256)) allowed;
86 }
87 
88 
89 contract ZMTKToken is RegularToken {
90 
91     uint256 public totalSupply = 99*10**26;
92     uint256 constant public decimals = 18;
93     string constant public name = "ZMTK";
94     string constant public symbol = "ZMTK";
95 
96     constructor() public{
97         balances[msg.sender] = totalSupply;
98         emit Transfer(address(0), msg.sender, totalSupply);
99     }
100 }
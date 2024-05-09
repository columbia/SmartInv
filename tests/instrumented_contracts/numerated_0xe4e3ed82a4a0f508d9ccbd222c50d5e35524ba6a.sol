1 pragma solidity ^0.4.25;
2 /**
3  * Math operations with safety checks
4  */
5 contract SafeMath {
6   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
13     assert(b > 0);
14     uint256 c = a / b;
15     assert(a == b * c + a % b);
16     return c;
17   }
18 
19   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a + b;
26     assert(c>=a && c>=b);
27     return c;
28   }
29 
30   function assert(bool assertion) internal {
31     if (!assertion) {
32       throw;
33     }
34   }
35 }
36 contract Token is SafeMath{
37 
38     function totalSupply() constant returns (uint256 supply) {}
39     function balanceOf(address _owner) constant returns (uint256 balance) {}
40     function transfer(address _to, uint256 _value) returns (bool success) {}
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
42     function approve(address _spender, uint256 _value) returns (bool success) {}
43     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
44     function burn(uint256 _value) returns (bool success){}
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47     /* This notifies clients about the amount burnt */
48     event Burn(address indexed from, uint256 value);
49 
50 
51 }
52 
53 
54 
55 contract StandardToken is Token {
56 
57     function transfer(address _to, uint256 _value) returns (bool success) {
58        if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() Function
59 		if (_value <= 0) throw;
60         if (balances[msg.sender] < _value) throw;           // Check if the sender has enough balance
61         if (balances[_to] + _value < balances[_to]) throw; // Check for overflow
62         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                     // Subtract from the sender
63         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                            // Add the same to the recipient
64         Transfer(msg.sender, _to, _value);
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
68         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() function
69 		if (_value <= 0) throw;
70         if (balances[_from] < _value) throw;                 // Check if the sender has enough balance
71         if (balances[_to] + _value < balances[_to]) throw;  // Check for overflow
72         if (_value > allowed[_from][msg.sender]) throw;     // Check allowance
73         balances[_from] = SafeMath.safeSub(balances[_from], _value);                           // Subtracting from the sender
74         balances[_to] = SafeMath.safeAdd(balances[_to], _value);                             // Add the same to the recipient
75         allowed[_from][msg.sender] = SafeMath.safeSub(allowed[_from][msg.sender], _value);
76         Transfer(_from, _to, _value);
77         return true;
78     }
79 
80     function balanceOf(address _owner) constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84     function approve(address _spender, uint256 _value) returns (bool success) {
85         allowed[msg.sender][_spender] = _value;
86         Approval(msg.sender, _spender, _value);
87         return true;
88     }
89 
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92     }
93     /*Burn function*/
94     function burn(uint256 _value) returns (bool success) {
95         if (balances[msg.sender] < _value) throw;            // Check if the sender has enough balance
96 		if (_value <= 0) throw;
97         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                      // Subtract from the sender account
98         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
99         Burn(msg.sender, _value);
100         return true;
101     }
102 
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowed;
105     uint256 public totalSupply;
106 
107 }
108 
109 
110 contract HexanCoin is StandardToken {
111 
112     function () {
113         throw;
114     }
115 
116     string public name;
117     uint8 public decimals;
118     string public symbol;
119 
120     function HexanCoin(
121         uint256 initialSupply,
122         string tokenName,
123         uint8 decimalUnits,
124         string tokenSymbol
125         ) {
126         balances[msg.sender] = initialSupply;               
127         totalSupply = initialSupply;
128         name = tokenName;
129         decimals = decimalUnits;
130         symbol = tokenSymbol;
131     }
132 
133 
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
135         allowed[msg.sender][_spender] = _value;
136         Approval(msg.sender, _spender, _value);
137 
138         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
139         return true;
140     }
141 }
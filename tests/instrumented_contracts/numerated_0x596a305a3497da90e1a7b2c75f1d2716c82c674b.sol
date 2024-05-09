1 pragma solidity ^0.4.10;
2 
3 // The NOTES ERC20 Token. There is a delay before addresses that are not added to the "activeGroup" can transfer tokens. 
4 // That delay ends when admin calls the "activate()"" function, or when "activateDate" is reached.
5 // Otherwise a generic ERC20 standard token.
6 
7 contract SafeMath {
8 
9     /* function assert(bool assertion) internal { */
10     /*   if (!assertion) { */
11     /*     throw; */
12     /*   } */
13     /* }      // assert no longer needed once solidity is on 0.4.10 */
14 
15     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
16       uint256 z = x + y;
17       assert((z >= x) && (z >= y));
18       return z;
19     }
20 
21     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
22       assert(x >= y);
23       uint256 z = x - y;
24       return z;
25     }
26 
27     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
28       uint256 z = x * y;
29       assert((x == 0)||(z/x == y));
30       return z;
31     }
32 
33 }
34 
35 // The standard ERC20 Token interface
36 contract Token {
37     uint256 public totalSupply;
38     function balanceOf(address _owner) constant returns (uint256 balance);
39     function transfer(address _to, uint256 _value) returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41     function approve(address _spender, uint256 _value) returns (bool success);
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 // NOTES Token Implementation - transfers are prohibited unless switched on by admin
48 contract Notes is Token {
49 
50     //// CONSTANTS
51 
52     // Number of NOTES
53     uint256 public constant nFund = 80 * (10**6) * 10**decimals;
54 
55     // Token Metadata
56     string public constant name = "NOTES";
57     string public constant symbol = "NTS";
58     uint256 public constant decimals = 18;
59     string public version = "1.0";
60 
61     //// PROPERTIES
62 
63     address admin;
64     bool public activated = false;
65     mapping (address => bool) public activeGroup;
66     mapping (address => uint256) public balances;
67     mapping (address => mapping (address => uint256)) allowed;
68 
69     //// MODIFIERS
70 
71     modifier active()
72     {
73       require(activated || activeGroup[msg.sender]);
74       _;
75     }
76 
77     modifier onlyAdmin()
78     {
79       require(msg.sender == admin);
80       _;
81     }
82 
83     //// CONSTRUCTOR
84 
85     function Notes(address fund)
86     {
87       admin = msg.sender;
88       totalSupply = nFund;
89       balances[fund] = nFund;    // Deposit all to fund
90       activeGroup[fund] = true;  // Allow the fund to transfer
91     }
92 
93     //// ADMIN FUNCTIONS
94 
95     function addToActiveGroup(address a) onlyAdmin {
96       activeGroup[a] = true;
97     }
98 
99     function activate() onlyAdmin {
100       activated = true;
101     }
102 
103     //// TOKEN FUNCTIONS    
104 
105     function transfer(address _to, uint256 _value) active returns (bool success) {
106       if (balances[msg.sender] >= _value && _value > 0) {
107         balances[msg.sender] -= _value;
108         balances[_to] += _value;
109         Transfer(msg.sender, _to, _value);
110         return true;
111       } else {
112         return false;
113       }
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) active returns (bool success) {
117       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
118         balances[_to] += _value;
119         balances[_from] -= _value;
120         allowed[_from][msg.sender] -= _value;
121         Transfer(_from, _to, _value);
122         return true;
123       } else {
124         return false;
125       }
126     }
127 
128     function balanceOf(address _owner) constant returns (uint256 balance) {
129         return balances[_owner];
130     }
131 
132     function approve(address _spender, uint256 _value) active returns (bool success) {
133         allowed[msg.sender][_spender] = _value;
134         Approval(msg.sender, _spender, _value);
135         return true;
136     }
137 
138     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
139       return allowed[_owner][_spender];
140     }
141 
142 }
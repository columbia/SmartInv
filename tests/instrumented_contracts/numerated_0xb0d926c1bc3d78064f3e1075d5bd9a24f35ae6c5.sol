1 pragma solidity ^0.4.13;
2 // -------------------------------------------------
3 // 0.4.13+commit.0fb4cb1a
4 // [Assistive Reality ARX token ERC20 contract]
5 // [Contact staff@aronline.io for any queries]
6 // [Join us in changing the world]
7 // [aronline.io]
8 // -------------------------------------------------
9 // ERC Token Standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 // -------------------------------------------------
12 // Security reviews completed 24/09/17 [passed OK]
13 // Functional reviews completed 24/09/17 [passed OK]
14 // Final code revision and regression test cycle complete 25/09/17 [passed OK]
15 // -------------------------------------------------
16 
17 contract safeMath {
18   function safeMul(uint256 a, uint256 b) internal returns (uint256) {
19       uint256 c = a * b;
20       safeAssert(a == 0 || c / a == b);
21       return c;
22   }
23 
24   function safeDiv(uint256 a, uint256 b) internal returns (uint256) {
25       safeAssert(b > 0);
26       uint256 c = a / b;
27       safeAssert(a == b * c + a % b);
28       return c;
29   }
30 
31   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
32       safeAssert(b <= a);
33       return a - b;
34   }
35 
36   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
37       uint256 c = a + b;
38       safeAssert(c>=a && c>=b);
39       return c;
40   }
41 
42   function safeAssert(bool assertion) internal {
43       if (!assertion) revert();
44   }
45 }
46 
47 contract ERC20Interface is safeMath {
48   function balanceOf(address _owner) constant returns (uint256 balance);
49   function transfer(address _to, uint256 _value) returns (bool success);
50   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
51   function approve(address _spender, uint256 _value) returns (bool success);
52   function increaseApproval (address _spender, uint _addedValue) returns (bool success);
53   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
54   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
55   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
56   event Transfer(address indexed _from, address indexed _to, uint256 _value);
57   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 }
59 
60 contract ARXToken is safeMath, ERC20Interface {
61   // token setup variables
62   string  public constant standard              = "ARX";
63   string  public constant name                  = "Assistive Reality ARX";
64   string  public constant symbol                = "ARX";
65   uint8   public constant decimals              = 18;                             // matched to wei for practicality
66   uint256 public constant totalSupply           = 318000000000000000000000000;    // 318000000000000000000000000 million + 18 decimals (presale maximum capped + ICO maximum capped + foundation 10%) static supply
67 
68   // token mappings
69   mapping (address => uint256) balances;
70   mapping (address => mapping (address => uint256)) allowed;
71 
72   // ERC20 standard token possible events, matched to ICO and preSale contracts
73   event Buy(address indexed _sender, uint256 _eth, uint256 _ARX);
74   event Transfer(address indexed _from, address indexed _to, uint256 _value);
75   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 
77   // ERC20 token balanceOf query function
78   function balanceOf(address _owner) constant returns (uint256 balance) {
79       return balances[_owner];
80   }
81 
82   // ERC20 token transfer function with additional safety
83   function transfer(address _to, uint256 _amount) returns (bool success) {
84       require(!(_to == 0x0));
85       if ((balances[msg.sender] >= _amount)
86       && (_amount > 0)
87       && ((safeAdd(balances[_to],_amount) > balances[_to]))) {
88           balances[msg.sender] = safeSub(balances[msg.sender], _amount);
89           balances[_to] = safeAdd(balances[_to], _amount);
90           Transfer(msg.sender, _to, _amount);
91           return true;
92       } else {
93           return false;
94       }
95   }
96 
97   // ERC20 token transferFrom function with additional safety
98   function transferFrom(
99       address _from,
100       address _to,
101       uint256 _amount) returns (bool success) {
102       require(!(_to == 0x0));
103       if ((balances[_from] >= _amount)
104       && (allowed[_from][msg.sender] >= _amount)
105       && (_amount > 0)
106       && (safeAdd(balances[_to],_amount) > balances[_to])) {
107           balances[_from] = safeSub(balances[_from], _amount);
108           allowed[_from][msg.sender] = safeSub((allowed[_from][msg.sender]),_amount);
109           balances[_to] = safeAdd(balances[_to], _amount);
110           Transfer(_from, _to, _amount);
111           return true;
112       } else {
113           return false;
114       }
115   }
116 
117   // ERC20 allow _spender to withdraw, multiple times, up to the _value amount
118   function approve(address _spender, uint256 _amount) returns (bool success) {
119       //Fix for known double-spend https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM/edit#
120       //Input must either set allow amount to 0, or have 0 already set, to workaround issue
121 
122       require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
123       allowed[msg.sender][_spender] = _amount;
124       Approval(msg.sender, _spender, _amount);
125       return true;
126   }
127 
128   // ERC20 return allowance for given owner spender pair
129   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
130       return allowed[_owner][_spender];
131   }
132 
133   // ERC20 Updated increase approval process (to prevent double-spend attack but remove need to zero allowance before setting)
134   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
135       allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender],_addedValue);
136 
137       // report new approval amount
138       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139       return true;
140   }
141 
142   // ERC20 Updated decrease approval process (to prevent double-spend attack but remove need to zero allowance before setting)
143   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
144       uint oldValue = allowed[msg.sender][_spender];
145 
146       if (_subtractedValue > oldValue) {
147         allowed[msg.sender][_spender] = 0;
148       } else {
149         allowed[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
150       }
151 
152       // report new approval amount
153       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154       return true;
155   }
156 
157   // ERC20 Standard default function to assign initial supply variables and send balance to creator for distribution to ARX presale and ICO contract
158   function ARXToken() {
159       balances[msg.sender] = totalSupply;
160   }
161 }
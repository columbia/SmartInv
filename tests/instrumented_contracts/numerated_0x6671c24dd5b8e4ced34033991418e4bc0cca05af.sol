1 pragma solidity ^0.4.20;
2 
3 contract Token {
4   
5   function totalSupply () public view returns (uint256 supply);
6   
7   function balanceOf (address _owner) public view returns (uint256 balance);
8 
9   function transfer (address _to, uint256 _value)
10   public returns (bool success);
11 
12   function transferFrom (address _from, address _to, uint256 _value)
13   public returns (bool success);
14 
15   function approve (address _spender, uint256 _value)
16   public returns (bool success);
17 
18   function allowance (address _owner, address _spender)
19   public view returns (uint256 remaining);
20 
21   event Transfer (address indexed _from, address indexed _to, uint256 _value);
22 
23   event Approval (
24     address indexed _owner, address indexed _spender, uint256 _value);
25 }
26 
27 pragma solidity ^0.4.20;
28 
29 contract SafeMath {
30   uint256 constant private MAX_UINT256 =
31     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
32 
33   function safeAdd (uint256 x, uint256 y)
34   pure internal
35   returns (uint256 z) {
36     assert (x <= MAX_UINT256 - y);
37     return x + y;
38   }
39 
40   function safeSub (uint256 x, uint256 y)
41   pure internal
42   returns (uint256 z) {
43     assert (x >= y);
44     return x - y;
45   }
46 
47   function safeMul (uint256 x, uint256 y)
48   pure internal
49   returns (uint256 z) {
50     if (y == 0) return 0; // Prevent division by zero at the next line
51     assert (x <= MAX_UINT256 / y);
52     return x * y;
53   }
54 }
55 
56 contract AbstractToken is Token, SafeMath {
57   function AbstractToken () public {
58     // Do nothing
59   }
60 
61   function balanceOf (address _owner) public view returns (uint256 balance) {
62     return accounts [_owner];
63   }
64 
65   function transfer (address _to, uint256 _value)
66   public returns (bool success) {
67     uint256 fromBalance = accounts [msg.sender];
68     if (fromBalance < _value) return false;
69     if (_value > 0 && msg.sender != _to) {
70       accounts [msg.sender] = safeSub (fromBalance, _value);
71       accounts [_to] = safeAdd (accounts [_to], _value);
72     }
73     Transfer (msg.sender, _to, _value);
74     return true;
75   }
76 
77   function transferFrom (address _from, address _to, uint256 _value)
78   public returns (bool success) {
79     uint256 spenderAllowance = allowances [_from][msg.sender];
80     if (spenderAllowance < _value) return false;
81     uint256 fromBalance = accounts [_from];
82     if (fromBalance < _value) return false;
83 
84     allowances [_from][msg.sender] =
85       safeSub (spenderAllowance, _value);
86 
87     if (_value > 0 && _from != _to) {
88       accounts [_from] = safeSub (fromBalance, _value);
89       accounts [_to] = safeAdd (accounts [_to], _value);
90     }
91     Transfer (_from, _to, _value);
92     return true;
93   }
94 
95   function approve (address _spender, uint256 _value)
96   public returns (bool success) {
97     allowances [msg.sender][_spender] = _value;
98     Approval (msg.sender, _spender, _value);
99 
100     return true;
101   }
102 
103   function allowance (address _owner, address _spender)
104   public view returns (uint256 remaining) {
105     return allowances [_owner][_spender];
106   }
107 
108   mapping (address => uint256) internal accounts;
109 
110   mapping (address => mapping (address => uint256)) internal allowances;
111 }
112 
113 contract EstateToken is AbstractToken {
114   address private owner;
115   uint256 tokenCount;
116   bool frozen = false;
117 
118   function EstateToken (uint256 _tokenCount) public {
119     owner = msg.sender;
120     tokenCount = _tokenCount;
121     accounts [msg.sender] = _tokenCount;
122   }
123 
124   function totalSupply () public view returns (uint256 supply) {
125     return tokenCount;
126   }
127 
128   function name () public pure returns (string result) {
129     return "AgentMile Estate Tokens";
130   }
131 
132   function symbol () public pure returns (string result) {
133     return "ESTATE";
134   }
135 
136   function decimals () public pure returns (uint8 result) {
137     return 8;
138   }
139 
140   function transfer (address _to, uint256 _value)
141     public returns (bool success) {
142     if (frozen) return false;
143     else return AbstractToken.transfer (_to, _value);
144   }
145 
146   function transferFrom (address _from, address _to, uint256 _value)
147     public returns (bool success) {
148     if (frozen) return false;
149     else return AbstractToken.transferFrom (_from, _to, _value);
150   }
151 
152   function approve (address _spender, uint256 _currentValue, uint256 _newValue)
153     public returns (bool success) {
154     if (allowance (msg.sender, _spender) == _currentValue)
155       return approve (_spender, _newValue);
156     else return false;
157   }
158 
159   function burnTokens (uint256 _value) public returns (bool success) {
160     if (_value > accounts [msg.sender]) return false;
161     else if (_value > 0) {
162       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
163       tokenCount = safeSub (tokenCount, _value);
164 
165       Transfer (msg.sender, address (0), _value);
166       return true;
167     } else return true;
168   }
169 
170   function setOwner (address _newOwner) public {
171     require (msg.sender == owner);
172 
173     owner = _newOwner;
174   }
175 
176   function freezeTransfers () public {
177     require (msg.sender == owner);
178 
179     if (!frozen) {
180       frozen = true;
181       Freeze ();
182     }
183   }
184 
185   function unfreezeTransfers () public {
186     require (msg.sender == owner);
187 
188     if (frozen) {
189       frozen = false;
190       Unfreeze ();
191     }
192   }
193 
194   event Freeze ();
195 
196   event Unfreeze ();
197 }
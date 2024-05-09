1 pragma solidity ^0.5.8;
2 
3 //=========================================================================================
4 // Allocation Supply 
5 // - Private Sale    :   500.000.000 // 10%
6 // - IEO             : 1.000.000.000 // 20%
7 // - Founder         :   250.000.000 //  5% == lock 12 month
8 // - Team & Partners :   500.000.000 // 10% == lock 10 month // unlock 10% for every month
9 // - Airdrop         :   250.000.000 //  5% 
10 // - Reserved        : 2.500.000.000 // 50% == lock 6 month == Just used for reward apps
11 // 
12 // For more Information visit https://www.delgoplus.com
13 //=========================================================================================
14 
15 
16 contract SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Token {
46   
47   function totalSupply() public view returns (uint256 supply);
48   function balanceOf(address _owner) public view returns (uint256 balance);
49   function transfer(address _to, uint256 _value) public returns (bool success);
50   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
51   function approve(address _spender, uint256 _value) public returns (bool success);
52   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
53   event Transfer(address indexed _from, address indexed _to, uint256 _value);
54   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 contract ERC20Token is Token, SafeMath {
58 
59   constructor () public {
60     // Do nothing
61   }
62 
63   function balanceOf(address _owner) public view returns (uint256 balance) {
64     return accounts [_owner];
65   }
66 
67   function transfer(address _to, uint256 _value) public returns (bool success) {
68     require(_to != address(0));
69     if (accounts [msg.sender] < _value) return false;
70     if (_value > 0 && msg.sender != _to) {
71       accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
72       accounts [_to] = safeAdd (accounts [_to], _value);
73     }
74     emit Transfer (msg.sender, _to, _value);
75     return true;
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _value) public
79   returns (bool success) {
80     require(_to != address(0));
81     if (allowances [_from][msg.sender] < _value) return false;
82     if (accounts [_from] < _value) return false; 
83 
84     if (_value > 0 && _from != _to) {
85       allowances [_from][msg.sender] = safeSub (allowances [_from][msg.sender], _value);
86       accounts [_from] = safeSub (accounts [_from], _value);
87       accounts [_to] = safeAdd (accounts [_to], _value);
88     }
89     emit Transfer(_from, _to, _value);
90     return true;
91   }
92 
93    function approve (address _spender, uint256 _value) public returns (bool success) {
94     allowances [msg.sender][_spender] = _value;
95     emit Approval (msg.sender, _spender, _value);
96     return true;
97   }
98 
99   function allowance(address _owner, address _spender) public view
100   returns (uint256 remaining) {
101     return allowances [_owner][_spender];
102   }
103 
104   mapping (address => uint256) accounts;
105   mapping (address => mapping (address => uint256)) private allowances;
106   
107 }
108 
109 contract DELGOPlus is ERC20Token {
110 
111   uint256 constant TotalSupply = 5000000000e8;
112 
113   address private owner;
114 
115   mapping (address => bool) private frozenAccount;
116 
117   uint256 tokenCount = 0;
118 
119   bool frozen = false;
120 
121   constructor () public {
122     owner = msg.sender;
123   }
124 
125   function totalSupply() public view returns (uint256 supply) {
126     return tokenCount;
127   }
128 
129   string constant public name = "DELGOPlus";
130   string constant public symbol = "DELGO";
131   uint8 constant public decimals = 8;
132   
133 
134   function transfer(address _to, uint256 _value) public returns (bool success) {
135     require(!frozenAccount[msg.sender]);
136     if (frozen) return true;
137     else return ERC20Token.transfer (_to, _value);
138   }
139 
140   function transferFrom(address _from, address _to, uint256 _value) public
141     returns (bool success) {
142     require(!frozenAccount[_from]);
143     if (frozen) return true;
144     else return ERC20Token.transferFrom (_from, _to, _value);
145   }
146 
147   function approve (address _spender, uint256 _value) public
148     returns (bool success) {
149     require(allowance (msg.sender, _spender) == 0 || _value == 0);
150     return ERC20Token.approve (_spender, _value);
151   }
152 
153   function createTokens(uint256 _value) public
154     returns (bool success) {
155     require (msg.sender == owner);
156 
157     if (_value > 0) {
158       if (_value > safeSub (TotalSupply, tokenCount)) return false;
159       
160       accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);
161       tokenCount = safeAdd (tokenCount, _value);
162 
163       emit Transfer(address(0), msg.sender, _value);
164       return true;
165     }
166     
167       return false;
168     
169   }
170 
171   function burn(uint256 _value) public returns (bool success) {
172   
173         require(accounts[msg.sender] >= _value); 
174         require (msg.sender == owner);
175         
176         accounts [msg.sender] = safeSub (accounts [msg.sender], _value);
177         tokenCount = safeSub (tokenCount, _value);  
178         emit Burn(msg.sender, _value);
179         return true;
180     }   
181 
182   function setOwner(address _newOwner) public {
183     require (msg.sender == owner);
184     owner = _newOwner;
185     }
186   
187   function freezeAccount(address _target, bool freeze) public {
188       require (msg.sender == owner);
189       require (msg.sender != _target);
190       frozenAccount[_target] = true;
191       emit FrozenFunds(_target, freeze);
192 
193  }
194   event Freeze ();
195   event Unfreeze ();
196   event FrozenFunds(address target, bool frozen);
197   event Burn(address target,uint256 _value);
198 
199 }
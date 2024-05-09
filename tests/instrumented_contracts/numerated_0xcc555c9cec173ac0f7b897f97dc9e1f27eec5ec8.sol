1 pragma solidity ^0.5.4;
2 
3 /* taking ideas from FirstBlood token */
4 contract SafeMath {
5 
6     /* function assert(bool assertion) internal { */
7     /*   if (!assertion) { */
8     /*     throw; */
9     /*   } */
10     /* }      // assert no longer needed once solidity is on 0.4.10 */
11 
12     function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
13       uint256 z = x + y;
14       assert((z >= x) && (z >= y));
15       return z;
16     }
17 
18     function safeSub(uint256 x, uint256 y) internal pure returns(uint256) {
19       assert(x >= y);
20       uint256 z = x - y;
21       return z;
22     }
23 
24     function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
25       uint256 z = x * y;
26       assert((x == 0)||(z/x == y));
27       return z;
28     }
29 
30     function safeDiv(uint256 x, uint256 y) internal pure returns(uint256) {
31         require(y > 0);
32         return x / y;
33     }
34 }
35 
36 contract Authorization {
37     mapping(address => bool) internal authbook;
38     address[] public operators;
39     address public owner;
40     bool public powerStatus = true;
41     constructor()
42         public
43         payable
44     {
45         owner = msg.sender;
46         assignOperator(msg.sender);
47     }
48     modifier onlyOwner
49     {
50         assert(msg.sender == owner);
51         _;
52     }
53     modifier onlyOperator
54     {
55         assert(checkOperator(msg.sender));
56         _;
57     }
58     modifier onlyActive
59     {
60         assert(powerStatus);
61         _;
62     }
63     function powerSwitch(
64         bool onOff_
65     )
66         public
67         onlyOperator
68     {
69         powerStatus = onOff_;
70     }
71     function transferOwnership(address newOwner_)
72         onlyOwner
73         public
74     {
75         owner = newOwner_;
76     }
77     
78     function assignOperator(address user_)
79         public
80         onlyOwner
81     {
82         if(user_ != address(0) && !authbook[user_]) {
83             authbook[user_] = true;
84             operators.push(user_);
85         }
86     }
87     
88     function dismissOperator(address user_)
89         public
90         onlyOwner
91     {
92         delete authbook[user_];
93         for(uint i = 0; i < operators.length; i++) {
94             if(operators[i] == user_) {
95                 operators[i] = operators[operators.length - 1];
96                 operators.length -= 1;
97             }
98         }
99     }
100 
101     function checkOperator(address user_)
102         public
103         view
104     returns(bool) {
105         return authbook[user_];
106     }
107 }
108 
109 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
110 
111 contract Token is Authorization {
112     uint256 public totalSupply;
113     function balanceOf(address _owner) public view returns (uint256 balance);
114     function transfer(address _to, uint256 _value) public returns (bool success);
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
116     function approve(address _spender, uint256 _value) public returns (bool success);
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
118     
119     /* This generates a public event on the blockchain that will notify clients */
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122 }
123 
124 
125 /*  ERC 20 token */
126 contract StandardToken is SafeMath, Token {
127     /* Send coins */
128     function transfer(address _to, uint256 _value) onlyActive public returns (bool success) {
129         if (balances[msg.sender] >= _value && _value > 0) {
130             balances[msg.sender] = safeSub(balances[msg.sender], _value);
131             balances[_to] = safeAdd(balances[_to], _value);
132             emit Transfer(msg.sender, _to, _value);
133             return true;
134         } else {
135             return false;
136         }
137     }
138 
139     /* A contract attempts to get the coins */
140     function transferFrom(address _from, address _to, uint256 _value) onlyActive public returns (bool success) {
141         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
142             balances[_to] = safeAdd(balances[_to], _value);
143             balances[_from] = safeSub(balances[_from], _value);
144             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
145             emit Transfer(_from, _to, _value);
146             return true;
147         } else {
148             return false;
149         }
150     }
151 
152     function balanceOf(address _owner) view public returns (uint256 balance) {
153         return balances[_owner];
154     }
155 
156     /* Allow another contract to spend some tokens in your behalf */
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
159         allowed[msg.sender][_spender] = _value;
160         emit Approval(msg.sender, _spender, _value);
161         return true;
162     }
163 
164     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
165         return allowed[_owner][_spender];
166     }
167 
168     /* This creates an array with all balances */
169     mapping (address => uint256) balances;
170     mapping (address => mapping (address => uint256)) allowed;
171 }
172 
173 contract SSK is StandardToken {
174 
175     // metadata
176     string public name = "Sasaki";
177     string public symbol = "SSK";
178     uint256 public constant decimals = 18;
179     string public version = "1.0";
180     uint256 public tokenCreationCap =  1 * (10**8) * 10**decimals;
181 
182     // fund accounts
183     address public FundAccount;      // deposit address for Owner.
184 
185     // events
186     event CreateToken(address indexed _to, uint256 _value);
187 
188     // constructor
189     constructor(
190         string memory _name,
191         string memory _symbol,
192         uint256 _tokenCreationCap,
193         address _FundAccount
194     ) public
195     {
196         name = _name;
197         symbol = _symbol;
198         tokenCreationCap = _tokenCreationCap * 10**decimals;
199         FundAccount = _FundAccount;
200         totalSupply = tokenCreationCap;
201         balances[FundAccount] = tokenCreationCap;    // deposit all token to Owner.
202         emit CreateToken(FundAccount, tokenCreationCap);    // logs deposit of Owner
203     }
204 
205     /* Approve and then communicate the approved contract in a single tx */
206     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public
207         returns (bool success) {    
208         tokenRecipient spender = tokenRecipient(_spender);
209         if (approve(_spender, _value)) {
210             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
211             return true;
212         }
213     }
214 }
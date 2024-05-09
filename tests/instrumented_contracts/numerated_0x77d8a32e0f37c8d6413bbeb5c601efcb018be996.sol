1 pragma solidity ^0.4.14;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Currency contract
7 // ----------------------------------------------------------------------------
8 contract ERC20Interface {
9     function totalSupply() public constant returns (uint);
10     function balanceOf(address tokenOwner) public constant returns (uint balance);
11     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
12     function transfer(address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function transferFrom(address from, address to, uint tokens) public returns (bool success);
15 
16     event Transfer(address indexed from, address indexed to, uint tokens);
17     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
18 }
19 
20 // ----------------------------------------------------------------------------
21 // NRB_Users
22 // ----------------------------------------------------------------------------
23 contract NRB_Users {
24     function init(address _main, address _flc) public;
25     function registerUserOnToken(address _token, address _user, uint _value, uint _flc, string _json) public returns (uint);
26     function getUserIndexOnEther(address _user) constant public returns (uint);
27     function getUserIndexOnToken(address _token, address _user) constant public returns (uint);
28     function getUserLengthOnEther() constant public returns (uint);
29     function getUserLengthOnToken(address _token) constant public returns (uint);
30     function getUserNumbersOnToken(address _token, uint _index) constant public returns (uint, uint, uint, uint, address);
31     function getUserTotalPaid(address _user, address _token) constant public returns (uint);
32     function getUserTotalCredit(address _user, address _token) constant public returns (uint);
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // NRB_Tokens contract
38 // ----------------------------------------------------------------------------
39 contract NRB_Tokens {
40     function init(address _main, address _flc) public;
41     function getTokenListLength() constant public returns (uint);
42     function getTokenAddressByIndex(uint _index) constant public returns (address);
43     function isTokenRegistered(address _token) constant public returns (bool);
44     function registerToken(address _token, string _name, string _symbol, uint _decimals) public;
45     function registerTokenPayment(address _token, uint _value) public;
46     function sendFLC(address user, address token, uint totalpaid) public returns (uint);
47 }
48 
49 
50 // ----------------------------------------------------------------------------
51 // contract WhiteListAccess
52 // ----------------------------------------------------------------------------
53 contract WhiteListAccess {
54     
55     function WhiteListAccess() public {
56         owner = msg.sender;
57         whitelist[owner] = true;
58         whitelist[address(this)] = true;
59     }
60     
61     address public owner;
62     mapping (address => bool) whitelist;
63 
64     modifier onlyBy(address who) { require(msg.sender == who); _; }
65     modifier onlyOwner {require(msg.sender == owner); _;}
66     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
67 
68     function addToWhiteList(address trusted) public onlyOwner() {
69         whitelist[trusted] = true;
70     }
71 
72     function removeFromWhiteList(address untrusted) public onlyOwner() {
73         whitelist[untrusted] = false;
74     }
75 
76 }
77 
78 // ----------------------------------------------------------------------------
79 // CNTCommon contract
80 // ----------------------------------------------------------------------------
81 contract NRB_Common is WhiteListAccess {
82    
83     function NRB_Common() public { ETH_address = 0x1; }
84 
85     // Deployment
86     address public ETH_address;    // representation of Ether as Token (0x1)
87     address public TOKENS_address;  // NRB_Tokens
88     address public USERS_address;   // NRB_Users
89     address public FLC_address;     // Four Leaf Clover Token
90 
91     // Debug
92     event Debug(string, bool);
93     event Debug(string, uint);
94     event Debug(string, uint, uint);
95     event Debug(string, uint, uint, uint);
96     event Debug(string, uint, uint, uint, uint);
97     event Debug(string, address);
98     event Debug(string, address, address);
99 }
100 
101 // ----------------------------------------------------------------------------
102 // NRB_Main (main) contract
103 // ----------------------------------------------------------------------------
104 
105 contract NRB_Main is NRB_Common {
106     mapping(address => uint) raisedAmount;
107     bool _init;
108 
109     function NRB_Main() public {
110         _init = false;
111     }
112 
113     function init(address _tokens, address _users, address _flc) public {
114         require(!_init);
115         TOKENS_address = _tokens;
116         USERS_address = _users;
117         FLC_address = _flc;
118         NRB_Tokens(TOKENS_address).init(address(this), _flc);
119         NRB_Users(USERS_address).init(address(this), _flc);
120         _init = true;
121     }
122 
123     function isTokenRegistered(address _token) constant public returns (bool) {
124         return NRB_Tokens(TOKENS_address).isTokenRegistered(_token);
125     }
126 
127     function isInit() constant public returns (bool) {
128         return _init;
129     }
130 
131     // User Registration ------------------------------------------
132     function registerMeOnEther(string _json) payable public {
133         return registerMeOnTokenCore(ETH_address, msg.sender, msg.value, _json);
134     }
135 
136     function registerMeOnToken(address _token, uint _value, string _json) public {
137         return registerMeOnTokenCore(_token, msg.sender, _value, _json);
138     }
139 
140     function registerMeOnTokenCore(address _token, address _user, uint _value, string _json) internal {
141         require(this.isTokenRegistered(_token));
142 
143 
144         // CrowdSale is over so we redirect gains to the owner
145         if (_token != ETH_address) {
146             ERC20Interface(_token).transferFrom(_user, address(this), _value);
147         }
148 
149         raisedAmount[_token] = raisedAmount[_token] + _value;
150 
151         uint _credit = NRB_Users(USERS_address).getUserTotalCredit(_user, _token);
152         uint _totalpaid = NRB_Users(USERS_address).getUserTotalPaid(_user, _token) + _value - _credit;
153         uint flc = NRB_Tokens(TOKENS_address).sendFLC(_user, _token, _totalpaid);
154 
155         NRB_Users(USERS_address).registerUserOnToken(_token, _user, _value, flc,_json);
156         NRB_Tokens(TOKENS_address).registerTokenPayment(_token,_value);
157     }
158 
159     function getRaisedAmountOnEther() constant public returns (uint) {
160         return this.getRaisedAmountOnToken(ETH_address);
161     }
162 
163     function getRaisedAmountOnToken(address _token) constant public returns (uint) {
164         return raisedAmount[_token];
165     }
166 
167     function getUserIndexOnEther(address _user) constant public returns (uint) {
168         return NRB_Users(USERS_address).getUserIndexOnEther(_user);
169     }
170 
171     function getUserIndexOnToken(address _token, address _user) constant public returns (uint) {
172         return NRB_Users(USERS_address).getUserIndexOnToken(_token, _user);
173     }
174 
175     function getUserLengthOnEther() constant public returns (uint) {
176         return NRB_Users(USERS_address).getUserLengthOnEther();
177     }
178 
179     function getUserLengthOnToken(address _token) constant public returns (uint) {
180         return NRB_Users(USERS_address).getUserLengthOnToken(_token);
181     }
182 
183     function getUserNumbersOnEther(uint _index) constant public returns (uint, uint, uint, uint, uint) {
184         return getUserNumbersOnToken(ETH_address, _index);
185     }
186 
187     function getUserNumbersOnToken(address _token, uint _index) constant public returns (uint, uint, uint, uint, uint) {
188         address _user;
189         uint _time; uint _userid; uint _userindex; uint _paid;
190         (_time, _userid, _userindex, _paid, _user) = NRB_Users(USERS_address).getUserNumbersOnToken(_token, _index);
191         uint _balance = _paid * 10;
192         uint _userbalance = getUserBalanceOnToken(_token, _user);
193         if (_userbalance < _balance) {
194             _balance = _userbalance;
195         }
196         return (_time, _balance, _paid, _userid, _userindex);
197     }
198 
199 
200     function getUserBalanceOnEther(address _user) constant public returns (uint) {
201         return this.getUserBalanceOnToken(ETH_address, _user);
202     }
203 
204     function getUserBalanceOnToken(address _token, address _user) constant public returns (uint) {
205         if (_token == ETH_address) {
206             return _user.balance;
207         } else {
208             return ERC20Interface(_token).balanceOf(_user);
209         }
210     }
211     
212     // control funcitons only the owner may call them -------------------------------------
213 
214     function _realBalanceOnEther() constant public returns (uint) {
215         return this.getUserBalanceOnToken(ETH_address, address(this));
216     }
217 
218     function _realBalanceOnToken(address _token) constant public returns (uint) {
219         return this.getUserBalanceOnToken(_token, address(this));
220     }
221 
222     function _withdrawal() public {
223         address _addrs;
224         uint _length = NRB_Tokens(TOKENS_address).getTokenListLength();
225         uint _balance;
226         for (uint i = 0; i<_length; i++) {
227             _addrs = NRB_Tokens(TOKENS_address).getTokenAddressByIndex(i);
228             if (_addrs == ETH_address) {continue;}
229             _balance = ERC20Interface(_addrs).balanceOf(address(this));
230             if (_balance > 0) {
231                 ERC20Interface(_addrs).transfer(owner, _balance);
232             }
233         }
234         owner.transfer(this.balance);
235     }
236 
237 }
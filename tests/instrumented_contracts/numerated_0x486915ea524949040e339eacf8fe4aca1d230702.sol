1 pragma solidity ^0.4.15;
2 
3 contract ERC20 {
4     function totalSupply() external constant returns (uint256 _totalSupply);
5     function balanceOf(address _owner) external constant returns (uint256 balance);
6     function userTransfer(address _to, uint256 _value) external returns (bool success);
7     function userTransferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function userApprove(address _spender, uint256 _old, uint256 _new) external returns (bool success);
9     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 
13     function ERC20() internal {
14     }
15 }
16 
17 library SafeMath {
18     uint256 constant private    MAX_UINT256     = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
19 
20     function safeAdd (uint256 x, uint256 y) internal pure returns (uint256 z) {
21         assert (x <= MAX_UINT256 - y);
22         return x + y;
23     }
24 
25     function safeSub (uint256 x, uint256 y) internal pure returns (uint256 z) {
26         assert (x >= y);
27         return x - y;
28     }
29 
30     function safeMul (uint256 x, uint256 y) internal pure returns (uint256 z) {
31         z = x * y;
32         assert(x == 0 || z / x == y);
33     }
34 
35     function safeDiv (uint256 x, uint256 y) internal pure returns (uint256 z) {
36         z = x / y;
37         return z;
38     }
39 }
40 
41 contract AutoCoin is ERC20 {
42 
43     using SafeMath for uint256;
44 
45     address public              owner;
46     address private             subowner;
47 
48     uint256 private             summarySupply;
49     uint256 public              weiPerMinToken;
50 
51     string  public              name = "Auto Token";
52     string  public              symbol = "ATK";
53     uint8   public              decimals = 2;
54 
55     bool    public              contractEnable = true;
56     bool    public              transferEnable = false;
57 
58 
59     mapping(address => uint8)                        private   group;
60     mapping(address => uint256)                      private   accounts;
61     mapping(address => mapping (address => uint256)) private   allowed;
62 
63     event EvGroupChanged(address _address, uint8 _oldgroup, uint8 _newgroup);
64     event EvTokenAdd(uint256 _value, uint256 _lastSupply);
65     event EvTokenRm(uint256 _delta, uint256 _value, uint256 _lastSupply);
66     event EvLoginfo(string _functionName, string _text);
67     event EvMigration(address _address, uint256 _balance, uint256 _secret);
68 
69     struct groupPolicy {
70         uint8 _default;
71         uint8 _backend;
72         uint8 _migration;
73         uint8 _admin;
74         uint8 _subowner;
75         uint8 _owner;
76     }
77 
78     groupPolicy private currentState = groupPolicy(0, 3, 9, 4, 2, 9);
79 
80     function AutoCoin(string _name, string _symbol, uint8 _decimals, uint256 _weiPerMinToken, uint256 _startTokens) public {
81         owner = msg.sender;
82         group[msg.sender] = 9;
83 
84         if (_weiPerMinToken != 0)
85             weiPerMinToken = _weiPerMinToken;
86 
87         accounts[owner]  = _startTokens;
88         summarySupply    = _startTokens;
89         name = _name;
90         symbol = _symbol;
91         decimals = _decimals;
92     }
93 
94     modifier minGroup(int _require) {
95         require(group[msg.sender] >= _require);
96         _;
97     }
98 
99     modifier onlyPayloadSize(uint size) {
100         assert(msg.data.length >= size + 4);
101         _;
102     }
103 
104     function serviceGroupChange(address _address, uint8 _group) minGroup(currentState._admin) external returns(uint8) {
105         uint8 old = group[_address];
106         if(old <= currentState._admin) {
107             group[_address] = _group;
108             EvGroupChanged(_address, old, _group);
109         }
110         return group[_address];
111     }
112 
113     function serviceGroupGet(address _check) minGroup(currentState._backend) external constant returns(uint8 _group) {
114         return group[_check];
115     }
116 
117 
118     function settingsSetWeiPerMinToken(uint256 _weiPerMinToken) minGroup(currentState._admin) external {
119         if (_weiPerMinToken > 0) {
120             weiPerMinToken = _weiPerMinToken;
121 
122             EvLoginfo("[weiPerMinToken]", "changed");
123         }
124     }
125 
126     function serviceIncreaseBalance(address _who, uint256 _value) minGroup(currentState._backend) external returns(bool) {
127         accounts[_who] = accounts[_who].safeAdd(_value);
128         summarySupply = summarySupply.safeAdd(_value);
129 
130         EvTokenAdd(_value, summarySupply);
131         return true;
132     }
133 
134     function serviceDecreaseBalance(address _who, uint256 _value) minGroup(currentState._backend) external returns(bool) {
135         accounts[_who] = accounts[_who].safeSub(_value);
136         summarySupply = summarySupply.safeSub(_value);
137 
138         EvTokenRm(accounts[_who], _value, summarySupply);
139         return true;
140     }
141 
142     function serviceTokensBurn(address _address) external minGroup(currentState._backend) returns(uint256 balance) {
143         accounts[_address] = 0;
144         return accounts[_address];
145     }
146 
147     function serviceChangeOwner(address _newowner) minGroup(currentState._subowner) external returns(address) {
148         address temp;
149         uint256 value;
150 
151         if (msg.sender == owner) {
152             subowner = _newowner;
153             group[msg.sender] = currentState._subowner;
154             group[_newowner] = currentState._subowner;
155 
156             EvGroupChanged(_newowner, currentState._owner, currentState._subowner);
157         }
158 
159         if (msg.sender == subowner) {
160             temp = owner;
161             value = accounts[owner];
162 
163             accounts[owner] = accounts[owner].safeSub(value);
164             accounts[subowner] = accounts[subowner].safeAdd(value);
165 
166             owner = subowner;
167 
168             delete group[temp];
169             group[subowner] = currentState._owner;
170 
171             subowner = 0x00;
172 
173             EvGroupChanged(_newowner, currentState._subowner, currentState._owner);
174         }
175 
176         return subowner;
177     }
178 
179     function userTransfer(address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) external returns (bool success) {
180         if (accounts[msg.sender] >= _value && (transferEnable || group[msg.sender] >= currentState._backend)) {
181             accounts[msg.sender] = accounts[msg.sender].safeSub(_value);
182             accounts[_to] = accounts[_to].safeAdd(_value);
183             Transfer(msg.sender, _to, _value);
184             return true;
185         } else {
186             return false;
187         }
188     }
189 
190     function userTransferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(64) minGroup(currentState._default) external returns (bool success) {
191         if ((accounts[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (transferEnable || group[msg.sender] >= currentState._backend)) {
192             accounts[_from] = accounts[_from].safeSub(_value);
193             allowed[_from][msg.sender] = allowed[_from][msg.sender].safeSub(_value);
194             accounts[_to] = accounts[_to].safeAdd(_value);
195             Transfer(_from, _to, _value);
196             return true;
197         } else {
198             return false;
199         }
200     }
201 
202     function userApprove(address _spender, uint256 _old, uint256 _new) onlyPayloadSize(64) minGroup(currentState._default) external returns (bool success) {
203         if (_old == allowed[msg.sender][_spender]) {
204             allowed[msg.sender][_spender] = _new;
205             Approval(msg.sender, _spender, _new);
206             return true;
207         } else {
208             return false;
209         }
210     }
211 
212     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
213         return allowed[_owner][_spender];
214     }
215 
216     function balanceOf(address _owner) external constant returns (uint256 balance) {
217         if (_owner == 0x00)
218             return accounts[msg.sender];
219         return accounts[_owner];
220     }
221 
222     function totalSupply() external constant returns (uint256 _totalSupply) {
223         _totalSupply = summarySupply;
224     }
225 
226     function destroy() minGroup(currentState._owner) external {
227         selfdestruct(owner);
228     }
229 
230     function settingsSwitchState() external minGroup(currentState._owner) returns (bool state) {
231 
232         if(contractEnable) {
233             currentState._default = 9;
234             currentState._migration = 0;
235             contractEnable = false;
236         } else {
237             currentState._default = 0;
238             currentState._migration = 9;
239             contractEnable = true;
240         }
241 
242         return contractEnable;
243     }
244 
245     function settingsSwitchTransferAccess() external minGroup(currentState._backend) returns (bool access) {
246         transferEnable = !transferEnable;
247         return transferEnable;
248     }
249 
250     function userMigration(uint256 _secrect) external minGroup(currentState._migration) returns (bool successful) {
251 
252         uint256 balance = accounts[msg.sender];
253         if (balance > 0) {
254             accounts[msg.sender] = accounts[msg.sender].safeSub(balance);
255             accounts[owner] = accounts[owner].safeAdd(balance);
256             EvMigration(msg.sender, balance, _secrect);
257             return true;
258         }
259         else
260             return false;
261     }
262 }
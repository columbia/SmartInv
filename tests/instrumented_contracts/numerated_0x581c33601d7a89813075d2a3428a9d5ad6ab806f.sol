1 pragma solidity ^0.4.24;
2 
3 contract Manager {
4     address public owner;
5     address public newOwner;
6 
7     address public manager;
8     address public newManager;
9 
10     event TransferOwnership(address oldaddr, address newaddr);
11     event TransferManager(address oldaddr, address newaddr);
12 
13     modifier onlyOwner() {require(msg.sender == owner);
14         _;}
15     modifier onlyAdmin() {require(msg.sender == owner || msg.sender == manager);
16         _;}
17 
18 
19     constructor() public {
20         owner = msg.sender;
21         manager = msg.sender;
22     }
23 
24     function transferOwnership(address _newOwner) onlyOwner public {
25         newOwner = _newOwner;
26     }
27 
28     function transferManager(address _newManager) onlyAdmin public {
29         newManager = _newManager;
30     }
31 
32     function acceptOwnership() public {
33         require(msg.sender == newOwner);
34         address oldaddr = owner;
35         owner = newOwner;
36         newOwner = address(0);
37         emit TransferOwnership(oldaddr, owner);
38     }
39 
40     function acceptManager() public {
41         require(msg.sender == newManager);
42         address oldaddr = manager;
43         manager = newManager;
44         newManager = address(0);
45         emit TransferManager(oldaddr, manager);
46     }
47 }
48 
49 
50 library SafeMath {
51 
52     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53         if (_a == 0) {
54             return 0;
55         }
56         uint256 c = _a * _b;
57         require(c / _a == _b);
58 
59         return c;
60     }
61 
62     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
63         require(_b > 0);
64         uint256 c = _a / _b;
65 
66         return c;
67     }
68 
69     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
70         require(_b <= _a);
71         uint256 c = _a - _b;
72 
73         return c;
74     }
75 
76     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
77         uint256 c = _a + _b;
78         require(c >= _a);
79 
80         return c;
81     }
82 
83     function mod(uint256 _a, uint256 _b) internal pure returns (uint256) {
84         require(_b != 0);
85         return _a % _b;
86     }
87 }
88 
89 // ----------------------------------------------------------------------------
90 // ERC Token Standard #20 Interface
91 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
92 // ----------------------------------------------------------------------------
93 contract ERC20Interface {
94     function totalSupply() public view returns (uint256);
95 
96     function balanceOf(address _owner) public view returns (uint256 balance);
97 
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
99 
100     function transfer(address _to, uint256 _value) public returns (bool success);
101 
102     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
103 
104     function approve(address _spender, uint256 _value) public returns (bool success);
105 
106     event Transfer(address indexed from, address indexed to, uint tokens);
107     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
108 }
109 
110 
111 contract ReentrancyGuard {
112     uint256 private guardCounter = 1;
113 
114     modifier noReentrant() {
115         guardCounter += 1;
116         uint256 localCounter = guardCounter;
117         _;
118         require(localCounter == guardCounter);
119     }
120 }
121 
122 
123 interface tokenRecipient {
124     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
125 }
126 
127 
128 contract ERC20Base is ERC20Interface, ReentrancyGuard {
129     using SafeMath for uint256;
130 
131     string public name;
132     string public symbol;
133     uint8 public decimals = 18;
134     uint256 public totalSupply;
135 
136     mapping(address => uint256) public balanceOf;
137     mapping(address => mapping(address => uint256)) public allowance;
138 
139     constructor() public {}
140 
141     function() payable public {
142         revert();
143     }
144 
145     function totalSupply() public view returns (uint256) {
146         return totalSupply;
147     }
148 
149     function balanceOf(address _owner) public view returns (uint256 balance) {
150         return balanceOf[_owner];
151     }
152 
153     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
154         return allowance[_owner][_spender];
155     }
156 
157     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
158         require(_to != 0x0);
159         require(balanceOf[_from] >= _value);
160         if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
161             revert();
162         }
163 
164         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
165         balanceOf[_from] = balanceOf[_from].sub(_value);
166         balanceOf[_to] = balanceOf[_to].add(_value);
167         emit Transfer(_from, _to, _value);
168         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
169 
170         return true;
171     }
172 
173     function transfer(address _to, uint256 _value) public returns (bool success) {
174         return _transfer(msg.sender, _to, _value);
175     }
176 
177     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
178         require(_value <= allowance[_from][msg.sender]);
179         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
180         return _transfer(_from, _to, _value);
181     }
182 
183     function approve(address _spender, uint256 _value) public returns (bool success) {
184         allowance[msg.sender][_spender] = _value;
185         emit Approval(msg.sender, _spender, _value);
186         return true;
187     }
188 
189     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
190         allowance[msg.sender][_spender] = (
191         allowance[msg.sender][_spender].add(_addedValue));
192         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
193         return true;
194     }
195 
196     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
197         uint256 oldValue = allowance[msg.sender][_spender];
198         if (_subtractedValue >= oldValue) {
199             allowance[msg.sender][_spender] = 0;
200         } else {
201             allowance[msg.sender][_spender] = oldValue.sub(_subtractedValue);
202         }
203         emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
204         return true;
205     }
206 
207     function approveAndCall(address _spender, uint256 _value, bytes _extraData) noReentrant public returns (bool success) {
208         tokenRecipient spender = tokenRecipient(_spender);
209         if (approve(_spender, _value)) {
210             spender.receiveApproval(msg.sender, _value, this, _extraData);
211             return true;
212         }
213     }
214 }
215 
216 contract ManualToken is Manager, ERC20Base {
217     bool public isTokenLocked;
218     bool public isUseFreeze;
219 
220     struct Frozen {
221         uint256 amount;
222     }
223 
224     mapping(address => Frozen) public frozenAccount;
225 
226     event FrozenFunds(address indexed target, uint256 freezeAmount);
227 
228     constructor()
229     ERC20Base()
230     public
231     {
232         name = "GameChain";
233         symbol = "GCH";
234         totalSupply = 1000000000 * 1 ether;
235         isUseFreeze = true;
236         isTokenLocked = false;
237         balanceOf[msg.sender] = totalSupply;
238         emit Transfer(address(0), msg.sender, totalSupply);
239     }
240 
241     modifier tokenLock() {
242         require(isTokenLocked == false);
243         _;
244     }
245 
246     function setLockToken(bool _lock) onlyOwner public {
247         isTokenLocked = _lock;
248     }
249 
250     function setUseFreeze(bool _useOrNot) onlyAdmin public {
251         isUseFreeze = _useOrNot;
252     }
253 
254     function freezeAmount(address target, uint256 amountFreeze) onlyAdmin public {
255         frozenAccount[target].amount = amountFreeze;
256         emit FrozenFunds(target, amountFreeze);
257     }
258 
259     function isFrozen(address target) public view returns (uint256) {
260         return frozenAccount[target].amount;
261     }
262 
263     function _transfer(address _from, address _to, uint256 _value) tokenLock internal returns (bool success) {
264         require(balanceOf[_from] >= _value);
265 
266         if (balanceOf[_to].add(_value) <= balanceOf[_to]) {
267             revert();
268         }
269 
270         if (isUseFreeze == true) {
271             require(balanceOf[_from].sub(_value)>=frozenAccount[_from].amount);
272         }
273 
274         balanceOf[_from] = balanceOf[_from].sub(_value);
275         balanceOf[_to] = balanceOf[_to].add(_value);
276         emit Transfer(_from, _to, _value);
277 
278         return true;
279     }
280 }
1 pragma solidity 0.4.25;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
7         if (_a == 0) {
8             return 0;
9         }
10 
11         uint256 c = _a * _b;
12         require(c / _a == _b);
13 
14         return c;
15     }
16 
17     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
18         require(_b > 0);
19         uint256 c = _a / _b;
20 
21         return c;
22     }
23 
24     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
25         require(_b <= _a);
26         uint256 c = _a - _b;
27 
28         return c;
29     }
30 
31     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
32         uint256 c = _a + _b;
33         require(c >= _a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 contract Ownable {
45     address public owner;
46 
47 
48     event OwnershipRenounced(address indexed previousOwner);
49     event OwnershipTransferred(
50         address indexed previousOwner,
51         address indexed newOwner
52     );
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function renounceOwnership() public onlyOwner {
64         emit OwnershipRenounced(owner);
65         owner = address(0);
66     }
67 
68     function transferOwnership(address _newOwner) public onlyOwner {
69         _transferOwnership(_newOwner);
70     }
71 
72     function _transferOwnership(address _newOwner) internal {
73         require(_newOwner != address(0));
74         emit OwnershipTransferred(owner, _newOwner);
75         owner = _newOwner;
76     }
77 }
78 
79 contract ERC20 {
80     function totalSupply() public view returns (uint256);
81 
82     function balanceOf(address _who) public view returns (uint256);
83 
84     function allowance(address _owner, address _spender)
85     public view returns (uint256);
86 
87     function transfer(address _to, uint256 _value) public returns (bool);
88 
89     function approve(address _spender, uint256 _value)
90     public returns (bool);
91 
92     function transferFrom(address _from, address _to, uint256 _value)
93     public returns (bool);
94 
95     event Transfer(
96         address indexed from,
97         address indexed to,
98         uint256 value
99     );
100 
101     event Approval(
102         address indexed owner,
103         address indexed spender,
104         uint256 value
105     );
106 }
107 
108 
109 
110 contract BIAT is ERC20, Ownable {
111     using SafeMath for uint256;
112 
113     mapping (address => uint256) public balances;
114 
115     mapping (address => mapping (address => uint256)) private allowed;
116 
117     uint256 private totalSupply_ = 15000000 * 10 ** 4;
118     uint256 private maxTotalSupply_ = 20000000 * 10 ** 4;
119 
120     address public crowdsale;
121 
122     string public constant name = "Bet It All Token";
123     string public constant symbol = "BIAT";
124     uint8 public constant decimals = 4;
125 
126     constructor() public {
127         balances[msg.sender] = totalSupply_;
128         emit Transfer(address(0), msg.sender, totalSupply_);
129     }
130 
131     function setAddressOfCrowdsale(address _address) external onlyOwner {
132         require(_address != 0x0);
133         crowdsale = _address;
134     }
135 
136     function totalSupply() public view returns (uint256) {
137         return totalSupply_;
138     }
139 
140     function balanceOf(address _owner) public view returns (uint256) {
141         return balances[_owner];
142     }
143 
144     function allowance(
145         address _owner,
146         address _spender
147     )
148     public
149     view
150     returns (uint256)
151     {
152         return allowed[_owner][_spender];
153     }
154 
155     function transfer(address _to, uint256 _value) public returns (bool) {
156         require(_value <= balances[msg.sender]);
157         require(_to != address(0));
158         balances[msg.sender] = balances[msg.sender].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         emit Transfer(msg.sender, _to, _value);
161         return true;
162     }
163 
164     function approve(address _spender, uint256 _value) public returns (bool) {
165         allowed[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170     function transferFrom(
171         address _from,
172         address _to,
173         uint256 _value
174     )
175     public
176     returns (bool)
177     {
178         require(_value <= balances[_from]);
179         require(_value <= allowed[_from][msg.sender]);
180         require(_to != address(0));
181 
182         balances[_from] = balances[_from].sub(_value);
183         balances[_to] = balances[_to].add(_value);
184         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
185         emit Transfer(_from, _to, _value);
186         return true;
187     }
188 
189     function increaseApproval(
190         address _spender,
191         uint256 _addedValue
192     )
193     public
194     returns (bool)
195     {
196         allowed[msg.sender][_spender] = (
197         allowed[msg.sender][_spender].add(_addedValue));
198         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199         return true;
200     }
201 
202     function decreaseApproval(
203         address _spender,
204         uint256 _subtractedValue
205     )
206     public
207     returns (bool)
208     {
209         uint256 oldValue = allowed[msg.sender][_spender];
210         if (_subtractedValue >= oldValue) {
211             allowed[msg.sender][_spender] = 0;
212         } else {
213             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214         }
215         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216         return true;
217     }
218 
219     function _mint(address account, uint256 value) internal {
220         require(account != 0);
221         totalSupply_ = totalSupply_.add(value);
222         balances[account] = balances[account].add(value);
223         emit Transfer(address(0), account, value);
224     }
225 
226     function mint(address to, uint256 value) public returns (bool) {
227         require(msg.sender == crowdsale);
228         require(totalSupply_.add(value) <= maxTotalSupply_);
229         _mint(to, value);
230         return true;
231     }
232 }
233 
234 
235 contract Crowdsale is Ownable {
236     using SafeMath for uint256;
237 
238     address public multisig;
239 
240     BIAT public token;
241 
242     uint public rate = 200;
243 
244     bool public paused;
245 
246     uint maxTotalSupplyBIAT = 20000000 * 10 ** 4;
247 
248     event Purchased(address indexed _addr, uint _amount);
249 
250     modifier isNotOnPause() {
251         require(!paused);
252         _;
253     }
254 
255     constructor(address _BIAT, address _multisig) public {
256         require(_BIAT != 0);
257         token = BIAT(_BIAT);
258         multisig = _multisig;
259     }
260 
261     function setRate(uint _newRate) public onlyOwner {
262         rate = _newRate;
263     }
264 
265     function() external payable {
266         buyTokens();
267     }
268 
269     function buyTokens() public isNotOnPause payable {
270 
271         uint256 amount = msg.value.mul(rate).div(10 ** 14);
272 
273         if (token.totalSupply() + amount >= maxTotalSupplyBIAT) {
274             amount = maxTotalSupplyBIAT - token.totalSupply();
275             uint256 cash = amount.mul(10 ** 14).div(rate);
276             uint256 cashBack = msg.value.sub(cash);
277             multisig.transfer(cash);
278             msg.sender.transfer(cashBack);
279             paused = true;
280         } else {
281             multisig.transfer(msg.value);
282         }
283 
284         token.mint(msg.sender, amount);
285         emit Purchased(msg.sender, amount);
286     }
287 
288     function getMyBalanceBIAT() external view returns(uint256) {
289         return token.balanceOf(msg.sender);
290     }
291 }
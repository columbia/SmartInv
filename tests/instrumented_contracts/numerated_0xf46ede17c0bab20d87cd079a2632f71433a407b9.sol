1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function sub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     if (!assertion) {
46       throw;
47     }
48   }
49 }
50 
51 contract PreICO {
52   function balanceOf(address _owner) constant returns (uint256);
53   function burnTokens(address _owner);
54 }
55 
56 contract ERC20Basic {
57   uint public totalSupply;
58   function balanceOf(address who) constant returns (uint);
59   function transfer(address to, uint value);
60   event Transfer(address indexed from, address indexed to, uint value);
61 }
62 
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) constant returns (uint);
65   function transferFrom(address from, address to, uint value);
66   function approve(address spender, uint value);
67   event Approval(address indexed owner, address indexed spender, uint value);
68 }
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint;
72 
73   mapping(address => uint) balances;
74 
75   /*
76    * Fix for the ERC20 short address attack  
77    */
78   modifier onlyPayloadSize(uint size) {
79      if(msg.data.length < size + 4) {
80        throw;
81      }
82      _;
83   }
84 
85   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89   }
90 
91   function balanceOf(address _owner) constant returns (uint balance) {
92     return balances[_owner];
93   }
94   
95 }
96 
97 contract StandardToken is BasicToken, ERC20 {
98 
99   mapping (address => mapping (address => uint)) allowed;
100 
101   function transferFrom(address _from, address _to, uint _value) {
102     var _allowance = allowed[_from][msg.sender];
103 
104     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
105     // if (_value > _allowance) throw;
106 
107     balances[_to] = balances[_to].add(_value);
108     balances[_from] = balances[_from].sub(_value);
109     allowed[_from][msg.sender] = _allowance.sub(_value);
110     Transfer(_from, _to, _value);
111   }
112 
113   function approve(address _spender, uint _value) {
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116   }
117 
118   function allowance(address _owner, address _spender) constant returns (uint remaining) {
119     return allowed[_owner][_spender];
120   }
121 
122 }
123 
124 contract ATL is StandardToken {
125 
126   string public name = "ATLANT Token";
127   string public symbol = "ATL";
128   uint public decimals = 18;
129   uint constant TOKEN_LIMIT = 150 * 1e6 * 1e18;
130 
131   address public ico;
132 
133   bool public tokensAreFrozen = true;
134 
135   function ATL(address _ico) {
136     ico = _ico;
137   }
138 
139   function mint(address _holder, uint _value) external {
140     require(msg.sender == ico);
141     require(_value != 0);
142     require(totalSupply + _value <= TOKEN_LIMIT);
143 
144     balances[_holder] += _value;
145     totalSupply += _value;
146     Transfer(0x0, _holder, _value);
147   }
148 
149   function unfreeze() external {
150     require(msg.sender == ico);
151     tokensAreFrozen = false;
152   }
153 
154   function transfer(address _to, uint _value) public {
155     require(!tokensAreFrozen);
156     super.transfer(_to, _value);
157   }
158 
159 
160   function transferFrom(address _from, address _to, uint _value) public {
161     require(!tokensAreFrozen);
162     super.transferFrom(_from, _to, _value);
163   }
164 
165 
166   function approve(address _spender, uint _value) public {
167     require(!tokensAreFrozen);
168     super.approve(_spender, _value);
169   }
170 }
171 
172 contract ICO {
173 
174   uint public constant MIN_TOKEN_PRICE = 425; // min atl per ETH
175   uint public constant TOKENS_FOR_SALE = 103548812 * 1e18;
176   uint public constant ATL_PER_ATP = 2; // Migration rate
177 
178   event Buy(address holder, uint atlValue);
179   event ForeignBuy(address holder, uint atlValue, string txHash);
180   event Migrate(address holder, uint atlValue);
181   event RunIco();
182   event PauseIco();
183   event FinishIco(address teamFund, address bountyFund);
184 
185   PreICO preICO;
186   ATL public atl;
187 
188   address public team;
189   address public tradeRobot;
190   modifier teamOnly { require(msg.sender == team); _; }
191   modifier robotOnly { require(msg.sender == tradeRobot); _; }
192 
193   uint public tokensSold = 0;
194 
195   enum IcoState { Created, Running, Paused, Finished }
196   IcoState icoState = IcoState.Created;
197 
198 
199   function ICO(address _team, address _preICO, address _tradeRobot) {
200     atl = new ATL(this);
201     preICO = PreICO(_preICO);
202     team = _team;
203     tradeRobot = _tradeRobot;
204   }
205 
206 
207   function() external payable {
208     buyFor(msg.sender);
209   }
210 
211 
212   function buyFor(address _investor) public payable {
213     require(icoState == IcoState.Running);
214     require(msg.value > 0);
215     uint _total = buy(_investor, msg.value * MIN_TOKEN_PRICE);
216     Buy(_investor, _total);
217   }
218 
219 
220   function getBonus(uint _value, uint _sold)
221     public constant returns (uint)
222   {
223     uint[8] memory _bonusPricePattern = [ 505, 495, 485, 475, 465, 455, 445, uint(435) ];
224     uint _step = TOKENS_FOR_SALE / 10;
225     uint _bonus = 0;
226 
227     for (uint8 i = 0; _value > 0 && i < _bonusPricePattern.length; ++i) {
228       uint _min = _step * i;
229       uint _max = _step * (i+1);
230 
231       if (_sold >= _min && _sold < _max) {
232         uint bonusedPart = min(_value, _max - _sold);
233         _bonus += bonusedPart * _bonusPricePattern[i] / MIN_TOKEN_PRICE - bonusedPart;
234         _value -= bonusedPart;
235         _sold += bonusedPart;
236       }
237     }
238 
239     return _bonus;
240   }
241 
242   function foreignBuy(address _investor, uint _atlValue, string _txHash)
243     external robotOnly
244   {
245     require(icoState == IcoState.Running);
246     require(_atlValue > 0);
247     uint _total = buy(_investor, _atlValue);
248     ForeignBuy(_investor, _total, _txHash);
249   }
250 
251 
252   function setRobot(address _robot) external teamOnly {
253     tradeRobot = _robot;
254   }
255 
256 
257   function migrateSome(address[] _investors) external robotOnly {
258     for (uint i = 0; i < _investors.length; i++)
259       doMigration(_investors[i]);
260   }
261 
262 
263   function startIco() external teamOnly {
264     require(icoState == IcoState.Created || icoState == IcoState.Paused);
265     icoState = IcoState.Running;
266     RunIco();
267   }
268 
269 
270   function pauseIco() external teamOnly {
271     require(icoState == IcoState.Running);
272     icoState = IcoState.Paused;
273     PauseIco();
274   }
275 
276 
277   function finishIco(
278     address _teamFund,
279     address _bountyFund
280   )
281     external teamOnly
282   {
283     require(icoState == IcoState.Running || icoState == IcoState.Paused);
284 
285     atl.mint(_teamFund, 22500000 * 1e18);
286     atl.mint(_bountyFund, 18750000 * 1e18);
287     atl.unfreeze();
288 
289     icoState = IcoState.Finished;
290     FinishIco(_teamFund, _bountyFund);
291   }
292 
293 
294   function withdrawEther(uint _value) external teamOnly {
295     team.transfer(_value);
296   }
297 
298 
299   function withdrawToken(address _tokenContract, uint _val) external teamOnly
300   {
301     ERC20 _tok = ERC20(_tokenContract);
302     _tok.transfer(team, _val);
303   }
304 
305 
306   function min(uint a, uint b) internal constant returns (uint) {
307     return a < b ? a : b;
308   }
309 
310 
311   function buy(address _investor, uint _atlValue) internal returns (uint) {
312     uint _bonus = getBonus(_atlValue, tokensSold);
313     uint _total = _atlValue + _bonus;
314 
315     require(tokensSold + _total <= TOKENS_FOR_SALE);
316 
317     atl.mint(_investor, _total);
318     tokensSold += _total;
319     return _total;
320   }
321 
322 
323   function doMigration(address _investor) internal {
324     uint _atpBalance = preICO.balanceOf(_investor);
325     require(_atpBalance > 0);
326 
327     preICO.burnTokens(_investor);
328 
329     uint _atlValue = _atpBalance * ATL_PER_ATP;
330     atl.mint(_investor, _atlValue);
331 
332     Migrate(_investor, _atlValue);
333   }
334 }
1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract ERC20Basic {
29 
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37 
38   using SafeMath for uint256;
39 
40   mapping(address => uint256) balances;
41 
42   function transfer(address _to, uint256 _value) public returns (bool) {
43     require(_to != address(0));
44 
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   function balanceOf(address _owner) public constant returns (uint256 balance) {
52     return balances[_owner];
53   }
54 }
55 
56 contract ERC20 is ERC20Basic {
57 
58   function allowance(address owner, address spender) public constant returns (uint256);
59   function transferFrom(address from, address to, uint256 value) public returns (bool);
60   function approve(address spender, uint256 value) public returns (bool);
61   event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) allowed;
67 
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70 
71     uint256 _allowance = allowed[_from][msg.sender];
72 
73     balances[_from] = balances[_from].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     allowed[_from][msg.sender] = _allowance.sub(_value);
76     Transfer(_from, _to, _value);
77     return true;
78   }
79 
80   function approve(address _spender, uint256 _value) public returns (bool) {
81     allowed[msg.sender][_spender] = _value;
82     Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
87     return allowed[_owner][_spender];
88   }
89 
90   function increaseApproval (address _spender, uint _addedValue)
91     returns (bool success) {
92     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
93     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
94     return true;
95   }
96 
97   function decreaseApproval (address _spender, uint _subtractedValue)
98     returns (bool success) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 }
109 
110 contract Ownable {
111 
112   address public owner;
113 
114   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116   function Ownable() {
117     owner = msg.sender;
118   }
119 
120   modifier onlyOwner() {
121     require(msg.sender == owner);
122     _;
123   }
124 
125   function transferOwnership(address newOwner) onlyOwner public {
126     require(newOwner != address(0));
127     OwnershipTransferred(owner, newOwner);
128     owner = newOwner;
129   }
130 }
131 
132 contract MintableToken is StandardToken, Ownable {
133 
134   event Mint(address indexed to, uint256 amount);
135   event MintFinished();
136 
137   bool public mintingFinished = false;
138 
139   modifier canMint() {
140     require(!mintingFinished);
141     _;
142   }
143 
144   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
145     totalSupply = totalSupply.add(_amount);
146     balances[_to] = balances[_to].add(_amount);
147     Mint(_to, _amount);
148     Transfer(0x0, _to, _amount);
149     return true;
150   }
151 
152   function finishMinting() onlyOwner public returns (bool) {
153     mintingFinished = true;
154     MintFinished();
155     return true;
156   }
157 }
158 
159 contract Crowdsale {
160 
161   using SafeMath for uint256;
162 
163   MintableToken public token;
164 
165   uint256 public startTime;
166   uint256 public endTime;
167 
168   address public wallet;
169 
170   uint256 public rate;
171 
172   uint256 public weiRaised;
173 
174   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
175 
176   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
177     require(_startTime >= now);
178     require(_endTime >= _startTime);
179     require(_rate > 0);
180     require(_wallet != 0x0);
181 
182     token = createTokenContract();
183     startTime = _startTime;
184     endTime = _endTime;
185     rate = _rate;
186     wallet = _wallet;
187   }
188 
189   function createTokenContract() internal returns (MintableToken) {
190     return new MintableToken();
191   }
192 
193   function () payable {
194     buyTokens(msg.sender);
195   }
196 
197   function buyTokens(address beneficiary) public payable {
198     require(beneficiary != 0x0);
199     require(validPurchase());
200 
201     uint256 weiAmount = msg.value;
202 
203     uint256 tokens = weiAmount.mul(rate);
204 
205     weiRaised = weiRaised.add(weiAmount);
206 
207     token.mint(beneficiary, tokens);
208     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
209 
210     forwardFunds();
211   }
212 
213   function forwardFunds() internal {
214     wallet.transfer(msg.value);
215   }
216 
217   function validPurchase() internal constant returns (bool) {
218     bool withinPeriod = now >= startTime && now <= endTime;
219     bool nonZeroPurchase = msg.value != 0;
220     return withinPeriod && nonZeroPurchase;
221   }
222 
223   function hasEnded() public constant returns (bool) {
224     return now > endTime;
225   }
226 }
227 
228 contract CappedCrowdsale is Crowdsale {
229 
230   using SafeMath for uint256;
231 
232   uint256 public cap;
233 
234   function CappedCrowdsale(uint256 _cap) {
235     require(_cap > 0);
236     cap = _cap;
237   }
238 
239   function validPurchase() internal constant returns (bool) {
240     bool withinCap = weiRaised.add(msg.value) <= cap;
241     return super.validPurchase() && withinCap;
242   }
243 
244   function hasEnded() public constant returns (bool) {
245     bool capReached = weiRaised >= cap;
246     return super.hasEnded() || capReached;
247   }
248 }
249 
250 contract FinalizableCrowdsale is Crowdsale, Ownable {
251 
252   using SafeMath for uint256;
253 
254   bool public isFinalized = false;
255 
256   event Finalized();
257 
258   function finalize() onlyOwner public {
259     require(!isFinalized);
260     require(hasEnded());
261 
262     finalization();
263     Finalized();
264 
265     isFinalized = true;
266   }
267 
268   function finalization() internal {
269   }
270 }
271 
272 contract RefundVault is Ownable {
273 
274   using SafeMath for uint256;
275 
276   enum State { Active, Refunding, Closed }
277 
278   mapping (address => uint256) public deposited;
279   address public wallet;
280   State public state;
281 
282   event Closed();
283   event RefundsEnabled();
284   event Refunded(address indexed beneficiary, uint256 weiAmount);
285 
286   function RefundVault(address _wallet) {
287     require(_wallet != 0x0);
288     wallet = _wallet;
289     state = State.Active;
290   }
291 
292   function deposit(address investor) onlyOwner public payable {
293     require(state == State.Active);
294     deposited[investor] = deposited[investor].add(msg.value);
295   }
296 
297   function close() onlyOwner public {
298     require(state == State.Active);
299     state = State.Closed;
300     Closed();
301     wallet.transfer(this.balance);
302   }
303 
304   function enableRefunds() onlyOwner public {
305     require(state == State.Active);
306     state = State.Refunding;
307     RefundsEnabled();
308   }
309 
310   function refund(address investor) public {
311     require(state == State.Refunding);
312     uint256 depositedValue = deposited[investor];
313     deposited[investor] = 0;
314     investor.transfer(depositedValue);
315     Refunded(investor, depositedValue);
316   }
317 }
318 
319 contract RefundableCrowdsale is FinalizableCrowdsale {
320 
321   using SafeMath for uint256;
322 
323   uint256 public goal;
324 
325   RefundVault public vault;
326 
327   function RefundableCrowdsale(uint256 _goal) {
328     require(_goal > 0);
329     vault = new RefundVault(wallet);
330     goal = _goal;
331   }
332 
333   function forwardFunds() internal {
334     vault.deposit.value(msg.value)(msg.sender);
335   }
336 
337   function claimRefund() public {
338     require(isFinalized);
339     require(!goalReached());
340 
341     vault.refund(msg.sender);
342   }
343 
344   function finalization() internal {
345     if (goalReached()) {
346       vault.close();
347     } else {
348       vault.enableRefunds();
349     }
350 
351     super.finalization();
352   }
353 
354   function goalReached() public constant returns (bool) {
355     return weiRaised >= goal;
356   }
357 }
358 
359 contract Oryza is MintableToken {
360 
361   string public constant name = "Oryza";
362   string public constant symbol = "米";
363   uint256 public constant decimals = 0;
364 }
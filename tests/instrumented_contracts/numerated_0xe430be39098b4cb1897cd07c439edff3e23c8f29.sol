1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner public {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 }
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that throw on error
43  */
44 library SafeMath {
45   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint256 a, uint256 b) internal constant returns (uint256) {
52     // assert(b > 0); // Solidity automatically throws when dividing by 0
53     uint256 c = a / b;
54     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 /**
71  * @title Pausable
72  * @dev Base contract which allows children to implement an emergency stop mechanism.
73  */
74 contract Pausable is Ownable {
75   event Pause();
76   event Unpause();
77 
78   bool public paused = false;
79 
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is not paused.
83    */
84   modifier whenNotPaused() {
85     require(!paused);
86     _;
87   }
88 
89   /**
90    * @dev Modifier to make a function callable only when the contract is paused.
91    */
92   modifier whenPaused() {
93     require(paused);
94     _;
95   }
96 
97   /**
98    * @dev called by the owner to pause, triggers stopped state
99    */
100   function pause() onlyOwner whenNotPaused public {
101     paused = true;
102     Pause();
103   }
104 
105   /**
106    * @dev called by the owner to unpause, returns to normal state
107    */
108   function unpause() onlyOwner whenPaused public {
109     paused = false;
110     Unpause();
111   }
112 }
113 
114 contract Finalizable is Ownable {
115   bool public contractFinalized;
116 
117   modifier notFinalized() {
118     require(!contractFinalized);
119     _;
120   }
121 
122   function finalizeContract() onlyOwner {
123     contractFinalized = true;
124   }
125 }
126 
127 contract Shared is Ownable, Finalizable {
128   uint internal constant DECIMALS = 8;
129   
130   address internal constant REWARDS_WALLET = 0x30b002d3AfCb7F9382394f7c803faFBb500872D8;
131   address internal constant CROWDSALE_WALLET = 0x028e1Ce69E379b1678278640c7387ecc40DAa895;
132   address internal constant LIFE_CHANGE_WALLET = 0xEe4284f98D0568c7f65688f18A2F74354E17B31a;
133   address internal constant LIFE_CHANGE_VESTING_WALLET = 0x2D354bD67707223C9aC0232cd0E54f22b03483Cf;
134 }
135 
136 contract Ledger is Shared {
137   using SafeMath for uint;
138 
139   address public controller;
140   mapping(address => uint) public balanceOf;
141   mapping (address => mapping (address => uint)) public allowed;
142   uint public totalSupply;
143 
144   function setController(address _address) onlyOwner notFinalized {
145     controller = _address;
146   }
147 
148   modifier onlyController() {
149     require(msg.sender == controller);
150     _;
151   }
152 
153   function transfer(address _from, address _to, uint _value) onlyController returns (bool success) {
154     balanceOf[_from] = balanceOf[_from].sub(_value);
155     balanceOf[_to] = balanceOf[_to].add(_value);
156     return true;
157   }
158 
159   function transferFrom(address _spender, address _from, address _to, uint _value) onlyController returns (bool success) {
160     var _allowance = allowed[_from][_spender];
161     balanceOf[_to] = balanceOf[_to].add(_value);
162     balanceOf[_from] = balanceOf[_from].sub(_value);
163     allowed[_from][_spender] = _allowance.sub(_value);
164     return true;
165   }
166 
167   function approve(address _owner, address _spender, uint _value) onlyController returns (bool success) {
168     require((_value == 0) || (allowed[_owner][_spender] == 0));
169     allowed[_owner][_spender] = _value;
170     return true;
171   }
172 
173   function allowance(address _owner, address _spender) onlyController constant returns (uint remaining) {
174     return allowed[_owner][_spender];
175   }
176 
177   function burn(address _from, uint _amount) onlyController returns (bool success) {
178     balanceOf[_from] = balanceOf[_from].sub(_amount);
179     totalSupply = totalSupply.sub(_amount);
180     return true;
181   }
182 
183   function mint(address _to, uint _amount) onlyController returns (bool success) {
184     balanceOf[_to] += _amount;
185     totalSupply += _amount;
186     return true;
187   }
188 }
189 
190 contract Controller is Shared, Pausable {
191   using SafeMath for uint;
192 
193   bool public initialized;
194 
195   ChristCoin public token;
196   Ledger public ledger;
197   address public crowdsale;
198 
199   uint public vestingAmount;
200   uint public vestingPaid;
201   uint public vestingStart;
202   uint public vestingDuration;
203 
204   function Controller(address _token, address _ledger, address _crowdsale) {
205     token = ChristCoin(_token);
206     ledger = Ledger(_ledger);
207     crowdsale = _crowdsale;
208   }
209 
210   function setToken(address _address) onlyOwner notFinalized {
211     token = ChristCoin(_address);
212   }
213 
214   function setLedger(address _address) onlyOwner notFinalized {
215     ledger = Ledger(_address);
216   }
217 
218   function setCrowdsale(address _address) onlyOwner notFinalized {
219     crowdsale = _address;
220   }
221 
222   modifier onlyToken() {
223     require(msg.sender == address(token));
224     _;
225   }
226 
227   modifier onlyCrowdsale() {
228     require(msg.sender == crowdsale);
229     _;
230   }
231 
232   modifier onlyTokenOrCrowdsale() {
233     require(msg.sender == address(token) || msg.sender == crowdsale);
234     _;
235   }
236 
237   modifier notVesting() {
238     require(msg.sender != LIFE_CHANGE_VESTING_WALLET);
239     _;
240   }
241 
242   function init() onlyOwner {
243     require(!initialized);
244     mintWithEvent(REWARDS_WALLET, 9 * (10 ** (9 + DECIMALS))); // 9 billion
245     mintWithEvent(CROWDSALE_WALLET, 900 * (10 ** (6 + DECIMALS))); // 900 million
246     mintWithEvent(LIFE_CHANGE_WALLET, 100 * (10 ** (6 + DECIMALS))); // 100 million
247     initialized = true;
248   }
249 
250   function totalSupply() onlyToken constant returns (uint) {
251     return ledger.totalSupply();
252   }
253 
254   function balanceOf(address _owner) onlyTokenOrCrowdsale constant returns (uint) {
255     return ledger.balanceOf(_owner);
256   }
257 
258   function allowance(address _owner, address _spender) onlyToken constant returns (uint) {
259     return ledger.allowance(_owner, _spender);
260   }
261 
262   function transfer(address _from, address _to, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
263     return ledger.transfer(_from, _to, _value);
264   }
265 
266   function transferWithEvent(address _from, address _to, uint _value) onlyCrowdsale returns (bool success) {
267     success = ledger.transfer(_from, _to, _value);
268     if (success) {
269       token.controllerTransfer(msg.sender, _to, _value);
270     }
271   }
272 
273   function transferFrom(address _spender, address _from, address _to, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
274     return ledger.transferFrom(_spender, _from, _to, _value);
275   }
276 
277   function approve(address _owner, address _spender, uint _value) onlyToken notVesting whenNotPaused returns (bool success) {
278     return ledger.approve(_owner, _spender, _value);
279   }
280 
281   function burn(address _owner, uint _amount) onlyToken whenNotPaused returns (bool success) {
282     return ledger.burn(_owner, _amount);
283   }
284 
285   function mintWithEvent(address _to, uint _amount) internal returns (bool success) {
286     success = ledger.mint(_to, _amount);
287     if (success) {
288       token.controllerTransfer(0x0, _to, _amount);
289     }
290   }
291 
292   function startVesting(uint _amount, uint _duration) onlyCrowdsale {
293     require(vestingAmount == 0);
294     vestingAmount = _amount;
295     vestingPaid = 0;
296     vestingStart = now;
297     vestingDuration = _duration;
298   }
299 
300   function withdrawVested(address _withdrawTo) returns (uint amountWithdrawn) {
301     require(msg.sender == LIFE_CHANGE_VESTING_WALLET);
302     require(vestingAmount > 0);
303     
304     uint _elapsed = now.sub(vestingStart);
305     uint _rate = vestingAmount.div(vestingDuration);
306     uint _unlocked = _rate.mul(_elapsed);
307 
308     if (_unlocked > vestingAmount) {
309        _unlocked = vestingAmount;
310     }
311 
312     if (_unlocked <= vestingPaid) {
313       amountWithdrawn = 0;
314       return;
315     }
316 
317     amountWithdrawn = _unlocked.sub(vestingPaid);
318     vestingPaid = vestingPaid.add(amountWithdrawn);
319 
320     ledger.transfer(LIFE_CHANGE_VESTING_WALLET, _withdrawTo, amountWithdrawn);
321     token.controllerTransfer(LIFE_CHANGE_VESTING_WALLET, _withdrawTo, amountWithdrawn);
322   }
323 }
324 
325 contract ChristCoin is Shared {
326   using SafeMath for uint;
327 
328   string public name = "Christ Coin";
329   string public symbol = "CCLC";
330   uint8 public decimals = 8;
331 
332   Controller public controller;
333 
334   event Transfer(address indexed _from, address indexed _to, uint _value);
335   event Approval(address indexed _owner, address indexed _spender, uint _value);
336 
337   function setController(address _address) onlyOwner notFinalized {
338     controller = Controller(_address);
339   }
340 
341   modifier onlyController() {
342     require(msg.sender == address(controller));
343     _;
344   }
345 
346   function balanceOf(address _owner) constant returns (uint) {
347     return controller.balanceOf(_owner);
348   }
349 
350   function totalSupply() constant returns (uint) {
351     return controller.totalSupply();
352   }
353 
354   function transfer(address _to, uint _value) returns (bool success) {
355     success = controller.transfer(msg.sender, _to, _value);
356     if (success) {
357       Transfer(msg.sender, _to, _value);
358     }
359   }
360 
361   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
362     success = controller.transferFrom(msg.sender, _from, _to, _value);
363     if (success) {
364       Transfer(_from, _to, _value);
365     }
366   }
367 
368   function approve(address _spender, uint _value) returns (bool success) {
369     success = controller.approve(msg.sender, _spender, _value);
370     if (success) {
371       Approval(msg.sender, _spender, _value);
372     }
373   }
374 
375   function allowance(address _owner, address _spender) constant returns (uint) {
376     return controller.allowance(_owner, _spender);
377   }
378 
379   function burn(uint _amount) onlyOwner returns (bool success) {
380     success = controller.burn(msg.sender, _amount);
381     if (success) {
382       Transfer(msg.sender, 0x0, _amount);
383     }
384   }
385 
386   function controllerTransfer(address _from, address _to, uint _value) onlyController {
387     Transfer(_from, _to, _value);
388   }
389 
390   function controllerApproval(address _from, address _spender, uint _value) onlyController {
391     Approval(_from, _spender, _value);
392   }
393 }
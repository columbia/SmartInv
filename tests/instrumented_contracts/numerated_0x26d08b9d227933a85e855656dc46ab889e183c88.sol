1 pragma solidity ^0.4.15;
2 
3 contract PlaykeyICO {
4 
5   // Constants
6   // =========
7 
8   uint256 public constant tokensPerEth = 250; // PKT per ETH
9   uint256 public constant tokenLimit = 100 * 1e6 * 1e18;
10   uint256 public constant tokensForSale = tokenLimit * 60 / 100;
11   uint256 public presaleSold = 0;
12 
13 
14   // Events
15   // ======
16 
17   event RunIco();
18   event PauseIco();
19   event FinishIco(address team, address foundation, address advisors, address bounty);
20 
21 
22   // State variables
23   // ===============
24 
25   PKT public pkt;
26 
27   address public team;
28   modifier teamOnly { require(msg.sender == team); _; }
29 
30   enum IcoState { Presale, Running, Paused, Finished }
31   IcoState public icoState = IcoState.Presale;
32 
33 
34   // Constructor
35   // ===========
36 
37   function PlaykeyICO(address _team) {
38     team = _team;
39     pkt = new PKT(this, tokenLimit);
40   }
41 
42 
43   // Public functions
44   // ================
45 
46   // Here you can buy some tokens (just don't forget to provide enough gas).
47   function() external payable {
48     buyFor(msg.sender);
49   }
50 
51 
52   function buyFor(address _investor) public payable {
53     require(icoState == IcoState.Running);
54     require(msg.value > 0);
55     buy(_investor, msg.value);
56   }
57 
58 
59   function getPresaleTotal(uint256 _value) public constant returns (uint256) {
60     if(_value < 60 ether) {
61       return _value * tokensPerEth;
62     }
63 
64     if(_value >= 60 ether && _value < 150 ether) {
65       return calcPresaleDiscount(_value, 25);
66     }
67 
68     if(_value >= 150 ether && _value < 500 ether) {
69       return calcPresaleDiscount(_value, 30);
70     }
71 
72     if(_value >= 500 ether) {
73       return calcPresaleDiscount(_value, 35);
74     }
75   }
76 
77 
78   function getTotal(uint256 _value) public constant returns (uint256) {
79     uint256 _pktValue = _value * tokensPerEth;
80     uint256 _bonus = getBonus(_pktValue, pkt.totalSupply() - presaleSold);
81 
82     return _pktValue + _bonus;
83   }
84 
85 
86   function getBonus(uint256 _pktValue, uint256 _sold) public constant returns (uint256) {
87     uint256[8] memory _bonusPattern = [ uint256(150), 125, 100, 75, 50, 38, 25, 13 ];
88     uint256 _step = (tokensForSale - presaleSold) / 10;
89     uint256 _bonus = 0;
90 
91     for(uint8 i = 0; i < _bonusPattern.length; ++i) {
92       uint256 _min = _step * i;
93       uint256 _max = _step * (i + 1);
94       if(_sold >= _min && _sold < _max) {
95         uint256 _bonusPart = min(_pktValue, _max - _sold);
96         _bonus += _bonusPart * _bonusPattern[i] / 1000;
97         _pktValue -= _bonusPart;
98         _sold  += _bonusPart;
99       }
100     }
101 
102     return _bonus;
103   }
104 
105 
106   // Priveleged functions
107   // ====================
108 
109   function mintForEarlyInvestors(address[] _investors, uint256[] _values) external teamOnly {
110     require(_investors.length == _values.length);
111     for (uint256 i = 0; i < _investors.length; ++i) {
112       mintPresaleTokens(_investors[i], _values[i]);
113     }
114   }
115 
116 
117   function mintFor(address _investor, uint256 _pktValue) external teamOnly {
118     require(icoState != IcoState.Finished);
119     require(pkt.totalSupply() + _pktValue <= tokensForSale);
120 
121     pkt.mint(_investor, _pktValue);
122   }
123 
124 
125   function withdrawEther(uint256 _value) external teamOnly {
126     team.transfer(_value);
127   }
128 
129 
130   // Save tokens from contract
131   function withdrawToken(address _tokenContract, uint256 _value) external teamOnly {
132     ERC20 _token = ERC20(_tokenContract);
133     _token.transfer(team, _value);
134   }
135 
136 
137   function withdrawTokenFromPkt(address _tokenContract, uint256 _value) external teamOnly {
138     pkt.withdrawToken(_tokenContract, team, _value);
139   }
140 
141 
142   // ICO state management: start / pause / finish
143   // --------------------------------------------
144 
145   function startIco() external teamOnly {
146     require(icoState == IcoState.Presale || icoState == IcoState.Paused);
147     icoState = IcoState.Running;
148     RunIco();
149   }
150 
151 
152   function pauseIco() external teamOnly {
153     require(icoState == IcoState.Running);
154     icoState = IcoState.Paused;
155     PauseIco();
156   }
157 
158 
159   function finishIco(address _team, address _foundation, address _advisors, address _bounty) external teamOnly {
160     require(icoState == IcoState.Running || icoState == IcoState.Paused);
161 
162     icoState = IcoState.Finished;
163     uint256 _teamFund = pkt.totalSupply() * 2 / 3;
164 
165     uint256 _den = 10000;
166     pkt.mint(_team, _teamFund * 5000 / _den);
167     pkt.mint(_foundation, _teamFund * 3125 / _den);
168     pkt.mint(_advisors, _teamFund * 1500 / _den);
169     pkt.mint(_bounty, _teamFund - _teamFund * 9625 / _den);
170 
171     pkt.defrost();
172 
173     FinishIco(_team, _foundation, _advisors, _bounty);
174   }
175 
176 
177   // Private functions
178   // =================
179 
180   function mintPresaleTokens(address _investor, uint256 _value) internal {
181     require(icoState == IcoState.Presale);
182     require(_value > 0);
183 
184     uint256 _pktValue = getPresaleTotal(_value);
185 
186     require(pkt.totalSupply() + _pktValue <= tokensForSale);
187 
188     pkt.mint(_investor, _pktValue);
189     presaleSold += _pktValue;
190   }
191 
192 
193   function calcPresaleDiscount(uint256 _value, uint256 _percent) internal constant returns (uint256) {
194     return _value * tokensPerEth * 100 / (100 - _percent);
195   }
196 
197 
198   function min(uint256 a, uint256 b) internal constant returns (uint256) {
199     return a < b ? a : b;
200   }
201 
202 
203   function buy(address _investor, uint256 _value) internal {
204     uint256 _total = getTotal(_value);
205 
206     require(pkt.totalSupply() + _total <= tokensForSale);
207 
208     pkt.mint(_investor, _total);
209   }
210 }
211 
212 /**
213  * @title Math
214  * @dev Assorted math operations
215  */
216 
217 library Math {
218   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
219     return a >= b ? a : b;
220   }
221 
222   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
223     return a < b ? a : b;
224   }
225 
226   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
227     return a >= b ? a : b;
228   }
229 
230   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
231     return a < b ? a : b;
232   }
233 }
234 
235 /**
236  * @title SafeMath
237  * @dev Math operations with safety checks that throw on error
238  */
239 library SafeMath {
240   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
241     uint256 c = a * b;
242     assert(a == 0 || c / a == b);
243     return c;
244   }
245 
246   function div(uint256 a, uint256 b) internal constant returns (uint256) {
247     // assert(b > 0); // Solidity automatically throws when dividing by 0
248     uint256 c = a / b;
249     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250     return c;
251   }
252 
253   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
254     assert(b <= a);
255     return a - b;
256   }
257 
258   function add(uint256 a, uint256 b) internal constant returns (uint256) {
259     uint256 c = a + b;
260     assert(c >= a);
261     return c;
262   }
263 }
264 
265 /**
266  * @title ERC20Basic
267  * @dev Simpler version of ERC20 interface
268  * @dev see https://github.com/ethereum/EIPs/issues/179
269  */
270 contract ERC20Basic {
271   uint256 public totalSupply;
272   function balanceOf(address who) public constant returns (uint256);
273   function transfer(address to, uint256 value) public returns (bool);
274   event Transfer(address indexed from, address indexed to, uint256 value);
275 }
276 
277 /**
278  * @title ERC20 interface
279  * @dev see https://github.com/ethereum/EIPs/issues/20
280  */
281 contract ERC20 is ERC20Basic {
282   function allowance(address owner, address spender) public constant returns (uint256);
283   function transferFrom(address from, address to, uint256 value) public returns (bool);
284   function approve(address spender, uint256 value) public returns (bool);
285   event Approval(address indexed owner, address indexed spender, uint256 value);
286 }
287 
288 /**
289  * @title Basic token
290  * @dev Basic version of StandardToken, with no allowances.
291  */
292 contract BasicToken is ERC20Basic {
293   using SafeMath for uint256;
294 
295   mapping(address => uint256) balances;
296 
297   /**
298   * @dev transfer token for a specified address
299   * @param _to The address to transfer to.
300   * @param _value The amount to be transferred.
301   */
302   function transfer(address _to, uint256 _value) public returns (bool) {
303     require(_to != address(0));
304 
305     // SafeMath.sub will throw if there is not enough balance.
306     balances[msg.sender] = balances[msg.sender].sub(_value);
307     balances[_to] = balances[_to].add(_value);
308     Transfer(msg.sender, _to, _value);
309     return true;
310   }
311 
312   /**
313   * @dev Gets the balance of the specified address.
314   * @param _owner The address to query the the balance of.
315   * @return An uint256 representing the amount owned by the passed address.
316   */
317   function balanceOf(address _owner) public constant returns (uint256 balance) {
318     return balances[_owner];
319   }
320 
321 }
322 
323 /**
324  * @title Standard ERC20 token
325  *
326  * @dev Implementation of the basic standard token.
327  * @dev https://github.com/ethereum/EIPs/issues/20
328  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
329  */
330 contract StandardToken is ERC20, BasicToken {
331 
332   mapping (address => mapping (address => uint256)) allowed;
333 
334 
335   /**
336    * @dev Transfer tokens from one address to another
337    * @param _from address The address which you want to send tokens from
338    * @param _to address The address which you want to transfer to
339    * @param _value uint256 the amount of tokens to be transferred
340    */
341   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
342     require(_to != address(0));
343 
344     uint256 _allowance = allowed[_from][msg.sender];
345 
346     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
347     // require (_value <= _allowance);
348 
349     balances[_from] = balances[_from].sub(_value);
350     balances[_to] = balances[_to].add(_value);
351     allowed[_from][msg.sender] = _allowance.sub(_value);
352     Transfer(_from, _to, _value);
353     return true;
354   }
355 
356   /**
357    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
358    *
359    * Beware that changing an allowance with this method brings the risk that someone may use both the old
360    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
361    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
362    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
363    * @param _spender The address which will spend the funds.
364    * @param _value The amount of tokens to be spent.
365    */
366   function approve(address _spender, uint256 _value) public returns (bool) {
367     allowed[msg.sender][_spender] = _value;
368     Approval(msg.sender, _spender, _value);
369     return true;
370   }
371 
372   /**
373    * @dev Function to check the amount of tokens that an owner allowed to a spender.
374    * @param _owner address The address which owns the funds.
375    * @param _spender address The address which will spend the funds.
376    * @return A uint256 specifying the amount of tokens still available for the spender.
377    */
378   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
379     return allowed[_owner][_spender];
380   }
381 
382   /**
383    * approve should be called when allowed[_spender] == 0. To increment
384    * allowed value is better to use this function to avoid 2 calls (and wait until
385    * the first transaction is mined)
386    * From MonolithDAO Token.sol
387    */
388   function increaseApproval (address _spender, uint _addedValue)
389     returns (bool success) {
390     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
391     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
392     return true;
393   }
394 
395   function decreaseApproval (address _spender, uint _subtractedValue)
396     returns (bool success) {
397     uint oldValue = allowed[msg.sender][_spender];
398     if (_subtractedValue > oldValue) {
399       allowed[msg.sender][_spender] = 0;
400     } else {
401       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
402     }
403     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
404     return true;
405   }
406 
407 }
408 
409 contract PKT is StandardToken {
410 
411   // Constants
412   // =========
413 
414   string public constant name = "Playkey Token";
415   string public constant symbol = "PKT";
416   uint8 public constant decimals = 18;
417   uint256 public tokenLimit;
418 
419 
420   // State variables
421   // ===============
422 
423   address public ico;
424   modifier icoOnly { require(msg.sender == ico); _; }
425 
426   // Tokens are frozen until ICO ends.
427   bool public tokensAreFrozen = true;
428 
429 
430   // Constructor
431   // ===========
432 
433   function PKT(address _ico, uint256 _tokenLimit) {
434     ico = _ico;
435     tokenLimit = _tokenLimit;
436   }
437 
438 
439   // Priveleged functions
440   // ====================
441 
442   // Mint few tokens and transfer them to some address.
443   function mint(address _holder, uint256 _value) external icoOnly {
444     require(_holder != address(0));
445     require(_value != 0);
446     require(totalSupply + _value <= tokenLimit);
447 
448     balances[_holder] += _value;
449     totalSupply += _value;
450     Transfer(0x0, _holder, _value);
451   }
452 
453 
454   // Allow token transfer.
455   function defrost() external icoOnly {
456     tokensAreFrozen = false;
457   }
458 
459 
460   // Save tokens from contract
461   function withdrawToken(address _tokenContract, address where, uint256 _value) external icoOnly {
462     ERC20 _token = ERC20(_tokenContract);
463     _token.transfer(where, _value);
464   }
465 
466 
467   // ERC20 functions
468   // =========================
469 
470   function transfer(address _to, uint256 _value)  public returns (bool) {
471     require(!tokensAreFrozen);
472     return super.transfer(_to, _value);
473   }
474 
475 
476   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
477     require(!tokensAreFrozen);
478     return super.transferFrom(_from, _to, _value);
479   }
480 
481 
482   function approve(address _spender, uint256 _value) public returns (bool) {
483     require(!tokensAreFrozen);
484     return super.approve(_spender, _value);
485   }
486 }
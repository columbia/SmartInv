1 pragma solidity ^0.4.15;
2 
3 contract ElcoinICO {
4 
5   // Constants
6   // =========
7 
8   uint256 public constant tokensPerEth = 300; // ELC per ETH
9   uint256 public constant tokenLimit = 60 * 1e6 * 1e18;
10   uint256 public constant tokensForSale = tokenLimit * 50 / 100;
11   uint256 public presaleSold = 0;
12   uint256 public startTime = 1511038800; // 19 November 2017 18:00 UTC
13   uint256 public endTime = 1517778000; // 05 February 2018 18:00 UTC
14 
15   // Events
16   // ======
17 
18   event RunIco();
19   event PauseIco();
20   event FinishIco(address team, address foundation, address advisors, address bounty);
21 
22 
23   // State variables
24   // ===============
25 
26   ELC public elc;
27 
28   address public team;
29   modifier teamOnly { require(msg.sender == team); _; }
30 
31   enum IcoState { Presale, Running, Paused, Finished }
32   IcoState public icoState = IcoState.Presale;
33 
34 
35   // Constructor
36   // ===========
37 
38   function ElcoinICO(address _team) public {
39     team = _team;
40     elc = new ELC(this, tokenLimit);
41   }
42 
43 
44   // Public functions
45   // ================
46 
47   // Here you can buy some tokens (just don't forget to provide enough gas).
48   function() external payable {
49     buyFor(msg.sender);
50   }
51 
52 
53   function buyFor(address _investor) public payable {
54     require(icoState == IcoState.Running);
55     require(msg.value > 0);
56     buy(_investor, msg.value);
57   }
58 
59 
60   function getPresaleTotal(uint256 _value) public constant returns (uint256) {
61      if(_value < 10 ether) {
62       return _value * tokensPerEth;
63     }
64 
65     if(_value >= 10 ether && _value < 100 ether) {
66       return calcPresaleDiscount(_value, 3);
67     }
68 
69     if(_value >= 100 ether && _value < 1000 ether) {
70       return calcPresaleDiscount(_value, 5);
71     }
72 
73     if(_value >= 1000 ether) {
74       return calcPresaleDiscount(_value, 10);
75     }
76   }
77 
78 function getTimeBonus(uint time) public constant returns (uint) {
79         if (time < startTime + 1 weeks) return 200;
80         if (time < startTime + 2 weeks) return 150;
81         if (time < startTime + 3 weeks) return 100;
82         if (time < startTime + 4 weeks) return 50;
83         return 0;
84     }
85 
86   function getTotal(uint256 _value) public constant returns (uint256) {
87     uint256 _elcValue = _value * tokensPerEth;
88     uint256 _bonus = getBonus(_elcValue, elc.totalSupply() - presaleSold);
89 
90     return _elcValue + _bonus;
91   }
92 
93 
94   function getBonus(uint256 _elcValue, uint256 _sold) public constant returns (uint256) {
95     uint256[8] memory _bonusPattern = [ uint256(150), 130, 110, 90, 70, 50, 30, 10 ];
96     uint256 _step = (tokensForSale - presaleSold) / 10;
97     uint256 _bonus = 0;
98 
99     for(uint8 i = 0; i < _bonusPattern.length; ++i) {
100       uint256 _min = _step * i;
101       uint256 _max = _step * (i + 1);
102       if(_sold >= _min && _sold < _max) {
103         uint256 _bonusPart = min(_elcValue, _max - _sold);
104         _bonus += _bonusPart * _bonusPattern[i] / 1000;
105         _elcValue -= _bonusPart;
106         _sold  += _bonusPart;
107       }
108     }
109 
110     return _bonus;
111   }
112 
113 
114   // Priveleged functions
115   // ====================
116 
117   function mintForEarlyInvestors(address[] _investors, uint256[] _values) external teamOnly {
118     require(_investors.length == _values.length);
119     for (uint256 i = 0; i < _investors.length; ++i) {
120       mintPresaleTokens(_investors[i], _values[i]);
121     }
122   }
123 
124 
125   function mintFor(address _investor, uint256 _elcValue) external teamOnly {
126     require(icoState != IcoState.Finished);
127     require(elc.totalSupply() + _elcValue <= tokensForSale);
128 
129     elc.mint(_investor, _elcValue);
130   }
131 
132 
133   function withdrawEther(uint256 _value) external teamOnly {
134     team.transfer(_value);
135   }
136 
137 
138   // Save tokens from contract
139   function withdrawToken(address _tokenContract, uint256 _value) external teamOnly {
140     ERC20 _token = ERC20(_tokenContract);
141     _token.transfer(team, _value);
142   }
143 
144 
145   function withdrawTokenFromElc(address _tokenContract, uint256 _value) external teamOnly {
146     elc.withdrawToken(_tokenContract, team, _value);
147   }
148 
149 
150   // ICO state management: start / pause / finish
151   // --------------------------------------------
152 
153   function startIco() external teamOnly {
154     require(icoState == IcoState.Presale || icoState == IcoState.Paused);
155     icoState = IcoState.Running;
156     RunIco();
157   }
158 
159 
160   function pauseIco() external teamOnly {
161     require(icoState == IcoState.Running);
162     icoState = IcoState.Paused;
163     PauseIco();
164   }
165 
166 
167   function finishIco(address _team, address _foundation, address _advisors, address _bounty) external teamOnly {
168     require(icoState == IcoState.Running || icoState == IcoState.Paused);
169 
170     icoState = IcoState.Finished;
171     uint256 _teamFund = elc.totalSupply() * 2 / 2;
172 
173     uint256 _den = 10000;
174     elc.mint(_team, _teamFund * 4000 / _den);
175     elc.mint(_foundation, _teamFund * 4000 / _den);
176     elc.mint(_advisors, _teamFund * 1000 / _den);
177     elc.mint(_bounty, _teamFund  * 1000 / _den);
178 
179     elc.defrost();
180 
181     FinishIco(_team, _foundation, _advisors, _bounty);
182   }
183 
184 
185   // Private functions
186   // =================
187 
188   function mintPresaleTokens(address _investor, uint256 _value) internal {
189     require(icoState == IcoState.Presale);
190     require(_value > 0);
191 
192     uint256 _elcValue = getPresaleTotal(_value);
193 
194     uint256 timeBonusAmount = _elcValue * getTimeBonus(now) / 1000;
195 
196      _elcValue += timeBonusAmount;
197 
198     require(elc.totalSupply() + _elcValue <= tokensForSale);
199 
200     elc.mint(_investor, _elcValue);
201     presaleSold += _elcValue;
202   }
203 
204 
205   function calcPresaleDiscount(uint256 _value, uint256 _percent) internal constant returns (uint256) {
206     return _value * tokensPerEth * 100 / (100 - _percent);
207   }
208 
209   function min(uint256 a, uint256 b) internal constant returns (uint256) {
210     return a < b ? a : b;
211   }
212 
213   function buy(address _investor, uint256 _value) internal {
214     uint256 _total = getTotal(_value);
215 
216     require(elc.totalSupply() + _total <= tokensForSale);
217 
218     elc.mint(_investor, _total);
219   }
220 }
221 
222 library Math {
223   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
224     return a >= b ? a : b;
225   }
226 
227   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
228     return a < b ? a : b;
229   }
230 
231   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
232     return a >= b ? a : b;
233   }
234 
235   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
236     return a < b ? a : b;
237   }
238 }
239 
240 
241 // @title SafeMath * @dev Math operations with safety checks that throw on error
242  
243 library SafeMath {
244   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
245     uint256 c = a * b;
246     assert(a == 0 || c / a == b);
247     return c;
248   }
249 
250   function div(uint256 a, uint256 b) internal constant returns (uint256) {
251     // assert(b > 0); // Solidity automatically throws when dividing by 0
252     uint256 c = a / b;
253     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
254     return c;
255   }
256 
257   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
258     assert(b <= a);
259     return a - b;
260   }
261 
262   function add(uint256 a, uint256 b) internal constant returns (uint256) {
263     uint256 c = a + b;
264     assert(c >= a);
265     return c;
266   }
267 }
268 
269 
270 // @title ERC20Basic  * @dev Simpler version of ERC20 interface  * @dev see https://github.com/ethereum/EIPs/issues/179
271  
272 contract ERC20Basic {
273   uint256 public totalSupply;
274   function balanceOf(address who) public constant returns (uint256);
275   function transfer(address to, uint256 value) public returns (bool);
276   event Transfer(address indexed from, address indexed to, uint256 value);
277 }
278 
279 //  @title ERC20 interface  * @dev see https://github.com/ethereum/EIPs/issues/20
280  
281 contract ERC20 is ERC20Basic {
282   function allowance(address owner, address spender) public constant returns (uint256);
283   function transferFrom(address from, address to, uint256 value) public returns (bool);
284   function approve(address spender, uint256 value) public returns (bool);
285   event Approval(address indexed owner, address indexed spender, uint256 value);
286 }
287 
288 // @title Basic token  * @dev Basic version of StandardToken, with no allowances.
289  
290 contract BasicToken is ERC20Basic {
291   using SafeMath for uint256;
292 
293   mapping(address => uint256) balances;
294 
295   // @dev transfer token for a specified address   * @param _to The address to transfer to.   * @param _value The amount to be transferred.
296   
297   function transfer(address _to, uint256 _value) public returns (bool) {
298     require(_to != address(0));
299 
300     // SafeMath.sub will throw if there is not enough balance.
301     balances[msg.sender] = balances[msg.sender].sub(_value);
302     balances[_to] = balances[_to].add(_value);
303     Transfer(msg.sender, _to, _value);
304     return true;
305   }
306 
307   // @dev Gets the balance of the specified address.  * @param _owner The address to query the the balance of.
308   // @return An uint256 representing the amount owned by the passed address.
309   
310   function balanceOf(address _owner) public constant returns (uint256 balance) {
311     return balances[_owner];
312   }
313 
314 }
315 
316 //
317 // @title Standard ERC20 token
318 //
319 // @dev Implementation of the basic standard token.
320 // @dev https://github.com/ethereum/EIPs/issues/20
321 // @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
322  
323 contract StandardToken is ERC20, BasicToken {
324 
325   mapping (address => mapping (address => uint256)) allowed;
326 
327 
328    //
329    // @dev Transfer tokens from one address to another
330    // @param _from address The address which you want to send tokens from
331   // @param _to address The address which you want to transfer to
332    //* @param _value uint256 the amount of tokens to be transferred
333    
334   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
335     require(_to != address(0));
336 
337     uint256 _allowance = allowed[_from][msg.sender];
338 
339     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
340     // require (_value <= _allowance);
341 
342     balances[_from] = balances[_from].sub(_value);
343     balances[_to] = balances[_to].add(_value);
344     allowed[_from][msg.sender] = _allowance.sub(_value);
345     Transfer(_from, _to, _value);
346     return true;
347   }
348 
349   //
350    // @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
351    //
352    // Beware that changing an allowance with this method brings the risk that someone may use both the old
353    // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
354    // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
355    // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356    // @param _spender The address which will spend the funds.
357    // @param _value The amount of tokens to be spent.
358    
359   function approve(address _spender, uint256 _value) public returns (bool) {
360     allowed[msg.sender][_spender] = _value;
361     Approval(msg.sender, _spender, _value);
362     return true;
363   }
364 
365   // @dev Function to check the amount of tokens that an owner allowed to a spender.
366    // @param _owner address The address which owns the funds.
367    // @param _spender address The address which will spend the funds.
368    // @return A uint256 specifying the amount of tokens still available for the spender.
369    
370   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
371     return allowed[_owner][_spender];
372   }
373 
374  // approve should be called when allowed[_spender] == 0. To increment
375    // allowed value is better to use this function to avoid 2 calls (and wait until
376    // the first transaction is mined)
377    // From MonolithDAO Token.sol
378    
379    
380    
381   
382   function increaseApproval (address _spender, uint _addedValue)
383     public returns (bool success) {
384     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
385     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
386     return true;
387   }
388 
389   function decreaseApproval (address _spender, uint _subtractedValue)
390     public returns (bool success) {
391     uint oldValue = allowed[msg.sender][_spender];
392     if (_subtractedValue > oldValue) {
393       allowed[msg.sender][_spender] = 0;
394     } else {
395       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
396     }
397     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
398     return true;
399   }
400 
401 }
402 
403 contract ELC is StandardToken {
404 
405   // Constants
406   // =========
407 
408   string public constant name = "Elcoin Token";
409   string public constant symbol = "ELC";
410   uint8 public constant decimals = 18;
411   uint256 public tokenLimit;
412 
413 
414   // State variables
415   // ===============
416 
417   address public ico;
418   modifier icoOnly { require(msg.sender == ico); _; }
419 
420   // Tokens are frozen until ICO ends.
421   bool public tokensAreFrozen = true;
422 
423 
424   // Constructor
425   // ===========
426 
427   function ELC(address _ico, uint256 _tokenLimit) public {
428     ico = _ico;
429     tokenLimit = _tokenLimit;
430   }
431 
432 
433   // Priveleged functions
434   // ====================
435 
436   // Mint few tokens and transfer them to some address.
437   function mint(address _holder, uint256 _value) external icoOnly {
438     require(_holder != address(0));
439     require(_value != 0);
440     require(totalSupply + _value <= tokenLimit);
441 
442     balances[_holder] += _value;
443     totalSupply += _value;
444     Transfer(0x0, _holder, _value);
445   }
446 
447 
448   // Allow token transfer.
449   function defrost() external icoOnly {
450     tokensAreFrozen = false;
451   }
452 
453 
454   // Save tokens from contract
455   function withdrawToken(address _tokenContract, address where, uint256 _value) external icoOnly {
456     ERC20 _token = ERC20(_tokenContract);
457     _token.transfer(where, _value);
458   }
459 
460 
461   // ERC20 functions
462   // =========================
463 
464   function transfer(address _to, uint256 _value)  public returns (bool) {
465     require(!tokensAreFrozen);
466     return super.transfer(_to, _value);
467   }
468 
469 
470   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
471     require(!tokensAreFrozen);
472     return super.transferFrom(_from, _to, _value);
473   }
474 
475 
476   function approve(address _spender, uint256 _value) public returns (bool) {
477     require(!tokensAreFrozen);
478     return super.approve(_spender, _value);
479   }
480 }
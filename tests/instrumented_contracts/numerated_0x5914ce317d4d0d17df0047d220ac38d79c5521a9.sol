1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev modifier to allow actions only when the contract IS paused
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev modifier to allow actions only when the contract IS NOT paused
65    */
66   modifier whenPaused {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused returns (bool) {
75     paused = true;
76     Pause();
77     return true;
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused returns (bool) {
84     paused = false;
85     Unpause();
86     return true;
87   }
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a * b;
97     assert(a == 0 || c / a == b);
98     return c;
99   }
100 
101   function div(uint256 a, uint256 b) internal constant returns (uint256) {
102     // assert(b > 0); // Solidity automatically throws when dividing by 0
103     uint256 c = a / b;
104     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105     return c;
106   }
107 
108   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint256 a, uint256 b) internal constant returns (uint256) {
114     uint256 c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 
121 /**
122  * @title ERC20Basic
123  * @dev Simpler version of ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/179
125  */
126 contract ERC20Basic {
127   uint256 public totalSupply;
128   function balanceOf(address who) constant returns (uint256);
129   function transfer(address to, uint256 value) returns (bool);
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 }
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) constant returns (uint256);
139   function transferFrom(address from, address to, uint256 value) returns (bool);
140   function approve(address spender, uint256 value) returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 
145 
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) returns (bool) {
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     Transfer(msg.sender, _to, _value);
165     return true;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param _owner The address to query the the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address _owner) constant returns (uint256 balance) {
174     return balances[_owner];
175   }
176 
177 }
178 
179 
180 /**
181  * @title Standard ERC20 token
182  *
183  * @dev Implementation of the basic standard token.
184  * @dev https://github.com/ethereum/EIPs/issues/20
185  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
186  */
187 contract StandardToken is ERC20, BasicToken {
188 
189   mapping (address => mapping (address => uint256)) allowed;
190 
191 
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amout of tokens to be transfered
197    */
198   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
199     var _allowance = allowed[_from][msg.sender];
200 
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203 
204     balances[_to] = balances[_to].add(_value);
205     balances[_from] = balances[_from].sub(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    * @param _spender The address which will spend the funds.
214    * @param _value The amount of tokens to be spent.
215    */
216   function approve(address _spender, uint256 _value) returns (bool) {
217 
218     // To change the approve amount you first have to reduce the addresses`
219     //  allowance to zero by calling `approve(_spender, 0)` if it is not
220     //  already 0 to mitigate the race condition described here:
221     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
223 
224     allowed[msg.sender][_spender] = _value;
225     Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Function to check the amount of tokens that an owner allowed to a spender.
231    * @param _owner address The address which owns the funds.
232    * @param _spender address The address which will spend the funds.
233    * @return A uint256 specifing the amount of tokens still avaible for the spender.
234    */
235   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
236     return allowed[_owner][_spender];
237   }
238 
239 }
240 
241 
242 /**
243  * @title Mintable token
244  * @dev Simple ERC20 Token example, with mintable token creation
245  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
246  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
247  */
248 
249 contract MintableToken is StandardToken, Ownable {
250   event Mint(address indexed to, uint256 amount);
251   event MintFinished();
252 
253   bool public mintingFinished = false;
254 
255 
256   modifier canMint() {
257     require(!mintingFinished);
258     _;
259   }
260 
261   /**
262    * @dev Function to mint tokens
263    * @param _to The address that will recieve the minted tokens.
264    * @param _amount The amount of tokens to mint.
265    * @return A boolean that indicates if the operation was successful.
266    */
267   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
268     totalSupply = totalSupply.add(_amount);
269     balances[_to] = balances[_to].add(_amount);
270     Transfer(0X0, _to, _amount);
271     return true;
272   }
273 
274   /**
275    * @dev Function to stop minting new tokens.
276    * @return True if the operation was successful.
277    */
278   function finishMinting() onlyOwner returns (bool) {
279     mintingFinished = true;
280     MintFinished();
281     return true;
282   }
283 }
284 
285 
286 
287 contract HydroCoin is MintableToken, Pausable {
288   string public name = "H2O Token";
289   string public symbol = "H2O";
290   uint256 public decimals = 18;
291 
292   //----- splitter functions
293 
294 
295     event Ev(string message, address whom, uint256 val);
296 
297     struct XRec {
298         bool inList;
299         address next;
300         address prev;
301         uint256 val;
302     }
303 
304     struct QueueRecord {
305         address whom;
306         uint256 val;
307     }
308 
309     address public first = 0x0;
310     address public last = 0x0;
311     bool    public queueMode;
312     uint256 public pos;
313 
314     mapping (address => XRec) public theList;
315 
316     QueueRecord[]  theQueue;
317 
318     function startQueueing() onlyOwner {
319         queueMode = true;
320         pos = 0;
321     }
322 
323     function stopQueueing(uint256 num) onlyOwner {
324         queueMode = false;
325         for (uint256 i = 0; i < num; i++) {
326             if (pos >= theQueue.length) {
327                 delete theQueue;
328                 return;
329             }
330             update(theQueue[pos].whom,theQueue[pos].val);
331             pos++;
332         }
333         queueMode = true;
334     } 
335 
336    function queueLength() constant returns (uint256) {
337         return theQueue.length;
338     }
339 
340     function addRecToQueue(address whom, uint256 val) internal {
341         theQueue.push(QueueRecord(whom,val));
342     }
343 
344     // add a record to the END of the list
345     function add(address whom, uint256 value) internal {
346         theList[whom] = XRec(true,0x0,last,value);
347         if (last != 0x0) {
348             theList[last].next = whom;
349         } else {
350             first = whom;
351         }
352         last = whom;
353         Ev("add",whom,value);
354     }
355 
356     function remove(address whom) internal {
357         if (first == whom) {
358             first = theList[whom].next;
359             theList[whom] = XRec(false,0x0,0x0,0);
360             return;
361         }
362         address next = theList[whom].next;
363         address prev = theList[whom].prev;
364         if (prev != 0x0) {
365             theList[prev].next = next;
366         }
367         if (next != 0x0) {
368             theList[next].prev = prev;
369         }
370         theList[whom] =XRec(false,0x0,0x0,0);
371         Ev("remove",whom,0);
372     }
373 
374     function update(address whom, uint256 value) internal {
375         if (queueMode) {
376             addRecToQueue(whom,value);
377             return;
378         }
379         if (value != 0) {
380             if (!theList[whom].inList) {
381                 add(whom,value);
382             } else {
383                 theList[whom].val = value;
384                 Ev("update",whom,value);
385             }
386             return;
387         }
388         if (theList[whom].inList) {
389                 remove(whom);
390         }
391     }
392 
393 
394 
395 
396 // ----- H20 stuff -----
397 
398 
399   /**
400    * @dev Allows anyone to transfer the H20 tokens once trading has started
401    * @param _to the recipient address of the tokens.
402    * @param _value number of tokens to be transfered.
403    */
404   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
405       bool result = super.transfer(_to, _value);
406       update(msg.sender,balances[msg.sender]);
407       update(_to,balances[_to]);
408       return result;
409   }
410 
411   /**
412    * @dev Allows anyone to transfer the H20 tokens once trading has started
413    * @param _from address The address which you want to send tokens from
414    * @param _to address The address which you want to transfer to
415    * @param _value uint the amout of tokens to be transfered
416    */
417   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
418       bool result = super.transferFrom(_from, _to, _value);
419       update(_from,balances[_from]);
420       update(_to,balances[_to]);
421       return result;
422   }
423 
424  /**
425    * @dev Function to mint tokens
426    * @param _to The address that will recieve the minted tokens.
427    * @param _amount The amount of tokens to mint.
428    * @return A boolean that indicates if the operation was successful.
429    */
430  
431   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
432       bool result = super.mint(_to,_amount);
433       update(_to,balances[_to]);
434       return result;
435   }
436 
437   function emergencyERC20Drain( ERC20 token, uint amount ) {
438       token.transfer(owner, amount);
439   }
440  
441 }
442 
443 
444 contract HydroCoinPresale is Ownable,Pausable {
445   using SafeMath for uint256;
446 
447   // The token being sold
448   HydroCoin public token;
449 
450   // start and end block where investments are allowed (both inclusive)
451   uint256 public startTimestamp; 
452   uint256 public endTimestamp;
453 
454   // address where funds are collected
455   address public hardwareWallet = 0xa6128CA2eD94FB697d7058dC3Fd22740F82FF06A;
456 
457   mapping (address => uint256) public deposits;
458 
459   // how many token units a buyer gets per wei
460   uint256 public rate = 125;
461 
462   // amount of raised money in wei
463   uint256 public weiRaised;
464 
465   // minimum contributio to participate in tokensale
466   uint256 public minContribution  = 50 ether;
467 
468   // maximum amount of ether being raised
469   uint256 public hardcap  = 1500 ether; 
470 
471   // amount to allocate to vendors
472   uint256 public vendorAllocation  = 1000000 * 10 ** 18; // H20
473 
474   // number of participants in presale
475   uint256 public numberOfPurchasers = 0;
476 
477   address public companyTokens = 0xF1D5007d3884B8Ec6C2f89088b2bA28C5291C70f;
478 
479   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
480   event PreSaleClosed();
481 
482   function setWallet(address _wallet) onlyOwner {
483     hardwareWallet = _wallet;
484   }
485 
486   function HydroCoinPresale() {
487     startTimestamp = 1506333600;
488     endTimestamp = startTimestamp + 1 weeks;
489 
490     token = new HydroCoin();
491 
492     require(startTimestamp >= now);
493     require(endTimestamp >= startTimestamp);
494 
495     token.mint(companyTokens, vendorAllocation);
496   }
497 
498   // check if valid purchase
499   modifier validPurchase {
500     require(now >= startTimestamp);
501     require(now <= endTimestamp);
502     require(msg.value >= minContribution);
503     require(weiRaised.add(msg.value) <= hardcap);
504     _;
505   }
506 
507   // @return true if crowdsale event has ended
508   function hasEnded() public constant returns (bool) {
509     if (now > endTimestamp)
510         return true;
511     if (weiRaised >= hardcap)
512         return true;
513     return false;
514   }
515 
516   // low level token purchase function
517   function buyTokens(address beneficiary) payable validPurchase {
518     require(beneficiary != 0x0);
519 
520     uint256 weiAmount = msg.value;
521 
522     if (deposits[msg.sender] == 0) {
523         numberOfPurchasers++;
524     }
525     deposits[msg.sender] = weiAmount.add(deposits[msg.sender]);
526     
527 
528     // calculate token amount to be created
529     uint256 tokens = weiAmount.mul(rate);
530 
531     // update state
532     weiRaised = weiRaised.add(weiAmount);
533 
534     token.mint(beneficiary, tokens);
535     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
536     hardwareWallet.transfer(msg.value);
537   }
538 
539   // transfer ownership of the token to the owner of the presale contract
540   function finishPresale() public onlyOwner {
541     require(hasEnded());
542     token.transferOwnership(owner);
543     PreSaleClosed();
544   }
545 
546   // fallback function can be used to buy tokens
547   function () payable {
548     buyTokens(msg.sender);
549   }
550 
551     function emergencyERC20Drain( ERC20 theToken, uint amount ) {
552         theToken.transfer(owner, amount);
553     }
554 
555 
556 }
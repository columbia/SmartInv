1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 
38 
39 
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() public {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70 
71   /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75   function transferOwnership(address newOwner) public onlyOwner {
76     require(newOwner != address(0));
77     OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81 }
82 
83 
84 
85 /**
86  * @title ERC20Basic
87  * @dev Simpler version of ERC20 interface
88  * @dev see https://github.com/ethereum/EIPs/issues/179
89  */
90 contract ERC20Basic {
91   uint256 public totalSupply;
92   function balanceOf(address who) public view returns (uint256);
93   function transfer(address to, uint256 value) public returns (bool);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 
98 
99 
100 /**
101  * @title ERC20 interface
102  * @dev see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 is ERC20Basic {
105   function allowance(address owner, address spender) public view returns (uint256);
106   function transferFrom(address from, address to, uint256 value) public returns (bool);
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 
114 
115 /**
116  * @title Basic token
117  * @dev Basic version of StandardToken, with no allowances.
118  */
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[msg.sender]);
132 
133     // SafeMath.sub will throw if there is not enough balance.
134     balances[msg.sender] = balances[msg.sender].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     Transfer(msg.sender, _to, _value);
137     return true;
138   }
139 
140   /**
141   * @dev Gets the balance of the specified address.
142   * @param _owner The address to query the the balance of.
143   * @return An uint256 representing the amount owned by the passed address.
144   */
145   function balanceOf(address _owner) public view returns (uint256 balance) {
146     return balances[_owner];
147   }
148 
149 }
150 
151 
152 
153 
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public view returns (uint256) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * approve should be called when allowed[_spender] == 0. To increment
213    * allowed value is better to use this function to avoid 2 calls (and wait until
214    * the first transaction is mined)
215    * From MonolithDAO Token.sol
216    */
217   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
224     uint oldValue = allowed[msg.sender][_spender];
225     if (_subtractedValue > oldValue) {
226       allowed[msg.sender][_spender] = 0;
227     } else {
228       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
229     }
230     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231     return true;
232   }
233 
234 }
235 
236 
237 
238 
239 
240 contract ZillaToken is StandardToken, Ownable {
241   uint256 constant zilla = 1 ether;
242 
243   string public name = 'Zilla Token';
244   string public symbol = 'ZLA';
245   uint public decimals = 18;
246   uint256 public initialSupply = 60000000 * zilla;
247   bool public tradeable;
248 
249   function ZillaToken() public {
250     totalSupply = initialSupply;
251     balances[msg.sender] = initialSupply;
252     tradeable = false;
253   }
254 
255   /**
256    * @dev modifier to determine if the token is tradeable
257    */
258   modifier isTradeable() {
259     require( tradeable == true );
260     _;
261   }
262 
263   /**
264    * @dev allow the token to be freely tradeable
265    */
266   function allowTrading() public onlyOwner {
267     require( tradeable == false );
268     tradeable = true;
269   }
270 
271   /**
272    * @dev allow the token to be freely tradeable
273    * @param _to the address to transfer ZLA to
274    * @param _value the amount of ZLA to transfer
275    */
276   function crowdsaleTransfer(address _to, uint256 _value) public onlyOwner returns (bool) {
277     require( tradeable == false );
278     return super.transfer(_to, _value);
279   } 
280 
281   function transfer(address _to, uint256 _value) public isTradeable returns (bool) {
282     return super.transfer(_to, _value);
283   }
284 
285   function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool) {
286     return super.transferFrom(_from, _to, _value);
287   }
288 
289   function approve(address _spender, uint256 _value) public isTradeable returns (bool) {
290     return super.approve(_spender, _value);
291   }
292 
293   function increaseApproval(address _spender, uint _addedValue) public isTradeable returns (bool success) {
294     return super.increaseApproval(_spender, _addedValue);
295   }
296 
297   function decreaseApproval(address _spender, uint _subtractedValue) public isTradeable returns (bool success) {
298     return super.decreaseApproval(_spender, _subtractedValue);
299   }
300 
301 }
302 
303 
304 
305 
306 
307 /**
308  * @title Crowdsale
309  * @dev Crowdsale is a base contract for managing a token crowdsale.
310  * Crowdsales have a start and end timestamps, where investors can make
311  * token purchases and the crowdsale will assign them tokens based
312  * on a token per ETH rate. Funds collected are forwarded to a wallet
313  * as they arrive.
314  */
315 contract ZillaCrowdsale is Ownable {
316   using SafeMath for uint256;
317 
318   // public events
319   event StartCrowdsale();
320   event FinalizeCrowdsale();
321   event TokenSold(address recipient, uint eth_amount, uint zla_amount);
322  
323   // crowdsale constants
324   uint256 constant presale_eth_to_zilla   = 1200;
325   uint256 constant crowdsale_eth_to_zilla =  750;
326 
327   // our ZillaToken contract
328   ZillaToken public token;
329 
330   // crowdsale token limit
331   uint256 public zilla_remaining;
332 
333   // our Zilla multisig vault address
334   address public vault;
335 
336   // crowdsale state
337   enum CrowdsaleState { Waiting, Running, Ended }
338   CrowdsaleState public state = CrowdsaleState.Waiting;
339   uint256 public start;
340   uint256 public unlimited;
341   uint256 public end;
342 
343   // participants state
344   struct Participant {
345     bool    whitelist;
346     uint256 remaining;
347   }
348   mapping (address => Participant) private participants;
349 
350   /**
351    * @dev constructs ZillaCrowdsale
352    */
353   function ZillaCrowdsale() public {
354     token = new ZillaToken();
355     zilla_remaining = token.totalSupply();
356   }
357 
358   /**
359    * @dev modifier to determine if the crowdsale has been initialized
360    */
361   modifier isStarted() {
362     require( (state == CrowdsaleState.Running) );
363     _;
364   }
365 
366   /**
367    * @dev modifier to determine if the crowdsale is active
368    */
369   modifier isRunning() {
370     require( (state == CrowdsaleState.Running) && (now >= start) && (now < end) );
371     _;
372   }
373 
374   /**
375    * @dev start the Zilla Crowdsale
376    * @param _start is the epoch time the crowdsale starts
377    * @param _end is the epoch time the crowdsale ends
378    * @param _vault is the multisig wallet the ethereum is transfered to
379    */
380   function startCrowdsale(uint256 _start, uint256 _unlimited, uint256 _end, address _vault) public onlyOwner {
381     require(state == CrowdsaleState.Waiting);
382     require(_start >= now);
383     require(_unlimited > _start);
384     require(_unlimited < _end);
385     require(_end > _start);
386     require(_vault != 0x0);
387 
388     start     = _start;
389     unlimited = _unlimited;
390     end       = _end;
391     vault     = _vault;
392     state     = CrowdsaleState.Running;
393     StartCrowdsale();
394   }
395 
396   /**
397    * @dev Finalize the Zilla Crowdsale, unsold tokens are moved to the vault account
398    */
399   function finalizeCrowdsale() public onlyOwner {
400     require(state == CrowdsaleState.Running);
401     require(end < now);
402     // transfer remaining tokens to vault
403     _transferTokens( vault, 0, zilla_remaining );
404     // end the crowdsale
405     state = CrowdsaleState.Ended;
406     // allow the token to be traded
407     token.allowTrading();
408     FinalizeCrowdsale();
409   }
410 
411   /**
412    * @dev Allow owner to increase the end date of the crowdsale as long as the crowdsale is still running
413    * @param _end the new end date for the crowdsale
414    */
415   function setEndDate(uint256 _end) public onlyOwner {
416     require(state == CrowdsaleState.Running);
417     require(_end > now);
418     require(_end > start);
419     require(_end > end);
420 
421     end = _end;
422   }
423 
424   /**
425    * @dev Allow owner to change the multisig wallet
426    * @param _vault the new address of the multisig wallet
427    */
428   function setVault(address _vault) public onlyOwner {
429     require(_vault != 0x0);
430 
431     vault = _vault;    
432   }
433 
434   /**
435    * @dev Allow owner to add to the whitelist
436    * @param _addresses array of addresses to add to the whitelist
437    */
438   function whitelistAdd(address[] _addresses) public onlyOwner {
439     for (uint i=0; i<_addresses.length; i++) {
440       Participant storage p = participants[ _addresses[i] ];
441       p.whitelist = true;
442       p.remaining = 15 ether;
443     }
444   }
445 
446   /**
447    * @dev Allow owner to remove from the whitelist
448    * @param _addresses array of addresses to remove from the whitelist
449    */
450   function whitelistRemove(address[] _addresses) public onlyOwner {
451     for (uint i=0; i<_addresses.length; i++) {
452       delete participants[ _addresses[i] ];
453     }
454   }
455 
456   /**
457    * @dev Fallback function which buys tokens when sent ether
458    */
459   function() external payable {
460     buyTokens(msg.sender);
461   }
462 
463   /**
464    * @dev Apply our fixed buy rate and verify we are not sold out.
465    * @param eth the amount of ether being used to purchase tokens.
466    */
467   function _allocateTokens(uint256 eth) private view returns(uint256 tokens) {
468     tokens = crowdsale_eth_to_zilla.mul(eth);
469     require( zilla_remaining >= tokens );
470   }
471 
472   /**
473    * @dev Apply our fixed presale rate and verify we are not sold out.
474    * @param eth the amount of ether used to purchase presale tokens.
475    */
476   function _allocatePresaleTokens(uint256 eth) private view returns(uint256 tokens) {
477     tokens = presale_eth_to_zilla.mul(eth);
478     require( zilla_remaining >= tokens );
479   }
480 
481   /**
482    * @dev Transfer tokens to the recipient and update our token availability.
483    * @param recipient the recipient to receive tokens.
484    * @param eth the amount of Ethereum spent.
485    * @param zla the amount of Zilla Tokens received.
486    */
487   function _transferTokens(address recipient, uint256 eth, uint256 zla) private {
488     require( token.crowdsaleTransfer( recipient, zla ) );
489     zilla_remaining = zilla_remaining.sub( zla );
490     TokenSold(recipient, eth, zla);
491   }
492 
493   /**
494    * @dev Allows the owner to grant presale participants their tokens.
495    * @param recipient the recipient to receive tokens. 
496    * @param eth the amount of ether from the presale.
497    */
498   function _grantPresaleTokens(address recipient, uint256 eth) private {
499     uint256 tokens = _allocatePresaleTokens(eth);
500     _transferTokens( recipient, eth, tokens );
501   }
502 
503   /**
504    * @dev Allows anyone to create tokens by depositing ether.
505    * @param recipient the recipient to receive tokens. 
506    */
507   function buyTokens(address recipient) public isRunning payable {
508     Participant storage p = participants[ recipient ];    
509     require( p.whitelist );
510     // check for the first session buy limits
511     if( unlimited > now ) {
512       require( p.remaining >= msg.value );
513       p.remaining.sub( msg.value );
514     }
515     uint256 tokens = _allocateTokens(msg.value);
516     require( vault.send(msg.value) );
517     _transferTokens( recipient, msg.value, tokens );
518   }
519 
520   /**
521    * @dev Allows owner to transfer tokens to any address.
522    * @param recipient is the address to receive tokens. 
523    * @param zla is the amount of Zilla to transfer
524    */
525   function grantTokens(address recipient, uint256 zla) public isStarted onlyOwner {
526     require( zilla_remaining >= zla );
527     _transferTokens( recipient, 0, zla );
528   }
529 
530   /**
531    * @dev Allows the owner to grant presale participants their tokens.
532    * @param recipients array of recipients to receive tokens. 
533    * @param eths array of ether from the presale.
534    */
535   function grantPresaleTokens(address[] recipients, uint256[] eths) public isStarted onlyOwner {
536     require( recipients.length == eths.length );
537     for (uint i=0; i<recipients.length; i++) {
538       _grantPresaleTokens( recipients[i], eths[i] );
539     }
540   }
541 
542 }
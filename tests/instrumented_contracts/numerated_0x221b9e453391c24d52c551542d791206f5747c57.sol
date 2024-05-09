1 pragma solidity ^0.4.15;
2 
3 
4   /**
5    * @title SafeMath
6    * @dev Math operations with safety checks that throw on error
7    */
8   library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10       uint256 c = a * b;
11       assert(a == 0 || c / a == b);
12       return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16       // assert(b > 0); // Solidity automatically throws when dividing by 0
17       uint256 c = a / b;
18       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19       return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23       assert(b <= a);
24       return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28       uint256 c = a + b;
29       assert(c >= a);
30       return c;
31     }
32   }
33 
34 
35   /**
36    * @title Ownable
37    * @dev The Ownable contract has an owner address, and provides basic authorization control
38    * functions, this simplifies the implementation of "user permissions".
39    */
40   contract Ownable {
41     address public owner;
42 
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46      * account.
47      */
48     function Ownable() {
49       owner = msg.sender;
50     }
51 
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57       require(msg.sender == owner);
58       _;
59     }
60 
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner {
67       if (newOwner != address(0)) {
68         owner = newOwner;
69       }
70     }
71 
72   }
73 
74 
75   /*
76    * Haltable
77    *
78    * Abstract contract that allows children to implement an
79    * emergency stop mechanism. Differs from Pausable by requiring a state.
80    *
81    *
82    * Originally envisioned in FirstBlood ICO contract.
83    */
84   contract Haltable is Ownable {
85     bool public halted = false;
86 
87     modifier inNormalState {
88       require(!halted);
89       _;
90     }
91 
92     modifier inEmergencyState {
93       require(halted);
94       _;
95     }
96 
97     // called by the owner on emergency, triggers stopped state
98     function halt() external onlyOwner inNormalState {
99       halted = true;
100     }
101 
102     // called by the owner on end of emergency, returns to normal state
103     function unhalt() external onlyOwner inEmergencyState {
104       halted = false;
105     }
106   }
107 
108   /**
109    * @title ERC20Basic
110    * @dev Simpler version of ERC20 interface
111    * @dev see https://github.com/ethereum/EIPs/issues/179
112    */
113   contract ERC20Basic {
114     uint256 public totalSupply;
115     function balanceOf(address who) constant returns (uint256);
116     function transfer(address to, uint256 value) returns (bool);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118   }
119 
120 
121   /**
122    * @title ERC20 interface
123    * @dev see https://github.com/ethereum/EIPs/issues/20
124    */
125   contract ERC20 is ERC20Basic {
126     function allowance(address owner, address spender) constant returns (uint256);
127     function transferFrom(address from, address to, uint256 value) returns (bool);
128     function approve(address spender, uint256 value) returns (bool);
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130   }
131 
132   /**
133    * @title Basic token
134    * @dev Basic version of StandardToken, with no allowances.
135    */
136   contract BasicToken is ERC20Basic {
137     using SafeMath for uint256;
138 
139     mapping(address => uint256) balances;
140 
141     /**
142     * @dev transfer token for a specified address
143     * @param _to The address to transfer to.
144     * @param _value The amount to be transferred.
145     */
146     function transfer(address _to, uint256 _value) returns (bool) {
147       balances[msg.sender] = balances[msg.sender].sub(_value);
148       balances[_to] = balances[_to].add(_value);
149       Transfer(msg.sender, _to, _value);
150       return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) constant returns (uint256 balance) {
159       return balances[_owner];
160     }
161 
162   }
163 
164   /**
165    * @title Standard ERC20 token
166    *
167    * @dev Implementation of the basic standard token.
168    * @dev https://github.com/ethereum/EIPs/issues/20
169    * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170    */
171   contract StandardToken is ERC20, BasicToken {
172 
173     mapping (address => mapping (address => uint256)) allowed;
174 
175 
176     /**
177      * @dev Transfer tokens from one address to another
178      * @param _from address The address which you want to send tokens from
179      * @param _to address The address which you want to transfer to
180      * @param _value uint256 the amout of tokens to be transfered
181      */
182     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
183       var _allowance = allowed[_from][msg.sender];
184 
185       // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
186       // require (_value <= _allowance);
187 
188       balances[_to] = balances[_to].add(_value);
189       balances[_from] = balances[_from].sub(_value);
190       allowed[_from][msg.sender] = _allowance.sub(_value);
191       Transfer(_from, _to, _value);
192       return true;
193     }
194 
195     /**
196      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
197      * @param _spender The address which will spend the funds.
198      * @param _value The amount of tokens to be spent.
199      */
200     function approve(address _spender, uint256 _value) returns (bool) {
201 
202       // To change the approve amount you first have to reduce the addresses`
203       //  allowance to zero by calling `approve(_spender, 0)` if it is not
204       //  already 0 to mitigate the race condition described here:
205       //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206       require((_value == 0) || (allowed[msg.sender][_spender] == 0));
207 
208       allowed[msg.sender][_spender] = _value;
209       Approval(msg.sender, _spender, _value);
210       return true;
211     }
212 
213     /**
214      * @dev Function to check the amount of tokens that an owner allowed to a spender.
215      * @param _owner address The address which owns the funds.
216      * @param _spender address The address which will spend the funds.
217      * @return A uint256 specifing the amount of tokens still avaible for the spender.
218      */
219     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
220       return allowed[_owner][_spender];
221     }
222 
223   }
224 
225   /**
226    * @title Burnable
227    *
228    * @dev Standard ERC20 token
229    */
230   contract Burnable is StandardToken {
231     using SafeMath for uint;
232 
233     /* This notifies clients about the amount burnt */
234     event Burn(address indexed from, uint256 value);
235 
236     function burn(uint256 _value) returns (bool success) {
237       require(balances[msg.sender] >= _value);                // Check if the sender has enough
238       balances[msg.sender] = balances[msg.sender].sub(_value);// Subtract from the sender
239       totalSupply = totalSupply.sub(_value);                                  // Updates totalSupply
240       Burn(msg.sender, _value);
241       return true;
242     }
243 
244     function burnFrom(address _from, uint256 _value) returns (bool success) {
245       require(balances[_from] >= _value);               // Check if the sender has enough
246       require(_value <= allowed[_from][msg.sender]);    // Check allowance
247       balances[_from] = balances[_from].sub(_value);    // Subtract from the sender
248       totalSupply = totalSupply.sub(_value);            // Updates totalSupply
249       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250       Burn(_from, _value);
251       return true;
252     }
253 
254     function transfer(address _to, uint _value) returns (bool success) {
255       require(_to != 0x0); //use burn
256 
257       return super.transfer(_to, _value);
258     }
259 
260     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
261       require(_to != 0x0); //use burn
262 
263       return super.transferFrom(_from, _to, _value);
264     }
265   }
266 
267 
268   /**
269    * @title JincorToken
270    *
271    * @dev Burnable Ownable ERC20 token
272    */
273   contract JincorToken is Burnable, Ownable {
274 
275     string public name = "Jincor Token";
276     string public symbol = "JCR";
277     uint256 public decimals = 18;
278     uint256 public INITIAL_SUPPLY = 35000000 * 1 ether;
279 
280     /* The finalizer contract that allows unlift the transfer limits on this token */
281     address public releaseAgent;
282 
283     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
284     bool public released = false;
285 
286     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
287     mapping (address => bool) public transferAgents;
288 
289     /**
290      * Limit token transfer until the crowdsale is over.
291      *
292      */
293     modifier canTransfer(address _sender) {
294       require(transferAgents[_sender] || released);
295       _;
296     }
297 
298     /** The function can be called only before or after the tokens have been releasesd */
299     modifier inReleaseState(bool releaseState) {
300       require(releaseState == released);
301       _;
302     }
303 
304     /** The function can be called only by a whitelisted release agent. */
305     modifier onlyReleaseAgent() {
306       require(msg.sender == releaseAgent);
307       _;
308     }
309 
310 
311     /**
312      * @dev Contructor that gives msg.sender all of existing tokens.
313      */
314     function JincorToken() {
315       totalSupply = INITIAL_SUPPLY;
316       balances[msg.sender] = INITIAL_SUPPLY;
317     }
318 
319 
320     /**
321      * Set the contract that can call release and make the token transferable.
322      *
323      * Design choice. Allow reset the release agent to fix fat finger mistakes.
324      */
325     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
326 
327       // We don't do interface check here as we might want to a normal wallet address to act as a release agent
328       releaseAgent = addr;
329     }
330 
331     function release() onlyReleaseAgent inReleaseState(false) public {
332       released = true;
333     }
334 
335     /**
336      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
337      */
338     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
339       transferAgents[addr] = state;
340     }
341 
342     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
343       // Call Burnable.transfer()
344       return super.transfer(_to, _value);
345     }
346 
347     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
348       // Call Burnable.transferForm()
349       return super.transferFrom(_from, _to, _value);
350     }
351 
352     function burn(uint256 _value) onlyOwner returns (bool success) {
353       return super.burn(_value);
354     }
355 
356     function burnFrom(address _from, uint256 _value) onlyOwner returns (bool success) {
357       return super.burnFrom(_from, _value);
358     }
359   }
360 
361 
362 
363   contract JincorTokenPreSale is Ownable, Haltable {
364     using SafeMath for uint;
365 
366     string public name = "Jincor Token PreSale";
367 
368     JincorToken public token;
369 
370     address public beneficiary;
371 
372     uint public hardCap;
373 
374     uint public softCap;
375 
376     uint public price;
377 
378     uint public purchaseLimit;
379 
380     uint public collected = 0;
381 
382     uint public tokensSold = 0;
383 
384     uint public investorCount = 0;
385 
386     uint public weiRefunded = 0;
387 
388     uint public startBlock;
389 
390     uint public endBlock;
391 
392     bool public softCapReached = false;
393 
394     bool public crowdsaleFinished = false;
395 
396     mapping (address => bool) refunded;
397 
398     event GoalReached(uint amountRaised);
399 
400     event SoftCapReached(uint softCap);
401 
402     event NewContribution(address indexed holder, uint256 tokenAmount, uint256 etherAmount);
403 
404     event Refunded(address indexed holder, uint256 amount);
405 
406     modifier preSaleActive() {
407       require(block.number >= startBlock && block.number < endBlock);
408       _;
409     }
410 
411     modifier preSaleEnded() {
412       require(block.number >= endBlock);
413       _;
414     }
415 
416     function JincorTokenPreSale(
417     uint _hardCapUSD,
418     uint _softCapUSD,
419     address _token,
420     address _beneficiary,
421     uint _totalTokens,
422     uint _priceETH,
423     uint _purchaseLimitUSD,
424 
425     uint _startBlock,
426     uint _endBlock
427     ) {
428       hardCap = _hardCapUSD.mul(1 ether).div(_priceETH);
429       softCap = _softCapUSD.mul(1 ether).div(_priceETH);
430       price = _totalTokens.mul(1 ether).div(hardCap);
431 
432       purchaseLimit = _purchaseLimitUSD.mul(1 ether).div(_priceETH).mul(price);
433       token = JincorToken(_token);
434       beneficiary = _beneficiary;
435 
436       startBlock = _startBlock;
437       endBlock = _endBlock;
438     }
439 
440     function() payable {
441       require(msg.value >= 0.1 * 1 ether);
442       doPurchase(msg.sender);
443     }
444 
445     function refund() external preSaleEnded inNormalState {
446       require(softCapReached == false);
447       require(refunded[msg.sender] == false);
448 
449       uint balance = token.balanceOf(msg.sender);
450       require(balance > 0);
451 
452       uint refund = balance.div(price);
453       if (refund > this.balance) {
454         refund = this.balance;
455       }
456 
457       assert(msg.sender.send(refund));
458       refunded[msg.sender] = true;
459       weiRefunded = weiRefunded.add(refund);
460       Refunded(msg.sender, refund);
461     }
462 
463     function withdraw() onlyOwner {
464       require(softCapReached);
465       assert(beneficiary.send(collected));
466       token.transfer(beneficiary, token.balanceOf(this));
467       crowdsaleFinished = true;
468     }
469 
470     function doPurchase(address _owner) private preSaleActive inNormalState {
471 
472       require(!crowdsaleFinished);
473       require(collected.add(msg.value) <= hardCap);
474 
475       if (!softCapReached && collected < softCap && collected.add(msg.value) >= softCap) {
476         softCapReached = true;
477         SoftCapReached(softCap);
478       }
479       uint tokens = msg.value * price;
480       require(token.balanceOf(msg.sender).add(tokens) <= purchaseLimit);
481 
482       if (token.balanceOf(msg.sender) == 0) investorCount++;
483 
484       collected = collected.add(msg.value);
485 
486       token.transfer(msg.sender, tokens);
487 
488       tokensSold = tokensSold.add(tokens);
489 
490       NewContribution(_owner, tokens, msg.value);
491 
492       if (collected == hardCap) {
493         GoalReached(hardCap);
494       }
495     }
496   }
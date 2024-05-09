1 pragma solidity ^0.4.11;
2 
3 //
4 // SafeMath
5 //
6 // Ownable
7 // Destructible
8 // Pausable
9 //
10 // ERC20Basic
11 // ERC20 : ERC20Basic
12 // BasicToken : ERC20Basic
13 // StandardToken : ERC20, BasicToken
14 // MintableToken : StandardToken, Ownable
15 // PausableToken : StandardToken, Pausable
16 //
17 // VanityToken : MintableToken, PausableToken
18 //
19 // VanityCrowdsale : Ownable
20 //
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) onlyOwner public {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92 }
93 
94 /**
95  * @title Destructible
96  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
97  */
98 contract Destructible is Ownable {
99 
100   function Destructible() public payable { }
101 
102   /**
103    * @dev Transfers the current balance to the owner and terminates the contract.
104    */
105   function destroy() onlyOwner public {
106     selfdestruct(owner);
107   }
108 
109   function destroyAndSend(address _recipient) onlyOwner public {
110     selfdestruct(_recipient);
111   }
112 }
113 
114 /**
115  * @title Pausable
116  * @dev Base contract which allows children to implement an emergency stop mechanism.
117  */
118 contract Pausable is Ownable {
119   event Pause();
120   event Unpause();
121 
122   bool public paused = false;
123 
124 
125   /**
126    * @dev Modifier to make a function callable only when the contract is not paused.
127    */
128   modifier whenNotPaused() {
129     require(!paused);
130     _;
131   }
132 
133   /**
134    * @dev Modifier to make a function callable only when the contract is paused.
135    */
136   modifier whenPaused() {
137     require(paused);
138     _;
139   }
140 
141   /**
142    * @dev called by the owner to pause, triggers stopped state
143    */
144   function pause() onlyOwner whenNotPaused public {
145     paused = true;
146     Pause();
147   }
148 
149   /**
150    * @dev called by the owner to unpause, returns to normal state
151    */
152   function unpause() onlyOwner whenPaused public {
153     paused = false;
154     Unpause();
155   }
156 }
157 
158 /**
159  * @title ERC20Basic
160  * @dev Simpler version of ERC20 interface
161  * @dev see https://github.com/ethereum/EIPs/issues/179
162  */
163 contract ERC20Basic {
164   uint256 public totalSupply;
165   function balanceOf(address who) public constant returns (uint256);
166   function transfer(address to, uint256 value) public returns (bool);
167   event Transfer(address indexed from, address indexed to, uint256 value);
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) public constant returns (uint256);
176   function transferFrom(address from, address to, uint256 value) public returns (bool);
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 /**
182  * @title Basic token
183  * @dev Basic version of StandardToken, with no allowances.
184  */
185 contract BasicToken is ERC20Basic {
186   using SafeMath for uint256;
187 
188   mapping(address => uint256) balances;
189 
190   /**
191   * @dev transfer token for a specified address
192   * @param _to The address to transfer to.
193   * @param _value The amount to be transferred.
194   */
195   function transfer(address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197 
198     // SafeMath.sub will throw if there is not enough balance.
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     balances[_to] = balances[_to].add(_value);
201     Transfer(msg.sender, _to, _value);
202     return true;
203   }
204 
205   /**
206   * @dev Gets the balance of the specified address.
207   * @param _owner The address to query the the balance of.
208   * @return An uint256 representing the amount owned by the passed address.
209   */
210   function balanceOf(address _owner) public constant returns (uint256 balance) {
211     return balances[_owner];
212   }
213 
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implementation of the basic standard token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is ERC20, BasicToken {
224 
225   mapping (address => mapping (address => uint256)) allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint256 the amount of tokens to be transferred
233    */
234   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
235     require(_to != address(0));
236 
237     uint256 _allowance = allowed[_from][msg.sender];
238 
239     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
240     // require (_value <= _allowance);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = _allowance.sub(_value);
245     Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    *
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Function to check the amount of tokens that an owner allowed to a spender.
267    * @param _owner address The address which owns the funds.
268    * @param _spender address The address which will spend the funds.
269    * @return A uint256 specifying the amount of tokens still available for the spender.
270    */
271   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
272     return allowed[_owner][_spender];
273   }
274 
275   /**
276    * approve should be called when allowed[_spender] == 0. To increment
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    */
281   function increaseApproval (address _spender, uint _addedValue) public
282     returns (bool success) {
283     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288   function decreaseApproval (address _spender, uint _subtractedValue) public
289     returns (bool success) {
290     uint oldValue = allowed[msg.sender][_spender];
291     if (_subtractedValue > oldValue) {
292       allowed[msg.sender][_spender] = 0;
293     } else {
294       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
295     }
296     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
297     return true;
298   }
299 
300 }
301 
302 /**
303  * @title Mintable token
304  * @dev Simple ERC20 Token example, with mintable token creation
305  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
306  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
307  */
308 
309 contract MintableToken is StandardToken, Ownable {
310   event Mint(address indexed to, uint256 amount);
311   event MintFinished();
312 
313   bool public mintingFinished = false;
314 
315 
316   modifier canMint() {
317     require(!mintingFinished);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will receive the minted tokens.
324    * @param _amount The amount of tokens to mint.
325    * @return A boolean that indicates if the operation was successful.
326    */
327   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
328     totalSupply = totalSupply.add(_amount);
329     balances[_to] = balances[_to].add(_amount);
330     Mint(_to, _amount);
331     Transfer(0x0, _to, _amount);
332     return true;
333   }
334 
335   /**
336    * @dev Function to stop minting new tokens.
337    * @return True if the operation was successful.
338    */
339   function finishMinting() onlyOwner public returns (bool) {
340     mintingFinished = true;
341     MintFinished();
342     return true;
343   }
344 }
345 
346 /**
347  * @title Pausable token
348  *
349  * @dev StandardToken modified with pausable transfers.
350  **/
351 
352 contract PausableToken is StandardToken, Pausable {
353 
354   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
355     return super.transfer(_to, _value);
356   }
357 
358   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
359     return super.transferFrom(_from, _to, _value);
360   }
361 
362   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
363     return super.approve(_spender, _value);
364   }
365 
366   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
367     return super.increaseApproval(_spender, _addedValue);
368   }
369 
370   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
371     return super.decreaseApproval(_spender, _subtractedValue);
372   }
373 }
374 
375 contract VanityToken is MintableToken, PausableToken {
376 
377     // Metadata
378     string public constant symbol = "VIP";
379     string public constant name = "VipCoin";
380     uint8 public constant decimals = 18;
381     string public constant version = "1.0";
382 
383 }
384 
385 contract VanityCrowdsale is Ownable {
386 
387     using SafeMath for uint256;
388 
389     // Constants
390 
391     uint256 public constant TOKEN_RATE = 1000; // 1 ETH = 1000 VPL
392     uint256 public constant OWNER_TOKENS_PERCENT = 100; // 1:1
393 
394     // Variables
395 
396     uint256 public startTime;
397     uint256 public endTime;
398     address public ownerWallet;
399     
400     mapping(address => uint) public registeredInDay;
401     address[] public participants;
402     uint256 public totalUsdAmount;
403     uint256 public bonusMultiplier;
404     
405     VanityToken public token;
406     bool public finalized;
407     bool public distributed;
408     uint256 public distributedCount;
409     uint256 public distributedTokens;
410     
411     // Events
412 
413     event Finalized();
414     event Distributed();
415     
416     // Constructor and accessors
417 
418     function VanityCrowdsale(uint256 _startTime, uint256 _endTime, address _ownerWallet) public {
419         startTime = _startTime;
420         endTime = _endTime;
421         ownerWallet = _ownerWallet;
422 
423         token = new VanityToken();
424         token.pause();
425     }
426 
427     function registered(address wallet) public constant returns(bool) {
428         return registeredInDay[wallet] > 0;
429     }
430 
431     function participantsCount() public constant returns(uint) {
432         return participants.length;
433     }
434 
435     function setOwnerWallet(address _ownerWallet) public onlyOwner {
436         require(_ownerWallet != address(0));
437         ownerWallet = _ownerWallet;
438     }
439 
440     function computeTotalEthAmount() public constant returns(uint256) {
441         uint256 total = 0;
442         for (uint i = 0; i < participants.length; i++) {
443             address participant = participants[distributedCount + i];
444             total += participant.balance;
445         }
446         return total;
447     }
448 
449     function setTotalUsdAmount(uint256 _totalUsdAmount) public onlyOwner {
450         totalUsdAmount = _totalUsdAmount;
451 
452         if (totalUsdAmount > 10000000) {
453             bonusMultiplier = 20;
454         } else if (totalUsdAmount > 5000000) {
455             bonusMultiplier = 15;
456         } else if (totalUsdAmount > 1000000) {
457             bonusMultiplier = 10;
458         } else if (totalUsdAmount > 100000) {
459             bonusMultiplier = 5;
460         } else if (totalUsdAmount > 10000) {
461             bonusMultiplier = 2;
462         } else if (totalUsdAmount == 0) {
463             bonusMultiplier = 0; //TODO: set 1
464         }
465     }
466 
467     // Participants methods
468 
469     function () public payable {
470         registerParticipant();
471     }
472 
473     function registerParticipant() public payable {
474         require(!finalized);
475         require(startTime <= now && now <= endTime);
476         require(registeredInDay[msg.sender] == 0);
477 
478         registeredInDay[msg.sender] = 1 + now.sub(startTime).div(24*60*60);
479         participants.push(msg.sender);
480         if (msg.value > 0) {
481             // No money => No need to handle recirsive calls
482             msg.sender.transfer(msg.value);
483         }
484     }
485 
486     // Owner methods
487 
488     function finalize() public onlyOwner {
489         require(!finalized);
490         require(now > endTime);
491 
492         finalized = true;
493         Finalized();
494     }
495 
496     function participantBonus(address participant) public constant returns(uint) {
497         uint day = registeredInDay[participant];
498         require(day > 0);
499 
500         uint bonus = 0;
501         if (day <= 1) {
502             bonus = 6;
503         } else if (day <= 3) {
504             bonus = 5;
505         } else if (day <= 7) {
506             bonus = 4;
507         } else if (day <= 10) {
508             bonus = 3;
509         } else if (day <= 14) {
510             bonus = 2;
511         } else if (day <= 21) {
512             bonus = 1;
513         }
514 
515         return bonus.mul(bonusMultiplier);
516     }
517 
518     function distribute(uint count) public onlyOwner {
519         require(finalized && !distributed);
520         require(count > 0 && distributedCount + count <= participants.length);
521         
522         for (uint i = 0; i < count; i++) {
523             address participant = participants[distributedCount + i];
524             uint256 bonus = participantBonus(participant);
525             uint256 tokens = participant.balance.mul(TOKEN_RATE).mul(100 + bonus).div(100);
526             token.mint(participant, tokens);
527             distributedTokens += tokens;
528         }
529         distributedCount += count;
530 
531         if (distributedCount == participants.length) {
532             uint256 ownerTokens = distributedTokens.mul(OWNER_TOKENS_PERCENT).div(100);
533             token.mint(ownerWallet, ownerTokens);
534             token.finishMinting();
535             token.unpause();
536             distributed = true;
537             Distributed();
538         }
539     }
540 
541 }
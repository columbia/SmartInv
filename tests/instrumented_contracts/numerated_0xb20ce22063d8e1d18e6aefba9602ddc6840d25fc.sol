1 /**
2    * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3    *
4    * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5    */
6 
7   pragma solidity ^0.4.18;
8 
9   /**
10    * @title SafeMath
11    * @dev Math operations with safety checks that throw on error
12    */
13   library SafeMath {
14 
15     /**
16     * @dev Multiplies two numbers, throws on overflow.
17     */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19       if (a == 0) {
20         return 0;
21       }
22       uint256 c = a * b;
23       assert(c / a == b);
24       return c;
25     }
26 
27     /**
28     * @dev Integer division of two numbers, truncating the quotient.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31       // assert(b > 0); // Solidity automatically throws when dividing by 0
32       uint256 c = a / b;
33       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34       return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41       assert(b <= a);
42       return a - b;
43     }
44 
45     /**
46     * @dev Adds two numbers, throws on overflow.
47     */
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49       uint256 c = a + b;
50       assert(c >= a);
51       return c;
52     }
53   }
54 
55 
56   /**
57    * Safe unsigned safe math.
58    *
59    * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
60    *
61    * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
62    *
63    * Maintained here until merged to mainline zeppelin-solidity.
64    *
65    */
66   library SafeMathLib {
67 
68     function times(uint a, uint b) returns (uint) {
69       uint c = a * b;
70       assert(a == 0 || c / a == b);
71       return c;
72     }
73 
74     function minus(uint a, uint b) returns (uint) {
75       assert(b <= a);
76       return a - b;
77     }
78 
79     function plus(uint a, uint b) returns (uint) {
80       uint c = a + b;
81       assert(c>=a);
82       return c;
83     }
84 
85   }
86 
87 
88   /**
89    * @title ERC20Basic
90    * @dev Simpler version of ERC20 interface
91    * @dev see https://github.com/ethereum/EIPs/issues/179
92    */
93   contract ERC20Basic {
94     function totalSupply() public view returns (uint256);
95     function balanceOf(address who) public view returns (uint256);
96     function transfer(address to, uint256 value) public returns (bool);
97     event Transfer(address indexed from, address indexed to, uint256 value);
98   }
99 
100 
101   /**
102    * @title Basic token
103    * @dev Basic version of StandardToken, with no allowances.
104    */
105   contract BasicToken is ERC20Basic {
106     using SafeMath for uint256;
107 
108     mapping(address => uint256) balances;
109 
110     uint256 totalSupply_;
111 
112     /**
113     * @dev total number of tokens in existence
114     */
115     function totalSupply() public view returns (uint256) {
116       return totalSupply_;
117     }
118 
119     /**
120     * @dev transfer token for a specified address
121     * @param _to The address to transfer to.
122     * @param _value The amount to be transferred.
123     */
124     function transfer(address _to, uint256 _value) public returns (bool) {
125       require(_to != address(0));
126       require(_value <= balances[msg.sender]);
127 
128       // SafeMath.sub will throw if there is not enough balance.
129       balances[msg.sender] = balances[msg.sender].sub(_value);
130       balances[_to] = balances[_to].add(_value);
131       Transfer(msg.sender, _to, _value);
132       return true;
133     }
134 
135     /**
136     * @dev Gets the balance of the specified address.
137     * @param _owner The address to query the the balance of.
138     * @return An uint256 representing the amount owned by the passed address.
139     */
140     function balanceOf(address _owner) public view returns (uint256 balance) {
141       return balances[_owner];
142     }
143 
144   }
145 
146 
147   /**
148    * @title ERC20 interface
149    * @dev see https://github.com/ethereum/EIPs/issues/20
150    */
151   contract ERC20 is ERC20Basic {
152     function allowance(address owner, address spender) public view returns (uint256);
153     function transferFrom(address from, address to, uint256 value) public returns (bool);
154     function approve(address spender, uint256 value) public returns (bool);
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156   }
157 
158   /**
159    * @title Standard ERC20 token
160    *
161    * @dev Implementation of the basic standard token.
162    * @dev https://github.com/ethereum/EIPs/issues/20
163    * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
164    */
165   contract StandardToken is ERC20, BasicToken {
166 
167     mapping (address => mapping (address => uint256)) internal allowed;
168 
169 
170     /**
171      * @dev Transfer tokens from one address to another
172      * @param _from address The address which you want to send tokens from
173      * @param _to address The address which you want to transfer to
174      * @param _value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
177       require(_to != address(0));
178       require(_value <= balances[_from]);
179       require(_value <= allowed[_from][msg.sender]);
180 
181       balances[_from] = balances[_from].sub(_value);
182       balances[_to] = balances[_to].add(_value);
183       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
184       Transfer(_from, _to, _value);
185       return true;
186     }
187 
188     /**
189      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
190      *
191      * Beware that changing an allowance with this method brings the risk that someone may use both the old
192      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
193      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      * @param _spender The address which will spend the funds.
196      * @param _value The amount of tokens to be spent.
197      */
198     function approve(address _spender, uint256 _value) public returns (bool) {
199       allowed[msg.sender][_spender] = _value;
200       Approval(msg.sender, _spender, _value);
201       return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param _owner address The address which owns the funds.
207      * @param _spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address _owner, address _spender) public view returns (uint256) {
211       return allowed[_owner][_spender];
212     }
213 
214     /**
215      * @dev Increase the amount of tokens that an owner allowed to a spender.
216      *
217      * approve should be called when allowed[_spender] == 0. To increment
218      * allowed value is better to use this function to avoid 2 calls (and wait until
219      * the first transaction is mined)
220      * From MonolithDAO Token.sol
221      * @param _spender The address which will spend the funds.
222      * @param _addedValue The amount of tokens to increase the allowance by.
223      */
224     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
225       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
226       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227       return true;
228     }
229 
230     /**
231      * @dev Decrease the amount of tokens that an owner allowed to a spender.
232      *
233      * approve should be called when allowed[_spender] == 0. To decrement
234      * allowed value is better to use this function to avoid 2 calls (and wait until
235      * the first transaction is mined)
236      * From MonolithDAO Token.sol
237      * @param _spender The address which will spend the funds.
238      * @param _subtractedValue The amount of tokens to decrease the allowance by.
239      */
240     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
241       uint oldValue = allowed[msg.sender][_spender];
242       if (_subtractedValue > oldValue) {
243         allowed[msg.sender][_spender] = 0;
244       } else {
245         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246       }
247       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248       return true;
249     }
250 
251   }
252 
253 
254   /**
255      @title ERC827 interface, an extension of ERC20 token standard
256 
257      Interface of a ERC827 token, following the ERC20 standard with extra
258      methods to transfer value and data and execute calls in transfers and
259      approvals.
260    */
261   contract ERC827 is ERC20 {
262 
263     function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
264     function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
265     function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
266 
267   }
268 
269 
270   /**
271      @title ERC827, an extension of ERC20 token standard
272 
273      Implementation the ERC827, following the ERC20 standard with extra
274      methods to transfer value and data and execute calls in transfers and
275      approvals.
276      Uses OpenZeppelin StandardToken.
277    */
278   contract ERC827Token is ERC827, StandardToken {
279 
280     /**
281        @dev Addition to ERC20 token methods. It allows to
282        approve the transfer of value and execute a call with the sent data.
283 
284        Beware that changing an allowance with this method brings the risk that
285        someone may use both the old and the new allowance by unfortunate
286        transaction ordering. One possible solution to mitigate this race condition
287        is to first reduce the spender's allowance to 0 and set the desired value
288        afterwards:
289        https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290 
291        @param _spender The address that will spend the funds.
292        @param _value The amount of tokens to be spent.
293        @param _data ABI-encoded contract call to call `_to` address.
294 
295        @return true if the call function was executed successfully
296      */
297     function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
298       require(_spender != address(this));
299 
300       super.approve(_spender, _value);
301 
302       require(_spender.call(_data));
303 
304       return true;
305     }
306 
307     /**
308        @dev Addition to ERC20 token methods. Transfer tokens to a specified
309        address and execute a call with the sent data on the same transaction
310 
311        @param _to address The address which you want to transfer to
312        @param _value uint256 the amout of tokens to be transfered
313        @param _data ABI-encoded contract call to call `_to` address.
314 
315        @return true if the call function was executed successfully
316      */
317     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
318       require(_to != address(this));
319 
320       super.transfer(_to, _value);
321 
322       require(_to.call(_data));
323       return true;
324     }
325 
326     /**
327        @dev Addition to ERC20 token methods. Transfer tokens from one address to
328        another and make a contract call on the same transaction
329 
330        @param _from The address which you want to send tokens from
331        @param _to The address which you want to transfer to
332        @param _value The amout of tokens to be transferred
333        @param _data ABI-encoded contract call to call `_to` address.
334 
335        @return true if the call function was executed successfully
336      */
337     function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
338       require(_to != address(this));
339 
340       super.transferFrom(_from, _to, _value);
341 
342       require(_to.call(_data));
343       return true;
344     }
345 
346     /**
347      * @dev Addition to StandardToken methods. Increase the amount of tokens that
348      * an owner allowed to a spender and execute a call with the sent data.
349      *
350      * approve should be called when allowed[_spender] == 0. To increment
351      * allowed value is better to use this function to avoid 2 calls (and wait until
352      * the first transaction is mined)
353      * From MonolithDAO Token.sol
354      * @param _spender The address which will spend the funds.
355      * @param _addedValue The amount of tokens to increase the allowance by.
356      * @param _data ABI-encoded contract call to call `_spender` address.
357      */
358     function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
359       require(_spender != address(this));
360 
361       super.increaseApproval(_spender, _addedValue);
362 
363       require(_spender.call(_data));
364 
365       return true;
366     }
367 
368     /**
369      * @dev Addition to StandardToken methods. Decrease the amount of tokens that
370      * an owner allowed to a spender and execute a call with the sent data.
371      *
372      * approve should be called when allowed[_spender] == 0. To decrement
373      * allowed value is better to use this function to avoid 2 calls (and wait until
374      * the first transaction is mined)
375      * From MonolithDAO Token.sol
376      * @param _spender The address which will spend the funds.
377      * @param _subtractedValue The amount of tokens to decrease the allowance by.
378      * @param _data ABI-encoded contract call to call `_spender` address.
379      */
380     function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
381       require(_spender != address(this));
382 
383       super.decreaseApproval(_spender, _subtractedValue);
384 
385       require(_spender.call(_data));
386 
387       return true;
388     }
389 
390   }
391 
392 
393   /**
394    * @title Ownable
395    * @dev The Ownable contract has an owner address, and provides basic authorization control
396    * functions, this simplifies the implementation of "user permissions".
397    */
398   contract Ownable {
399     address public owner;
400 
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404 
405     /**
406      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
407      * account.
408      */
409     function Ownable() public {
410       owner = msg.sender;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417       require(msg.sender == owner);
418       _;
419     }
420 
421     /**
422      * @dev Allows the current owner to transfer control of the contract to a newOwner.
423      * @param newOwner The address to transfer ownership to.
424      */
425     function transferOwnership(address newOwner) public onlyOwner {
426       require(newOwner != address(0));
427       OwnershipTransferred(owner, newOwner);
428       owner = newOwner;
429     }
430 
431   }
432 
433 
434   contract Recoverable is Ownable {
435 
436     /// @dev Empty constructor (for now)
437     function Recoverable() {
438     }
439 
440     /// @dev This will be invoked by the owner, when owner wants to rescue tokens
441     /// @param token Token which will we rescue to the owner from the contract
442     function recoverTokens(ERC20Basic token) onlyOwner public {
443       token.transfer(owner, tokensToBeReturned(token));
444     }
445 
446     /// @dev Interface function, can be overwritten by the superclass
447     /// @param token Token which balance we will check and return
448     /// @return The amount of tokens (in smallest denominator) the contract owns
449     function tokensToBeReturned(ERC20Basic token) public returns (uint) {
450       return token.balanceOf(this);
451     }
452   }
453 
454 
455   /**
456    * Standard EIP-20 token with an interface marker.
457    *
458    * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
459    *
460    */
461   contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
462 
463     /* Interface declaration */
464     function isToken() public constant returns (bool weAre) {
465       return true;
466     }
467   }
468 
469   /**
470    * Hold tokens for a group investor of investors until the unlock date.
471    *
472    * After the unlock date the investor can claim their tokens.
473    *
474    * Steps
475    *
476    * - Deploy this contract
477    * - Move tokensToBeAllocated to this contract using StandardToken.transfer()
478    * - Call setInvestor for all investors from the owner account using a local script and CSV input
479    * - Wait until the freeze period is over
480    * - After the freeze time is over investors can call claim() from their address to get their tokens
481    *
482    */
483   contract InvestorTimeVault is Ownable {
484     using SafeMathLib for uint;
485 
486     /** How many investors we have now */
487     uint public investorCount;
488 
489     /** How many tokens investors have claimed so far */
490     uint public totalClaimed;
491 
492     /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
493     uint public tokensAllocatedTotal;
494 
495     /** How much we have allocated to the investors invested */
496     mapping(address => uint) public balances;
497 
498     /** How many tokens investors have claimed */
499     mapping(address => uint) public claimed;
500 
501     /** When our claim freeze is over (UNIX timestamp) */
502     mapping(address => uint) public freezeEndsAt;
503 
504     /** We can also define our own token, which will override the ICO one ***/
505     StandardTokenExt public token;
506 
507     /** We allocated tokens for investor */
508     event Allocated(address investor, uint value);
509 
510     /** We distributed tokens to an investor */
511     event Distributed(address investors, uint count);
512 
513     /**
514      * Create contract for presale investors where tokens will be locked for a period of time
515      *
516      * @param _owner Who can load investor data and lock
517      * @param _token Token contract address we are distributing
518      *
519      */
520     function InvestorTimeVault(address _owner, address _token) {
521 
522       owner = _owner;
523 
524       // Invalid owenr
525       if(owner == 0) {
526         throw;
527       }
528 
529       token = StandardTokenExt(_token);
530 
531       // Check the address looks like a token contract
532       if(!token.isToken()) {
533         throw;
534       }
535 
536     }
537 
538     /// @dev Add a presale participating allocation
539     function setInvestor(address investor, uint _freezeEndsAt, uint amount) public onlyOwner {
540 
541       uint tokensTotal = (token.balanceOf(address(this))).plus(totalClaimed);
542       uint unallocatedTokens = tokensTotal.minus(tokensAllocatedTotal); // Tokens we have in vault with no owner set
543 
544       if(amount == 0) throw; // No empty buys
545 
546       if(amount > unallocatedTokens) throw; // Can not lock tokens the vault don't have
547 
548       if(now > _freezeEndsAt) throw; // Trying to lock for negative period of time
549 
550       // Don't allow reset
551       if(balances[investor] > 0) {
552         throw;
553       }
554 
555       balances[investor] = amount;
556       freezeEndsAt[investor] = _freezeEndsAt;
557 
558       investorCount++;
559 
560       tokensAllocatedTotal = tokensAllocatedTotal.plus(amount);
561 
562       Allocated(investor, amount);
563     }
564 
565     /// @dev Get the current balance of tokens in the vault
566     /// @return uint How many tokens there are currently in vault
567     function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
568       return token.balanceOf(address(this));
569     }
570 
571     /// @dev Claim N bought tokens to the investor as the msg sender
572     function claim() {
573 
574       address investor = msg.sender;
575 
576       if(balances[investor] == 0) {
577         // Not our investor
578         throw;
579       }
580 
581       if(now < freezeEndsAt[investor]) {
582         throw; // Trying to claim early
583       }
584 
585       uint amount = balances[investor];
586 
587       balances[investor] = 0;
588 
589       claimed[investor] = claimed[investor].plus(amount);
590 
591       totalClaimed = totalClaimed.plus(amount);
592 
593       token.transfer(investor, amount);
594 
595       Distributed(investor, amount);
596     }
597 
598   }
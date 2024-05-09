1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   function Ownable() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Ownable {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261 
262   bool public mintingFinished = false;
263 
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
277     totalSupply_ = totalSupply_.add(_amount);
278     balances[_to] = balances[_to].add(_amount);
279     Mint(_to, _amount);
280     Transfer(address(0), _to, _amount);
281     return true;
282   }
283 
284   /**
285    * @dev Function to stop minting new tokens.
286    * @return True if the operation was successful.
287    */
288   function finishMinting() onlyOwner canMint public returns (bool) {
289     mintingFinished = true;
290     MintFinished();
291     return true;
292   }
293 }
294 
295 // TEAM Token is an index token of TokenStars platform
296 // Copyright (c) 2017 TokenStars
297 // Made by Aler Denisov
298 // Permission is hereby granted, free of charge, to any person obtaining a copy
299 // of this software and associated documentation files (the "Software"), to deal
300 // in the Software without restriction, including without limitation the rights
301 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
302 // copies of the Software, and to permit persons to whom the Software is
303 // furnished to do so, subject to the following conditions:
304 
305 // The above copyright notice and this permission notice shall be included in all
306 // copies or substantial portions of the Software.
307 
308 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
309 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
310 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
311 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
312 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
313 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
314 // SOFTWARE.
315 
316 
317 
318 
319 
320 
321 contract StarTokenInterface is MintableToken {
322     // Cheatsheet of inherit methods and events
323     // function transferOwnership(address newOwner);
324     // function allowance(address owner, address spender) constant returns (uint256);
325     // function transfer(address _to, uint256 _value) returns (bool);
326     // function transferFrom(address from, address to, uint256 value) returns (bool);
327     // function approve(address spender, uint256 value) returns (bool);
328     // function increaseApproval (address _spender, uint _addedValue) returns (bool success);
329     // function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
330     // function finishMinting() returns (bool);
331     // function mint(address _to, uint256 _amount) returns (bool);
332     // event Approval(address indexed owner, address indexed spender, uint256 value);
333     // event Mint(address indexed to, uint256 amount);
334     // event MintFinished();
335 
336     // Custom methods and events
337     function openTransfer() public returns (bool);
338     function toggleTransferFor(address _for) public returns (bool);
339     function extraMint() public returns (bool);
340 
341     event TransferAllowed();
342     event TransferAllowanceFor(address indexed who, bool indexed state);
343 
344 
345 }
346 
347 // TEAM Token is an index token of TokenStars platform
348 // Copyright (c) 2017 TokenStars
349 // Made by Aler Denisov
350 // Permission is hereby granted, free of charge, to any person obtaining a copy
351 // of this software and associated documentation files (the "Software"), to deal
352 // in the Software without restriction, including without limitation the rights
353 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
354 // copies of the Software, and to permit persons to whom the Software is
355 // furnished to do so, subject to the following conditions:
356 
357 // The above copyright notice and this permission notice shall be included in all
358 // copies or substantial portions of the Software.
359 
360 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
361 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
362 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
363 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
364 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
365 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
366 // SOFTWARE.
367 
368 
369 
370 
371 
372 
373 
374 contract TeamToken is StarTokenInterface {
375     using SafeMath for uint256;
376     
377     // ERC20 constants
378     string public constant name = "TEAM";
379     string public constant symbol = "TEAM";
380     uint public constant decimals = 4;
381 
382     // Minting constants
383     uint256 public constant MAXSOLD_SUPPLY = 450000000000;
384     uint256 public constant HARDCAPPED_SUPPLY = 750000000000;
385 
386     uint256 public investorSupply = 0;
387     uint256 public extraSupply = 0;
388     uint256 public freeToExtraMinting = 0;
389 
390     uint256 public constant DISTRIBUTION_INVESTORS = 60;
391     uint256 public constant DISTRIBUTION_TEAM      = 20;
392     uint256 public constant DISTRIBUTION_COMMUNITY = 20;
393 
394     address public teamTokensHolder;
395     address public communityTokensHolder;
396 
397     // Transfer rules
398     bool public transferAllowed = false;
399     mapping (address=>bool) public specialAllowed;
400 
401     // Transfer rules events
402     // event TransferAllowed();
403     // event TransferAllowanceFor(address indexed who, bool indexed state);
404 
405     // Holders events
406     event ChangeCommunityHolder(address indexed from, address indexed to);
407     event ChangeTeamHolder(address indexed from, address indexed to);
408 
409     /**
410     * @dev check transfer is allowed
411     */
412     modifier allowTransfer() {
413         require(transferAllowed || specialAllowed[msg.sender]);
414         _;
415     }
416 
417     function TeamToken() public {
418       teamTokensHolder = msg.sender;
419       communityTokensHolder = msg.sender;
420 
421       ChangeTeamHolder(0x0, teamTokensHolder);
422       ChangeCommunityHolder(0x0, communityTokensHolder);
423     }
424 
425     /**
426     * @dev change team tokens holder
427     * @param _tokenHolder The address of next team tokens holder
428     */
429     function setTeamTokensHolder(address _tokenHolder) onlyOwner public returns (bool) {
430       require(_tokenHolder != 0);
431       address temporaryEventAddress = teamTokensHolder;
432       teamTokensHolder = _tokenHolder;
433       ChangeTeamHolder(temporaryEventAddress, teamTokensHolder);
434       return true;
435     }
436 
437     /**
438     * @dev change community tokens holder
439     * @param _tokenHolder The address of next community tokens holder
440     */
441     function setCommunityTokensHolder(address _tokenHolder) onlyOwner public returns (bool) {
442       require(_tokenHolder != 0);
443       address temporaryEventAddress = communityTokensHolder;
444       communityTokensHolder = _tokenHolder;
445       ChangeCommunityHolder(temporaryEventAddress, communityTokensHolder);
446       return true;
447     }
448 
449     /**
450     * @dev Doesn't allow to send funds on contract!
451     */
452     function () payable public {
453         require(false);
454     }
455 
456     /**
457     * @dev transfer token for a specified address if transfer is open
458     * @param _to The address to transfer to.
459     * @param _value The amount to be transferred.
460     */
461     function transfer(address _to, uint256 _value) allowTransfer public returns (bool) {
462         return super.transfer(_to, _value);
463     }
464 
465     
466     /**
467     * @dev Transfer tokens from one address to another if transfer is open
468     * @param _from address The address which you want to send tokens from
469     * @param _to address The address which you want to transfer to
470     * @param _value uint256 the amount of tokens to be transferred
471      */
472     function transferFrom(address _from, address _to, uint256 _value) allowTransfer public returns (bool) {
473         return super.transferFrom(_from, _to, _value);
474     }
475 
476     /**
477     * @dev Open transfer for everyone or throws
478      */
479     function openTransfer() onlyOwner public returns (bool) {
480         require(!transferAllowed);
481         transferAllowed = true;
482         TransferAllowed();
483         return true;
484     }
485 
486     /**
487     * @dev allow transfer for the given address against global rules
488     * @param _for addres The address of special allowed transfer (required for smart contracts)
489      */
490     function toggleTransferFor(address _for) onlyOwner public returns (bool) {
491         specialAllowed[_for] = !specialAllowed[_for];
492         TransferAllowanceFor(_for, specialAllowed[_for]);
493         return specialAllowed[_for];
494     }
495 
496     /**
497     * @dev Function to mint tokens for investor
498     * @param _to The address that will receive the minted tokens.
499     * @param _amount The amount of tokens to emit.
500     * @return A boolean that indicates if the operation was successful.
501     */
502     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
503         require(_amount > 0);
504         totalSupply_ = totalSupply_.add(_amount);
505         investorSupply = investorSupply.add(_amount);
506         freeToExtraMinting = freeToExtraMinting.add(_amount);
507 
508         // Prevent to emit more than sale hardcap!
509         assert(investorSupply <= MAXSOLD_SUPPLY);
510         assert(totalSupply_ <= HARDCAPPED_SUPPLY);
511 
512         balances[_to] = balances[_to].add(_amount);
513         Mint(_to, _amount);
514         Transfer(address(this), _to, _amount);
515         return true;
516     }
517 
518 
519     /**
520     * @dev Mint extra token to corresponding token and community holders
521     */
522     function extraMint() onlyOwner canMint public returns (bool) {
523       require(freeToExtraMinting > 0);
524 
525       uint256 onePercent = freeToExtraMinting / DISTRIBUTION_INVESTORS;
526       uint256 teamPart = onePercent * DISTRIBUTION_TEAM;
527       uint256 communityPart = onePercent * DISTRIBUTION_COMMUNITY;
528       uint256 extraTokens = teamPart.add(communityPart);
529 
530       totalSupply_ = totalSupply_.add(extraTokens);
531       extraSupply = extraSupply.add(extraTokens);
532 
533       uint256 leftToNextMinting = freeToExtraMinting % DISTRIBUTION_INVESTORS;
534       freeToExtraMinting = leftToNextMinting;
535 
536       assert(totalSupply_ <= HARDCAPPED_SUPPLY);
537       assert(extraSupply <= HARDCAPPED_SUPPLY.sub(MAXSOLD_SUPPLY));
538 
539       balances[teamTokensHolder] = balances[teamTokensHolder].add(teamPart);
540       balances[communityTokensHolder] = balances[communityTokensHolder].add(communityPart);
541 
542       Mint(teamTokensHolder, teamPart);
543       Transfer(address(this), teamTokensHolder, teamPart);
544       Mint(communityTokensHolder, communityPart);
545       Transfer(address(this), communityTokensHolder, communityPart);
546 
547       return true;
548     }
549 
550     /**
551     * @dev Increase approved amount to spend 
552     * @param _spender The address which will spend the funds.
553     * @param _addedValue The amount of tokens to increase already approved amount. 
554      */
555     function increaseApproval (address _spender, uint _addedValue)  public returns (bool success) {
556         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
557         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
558         return true;
559     }
560 
561     /**
562     * @dev Decrease approved amount to spend 
563     * @param _spender The address which will spend the funds.
564     * @param _subtractedValue The amount of tokens to decrease already approved amount. 
565      */
566     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
567         uint oldValue = allowed[msg.sender][_spender];
568         if (_subtractedValue > oldValue) {
569             allowed[msg.sender][_spender] = 0;
570         } else {
571             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
572         }
573         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
574         return true;
575     }
576 
577 
578     function finilize() onlyOwner public returns (bool) {
579         require(mintingFinished);
580         require(transferAllowed);
581 
582         owner = 0x0;
583         return true;
584     }
585 }
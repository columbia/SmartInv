1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract Ownable {
52     address public owner;
53 
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61     function Ownable() public {
62         owner = msg.sender;
63     }
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0));
79         OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 
83 }
84 
85 
86 contract ERC20Basic {
87     function totalSupply() public view returns (uint256);
88     function balanceOf(address who) public view returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 
94 contract ERC20 is ERC20Basic {
95     function allowance(address owner, address spender) public view returns (uint256);
96     function transferFrom(address from, address to, uint256 value) public returns (bool);
97     function approve(address spender, uint256 value) public returns (bool);
98     event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 
102 contract BasicToken is ERC20Basic {
103     using SafeMath for uint256;
104 
105     mapping(address => uint256) balances;
106 
107     uint256 totalSupply_;
108 
109   /**
110   * @dev total number of tokens in existence
111   */
112     function totalSupply() public view returns (uint256) {
113         return totalSupply_;
114     }
115 
116   /**
117   * @dev transfer token for a specified address
118   * @param _to The address to transfer to.
119   * @param _value The amount to be transferred.
120   */
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124 
125     // SafeMath.sub will throw if there is not enough balance.
126         balances[msg.sender] = balances[msg.sender].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         Transfer(msg.sender, _to, _value);
129         return true;
130     }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137     function balanceOf(address _owner) public view returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141 }
142 
143 
144 contract StandardToken is ERC20, BasicToken {
145 
146     string public name = "ME Token";
147     string public symbol = "MET";
148     uint8 public decimals = 18;
149     mapping (address => mapping (address => uint256)) internal allowed;
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
158         require(_to != address(0));
159         require(_value <= balances[_from]);
160         require(_value <= allowed[_from][msg.sender]);
161 
162         balances[_from] = balances[_from].sub(_value);
163         balances[_to] = balances[_to].add(_value);
164         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165         Transfer(_from, _to, _value);
166         return true;
167     }
168 
169   /**
170    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
171    *
172    * Beware that changing an allowance with this method brings the risk that someone may use both the old
173    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
174    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    * @param _spender The address which will spend the funds.
177    * @param _value The amount of tokens to be spent.
178    */
179     function approve(address _spender, uint256 _value) public returns (bool) {
180         allowed[msg.sender][_spender] = _value;
181         Approval(msg.sender, _spender, _value);
182         return true;
183     }
184 
185   /**
186    * @dev Function to check the amount of tokens that an owner allowed to a spender.
187    * @param _owner address The address which owns the funds.
188    * @param _spender address The address which will spend the funds.
189    * @return A uint256 specifying the amount of tokens still available for the spender.
190    */
191     function allowance(address _owner, address _spender) public view returns (uint256) {
192         return allowed[_owner][_spender];
193     }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
206         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
207         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
208         return true;
209     }
210 
211   /**
212    * @dev Decrease the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To decrement
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _subtractedValue The amount of tokens to decrease the allowance by.
220    */
221     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
222         uint oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224             allowed[msg.sender][_spender] = 0;
225         } else {
226             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232 }
233 
234 
235 contract MintableToken is StandardToken, Ownable {
236     event Mint(address indexed to, uint256 amount);
237     event MintFinished();
238 
239     bool public mintingFinished = false;
240 
241     modifier canMint() {
242         require(!mintingFinished);
243         _;
244     }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252     function mint(address _to, uint256 _amount) public onlyOwner canMint returns (bool) {
253         totalSupply_ = totalSupply_.add(_amount);
254         balances[_to] = balances[_to].add(_amount);
255         Mint(_to, _amount);
256         Transfer(address(0), _to, _amount);
257         return true;
258     }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264     function finishMinting() public onlyOwner canMint returns (bool) {
265         mintingFinished = true;
266         MintFinished();
267         return true;
268     }
269 }
270 
271 
272 contract ERC721 {
273     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
274     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
275 
276     function balanceOf(address _owner) public view returns (uint256 _balance);
277     function ownerOf(uint256 _tokenId) public view returns (address _owner);
278     function transfer(address _to, uint256 _tokenId) public;
279     function approve(address _to, uint256 _tokenId) public;
280     function takeOwnership(uint256 _tokenId) public;
281 }
282 
283 
284 contract ERC721Token is ERC721, Ownable {
285     using SafeMath for uint256;
286 
287     string public constant NAME = "ERC-ME Contribution";
288     string public constant SYMBOL = "MEC";
289 
290     // Total amount of tokens
291     uint256 private totalTokens;
292 
293     // Mapping from token ID to owner
294     mapping (uint256 => address) private tokenOwner;
295 
296     // Mapping from token ID to approved address
297     mapping (uint256 => address) private tokenApprovals;
298 
299     // Mapping from owner to list of owned token IDs
300     mapping (address => uint256[]) private ownedTokens;
301 
302     // Mapping from token ID to index of the owner tokens list
303     mapping(uint256 => uint256) private ownedTokensIndex;
304 
305     struct Contribution {
306         address contributor; // The address of the contributor in the crowdsale
307         uint256 contributionAmount; // The amount of the contribution
308         uint64 contributionTimestamp; // The time at which the contribution was made
309     }
310 
311     Contribution[] public contributions;
312 
313     event ContributionMinted(address indexed _minter, uint256 _contributionSent, uint256 _tokenId);
314 
315   /**
316   * @dev Guarantees msg.sender is owner of the given token
317   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
318   */
319     modifier onlyOwnerOf(uint256 _tokenId) {
320         require(ownerOf(_tokenId) == msg.sender);
321         _;
322     }
323 
324   /**
325   * @dev Gets the total amount of tokens stored by the contract
326   * @return uint256 representing the total amount of tokens
327   */
328     function totalSupply() public view returns (uint256) {
329         return contributions.length;
330     }
331 
332   /**
333   * @dev Gets the balance of the specified address
334   * @param _owner address to query the balance of
335   * @return uint256 representing the amount owned by the passed address
336   */
337     function balanceOf(address _owner) public view returns (uint256) {
338         return ownedTokens[_owner].length;
339     }
340 
341   /**
342   * @dev Gets the list of tokens owned by a given address
343   * @param _owner address to query the tokens of
344   * @return uint256[] representing the list of tokens owned by the passed address
345   */
346     function tokensOf(address _owner) public view returns (uint256[]) {
347         return ownedTokens[_owner];
348     }
349 
350   /**
351   * @dev Gets the owner of the specified token ID
352   * @param _tokenId uint256 ID of the token to query the owner of
353   * @return owner address currently marked as the owner of the given token ID
354   */
355     function ownerOf(uint256 _tokenId) public view returns (address) {
356         address owner = tokenOwner[_tokenId];
357         require(owner != address(0));
358         return owner;
359     }
360 
361   /**
362    * @dev Gets the approved address to take ownership of a given token ID
363    * @param _tokenId uint256 ID of the token to query the approval of
364    * @return address currently approved to take ownership of the given token ID
365    */
366     function approvedFor(uint256 _tokenId) public view returns (address) {
367         return tokenApprovals[_tokenId];
368     }
369 
370   /**
371   * @dev Transfers the ownership of a given token ID to another address
372   * @param _to address to receive the ownership of the given token ID
373   * @param _tokenId uint256 ID of the token to be transferred
374   */
375     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
376         clearApprovalAndTransfer(msg.sender, _to, _tokenId);
377     }
378 
379   /**
380   * @dev Approves another address to claim for the ownership of the given token ID
381   * @param _to address to be approved for the given token ID
382   * @param _tokenId uint256 ID of the token to be approved
383   */
384     function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
385         address owner = ownerOf(_tokenId);
386         require(_to != owner);
387         if (approvedFor(_tokenId) != 0 || _to != 0) {
388             tokenApprovals[_tokenId] = _to;
389             Approval(owner, _to, _tokenId);
390         }
391     }
392 
393   /**
394   * @dev Claims the ownership of a given token ID
395   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
396   */
397     function takeOwnership(uint256 _tokenId) public {
398         require(isApprovedFor(msg.sender, _tokenId));
399         clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
400     }
401 
402   /**
403   * @dev Mint token function
404   * @param _to The address that will own the minted token
405   */
406     function mint(address _to, uint256 _amount) public onlyOwner {
407         require(_to != address(0));
408 
409         Contribution memory contribution = Contribution({
410             contributor: _to,
411             contributionAmount: _amount,
412             contributionTimestamp: uint64(now)
413         });
414         uint256 tokenId = contributions.push(contribution) - 1;
415 
416         addToken(_to, tokenId);
417         Transfer(0x0, _to, tokenId);
418         ContributionMinted(_to, _amount, tokenId);
419     }
420 
421     function getContributor(uint256 _tokenId) public view returns(address contributor) {
422         Contribution memory contribution = contributions[_tokenId];
423         contributor = contribution.contributor;
424     }
425 
426     function getContributionAmount(uint256 _tokenId) public view returns(uint256 contributionAmount) {
427         Contribution memory contribution = contributions[_tokenId];
428         contributionAmount = contribution.contributionAmount;
429     }
430 
431     function getContributionTime(uint256 _tokenId) public view returns(uint64 contributionTimestamp) {
432         Contribution memory contribution = contributions[_tokenId];
433         contributionTimestamp = contribution.contributionTimestamp;
434     }
435 
436   /**
437   * @dev Burns a specific token
438   * @param _tokenId uint256 ID of the token being burned by the msg.sender
439   */
440     function _burn(uint256 _tokenId) internal onlyOwnerOf(_tokenId) {
441         if (approvedFor(_tokenId) != 0) {
442             clearApproval(msg.sender, _tokenId);
443         }
444         removeToken(msg.sender, _tokenId);
445         Transfer(msg.sender, 0x0, _tokenId);
446     }
447 
448   /**
449    * @dev Tells whether the msg.sender is approved for the given token ID or not
450    * This function is not private so it can be extended in further implementations like the operatable ERC721
451    * @param _owner address of the owner to query the approval of
452    * @param _tokenId uint256 ID of the token to query the approval of
453    * @return bool whether the msg.sender is approved for the given token ID or not
454    */
455     function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
456         return approvedFor(_tokenId) == _owner;
457     }
458 
459   /**
460   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
461   * @param _from address which you want to send tokens from
462   * @param _to address which you want to transfer the token to
463   * @param _tokenId uint256 ID of the token to be transferred
464   */
465     function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
466         require(_to != address(0));
467         require(_to != ownerOf(_tokenId));
468         require(ownerOf(_tokenId) == _from);
469 
470         clearApproval(_from, _tokenId);
471         removeToken(_from, _tokenId);
472         addToken(_to, _tokenId);
473         Transfer(_from, _to, _tokenId);
474     }
475 
476   /**
477   * @dev Internal function to clear current approval of a given token ID
478   * @param _tokenId uint256 ID of the token to be transferred
479   */
480     function clearApproval(address _owner, uint256 _tokenId) private {
481         require(ownerOf(_tokenId) == _owner);
482         tokenApprovals[_tokenId] = 0;
483         Approval(_owner, 0, _tokenId);
484     }
485 
486   /**
487   * @dev Internal function to add a token ID to the list of a given address
488   * @param _to address representing the new owner of the given token ID
489   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
490   */
491     function addToken(address _to, uint256 _tokenId) private {
492         require(tokenOwner[_tokenId] == address(0));
493         tokenOwner[_tokenId] = _to;
494         uint256 length = balanceOf(_to);
495         ownedTokens[_to].push(_tokenId);
496         ownedTokensIndex[_tokenId] = length;
497         totalTokens = totalTokens.add(1);
498     }
499 
500   /**
501   * @dev Internal function to remove a token ID from the list of a given address
502   * @param _from address representing the previous owner of the given token ID
503   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
504   */
505     function removeToken(address _from, uint256 _tokenId) private {
506         require(ownerOf(_tokenId) == _from);
507 
508         uint256 tokenIndex = ownedTokensIndex[_tokenId];
509         uint256 lastTokenIndex = balanceOf(_from).sub(1);
510         uint256 lastToken = ownedTokens[_from][lastTokenIndex];
511 
512         tokenOwner[_tokenId] = 0;
513         ownedTokens[_from][tokenIndex] = lastToken;
514         ownedTokens[_from][lastTokenIndex] = 0;
515     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
516     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
517     // the lastToken to the first position, and then dropping the element placed in the last position of the list
518 
519         ownedTokens[_from].length--;
520         ownedTokensIndex[_tokenId] = 0;
521         ownedTokensIndex[lastToken] = tokenIndex;
522         totalTokens = totalTokens.sub(1);
523     }
524 }
525 
526 
527 /*
528 *
529 * ERC-ME Beta Game
530 *
531 * @author Ghilia Weldesselasie
532 *
533 * Your mission, if you choose to accept it: get access to the ERC-ME beta.
534 * How do you do that? It's simple.
535 *   1. Become ekspert devloper
536 *   2. ???
537 *   3. Profit
538 *
539 * Hint: Those who can mint a certain asset will have access to the beta
540 *
541 * WARNING
542 * - You might wanna read the code (don't look at it too closely tho just send your ETH to the address)
543 * - Beware people waiting to use your funds to beat the game at your expense (Don't get finessed boi!)
544 *
545 * Join us on Discord: https://discord.gg/nDdTm5z
546 *
547 * Oh and thanks for participating in our presale
548 *
549 *
550 */
551 
552 //Token Game contract - allows skilled players to gain access to the ERC-ME beta
553 contract TokenGame {
554     using SafeMath for uint256;
555 
556     // The ME-Token being minted
557     MintableToken public token;
558     // The NFT being minted, thought it might be useful
559     ERC721Token public pass;
560     // A mapping of all the people who funded to the presale
561     mapping(address => uint256) public funders;
562     // An array of all the people who beat the game
563     mapping(address => bool) public isWinner;
564     // amount of raised money in wei
565     uint256 public weiRaised;
566     // cap of the Crowdsale
567     uint256 public cap = 7000 ether;
568     // My wallet
569     address public wallet;
570 
571     event GameWon(address indexed winner, uint256 valueUnlocked);
572 
573     //Constructor
574     function TokenGame(ERC721Token _pass, MintableToken _token) public {
575         pass = _pass;
576         token = _token;
577         wallet = msg.sender;
578     }
579 
580     // Beating the game should be as simple as sending all of your ETH to the contract address
581     // Idk tho I could be wrong :)
582     function () public payable {
583         beatGame();
584     }
585 
586     // If you call this function you should beat the game... I think
587     function beatGame() public payable {
588         require(weiRaised.add(msg.value) <= cap);
589         weiRaised = weiRaised.add(msg.value); // update state
590         funders[msg.sender] = funders[msg.sender].add(msg.value);
591         wallet.transfer(msg.value);
592     }
593 
594     // Check the balance
595     function getBalance() public view returns(uint256 balance) {
596         return this.balance;
597     }
598 
599     // You might wanna check if the cap has been reached before doing anything
600     function capReached() public view returns(bool) {
601         return weiRaised >= cap;
602     }
603 
604     function changeOwner() public {
605         require(msg.sender == wallet);
606         token.transferOwnership(wallet);
607         pass.transferOwnership(wallet);
608     }
609 
610     // I wouldn't call this if I were you, who knows what could happen
611     function loseGame() public {
612         require(this.balance > 0);
613         weiRaised = weiRaised.add(this.balance); // update state
614 
615         isWinner[msg.sender] = true;
616         funders[msg.sender] = funders[msg.sender].add(this.balance);
617 
618         receivePrize(msg.sender, this.balance);
619         GameWon(msg.sender, this.balance);
620 
621         wallet.transfer(this.balance);
622     }
623 
624     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
625         // how many token units a buyer gets per wei
626         return weiAmount.mul(10000);
627     }
628 
629     function receivePrize(address _winner, uint256 _prizeMoney) private {
630         // The code for token minting
631         uint256 tokens = getTokenAmount(_prizeMoney);
632         token.mint(_winner, tokens);
633         // The code for the pass minting
634         pass.mint(_winner, _prizeMoney);
635     }
636 
637 }
1 pragma solidity ^0.4.20;
2 
3 contract GenesisProtected {
4     modifier addrNotNull(address _address) {
5         require(_address != address(0));
6         _;
7     }
8 }
9 
10 
11 // ----------------------------------------------------------------------------
12 // The original code is taken from:
13 // https://github.com/OpenZeppelin/zeppelin-solidity:
14 //     master branch from zeppelin-solidity/contracts/ownership/Ownable.sol
15 // Changed function name: transferOwnership -> setOwner.
16 // Added inheritance from GenesisProtected (address != 0x0).
17 // setOwner refactored for emitting after owner replacing.
18 // ----------------------------------------------------------------------------
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable is GenesisProtected {
26     address public owner;
27 
28     /**
29      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
30      * account.
31      */
32     function Ownable() public {
33         owner = msg.sender;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     /**
45      * @dev Allows the current owner to transfer control of the contract to a _new.
46      * @param a The address to transfer ownership to.
47      */
48     function setOwner(address a) external onlyOwner addrNotNull(a) {
49         owner = a;
50         emit OwnershipReplaced(msg.sender, a);
51     }
52 
53     event OwnershipReplaced(
54         address indexed previousOwner,
55         address indexed newOwner
56     );
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // ERC Token Standard #20 Interface
62 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
63 // The original code is taken from:
64 // https://theethereum.wiki/w/index.php/ERC20_Token_Standard
65 // ----------------------------------------------------------------------------
66 contract ERC20Interface {
67     function totalSupply() public constant returns (uint);
68     function balanceOf(address tokenOwner)
69         public constant returns (uint balance);
70     function allowance(address tokenOwner, address spender)
71         public constant returns (uint remaining);
72     function transfer(address to, uint tokens) public returns (bool success);
73     function approve(address spender, uint tokens)
74         public returns (bool success);
75     function transferFrom(address from, address to, uint tokens)
76         public returns (bool success);
77 
78     event Transfer(address indexed from, address indexed to, uint tokens);
79     event Approval(
80         address indexed tokenOwner,
81         address indexed spender,
82         uint tokens
83     );
84 }
85 
86 contract Enums {
87     // Type for mapping uint (index) => name for baskets types described in WP
88     enum BasketType {
89         unknown, // 0 unknown
90         team, // 1 Team
91         foundation, // 2 Foundation
92         arr, // 3 Advertisement, Referral program, Reward
93         advisors, // 4 Advisors
94         bounty, // 5 Bounty
95         referral, // 6 Referral
96         referrer // 7 Referrer
97     }
98 }
99 
100 
101 contract WPTokensBaskets is Ownable, Enums {
102     // This mapping holds all accounts ever used as baskets forever
103     mapping (address => BasketType) internal types;
104 
105     // Baskets for tokens
106     address public team;
107     address public foundation;
108     address public arr;
109     address public advisors;
110     address public bounty;
111 
112     // Public constructor
113     function WPTokensBaskets(
114         address _team,
115         address _foundation,
116         address _arr,
117         address _advisors,
118         address _bounty
119     )
120         public
121     {
122         setTeam(_team);
123         setFoundation(_foundation);
124         setARR(_arr);
125         setAdvisors(_advisors);
126         setBounty(_bounty);
127     }
128 
129     // Fallback function - do not apply any ether to this contract.
130     function () external payable {
131         revert();
132     }
133 
134     // Last resort to return ether.
135     // See the last warning at
136     // http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
137     // for such cases.
138     function transferEtherTo(address a) external onlyOwner addrNotNull(a) {
139         a.transfer(address(this).balance);
140     }
141 
142     function typeOf(address a) public view returns (BasketType) {
143         return types[a];
144     }
145 
146     // Return truth if given address is not registered as token basket.
147     function isUnknown(address a) public view returns (bool) {
148         return types[a] == BasketType.unknown;
149     }
150 
151     function isTeam(address a) public view returns (bool) {
152         return types[a] == BasketType.team;
153     }
154 
155     function isFoundation(address a) public view returns (bool) {
156         return types[a] == BasketType.foundation;
157     }
158 
159     function setTeam(address a) public onlyOwner addrNotNull(a) {
160         require(isUnknown(a));
161         types[team = a] = BasketType.team;
162     }
163 
164     function setFoundation(address a) public onlyOwner addrNotNull(a) {
165         require(isUnknown(a));
166         types[foundation = a] = BasketType.foundation;
167     }
168 
169     function setARR(address a) public onlyOwner addrNotNull(a) {
170         require(isUnknown(a));
171         types[arr = a] = BasketType.arr;
172     }
173 
174     function setAdvisors(address a) public onlyOwner addrNotNull(a) {
175         require(isUnknown(a));
176         types[advisors = a] = BasketType.advisors;
177     }
178 
179     function setBounty(address a) public onlyOwner addrNotNull(a) {
180         require(types[a] == BasketType.unknown);
181         types[bounty = a] = BasketType.bounty;
182     }
183 }
184 
185 // ----------------------------------------------------------------------------
186 // The original code is taken from:
187 // https://github.com/OpenZeppelin/zeppelin-solidity:
188 //     master branch from zeppelin-solidity/contracts/math/SafeMath.sol
189 // ----------------------------------------------------------------------------
190 
191 /**
192  * @title SafeMath
193  * @dev Math operations with safety checks that throw on error
194  */
195 library SafeMath {
196     /**
197      * @dev Multiplies two numbers, throws on overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         if (a == 0)
201             return 0;
202         uint256 c = a * b;
203         assert(c / a == b);
204         return c;
205     }
206 
207     /**
208      * @dev Integer division of two numbers, truncating the quotient.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         // assert(b > 0); // Solidity automatically throws when dividing by 0
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214         return c;
215     }
216 
217     /**
218      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is
219      * greater than minuend).
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         assert(b <= a);
223         return a - b;
224     }
225 
226     /**
227      * @dev Adds two numbers, throws on overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         uint256 c = a + b;
231         assert(c >= a);
232         return c;
233     }
234 }
235 
236 
237 contract Token is Ownable, ERC20Interface, Enums {
238     using SafeMath for uint;
239 
240     // Token full name
241     string private constant NAME = "EnvisionX EXCHAIN Token";
242     // Token symbol name
243     string private constant SYMBOL = "EXT";
244     // Token max fraction, in decimal signs after the point
245     uint8 private constant DECIMALS = 18;
246 
247     // Tokens max supply, in EXTwei
248     uint public constant MAX_SUPPLY = 3000000000 * (10**uint(DECIMALS));
249 
250     // Tokens balances map
251     mapping(address => uint) internal balances;
252 
253     // Maps with allowed amounts fot TransferFrom
254     mapping (address => mapping (address => uint)) internal allowed;
255 
256     // Total amount of issued tokens, in EXTwei
257     uint internal _totalSupply;
258 
259     // Map with Ether founds amount by address (using when refunds)
260     mapping(address => uint) internal etherFunds;
261     uint internal _earnedFunds;
262     // Map with refunded addreses (Black List)
263     mapping(address => bool) internal refunded;
264 
265     // Address of sale agent (a contract) which can mint new tokens
266     address public mintAgent;
267 
268     // Token transfer allowed only when token minting is finished
269     bool public isMintingFinished = false;
270     // When minting was finished
271     uint public mintingStopDate;
272 
273     // Total amount of tokens minted to team basket, in EXTwei.
274     // This will not include tokens, transferred to team basket
275     // after minting is finished.
276     uint public teamTotal;
277     // Amount of tokens spent by team in first 96 weeks since
278     // minting finish date. Used to calculate team spend
279     // restrictions according to ICO White Paper.
280     uint public spentByTeam;
281 
282     // Address of WPTokensBaskets contract
283     WPTokensBaskets public wpTokensBaskets;
284 
285     // Constructor
286     function Token(WPTokensBaskets baskets) public {
287         wpTokensBaskets = baskets;
288         mintAgent = owner;
289     }
290 
291     // Fallback function - do not apply any ether to this contract.
292     function () external payable {
293         revert();
294     }
295 
296     // Last resort to return ether.
297     // See the last warning at
298     // http://solidity.readthedocs.io/en/develop/contracts.html#fallback-function
299     // for such cases.
300     function transferEtherTo(address a) external onlyOwner addrNotNull(a) {
301         a.transfer(address(this).balance);
302     }
303 
304     /**
305     ----------------------------------------------------------------------
306     ERC20 Interface implementation
307     */
308 
309     // Return token full name
310     function name() public pure returns (string) {
311         return NAME;
312     }
313 
314     // Return token symbol name
315     function symbol() public pure returns (string) {
316         return SYMBOL;
317     }
318 
319     // Return amount of decimals after point
320     function decimals() public pure returns (uint8) {
321         return DECIMALS;
322     }
323 
324     // Return total amount of issued tokens, in EXTwei
325     function totalSupply() public constant returns (uint) {
326         return _totalSupply;
327     }
328 
329     // Return account balance in tokens (in EXTwei)
330     function balanceOf(address _address) public constant returns (uint) {
331         return balances[_address];
332     }
333 
334     // Transfer tokens to another account
335     function transfer(address to, uint value)
336         public
337         addrNotNull(to)
338         returns (bool)
339     {
340         if (balances[msg.sender] < value)
341             return false;
342         if (isFrozen(wpTokensBaskets.typeOf(msg.sender), value))
343             return false;
344         balances[msg.sender] = balances[msg.sender].sub(value);
345         balances[to] = balances[to].add(value);
346         saveTeamSpent(msg.sender, value);
347         emit Transfer(msg.sender, to, value);
348         return true;
349     }
350 
351     // Transfer tokens from one account to another,
352     // using permissions defined with approve() method.
353     function transferFrom(address from, address to, uint value)
354         public
355         addrNotNull(to)
356         returns (bool)
357     {
358         if (balances[from] < value)
359             return false;
360         if (allowance(from, msg.sender) < value)
361             return false;
362         if (isFrozen(wpTokensBaskets.typeOf(from), value))
363             return false;
364         balances[from] = balances[from].sub(value);
365         balances[to] = balances[to].add(value);
366         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
367         saveTeamSpent(from, value);
368         emit Transfer(from, to, value);
369         return true;
370     }
371 
372     // Allow to transfer given amount of tokens (in EXTwei)
373     // to account which is not owner.
374     function approve(address spender, uint value) public returns (bool) {
375         if (msg.sender == spender)
376             return false;
377         allowed[msg.sender][spender] = value;
378         emit Approval(msg.sender, spender, value);
379         return true;
380     }
381 
382     // Return amount of tokens (in EXTwei) which allowed to
383     // be transferred by non-owner spender
384     function allowance(address _owner, address spender)
385         public
386         constant
387         returns (uint)
388     {
389         return allowed[_owner][spender];
390     }
391 
392     /**
393     ----------------------------------------------------------------------
394     Other methods
395     */
396 
397     // Return account funds in ether (in wei)
398     function etherFundsOf(address _address) public constant returns (uint) {
399         return etherFunds[_address];
400     }
401 
402     // Return total amount of funded ether, in wei
403     function earnedFunds() public constant returns (uint) {
404         return _earnedFunds;
405     }
406 
407     // Return true if given address have been refunded
408     function isRefunded(address _address) public view returns (bool) {
409         return refunded[_address];
410     }
411 
412     // Set new address of sale agent contract.
413     // Will be called for each sale stage: PrivateSale, PreSale, MainSale.
414     function setMintAgent(address a) public onlyOwner addrNotNull(a) {
415         emit MintAgentReplaced(mintAgent, a);
416         mintAgent = a;
417     }
418 
419     // Interface for sale agent contract - mint new tokens
420     function mint(address to, uint256 extAmount, uint256 etherAmount) public {
421         require(!isMintingFinished);
422         require(msg.sender == mintAgent);
423         require(!refunded[to]);
424         _totalSupply = _totalSupply.add(extAmount);
425         require(_totalSupply <= MAX_SUPPLY);
426         balances[to] = balances[to].add(extAmount);
427         if (wpTokensBaskets.isUnknown(to)) {
428             _earnedFunds = _earnedFunds.add(etherAmount);
429             etherFunds[to] = etherFunds[to].add(etherAmount);
430         } else if (wpTokensBaskets.isTeam(to)) {
431             teamTotal = teamTotal.add(extAmount);
432         }
433         emit Mint(to, extAmount);
434         emit Transfer(msg.sender, to, extAmount);
435     }
436 
437     // Destroy minted tokens and refund ether spent by investor.
438     // Used in AML (Anti Money Laundering) workflow.
439     // Will be called only by humans because there is no way
440     // to withdraw crowdfunded ether from Beneficiary account
441     // from context of this account.
442     // Important note: all tokens minted to team, foundation etc.
443     // will NOT be burned, because they in general are spent
444     // during the sale and its too expensive to track all these
445     // transactions.
446     function burnTokensAndRefund(address _address)
447         external
448         payable
449         addrNotNull(_address)
450         onlyOwner()
451     {
452         require(msg.value > 0 && msg.value == etherFunds[_address]);
453         _totalSupply = _totalSupply.sub(balances[_address]);
454         balances[_address] = 0;
455         _earnedFunds = _earnedFunds.sub(msg.value);
456         etherFunds[_address] = 0;
457         refunded[_address] = true;
458         _address.transfer(msg.value);
459     }
460 
461     // Stop tokens minting forever.
462     function finishMinting() external onlyOwner {
463         require(!isMintingFinished);
464         isMintingFinished = true;
465         mintingStopDate = now;
466         emit MintingFinished();
467     }
468 
469     /**
470     ----------------------------------------------------------------------
471     Tokens freeze logic, according to ICO White Paper
472     */
473 
474     // Return truth if given _value amount of tokens (in EXTwei)
475     // cannot be transferred from account due to spend restrictions
476     // defined in ICO White Paper.
477     // !!!Caveat of current implementaion!!!
478     // Say,
479     //  1. There was 100 tokens minted to the team basket;
480     //  2. Minting was finished and 24 weeks elapsed, and now
481     //    team can spend up to 25 tokens till next 24 weeks;
482     //  3. Someone transfers another 100 tokens to the team basket;
483     //  4. ...
484     // Problem is, actually, you can't spend any of these extra 100
485     // tokens until 96 weeks will elapse since minting finish date.
486     // That's because after next 24 weeks will be unlocked only
487     // 25 tokens more (25% of *minted* tokens) and so on.
488     // So, DO NOT send tokens to the team basket until 96 weeks elapse!
489     function isFrozen(
490         BasketType _basketType,
491         uint _value
492     )
493         public view returns (bool)
494     {
495         if (!isMintingFinished) {
496             // Allow spend only after minting is finished
497             return true;
498         }
499         if (_basketType == BasketType.foundation) {
500             // Allow to spend foundation tokens only after
501             // 48 weeks after minting is finished
502             return now < mintingStopDate + 48 weeks;
503         }
504         if (_basketType == BasketType.team) {
505             // Team allowed to spend tokens:
506             //  25%  - after minting finished date + 24 weeks;
507             //  50%  - after minting finished date + 48 weeks;
508             //  75%  - after minting finished date + 72 weeks;
509             //  100% - after minting finished date + 96 weeks.
510             if (mintingStopDate + 96 weeks <= now) {
511                 return false;
512             }
513             if (now < mintingStopDate + 24 weeks)
514                 return true;
515             // Calculate fraction as percents multipled to 10^10.
516             // Without this owner will be able to spend fractions
517             // less than 1% per transaction.
518             uint fractionSpent =
519                 spentByTeam.add(_value).mul(1000000000000).div(teamTotal);
520             if (now < mintingStopDate + 48 weeks) {
521                 return 250000000000 < fractionSpent;
522             }
523             if (now < mintingStopDate + 72 weeks) {
524                 return 500000000000 < fractionSpent;
525             }
526             // from 72 to 96 weeks elapsed
527             return 750000000000 < fractionSpent;
528         }
529         // No restrictions for other token holders
530         return false;
531     }
532 
533     // Save amount of spent tokens by team till 96 weeks after minting
534     // finish date. This is vital because without the check we'll eventually
535     // overflow the uint256.
536     function saveTeamSpent(address _owner, uint _value) internal {
537         if (wpTokensBaskets.isTeam(_owner)) {
538             if (now < mintingStopDate + 96 weeks)
539                 spentByTeam = spentByTeam.add(_value);
540         }
541     }
542 
543     /**
544     ----------------------------------------------------------------------
545     Events
546     */
547 
548     // Emitted when mint agent (address of a sale contract)
549     // replaced with new one
550     event MintAgentReplaced(
551         address indexed previousMintAgent,
552         address indexed newMintAgent
553     );
554 
555     // Emitted when new tokens were created and funded to account
556     event Mint(address indexed to, uint256 amount);
557 
558     // Emitted when tokens minting is finished.
559     event MintingFinished();
560 }
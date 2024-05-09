1 pragma solidity ^0.4.24;
2 
3 /**
4   * @title SafeMath
5   * @dev Math operations with safety checks that throw on error
6   */
7 library SafeMath {
8 /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 /**
50 * @title Ownable
51 * @dev The Ownable contract has an owner address, and provides basic authorization control
52 * functions, this simplifies the implementation of "user permissions".
53 */
54 contract Ownable {
55     address public owner;
56     event OwnershipRenounced(address indexed previousOwner);
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61     * account.
62     */
63     constructor() public {
64         owner = msg.sender;
65     }
66 
67     /**
68     * @dev Throws if called by any account other than the owner.
69     */
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     /**
76     * @dev Allows the current owner to transfer control of the contract to a newOwner.
77     * @param newOwner The address to transfer ownership to.
78     */
79     function transferOwnership(address newOwner) public onlyOwner {
80         require(newOwner != address(0));
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83     }
84 
85     /**
86     * @dev Allows the current owner to relinquish control of the contract.
87     */
88     function renounceOwnership() public onlyOwner {
89         emit OwnershipRenounced(owner);
90         owner = address(0);
91     }
92 }
93 
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     function transfer(address to, uint256 value) public returns (bool);
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 
108 /**
109  * @title ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 is ERC20Basic {
113     function allowance(address owner, address spender) public view returns (uint256);
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115     function approve(address spender, uint256 value) public returns (bool);
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 contract VANMToken is ERC20, Ownable {
121     using SafeMath for uint256;
122 
123     //Variables
124     string public symbol;
125     string public name;
126     uint8 public decimals;
127     uint256 public _totalSupply;
128 
129     mapping(address => uint256) balances;
130     mapping(address => mapping(address => uint256)) internal allowed;
131 
132     uint256 public presaleSupply;
133     address public presaleAddress;
134 
135     uint256 public crowdsaleSupply;
136     address public crowdsaleAddress;
137 
138     uint256 public platformSupply;
139     address public platformAddress;
140 
141     uint256 public incentivisingSupply;
142     address public incentivisingAddress;
143 
144     uint256 public teamSupply;
145     address public teamAddress;
146 
147     uint256 public crowdsaleEndsAt;
148 
149     uint256 public teamVestingPeriod;
150 
151     bool public presaleFinalized = false;
152 
153     bool public crowdsaleFinalized = false;
154 
155     //Modifiers
156     //Only presale contract
157     modifier onlyPresale() {
158         require(msg.sender == presaleAddress);
159         _;
160     }
161 
162     //Only crowdsale contract
163     modifier onlyCrowdsale() {
164         require(msg.sender == crowdsaleAddress);
165         _;
166     }
167 
168     //crowdsale has to be over
169     modifier notBeforeCrowdsaleEnds(){
170         require(block.timestamp >= crowdsaleEndsAt);
171         _;
172     }
173 
174     // Check if vesting period is over
175     modifier checkTeamVestingPeriod() {
176         require(block.timestamp >= teamVestingPeriod);
177         _;
178     }
179 
180     //Events
181     event PresaleFinalized(uint tokensRemaining);
182 
183     event CrowdsaleFinalized(uint tokensRemaining);
184 
185     //Constructor
186     constructor() public {
187 
188         //Basic information
189         symbol = "VANM";
190         name = "VANM";
191         decimals = 18;
192 
193         //Total VANM supply
194         _totalSupply = 240000000 * 10**uint256(decimals);
195 
196         // 10% of total supply for presale
197         presaleSupply = 24000000 * 10**uint256(decimals);
198 
199         // 50% of total supply for crowdsale
200         crowdsaleSupply = 120000000 * 10**uint256(decimals);
201 
202         // 10% of total supply for platform
203         platformSupply = 24000000 * 10**uint256(decimals);
204 
205         // 20% of total supply for incentivising
206         incentivisingSupply = 48000000 * 10**uint256(decimals);
207 
208         // 10% of total supply for team
209         teamSupply = 24000000 * 10**uint256(decimals);
210 
211         platformAddress = 0x6962371D5a9A229C735D936df5CE6C690e66b718;
212 
213         teamAddress = 0xB9e54846da59C27eFFf06C3C08D5d108CF81FEae;
214 
215         // 01.05.2019 00:00:00 UTC
216         crowdsaleEndsAt = 1556668800;
217 
218         // 2 years vesting period
219         teamVestingPeriod = crowdsaleEndsAt.add(2 * 365 * 1 days);
220 
221         balances[platformAddress] = platformSupply;
222         emit Transfer(0x0, platformAddress, platformSupply);
223 
224         balances[incentivisingAddress] = incentivisingSupply;
225     }
226 
227     //External functions
228     //Set Presale Address when it's deployed
229     function setPresaleAddress(address _presaleAddress) external onlyOwner {
230         require(presaleAddress == 0x0);
231         presaleAddress = _presaleAddress;
232         balances[_presaleAddress] = balances[_presaleAddress].add(presaleSupply);
233     }
234 
235     // Finalize presale. Leftover tokens will overflow to crowdsale.
236     function finalizePresale() external onlyPresale {
237         require(presaleFinalized == false);
238         uint256 amount = balanceOf(presaleAddress);
239         if (amount > 0) {
240             balances[presaleAddress] = 0;
241             balances[crowdsaleAddress] = balances[crowdsaleAddress].add(amount);
242         }
243         presaleFinalized = true;
244         emit PresaleFinalized(amount);
245     }
246 
247     //Set Crowdsale Address when it's deployed
248     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
249         require(presaleAddress != 0x0);
250         require(crowdsaleAddress == 0x0);
251         crowdsaleAddress = _crowdsaleAddress;
252         balances[_crowdsaleAddress] = balances[_crowdsaleAddress].add(crowdsaleSupply);
253     }
254 
255     // Finalize crowdsale. Leftover tokens will overflow to platform.
256     function finalizeCrowdsale() external onlyCrowdsale {
257         require(presaleFinalized == true && crowdsaleFinalized == false);
258         uint256 amount = balanceOf(crowdsaleAddress);
259         if (amount > 0) {
260             balances[crowdsaleAddress] = 0;
261             balances[platformAddress] = balances[platformAddress].add(amount);
262             emit Transfer(0x0, platformAddress, amount);
263         }
264         crowdsaleFinalized = true;
265         emit CrowdsaleFinalized(amount);
266     }
267 
268     //Public functions
269     //ERC20 functions
270     function totalSupply() public view returns (uint256) {
271         return _totalSupply;
272     }
273 
274     function transfer(address _to, uint256 _value) public
275     notBeforeCrowdsaleEnds
276     returns (bool) {
277         require(_to != address(0));
278         require(_value <= balances[msg.sender]);
279         balances[msg.sender] = balances[msg.sender].sub(_value);
280         balances[_to] = balances[_to].add(_value);
281         emit Transfer(msg.sender, _to, _value);
282         return true;
283     }
284 
285     function balanceOf(address _owner) public view returns (uint256) {
286         return balances[_owner];
287     }
288 
289     function transferFrom(address _from, address _to, uint256 _value) public
290     notBeforeCrowdsaleEnds
291     returns (bool) {
292         require(_to != address(0));
293         require(_value <= balances[_from]);
294         require(_value <= allowed[_from][msg.sender]);
295         balances[_from] = balances[_from].sub(_value);
296         balances[_to] = balances[_to].add(_value);
297         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
298         emit Transfer(_from, _to, _value);
299         return true;
300     }
301 
302     function approve(address _spender, uint256 _value) public returns (bool) {
303         allowed[msg.sender][_spender] = _value;
304         emit Approval(msg.sender, _spender, _value);
305         return true;
306     }
307 
308     function allowance(address _owner, address _spender) public view returns (uint256) {
309         return allowed[_owner][_spender];
310     }
311 
312     //Token functions
313     //Incentivising function to transfer tokens
314     function transferFromIncentivising(address _to, uint256 _value) public
315     onlyOwner
316     returns (bool) {
317     require(_value <= balances[incentivisingAddress]);
318         balances[incentivisingAddress] = balances[incentivisingAddress].sub(_value);
319         balances[_to] = balances[_to].add(_value);
320         emit Transfer(0x0, _to, _value);
321         return true;
322     }
323 
324     //Presalefunction to transfer tokens
325     function transferFromPresale(address _to, uint256 _value) public
326     onlyPresale
327     returns (bool) {
328     require(_value <= balances[presaleAddress]);
329         balances[presaleAddress] = balances[presaleAddress].sub(_value);
330         balances[_to] = balances[_to].add(_value);
331         emit Transfer(0x0, _to, _value);
332         return true;
333     }
334 
335     //Crowdsalefunction to transfer tokens
336     function transferFromCrowdsale(address _to, uint256 _value) public
337     onlyCrowdsale
338     returns (bool) {
339     require(_value <= balances[crowdsaleAddress]);
340         balances[crowdsaleAddress] = balances[crowdsaleAddress].sub(_value);
341         balances[_to] = balances[_to].add(_value);
342         emit Transfer(0x0, _to, _value);
343         return true;
344     }
345 
346     // Release team supply after vesting period is finished.
347     function releaseTeamTokens() public checkTeamVestingPeriod onlyOwner returns(bool) {
348         require(teamSupply > 0);
349         balances[teamAddress] = teamSupply;
350         emit Transfer(0x0, teamAddress, teamSupply);
351         teamSupply = 0;
352         return true;
353     }
354 
355     //Check remaining incentivising tokens
356     function checkIncentivisingBalance() public view returns (uint256) {
357         return balances[incentivisingAddress];
358     }
359 
360     //Check remaining presale tokens after presale contract is deployed
361     function checkPresaleBalance() public view returns (uint256) {
362         return balances[presaleAddress];
363     }
364 
365     //Check remaining crowdsale tokens after crowdsale contract is deployed
366     function checkCrowdsaleBalance() public view returns (uint256) {
367         return balances[crowdsaleAddress];
368     }
369 
370     //Recover ERC20 Tokens
371     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
372         return ERC20(tokenAddress).transfer(owner, tokens);
373     }
374 
375     //Don't accept ETH
376     function () public payable {
377 revert();
378     }
379 }
380 
381 
382 contract VANMPresale is Ownable {
383     using SafeMath for uint256;
384 
385     //Variables
386     uint256 public presaleStartsAt;
387     uint256 public presaleEndsAt;
388 
389     uint256 public presaleRate;
390     uint256 public weiRaised;
391     address public presaleWallet;
392 
393     address public tokenAddress;
394     VANMToken public token;
395 
396     //Load whitelist
397     mapping(address => bool) public whitelist;
398 
399     //Modifiers
400     //Only during presale
401     modifier whilePresale {
402         require(block.timestamp >= presaleStartsAt && block.timestamp <= presaleEndsAt);
403         _;
404     }
405 
406     //Presale has to be over
407     modifier notBeforePresaleEnds {
408         require(block.timestamp > presaleEndsAt);
409         _;
410     }
411 
412     //Recipient has to be whitelisted
413     modifier isWhitelisted(address _to) {
414         require(whitelist[_to]);
415         _;
416     }
417 
418     //Events
419     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
420 
421     event AmountRaised(address beneficiary, uint amountRaised);
422 
423     event WalletChanged(address _wallet);
424 
425     //Constructor
426     constructor() public {
427 
428         //17.11.2018 00:00 UTC
429         presaleStartsAt = 1542412800;
430 
431         //31.12.2018 00:00 UTC
432         presaleEndsAt = 1546214400;
433 
434         //Amount of token per wei
435         presaleRate = 2600;
436 
437         //Amount of raised Funds in wei
438         weiRaised = 0;
439 
440         //Wallet for raised presale funds
441         presaleWallet = 0xedaFdA45fedcCE4D2b81e173F1D2F21557E97aA5;
442 
443         //VANM token address
444         tokenAddress = 0x0d155aaa5C94086bCe0Ad0167EE4D55185F02943;
445         token = VANMToken(tokenAddress);
446     }
447 
448     //External functions
449     //Add one address to whitelist
450     function addToWhitelist(address _to) external onlyOwner {
451         whitelist[_to] = true;
452     }
453 
454     //Add multiple addresses to whitelist
455     function addManyToWhitelist(address[] _to) external onlyOwner {
456         for (uint256 i = 0; i < _to.length; i++) {
457             whitelist[_to[i]] = true;
458         }
459     }
460 
461     //Remove one address from whitelist
462     function removeFromWhitelist(address _to) external onlyOwner {
463         whitelist[_to] = false;
464     }
465 
466     //Remove multiple addresses from whitelist
467     function removeManyFromWhitelist(address[] _to) external onlyOwner {
468         for (uint256 i = 0; i < _to.length; i++) {
469             whitelist[_to[i]] = false;
470         }
471     }
472 
473     //Change presale wallet
474     function changeWallet(address _presaleWallet) external onlyOwner {
475         presaleWallet = _presaleWallet;
476         emit WalletChanged(_presaleWallet);
477     }
478 
479     //Close the presale
480     //Remaining tokens will be transferred to crowdsale
481     function closePresale() external notBeforePresaleEnds onlyOwner returns (bool) {
482         emit AmountRaised(presaleWallet, weiRaised);
483         token.finalizePresale();
484         return true;
485     }
486 
487     //Public functions
488     //Check if presale has closed
489     function presaleHasClosed() public view returns (bool) {
490         return block.timestamp > presaleEndsAt;
491     }
492 
493     //Buy tokens by sending ETH to the contract
494     function () public payable {
495         buyTokens(msg.sender);
496     }
497 
498     //Buy tokens and send it to an address
499     function buyTokens(address _to) public
500     whilePresale
501     isWhitelisted (_to)
502     payable {
503         uint256 weiAmount = msg.value;
504         uint256 tokens = weiAmount * presaleRate;
505         weiRaised = weiRaised.add(weiAmount);
506         presaleWallet.transfer(weiAmount);
507         if (!token.transferFromPresale(_to, tokens)) {
508             revert();
509         }
510         emit TokenPurchase(_to, weiAmount, tokens);
511     }
512 
513     //Recover ERC20 tokens
514     function transferAnyERC20Token(address ERC20Address, uint tokens) public onlyOwner returns (bool success) {
515         return ERC20(ERC20Address).transfer(owner, tokens);
516     }
517 }
1 /**
2   * Author 	: Christophe GAUTHIER
3   * Website : https://www.linkedin.com/in/chrgauthier/
4   * Version : COLLECTE NOTRE DAME DE PARIS
5   **/
6 
7 pragma solidity 0.5.7;
8 
9 
10 /**
11  * @title SafeMath
12  * @dev Unsigned math operations with safety checks that revert on error.
13  */
14 library SafeMath {
15     /**
16      * @dev Multiplies two unsigned integers, reverts on overflow.
17      */
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
20         // benefit is lost if 'b' is also tested.
21         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
22         if (a == 0) {
23             return 0;
24         }
25 
26         uint256 c = a * b;
27         require(c / a == b);
28 
29         return c;
30     }
31 
32     /**
33      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
34      */
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Solidity only automatically asserts when dividing by 0
37         require(b > 0);
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 
41         return c;
42     }
43 
44     /**
45      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         require(b <= a);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Adds two unsigned integers, reverts on overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a);
60 
61         return c;
62     }
63 
64     /**
65      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
66      * reverts when dividing by zero.
67      */
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b != 0);
70         return a % b;
71     }
72 }
73 
74 
75 /**
76  * @title ERC20 interface
77  * @dev see https://eips.ethereum.org/EIPS/eip-20
78  */
79 interface IERC20 {
80     function transfer(address to, uint256 value) external returns (bool);
81 
82     function approve(address spender, uint256 value) external returns (bool);
83 
84     function transferFrom(address from, address to, uint256 value) external returns (bool);
85 
86     function totalSupply() external view returns (uint256);
87 
88     function balanceOf(address who) external view returns (uint256);
89 
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     event Transfer(address indexed from, address indexed to, uint256 value);
93 
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * https://eips.ethereum.org/EIPS/eip-20
102  * Originally based on code by FirstBlood:
103  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
104  *
105  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
106  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
107  * compliant implementations may not do it.
108  */
109 contract ERC20 is IERC20 {
110     using SafeMath for uint256;
111 
112     mapping (address => uint256) private _balances;
113 
114     mapping (address => mapping (address => uint256)) private _allowed;
115 
116     uint256 private _totalSupply;
117 
118     /**
119      * @dev Total number of tokens in existence.
120      */
121     function totalSupply() public view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     /**
126      * @dev Gets the balance of the specified address.
127      * @param owner The address to query the balance of.
128      * @return A uint256 representing the amount owned by the passed address.
129      */
130     function balanceOf(address owner) public view returns (uint256) {
131         return _balances[owner];
132     }
133 
134     /**
135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
136      * @param owner address The address which owns the funds.
137      * @param spender address The address which will spend the funds.
138      * @return A uint256 specifying the amount of tokens still available for the spender.
139      */
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return _allowed[owner][spender];
142     }
143 
144     /**
145      * @dev Transfer token to a specified address.
146      * @param to The address to transfer to.
147      * @param value The amount to be transferred.
148      */
149     function transfer(address to, uint256 value) public returns (bool) {
150         _transfer(msg.sender, to, value);
151         return true;
152     }
153 
154     /**
155      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
156      * Beware that changing an allowance with this method brings the risk that someone may use both the old
157      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      * @param spender The address which will spend the funds.
161      * @param value The amount of tokens to be spent.
162      */
163     function approve(address spender, uint256 value) public returns (bool) {
164         _approve(msg.sender, spender, value);
165         return true;
166     }
167 
168     /**
169      * @dev Transfer tokens from one address to another.
170      * Note that while this function emits an Approval event, this is not required as per the specification,
171      * and other compliant implementations may not emit the event.
172      * @param from address The address which you want to send tokens from
173      * @param to address The address which you want to transfer to
174      * @param value uint256 the amount of tokens to be transferred
175      */
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177         _transfer(from, to, value);
178         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
179         return true;
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
209         return true;
210     }
211 
212     /**
213      * @dev Transfer token for a specified addresses.
214      * @param from The address to transfer from.
215      * @param to The address to transfer to.
216      * @param value The amount to be transferred.
217      */
218     function _transfer(address from, address to, uint256 value) internal {
219         require(to != address(0));
220 
221         _balances[from] = _balances[from].sub(value);
222         _balances[to] = _balances[to].add(value);
223         emit Transfer(from, to, value);
224     }
225 
226     /**
227      * @dev Internal function that mints an amount of the token and assigns it to
228      * an account. This encapsulates the modification of balances such that the
229      * proper events are emitted.
230      * @param account The account that will receive the created tokens.
231      * @param value The amount that will be created.
232      */
233     function _mint(address account, uint256 value) internal {
234         require(account != address(0));
235 
236         _totalSupply = _totalSupply.add(value);
237         _balances[account] = _balances[account].add(value);
238         emit Transfer(address(0), account, value);
239     }
240 
241     /**
242      * @dev Internal function that burns an amount of the token of a given
243      * account.
244      * @param account The account whose tokens will be burnt.
245      * @param value The amount that will be burnt.
246      */
247     function _burn(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.sub(value);
251         _balances[account] = _balances[account].sub(value);
252         emit Transfer(account, address(0), value);
253     }
254 
255     /**
256      * @dev Approve an address to spend another addresses' tokens.
257      * @param owner The address that owns the tokens.
258      * @param spender The address that will spend the tokens.
259      * @param value The number of tokens that can be spent.
260      */
261     function _approve(address owner, address spender, uint256 value) internal {
262         require(spender != address(0));
263         require(owner != address(0));
264 
265         _allowed[owner][spender] = value;
266         emit Approval(owner, spender, value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _burn(account, value);
279         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
280     }
281 }
282 
283 
284 /**
285  * @title Roles
286  * @dev Library for managing addresses assigned to a Role.
287  */
288 library Roles {
289     struct Role {
290         mapping (address => bool) bearer;
291     }
292 
293     /**
294      * @dev Give an account access to this role.
295      */
296     function add(Role storage role, address account) internal {
297         require(!has(role, account));
298 
299         role.bearer[account] = true;
300     }
301 
302     /**
303      * @dev Remove an account's access to this role.
304      */
305     function remove(Role storage role, address account) internal {
306         require(has(role, account));
307 
308         role.bearer[account] = false;
309     }
310 
311     /**
312      * @dev Check if an account has this role.
313      * @return bool
314      */
315     function has(Role storage role, address account) internal view returns (bool) {
316         require(account != address(0));
317         return role.bearer[account];
318     }
319 }
320 
321 contract MinterRole {
322     using Roles for Roles.Role;
323 
324     event MinterAdded(address indexed account);
325     event MinterRemoved(address indexed account);
326 
327     Roles.Role private _minters;
328 
329     constructor () internal {
330         _addMinter(msg.sender);
331     }
332 
333     modifier onlyMinter() {
334         require(isMinter(msg.sender));
335         _;
336     }
337 
338     function isMinter(address account) public view returns (bool) {
339         return _minters.has(account);
340     }
341 
342     function addMinter(address account) public onlyMinter {
343         _addMinter(account);
344     }
345 
346     function renounceMinter() public {
347         _removeMinter(msg.sender);
348     }
349 
350     function _addMinter(address account) internal {
351         _minters.add(account);
352         emit MinterAdded(account);
353     }
354 
355     function _removeMinter(address account) internal {
356         _minters.remove(account);
357         emit MinterRemoved(account);
358     }
359 }
360 
361 
362 /**
363  * @title ERC20Mintable
364  * @dev ERC20 minting logic.
365  */
366 contract ERC20Mintable is ERC20, MinterRole {
367     /**
368      * @dev Function to mint tokens
369      * @param to The address that will receive the minted tokens.
370      * @param value The amount of tokens to mint.
371      * @return A boolean that indicates if the operation was successful.
372      */
373     function mint(address to, uint256 value) public onlyMinter returns (bool) {
374         _mint(to, value);
375         return true;
376     }
377 }
378 
379 
380 contract OwnablePayable {
381     address payable public _owner;
382 
383     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385     /**
386      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
387      * account.
388      */
389     constructor () internal {
390         _owner = msg.sender;
391         emit OwnershipTransferred(address(0), _owner);
392     }
393 
394 
395     /**
396      * @dev Throws if called by any account other than the owner.
397      */
398     modifier onlyOwner() {
399         require(msg.sender == _owner);
400         _;
401     }
402 
403     /**
404      * @dev Allows the current owner to transfer control of the contract to a newOwner.
405      * @param newOwner The address to transfer ownership to.
406      */
407     function transferOwnership(address payable newOwner) public onlyOwner {
408         _transferOwnership(newOwner);
409     }
410 
411     /**
412      * @dev Transfers control of the contract to a newOwner.
413      * @param newOwner The address to transfer ownership to.
414      */
415     function _transferOwnership(address payable newOwner) internal {
416         require(newOwner != address(0));
417         emit OwnershipTransferred(_owner, newOwner);
418         _owner = newOwner;
419     }
420 }
421 
422 /*@title FRENCHICO TOKEN - FRENCHICO*/
423 
424 contract FrenchIco_Token is ERC20Mintable {
425 
426     using SafeMath for uint256;
427     event newTokenFico(address owner, string copyright, string name, string symbol);
428 
429     uint8 public constant decimals = 18;
430 	string public name;
431 	string public symbol;
432 
433     constructor(string memory _symbol, string memory _name) public {
434 	    symbol = _symbol;
435 	    name = _name;
436 	    emit newTokenFico(msg.sender, "Copyright FRENCHICO", name, symbol);
437 	}
438 
439    function sendToGateway(address gatewayAddr, uint amount, uint orderId, uint[] calldata instruction, string calldata message, address addr) external {
440     approve(address(gatewayAddr) ,amount);
441     FrenchIco_Gateway gateway = FrenchIco_Gateway(address(gatewayAddr));
442     gateway.orderFromToken(msg.sender, amount, address(this), orderId, instruction, message, addr);
443     }
444 
445 
446 
447 }
448 
449 interface FrenchIco_Gateway {
450 function orderFromToken(address , uint , address, uint, uint[] calldata, string calldata, address) external returns (bool);
451 }
452 
453 interface FrenchIco_Corporate {
454 
455     function isGeneralPaused() external view returns (bool);
456     function GetRole(address addr) external view returns (uint _role);
457     function GetWallet_FRENCHICO() external view returns (address payable);
458     function GetMaxAmount() external view returns (uint);
459 }
460 
461 contract FrenchIco {
462 
463     FrenchIco_Corporate Fico = FrenchIco_Corporate(address(0x8024A6e9f0842E86079e707bF874AFC061c38D60));
464 
465 	modifier isNotStoppedByFrenchIco() {
466 	    require(!Fico.isGeneralPaused());
467 	    _;
468 	}
469 }
470 
471 contract FrenchIco_Crowdsale is OwnablePayable, FrenchIco {
472 
473  using SafeMath for uint256;
474  FrenchIco_Token public token;
475 
476   /**
477    * @dev Events
478    * TokensBooked is the event published each time tokens are booked by investor
479    * TokensReleased is the event published each time tokens are released
480    * DepositRefund is the event published each time deposit are refud to a investor
481    * MarketplaceDeployed is the event published when the Marketplace is deployed
482    */
483 
484     event TokensBuy(address beneficary, uint amount);
485     event Copyright(string copyright);
486 
487    /**
488    * 
489    * @param Investor is the ETH address of the Investor
490    * @param tokensBought the quantity of tokens bought by the contributor
491    
492    */
493 
494     struct Investor {
495 	uint tokensBought;
496     }
497     mapping(address => Investor) public Investors;
498 
499    /**
500    *
501    * @param endTime end Time
502    * @param fundsCollected total of founds collected
503    */
504 
505     uint public endTime;
506     uint public fundsCollected;
507 
508   /**
509    * the function is launched the contract on the blockchain
510    *
511    * @param _name Token's name
512    * @param _symbol Token's symbol
513    * @param _endTime starting time of the collect
514    */
515     constructor(string memory _name, string memory _symbol, uint _endTime) public {
516         token = new FrenchIco_Token(_symbol, _name);
517         endTime = _endTime;
518         emit Copyright("Copyright FRENCHICO");
519 
520     }
521 
522   /**
523    * @dev fallback function wich is executed if eth are send directly from a wallet to this contract
524    */
525 
526     function() external payable {
527         buyTokens();
528     }
529 
530 
531   /**
532    * this function allow contributors to buy tokens NOTRE DAME DE PARIS
533    * only during collect Times
534    */
535     function buyTokens() public payable isNotStoppedByFrenchIco  {
536          require (msg.value>0,"empty");
537          require (validAccess(msg.value), "Control Access Denied");
538          require (now <= endTime,"ICO not running");
539          token.mint(msg.sender,msg.value);
540          Investors[msg.sender].tokensBought = Investors[msg.sender].tokensBought.add(msg.value);
541          fundsCollected = fundsCollected.add(msg.value);
542          _owner.transfer(address(this).balance);
543 
544          emit TokensBuy(msg.sender, msg.value);
545     }
546 
547 
548   /**
549    * check if the ETH address used is recorded in the whitelist or not
550    * KYC are not necessary if total of deposit is less than the maw amount allowed by the same address
551    *
552    */
553     function validAccess(uint value) public view returns(bool) {
554         bool access;
555         if (Fico.GetRole(msg.sender) <= 1 && Investors[msg.sender].tokensBought.add(value) <= Fico.GetMaxAmount()){access = true;}
556         else if (Fico.GetRole(msg.sender) > 1){access = true;}
557         else {access = false;}
558         return access;
559     }
560 
561 
562 }
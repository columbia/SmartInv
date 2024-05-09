1 // File: contracts-separate/Ownable.sol
2 
3 pragma solidity >=0.4.25 <0.6.0;
4 
5 contract Ownable {
6     //이 contract가 owner로 갖고있는 address는 단 하나
7     address public owner;
8     address public newOwner;
9 
10     event OwnershipTransferred(address indexed _from, address indexed _to);
11 
12     //현재 call을 보낸(contract를 작성한) 주소가 owner이다.
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner, "Only owner can execute this function");
19         _;
20     }
21 
22     function transferOwnership(address _newOwner) public onlyOwner {
23         newOwner = _newOwner;
24     }
25 
26     function acceptOwnership() public {
27         require(msg.sender == newOwner);
28         emit OwnershipTransferred(owner, newOwner);
29         owner = newOwner; //owner transferred
30         newOwner = address(0); // newOwner address to 0x0
31     }
32 }
33 
34 // File: contracts-separate/Freezable.sol
35 
36 pragma solidity >=0.4.25 <0.6.0;
37 
38 
39 contract Freezable is Ownable { 
40     mapping (address => bool) internal isFrozen;
41         
42     uint256 public _unfreezeDateTime = 1559390400; // 06/01/2019 @ 12:00pm (UTC) || https://www.unixtimestamp.com
43 
44     event globalUnfreezeDatetimeModified(uint256);
45     event FreezeFunds(address target, bool frozen);
46 
47     /**
48      * Modifier for checking if the account is not frozen
49      */
50     modifier onlyNotFrozen(address a) {
51         require(!isFrozen[a], "Any account in this function must not be frozen");
52         _;
53     }
54 
55     /**
56      * Modifier for checking if the ICO freezing period has ended so that transactions can be accepted.
57      */
58     modifier onlyAfterUnfreeze() {
59         require(block.timestamp >= _unfreezeDateTime, "You cannot tranfer tokens before unfreeze date" );
60         _;
61     }
62     /**
63     * @dev Total number of tokens in existence
64     */
65     function getUnfreezeDateTime() public view returns (uint256) {
66         return _unfreezeDateTime;
67     }
68 
69     /**
70      * @dev set Unfreeze date for every users.
71      * @param unfreezeDateTime The given date and time for unfreezing all the existing accounts.
72      */
73     function setUnfreezeDateTime(uint256 unfreezeDateTime) onlyOwner public {
74         _unfreezeDateTime = unfreezeDateTime;
75         emit globalUnfreezeDatetimeModified(unfreezeDateTime); 
76     }
77 
78     /**
79      * @dev Gets the freezing status of the account, not relevant with the _unfreezeDateTime
80      */
81     function isAccountFrozen( address target ) public view returns (bool) {
82         return isFrozen[target];
83     }
84 
85     /**
86      * @dev Internal function that freezes the given address
87      * @param target The account that will be frozen/unfrozen.
88      * @param doFreeze to freeze or unfreeze.
89      */
90     function freeze(address target, bool doFreeze) onlyOwner public {
91         if( msg.sender == target ) {
92             revert();
93         }
94 
95         isFrozen[target] = doFreeze;
96         emit FreezeFunds(target, doFreeze);
97     }
98 }
99 
100 // File: contracts-separate/SafeMath.sol
101 
102 pragma solidity >=0.4.25 <0.6.0;
103 /**
104  * @title SafeMath
105  * @dev Unsigned math operations with safety checks that revert on error
106  */
107 library SafeMath {
108     /**
109     * @dev Multiplies two unsigned integers, reverts on overflow.
110     */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
113         // benefit is lost if 'b' is also tested.
114         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
115         if (a == 0) {
116             return 0;
117         }
118 
119         uint256 c = a * b;
120         require(c / a == b);
121 
122         return c;
123     }
124 
125     /**
126     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
127     */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Solidity only automatically asserts when dividing by 0
130         require(b > 0);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
139     */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         require(b <= a);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148     * @dev Adds two unsigned integers, reverts on overflow.
149     */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a);
153 
154         return c;
155     }
156 
157     /**
158     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
159     * reverts when dividing by zero.
160     */
161     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162         require(b != 0);
163         return a % b;
164     }
165 }
166 
167 // File: contracts-separate/IERC20.sol
168 
169 pragma solidity >=0.4.25 <0.6.0;
170 
171 /**
172  * @title ERC20 interface
173  * @dev see https://github.com/ethereum/EIPs/issues/20
174  */
175 interface IERC20 {
176     function transfer(address to, uint256 value) external returns (bool);
177 
178     function approve(address spender, uint256 value) external returns (bool);
179 
180     function transferFrom(address from, address to, uint256 value) external returns (bool);
181 
182     function totalSupply() external view returns (uint256);
183 
184     function balanceOf(address who) external view returns (uint256);
185 
186     function allowance(address owner, address spender) external view returns (uint256);
187 
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: contracts-separate/TokenStorage.sol
194 
195 pragma solidity >=0.4.25 <0.6.0;
196  
197 
198 contract TokenStorage  {
199     uint256 internal _totalSupply;
200     mapping (address => uint256) internal _balances;
201     mapping (address => mapping(address => uint256)) internal _allowed;
202 }
203 
204 // File: contracts-separate/AddressGuard.sol
205 
206 pragma solidity >=0.4.25 <0.6.0;
207 
208 contract AddressGuard {
209     modifier onlyAddressNotZero(address addr) {
210         require(addr != address(0), "The address must not be 0x0");
211         _;   
212     }
213 }
214 
215 // File: contracts-separate/TokenRescue.sol
216 
217 pragma solidity >=0.4.25 <0.6.0;
218 
219 
220 
221 
222 /**
223  * @title TokenRescue
224  * @dev Rescue the lost ERC20 token
225  * inspred by DreamTeamToken
226  */
227 contract TokenRescue is Ownable, AddressGuard {
228     address internal rescueAddr;
229 
230     modifier onlyRescueAddr {
231         require(msg.sender == rescueAddr);
232         _;
233     }
234 
235     function setRescueAddr(address addr) onlyAddressNotZero(addr) onlyOwner public{
236         rescueAddr = addr;
237     }
238 
239     function getRescueAddr() public view returns(address) {
240         return rescueAddr;
241     }
242 
243     function rescueLostTokensByOwn(IERC20 lostTokenContract, uint256 value) external onlyRescueAddr {
244         lostTokenContract.transfer(rescueAddr, value);
245     }
246 
247     function rescueLostTokenByThisTokenOwner (IERC20 lostTokenContract, uint256 value) external onlyOwner {
248         lostTokenContract.transfer(rescueAddr, value);
249     } 
250     
251 }
252 
253 // File: contracts-separate/FinentToken.sol
254 
255 pragma solidity >=0.4.25 <0.6.0;
256 
257 
258 
259 
260 
261 
262 
263 
264 
265 /**
266  * @title FinentToken
267  *
268  * @dev Implementation of the basic standard token.
269  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
270  * 
271  This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
272  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
273  * compliant implementations may not do it.
274  */
275 contract FinentToken is IERC20, Ownable, Freezable, TokenStorage, AddressGuard, TokenRescue {
276     using SafeMath for uint256;
277     string private _name;
278 
279     string private _symbol;
280     uint8 private _decimals;
281     uint256 private _totalSupply;
282 
283     /**
284      * @dev Constructor of FinentToken
285      */
286     constructor() public {
287         _name = "Finent Token";
288         _symbol = "FNT";
289         _decimals = 18; //normal...
290         _mint(msg.sender, 1000000000 * 10 ** uint256(_decimals));
291     }
292 
293     /**
294     * @dev Gets the name of the token
295     */
296     function name() public view returns (string memory) {
297         return _name;
298     }
299     
300     /**
301     * @dev Gets the symbol of the token
302     */
303     function symbol() public view returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308     * @dev Gets the decimals of the token
309     */
310     function decimals() public view returns (uint256) {
311         return _decimals;
312     }
313 
314     /**
315      * @dev Gets the balance of address zero
316      */
317     function balanceOfZero() public view returns (uint256) {
318         return _balances[address(0)];
319     }
320 
321     /**
322     * @dev Total number of tokens in existence
323     */
324     function totalSupply() public view returns (uint256) {
325         return _totalSupply - _balances[address(0)];
326     }
327 
328     
329     /**
330     * @dev Gets the balance of the specified address.
331     * @param owner The address to query the balance of.
332     * @return An uint256 representing the amount owned by the passed address.
333     */
334     function balanceOf(address owner) onlyAddressNotZero(owner) public view returns (uint256) {
335         return _balances[owner];
336     }
337 
338     /**
339      * @dev Function to check the amount of tokens that an owner allowed to a spender.
340      * @param owner address The address which owns the funds.
341      * @param spender address The address which will spend the funds.
342      * @return A uint256 specifying the amount of tokens still available for the spender.
343      */
344     function allowance(address owner, address spender) onlyAddressNotZero(owner) onlyAddressNotZero(spender) public view returns (uint256) {
345         return _allowed[owner][spender];
346     }
347 
348     /**
349     * @dev Transfer token for a specified address
350     * @param _to The address to transfer to.
351     * @param _value The amount to be transferred.
352     */
353     function transfer(address _to, uint256 _value) onlyNotFrozen(msg.sender) onlyNotFrozen(_to) onlyAfterUnfreeze onlyAddressNotZero(_to) public returns (bool) {
354         _transfer(msg.sender, _to, _value);
355         return true;
356     }
357 
358     /**
359      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
360      * Beware that changing an allowance with this method brings the risk that someone may use both the old
361      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
362      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
363      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
364      * @param spender The address which will spend the funds.
365      * @param value The amount of tokens to be spent.
366      */
367     function approve(address spender, uint256 value) public onlyAddressNotZero(spender) returns (bool) {
368         _allowed[msg.sender][spender] = value;
369         emit Approval(msg.sender, spender, value);
370         return true;
371     }
372 
373     /**
374      * @dev Transfer tokens from one address to another.
375      * Note that while this function emits an Approval event, this is not required as per the specification,
376      * and other compliant implementations may not emit the event.
377      * @param _from address The address which you want to send tokens from
378      * @param _to address The address which you want to transfer to
379      * @param _value uint256 the amount of tokens to be transferred
380      */
381     function transferFrom(address _from, address _to, uint256 _value) onlyNotFrozen(msg.sender) onlyNotFrozen(_from) onlyNotFrozen(_to) onlyAfterUnfreeze public returns (bool) {
382         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
383         _transfer(_from, _to, _value);
384         emit Approval(_from, msg.sender, _allowed[_from][msg.sender]);
385         return true;
386     }
387 
388     /**
389      * @dev Increase the amount of tokens that an owner allowed to a spender.
390      * approve should be called when allowed_[_spender] == 0. To increment
391      * allowed value is better to use this function to avoid 2 calls (and wait until
392      * the first transaction is mined)
393      * From MonolithDAO Token.sol
394      * Emits an Approval event.
395      * @param spender The address which will spend the funds.
396      * @param addedValue The amount of tokens to increase the allowance by.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) onlyAddressNotZero(spender) public returns (bool) {
399         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
400         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
401         return true;
402     }
403 
404     /**
405      * @dev Decrease the amount of tokens that an owner allowed to a spender.
406      * approve should be called when allowed_[_spender] == 0. To decrement
407      * allowed value is better to use this function to avoid 2 calls (and wait until
408      * the first transaction is mined)
409      * From MonolithDAO Token.sol
410      * Emits an Approval event.
411      * @param spender The address which will spend the funds.
412      * @param subtractedValue The amount of tokens to decrease the allowance by.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) onlyAddressNotZero(spender) public returns (bool) {
415         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
416         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
417         return true;
418     }
419 
420     /**
421      * @dev burn token from specific addr
422      * @param addr The given addr to burn the token from.
423      * @param value The amount to be burnt.
424      */
425     function burn(address addr, uint256 value) onlyOwner onlyAddressNotZero(addr) public {
426         _burn(addr, value);
427     }
428 
429     /**
430      * @dev burn token from owner
431      * @param value The amount to be burnt.
432      */
433     function burnFromOwner(uint256 value) onlyOwner public {
434         _burn(msg.sender, value);
435     }
436 
437     /**
438      * @dev mint token from owner
439      * @param value The amount to be minted.
440      */
441     function mint(uint256 value) onlyOwner public {
442         _mint(msg.sender, value);
443     }
444 
445     /**
446      * @dev distribute token to addr and determine to freeze or not
447      * @param addr The given addr to distribute the token.
448      * @param value The amount to be distributed
449      * @param doFreeze to freeze or unfreeze
450      */
451     function distribute(address addr, uint256 value, bool doFreeze) onlyOwner public {
452         _distribute(addr, value, doFreeze);
453     }
454 
455     /**
456     * @dev Transfer token for a specified addresses
457     * @param _from The address to transfer from.
458     * @param _to The address to transfer to.
459     * @param _value The amount to be transferred.
460     */
461     function _transfer(address _from, address _to, uint256 _value) internal {
462         _balances[_from] = _balances[_from].sub(_value);
463         _balances[_to] = _balances[_to].add(_value);
464         emit Transfer(_from, _to, _value);
465     }
466 
467     /**
468     * @dev Distribute token for a specified addresses
469     * @param to The address to transfer to.
470     * @param value The amount to be transferred.
471     * @param doFreeze to freeze or unfreeze.
472     */
473     function _distribute(address to, uint256 value, bool doFreeze) onlyOwner internal {
474         _balances[msg.sender] = _balances[msg.sender].sub(value);
475         _balances[to] = _balances[to].add(value);
476 
477         if( doFreeze && msg.sender != to ) {
478             freeze( to, true );
479         }
480 
481         emit Transfer(msg.sender, to, value);
482     }
483 
484     /**
485      * @dev Internal function that mints an amount of the token and assigns it to
486      * an account. This encapsulates the modification of balances such that the
487      * proper events are emitted.
488      * @param account The account that will receive the created tokens.
489      * @param value The amount that will be created.
490      */
491     function _mint(address account, uint256 value) internal {
492         _totalSupply = _totalSupply.add(value);
493         _balances[account] = _balances[account].add(value);
494         emit Transfer(address(0), account, value);
495     }
496 
497     /**
498      * @dev Internal function that burns an amount of the token of a given
499      * account.
500      * @param account The account whose tokens will be burnt.
501      * @param value The amount that will be burnt.
502      */
503     function _burn(address account, uint256 value) internal {
504         _totalSupply = _totalSupply.sub(value);
505         _balances[account] = _balances[account].sub(value);
506         emit Transfer(account, address(0), value);
507     }
508 
509     /**
510      * @dev Internal function that burns an amount of the token of a given
511      * account, deducting from the sender's allowance for said account. Uses the
512      * internal burn function.
513      * Emits an Approval event (reflecting the reduced allowance).
514      * @param account The account whose tokens will be burnt.
515      * @param value The amount that will be burnt.
516      */
517     function _burnFrom(address account, uint256 value) internal {
518         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
519         _burn(account, value);
520         emit Approval(account, msg.sender, _allowed[account][msg.sender]);    
521     }
522 
523     
524     // ------------------------------------------------------------------------
525     // Don't accept ETH
526     // ------------------------------------------------------------------------
527     function () external payable {
528         revert();
529     }
530 
531 }
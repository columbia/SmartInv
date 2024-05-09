1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**------------------------------------------------------------------------------------------**/
26 
27 pragma solidity ^0.5.2;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 /**------------------------------------------------------------------------------------------**/
94 
95 pragma solidity ^0.5.2;
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
119      * @dev Total number of tokens in existence
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
145      * @dev Transfer token to a specified address
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
213      * @dev Transfer token for a specified addresses
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
283 /**------------------------------------------------------------------------------------------**/
284 
285 pragma solidity ^0.5.2;
286 
287 /**
288  * @title Roles
289  * @dev Library for managing addresses assigned to a Role.
290  */
291 library Roles {
292     struct Role {
293         mapping (address => bool) bearer;
294     }
295 
296     /**
297      * @dev give an account access to this role
298      */
299     function add(Role storage role, address account) internal {
300         require(account != address(0));
301         require(!has(role, account));
302 
303         role.bearer[account] = true;
304     }
305 
306     /**
307      * @dev remove an account's access to this role
308      */
309     function remove(Role storage role, address account) internal {
310         require(account != address(0));
311         require(has(role, account));
312 
313         role.bearer[account] = false;
314     }
315 
316     /**
317      * @dev check if an account has this role
318      * @return bool
319      */
320     function has(Role storage role, address account) internal view returns (bool) {
321         require(account != address(0));
322         return role.bearer[account];
323     }
324 }
325 
326 /**------------------------------------------------------------------------------------------**/
327 
328 pragma solidity ^0.5.2;
329 
330 contract MinterRole {
331     using Roles for Roles.Role;
332 
333     event MinterAdded(address indexed account);
334     event MinterRemoved(address indexed account);
335 
336     Roles.Role private _minters;
337 
338     constructor () internal {
339         _addMinter(msg.sender);
340     }
341 
342     modifier onlyMinter() {
343         require(isMinter(msg.sender));
344         _;
345     }
346 
347     function isMinter(address account) public view returns (bool) {
348         return _minters.has(account);
349     }
350 
351     function addMinter(address account) public onlyMinter {
352         _addMinter(account);
353     }
354 
355     function renounceMinter() public {
356         _removeMinter(msg.sender);
357     }
358 
359     function _addMinter(address account) internal {
360         _minters.add(account);
361         emit MinterAdded(account);
362     }
363 
364     function _removeMinter(address account) internal {
365         _minters.remove(account);
366         emit MinterRemoved(account);
367     }
368 }
369 
370 /**------------------------------------------------------------------------------------------**/
371 
372 pragma solidity ^0.5.2;
373 
374 /**
375  * @title ERC20Mintable
376  * @dev ERC20 minting logic
377  */
378 contract ERC20Mintable is ERC20, MinterRole {
379     /**
380      * @dev Function to mint tokens
381      * @param to The address that will receive the minted tokens.
382      * @param value The amount of tokens to mint.
383      * @return A boolean that indicates if the operation was successful.
384      */
385     function mint(address to, uint256 value) public onlyMinter returns (bool) {
386         _mint(to, value);
387         return true;
388     }
389 }
390 
391 /**------------------------------------------------------------------------------------------**/
392 
393 pragma solidity ^0.5.2;
394 
395 /**
396  * @title Burnable Token
397  * @dev Token that can be irreversibly burned (destroyed).
398  */
399 contract ERC20Burnable is ERC20 {
400     /**
401      * @dev Burns a specific amount of tokens.
402      * @param value The amount of token to be burned.
403      */
404     function burn(uint256 value) public {
405         _burn(msg.sender, value);
406     }
407 
408     /**
409      * @dev Burns a specific amount of tokens from the target address and decrements allowance
410      * @param from address The account whose tokens will be burned.
411      * @param value uint256 The amount of token to be burned.
412      */
413     function burnFrom(address from, uint256 value) public {
414         _burnFrom(from, value);
415     }
416 }
417 
418 /**------------------------------------------------------------------------------------------**/
419 
420 pragma solidity ^0.5.2;
421 
422 /**
423  * @title Ownable
424  * @dev The Ownable contract has an owner address, and provides basic authorization control
425  * functions, this simplifies the implementation of "user permissions".
426  */
427 contract Ownable {
428     address private _owner;
429 
430     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
431 
432     /**
433      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
434      * account.
435      */
436     constructor () internal {
437         _owner = msg.sender;
438         emit OwnershipTransferred(address(0), _owner);
439     }
440 
441     /**
442      * @return the address of the owner.
443      */
444     function owner() public view returns (address) {
445         return _owner;
446     }
447 
448     /**
449      * @dev Throws if called by any account other than the owner.
450      */
451     modifier onlyOwner() {
452         require(isOwner());
453         _;
454     }
455 
456     /**
457      * @return true if `msg.sender` is the owner of the contract.
458      */
459     function isOwner() public view returns (bool) {
460         return msg.sender == _owner;
461     }
462 
463     /**
464      * @dev Allows the current owner to relinquish control of the contract.
465      * It will not be possible to call the functions with the `onlyOwner`
466      * modifier anymore.
467      * @notice Renouncing ownership will leave the contract without an owner,
468      * thereby removing any functionality that is only available to the owner.
469      */
470     function renounceOwnership() public onlyOwner {
471         emit OwnershipTransferred(_owner, address(0));
472         _owner = address(0);
473     }
474 
475     /**
476      * @dev Allows the current owner to transfer control of the contract to a newOwner.
477      * @param newOwner The address to transfer ownership to.
478      */
479     function transferOwnership(address newOwner) public onlyOwner {
480         _transferOwnership(newOwner);
481     }
482 
483     /**
484      * @dev Transfers control of the contract to a newOwner.
485      * @param newOwner The address to transfer ownership to.
486      */
487     function _transferOwnership(address newOwner) internal {
488         require(newOwner != address(0));
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 /**------------------------------------------------------------------------------------------**/
495 
496 pragma solidity 0.5.2;
497 
498 contract NonWhitelistContract is ERC20, ERC20Mintable, ERC20Burnable, Ownable {
499   string public symbol;
500   string public name;
501   uint8 public decimals;
502 
503   constructor (
504     string memory symbol_,
505     string memory name_,
506     uint8 decimals_,
507     uint256 totalSupply,
508     address owner,
509     address supplyOwnerAddress
510   ) public {
511     symbol = symbol_;
512     name = name_;
513     decimals = decimals_;
514 
515     if(!isMinter(owner)){
516       addMinter(owner);
517     }
518 
519     mint(supplyOwnerAddress, totalSupply);
520     renounceMinter();
521     Ownable.transferOwnership(owner);
522   }
523 
524 }
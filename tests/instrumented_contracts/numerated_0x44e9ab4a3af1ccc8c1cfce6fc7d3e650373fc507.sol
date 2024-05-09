1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
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
25 
26 /**
27  * @title SafeMath
28  * @dev Unsigned math operations with safety checks that revert on error
29  */
30 library SafeMath {
31     /**
32     * @dev Multiplies two unsigned integers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two unsigned integers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 
91 
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
98  * Originally based on code by FirstBlood:
99  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
100  *
101  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
102  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
103  * compliant implementations may not do it.
104  */
105 contract ERC20 is IERC20 {
106     using SafeMath for uint256;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     uint256 private _totalSupply;
113 
114     /**
115     * @dev Total number of tokens in existence
116     */
117     function totalSupply() public view returns (uint256) {
118         return _totalSupply;
119     }
120 
121     /**
122     * @dev Gets the balance of the specified address.
123     * @param owner The address to query the balance of.
124     * @return An uint256 representing the amount owned by the passed address.
125     */
126     function balanceOf(address owner) public view returns (uint256) {
127         return _balances[owner];
128     }
129 
130     /**
131      * @dev Function to check the amount of tokens that an owner allowed to a spender.
132      * @param owner address The address which owns the funds.
133      * @param spender address The address which will spend the funds.
134      * @return A uint256 specifying the amount of tokens still available for the spender.
135      */
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowed[owner][spender];
138     }
139 
140     /**
141     * @dev Transfer token for a specified address
142     * @param to The address to transfer to.
143     * @param value The amount to be transferred.
144     */
145     function transfer(address to, uint256 value) public returns (bool) {
146         _transfer(msg.sender, to, value);
147         return true;
148     }
149 
150     /**
151      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152      * Beware that changing an allowance with this method brings the risk that someone may use both the old
153      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      * @param spender The address which will spend the funds.
157      * @param value The amount of tokens to be spent.
158      */
159     function approve(address spender, uint256 value) public returns (bool) {
160         require(spender != address(0));
161 
162         _allowed[msg.sender][spender] = value;
163         emit Approval(msg.sender, spender, value);
164         return true;
165     }
166 
167     /**
168      * @dev Transfer tokens from one address to another.
169      * Note that while this function emits an Approval event, this is not required as per the specification,
170      * and other compliant implementations may not emit the event.
171      * @param from address The address which you want to send tokens from
172      * @param to address The address which you want to transfer to
173      * @param value uint256 the amount of tokens to be transferred
174      */
175     function transferFrom(address from, address to, uint256 value) public returns (bool) {
176         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
177         _transfer(from, to, value);
178         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
179         return true;
180     }
181 
182     /**
183      * @dev Increase the amount of tokens that an owner allowed to a spender.
184      * approve should be called when allowed_[_spender] == 0. To increment
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param addedValue The amount of tokens to increase the allowance by.
191      */
192     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
193         require(spender != address(0));
194 
195         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
196         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
197         return true;
198     }
199 
200     /**
201      * @dev Decrease the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed_[_spender] == 0. To decrement
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param subtractedValue The amount of tokens to decrease the allowance by.
209      */
210     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
211         require(spender != address(0));
212 
213         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
214         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
215         return true;
216     }
217 
218     /**
219     * @dev Transfer token for a specified addresses
220     * @param from The address to transfer from.
221     * @param to The address to transfer to.
222     * @param value The amount to be transferred.
223     */
224     function _transfer(address from, address to, uint256 value) internal {
225         require(to != address(0));
226 
227         _balances[from] = _balances[from].sub(value);
228         _balances[to] = _balances[to].add(value);
229         emit Transfer(from, to, value);
230     }
231 
232     /**
233      * @dev Internal function that mints an amount of the token and assigns it to
234      * an account. This encapsulates the modification of balances such that the
235      * proper events are emitted.
236      * @param account The account that will receive the created tokens.
237      * @param value The amount that will be created.
238      */
239     function _mint(address account, uint256 value) internal {
240         require(account != address(0));
241 
242         _totalSupply = _totalSupply.add(value);
243         _balances[account] = _balances[account].add(value);
244         emit Transfer(address(0), account, value);
245     }
246 
247     /**
248      * @dev Internal function that burns an amount of the token of a given
249      * account.
250      * @param account The account whose tokens will be burnt.
251      * @param value The amount that will be burnt.
252      */
253     function _burn(address account, uint256 value) internal {
254         require(account != address(0));
255 
256         _totalSupply = _totalSupply.sub(value);
257         _balances[account] = _balances[account].sub(value);
258         emit Transfer(account, address(0), value);
259     }
260 
261     /**
262      * @dev Internal function that burns an amount of the token of a given
263      * account, deducting from the sender's allowance for said account. Uses the
264      * internal burn function.
265      * Emits an Approval event (reflecting the reduced allowance).
266      * @param account The account whose tokens will be burnt.
267      * @param value The amount that will be burnt.
268      */
269     function _burnFrom(address account, uint256 value) internal {
270         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
271         _burn(account, value);
272         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
273     }
274 }
275 
276 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
277 
278 pragma solidity ^0.5.0;
279 
280 
281 /**
282  * @title ERC20Detailed token
283  * @dev The decimals are only for visualization purposes.
284  * All the operations are done using the smallest and indivisible token unit,
285  * just as on Ethereum all the operations are done in wei.
286  */
287 contract ERC20Detailed is IERC20 {
288     string private _name;
289     string private _symbol;
290     uint8 private _decimals;
291 
292     constructor (string memory name, string memory symbol, uint8 decimals) public {
293         _name = name;
294         _symbol = symbol;
295         _decimals = decimals;
296     }
297 
298     /**
299      * @return the name of the token.
300      */
301     function name() public view returns (string memory) {
302         return _name;
303     }
304 
305     /**
306      * @return the symbol of the token.
307      */
308     function symbol() public view returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @return the number of decimals of the token.
314      */
315     function decimals() public view returns (uint8) {
316         return _decimals;
317     }
318 }
319 
320 // File: openzeppelin-solidity/contracts/access/Roles.sol
321 
322 pragma solidity ^0.5.0;
323 
324 /**
325  * @title Roles
326  * @dev Library for managing addresses assigned to a Role.
327  */
328 library Roles {
329     struct Role {
330         mapping (address => bool) bearer;
331     }
332 
333     /**
334      * @dev give an account access to this role
335      */
336     function add(Role storage role, address account) internal {
337         require(account != address(0));
338         require(!has(role, account));
339 
340         role.bearer[account] = true;
341     }
342 
343     /**
344      * @dev remove an account's access to this role
345      */
346     function remove(Role storage role, address account) internal {
347         require(account != address(0));
348         require(has(role, account));
349 
350         role.bearer[account] = false;
351     }
352 
353     /**
354      * @dev check if an account has this role
355      * @return bool
356      */
357     function has(Role storage role, address account) internal view returns (bool) {
358         require(account != address(0));
359         return role.bearer[account];
360     }
361 }
362 
363 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
364 
365 pragma solidity ^0.5.0;
366 
367 
368 contract MinterRole {
369     using Roles for Roles.Role;
370 
371     event MinterAdded(address indexed account);
372     event MinterRemoved(address indexed account);
373 
374     Roles.Role private _minters;
375 
376     constructor () internal {
377         _addMinter(msg.sender);
378     }
379 
380     modifier onlyMinter() {
381         require(isMinter(msg.sender));
382         _;
383     }
384 
385     function isMinter(address account) public view returns (bool) {
386         return _minters.has(account);
387     }
388 
389     function addMinter(address account) public onlyMinter {
390         _addMinter(account);
391     }
392 
393     function renounceMinter() public {
394         _removeMinter(msg.sender);
395     }
396 
397     function _addMinter(address account) internal {
398         _minters.add(account);
399         emit MinterAdded(account);
400     }
401 
402     function _removeMinter(address account) internal {
403         _minters.remove(account);
404         emit MinterRemoved(account);
405     }
406 }
407 
408 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
409 
410 pragma solidity ^0.5.0;
411 
412 
413 
414 /**
415  * @title ERC20Mintable
416  * @dev ERC20 minting logic
417  */
418 contract ERC20Mintable is ERC20, MinterRole {
419     /**
420      * @dev Function to mint tokens
421      * @param to The address that will receive the minted tokens.
422      * @param value The amount of tokens to mint.
423      * @return A boolean that indicates if the operation was successful.
424      */
425     function mint(address to, uint256 value) public onlyMinter returns (bool) {
426         _mint(to, value);
427         return true;
428     }
429 }
430 
431 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol
432 
433 pragma solidity ^0.5.0;
434 
435 
436 /**
437  * @title Burnable Token
438  * @dev Token that can be irreversibly burned (destroyed).
439  */
440 contract ERC20Burnable is ERC20 {
441     /**
442      * @dev Burns a specific amount of tokens.
443      * @param value The amount of token to be burned.
444      */
445     function burn(uint256 value) public {
446         _burn(msg.sender, value);
447     }
448 
449     /**
450      * @dev Burns a specific amount of tokens from the target address and decrements allowance
451      * @param from address The address which you want to send tokens from
452      * @param value uint256 The amount of token to be burned
453      */
454     function burnFrom(address from, uint256 value) public {
455         _burnFrom(from, value);
456     }
457 }
458 
459 // File: contracts/CnabToken.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 
465 
466 
467 contract CnabToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Burnable {
468 
469     constructor()
470         ERC20Burnable()
471         ERC20Mintable()
472         ERC20Detailed('Cannabium', 'CNAB', 18)
473         ERC20()
474         public
475     {
476 
477         // pre-mint token sale participants.
478 
479         mint(0x243A839E28d64C2f7BaaDC91FaC22B3E79A2f6e4, 8339235460000000000000000);
480 
481         _mint(0xb5e74585a14C44f3819420831e9532F916a4f389, 2756850000000000000000000);
482         _mint(0x071B03261b23b40753FAc37156d3Ff5d1ac74944, 1260800100000000000000000);
483         _mint(0x03FBe5234AD39F9778dbc0F5036cC7F2974aB89c, 1250000100000000000000000);
484         _mint(0x27EcF302F15d065Ff43Dcfc40Fe2c64C1e7Dd4C5, 1250000100000000000000000);
485         _mint(0xeB40cA0524710301c1E32a56229044E9675847cC, 1250000000000000000000000);
486         _mint(0x2E6F4E999cda38C1B7b1eDd2cE1Aef1F070ebFB4, 1250000000000000000000000);
487         _mint(0xF73e47f9812c4114bEf95a7892DA0c55c7F07337, 1250000000000000000000000);
488         _mint(0x3b989F8a8e328abD2fe639e36D10403E7cE6184E, 1037425380000000000000000);
489         _mint(0x995938EbaB9B3A91052F6E18D6f8a2341571B78E, 900000400000000000000000);
490         _mint(0xB0C0EF9bc23E4be189AF0d7128151BEaE842Bb6B, 600000000000000000000000);
491         _mint(0xa8eA553C1571528cD6fD4D2c7F17B3034B3A6CF3, 550000900000000000000000);
492         _mint(0x2d8Be983C7933883372793861394D89E65A93B19, 540000200000000000000000);
493         _mint(0x3353cd7cdA61648323624b4BeF9dfBde54Ed14aD, 500000800000000000000000);
494         _mint(0x2f6804d3927589a74651d4dBD64AB5BCC70CBd28, 500000400000000000000000);
495         _mint(0x2c7226a0c80885baccE1AD0e9ea73a558595FE25, 500000300000000000000000);
496         _mint(0x1ffd044183d272ad5d5F57eF54ef0991A1fcd77b, 250000700000000000000000);
497         _mint(0x2929C9e2934cC476Ec31a8Fc26F4cc2C4F6DcE92, 250000700000000000000000);
498         _mint(0xbb7A1f75B2919fb2c6818DCebAb54254da59f911, 250000000000000000000000);
499         _mint(0x65946d8D2E9c4882F6d0FEAED542008114f42EEB, 178755820000000000000000);
500         _mint(0xf07901B57970bB1aC572Aa8162D2036Be617C3cc, 178000300000000000000000);
501         _mint(0x3170Cb947C5199e225FDa23E1CD86b37d2E966d5, 137175200000000000000000);
502         _mint(0xDf5E38Faabb01CC35E4863d45641c834318C9a06, 125000900000000000000000);
503         _mint(0x22460f2C87E21898dB5C491629441E5810d98C7A, 125000300000000000000000);
504         _mint(0x28202C5b73Afe5E88355D1bF4f821eDba89C8449, 102875100000000000000000);
505         _mint(0x701F933E1A5d96801D24fa92f1E9D340A372a6FB, 75000400000000000000000);
506         _mint(0xaf207382Fb4Eedfb12f21d07cA3902Dc9b9F3C4f, 30000100000000000000000);
507         _mint(0x5A850CfB96f47A4713EF9681055df93143FB6bBA, 24192290000000000000000);
508         _mint(0xE4561BF6D5017D354f9B53500FE8BDa6E7F6180C, 18000700000000000000000);
509         _mint(0x805eF1C293013847Ee51D160DE2600AecdB381Ae, 5836950000000000000000);
510 
511     }
512 
513 }
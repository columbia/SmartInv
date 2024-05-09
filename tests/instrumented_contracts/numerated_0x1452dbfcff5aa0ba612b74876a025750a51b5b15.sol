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
27  * @title Roles
28  * @dev Library for managing addresses assigned to a Role.
29  */
30 library Roles {
31     struct Role {
32         mapping (address => bool) bearer;
33     }
34 
35     /**
36      * @dev give an account access to this role
37      */
38     function add(Role storage role, address account) internal {
39         require(account != address(0));
40         require(!has(role, account));
41 
42         role.bearer[account] = true;
43     }
44 
45     /**
46      * @dev remove an account's access to this role
47      */
48     function remove(Role storage role, address account) internal {
49         require(account != address(0));
50         require(has(role, account));
51 
52         role.bearer[account] = false;
53     }
54 
55     /**
56      * @dev check if an account has this role
57      * @return bool
58      */
59     function has(Role storage role, address account) internal view returns (bool) {
60         require(account != address(0));
61         return role.bearer[account];
62     }
63 }
64 
65 
66 
67 
68 contract MinterRole {
69     using Roles for Roles.Role;
70 
71     event MinterAdded(address indexed account);
72     event MinterRemoved(address indexed account);
73 
74     Roles.Role private _minters;
75 
76     constructor () internal {
77         _addMinter(msg.sender);
78     }
79 
80     modifier onlyMinter() {
81         require(isMinter(msg.sender));
82         _;
83     }
84 
85     function isMinter(address account) public view returns (bool) {
86         return _minters.has(account);
87     }
88 
89     function addMinter(address account) public onlyMinter {
90         _addMinter(account);
91     }
92 
93     function renounceMinter() public {
94         _removeMinter(msg.sender);
95     }
96 
97     function _addMinter(address account) internal {
98         _minters.add(account);
99         emit MinterAdded(account);
100     }
101 
102     function _removeMinter(address account) internal {
103         _minters.remove(account);
104         emit MinterRemoved(account);
105     }
106 }
107 
108 
109 
110 
111 
112 
113 /**
114  * @title ERC20Detailed token
115  * @dev The decimals are only for visualization purposes.
116  * All the operations are done using the smallest and indivisible token unit,
117  * just as on Ethereum all the operations are done in wei.
118  */
119 contract ERC20Detailed is IERC20 {
120     string private _name;
121     string private _symbol;
122     uint8 private _decimals;
123 
124     constructor (string memory name, string memory symbol, uint8 decimals) public {
125         _name = name;
126         _symbol = symbol;
127         _decimals = decimals;
128     }
129 
130     /**
131      * @return the name of the token.
132      */
133     function name() public view returns (string memory) {
134         return _name;
135     }
136 
137     /**
138      * @return the symbol of the token.
139      */
140     function symbol() public view returns (string memory) {
141         return _symbol;
142     }
143 
144     /**
145      * @return the number of decimals of the token.
146      */
147     function decimals() public view returns (uint8) {
148         return _decimals;
149     }
150 }
151 
152 
153 
154 
155 
156 
157 
158 
159 
160 
161 /**
162  * @title SafeMath
163  * @dev Unsigned math operations with safety checks that revert on error
164  */
165 library SafeMath {
166     /**
167     * @dev Multiplies two unsigned integers, reverts on overflow.
168     */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b);
179 
180         return c;
181     }
182 
183     /**
184     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
185     */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Solidity only automatically asserts when dividing by 0
188         require(b > 0);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
197     */
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         require(b <= a);
200         uint256 c = a - b;
201 
202         return c;
203     }
204 
205     /**
206     * @dev Adds two unsigned integers, reverts on overflow.
207     */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a);
211 
212         return c;
213     }
214 
215     /**
216     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
217     * reverts when dividing by zero.
218     */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         require(b != 0);
221         return a % b;
222     }
223 }
224 
225 
226 /**
227  * @title Standard ERC20 token
228  *
229  * @dev Implementation of the basic standard token.
230  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
231  * Originally based on code by FirstBlood:
232  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  *
234  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
235  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
236  * compliant implementations may not do it.
237  */
238 contract ERC20 is IERC20 {
239     using SafeMath for uint256;
240 
241     mapping (address => uint256) private _balances;
242 
243     mapping (address => mapping (address => uint256)) private _allowed;
244 
245     uint256 private _totalSupply;
246 
247     /**
248     * @dev Total number of tokens in existence
249     */
250     function totalSupply() public view returns (uint256) {
251         return _totalSupply;
252     }
253 
254     /**
255     * @dev Gets the balance of the specified address.
256     * @param owner The address to query the balance of.
257     * @return An uint256 representing the amount owned by the passed address.
258     */
259     function balanceOf(address owner) public view returns (uint256) {
260         return _balances[owner];
261     }
262 
263     /**
264      * @dev Function to check the amount of tokens that an owner allowed to a spender.
265      * @param owner address The address which owns the funds.
266      * @param spender address The address which will spend the funds.
267      * @return A uint256 specifying the amount of tokens still available for the spender.
268      */
269     function allowance(address owner, address spender) public view returns (uint256) {
270         return _allowed[owner][spender];
271     }
272 
273     /**
274     * @dev Transfer token for a specified address
275     * @param to The address to transfer to.
276     * @param value The amount to be transferred.
277     */
278     function transfer(address to, uint256 value) public returns (bool) {
279         _transfer(msg.sender, to, value);
280         return true;
281     }
282 
283     /**
284      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285      * Beware that changing an allowance with this method brings the risk that someone may use both the old
286      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289      * @param spender The address which will spend the funds.
290      * @param value The amount of tokens to be spent.
291      */
292     function approve(address spender, uint256 value) public returns (bool) {
293         require(spender != address(0));
294 
295         _allowed[msg.sender][spender] = value;
296         emit Approval(msg.sender, spender, value);
297         return true;
298     }
299 
300     /**
301      * @dev Transfer tokens from one address to another.
302      * Note that while this function emits an Approval event, this is not required as per the specification,
303      * and other compliant implementations may not emit the event.
304      * @param from address The address which you want to send tokens from
305      * @param to address The address which you want to transfer to
306      * @param value uint256 the amount of tokens to be transferred
307      */
308     function transferFrom(address from, address to, uint256 value) public returns (bool) {
309         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
310         _transfer(from, to, value);
311         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
312         return true;
313     }
314 
315     /**
316      * @dev Increase the amount of tokens that an owner allowed to a spender.
317      * approve should be called when allowed_[_spender] == 0. To increment
318      * allowed value is better to use this function to avoid 2 calls (and wait until
319      * the first transaction is mined)
320      * From MonolithDAO Token.sol
321      * Emits an Approval event.
322      * @param spender The address which will spend the funds.
323      * @param addedValue The amount of tokens to increase the allowance by.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
326         require(spender != address(0));
327 
328         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
329         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
330         return true;
331     }
332 
333     /**
334      * @dev Decrease the amount of tokens that an owner allowed to a spender.
335      * approve should be called when allowed_[_spender] == 0. To decrement
336      * allowed value is better to use this function to avoid 2 calls (and wait until
337      * the first transaction is mined)
338      * From MonolithDAO Token.sol
339      * Emits an Approval event.
340      * @param spender The address which will spend the funds.
341      * @param subtractedValue The amount of tokens to decrease the allowance by.
342      */
343     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
344         require(spender != address(0));
345 
346         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
347         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
348         return true;
349     }
350 
351     /**
352     * @dev Transfer token for a specified addresses
353     * @param from The address to transfer from.
354     * @param to The address to transfer to.
355     * @param value The amount to be transferred.
356     */
357     function _transfer(address from, address to, uint256 value) internal {
358         require(to != address(0));
359 
360         _balances[from] = _balances[from].sub(value);
361         _balances[to] = _balances[to].add(value);
362         emit Transfer(from, to, value);
363     }
364 
365     /**
366      * @dev Internal function that mints an amount of the token and assigns it to
367      * an account. This encapsulates the modification of balances such that the
368      * proper events are emitted.
369      * @param account The account that will receive the created tokens.
370      * @param value The amount that will be created.
371      */
372     function _mint(address account, uint256 value) internal {
373         require(account != address(0));
374 
375         _totalSupply = _totalSupply.add(value);
376         _balances[account] = _balances[account].add(value);
377         emit Transfer(address(0), account, value);
378     }
379 
380     /**
381      * @dev Internal function that burns an amount of the token of a given
382      * account.
383      * @param account The account whose tokens will be burnt.
384      * @param value The amount that will be burnt.
385      */
386     function _burn(address account, uint256 value) internal {
387         require(account != address(0));
388 
389         _totalSupply = _totalSupply.sub(value);
390         _balances[account] = _balances[account].sub(value);
391         emit Transfer(account, address(0), value);
392     }
393 
394     /**
395      * @dev Internal function that burns an amount of the token of a given
396      * account, deducting from the sender's allowance for said account. Uses the
397      * internal burn function.
398      * Emits an Approval event (reflecting the reduced allowance).
399      * @param account The account whose tokens will be burnt.
400      * @param value The amount that will be burnt.
401      */
402     function _burnFrom(address account, uint256 value) internal {
403         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
404         _burn(account, value);
405         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
406     }
407 }
408 
409 
410 
411 /**
412  * @title ERC20Mintable
413  * @dev ERC20 minting logic
414  */
415 contract ERC20Mintable is ERC20, MinterRole {
416     /**
417      * @dev Function to mint tokens
418      * @param to The address that will receive the minted tokens.
419      * @param value The amount of tokens to mint.
420      * @return A boolean that indicates if the operation was successful.
421      */
422     function mint(address to, uint256 value) public onlyMinter returns (bool) {
423         _mint(to, value);
424         return true;
425     }
426 }
427 
428 
429 /**
430  * @title Capped token
431  * @dev Mintable token with a token cap.
432  */
433 contract ERC20Capped is ERC20Mintable {
434     uint256 private _cap;
435 
436     constructor (uint256 cap) public {
437         require(cap > 0);
438         _cap = cap;
439     }
440 
441     /**
442      * @return the cap for the token minting.
443      */
444     function cap() public view returns (uint256) {
445         return _cap;
446     }
447 
448     function _mint(address account, uint256 value) internal {
449         require(totalSupply().add(value) <= _cap);
450         super._mint(account, value);
451     }
452 }
453 
454 
455 contract UniqToken is ERC20Detailed, ERC20Capped{
456 
457   using SafeMath for uint256;
458 
459   uint8 public constant DECIMALS = 18;
460   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS));
461   uint256 public constant TOTAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
462   uint256 public initialBlockCount = 5095535;
463   uint256 public currentBlockNumber = 5095535;
464   uint256 public totalRewardAddress = 10;
465   uint256 public perAddressToken = 50000 * (10 ** uint256(DECIMALS));
466   uint256 public minimumBlocks = 10;
467 
468   mapping (address => uint256) private _balances;
469   address[] _rewardAddress = [
470     0x8459676AfCb1804c8ec4Ca2436DDe3Dcc3834c00,
471     0x1F9d07c81a416bcE0dCd13F13f523a65377Dad0B,
472     0x859730593eBd4aF41CcBf187A166fbeab16740e0,
473     0x4C077984C6F430bCD1a574A09B2A0cF4E592464D,
474     0x0A8C3A722D96a9233c83cAd536d83A7d50Cee7FA,
475     0x194C252A9E0eAe3240E305d98E7BCd952Bf2d7E4,
476     0xD09dB349998053dcd7d0e415b529813c96757Bd7,
477     0x3c56d3418Bb03Ae5A478A8beCE49CC8C03aFa5cD,
478     0xF9ED74071bb6c86fDd30Bb3Cb30Be1504803d5De,
479     0x205f884e2b795d330095c863486bD0615aD8371e
480   ];
481 
482 
483 
484   constructor () public ERC20Detailed("UniqCoin", "UNIQ", DECIMALS) ERC20Capped(TOTAL_SUPPLY) {
485     _mint(msg.sender, INITIAL_SUPPLY);
486   }
487 
488   function currentEthBlock() public view returns (uint256 blockNumber)
489   {
490     return block.number;
491   }
492 
493   function executeDailyMining() public returns (bool) {
494     require(block.number.sub(currentBlockNumber) >= minimumBlocks);
495 
496     currentBlockNumber = block.number;
497     for(uint i = 0 ; i<totalRewardAddress; i++) {
498       _mint(_rewardAddress[i], perAddressToken);
499     }
500 
501     return true;
502  }
503 }
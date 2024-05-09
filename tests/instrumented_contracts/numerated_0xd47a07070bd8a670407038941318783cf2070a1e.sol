1 /*
2     Moon Token for MoonTrader Platform and projects
3     More information at https://moontrader.io/
4 
5     MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/
6 
7     Mail us to: info@moontrader.io 
8 
9     Join the Telegram channel https://t.me/moontrader_news_en, 
10     Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.
11 
12  */
13 
14 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
15 
16 pragma solidity ^0.5.2;
17 
18 /**
19  * @title ERC20 interface
20  * @dev see https://eips.ethereum.org/EIPS/eip-20
21  */
22 interface IERC20 {
23     function transfer(address to, uint256 value) external returns (bool);
24 
25     function approve(address spender, uint256 value) external returns (bool);
26 
27     function transferFrom(address from, address to, uint256 value) external returns (bool);
28 
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address who) external view returns (uint256);
32 
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
41 
42 pragma solidity ^0.5.2;
43 
44 /**
45  * @title SafeMath
46  * @dev Unsigned math operations with safety checks that revert on error
47  */
48 library SafeMath {
49     /**
50      * @dev Multiplies two unsigned integers, reverts on overflow.
51      */
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b);
62 
63         return c;
64     }
65 
66     /**
67      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
68      */
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     /**
79      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
80      */
81     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
82         require(b <= a);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Adds two unsigned integers, reverts on overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a);
94 
95         return c;
96     }
97 
98     /**
99      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
100      * reverts when dividing by zero.
101      */
102     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
103         require(b != 0);
104         return a % b;
105     }
106 }
107 
108 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
109 
110 pragma solidity ^0.5.2;
111 
112 
113 
114 /**
115  * @title Standard ERC20 token
116  *
117  * @dev Implementation of the basic standard token.
118  * https://eips.ethereum.org/EIPS/eip-20
119  * Originally based on code by FirstBlood:
120  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  *
122  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
123  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
124  * compliant implementations may not do it.
125  */
126 contract ERC20 is IERC20 {
127     using SafeMath for uint256;
128 
129     mapping (address => uint256) private _balances;
130 
131     mapping (address => mapping (address => uint256)) private _allowed;
132 
133     uint256 private _totalSupply;
134 
135     /**
136      * @dev Total number of tokens in existence
137      */
138     function totalSupply() public view returns (uint256) {
139         return _totalSupply;
140     }
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param owner The address to query the balance of.
145      * @return A uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address owner) public view returns (uint256) {
148         return _balances[owner];
149     }
150 
151     /**
152      * @dev Function to check the amount of tokens that an owner allowed to a spender.
153      * @param owner address The address which owns the funds.
154      * @param spender address The address which will spend the funds.
155      * @return A uint256 specifying the amount of tokens still available for the spender.
156      */
157     function allowance(address owner, address spender) public view returns (uint256) {
158         return _allowed[owner][spender];
159     }
160 
161     /**
162      * @dev Transfer token to a specified address
163      * @param to The address to transfer to.
164      * @param value The amount to be transferred.
165      */
166     function transfer(address to, uint256 value) public returns (bool) {
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * Beware that changing an allowance with this method brings the risk that someone may use both the old
174      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      * @param spender The address which will spend the funds.
178      * @param value The amount of tokens to be spent.
179      */
180     function approve(address spender, uint256 value) public returns (bool) {
181         _approve(msg.sender, spender, value);
182         return true;
183     }
184 
185     /**
186      * @dev Transfer tokens from one address to another.
187      * Note that while this function emits an Approval event, this is not required as per the specification,
188      * and other compliant implementations may not emit the event.
189      * @param from address The address which you want to send tokens from
190      * @param to address The address which you want to transfer to
191      * @param value uint256 the amount of tokens to be transferred
192      */
193     function transferFrom(address from, address to, uint256 value) public returns (bool) {
194         _transfer(from, to, value);
195         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
196         return true;
197     }
198 
199     /**
200      * @dev Increase the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param addedValue The amount of tokens to increase the allowance by.
208      */
209     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Decrease the amount of tokens that an owner allowed to a spender.
216      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
217      * allowed value is better to use this function to avoid 2 calls (and wait until
218      * the first transaction is mined)
219      * From MonolithDAO Token.sol
220      * Emits an Approval event.
221      * @param spender The address which will spend the funds.
222      * @param subtractedValue The amount of tokens to decrease the allowance by.
223      */
224     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
225         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
226         return true;
227     }
228 
229     /**
230      * @dev Transfer token for a specified addresses
231      * @param from The address to transfer from.
232      * @param to The address to transfer to.
233      * @param value The amount to be transferred.
234      */
235     function _transfer(address from, address to, uint256 value) internal {
236         require(to != address(0));
237 
238         _balances[from] = _balances[from].sub(value);
239         _balances[to] = _balances[to].add(value);
240         emit Transfer(from, to, value);
241     }
242 
243     /**
244      * @dev Internal function that mints an amount of the token and assigns it to
245      * an account. This encapsulates the modification of balances such that the
246      * proper events are emitted.
247      * @param account The account that will receive the created tokens.
248      * @param value The amount that will be created.
249      */
250     function _mint(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.add(value);
254         _balances[account] = _balances[account].add(value);
255         emit Transfer(address(0), account, value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account.
261      * @param account The account whose tokens will be burnt.
262      * @param value The amount that will be burnt.
263      */
264     function _burn(address account, uint256 value) internal {
265         require(account != address(0));
266 
267         _totalSupply = _totalSupply.sub(value);
268         _balances[account] = _balances[account].sub(value);
269         emit Transfer(account, address(0), value);
270     }
271 
272     /**
273      * @dev Approve an address to spend another addresses' tokens.
274      * @param owner The address that owns the tokens.
275      * @param spender The address that will spend the tokens.
276      * @param value The number of tokens that can be spent.
277      */
278     function _approve(address owner, address spender, uint256 value) internal {
279         require(spender != address(0));
280         require(owner != address(0));
281 
282         _allowed[owner][spender] = value;
283         emit Approval(owner, spender, value);
284     }
285 
286     /**
287      * @dev Internal function that burns an amount of the token of a given
288      * account, deducting from the sender's allowance for said account. Uses the
289      * internal burn function.
290      * Emits an Approval event (reflecting the reduced allowance).
291      * @param account The account whose tokens will be burnt.
292      * @param value The amount that will be burnt.
293      */
294     function _burnFrom(address account, uint256 value) internal {
295         _burn(account, value);
296         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
297     }
298 }
299 
300 // File: openzeppelin-solidity/contracts/access/Roles.sol
301 
302 pragma solidity ^0.5.2;
303 
304 /**
305  * @title Roles
306  * @dev Library for managing addresses assigned to a Role.
307  */
308 library Roles {
309     struct Role {
310         mapping (address => bool) bearer;
311     }
312 
313     /**
314      * @dev give an account access to this role
315      */
316     function add(Role storage role, address account) internal {
317         require(account != address(0));
318         require(!has(role, account));
319 
320         role.bearer[account] = true;
321     }
322 
323     /**
324      * @dev remove an account's access to this role
325      */
326     function remove(Role storage role, address account) internal {
327         require(account != address(0));
328         require(has(role, account));
329 
330         role.bearer[account] = false;
331     }
332 
333     /**
334      * @dev check if an account has this role
335      * @return bool
336      */
337     function has(Role storage role, address account) internal view returns (bool) {
338         require(account != address(0));
339         return role.bearer[account];
340     }
341 }
342 
343 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
344 
345 pragma solidity ^0.5.2;
346 
347 
348 contract MinterRole {
349     using Roles for Roles.Role;
350 
351     event MinterAdded(address indexed account);
352     event MinterRemoved(address indexed account);
353 
354     Roles.Role private _minters;
355 
356     constructor () internal {
357         _addMinter(msg.sender);
358     }
359 
360     modifier onlyMinter() {
361         require(isMinter(msg.sender));
362         _;
363     }
364 
365     function isMinter(address account) public view returns (bool) {
366         return _minters.has(account);
367     }
368 
369     function addMinter(address account) public onlyMinter {
370         _addMinter(account);
371     }
372 
373     function renounceMinter() public {
374         _removeMinter(msg.sender);
375     }
376 
377     function _addMinter(address account) internal {
378         _minters.add(account);
379         emit MinterAdded(account);
380     }
381 
382     function _removeMinter(address account) internal {
383         _minters.remove(account);
384         emit MinterRemoved(account);
385     }
386 }
387 
388 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
389 
390 pragma solidity ^0.5.2;
391 
392 
393 
394 /**
395  * @title ERC20Mintable
396  * @dev ERC20 minting logic
397  */
398 contract ERC20Mintable is ERC20, MinterRole {
399     /**
400      * @dev Function to mint tokens
401      * @param to The address that will receive the minted tokens.
402      * @param value The amount of tokens to mint.
403      * @return A boolean that indicates if the operation was successful.
404      */
405     function mint(address to, uint256 value) public onlyMinter returns (bool) {
406         _mint(to, value);
407         return true;
408     }
409 }
410 
411 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol
412 
413 pragma solidity ^0.5.2;
414 
415 
416 /**
417  * @title Capped token
418  * @dev Mintable token with a token cap.
419  */
420 contract ERC20Capped is ERC20Mintable {
421     uint256 private _cap;
422 
423     constructor (uint256 cap) public {
424         require(cap > 0);
425         _cap = cap;
426     }
427 
428     /**
429      * @return the cap for the token minting.
430      */
431     function cap() public view returns (uint256) {
432         return _cap;
433     }
434 
435     function _mint(address account, uint256 value) internal {
436         require(totalSupply().add(value) <= _cap);
437         super._mint(account, value);
438     }
439 }
440 
441 // File: contracts/Moon_Token.sol
442 
443 pragma solidity ^0.5.2;
444 
445 
446 /*
447     Moon Token for MoonTrader Platform and projects
448     More information at https://moontrader.io/
449 
450     MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/
451 
452     Mail us to: info@moontrader.io 
453 
454     Join the Telegram channel https://t.me/moontrader_news_en, 
455     Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.
456 
457  */
458 
459 contract Moon_Token is ERC20Capped {
460     string public constant name = "MoonTrader";
461     string public constant symbol = "MOON";
462     uint8 public constant decimals = 18;
463 
464     constructor(uint256 supply)
465     ERC20Capped(supply)
466     public
467     {
468 
469     }
470 }
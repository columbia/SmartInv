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
24 /*
25     Copyright 2017-2019 Phillip A. Elsasser
26 
27     Licensed under the Apache License, Version 2.0 (the "License");
28     you may not use this file except in compliance with the License.
29     You may obtain a copy of the License at
30 
31     http://www.apache.org/licenses/LICENSE-2.0
32 
33     Unless required by applicable law or agreed to in writing, software
34     distributed under the License is distributed on an "AS IS" BASIS,
35     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
36     See the License for the specific language governing permissions and
37     limitations under the License.
38 */
39 
40 
41 
42 /*
43     Copyright 2017-2019 Phillip A. Elsasser
44 
45     Licensed under the Apache License, Version 2.0 (the "License");
46     you may not use this file except in compliance with the License.
47     You may obtain a copy of the License at
48 
49     http://www.apache.org/licenses/LICENSE-2.0
50 
51     Unless required by applicable law or agreed to in writing, software
52     distributed under the License is distributed on an "AS IS" BASIS,
53     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
54     See the License for the specific language governing permissions and
55     limitations under the License.
56 */
57 
58 
59 
60 /*
61     Copyright 2017-2019 Phillip A. Elsasser
62 
63     Licensed under the Apache License, Version 2.0 (the "License");
64     you may not use this file except in compliance with the License.
65     You may obtain a copy of the License at
66 
67     http://www.apache.org/licenses/LICENSE-2.0
68 
69     Unless required by applicable law or agreed to in writing, software
70     distributed under the License is distributed on an "AS IS" BASIS,
71     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
72     See the License for the specific language governing permissions and
73     limitations under the License.
74 */
75 
76 
77 
78 
79 /// @title Upgradeable Target
80 /// @notice A contract (or a token itself) that can facilitate the upgrade from an existing deployed token
81 /// to allow us to upgrade our token's functionality.
82 /// @author Phil Elsasser <phil@marketprotocol.io>
83 contract UpgradeableTarget {
84     function upgradeFrom(address from, uint256 value) external; // note: implementation should require(from == oldToken)
85 }
86 
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94     address private _owner;
95 
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     /**
99      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100      * account.
101      */
102     constructor () internal {
103         _owner = msg.sender;
104         emit OwnershipTransferred(address(0), _owner);
105     }
106 
107     /**
108      * @return the address of the owner.
109      */
110     function owner() public view returns (address) {
111         return _owner;
112     }
113 
114     /**
115      * @dev Throws if called by any account other than the owner.
116      */
117     modifier onlyOwner() {
118         require(isOwner());
119         _;
120     }
121 
122     /**
123      * @return true if `msg.sender` is the owner of the contract.
124      */
125     function isOwner() public view returns (bool) {
126         return msg.sender == _owner;
127     }
128 
129     /**
130      * @dev Allows the current owner to relinquish control of the contract.
131      * It will not be possible to call the functions with the `onlyOwner`
132      * modifier anymore.
133      * @notice Renouncing ownership will leave the contract without an owner,
134      * thereby removing any functionality that is only available to the owner.
135      */
136     function renounceOwnership() public onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140 
141     /**
142      * @dev Allows the current owner to transfer control of the contract to a newOwner.
143      * @param newOwner The address to transfer ownership to.
144      */
145     function transferOwnership(address newOwner) public onlyOwner {
146         _transferOwnership(newOwner);
147     }
148 
149     /**
150      * @dev Transfers control of the contract to a newOwner.
151      * @param newOwner The address to transfer ownership to.
152      */
153     function _transferOwnership(address newOwner) internal {
154         require(newOwner != address(0));
155         emit OwnershipTransferred(_owner, newOwner);
156         _owner = newOwner;
157     }
158 }
159 
160 
161 
162 
163 
164 
165 
166 
167 /**
168  * @title SafeMath
169  * @dev Unsigned math operations with safety checks that revert on error
170  */
171 library SafeMath {
172     /**
173      * @dev Multiplies two unsigned integers, reverts on overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b);
185 
186         return c;
187     }
188 
189     /**
190      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
203      */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         require(b <= a);
206         uint256 c = a - b;
207 
208         return c;
209     }
210 
211     /**
212      * @dev Adds two unsigned integers, reverts on overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a);
217 
218         return c;
219     }
220 
221     /**
222      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
223      * reverts when dividing by zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         require(b != 0);
227         return a % b;
228     }
229 }
230 
231 
232 /**
233  * @title Standard ERC20 token
234  *
235  * @dev Implementation of the basic standard token.
236  * https://eips.ethereum.org/EIPS/eip-20
237  * Originally based on code by FirstBlood:
238  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
239  *
240  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
241  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
242  * compliant implementations may not do it.
243  */
244 contract ERC20 is IERC20 {
245     using SafeMath for uint256;
246 
247     mapping (address => uint256) private _balances;
248 
249     mapping (address => mapping (address => uint256)) private _allowed;
250 
251     uint256 private _totalSupply;
252 
253     /**
254      * @dev Total number of tokens in existence
255      */
256     function totalSupply() public view returns (uint256) {
257         return _totalSupply;
258     }
259 
260     /**
261      * @dev Gets the balance of the specified address.
262      * @param owner The address to query the balance of.
263      * @return A uint256 representing the amount owned by the passed address.
264      */
265     function balanceOf(address owner) public view returns (uint256) {
266         return _balances[owner];
267     }
268 
269     /**
270      * @dev Function to check the amount of tokens that an owner allowed to a spender.
271      * @param owner address The address which owns the funds.
272      * @param spender address The address which will spend the funds.
273      * @return A uint256 specifying the amount of tokens still available for the spender.
274      */
275     function allowance(address owner, address spender) public view returns (uint256) {
276         return _allowed[owner][spender];
277     }
278 
279     /**
280      * @dev Transfer token to a specified address
281      * @param to The address to transfer to.
282      * @param value The amount to be transferred.
283      */
284     function transfer(address to, uint256 value) public returns (bool) {
285         _transfer(msg.sender, to, value);
286         return true;
287     }
288 
289     /**
290      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
291      * Beware that changing an allowance with this method brings the risk that someone may use both the old
292      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
293      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
294      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295      * @param spender The address which will spend the funds.
296      * @param value The amount of tokens to be spent.
297      */
298     function approve(address spender, uint256 value) public returns (bool) {
299         _approve(msg.sender, spender, value);
300         return true;
301     }
302 
303     /**
304      * @dev Transfer tokens from one address to another.
305      * Note that while this function emits an Approval event, this is not required as per the specification,
306      * and other compliant implementations may not emit the event.
307      * @param from address The address which you want to send tokens from
308      * @param to address The address which you want to transfer to
309      * @param value uint256 the amount of tokens to be transferred
310      */
311     function transferFrom(address from, address to, uint256 value) public returns (bool) {
312         _transfer(from, to, value);
313         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
314         return true;
315     }
316 
317     /**
318      * @dev Increase the amount of tokens that an owner allowed to a spender.
319      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
320      * allowed value is better to use this function to avoid 2 calls (and wait until
321      * the first transaction is mined)
322      * From MonolithDAO Token.sol
323      * Emits an Approval event.
324      * @param spender The address which will spend the funds.
325      * @param addedValue The amount of tokens to increase the allowance by.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
328         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
329         return true;
330     }
331 
332     /**
333      * @dev Decrease the amount of tokens that an owner allowed to a spender.
334      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
335      * allowed value is better to use this function to avoid 2 calls (and wait until
336      * the first transaction is mined)
337      * From MonolithDAO Token.sol
338      * Emits an Approval event.
339      * @param spender The address which will spend the funds.
340      * @param subtractedValue The amount of tokens to decrease the allowance by.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
343         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
344         return true;
345     }
346 
347     /**
348      * @dev Transfer token for a specified addresses
349      * @param from The address to transfer from.
350      * @param to The address to transfer to.
351      * @param value The amount to be transferred.
352      */
353     function _transfer(address from, address to, uint256 value) internal {
354         require(to != address(0));
355 
356         _balances[from] = _balances[from].sub(value);
357         _balances[to] = _balances[to].add(value);
358         emit Transfer(from, to, value);
359     }
360 
361     /**
362      * @dev Internal function that mints an amount of the token and assigns it to
363      * an account. This encapsulates the modification of balances such that the
364      * proper events are emitted.
365      * @param account The account that will receive the created tokens.
366      * @param value The amount that will be created.
367      */
368     function _mint(address account, uint256 value) internal {
369         require(account != address(0));
370 
371         _totalSupply = _totalSupply.add(value);
372         _balances[account] = _balances[account].add(value);
373         emit Transfer(address(0), account, value);
374     }
375 
376     /**
377      * @dev Internal function that burns an amount of the token of a given
378      * account.
379      * @param account The account whose tokens will be burnt.
380      * @param value The amount that will be burnt.
381      */
382     function _burn(address account, uint256 value) internal {
383         require(account != address(0));
384 
385         _totalSupply = _totalSupply.sub(value);
386         _balances[account] = _balances[account].sub(value);
387         emit Transfer(account, address(0), value);
388     }
389 
390     /**
391      * @dev Approve an address to spend another addresses' tokens.
392      * @param owner The address that owns the tokens.
393      * @param spender The address that will spend the tokens.
394      * @param value The number of tokens that can be spent.
395      */
396     function _approve(address owner, address spender, uint256 value) internal {
397         require(spender != address(0));
398         require(owner != address(0));
399 
400         _allowed[owner][spender] = value;
401         emit Approval(owner, spender, value);
402     }
403 
404     /**
405      * @dev Internal function that burns an amount of the token of a given
406      * account, deducting from the sender's allowance for said account. Uses the
407      * internal burn function.
408      * Emits an Approval event (reflecting the reduced allowance).
409      * @param account The account whose tokens will be burnt.
410      * @param value The amount that will be burnt.
411      */
412     function _burnFrom(address account, uint256 value) internal {
413         _burn(account, value);
414         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
415     }
416 }
417 
418 
419 /**
420  * @title Burnable Token
421  * @dev Token that can be irreversibly burned (destroyed).
422  */
423 contract ERC20Burnable is ERC20 {
424     /**
425      * @dev Burns a specific amount of tokens.
426      * @param value The amount of token to be burned.
427      */
428     function burn(uint256 value) public {
429         _burn(msg.sender, value);
430     }
431 
432     /**
433      * @dev Burns a specific amount of tokens from the target address and decrements allowance
434      * @param from address The account whose tokens will be burned.
435      * @param value uint256 The amount of token to be burned.
436      */
437     function burnFrom(address from, uint256 value) public {
438         _burnFrom(from, value);
439     }
440 }
441 
442 
443 
444 /// @title Upgradeable Token
445 /// @notice allows for us to update some of the needed functionality in our tokens post deployment. Inspiration taken
446 /// from Golems migrate functionality.
447 /// @author Phil Elsasser <phil@marketprotocol.io>
448 contract UpgradeableToken is Ownable, ERC20Burnable {
449 
450     address public upgradeableTarget;       // contract address handling upgrade
451     uint256 public totalUpgraded;           // total token amount already upgraded
452 
453     event Upgraded(address indexed from, address indexed to, uint256 value);
454 
455     /*
456     // EXTERNAL METHODS - TOKEN UPGRADE SUPPORT
457     */
458 
459     /// @notice Update token to the new upgraded token
460     /// @param value The amount of token to be migrated to upgraded token
461     function upgrade(uint256 value) external {
462         require(upgradeableTarget != address(0), "cannot upgrade with no target");
463 
464         burn(value);                    // burn tokens as we migrate them.
465         totalUpgraded = totalUpgraded.add(value);
466 
467         UpgradeableTarget(upgradeableTarget).upgradeFrom(msg.sender, value);
468         emit Upgraded(msg.sender, upgradeableTarget, value);
469     }
470 
471     /// @notice Set address of upgrade target process.
472     /// @param upgradeAddress The address of the UpgradeableTarget contract.
473     function setUpgradeableTarget(address upgradeAddress) external onlyOwner {
474         upgradeableTarget = upgradeAddress;
475     }
476 
477 }
478 
479 
480 /// @title Market Token
481 /// @notice Our membership token.  Users must lock tokens to enable trading for a given Market Contract
482 /// as well as have a minimum balance of tokens to create new Market Contracts.
483 /// @author Phil Elsasser <phil@marketprotocol.io>
484 contract MarketToken is UpgradeableToken {
485 
486     string public constant name = "MARKET Protocol Token";
487     string public constant symbol = "MKT";
488     uint8 public constant decimals = 18;
489 
490     uint public constant INITIAL_SUPPLY = 600000000 * 10**uint(decimals); // 600 million tokens with 18 decimals (6e+26)
491 
492     constructor() public {
493         _mint(msg.sender, INITIAL_SUPPLY);
494     }
495 }
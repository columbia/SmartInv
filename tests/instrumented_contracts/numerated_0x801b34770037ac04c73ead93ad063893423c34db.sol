1 pragma solidity 0.5.8;
2 
3 
4 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
5 
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/20
10  */
11 interface IERC20 {
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     function approve(address spender, uint256 value) external returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value) external returns (bool);
17 
18     function totalSupply() external view returns (uint256);
19 
20     function balanceOf(address who) external view returns (uint256);
21 
22     function allowance(address owner, address spender) external view returns (uint256);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  */
36 library SafeMath {
37     /**
38     * @dev Multiplies two unsigned integers, reverts on overflow.
39     */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Adds two unsigned integers, reverts on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88     * reverts when dividing by zero.
89     */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
104  * Originally based on code by FirstBlood:
105  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 contract ERC20 is IERC20 {
112     using SafeMath for uint256;
113 
114     mapping (address => uint256) private _balances;
115 
116     mapping (address => mapping (address => uint256)) private _allowed;
117 
118     uint256 private _totalSupply;
119 
120     /**
121     * @dev Total number of tokens in existence
122     */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128     * @dev Gets the balance of the specified address.
129     * @param owner The address to query the balance of.
130     * @return An uint256 representing the amount owned by the passed address.
131     */
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      * @param owner address The address which owns the funds.
139      * @param spender address The address which will spend the funds.
140      * @return A uint256 specifying the amount of tokens still available for the spender.
141      */
142     function allowance(address owner, address spender) public view returns (uint256) {
143         return _allowed[owner][spender];
144     }
145 
146     /**
147     * @dev Transfer token for a specified address
148     * @param to The address to transfer to.
149     * @param value The amount to be transferred.
150     */
151     function transfer(address to, uint256 value) public returns (bool) {
152         _transfer(msg.sender, to, value);
153         return true;
154     }
155 
156     /**
157      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158      * Beware that changing an allowance with this method brings the risk that someone may use both the old
159      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      * @param spender The address which will spend the funds.
163      * @param value The amount of tokens to be spent.
164      */
165     function approve(address spender, uint256 value) public returns (bool) {
166         require(spender != address(0));
167 
168         _allowed[msg.sender][spender] = value;
169         emit Approval(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
183         _transfer(from, to, value);
184         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
185         return true;
186     }
187 
188     /**
189      * @dev Increase the amount of tokens that an owner allowed to a spender.
190      * approve should be called when allowed_[_spender] == 0. To increment
191      * allowed value is better to use this function to avoid 2 calls (and wait until
192      * the first transaction is mined)
193      * From MonolithDAO Token.sol
194      * Emits an Approval event.
195      * @param spender The address which will spend the funds.
196      * @param addedValue The amount of tokens to increase the allowance by.
197      */
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199         require(spender != address(0));
200 
201         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
202         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203         return true;
204     }
205 
206     /**
207      * @dev Decrease the amount of tokens that an owner allowed to a spender.
208      * approve should be called when allowed_[_spender] == 0. To decrement
209      * allowed value is better to use this function to avoid 2 calls (and wait until
210      * the first transaction is mined)
211      * From MonolithDAO Token.sol
212      * Emits an Approval event.
213      * @param spender The address which will spend the funds.
214      * @param subtractedValue The amount of tokens to decrease the allowance by.
215      */
216     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
217         require(spender != address(0));
218 
219         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
220         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221         return true;
222     }
223 
224     /**
225     * @dev Transfer token for a specified addresses
226     * @param from The address to transfer from.
227     * @param to The address to transfer to.
228     * @param value The amount to be transferred.
229     */
230     function _transfer(address from, address to, uint256 value) internal {
231         require(to != address(0));
232 
233         _balances[from] = _balances[from].sub(value);
234         _balances[to] = _balances[to].add(value);
235         emit Transfer(from, to, value);
236     }
237 
238     /**
239      * @dev Internal function that mints an amount of the token and assigns it to
240      * an account. This encapsulates the modification of balances such that the
241      * proper events are emitted.
242      * @param account The account that will receive the created tokens.
243      * @param value The amount that will be created.
244      */
245     function _mint(address account, uint256 value) internal {
246         require(account != address(0));
247 
248         _totalSupply = _totalSupply.add(value);
249         _balances[account] = _balances[account].add(value);
250         emit Transfer(address(0), account, value);
251     }
252 
253     /**
254      * @dev Internal function that burns an amount of the token of a given
255      * account.
256      * @param account The account whose tokens will be burnt.
257      * @param value The amount that will be burnt.
258      */
259     function _burn(address account, uint256 value) internal {
260         require(account != address(0));
261 
262         _totalSupply = _totalSupply.sub(value);
263         _balances[account] = _balances[account].sub(value);
264         emit Transfer(account, address(0), value);
265     }
266 
267     /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account, deducting from the sender's allowance for said account. Uses the
270      * internal burn function.
271      * Emits an Approval event (reflecting the reduced allowance).
272      * @param account The account whose tokens will be burnt.
273      * @param value The amount that will be burnt.
274      */
275     function _burnFrom(address account, uint256 value) internal {
276         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
277         _burn(account, value);
278         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
279     }
280 }
281 
282 // File: openzeppelin-solidity/contracts/access/Roles.sol
283 
284 
285 /**
286  * @title Roles
287  * @dev Library for managing addresses assigned to a Role.
288  */
289 library Roles {
290     struct Role {
291         mapping (address => bool) bearer;
292     }
293 
294     /**
295      * @dev give an account access to this role
296      */
297     function add(Role storage role, address account) internal {
298         require(account != address(0));
299         require(!has(role, account));
300 
301         role.bearer[account] = true;
302     }
303 
304     /**
305      * @dev remove an account's access to this role
306      */
307     function remove(Role storage role, address account) internal {
308         require(account != address(0));
309         require(has(role, account));
310 
311         role.bearer[account] = false;
312     }
313 
314     /**
315      * @dev check if an account has this role
316      * @return bool
317      */
318     function has(Role storage role, address account) internal view returns (bool) {
319         require(account != address(0));
320         return role.bearer[account];
321     }
322 }
323 
324 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
325 
326 
327 contract MinterRole {
328     using Roles for Roles.Role;
329 
330     event MinterAdded(address indexed account);
331     event MinterRemoved(address indexed account);
332 
333     Roles.Role private _minters;
334 
335     constructor () internal {
336         _addMinter(msg.sender);
337     }
338 
339     modifier onlyMinter() {
340         require(isMinter(msg.sender));
341         _;
342     }
343 
344     function isMinter(address account) public view returns (bool) {
345         return _minters.has(account);
346     }
347 
348     function addMinter(address account) public onlyMinter {
349         _addMinter(account);
350     }
351 
352     function renounceMinter() public {
353         _removeMinter(msg.sender);
354     }
355 
356     function _addMinter(address account) internal {
357         _minters.add(account);
358         emit MinterAdded(account);
359     }
360 
361     function _removeMinter(address account) internal {
362         _minters.remove(account);
363         emit MinterRemoved(account);
364     }
365 }
366 
367 // File: contracts/token/ERC20Interface.sol
368 
369 
370 interface ERC20Interface {
371   // Standard ERC-20 interface.
372   function transfer(address to, uint256 value) external returns (bool);
373   function approve(address spender, uint256 value) external returns (bool);
374   function transferFrom(address from, address to, uint256 value) external returns (bool);
375   function totalSupply() external view returns (uint256);
376   function balanceOf(address who) external view returns (uint256);
377   function allowance(address owner, address spender) external view returns (uint256);
378   // Extension of ERC-20 interface to support supply adjustment.
379   function mint(address to, uint256 value) external returns (bool);
380   function burn(address from, uint256 value) external returns (bool);
381 }
382 
383 // File: contracts/token/ERC20Base.sol
384 
385 
386 contract ERC20Base is ERC20Interface, ERC20, MinterRole {
387   string public name;
388   string public symbol;
389   uint8 public decimals = 18;
390 
391   constructor(string memory _name, string memory _symbol) public {
392     name = _name;
393     symbol = _symbol;
394   }
395 
396   function transferAndCall(address to, uint256 value, bytes4 sig, bytes memory data)
397     public
398     returns (bool)
399   {
400     _transfer(msg.sender, to, value);
401     (bool success,) = to.call(abi.encodePacked(sig, uint256(msg.sender), value, data));
402     require(success);
403     return true;
404   }
405 
406   function mint(address to, uint256 value) public onlyMinter returns (bool) {
407     _mint(to, value);
408     return true;
409   }
410 
411   function burn(address from, uint256 value) public onlyMinter returns (bool) {
412     _burn(from, value);
413     return true;
414   }
415 }
416 
417 // File: contracts/BandToken.sol
418 
419 
420 contract BandToken is ERC20Base("BandToken", "BAND") {}
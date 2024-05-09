1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Roles
69  * @dev Library for managing addresses assigned to a Role.
70  */
71 library Roles {
72     struct Role {
73         mapping (address => bool) bearer;
74     }
75 
76     /**
77      * @dev give an account access to this role
78      */
79     function add(Role storage role, address account) internal {
80         require(account != address(0));
81         require(!has(role, account));
82 
83         role.bearer[account] = true;
84     }
85 
86     /**
87      * @dev remove an account's access to this role
88      */
89     function remove(Role storage role, address account) internal {
90         require(account != address(0));
91         require(has(role, account));
92 
93         role.bearer[account] = false;
94     }
95 
96     /**
97      * @dev check if an account has this role
98      * @return bool
99      */
100     function has(Role storage role, address account) internal view returns (bool) {
101         require(account != address(0));
102         return role.bearer[account];
103     }
104 }
105 
106 contract AdminRole {
107     using Roles for Roles.Role;
108 
109     event AdminAdded(address indexed account);
110     event AdminRemoved(address indexed account);
111 
112     Roles.Role private _admins;
113 
114     constructor () internal {
115         _addAdmin(msg.sender);
116     }
117 
118     modifier onlyAdmin() {
119         require(isAdmin(msg.sender));
120         _;
121     }
122 
123     function isAdmin(address account) public view returns (bool) {
124         return _admins.has(account);
125     }
126 
127     function addAdmin(address account) public onlyAdmin {
128         _addAdmin(account);
129     }
130 
131     function renounceAdmin() public {
132         _removeAdmin(msg.sender);
133     }
134 
135     function _addAdmin(address account) internal {
136         _admins.add(account);
137         emit AdminAdded(account);
138     }
139 
140     function _removeAdmin(address account) internal {
141         _admins.remove(account);
142         emit AdminRemoved(account);
143     }
144 }
145 
146 /**
147  * @title ERC20 interface
148  * @dev see https://github.com/ethereum/EIPs/issues/20
149  */
150 interface IERC20 {
151     function totalSupply() external view returns (uint256);
152 
153     function balanceOf(address who) external view returns (uint256);
154 
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     function transfer(address to, uint256 value) external returns (bool);
158 
159     function approve(address spender, uint256 value) external returns (bool);
160 
161     function transferFrom(address from, address to, uint256 value) external returns (bool);
162 
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 }
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
173  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  *
175  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
176  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
177  * compliant implementations may not do it.
178  */
179 contract ERC20 is IERC20 {
180     using SafeMath for uint256;
181 
182     mapping (address => uint256) private _balances;
183 
184     mapping (address => mapping (address => uint256)) private _allowed;
185 
186     uint256 private _totalSupply;
187 
188     /**
189     * @dev Total number of tokens in existence
190     */
191     function totalSupply() public view returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196     * @dev Gets the balance of the specified address.
197     * @param owner The address to query the balance of.
198     * @return An uint256 representing the amount owned by the passed address.
199     */
200     function balanceOf(address owner) public view returns (uint256) {
201         return _balances[owner];
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param owner address The address which owns the funds.
207      * @param spender address The address which will spend the funds.
208      * @return A uint256 specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address owner, address spender) public view returns (uint256) {
211         return _allowed[owner][spender];
212     }
213 
214     /**
215     * @dev Transfer token for a specified address
216     * @param to The address to transfer to.
217     * @param value The amount to be transferred.
218     */
219     function transfer(address to, uint256 value) public returns (bool) {
220         _transfer(msg.sender, to, value);
221         return true;
222     }
223 
224     /**
225      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226      * Beware that changing an allowance with this method brings the risk that someone may use both the old
227      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
228      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
229      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
230      * @param spender The address which will spend the funds.
231      * @param value The amount of tokens to be spent.
232      */
233     function approve(address spender, uint256 value) public returns (bool) {
234         require(spender != address(0));
235 
236         _allowed[msg.sender][spender] = value;
237         emit Approval(msg.sender, spender, value);
238         return true;
239     }
240 
241     /**
242      * @dev Transfer tokens from one address to another.
243      * Note that while this function emits an Approval event, this is not required as per the specification,
244      * and other compliant implementations may not emit the event.
245      * @param from address The address which you want to send tokens from
246      * @param to address The address which you want to transfer to
247      * @param value uint256 the amount of tokens to be transferred
248      */
249     function transferFrom(address from, address to, uint256 value) public returns (bool) {
250         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
251         _transfer(from, to, value);
252         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
253         return true;
254     }
255 
256     /**
257      * @dev Increase the amount of tokens that an owner allowed to a spender.
258      * approve should be called when allowed_[_spender] == 0. To increment
259      * allowed value is better to use this function to avoid 2 calls (and wait until
260      * the first transaction is mined)
261      * From MonolithDAO Token.sol
262      * Emits an Approval event.
263      * @param spender The address which will spend the funds.
264      * @param addedValue The amount of tokens to increase the allowance by.
265      */
266     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
267         require(spender != address(0));
268 
269         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
270         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
271         return true;
272     }
273 
274     /**
275      * @dev Decrease the amount of tokens that an owner allowed to a spender.
276      * approve should be called when allowed_[_spender] == 0. To decrement
277      * allowed value is better to use this function to avoid 2 calls (and wait until
278      * the first transaction is mined)
279      * From MonolithDAO Token.sol
280      * Emits an Approval event.
281      * @param spender The address which will spend the funds.
282      * @param subtractedValue The amount of tokens to decrease the allowance by.
283      */
284     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
285         require(spender != address(0));
286 
287         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
288         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289         return true;
290     }
291 
292     /**
293     * @dev Transfer token for a specified addresses
294     * @param from The address to transfer from.
295     * @param to The address to transfer to.
296     * @param value The amount to be transferred.
297     */
298     function _transfer(address from, address to, uint256 value) internal {
299         require(to != address(0));
300 
301         _balances[from] = _balances[from].sub(value);
302         _balances[to] = _balances[to].add(value);
303         emit Transfer(from, to, value);
304     }
305 
306     /**
307      * @dev Internal function that mints an amount of the token and assigns it to
308      * an account. This encapsulates the modification of balances such that the
309      * proper events are emitted.
310      * @param account The account that will receive the created tokens.
311      * @param value The amount that will be created.
312      */
313     function _mint(address account, uint256 value) internal {
314         require(account != address(0));
315 
316         _totalSupply = _totalSupply.add(value);
317         _balances[account] = _balances[account].add(value);
318         emit Transfer(address(0), account, value);
319     }
320 
321     /**
322      * @dev Internal function that burns an amount of the token of a given
323      * account.
324      * @param account The account whose tokens will be burnt.
325      * @param value The amount that will be burnt.
326      */
327     function _burn(address account, uint256 value) internal {
328         require(account != address(0));
329 
330         _totalSupply = _totalSupply.sub(value);
331         _balances[account] = _balances[account].sub(value);
332         emit Transfer(account, address(0), value);
333     }
334 
335     /**
336      * @dev Internal function that burns an amount of the token of a given
337      * account, deducting from the sender's allowance for said account. Uses the
338      * internal burn function.
339      * Emits an Approval event (reflecting the reduced allowance).
340      * @param account The account whose tokens will be burnt.
341      * @param value The amount that will be burnt.
342      */
343     function _burnFrom(address account, uint256 value) internal {
344         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
345         _burn(account, value);
346         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
347     }
348 }
349 
350 /**
351  * @title ERC20Detailed token
352  * @dev The decimals are only for visualization purposes.
353  * All the operations are done using the smallest and indivisible token unit,
354  * just as on Ethereum all the operations are done in wei.
355  */
356 contract ERC20Detailed is ERC20 {
357     string private _name;
358     string private _symbol;
359     uint8 private _decimals;
360 
361     constructor (string name, string symbol, uint8 decimals) public {
362         _name = name;
363         _symbol = symbol;
364         _decimals = decimals;
365     }
366 
367     /**
368      * @return the name of the token.
369      */
370     function name() public view returns (string) {
371         return _name;
372     }
373 
374     /**
375      * @return the symbol of the token.
376      */
377     function symbol() public view returns (string) {
378         return _symbol;
379     }
380 
381     /**
382      * @return the number of decimals of the token.
383      */
384     function decimals() public view returns (uint8) {
385         return _decimals;
386     }
387 }
388 
389 
390 contract TokenRushToken is ERC20Detailed, AdminRole {
391     address public reserveTokensAddress;
392 
393     mapping(address => bool) public whitelisted;
394     mapping(address => bool) public blacklisted;
395     bool public tradingEnabled;
396 
397     constructor(address _reserveTokensAddress) public ERC20Detailed("TokenRush", "RUSH", 18) {
398         require(_reserveTokensAddress != address(0));
399 
400         reserveTokensAddress = _reserveTokensAddress;
401 
402         _mint(msg.sender, 100000000 * (10 ** uint256(decimals()))); // 100M airdrop tokens
403         _mint(reserveTokensAddress, 100000000 * (10 ** uint256(decimals()))); // 100M reserve tokens
404 
405         whitelisted[msg.sender] = true;
406     }
407 
408     function setWhitelisted(address _address, bool _whitelisted) public onlyAdmin {
409         whitelisted[_address] = _whitelisted;
410     }
411 
412     function setBlacklisted(address _address, bool _blacklisted) public onlyAdmin {
413         blacklisted[_address] = _blacklisted;
414     }
415 
416     function setTradingEnabled(bool _enabled) public onlyAdmin {
417         tradingEnabled = _enabled;
418     }
419 
420     function allowedTransfer(address _address) public view returns (bool) {
421         return whitelisted[_address] || (tradingEnabled && !blacklisted[_address]);
422     }
423 
424     function transfer(address to, uint256 value) public returns (bool) {
425         if(!allowedTransfer(msg.sender)) return false;
426         return super.transfer(to, value);
427     }
428 
429     function transferFrom(address from, address to, uint256 value) public returns (bool) {
430         if(!allowedTransfer(msg.sender) || !allowedTransfer(from)) return false;
431         return super.transferFrom(from, to, value);
432     }
433 
434     function transferBatch(address[] _recipients, uint256[] _amounts) external {
435         require(_recipients.length > 0);
436         require(_recipients.length == _amounts.length);
437 
438         for(uint8 i = 0; i < _recipients.length; i++) {
439             require(transfer(_recipients[i], _amounts[i]));
440         }
441     }
442 
443     /// @dev Admin-only function to recover any tokens mistakenly sent to this contract
444     function recoverERC20Tokens(address _contractAddress) onlyAdmin external {
445         IERC20 erc20Token = IERC20(_contractAddress);
446         if(erc20Token.balanceOf(address(this)) > 0) {
447             require(erc20Token.transfer(msg.sender, erc20Token.balanceOf(address(this))));
448         }
449     }
450 }
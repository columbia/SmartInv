1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5 
6     function balanceOf(address who) external view returns (uint256);
7 
8     function allowance(address owner, address spender) external view returns (uint256);
9 
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     event Transfer(
17         address indexed from,
18         address indexed to,
19         uint256 value
20     );
21 
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 }
28 
29 library SafeMath {
30 
31     /**
32      * @dev Multiplies two numbers, reverts on overflow.
33      */
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
49      * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50      */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b > 0); // Solidity only automatically asserts when dividing by 0
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60      * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Adds two numbers, reverts on overflow.
71      */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80      * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
81      * reverts when dividing by zero.
82      */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 library Roles {
90     struct Role {
91         mapping (address => bool) bearer;
92     }
93 
94     /**
95      * @dev give an account access to this role
96      */
97     function add(Role storage role, address account) internal {
98         require(account != address(0));
99         require(!has(role, account));
100 
101         role.bearer[account] = true;
102     }
103 
104     /**
105      * @dev remove an account's access to this role
106      */
107     function remove(Role storage role, address account) internal {
108         require(account != address(0));
109         require(has(role, account));
110 
111         role.bearer[account] = false;
112     }
113 
114     /**
115      * @dev check if an account has this role
116      * @return bool
117      */
118     function has(Role storage role, address account)
119         internal
120         view
121         returns (bool)
122     {
123         require(account != address(0));
124         return role.bearer[account];
125     }
126 }
127 
128 contract ERC20Detailed is IERC20 {
129     string private _name;
130     string private _symbol;
131     uint8 private _decimals;
132 
133     constructor(string name, string symbol, uint8 decimals) public {
134         _name = name;
135         _symbol = symbol;
136         _decimals = decimals;
137     }
138 
139     /**
140      * @return the name of the token.
141      */
142     function name() public view returns(string) {
143         return _name;
144     }
145 
146     /**
147       * @return the symbol of the token.
148       */
149     function symbol() public view returns(string) {
150         return _symbol;
151     }
152 
153     /**
154       * @return the number of decimals of the token.
155       */
156     function decimals() public view returns(uint8) {
157         return _decimals;
158     }
159 }
160 
161 contract ERC20 is IERC20 {
162     using SafeMath for uint256;
163 
164     mapping (address => uint256) private _balances;
165 
166     mapping (address => mapping (address => uint256)) private _allowed;
167 
168     uint256 private _totalSupply;
169 
170     /**
171      * @dev Total number of tokens in existence
172      */
173     function totalSupply() public view returns (uint256) {
174         return _totalSupply;
175     }
176 
177     /**
178      * @dev Gets the balance of the specified address.
179      * @param owner The address to query the balance of.
180      * @return An uint256 representing the amount owned by the passed address.
181      */
182     function balanceOf(address owner) public view returns (uint256) {
183         return _balances[owner];
184     }
185 
186     /**
187      * @dev Function to check the amount of tokens that an owner allowed to a spender.
188      * @param owner address The address which owns the funds.
189      * @param spender address The address which will spend the funds.
190      * @return A uint256 specifying the amount of tokens still available for the spender.
191      */
192     function allowance(
193         address owner,
194         address spender
195     )
196         public
197         view
198         returns (uint256)
199     {
200         return _allowed[owner][spender];
201     }
202 
203     /**
204      * @dev Transfer token for a specified address
205      * @param to The address to transfer to.
206      * @param value The amount to be transferred.
207      */
208     function transfer(address to, uint256 value) public returns (bool) {
209         _transfer(msg.sender, to, value);
210         return true;
211     }
212 
213     /**
214      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
215      * To prevent attack vectors like the one described in
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729,
217      * msg.sender must set the allowance first to 0 before setting it to another value for the same spender.
218      * This enforces token holders to call approve(spedner, 0) before call it again with positive integer value.
219      * @param spender The address which will spend the funds.
220      * @param value The amount of tokens to be spent.
221      */
222     function approve(address spender, uint256 value) public returns (bool) {
223         require(spender != address(0));
224         require(value == 0 || _allowed[msg.sender][spender] == 0);
225 
226         _allowed[msg.sender][spender] = value;
227         emit Approval(msg.sender, spender, value);
228         return true;
229     }
230 
231     /**
232      * @dev Transfer tokens from one address to another
233      * @param from address The address which you want to send tokens from
234      * @param to address The address which you want to transfer to
235      * @param value uint256 the amount of tokens to be transferred
236      */
237     function transferFrom(
238         address from,
239         address to,
240         uint256 value
241     )
242         public
243         returns (bool)
244     {
245         require(value <= _allowed[from][msg.sender]);
246 
247         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
248         _transfer(from, to, value);
249         return true;
250     }
251 
252     /**
253      * @dev Increase the amount of tokens that an owner allowed to a spender.
254      * approve should be called when allowed_[_spender] == 0. To increment
255      * allowed value is better to use this function to avoid 2 calls (and wait until
256      * the first transaction is mined)
257      * From MonolithDAO Token.sol
258      * @param spender The address which will spend the funds.
259      * @param addedValue The amount of tokens to increase the allowance by.
260      */
261     function increaseAllowance(
262         address spender,
263         uint256 addedValue
264     )
265         public
266         returns (bool)
267     {
268         require(spender != address(0));
269 
270         _allowed[msg.sender][spender] = (
271         _allowed[msg.sender][spender].add(addedValue));
272         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
273         return true;
274     }
275 
276     /**
277      * @dev Decrease the amount of tokens that an owner allowed to a spender.
278      * approve should be called when allowed_[_spender] == 0. To decrement
279      * allowed value is better to use this function to avoid 2 calls (and wait until
280      * the first transaction is mined)
281      * From MonolithDAO Token.sol
282      * @param spender The address which will spend the funds.
283      * @param subtractedValue The amount of tokens to decrease the allowance by.
284      */
285     function decreaseAllowance(
286         address spender,
287         uint256 subtractedValue
288     )
289         public
290         returns (bool)
291     {
292         require(spender != address(0));
293 
294         _allowed[msg.sender][spender] = (
295         _allowed[msg.sender][spender].sub(subtractedValue));
296         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
297         return true;
298     }
299 
300     /**
301      * @dev Transfer token for a specified addresses
302      * @param from The address to transfer from.
303      * @param to The address to transfer to.
304      * @param value The amount to be transferred.
305      */
306     function _transfer(address from, address to, uint256 value) internal {
307         require(value <= _balances[from]);
308         require(to != address(0));  // to burn tokens, must call 'burn' method instead.
309 
310         _balances[from] = _balances[from].sub(value);
311         _balances[to] = _balances[to].add(value);
312         emit Transfer(from, to, value);
313     }
314 
315     /**
316      * @dev Internal function that mints an amount of the token and assigns it to
317      * an account. This encapsulates the modification of balances such that the
318      * proper events are emitted.
319      * @param account The account that will receive the created tokens.
320      * @param value The amount that will be created.
321      */
322     function _mint(address account, uint256 value) internal {
323         require(account != address(0));
324 
325         _totalSupply = _totalSupply.add(value);
326         _balances[account] = _balances[account].add(value);
327         emit Transfer(address(0), account, value);
328     }
329 
330     /**
331      * @dev Internal function that burns an amount of the token of a given
332      * account.
333      * @param account The account whose tokens will be burnt.
334      * @param value The amount that will be burnt.
335      */
336     function _burn(address account, uint256 value) internal {
337         require(account != 0);
338         require(value <= _balances[account]);
339 
340         _totalSupply = _totalSupply.sub(value);
341         _balances[account] = _balances[account].sub(value);
342         emit Transfer(account, address(0), value);
343     }
344 
345     /**
346      * @dev Internal function that burns an amount of the token of a given
347      * account, deducting from the sender's allowance for said account. Uses the
348      * internal burn function.
349      * @param account The account whose tokens will be burnt.
350      * @param value The amount that will be burnt.
351      */
352     function _burnFrom(address account, uint256 value) internal {
353         require(value <= _allowed[account][msg.sender]);
354 
355         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
356         // this function needs to emit an event with the updated approval.
357         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
358         value);
359         _burn(account, value);
360     }
361 }
362 
363 contract BurnerRole {
364     using Roles for Roles.Role;
365 
366     event BurnerAdded(address indexed account);
367     event BurnerRemoved(address indexed account);
368 
369     Roles.Role private burners;
370 
371     constructor() internal {
372         _addBurner(msg.sender);
373     }
374 
375     modifier onlyBurner() {
376         require(isBurner(msg.sender));
377         _;
378     }
379 
380     function isBurner(address account) public view returns (bool) {
381         return burners.has(account);
382     }
383 
384     function addBurner(address account) public onlyBurner {
385         _addBurner(account);
386     }
387 
388     function renounceBurner() public {
389         _removeBurner(msg.sender);
390     }
391 
392     function _addBurner(address account) internal {
393         burners.add(account);
394         emit BurnerAdded(account);
395     }
396 
397     function _removeBurner(address account) internal {
398         burners.remove(account);
399         emit BurnerRemoved(account);
400     }
401 }
402 
403 contract ERC20Burnable is ERC20, BurnerRole {
404 
405     /**
406      * @dev Burns a specific amount of tokens of burner.
407      * @param value The amount of token to be burned.
408      */
409     function burn(uint256 value) public onlyBurner {
410         _burn(msg.sender, value);
411     }
412 
413     /**
414      * @dev Burns a specific amount of tokens from the target address and decrements allowance
415      * @param from address The address which you want to send tokens from
416      * @param value uint256 The amount of token to be burned
417      */
418     function burnFrom(address from, uint256 value) public onlyBurner {
419         _burnFrom(from, value);
420     }
421 }
422 
423 contract ApproveAndCallFallBack {
424     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
425 }
426 
427 
428 
429 contract BepickCoin is ERC20, ERC20Detailed, ERC20Burnable {
430     uint256 public constant INITIAL_SUPPLY = 10 * (10 ** 9);
431     constructor() public ERC20Detailed("BestPick Coin", "BPC", 18) {
432         _mint(msg.sender, INITIAL_SUPPLY * (10 ** uint256(decimals())));
433     }
434 
435     function () public payable {
436         revert();
437     }
438 
439     /**
440      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
441      * its behalf, and then a function is triggered in the contract that is
442      * being approved, `_spender`. This allows users to use their tokens to
443      * interact with contracts in one function call instead of two
444      * @param _spender The address of the contract able to transfer the tokens
445      * @param _amount The amount of tokens to be approved for transfer
446      * @return True if the function call was successful
447      */
448     function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
449         require(approve(_spender, _amount));
450 
451         ApproveAndCallFallBack(_spender).receiveApproval(
452             msg.sender,
453             _amount,
454             this,
455             _extraData
456         );
457 
458         return true;
459     }
460 }
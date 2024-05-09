1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 
5     address private _owner;
6     
7     event OwnershipRenounced(address indexed previousOwner);
8     event OwnershipTransferred(
9         address indexed previousOwner,
10         address indexed newOwner
11     );
12 
13     /**
14     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15     * account.
16     */
17     constructor() public {
18         _owner = msg.sender;
19     }
20 
21     /**
22     * @return the address of the owner.
23     */
24     function owner() public view returns(address) {
25         return _owner;
26     }
27 
28     /**
29     * @dev Throws if called by any account other than the owner.
30     */
31     modifier onlyOwner() {
32         require(isOwner());
33         _;
34     }
35 
36     /**
37     * @return true if `msg.sender` is the owner of the contract.
38     */
39     function isOwner() public view returns(bool) {
40         return msg.sender == _owner;
41     }
42 
43     /**
44     * @dev Allows the current owner to relinquish control of the contract.
45     * @notice Renouncing to ownership will leave the contract without an owner.
46     * It will not be possible to call the functions with the `onlyOwner`
47     * modifier anymore.
48     */
49     function renounceOwnership() public onlyOwner {
50         emit OwnershipRenounced(_owner);
51         _owner = address(0);
52     }
53 
54     /**
55     * @dev Allows the current owner to transfer control of the contract to a newOwner.
56     * @param newOwner The address to transfer ownership to.
57     */
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63     * @dev Transfers control of the contract to a newOwner.
64     * @param newOwner The address to transfer ownership to.
65     */
66     function _transferOwnership(address newOwner) internal {
67         require(newOwner != address(0));
68         emit OwnershipTransferred(_owner, newOwner);
69         _owner = newOwner;
70     }
71 }
72 
73 library SafeMath {
74 
75     /**
76     * @dev Multiplies two numbers, reverts on overflow.
77     */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b);
88 
89         return c;
90     }
91 
92     /**
93     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
94     */
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b > 0); // Solidity only automatically asserts when dividing by 0
97         uint256 c = a / b;
98         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99 
100         return c;
101     }
102 
103     /**
104     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105     */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         require(b <= a);
108         uint256 c = a - b;
109 
110         return c;
111     }
112 
113     /**
114     * @dev Adds two numbers, reverts on overflow.
115     */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a);
119 
120         return c;
121     }
122 
123     /**
124     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125     * reverts when dividing by zero.
126     */
127     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b != 0);
129         return a % b;
130     }
131 }
132 
133 interface IERC20 {
134 
135     function totalSupply() external view returns (uint256);
136 
137     function balanceOf(address who) external view returns (uint256);
138 
139     function allowance(address owner, address spender)
140         external view returns (uint256);
141 
142     function transfer(address to, uint256 value) external returns (bool);
143 
144     function approve(address spender, uint256 value)
145         external returns (bool);
146 
147     function transferFrom(address from, address to, uint256 value)
148         external returns (bool);
149 
150     event Transfer(
151         address indexed from,
152         address indexed to,
153         uint256 value
154     );
155 
156     event Approval(
157         address indexed owner,
158         address indexed spender,
159         uint256 value
160     );
161 }
162 
163 contract ERC20 is IERC20 {
164 
165     using SafeMath for uint256;
166 
167     mapping (address => uint256) private _balances;
168 
169     mapping (address => mapping (address => uint256)) private _allowed;
170 
171     uint256 private _totalSupply;
172 
173     /**
174     * @dev Total number of tokens in existence
175     */
176     function totalSupply() public view returns (uint256) {
177         return _totalSupply;
178     }
179 
180     /**
181     * @dev Gets the balance of the specified address.
182     * @param owner The address to query the balance of.
183     * @return An uint256 representing the amount owned by the passed address.
184     */
185     function balanceOf(address owner) public view returns (uint256) {
186         return _balances[owner];
187     }
188 
189     /**
190     * @dev Function to check the amount of tokens that an owner allowed to a spender.
191     * @param owner address The address which owns the funds.
192     * @param spender address The address which will spend the funds.
193     * @return A uint256 specifying the amount of tokens still available for the spender.
194     */
195     function allowance(
196         address owner,
197         address spender
198     )
199         public
200         view
201         returns (uint256)
202     {
203         return _allowed[owner][spender];
204     }
205 
206     /**
207     * @dev Transfer token for a specified address
208     * @param to The address to transfer to.
209     * @param value The amount to be transferred.
210     */
211     function transfer(address to, uint256 value) public returns (bool) {
212         require(value <= _balances[msg.sender]);
213         require(to != address(0));
214 
215         _balances[msg.sender] = _balances[msg.sender].sub(value);
216         _balances[to] = _balances[to].add(value);
217         emit Transfer(msg.sender, to, value);
218         return true;
219     }
220 
221     /**
222     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223     * Beware that changing an allowance with this method brings the risk that someone may use both the old
224     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227     * @param spender The address which will spend the funds.
228     * @param value The amount of tokens to be spent.
229     */
230     function approve(address spender, uint256 value) public returns (bool) {
231         require(spender != address(0));
232 
233         _allowed[msg.sender][spender] = value;
234         emit Approval(msg.sender, spender, value);
235         return true;
236     }
237 
238     /**
239     * @dev Transfer tokens from one address to another
240     * @param from address The address which you want to send tokens from
241     * @param to address The address which you want to transfer to
242     * @param value uint256 the amount of tokens to be transferred
243     */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 value
248     )
249         public
250         returns (bool)
251     {
252         require(value <= _balances[from]);
253         require(value <= _allowed[from][msg.sender]);
254         require(to != address(0));
255 
256         _balances[from] = _balances[from].sub(value);
257         _balances[to] = _balances[to].add(value);
258         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
259         emit Transfer(from, to, value);
260         return true;
261     }
262 
263     /**
264     * @dev Increase the amount of tokens that an owner allowed to a spender.
265     * approve should be called when allowed_[_spender] == 0. To increment
266     * allowed value is better to use this function to avoid 2 calls (and wait until
267     * the first transaction is mined)
268     * From MonolithDAO Token.sol
269     * @param spender The address which will spend the funds.
270     * @param addedValue The amount of tokens to increase the allowance by.
271     */
272     function increaseAllowance(
273         address spender,
274         uint256 addedValue
275     )
276         public
277         returns (bool)
278     {
279         require(spender != address(0));
280 
281         _allowed[msg.sender][spender] = (
282         _allowed[msg.sender][spender].add(addedValue));
283         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
284         return true;
285     }
286 
287     /**
288     * @dev Decrease the amount of tokens that an owner allowed to a spender.
289     * approve should be called when allowed_[_spender] == 0. To decrement
290     * allowed value is better to use this function to avoid 2 calls (and wait until
291     * the first transaction is mined)
292     * From MonolithDAO Token.sol
293     * @param spender The address which will spend the funds.
294     * @param subtractedValue The amount of tokens to decrease the allowance by.
295     */
296     function decreaseAllowance(
297         address spender,
298         uint256 subtractedValue
299     )
300         public
301         returns (bool)
302     {
303         require(spender != address(0));
304 
305         _allowed[msg.sender][spender] = (
306         _allowed[msg.sender][spender].sub(subtractedValue));
307         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
308         return true;
309     }
310 
311     /**
312     * @dev Internal function that mints an amount of the token and assigns it to
313     * an account. This encapsulates the modification of balances such that the
314     * proper events are emitted.
315     * @param account The account that will receive the created tokens.
316     * @param amount The amount that will be created.
317     */
318     function _mint(address account, uint256 amount) internal {
319         require(account != 0);
320         _totalSupply = _totalSupply.add(amount);
321         _balances[account] = _balances[account].add(amount);
322         emit Transfer(address(0), account, amount);
323     }
324 
325     /**
326     * @dev Internal function that burns an amount of the token of a given
327     * account.
328     * @param account The account whose tokens will be burnt.
329     * @param amount The amount that will be burnt.
330     */
331     function _burn(address account, uint256 amount) internal {
332         require(account != 0);
333         require(amount <= _balances[account]);
334 
335         _totalSupply = _totalSupply.sub(amount);
336         _balances[account] = _balances[account].sub(amount);
337         emit Transfer(account, address(0), amount);
338     }
339 
340     /**
341     * @dev Internal function that burns an amount of the token of a given
342     * account, deducting from the sender's allowance for said account. Uses the
343     * internal burn function.
344     * @param account The account whose tokens will be burnt.
345     * @param amount The amount that will be burnt.
346     */
347     function _burnFrom(address account, uint256 amount) internal {
348         require(amount <= _allowed[account][msg.sender]);
349 
350         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
351         // this function needs to emit an event with the updated approval.
352         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
353         amount);
354         _burn(account, amount);
355     }
356 }
357 
358 contract ERC20Burnable is ERC20 {
359 
360     /**
361     * @dev Burns a specific amount of tokens.
362     * @param value The amount of token to be burned.
363     */
364     function burn(uint256 value) public {
365         _burn(msg.sender, value);
366     }
367 
368     /**
369     * @dev Burns a specific amount of tokens from the target address and decrements allowance
370     * @param from address The address which you want to send tokens from
371     * @param value uint256 The amount of token to be burned
372     */
373     function burnFrom(address from, uint256 value) public {
374         _burnFrom(from, value);
375     }
376 
377     /**
378     * @dev Overrides ERC20._burn in order for burn and burnFrom to emit
379     * an additional Burn event.
380     */
381     function _burn(address who, uint256 value) internal {
382         super._burn(who, value);
383     }
384 }
385 
386 contract IFUM is Ownable, ERC20Burnable {
387 
388     string public name;
389     
390     string public symbol;
391     
392     uint8 public decimals;
393 
394     address private _crowdsale;
395 
396     bool private _freezed;
397 
398     mapping (address => bool) private _locked;
399     
400     constructor() public {
401         symbol = "IFUM";
402         name = "INFLEUM Token";
403         decimals = 8;
404         _crowdsale = address(0);
405         _freezed = true;
406     }
407 
408     function setCrowdsale(address crowdsale) public {
409         require(crowdsale != address(0), "Invalid address");
410         require(_crowdsale == address(0), "It is allowed only one time.");
411         _crowdsale = crowdsale;
412         _mint(crowdsale, 3000000000 * 10 ** uint(decimals));
413     }
414 
415     function isFreezed() public view returns (bool) {
416         return _freezed;
417     }
418 
419     function unfreeze() public {
420         require(msg.sender == _crowdsale, "Only crowdsale contract can unfreeze this token.");
421         _freezed = false;
422     }
423 
424     function isLocked(address account) public view returns (bool) {
425         return _locked[account];
426     }
427 
428     modifier test(address account) {
429         require(!isLocked(account), "It is a locked account.");
430         require(!_freezed || _crowdsale == account, "A token is frozen or not crowdsale contract executes this function.");
431         _;
432     }
433 
434     function lockAccount(address account) public onlyOwner {
435         require(!isLocked(account), "It is already a locked account.");
436         _locked[account] = true;
437         emit LockAccount(account);
438     }
439 
440     function unlockAccount(address account) public onlyOwner {
441         require(isLocked(account), "It is already a unlocked account.");
442         _locked[account] = false;
443         emit UnlockAccount(account);
444     }
445 
446     function transfer(address to, uint256 value) public test(msg.sender) returns (bool) {
447         return super.transfer(to, value);
448     }
449 
450     function approve(address spender, uint256 value) public test(msg.sender) returns (bool) {
451         return super.approve(spender, value);
452     }
453 
454     function transferFrom(address from, address to, uint256 value) public test(from) returns (bool) {
455         return super.transferFrom(from, to, value);
456     }
457 
458     function increaseAllowance(address spender, uint256 addedValue) public test(msg.sender) returns (bool) {
459         return super.increaseAllowance(spender, addedValue);
460     }
461 
462     function decreaseAllowance(address spender, uint256 subtractedValue) public test(msg.sender) returns (bool) {
463         return super.decreaseAllowance(spender, subtractedValue);
464     }
465 
466     function burn(uint256 value) public test(msg.sender) {
467         return super.burn(value);
468     }
469 
470     function burnFrom(address from, uint256 value) public test(from) {
471         return super.burnFrom(from, value);
472     }
473 
474     event LockAccount(address indexed account);
475 
476     event UnlockAccount(address indexed account);
477 }
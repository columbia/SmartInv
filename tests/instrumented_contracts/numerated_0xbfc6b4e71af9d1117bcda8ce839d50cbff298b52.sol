1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     /**
23      * @dev Multiplies two unsigned integers, reverts on overflow.
24      */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41      */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53      */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62      * @dev Adds two unsigned integers, reverts on overflow.
63      */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73      * reverts when dividing by zero.
74      */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 /**
82  * @title Roles
83  * @dev Library for managing addresses assigned to a Role.
84  */
85 library Roles {
86     struct Role {
87         mapping (address => bool) bearer;
88     }
89 
90     /**
91      * @dev Give an account access to this role.
92      */
93     function add(Role storage role, address account) internal {
94         require(account != address(0));
95         require(!has(role, account));
96 
97         role.bearer[account] = true;
98     }
99 
100     /**
101      * @dev Remove an account's access to this role.
102      */
103     function remove(Role storage role, address account) internal {
104         require(account != address(0));
105         require(has(role, account));
106 
107         role.bearer[account] = false;
108     }
109 
110     /**
111      * @dev Check if an account has this role.
112      * @return bool
113      */
114     function has(Role storage role, address account) internal view returns (bool) {
115         require(account != address(0));
116         return role.bearer[account];
117     }
118 }
119 
120 contract ERC20 is IERC20 {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) private _balances;
124 
125     mapping (address => mapping (address => uint256)) private _allowed;
126 
127     uint256 private _totalSupply;
128 
129     /**
130      * @dev Total number of tokens in existence.
131      */
132     function totalSupply() public view returns (uint256) {
133         return _totalSupply;
134     }
135 
136     /**
137      * @dev Gets the balance of the specified address.
138      * @param owner The address to query the balance of.
139      * @return A uint256 representing the amount owned by the passed address.
140      */
141     function balanceOf(address owner) public view returns (uint256) {
142         return _balances[owner];
143     }
144 
145     /**
146      * @dev Function to check the amount of tokens that an owner allowed to a spender.
147      * @param owner address The address which owns the funds.
148      * @param spender address The address which will spend the funds.
149      * @return A uint256 specifying the amount of tokens still available for the spender.
150      */
151     function allowance(address owner, address spender) public view returns (uint256) {
152         return _allowed[owner][spender];
153     }
154 
155     /**
156      * @dev Transfer token to a specified address.
157      * @param to The address to transfer to.
158      * @param value The amount to be transferred.
159      */
160     function transfer(address to, uint256 value) public returns (bool) {
161         _transfer(msg.sender, to, value);
162         return true;
163     }
164 
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      * Beware that changing an allowance with this method brings the risk that someone may use both the old
168      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      * @param spender The address which will spend the funds.
172      * @param value The amount of tokens to be spent.
173      */
174     function approve(address spender, uint256 value) public returns (bool) {
175         _approve(msg.sender, spender, value);
176         return true;
177     }
178 
179     /**
180      * @dev Transfer tokens from one address to another.
181      * Note that while this function emits an Approval event, this is not required as per the specification,
182      * and other compliant implementations may not emit the event.
183      * @param from address The address which you want to send tokens from
184      * @param to address The address which you want to transfer to
185      * @param value uint256 the amount of tokens to be transferred
186      */
187     function transferFrom(address from, address to, uint256 value) public returns (bool) {
188         _transfer(from, to, value);
189         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
190         return true;
191     }
192 
193     /**
194      * @dev Increase the amount of tokens that an owner allowed to a spender.
195      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
196      * allowed value is better to use this function to avoid 2 calls (and wait until
197      * the first transaction is mined)
198      * From MonolithDAO Token.sol
199      * Emits an Approval event.
200      * @param spender The address which will spend the funds.
201      * @param addedValue The amount of tokens to increase the allowance by.
202      */
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
220         return true;
221     }
222 
223     /**
224      * @dev Transfer token for a specified addresses.
225      * @param from The address to transfer from.
226      * @param to The address to transfer to.
227      * @param value The amount to be transferred.
228      */
229     function _transfer(address from, address to, uint256 value) internal {
230         require(to != address(0));
231 
232         _balances[from] = _balances[from].sub(value);
233         _balances[to] = _balances[to].add(value);
234         emit Transfer(from, to, value);
235     }
236 
237     /**
238      * @dev Internal function that mints an amount of the token and assigns it to
239      * an account. This encapsulates the modification of balances such that the
240      * proper events are emitted.
241      * @param account The account that will receive the created tokens.
242      * @param value The amount that will be created.
243      */
244     function _mint(address account, uint256 value) internal {
245         require(account != address(0));
246 
247         _totalSupply = _totalSupply.add(value);
248         _balances[account] = _balances[account].add(value);
249         emit Transfer(address(0), account, value);
250     }
251 
252     /**
253      * @dev Internal function that burns an amount of the token of a given
254      * account.
255      * @param account The account whose tokens will be burnt.
256      * @param value The amount that will be burnt.
257      */
258     function _burn(address account, uint256 value) internal {
259         require(account != address(0));
260 
261         _totalSupply = _totalSupply.sub(value);
262         _balances[account] = _balances[account].sub(value);
263         emit Transfer(account, address(0), value);
264     }
265 
266     /**
267      * @dev Approve an address to spend another addresses' tokens.
268      * @param owner The address that owns the tokens.
269      * @param spender The address that will spend the tokens.
270      * @param value The number of tokens that can be spent.
271      */
272     function _approve(address owner, address spender, uint256 value) internal {
273         require(spender != address(0));
274         require(owner != address(0));
275 
276         _allowed[owner][spender] = value;
277         emit Approval(owner, spender, value);
278     }
279 
280     /**
281      * @dev Internal function that burns an amount of the token of a given
282      * account, deducting from the sender's allowance for said account. Uses the
283      * internal burn function.
284      * Emits an Approval event (reflecting the reduced allowance).
285      * @param account The account whose tokens will be burnt.
286      * @param value The amount that will be burnt.
287      */
288     function _burnFrom(address account, uint256 value) internal {
289         _burn(account, value);
290         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
291     }
292 }
293 
294 
295 contract ERC20Burnable is ERC20 {
296     /**
297      * @dev Burns a specific amount of tokens.
298      * @param value The amount of token to be burned.
299      */
300     function burn(uint256 value) public {
301         _burn(msg.sender, value);
302     }
303 
304     /**
305      * @dev Burns a specific amount of tokens from the target address and decrements allowance.
306      * @param from address The account whose tokens will be burned.
307      * @param value uint256 The amount of token to be burned.
308      */
309     function burnFrom(address from, uint256 value) public {
310         _burnFrom(from, value);
311     }
312 }
313 
314 contract MinterRole {
315     using Roles for Roles.Role;
316 
317     event MinterAdded(address indexed account);
318     event MinterRemoved(address indexed account);
319 
320     Roles.Role private _minters;
321 
322     constructor () internal {
323         _addMinter(msg.sender);
324     }
325 
326     modifier onlyMinter() {
327         require(isMinter(msg.sender));
328         _;
329     }
330 
331     function isMinter(address account) public view returns (bool) {
332         return _minters.has(account);
333     }
334 
335     function addMinter(address account) public onlyMinter {
336         _addMinter(account);
337     }
338 
339     function renounceMinter() public {
340         _removeMinter(msg.sender);
341     }
342 
343     function _addMinter(address account) internal {
344         _minters.add(account);
345         emit MinterAdded(account);
346     }
347 
348     function _removeMinter(address account) internal {
349         _minters.remove(account);
350         emit MinterRemoved(account);
351     }
352 }
353 
354 contract ERC20Mintable is ERC20, MinterRole {
355     /**
356      * @dev Function to mint tokens
357      * @param to The address that will receive the minted tokens.
358      * @param value The amount of tokens to mint.
359      * @return A boolean that indicates if the operation was successful.
360      */
361 
362     uint256 public maxSupply;
363     uint256 public tokensMinted;
364 
365     constructor  (uint256 _maxSupply) public {
366         require(_maxSupply > 0);
367         maxSupply = _maxSupply;
368     }
369 
370     function mint(address to, uint256 value) public onlyMinter returns (bool) {
371         require(tokensMinted.add(value) <= maxSupply);
372         tokensMinted = tokensMinted.add(value);
373         _mint(to, value);
374         return true;
375     }
376 
377 }
378 
379 
380 contract TestToken is ERC20Burnable, ERC20Mintable {
381 
382     string public constant name = "TESSST";
383     string public constant symbol = "TESSST";
384     uint8 public constant decimals = 18;
385 
386     struct FreezeParams {
387         uint256 timestamp;
388         uint256 value;
389         bool subsequentUnlock;
390     }
391 
392     mapping (address => FreezeParams) private _freezed;
393 
394     constructor () public ERC20Mintable(5400000000 * 1e18) {
395     }
396 
397     function freezeOf(address owner) public view returns (uint256) {
398         if (_freezed[owner].timestamp <= now){
399             if (_freezed[owner].subsequentUnlock){
400                 uint256  monthsPassed;
401                 monthsPassed = now.sub(_freezed[owner].timestamp).div(30 days);
402                 if (monthsPassed >= 10)
403                 {
404                     return 0;
405                 }
406                 else
407                 {
408                     return _freezed[owner].value.mul(10-monthsPassed).div(10);
409                 }
410             }
411             else {
412                 return 0;
413             }
414         }
415         else
416         {
417             return _freezed[owner].value;
418         }
419     }
420 
421     function freezeFor(address owner) public view returns (uint256) {
422         return _freezed[owner].timestamp;
423     }
424 
425     function getAvailableBalance(address from) public view returns (uint256) {
426 
427         return balanceOf(from).sub(freezeOf(from));
428     }
429 
430     function mintWithFreeze(address _to, uint256 _value, uint256 _unfreezeTimestamp, bool _subsequentUnlock) public onlyMinter returns (bool) {
431         require(now < _unfreezeTimestamp);
432         _setHold(_to, _value, _unfreezeTimestamp, _subsequentUnlock);
433         mint(_to, _value);
434         return true;
435     }
436 
437     function _setHold(address to, uint256 value, uint256 unfreezeTimestamp, bool subsequentUnlock) private {
438         FreezeParams memory freezeData;
439         freezeData = _freezed[to];
440         // freeze timestamp is unchangable
441         if (freezeData.timestamp == 0) {
442             freezeData.timestamp = unfreezeTimestamp;
443             freezeData.subsequentUnlock = subsequentUnlock;
444         }
445         freezeData.value = freezeData.value.add(value);
446         _freezed[to] = freezeData;
447     }
448 
449     function transfer(address to, uint256 value) public returns (bool) {
450         require(getAvailableBalance(msg.sender) >= value);
451         return super.transfer(to, value);
452     }
453 
454     function transferFrom(address from, address to, uint256 value) public returns (bool) {
455         require(getAvailableBalance(from) >= value);
456         return super.transferFrom(from, to, value);
457     }
458 
459     function burn(uint256 value) public {
460         require(getAvailableBalance(msg.sender) >= value);
461         super.burn(value);
462     }
463 
464     function burnFrom(address from, uint256 value) public  {
465         require(getAvailableBalance(from) >= value);
466         super.burnFrom(from, value);
467     }
468 
469     function approveAndCall(address _spender, uint256 _value, string memory _extraData
470     ) public returns (bool success) {
471         approve(_spender, _value);
472 
473         // This portion is copied from ConsenSys's Standard Token Contract. It
474         //  calls the approvalFallback function that is part of the contract that
475         //  is being approved (`_spender`). The function should look like:
476         //  `approvalFallback(address _from, uint256 _value, address
477         //  _token, string memory _extraData)` It is assumed that the call
478         //  *should* succeed, otherwise the plain vanilla approve would be used
479         CallReceiver(_spender).approvalFallback(
480            msg.sender,
481            _value,
482            address(this),
483            _extraData
484         );
485         return true;
486     }
487 
488 }
489 
490 contract CallReceiver {
491     function approvalFallback(address _from, uint256 _value, address _token, string memory _extraData) public ;
492 }
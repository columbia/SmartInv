1 pragma solidity ^0.5.4;
2 
3 // File: contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/OwnAdminable.sol
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract OwnAdminable {
85     address private _owner;
86     address private _admin;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
92      * account.
93      */
94     constructor () internal {
95         _owner = msg.sender;
96         emit OwnershipTransferred(address(0), _owner);
97     }
98 
99     /**
100      * @return the address of the owner.
101      */
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     /**
107      * @return the address of the admin.
108      */
109     function admin() public view returns (address) {
110         return _admin;
111     }
112 
113     /**
114      * @dev Throws if called by any account other than the owner.
115      */
116     modifier onlyOwner() {
117         require(isOwner());
118         _;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwnerOrAdmin() {
125         require(isOwnerOrAdmin());
126         _;
127     }
128 
129     /**
130      * @return true if `msg.sender` is the owner of the contract.
131      */
132     function isOwner() public view returns (bool) {
133         return msg.sender == _owner;
134     }
135 
136     /**
137      * @return true if `msg.sender` is the owner or admin of the contract.
138      */
139     function isOwnerOrAdmin() public view returns (bool) {
140         return msg.sender == _owner || msg.sender == _admin;
141     }
142 
143     /**
144      * @dev Allows the current owner to relinquish control of the contract.
145      * It will not be possible to call the functions with the `onlyOwner`
146      * modifier anymore.
147      * @notice Renouncing ownership will leave the contract without an owner,
148      * thereby removing any functionality that is only available to the owner.
149      */
150     function renounceOwnership() public onlyOwner {
151         emit OwnershipTransferred(_owner, address(0));
152         _owner = address(0);
153     }
154 
155     /**
156      * @dev Allows the current owner to transfer control of the contract to a newOwner.
157      * @param newOwner The address to transfer ownership to.
158      */
159     function transferOwnership(address newOwner) public onlyOwner {
160         _transferOwnership(newOwner);
161     }
162 
163     function setAdmin(address newAdmin) public onlyOwner {
164         _admin = newAdmin;
165     }
166 
167     /**
168      * @dev Transfers control of the contract to a newOwner.
169      * @param newOwner The address to transfer ownership to.
170      */
171     function _transferOwnership(address newOwner) internal {
172         require(newOwner != address(0));
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 // File: contracts/Pausable.sol
179 
180 /**
181  * @title Pausable
182  * @dev Base contract which allows children to implement an emergency stop mechanism.
183  */
184 contract Pausable is OwnAdminable {
185     event Paused(address account);
186     event Unpaused(address account);
187 
188     bool private _paused;
189 
190     constructor () internal {
191         _paused = false;
192     }
193 
194     /**
195      * @return true if the contract is paused, false otherwise.
196      */
197     function paused() public view returns (bool) {
198         return _paused;
199     }
200 
201     /**
202      * @dev Modifier to make a function callable only when the contract is not paused.
203      */
204     modifier whenNotPaused() {
205         require(!_paused);
206         _;
207     }
208 
209     /**
210      * @dev Modifier to make a function callable only when the contract is paused.
211      */
212     modifier whenPaused() {
213         require(_paused);
214         _;
215     }
216 
217     /**
218      * @dev called by the owner to pause, triggers stopped state
219      */
220     function pause() public onlyOwner whenNotPaused {
221         _paused = true;
222         emit Paused(msg.sender);
223     }
224 
225     /**
226      * @dev called by the owner to unpause, returns to normal state
227      */
228     function unpause() public onlyOwner whenPaused {
229         _paused = false;
230         emit Unpaused(msg.sender);
231     }
232 }
233 
234 // File: contracts/NewcaterToken.sol
235 
236 /**
237  * Newcater builds optimized Blockchain infrastructure with application platforms, solutions for supporting swap, auction, payment, delivery and community connectivity.
238  * It is an ideal economic-technical environment for the community to join in application development, swap, knowledge and resource sharing.
239  * To create a circle of connections, support, sharing, shopping and income generation.
240  *
241  * Newcater develops and applies new technologies, especially Blockchain technology, in generating dApps, Smart contracts, and digital assets to apply in heritage digitization, copyright guarantee, auction, reward points, community fund management and cross-border transaction guarantee.
242  * To enable all of these activities to become more transparent, safe and secure.
243  *
244  * Newcater aims at promoting e-commerce and developing the local economy, helping businesses and merchants to take their products global.
245  * Boosting the trade freedom, narrowing the income gap, promoting the arts and creativity, and preserving traditional values in order to bring benefits to society, users, developers and contributors.
246  */
247 contract NewcaterToken is Ownable, Pausable {
248     string private _name;
249     string private _symbol;
250     uint8 private _decimals;
251 
252     mapping(address => uint256) private _balances;
253 
254     mapping(address => mapping(address => uint256)) private _allowed;
255 
256     uint256 private _totalSupply;
257 
258     uint256 private _cap;
259 
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     event Approval(address indexed owner, address indexed spender, uint256 value);
263 
264     constructor (string memory name, string memory symbol, uint8 decimals, uint256 cap) public {
265         require(cap > 0);
266         _name = name;
267         _symbol = symbol;
268         _decimals = decimals;
269         _cap = cap;
270     }
271 
272     /**
273      * @return the name of the token.
274      */
275     function name() public view returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @return the symbol of the token.
281      */
282     function symbol() public view returns (string memory) {
283         return _symbol;
284     }
285 
286     /**
287      * @return the number of decimals of the token.
288      */
289     function decimals() public view returns (uint8) {
290         return _decimals;
291     }
292 
293     /**
294      * @dev Total number of tokens in existence
295      */
296     function totalSupply() public view returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @return the cap for the token minting.
302      */
303     function cap() public view returns (uint256) {
304         return _cap;
305     }
306 
307     /**
308      * @dev Gets the balance of the specified address.
309      * @param owner The address to query the balance of.
310      * @return A uint256 representing the amount owned by the passed address.
311      */
312     function balanceOf(address owner) public view returns (uint256) {
313         return _balances[owner];
314     }
315 
316     /**
317      * @dev Function to check the amount of tokens that an owner allowed to a spender.
318      * @param owner address The address which owns the funds.
319      * @param spender address The address which will spend the funds.
320      * @return A uint256 specifying the amount of tokens still available for the spender.
321      */
322     function allowance(address owner, address spender) public view returns (uint256) {
323         return _allowed[owner][spender];
324     }
325 
326     /**
327      * @dev Transfer token to a specified address
328      * @param to The address to transfer to.
329      * @param value The amount to be transferred.
330      */
331     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
332         _transfer(msg.sender, to, value);
333         return true;
334     }
335 
336     /**
337      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
338      * Beware that changing an allowance with this method brings the risk that someone may use both the old
339      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
340      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
341      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
342      * @param spender The address which will spend the funds.
343      * @param value The amount of tokens to be spent.
344      */
345     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
346         _approve(msg.sender, spender, value);
347         return true;
348     }
349 
350     /**
351      * @dev Transfer tokens from one address to another.
352      * Note that while this function emits an Approval event, this is not required as per the specification,
353      * and other compliant implementations may not emit the event.
354      * @param from address The address which you want to send tokens from
355      * @param to address The address which you want to transfer to
356      * @param value uint256 the amount of tokens to be transferred
357      */
358     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
359         _transfer(from, to, value);
360         _approve(from, msg.sender, safeSub(_allowed[from][msg.sender], value));
361         return true;
362     }
363 
364     /**
365      * @dev Increase the amount of tokens that an owner allowed to a spender.
366      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
367      * allowed value is better to use this function to avoid 2 calls (and wait until
368      * the first transaction is mined)
369      * From MonolithDAO Token.sol
370      * Emits an Approval event.
371      * @param spender The address which will spend the funds.
372      * @param addedValue The amount of tokens to increase the allowance by.
373      */
374     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
375         _approve(msg.sender, spender, safeAdd(_allowed[msg.sender][spender], addedValue));
376         return true;
377     }
378 
379     /**
380      * @dev Decrease the amount of tokens that an owner allowed to a spender.
381      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
382      * allowed value is better to use this function to avoid 2 calls (and wait until
383      * the first transaction is mined)
384      * From MonolithDAO Token.sol
385      * Emits an Approval event.
386      * @param spender The address which will spend the funds.
387      * @param subtractedValue The amount of tokens to decrease the allowance by.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
390         _approve(msg.sender, spender, safeSub(_allowed[msg.sender][spender], subtractedValue));
391         return true;
392     }
393 
394     /**
395      * @dev Transfer token for a specified addresses
396      * @param from The address to transfer from.
397      * @param to The address to transfer to.
398      * @param value The amount to be transferred.
399      */
400     function _transfer(address from, address to, uint256 value) internal {
401         require(to != address(0));
402 
403         _balances[from] = safeSub(_balances[from], value);
404         _balances[to] = safeAdd(_balances[to], value);
405         emit Transfer(from, to, value);
406     }
407 
408     /**
409      * @dev Function to mint tokens
410      * @param to The address that will receive the minted tokens.
411      * @param value The amount of tokens to mint.
412      * @return A boolean that indicates if the operation was successful.
413      */
414     function mint(address to, uint256 value) public whenNotPaused onlyOwner returns (bool) {
415         _mint(to, value);
416         return true;
417     }
418 
419     /**
420      * @dev Internal function that mints an amount of the token and assigns it to
421      * an account. This encapsulates the modification of balances such that the
422      * proper events are emitted.
423      * @param account The account that will receive the created tokens.
424      * @param value The amount that will be created.
425      */
426     function _mint(address account, uint256 value) internal {
427         require(account != address(0));
428         require(safeAdd(totalSupply(), value) <= _cap);
429 
430         _totalSupply = safeAdd(_totalSupply, value);
431         _balances[account] = safeAdd(_balances[account], value);
432         emit Transfer(address(0), account, value);
433     }
434 
435     /**
436      * @dev Burns a specific amount of tokens.
437      * @param value The amount of token to be burned.
438      */
439     function burn(uint256 value) public {
440         _burn(msg.sender, value);
441     }
442 
443     /**
444      * @dev Burns a specific amount of tokens from the target address and decrements allowance
445      * @param from address The account whose tokens will be burned.
446      * @param value uint256 The amount of token to be burned.
447      */
448     function burnFrom(address from, uint256 value) public whenNotPaused {
449         _burnFrom(from, value);
450     }
451 
452     /**
453      * @dev Internal function that burns an amount of the token of a given
454      * account.
455      * @param account The account whose tokens will be burnt.
456      * @param value The amount that will be burnt.
457      */
458     function _burn(address account, uint256 value) internal {
459         require(account != address(0));
460 
461         _totalSupply = safeSub(_totalSupply, value);
462         _balances[account] = safeSub(_balances[account], value);
463         emit Transfer(account, address(0), value);
464     }
465 
466     /**
467      * @dev Approve an address to spend another addresses' tokens.
468      * @param owner The address that owns the tokens.
469      * @param spender The address that will spend the tokens.
470      * @param value The number of tokens that can be spent.
471      */
472     function _approve(address owner, address spender, uint256 value) internal {
473         require(spender != address(0));
474         require(owner != address(0));
475 
476         _allowed[owner][spender] = value;
477         emit Approval(owner, spender, value);
478     }
479 
480     /**
481      * @dev Internal function that burns an amount of the token of a given
482      * account, deducting from the sender's allowance for said account. Uses the
483      * internal burn function.
484      * Emits an Approval event (reflecting the reduced allowance).
485      * @param account The account whose tokens will be burnt.
486      * @param value The amount that will be burnt.
487      */
488     function _burnFrom(address account, uint256 value) internal {
489         _burn(account, value);
490         _approve(account, msg.sender, safeSub(_allowed[account][msg.sender], value));
491     }
492 
493     function safeSub(uint a, uint b) private pure returns (uint) {
494         assert(b <= a);
495         return a - b;
496     }
497 
498     function safeAdd(uint a, uint b) private pure returns (uint) {
499         uint c = a + b;
500         assert(c >= a && c >= b);
501         return c;
502     }
503 }
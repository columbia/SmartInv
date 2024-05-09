1 pragma solidity ^0.5.2;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/GustavoIbarra/Projects/Solidity/blockchain-asset-registry/contracts/vRC20.sol
6 // flattened :  Thursday, 11-Apr-19 23:33:19 UTC
7 interface IVersioned {
8     event AppendedData( string data, uint256 versionIndex );
9 
10     /*
11     * @dev fallback function
12     */
13     function() external;
14 
15     /**
16     * @dev Appends data to a string[] list
17     * @param _data any string. Could be an IPFS hash
18     */
19     function appendData(string calldata _data) external returns (bool);
20 
21     /**
22     * @dev Gets the current index of the data list
23     */
24     function getVersionIndex() external view returns (uint count);
25 }
26 
27 interface IERC20 {
28     function transfer(address to, uint256 value) external returns (bool);
29 
30     function approve(address spender, uint256 value) external returns (bool);
31 
32     function transferFrom(address from, address to, uint256 value) external returns (bool);
33 
34     function totalSupply() external view returns (uint256);
35 
36     function balanceOf(address who) external view returns (uint256);
37 
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 library SafeMath {
46     /**
47      * @dev Multiplies two unsigned integers, reverts on overflow.
48      */
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51         // benefit is lost if 'b' is also tested.
52         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b);
59 
60         return c;
61     }
62 
63     /**
64      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
65      */
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         // Solidity only automatically asserts when dividing by 0
68         require(b > 0);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     /**
76      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
77      */
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b <= a);
80         uint256 c = a - b;
81 
82         return c;
83     }
84 
85     /**
86      * @dev Adds two unsigned integers, reverts on overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         uint256 c = a + b;
90         require(c >= a);
91 
92         return c;
93     }
94 
95     /**
96      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
97      * reverts when dividing by zero.
98      */
99     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b != 0);
101         return a % b;
102     }
103 }
104 
105 contract Ownable {
106 
107     /**
108     * @dev The current owner of the contract
109     */
110     address payable private _owner;
111     
112     /**
113     * @dev A list of the contract owners
114     */
115     address[] private _owners;
116 
117     /**
118     * @dev The pending owner. 
119     * The current owner must have transferred the contract to this address
120     * The pending owner must claim the ownership
121     */
122     address payable private _pendingOwner;
123 
124     /**
125     * @dev A list of addresses that are allowed to transfer 
126     * the contract ownership on behalf of the current owner
127     */
128     mapping (address => mapping (address => bool)) internal allowed;
129 
130     event PendingTransfer( address indexed owner, address indexed pendingOwner );
131     event OwnershipTransferred( address indexed previousOwner, address indexed newOwner );
132     event Approval( address indexed owner, address indexed trustee );
133     event RemovedApproval( address indexed owner, address indexed trustee );
134 
135     /**
136     * @dev Modifier throws if called by any account other than the pendingOwner.
137     */
138     modifier onlyPendingOwner {
139         require(isPendingOwner());
140         _;
141     }
142 
143     /**
144     * @dev Throws if called by any account other than the owner.
145     */
146     modifier onlyOwner() {
147         require(isOwner());
148         _;
149     }
150 
151     /**
152     * @dev The Asset constructor sets the original `owner` 
153     * of the contract to the sender account.
154     */
155     constructor() public {
156         _owner = msg.sender;
157         _owners.push(_owner);
158         emit OwnershipTransferred(address(0), _owner);
159     }
160 
161     /*
162     * @dev fallback function
163     */
164     function() external {}
165 
166     /**
167      * @return the set asset owner
168      */
169     function owner() public view returns (address payable) {
170         return _owner;
171     }
172     
173     /**
174      * @return the set asset owner
175      */
176     function owners() public view returns (address[] memory) {
177         return _owners;
178     }
179     
180     /**
181      * @return the set asset pendingOwner
182      */
183     function pendingOwner() public view returns (address) {
184         return _pendingOwner;
185     }
186 
187     /**
188      * @return true if `msg.sender` is the owner of the contract.
189      */
190     function isOwner() public view returns (bool) {
191         return msg.sender == _owner;
192     }
193     
194     /**
195      * @return true if `msg.sender` is the owner of the contract.
196      */
197     function isPendingOwner() public view returns (bool) {
198         return msg.sender == _pendingOwner;
199     }
200 
201     /**
202     * @dev Allows the current owner to set the pendingOwner address.
203     * @param pendingOwner_ The address to transfer ownership to.
204     */
205     function transferOwnership(address payable pendingOwner_) onlyOwner public {
206         _pendingOwner = pendingOwner_;
207         emit PendingTransfer(_owner, _pendingOwner);
208     }
209 
210 
211     /**
212     * @dev Allows an approved trustee to set the pendingOwner address.
213     * @param pendingOwner_ The address to transfer ownership to.
214     */
215     function transferOwnershipFrom(address payable pendingOwner_) public {
216         require(allowance(msg.sender));
217         _pendingOwner = pendingOwner_;
218         emit PendingTransfer(_owner, _pendingOwner);
219     }
220 
221     /**
222     * @dev Allows the pendingOwner address to finalize the transfer.
223     */
224     function claimOwnership() onlyPendingOwner public {
225         _owner = _pendingOwner;
226         _owners.push(_owner);
227         _pendingOwner = address(0);
228         emit OwnershipTransferred(_owner, _pendingOwner);
229     }
230 
231     /**
232     * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
233     * @param trustee The address which will spend the funds.
234     */
235     function approve(address trustee) onlyOwner public returns (bool) {
236         allowed[msg.sender][trustee] = true;
237         emit Approval(msg.sender, trustee);
238         return true;
239     }
240 
241     /**
242     * @dev Approve the passed address to transfer the Asset on behalf of msg.sender.
243     * @param trustee The address which will spend the funds.
244     */
245     function removeApproval(address trustee) onlyOwner public returns (bool) {
246         allowed[msg.sender][trustee] = false;
247         emit RemovedApproval(msg.sender, trustee);
248         return true;
249     }
250 
251     /**
252     * @dev Function to check if a trustee is allowed to transfer on behalf the owner
253     * @param trustee address The address which will spend the funds.
254     * @return A bool specifying if the trustee can still transfer the Asset
255     */
256     function allowance(address trustee) public view returns (bool) {
257         return allowed[_owner][trustee];
258     }
259 }
260 
261 contract ERC20 is IERC20 {
262     using SafeMath for uint256;
263 
264     mapping (address => uint256) private _balances;
265 
266     mapping (address => mapping (address => uint256)) private _allowed;
267 
268     uint256 private _totalSupply;
269 
270     /**
271      * @dev Total number of tokens in existence
272      */
273     function totalSupply() public view returns (uint256) {
274         return _totalSupply;
275     }
276 
277     /**
278      * @dev Gets the balance of the specified address.
279      * @param owner The address to query the balance of.
280      * @return A uint256 representing the amount owned by the passed address.
281      */
282     function balanceOf(address owner) public view returns (uint256) {
283         return _balances[owner];
284     }
285 
286     /**
287      * @dev Function to check the amount of tokens that an owner allowed to a spender.
288      * @param owner address The address which owns the funds.
289      * @param spender address The address which will spend the funds.
290      * @return A uint256 specifying the amount of tokens still available for the spender.
291      */
292     function allowance(address owner, address spender) public view returns (uint256) {
293         return _allowed[owner][spender];
294     }
295 
296     /**
297      * @dev Transfer token to a specified address
298      * @param to The address to transfer to.
299      * @param value The amount to be transferred.
300      */
301     function transfer(address to, uint256 value) public returns (bool) {
302         _transfer(msg.sender, to, value);
303         return true;
304     }
305 
306     /**
307      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
308      * Beware that changing an allowance with this method brings the risk that someone may use both the old
309      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
310      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
311      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312      * @param spender The address which will spend the funds.
313      * @param value The amount of tokens to be spent.
314      */
315     function approve(address spender, uint256 value) public returns (bool) {
316         _approve(msg.sender, spender, value);
317         return true;
318     }
319 
320     /**
321      * @dev Transfer tokens from one address to another.
322      * Note that while this function emits an Approval event, this is not required as per the specification,
323      * and other compliant implementations may not emit the event.
324      * @param from address The address which you want to send tokens from
325      * @param to address The address which you want to transfer to
326      * @param value uint256 the amount of tokens to be transferred
327      */
328     function transferFrom(address from, address to, uint256 value) public returns (bool) {
329         _transfer(from, to, value);
330         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
331         return true;
332     }
333 
334     /**
335      * @dev Increase the amount of tokens that an owner allowed to a spender.
336      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
337      * allowed value is better to use this function to avoid 2 calls (and wait until
338      * the first transaction is mined)
339      * From MonolithDAO Token.sol
340      * Emits an Approval event.
341      * @param spender The address which will spend the funds.
342      * @param addedValue The amount of tokens to increase the allowance by.
343      */
344     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
345         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
346         return true;
347     }
348 
349     /**
350      * @dev Decrease the amount of tokens that an owner allowed to a spender.
351      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
352      * allowed value is better to use this function to avoid 2 calls (and wait until
353      * the first transaction is mined)
354      * From MonolithDAO Token.sol
355      * Emits an Approval event.
356      * @param spender The address which will spend the funds.
357      * @param subtractedValue The amount of tokens to decrease the allowance by.
358      */
359     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
360         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
361         return true;
362     }
363 
364     /**
365      * @dev Transfer token for a specified addresses
366      * @param from The address to transfer from.
367      * @param to The address to transfer to.
368      * @param value The amount to be transferred.
369      */
370     function _transfer(address from, address to, uint256 value) internal {
371         require(to != address(0));
372 
373         _balances[from] = _balances[from].sub(value);
374         _balances[to] = _balances[to].add(value);
375         emit Transfer(from, to, value);
376     }
377 
378     /**
379      * @dev Internal function that mints an amount of the token and assigns it to
380      * an account. This encapsulates the modification of balances such that the
381      * proper events are emitted.
382      * @param account The account that will receive the created tokens.
383      * @param value The amount that will be created.
384      */
385     function _mint(address account, uint256 value) internal {
386         require(account != address(0));
387 
388         _totalSupply = _totalSupply.add(value);
389         _balances[account] = _balances[account].add(value);
390         emit Transfer(address(0), account, value);
391     }
392 
393     /**
394      * @dev Internal function that burns an amount of the token of a given
395      * account.
396      * @param account The account whose tokens will be burnt.
397      * @param value The amount that will be burnt.
398      */
399     function _burn(address account, uint256 value) internal {
400         require(account != address(0));
401 
402         _totalSupply = _totalSupply.sub(value);
403         _balances[account] = _balances[account].sub(value);
404         emit Transfer(account, address(0), value);
405     }
406 
407     /**
408      * @dev Approve an address to spend another addresses' tokens.
409      * @param owner The address that owns the tokens.
410      * @param spender The address that will spend the tokens.
411      * @param value The number of tokens that can be spent.
412      */
413     function _approve(address owner, address spender, uint256 value) internal {
414         require(spender != address(0));
415         require(owner != address(0));
416 
417         _allowed[owner][spender] = value;
418         emit Approval(owner, spender, value);
419     }
420 
421     /**
422      * @dev Internal function that burns an amount of the token of a given
423      * account, deducting from the sender's allowance for said account. Uses the
424      * internal burn function.
425      * Emits an Approval event (reflecting the reduced allowance).
426      * @param account The account whose tokens will be burnt.
427      * @param value The amount that will be burnt.
428      */
429     function _burnFrom(address account, uint256 value) internal {
430         _burn(account, value);
431         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
432     }
433 }
434 
435 contract ERC20Detailed is IERC20 {
436     string private _name;
437     string private _symbol;
438     uint8 private _decimals;
439 
440     constructor (string memory name, string memory symbol, uint8 decimals) public {
441         _name = name;
442         _symbol = symbol;
443         _decimals = decimals;
444     }
445 
446     /**
447      * @return the name of the token.
448      */
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     /**
454      * @return the symbol of the token.
455      */
456     function symbol() public view returns (string memory) {
457         return _symbol;
458     }
459 
460     /**
461      * @return the number of decimals of the token.
462      */
463     function decimals() public view returns (uint8) {
464         return _decimals;
465     }
466 }
467 
468 contract Versioned is IVersioned {
469 
470     string[] public data;
471     
472     event AppendedData( 
473         string data, 
474         uint256 versionIndex
475     );
476 
477     /*
478     * @dev fallback function
479     */
480     function() external {}
481 
482     /**
483     * @dev Add data to the _data array
484     * @param _data string data
485     */
486     function appendData(string memory _data) public returns (bool) {
487         return _appendData(_data);
488     }
489     
490     /**
491     * @dev Add data to the _data array
492     * @param _data string data
493     */
494     function _appendData(string memory _data) internal returns (bool) {
495         data.push(_data);
496         emit AppendedData(_data, getVersionIndex());
497         return true;
498     }
499 
500     /**
501     * @dev Gets the current index of the data list
502     */
503     function getVersionIndex() public view returns (uint count) {
504         return data.length - 1;
505     }
506 }
507 
508 contract vRC20 is ERC20, ERC20Detailed, Versioned, Ownable {
509 
510     constructor (
511         uint256 supply,
512         string memory name,
513         string memory symbol,
514         uint8 decimals
515     ) public ERC20Detailed (name, symbol, decimals) {
516         _mint(msg.sender, supply);
517     }
518 
519     /**
520     * @dev Add data to the _data array
521     * @param _data string data
522     */
523     function appendData(string memory _data) public onlyOwner returns (bool) {
524         return _appendData(_data);
525     }
526 }
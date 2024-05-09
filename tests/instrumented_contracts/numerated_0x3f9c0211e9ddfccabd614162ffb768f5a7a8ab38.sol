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
24 
25 
26 
27 pragma solidity ^0.5.2;
28 
29 /**
30  * @title SafeMath
31  * @dev Unsigned math operations with safety checks that revert on error
32  */
33 library SafeMath {
34     /**
35      * @dev Multiplies two unsigned integers, reverts on overflow.
36      */
37     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
39         // benefit is lost if 'b' is also tested.
40         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b);
47 
48         return c;
49     }
50 
51     /**
52      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
53      */
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         // Solidity only automatically asserts when dividing by 0
56         require(b > 0);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     /**
64      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b <= a);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Adds two unsigned integers, reverts on overflow.
75      */
76     function add(uint256 a, uint256 b) internal pure returns (uint256) {
77         uint256 c = a + b;
78         require(c >= a);
79 
80         return c;
81     }
82 
83     /**
84      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
85      * reverts when dividing by zero.
86      */
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0);
89         return a % b;
90     }
91 }
92 
93 
94 
95 pragma solidity ^0.5.2;
96 
97 
98 
99 /**
100  * @title Standard ERC20 token
101  *
102  * @dev Implementation of the basic standard token.
103  * https://eips.ethereum.org/EIPS/eip-20
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
121      * @dev Total number of tokens in existence
122      */
123     function totalSupply() public view returns (uint256) {
124         return _totalSupply;
125     }
126 
127     /**
128      * @dev Gets the balance of the specified address.
129      * @param owner The address to query the balance of.
130      * @return A uint256 representing the amount owned by the passed address.
131      */
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
147      * @dev Transfer token to a specified address
148      * @param to The address to transfer to.
149      * @param value The amount to be transferred.
150      */
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
166         _approve(msg.sender, spender, value);
167         return true;
168     }
169 
170     /**
171      * @dev Transfer tokens from one address to another.
172      * Note that while this function emits an Approval event, this is not required as per the specification,
173      * and other compliant implementations may not emit the event.
174      * @param from address The address which you want to send tokens from
175      * @param to address The address which you want to transfer to
176      * @param value uint256 the amount of tokens to be transferred
177      */
178     function transferFrom(address from, address to, uint256 value) public returns (bool) {
179         _transfer(from, to, value);
180         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
181         return true;
182     }
183 
184     /**
185      * @dev Increase the amount of tokens that an owner allowed to a spender.
186      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
187      * allowed value is better to use this function to avoid 2 calls (and wait until
188      * the first transaction is mined)
189      * From MonolithDAO Token.sol
190      * Emits an Approval event.
191      * @param spender The address which will spend the funds.
192      * @param addedValue The amount of tokens to increase the allowance by.
193      */
194     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
195         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
196         return true;
197     }
198 
199     /**
200      * @dev Decrease the amount of tokens that an owner allowed to a spender.
201      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
202      * allowed value is better to use this function to avoid 2 calls (and wait until
203      * the first transaction is mined)
204      * From MonolithDAO Token.sol
205      * Emits an Approval event.
206      * @param spender The address which will spend the funds.
207      * @param subtractedValue The amount of tokens to decrease the allowance by.
208      */
209     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
211         return true;
212     }
213 
214     /**
215      * @dev Transfer token for a specified addresses
216      * @param from The address to transfer from.
217      * @param to The address to transfer to.
218      * @param value The amount to be transferred.
219      */
220     function _transfer(address from, address to, uint256 value) internal {
221         require(to != address(0));
222 
223         _balances[from] = _balances[from].sub(value);
224         _balances[to] = _balances[to].add(value);
225         emit Transfer(from, to, value);
226     }
227 
228     /**
229      * @dev Internal function that mints an amount of the token and assigns it to
230      * an account. This encapsulates the modification of balances such that the
231      * proper events are emitted.
232      * @param account The account that will receive the created tokens.
233      * @param value The amount that will be created.
234      */
235     function _mint(address account, uint256 value) internal {
236         require(account != address(0));
237 
238         _totalSupply = _totalSupply.add(value);
239         _balances[account] = _balances[account].add(value);
240         emit Transfer(address(0), account, value);
241     }
242 
243     /**
244      * @dev Internal function that burns an amount of the token of a given
245      * account.
246      * @param account The account whose tokens will be burnt.
247      * @param value The amount that will be burnt.
248      */
249     function _burn(address account, uint256 value) internal {
250         require(account != address(0));
251 
252         _totalSupply = _totalSupply.sub(value);
253         _balances[account] = _balances[account].sub(value);
254         emit Transfer(account, address(0), value);
255     }
256 
257     /**
258      * @dev Approve an address to spend another addresses' tokens.
259      * @param owner The address that owns the tokens.
260      * @param spender The address that will spend the tokens.
261      * @param value The number of tokens that can be spent.
262      */
263     function _approve(address owner, address spender, uint256 value) internal {
264         require(spender != address(0));
265         require(owner != address(0));
266 
267         _allowed[owner][spender] = value;
268         emit Approval(owner, spender, value);
269     }
270 
271     /**
272      * @dev Internal function that burns an amount of the token of a given
273      * account, deducting from the sender's allowance for said account. Uses the
274      * internal burn function.
275      * Emits an Approval event (reflecting the reduced allowance).
276      * @param account The account whose tokens will be burnt.
277      * @param value The amount that will be burnt.
278      */
279     function _burnFrom(address account, uint256 value) internal {
280         _burn(account, value);
281         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
282     }
283 }
284 
285 
286 
287 pragma solidity ^0.5.2;
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295     address private _owner;
296 
297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
298 
299     /**
300      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301      * account.
302      */
303     constructor () internal {
304         _owner = msg.sender;
305         emit OwnershipTransferred(address(0), _owner);
306     }
307 
308     /**
309      * @return the address of the owner.
310      */
311     function owner() public view returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(isOwner());
320         _;
321     }
322 
323     /**
324      * @return true if `msg.sender` is the owner of the contract.
325      */
326     function isOwner() public view returns (bool) {
327         return msg.sender == _owner;
328     }
329 
330     /**
331      * @dev Allows the current owner to relinquish control of the contract.
332      * It will not be possible to call the functions with the `onlyOwner`
333      * modifier anymore.
334      * @notice Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public onlyOwner {
338         emit OwnershipTransferred(_owner, address(0));
339         _owner = address(0);
340     }
341 
342     /**
343      * @dev Allows the current owner to transfer control of the contract to a newOwner.
344      * @param newOwner The address to transfer ownership to.
345      */
346     function transferOwnership(address newOwner) public onlyOwner {
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers control of the contract to a newOwner.
352      * @param newOwner The address to transfer ownership to.
353      */
354     function _transferOwnership(address newOwner) internal {
355         require(newOwner != address(0));
356         emit OwnershipTransferred(_owner, newOwner);
357         _owner = newOwner;
358     }
359 }
360 
361 
362 
363 pragma solidity ^0.5.2;
364 
365 
366 /**
367  * @title Protected token
368  * @dev Does not accept Ethereum and prohibits transfer of token to the contract address.
369  */
370 contract ERC20Protected is ERC20 {
371     function () payable external {
372         revert();
373     }
374 
375     function transfer(address to, uint256 value) public returns (bool) {
376         require (to != address(this));
377         return super.transfer(to, value);
378     }
379 
380     function transferFrom(address from, address to, uint256 value) public returns (bool) {
381         require (to != address(this));
382         return super.transferFrom(from, to, value);
383     }
384 }
385 
386 
387 
388 pragma solidity ^0.5.2;
389 
390 
391 
392 /**
393  * @title ERC20DetailedChangeable token
394  * @dev Name and symbol can be changed later.
395  */
396 contract ERC20DetailedChangeable is ERC20, Ownable {
397     string private _name;
398     string private _symbol;
399     uint8 private _decimals;
400 
401     event NameChanged(string oldName, string newName, address changer);
402     event SymbolChanged(string oldSymbol, string newSymbol, address changer);
403 
404     constructor (string memory name, string memory symbol, uint8 decimals) public {
405         _name = name;
406         _symbol = symbol;
407         _decimals = decimals;
408     }
409 
410     /**
411      * @return the name of the token.
412      */
413     function name() public view returns (string memory) {
414         return _name;
415     }
416 
417     /**
418      * @return the symbol of the token.
419      */
420     function symbol() public view returns (string memory) {
421         return _symbol;
422     }
423 
424     /**
425      * @return the number of decimals of the token.
426      */
427     function decimals() public view returns (uint8) {
428         return _decimals;
429     }
430 
431     function setName(string memory newName) public onlyOwner {
432         emit NameChanged(_name, newName, msg.sender);
433         _name = newName;
434     }
435 
436     function setSymbol(string memory newSymbol) public onlyOwner {
437         emit SymbolChanged(_symbol, newSymbol, msg.sender);
438         _symbol = newSymbol;
439     }
440 }
441 
442 
443 
444 pragma solidity ^0.5.2;
445 
446 
447 
448 
449 
450 contract ISF is ERC20, Ownable, ERC20DetailedChangeable, ERC20Protected {
451     uint8 public constant DECIMALS = 18;
452     uint256 public constant INITIAL_SUPPLY = 40000000000 * (10 ** uint256(DECIMALS));
453 
454     constructor () public ERC20DetailedChangeable("SusNova", "ISF", DECIMALS) {
455         _mint(msg.sender, INITIAL_SUPPLY);
456     }
457 
458     function renounceOwnership() public onlyOwner {
459         revert();
460     } 
461 
462 }
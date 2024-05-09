1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80      * account.
81      */
82     constructor () internal {
83         _owner = msg.sender;
84         emit OwnershipTransferred(address(0), _owner);
85     }
86 
87     /**
88      * @return the address of the owner.
89      */
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * @dev Throws if called by any account other than the owner.
96      */
97     modifier onlyOwner() {
98         require(isOwner());
99         _;
100     }
101 
102     /**
103      * @return true if `msg.sender` is the owner of the contract.
104      */
105     function isOwner() public view returns (bool) {
106         return msg.sender == _owner;
107     }
108 
109     /**
110      * @dev Allows the current owner to relinquish control of the contract.
111      * It will not be possible to call the functions with the `onlyOwner`
112      * modifier anymore.
113      * @notice Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public onlyOwner {
117         emit OwnershipTransferred(_owner, address(0));
118         _owner = address(0);
119     }
120 
121     /**
122      * @dev Allows the current owner to transfer control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function transferOwnership(address newOwner) public onlyOwner {
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers control of the contract to a newOwner.
131      * @param newOwner The address to transfer ownership to.
132      */
133     function _transferOwnership(address newOwner) internal {
134         require(newOwner != address(0));
135         emit OwnershipTransferred(_owner, newOwner);
136         _owner = newOwner;
137     }
138 }
139 
140 /**
141  * @title ERC20 interface
142  * @dev see https://eips.ethereum.org/EIPS/eip-20
143  */
144 interface IERC20 {
145     function transfer(address to, uint256 value) external returns (bool);
146 
147     function approve(address spender, uint256 value) external returns (bool);
148 
149     function transferFrom(address from, address to, uint256 value) external returns (bool);
150 
151     function totalSupply() external view returns (uint256);
152 
153     function balanceOf(address who) external view returns (uint256);
154 
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * https://eips.ethereum.org/EIPS/eip-20
167  * Originally based on code by FirstBlood:
168  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
169  *
170  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
171  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
172  * compliant implementations may not do it.
173  */
174 contract ERC20 is IERC20, Ownable {
175     using SafeMath for uint256;
176 
177     mapping (address => uint256) private _balances;
178 
179     // allowedAddresses will be able to transfer even when locked
180     // lockedAddresses will *not* be able to transfer even when *not locked*
181     mapping(address => bool) public allowedAddresses;
182     mapping(address => bool) public lockedAddresses;
183     bool public locked = false;
184 
185     function allowAddress(address _addr, bool _allowed) public onlyOwner {
186         require(_addr != owner());
187         allowedAddresses[_addr] = _allowed;
188     }
189 
190     function lockAddress(address _addr, bool _locked) public onlyOwner {
191         require(_addr != owner());
192         lockedAddresses[_addr] = _locked;
193     }
194 
195     function setLocked(bool _locked) public onlyOwner {
196         locked = _locked;
197     }
198 
199     function canTransfer(address _addr) public view returns (bool) {
200         if (locked) {
201           if(!allowedAddresses[_addr] &&_addr != owner()) return false;
202         } else if (lockedAddresses[_addr]) return false;
203 
204         return true;
205     }
206 
207 
208     // dividends feature
209 
210     uint pointMultiplier = 1e18;
211     mapping (address => uint) lastDivPoints;
212     uint totalDivPoints = 0;
213 
214     event DividendsTransferred(address account, uint amount);
215     event DividendsAdded(uint amount);
216 
217     function divsOwing(address _addr) public view returns (uint) {
218       uint newDivPoints = totalDivPoints.sub(lastDivPoints[_addr]);
219       return _balances[_addr].mul(newDivPoints).div(pointMultiplier);
220     }
221 
222     function updateAccount(address account) internal {
223       uint owing = divsOwing(account);
224       if (owing > 0) {
225         account.transfer(owing);
226         emit DividendsTransferred(account, owing);
227       }
228       lastDivPoints[account] = totalDivPoints;
229     }
230 
231     function payDividends() payable public onlyOwner {
232       uint weiAmount = msg.value;
233       require(weiAmount>0);
234   
235       totalDivPoints = totalDivPoints.add(weiAmount.mul(pointMultiplier).div(totalSupply()));
236       emit DividendsAdded(weiAmount);
237     }    
238 
239     function claimDividends() public {
240       updateAccount(msg.sender);
241     }
242 
243     // end dividends feature
244 
245     mapping (address => mapping (address => uint256)) private _allowed;
246 
247     uint256 private _totalSupply;
248 
249     /**
250      * @dev Total number of tokens in existence
251      */
252     function totalSupply() public view returns (uint256) {
253         return _totalSupply;
254     }
255 
256     /**
257      * @dev Gets the balance of the specified address.
258      * @param owner The address to query the balance of.
259      * @return A uint256 representing the amount owned by the passed address.
260      */
261     function balanceOf(address owner) public view returns (uint256) {
262         return _balances[owner];
263     }
264 
265     /**
266      * @dev Function to check the amount of tokens that an owner allowed to a spender.
267      * @param owner address The address which owns the funds.
268      * @param spender address The address which will spend the funds.
269      * @return A uint256 specifying the amount of tokens still available for the spender.
270      */
271     function allowance(address owner, address spender) public view returns (uint256) {
272         return _allowed[owner][spender];
273     }
274 
275     /**
276      * @dev Transfer token to a specified address
277      * @param to The address to transfer to.
278      * @param value The amount to be transferred.
279      */
280     function transfer(address to, uint256 value) public returns (bool) {
281         _transfer(msg.sender, to, value);
282         return true;
283     }
284 
285     /**
286      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
287      * Beware that changing an allowance with this method brings the risk that someone may use both the old
288      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
289      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
290      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
291      * @param spender The address which will spend the funds.
292      * @param value The amount of tokens to be spent.
293      */
294     function approve(address spender, uint256 value) public returns (bool) {
295         _approve(msg.sender, spender, value);
296         return true;
297     }
298 
299     /**
300      * @dev Transfer tokens from one address to another.
301      * Note that while this function emits an Approval event, this is not required as per the specification,
302      * and other compliant implementations may not emit the event.
303      * @param from address The address which you want to send tokens from
304      * @param to address The address which you want to transfer to
305      * @param value uint256 the amount of tokens to be transferred
306      */
307     function transferFrom(address from, address to, uint256 value) public returns (bool) {
308         _transfer(from, to, value);
309         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
310         return true;
311     }
312 
313     /**
314      * @dev Increase the amount of tokens that an owner allowed to a spender.
315      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
316      * allowed value is better to use this function to avoid 2 calls (and wait until
317      * the first transaction is mined)
318      * From MonolithDAO Token.sol
319      * Emits an Approval event.
320      * @param spender The address which will spend the funds.
321      * @param addedValue The amount of tokens to increase the allowance by.
322      */
323     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Decrease the amount of tokens that an owner allowed to a spender.
330      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
331      * allowed value is better to use this function to avoid 2 calls (and wait until
332      * the first transaction is mined)
333      * From MonolithDAO Token.sol
334      * Emits an Approval event.
335      * @param spender The address which will spend the funds.
336      * @param subtractedValue The amount of tokens to decrease the allowance by.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
339         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
340         return true;
341     }
342 
343     /**
344      * @dev Transfer token for a specified addresses
345      * @param from The address to transfer from.
346      * @param to The address to transfer to.
347      * @param value The amount to be transferred.
348      */
349     function _transfer(address from, address to, uint256 value) internal {
350         require(to != address(0));
351         require(canTransfer(from) && canTransfer(msg.sender));
352         
353         updateAccount(from);
354         updateAccount(to);
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
371         updateAccount(account);
372 
373         _totalSupply = _totalSupply.add(value);
374         _balances[account] = _balances[account].add(value);
375         emit Transfer(address(0), account, value);
376     }
377 
378     /**
379      * @dev Internal function that burns an amount of the token of a given
380      * account.
381      * @param account The account whose tokens will be burnt.
382      * @param value The amount that will be burnt.
383      */
384     function _burn(address account, uint256 value) internal {
385         require(account != address(0));
386         require(canTransfer(msg.sender) && canTransfer(account));
387         
388         updateAccount(account);
389 
390         _totalSupply = _totalSupply.sub(value);
391         _balances[account] = _balances[account].sub(value);
392         emit Transfer(account, address(0), value);
393     }
394 
395     /**
396      * @dev Approve an address to spend another addresses' tokens.
397      * @param owner The address that owns the tokens.
398      * @param spender The address that will spend the tokens.
399      * @param value The number of tokens that can be spent.
400      */
401     function _approve(address owner, address spender, uint256 value) internal {
402         require(spender != address(0));
403         require(owner != address(0));
404 
405         _allowed[owner][spender] = value;
406         emit Approval(owner, spender, value);
407     }
408 
409     /**
410      * @dev Internal function that burns an amount of the token of a given
411      * account, deducting from the sender's allowance for said account. Uses the
412      * internal burn function.
413      * Emits an Approval event (reflecting the reduced allowance).
414      * @param account The account whose tokens will be burnt.
415      * @param value The amount that will be burnt.
416      */
417     function _burnFrom(address account, uint256 value) internal {
418         _burn(account, value);
419         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
420     }
421 }
422 
423 /**
424  * @title Burnable Token
425  * @dev Token that can be irreversibly burned (destroyed).
426  */
427 contract ERC20Burnable is ERC20 {
428     /**
429      * @dev Burns a specific amount of tokens.
430      * @param value The amount of token to be burned.
431      */
432     function burn(uint256 value) public {
433         _burn(msg.sender, value);
434     }
435 
436     /**
437      * @dev Burns a specific amount of tokens from the target address and decrements allowance
438      * @param from address The account whose tokens will be burned.
439      * @param value uint256 The amount of token to be burned.
440      */
441     function burnFrom(address from, uint256 value) public {
442         _burnFrom(from, value);
443     }
444 }
445 
446 /**
447  * @title ERC20Mintable
448  * @dev ERC20 minting logic
449  */
450 contract ERC20Mintable is ERC20 {
451     /**
452      * @dev Function to mint tokens
453      * @param to The address that will receive the minted tokens.
454      * @param value The amount of tokens to mint.
455      * @return A boolean that indicates if the operation was successful.
456      */
457     function mint(address to, uint256 value) public onlyOwner returns (bool) {
458         _mint(to, value);
459         return true;
460     }
461 }
462 
463 interface tokenRecipient { 
464     function receiveApproval(address _from, uint256 _value, bytes _extraData) external;
465 }
466 
467 contract ThornCloud is ERC20Mintable, ERC20Burnable {
468     string public constant name = "Thorn Cloud";
469     string public constant symbol = "TCC";
470     uint256 public constant decimals = 18;
471 
472     // there is no problem in using * here instead of .mul()
473     uint256 public initialSupply = 300000000 * (10 ** decimals);
474 
475     constructor () public {
476         _mint(msg.sender, initialSupply);
477     }
478 
479     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
480         external
481         returns (bool success) 
482     {
483         tokenRecipient spender = tokenRecipient(_spender);
484         if (approve(_spender, _value)) {
485             spender.receiveApproval(msg.sender, _value, _extraData);
486             return true;
487         }
488     }
489 
490     function transferAnyERC20(address _tokenAddress, address _to, uint _amount) public onlyOwner {
491         IERC20(_tokenAddress).transfer(_to, _amount);
492     }
493 }
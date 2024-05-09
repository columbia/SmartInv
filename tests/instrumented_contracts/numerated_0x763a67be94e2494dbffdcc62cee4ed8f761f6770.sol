1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     int256 constant private INT256_MIN = -2**255;
31 
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50     * @dev Multiplies two signed integers, reverts on overflow.
51     */
52     function mul(int256 a, int256 b) internal pure returns (int256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
61 
62         int256 c = a * b;
63         require(c / a == b);
64 
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
82     */
83     function div(int256 a, int256 b) internal pure returns (int256) {
84         require(b != 0); // Solidity only automatically asserts when dividing by 0
85         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
86 
87         int256 c = a / b;
88 
89         return c;
90     }
91 
92     /**
93     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94     */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103     * @dev Subtracts two signed integers, reverts on overflow.
104     */
105     function sub(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a - b;
107         require((b >= 0 && c <= a) || (b < 0 && c > a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Adds two unsigned integers, reverts on overflow.
114     */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Adds two signed integers, reverts on overflow.
124     */
125     function add(int256 a, int256 b) internal pure returns (int256) {
126         int256 c = a + b;
127         require((b >= 0 && c >= a) || (b < 0 && c < a));
128 
129         return c;
130     }
131 
132     /**
133     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
134     * reverts when dividing by zero.
135     */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b != 0);
138         return a % b;
139     }
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
147  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  *
149  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
150  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
151  * compliant implementations may not do it.
152  */
153 contract ERC20 is IERC20 {
154     using SafeMath for uint256;
155 
156     mapping (address => uint256) private _balances;
157 
158     mapping (address => mapping (address => uint256)) private _allowed;
159 
160     uint256 private _totalSupply;
161 
162     /**
163     * @dev Total number of tokens in existence
164     */
165     function totalSupply() public view returns (uint256) {
166         return _totalSupply;
167     }
168 
169     /**
170     * @dev Gets the balance of the specified address.
171     * @param owner The address to query the balance of.
172     * @return An uint256 representing the amount owned by the passed address.
173     */
174     function balanceOf(address owner) public view returns (uint256) {
175         return _balances[owner];
176     }
177 
178     /**
179      * @dev Function to check the amount of tokens that an owner allowed to a spender.
180      * @param owner address The address which owns the funds.
181      * @param spender address The address which will spend the funds.
182      * @return A uint256 specifying the amount of tokens still available for the spender.
183      */
184     function allowance(address owner, address spender) public view returns (uint256) {
185         return _allowed[owner][spender];
186     }
187 
188     /**
189     * @dev Transfer token for a specified address
190     * @param to The address to transfer to.
191     * @param value The amount to be transferred.
192     */
193     function transfer(address to, uint256 value) public returns (bool) {
194         _transfer(msg.sender, to, value);
195         return true;
196     }
197 
198     /**
199      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200      * Beware that changing an allowance with this method brings the risk that someone may use both the old
201      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204      * @param spender The address which will spend the funds.
205      * @param value The amount of tokens to be spent.
206      */
207     function approve(address spender, uint256 value) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = value;
211         emit Approval(msg.sender, spender, value);
212         return true;
213     }
214 
215     /**
216      * @dev Transfer tokens from one address to another.
217      * Note that while this function emits an Approval event, this is not required as per the specification,
218      * and other compliant implementations may not emit the event.
219      * @param from address The address which you want to send tokens from
220      * @param to address The address which you want to transfer to
221      * @param value uint256 the amount of tokens to be transferred
222      */
223     function transferFrom(address from, address to, uint256 value) public returns (bool) {
224         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
225         _transfer(from, to, value);
226         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
227         return true;
228     }
229 
230     /**
231      * @dev Increase the amount of tokens that an owner allowed to a spender.
232      * approve should be called when allowed_[_spender] == 0. To increment
233      * allowed value is better to use this function to avoid 2 calls (and wait until
234      * the first transaction is mined)
235      * From MonolithDAO Token.sol
236      * Emits an Approval event.
237      * @param spender The address which will spend the funds.
238      * @param addedValue The amount of tokens to increase the allowance by.
239      */
240     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
241         require(spender != address(0));
242 
243         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
244         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
245         return true;
246     }
247 
248     /**
249      * @dev Decrease the amount of tokens that an owner allowed to a spender.
250      * approve should be called when allowed_[_spender] == 0. To decrement
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * Emits an Approval event.
255      * @param spender The address which will spend the funds.
256      * @param subtractedValue The amount of tokens to decrease the allowance by.
257      */
258     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
259         require(spender != address(0));
260 
261         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
262         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
263         return true;
264     }
265 
266     /**
267     * @dev Transfer token for a specified addresses
268     * @param from The address to transfer from.
269     * @param to The address to transfer to.
270     * @param value The amount to be transferred.
271     */
272     function _transfer(address from, address to, uint256 value) internal {
273         require(to != address(0));
274 
275         _balances[from] = _balances[from].sub(value);
276         _balances[to] = _balances[to].add(value);
277         emit Transfer(from, to, value);
278     }
279 
280     /**
281      * @dev Internal function that mints an amount of the token and assigns it to
282      * an account. This encapsulates the modification of balances such that the
283      * proper events are emitted.
284      * @param account The account that will receive the created tokens.
285      * @param value The amount that will be created.
286      */
287     function _mint(address account, uint256 value) internal {
288         require(account != address(0));
289 
290         _totalSupply = _totalSupply.add(value);
291         _balances[account] = _balances[account].add(value);
292         emit Transfer(address(0), account, value);
293     }
294 
295     /**
296      * @dev Internal function that burns an amount of the token of a given
297      * account.
298      * @param account The account whose tokens will be burnt.
299      * @param value The amount that will be burnt.
300      */
301     function _burn(address account, uint256 value) internal {
302         require(account != address(0));
303 
304         _totalSupply = _totalSupply.sub(value);
305         _balances[account] = _balances[account].sub(value);
306         emit Transfer(account, address(0), value);
307     }
308 
309     /**
310      * @dev Internal function that burns an amount of the token of a given
311      * account, deducting from the sender's allowance for said account. Uses the
312      * internal burn function.
313      * Emits an Approval event (reflecting the reduced allowance).
314      * @param account The account whose tokens will be burnt.
315      * @param value The amount that will be burnt.
316      */
317     function _burnFrom(address account, uint256 value) internal {
318         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
319         _burn(account, value);
320         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
321     }
322 }
323 
324 /**
325  * @title Ownable
326  * @dev The Ownable contract has an owner address, and provides basic authorization control
327  * functions, this simplifies the implementation of "user permissions".
328  */
329 contract Ownable {
330     address private _owner;
331 
332     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
333 
334     /**
335      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
336      * account.
337      */
338     constructor () internal {
339         _owner = msg.sender;
340         emit OwnershipTransferred(address(0), _owner);
341     }
342 
343     /**
344      * @return the address of the owner.
345      */
346     function owner() public view returns (address) {
347         return _owner;
348     }
349 
350     /**
351      * @dev Throws if called by any account other than the owner.
352      */
353     modifier onlyOwner() {
354         require(isOwner());
355         _;
356     }
357 
358     /**
359      * @return true if `msg.sender` is the owner of the contract.
360      */
361     function isOwner() public view returns (bool) {
362         return msg.sender == _owner;
363     }
364 
365     /**
366      * @dev Allows the current owner to relinquish control of the contract.
367      * @notice Renouncing to ownership will leave the contract without an owner.
368      * It will not be possible to call the functions with the `onlyOwner`
369      * modifier anymore.
370      */
371     function renounceOwnership() public onlyOwner {
372         emit OwnershipTransferred(_owner, address(0));
373         _owner = address(0);
374     }
375 
376     /**
377      * @dev Allows the current owner to transfer control of the contract to a newOwner.
378      * @param newOwner The address to transfer ownership to.
379      */
380     function transferOwnership(address newOwner) public onlyOwner {
381         _transferOwnership(newOwner);
382     }
383 
384     /**
385      * @dev Transfers control of the contract to a newOwner.
386      * @param newOwner The address to transfer ownership to.
387      */
388     function _transferOwnership(address newOwner) internal {
389         require(newOwner != address(0));
390         emit OwnershipTransferred(_owner, newOwner);
391         _owner = newOwner;
392     }
393 }
394 
395 contract BTNY is ERC20, Ownable {
396   string public constant name = "Bitenny";
397   string public constant symbol = "BTNY";
398   uint32 public constant decimals = 18;
399   
400   address public saleContract;
401   bool public saleContractActivated;
402   uint256 internal _startTime;
403   uint256 internal _foundation = uint256(9e7).mul(1 ether);
404   uint256 internal _bounty = uint256(1e7).mul(1 ether);
405   uint256 internal _tokensForSale = uint256(7e8).mul(1 ether);
406   uint256 internal _tokensForTeamAndAdvisors = uint256(2e8).mul(1 ether);
407 
408   mapping(address => uint256) public team;
409   mapping(address => uint256) public teamReleased;
410   mapping(address => uint256) public advisors;
411   mapping(address => uint256) public advisorsReleased;
412 
413   event SaleContractActivation(address saleContract, uint256 _tokensForSale);
414   event VestedToTeam(address who, uint256 amount);
415   event VestedToAdvisors(address who, uint256 amount);
416 
417   constructor(address _newOwner) public {
418     _transferOwnership(_newOwner);
419     _startTime = now;
420     uint256 tokens = _foundation.add(_bounty);
421     _foundation = 0;
422     _bounty = 0;
423     _mint(_newOwner, tokens);
424   }
425 
426   function _teamToRelease(address who) internal view returns(uint256) {
427     uint256 teamStage = now.sub(_startTime).div(365 days);
428     if (teamStage > 3) teamStage = 3;
429     uint256 teamTokens = team[who].mul(teamStage).div(3).sub(teamReleased[who]);
430     return teamTokens;
431   }
432 
433   function _advisorsToRelease(address who) internal view returns(uint256) {
434     uint256 advisorsStage = now.sub(_startTime).div(91 days);
435     if (advisorsStage > 4) advisorsStage = 4;
436     uint256 advisorsTokens = advisors[who].mul(advisorsStage).div(4).sub(advisorsReleased[who]);
437     return advisorsTokens;
438   }
439 
440   function toRelease(address who) public view returns(uint256) {
441     uint256 teamTokens = _teamToRelease(who);
442     uint256 advisorsTokens = _advisorsToRelease(who);
443     return teamTokens.add(advisorsTokens);
444   }
445 
446   function release() public {
447     address who = msg.sender;
448     uint256 teamTokens = _teamToRelease(who);
449     uint256 advisorsTokens = _advisorsToRelease(who);
450     uint256 tokens = teamTokens.add(advisorsTokens);
451     require(tokens > 0);
452     if (teamTokens > 0)
453         teamReleased[who] = teamReleased[who].add(teamTokens);
454     if (advisorsTokens > 0)
455         advisorsReleased[who] = advisorsReleased[who].add(advisorsTokens);
456     _mint(who, tokens);
457   }
458 
459   function vestToTeam (address who, uint256 amount) public onlyOwner {
460     require(who != address(0));
461     _tokensForTeamAndAdvisors = _tokensForTeamAndAdvisors.sub(amount);
462     team[who] = team[who].add(amount);
463     emit VestedToTeam(who, amount);
464   }
465 
466   function vestToAdvisors (address who, uint256 amount) public onlyOwner {
467     require(who != address(0));
468     _tokensForTeamAndAdvisors = _tokensForTeamAndAdvisors.sub(amount);
469     advisors[who] = advisors[who].add(amount);
470     emit VestedToAdvisors(who, amount);
471   }
472 
473   function activateSaleContract(address saleContractAddress) public onlyOwner {
474     require(saleContractAddress != address(0));
475     require(!saleContractActivated);
476     saleContract = saleContractAddress;
477     saleContractActivated = true;
478     _mint(saleContract, _tokensForSale);
479     _tokensForSale = 0;
480     emit SaleContractActivation(saleContract, _tokensForSale);
481   }
482 
483   function burnTokensForSale(uint256 amount) public returns (bool) {
484     require(saleContract != address(0));
485     require(msg.sender == saleContract);
486     _burn(saleContract, amount);
487     return true;
488   }
489 }
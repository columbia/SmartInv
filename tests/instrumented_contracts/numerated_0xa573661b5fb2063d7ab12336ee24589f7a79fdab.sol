1 pragma solidity 0.4.24;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/flavours/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions". It has two-stage ownership transfer.
75  */
76 contract Ownable {
77 
78     address public owner;
79     address public pendingOwner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to prepare transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         pendingOwner = newOwner;
114     }
115 
116     /**
117      * @dev Allows the pendingOwner address to finalize the transfer.
118      */
119     function claimOwnership() public onlyPendingOwner {
120         emit OwnershipTransferred(owner, pendingOwner);
121         owner = pendingOwner;
122         pendingOwner = address(0);
123     }
124 }
125 
126 // File: contracts/flavours/Lockable.sol
127 
128 /**
129  * @title Lockable
130  * @dev Base contract which allows children to
131  *      implement main operations locking mechanism.
132  */
133 contract Lockable is Ownable {
134     event Lock();
135     event Unlock();
136 
137     bool public locked = false;
138 
139     /**
140      * @dev Modifier to make a function callable
141     *       only when the contract is not locked.
142      */
143     modifier whenNotLocked() {
144         require(!locked);
145         _;
146     }
147 
148     /**
149      * @dev Modifier to make a function callable
150      *      only when the contract is locked.
151      */
152     modifier whenLocked() {
153         require(locked);
154         _;
155     }
156 
157     /**
158      * @dev called by the owner to locke, triggers locked state
159      */
160     function lock() public onlyOwner whenNotLocked {
161         locked = true;
162         emit Lock();
163     }
164 
165     /**
166      * @dev called by the owner
167      *      to unlock, returns to unlocked state
168      */
169     function unlock() public onlyOwner whenLocked {
170         locked = false;
171         emit Unlock();
172     }
173 }
174 
175 // File: contracts/base/BaseFixedERC20Token.sol
176 
177 contract BaseFixedERC20Token is Lockable {
178     using SafeMath for uint;
179 
180     /// @dev ERC20 Total supply
181     uint public totalSupply;
182 
183     mapping(address => uint) public balances;
184 
185     mapping(address => mapping(address => uint)) private allowed;
186 
187     /// @dev Fired if token is transferred according to ERC20 spec
188     event Transfer(address indexed from, address indexed to, uint value);
189 
190     /// @dev Fired if token withdrawal is approved according to ERC20 spec
191     event Approval(address indexed owner, address indexed spender, uint value);
192 
193     /**
194      * @dev Gets the balance of the specified address
195      * @param owner_ The address to query the the balance of
196      * @return An uint representing the amount owned by the passed address
197      */
198     function balanceOf(address owner_) public view returns (uint balance) {
199         return balances[owner_];
200     }
201 
202     /**
203      * @dev Transfer token for a specified address
204      * @param to_ The address to transfer to.
205      * @param value_ The amount to be transferred.
206      */
207     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
208         require(to_ != address(0) && value_ <= balances[msg.sender]);
209         // SafeMath.sub will throw an exception if there is not enough balance
210         balances[msg.sender] = balances[msg.sender].sub(value_);
211         balances[to_] = balances[to_].add(value_);
212         emit Transfer(msg.sender, to_, value_);
213         return true;
214     }
215 
216     /**
217      * @dev Transfer tokens from one address to another
218      * @param from_ address The address which you want to send tokens from
219      * @param to_ address The address which you want to transfer to
220      * @param value_ uint the amount of tokens to be transferred
221      */
222     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
223         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
224         balances[from_] = balances[from_].sub(value_);
225         balances[to_] = balances[to_].add(value_);
226         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
227         emit Transfer(from_, to_, value_);
228         return true;
229     }
230 
231     /**
232      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
233      *
234      * Beware that changing an allowance with this method brings the risk that someone may use both the old
235      * and the new allowance by unfortunate transaction ordering
236      *
237      * To change the approve amount you first have to reduce the addresses
238      * allowance to zero by calling `approve(spender_, 0)` if it is not
239      * already 0 to mitigate the race condition described in:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * @param spender_ The address which will spend the funds.
243      * @param value_ The amount of tokens to be spent.
244      */
245     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
246         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
247             revert();
248         }
249         allowed[msg.sender][spender_] = value_;
250         emit Approval(msg.sender, spender_, value_);
251         return true;
252     }
253 
254     /**
255      * @dev Function to check the amount of tokens that an owner allowed to a spender
256      * @param owner_ address The address which owns the funds
257      * @param spender_ address The address which will spend the funds
258      * @return A uint specifying the amount of tokens still available for the spender
259      */
260     function allowance(address owner_, address spender_) public view returns (uint) {
261         return allowed[owner_][spender_];
262     }
263 }
264 
265 // File: contracts/base/BaseICOToken.sol
266 
267 /**
268  * @dev Not mintable, ERC20 compliant token, distributed by ICO.
269  */
270 contract BaseICOToken is BaseFixedERC20Token {
271 
272     /// @dev Available supply of tokens
273     uint public availableSupply;
274 
275     /// @dev ICO smart contract allowed to distribute public funds for this
276     address public ico;
277 
278     /// @dev Fired if investment for `amount` of tokens performed by `to` address
279     event ICOTokensInvested(address indexed to, uint amount);
280 
281     /// @dev ICO contract changed for this token
282     event ICOChanged(address indexed icoContract);
283 
284     modifier onlyICO() {
285         require(msg.sender == ico);
286         _;
287     }
288 
289     /**
290      * @dev Not mintable, ERC20 compliant token, distributed by ICO.
291      * @param totalSupply_ Total tokens supply.
292      */
293     constructor(uint totalSupply_) public {
294         locked = true;
295         totalSupply = totalSupply_;
296         availableSupply = totalSupply_;
297     }
298 
299     /**
300      * @dev Set address of ICO smart-contract which controls token
301      * initial token distribution.
302      * @param ico_ ICO contract address.
303      */
304     function changeICO(address ico_) public onlyOwner {
305         ico = ico_;
306         emit ICOChanged(ico);
307     }
308 
309     /**
310      * @dev Assign `amountWei_` of wei converted into tokens to investor identified by `to_` address.
311      * @param to_ Investor address.
312      * @param amountWei_ Number of wei invested
313      * @param ethTokenExchangeRatio_ Number of tokens in 1Eth
314      * @return Amount of invested tokens
315      */
316     function icoInvestmentWei(address to_, uint amountWei_, uint ethTokenExchangeRatio_) public returns (uint);
317 
318     function isValidICOInvestment(address to_, uint amount_) internal view returns (bool) {
319         return to_ != address(0) && amount_ <= availableSupply;
320     }
321 }
322 
323 // File: contracts/flavours/SelfDestructible.sol
324 
325 /**
326  * @title SelfDestructible
327  * @dev The SelfDestructible contract has an owner address, and provides selfDestruct method
328  * in case of deployment error.
329  */
330 contract SelfDestructible is Ownable {
331 
332     function selfDestruct(uint8 v, bytes32 r, bytes32 s) public onlyOwner {
333         if (ecrecover(prefixedHash(), v, r, s) != owner) {
334             revert();
335         }
336         selfdestruct(owner);
337     }
338 
339     function originalHash() internal view returns (bytes32) {
340         return keccak256(abi.encodePacked(
341                 "Signed for Selfdestruct",
342                 address(this),
343                 msg.sender
344             ));
345     }
346 
347     function prefixedHash() internal view returns (bytes32) {
348         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
349         return keccak256(abi.encodePacked(prefix, originalHash()));
350     }
351 }
352 
353 // File: contracts/interface/ERC20Token.sol
354 
355 interface ERC20Token {
356     function transferFrom(address from_, address to_, uint value_) external returns (bool);
357     function transfer(address to_, uint value_) external returns (bool);
358     function balanceOf(address owner_) external returns (uint);
359 }
360 
361 // File: contracts/flavours/Withdrawal.sol
362 
363 /**
364  * @title Withdrawal
365  * @dev The Withdrawal contract has an owner address, and provides method for withdraw funds and tokens, if any
366  */
367 contract Withdrawal is Ownable {
368 
369     // withdraw funds, if any, only for owner
370     function withdraw() public onlyOwner {
371         owner.transfer(address(this).balance);
372     }
373 
374     // withdraw stuck tokens, if any, only for owner
375     function withdrawTokens(address _someToken) public onlyOwner {
376         ERC20Token someToken = ERC20Token(_someToken);
377         uint balance = someToken.balanceOf(address(this));
378         someToken.transfer(owner, balance);
379     }
380 }
381 
382 // File: contracts/ICHXToken.sol
383 
384 /**
385  * @title ICHX token contract.
386  */
387 contract ICHXToken is BaseICOToken, SelfDestructible, Withdrawal {
388     using SafeMath for uint;
389 
390     string public constant name = "IceChain";
391 
392     string public constant symbol = "ICHX";
393 
394     uint8 public constant decimals = 18;
395 
396     uint internal constant ONE_TOKEN = 1e18;
397 
398     constructor(uint totalSupplyTokens_,
399             uint companyTokens_) public
400         BaseICOToken(totalSupplyTokens_.mul(ONE_TOKEN)) {
401         require(availableSupply == totalSupply);
402 
403         balances[owner] = companyTokens_.mul(ONE_TOKEN);
404 
405         availableSupply = availableSupply
406             .sub(balances[owner]);
407 
408         emit Transfer(0, address(this), balances[owner]);
409         emit Transfer(address(this), owner, balances[owner]);
410     }
411 
412     // Disable direct payments
413     function() external payable {
414         revert();
415     }
416 
417     /**
418      * @dev Assign `amountWei_` of wei converted into tokens to investor identified by `to_` address.
419      * @param to_ Investor address.
420      * @param amountWei_ Number of wei invested
421      * @param ethTokenExchangeRatio_ Number of tokens in 1 Eth
422      * @return Amount of invested tokens
423      */
424     function icoInvestmentWei(address to_, uint amountWei_, uint ethTokenExchangeRatio_) public onlyICO returns (uint) {
425         uint amount = amountWei_.mul(ethTokenExchangeRatio_).mul(ONE_TOKEN).div(1 ether);
426         require(isValidICOInvestment(to_, amount));
427         availableSupply = availableSupply.sub(amount);
428         balances[to_] = balances[to_].add(amount);
429         emit ICOTokensInvested(to_, amount);
430         return amount;
431     }
432 }
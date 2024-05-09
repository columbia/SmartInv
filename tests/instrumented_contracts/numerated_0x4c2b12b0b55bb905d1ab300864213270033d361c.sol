1 pragma solidity ^0.4.18;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a / b;
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 // File: contracts/flavours/Ownable.sol
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44 
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51      * account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 // File: contracts/flavours/Lockable.sol
77 
78 /**
79  * @title Lockable
80  * @dev Base contract which allows children to
81  *      implement main operations locking mechanism.
82  */
83 contract Lockable is Ownable {
84     event Lock();
85     event Unlock();
86 
87     bool public locked = false;
88 
89     /**
90      * @dev Modifier to make a function callable
91     *       only when the contract is not locked.
92      */
93     modifier whenNotLocked() {
94         require(!locked);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable
100      *      only when the contract is locked.
101      */
102     modifier whenLocked() {
103         require(locked);
104         _;
105     }
106 
107     /**
108      * @dev called by the owner to locke, triggers locked state
109      */
110     function lock() public onlyOwner whenNotLocked {
111         locked = true;
112         Lock();
113     }
114 
115     /**
116      * @dev called by the owner
117      *      to unlock, returns to unlocked state
118      */
119     function unlock() public onlyOwner whenLocked {
120         locked = false;
121         Unlock();
122     }
123 }
124 
125 // File: contracts/base/BaseFixedERC20Token.sol
126 
127 contract BaseFixedERC20Token is Lockable {
128     using SafeMath for uint;
129 
130     /// @dev ERC20 Total supply
131     uint public totalSupply;
132 
133     mapping(address => uint) balances;
134 
135     mapping(address => mapping(address => uint)) private allowed;
136 
137     /// @dev Fired if token is transferred according to ERC20 spec
138     event Transfer(address indexed from, address indexed to, uint value);
139 
140     /// @dev Fired if token withdrawal is approved according to ERC20 spec
141     event Approval(address indexed owner, address indexed spender, uint value);
142 
143     /**
144      * @dev Gets the balance of the specified address
145      * @param owner_ The address to query the the balance of
146      * @return An uint representing the amount owned by the passed address
147      */
148     function balanceOf(address owner_) public view returns (uint balance) {
149         return balances[owner_];
150     }
151 
152     /**
153      * @dev Transfer token for a specified address
154      * @param to_ The address to transfer to.
155      * @param value_ The amount to be transferred.
156      */
157     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
158         require(to_ != address(0) && value_ <= balances[msg.sender]);
159         // SafeMath.sub will throw an exception if there is not enough balance
160         balances[msg.sender] = balances[msg.sender].sub(value_);
161         balances[to_] = balances[to_].add(value_);
162         Transfer(msg.sender, to_, value_);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another
168      * @param from_ address The address which you want to send tokens from
169      * @param to_ address The address which you want to transfer to
170      * @param value_ uint the amount of tokens to be transferred
171      */
172     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
173         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
174         balances[from_] = balances[from_].sub(value_);
175         balances[to_] = balances[to_].add(value_);
176         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
177         Transfer(from_, to_, value_);
178         return true;
179     }
180 
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
183      *
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering
186      *
187      * To change the approve amount you first have to reduce the addresses
188      * allowance to zero by calling `approve(spender_, 0)` if it is not
189      * already 0 to mitigate the race condition described in:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * @param spender_ The address which will spend the funds.
193      * @param value_ The amount of tokens to be spent.
194      */
195     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
196         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
197             revert();
198         }
199         allowed[msg.sender][spender_] = value_;
200         Approval(msg.sender, spender_, value_);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender
206      * @param owner_ address The address which owns the funds
207      * @param spender_ address The address which will spend the funds
208      * @return A uint specifying the amount of tokens still available for the spender
209      */
210     function allowance(address owner_, address spender_) public view returns (uint) {
211         return allowed[owner_][spender_];
212     }
213 }
214 
215 // File: contracts/base/BaseICOTokenWithBonus.sol
216 
217 /**
218  * @dev Not mintable, ERC20 compliant token, distributed by ICO/Pre-ICO.
219  */
220 contract BaseICOTokenWithBonus is BaseFixedERC20Token {
221 
222     /// @dev Available supply of tokens
223     uint public availableSupply;
224 
225     /// @dev ICO/Pre-ICO smart contract allowed to distribute public funds for this
226     address public ico;
227 
228     /// @dev bonus tokens unlock date
229     uint public bonusUnlockAt;
230 
231     /// @dev bonus balances
232     mapping(address => uint) public bonusBalances;
233 
234     /// @dev Fired if investment for `amount` of tokens performed by `to` address
235     event ICOTokensInvested(address indexed to, uint amount);
236 
237     /// @dev ICO contract changed for this token
238     event ICOChanged(address indexed icoContract);
239 
240     modifier onlyICO() {
241         require(msg.sender == ico);
242         _;
243     }
244 
245     /**
246      * @dev Not mintable, ERC20 compliant token, distributed by ICO/Pre-ICO.
247      * @param totalSupply_ Total tokens supply.
248      */
249     function BaseICOTokenWithBonus(uint totalSupply_) public {
250         locked = true;
251         totalSupply = totalSupply_;
252         availableSupply = totalSupply_;
253     }
254 
255     /**
256      * @dev Set address of ICO smart-contract which controls token
257      * initial token distribution.
258      * @param ico_ ICO contract address.
259      */
260     function changeICO(address ico_) public onlyOwner {
261         ico = ico_;
262         ICOChanged(ico);
263     }
264 
265     /**
266      * @dev Set date for unlock bonus tokens
267      * @param bonusUnlockAt_ seconds since epoch
268      */
269     function setBonusUnlockAt(uint bonusUnlockAt_) public onlyOwner {
270         require(bonusUnlockAt_ > block.timestamp);
271         bonusUnlockAt = bonusUnlockAt_;
272     }
273 
274     function getBonusUnlockAt() public view returns (uint) {
275         return bonusUnlockAt;
276     }
277 
278     /**
279      * @dev Gets the balance of bonus tokens the specified address.
280      * @param owner_ The address to query the the balance of.
281      * @return An uint representing the amount owned by the passed address.
282      */
283     function bonusBalanceOf(address owner_) public view returns (uint) {
284         return bonusBalances[owner_];
285     }
286 
287     /**
288      * @dev Assign `amount_` of tokens to investor identified by `to_` address.
289      * @param to_ Investor address.
290      * @param amount_ Number of tokens distributed.
291      */
292     function icoInvestment(address to_, uint amount_, uint bonusAmount_) public onlyICO returns (uint) {
293         require(isValidICOInvestment(to_, amount_));
294         availableSupply = availableSupply.sub(amount_);
295         balances[to_] = balances[to_].add(amount_);
296         bonusBalances[to_] = bonusBalances[to_].add(bonusAmount_);
297         ICOTokensInvested(to_, amount_);
298         return amount_;
299     }
300 
301     function isValidICOInvestment(address to_, uint amount_) internal view returns (bool) {
302         return to_ != address(0) && amount_ <= availableSupply;
303     }
304 
305     function getAllowedForTransferTokens(address from_) public view returns (uint) {
306         return (bonusUnlockAt >= block.timestamp) ? balances[from_].sub(bonusBalances[from_]) : balances[from_];
307     }
308 
309     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
310         require(value_ <= getAllowedForTransferTokens(msg.sender));
311         return super.transfer(to_, value_);
312     }
313 
314     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
315         require(value_ <= getAllowedForTransferTokens(from_));
316         return super.transferFrom(from_, to_, value_);
317     }
318 }
319 
320 // File: contracts/BENEFITToken.sol
321 
322 /**
323  * @title BENEFIT token contract.
324  */
325 contract BENEFITToken is BaseICOTokenWithBonus {
326     using SafeMath for uint;
327 
328     string public constant name = "Dating with Benefits";
329 
330     string public constant symbol = "BENEFIT";
331 
332     uint8 public constant decimals = 18;
333 
334     uint internal constant ONE_TOKEN = 1e18;
335 
336     uint public constant RESERVED_RESERVE_UNLOCK_AT = 1546300800; // 1 January 2019 00:00:00 UTC
337     uint public constant RESERVED_COMPANY_UNLOCK_AT = 1561939200; // 1 July 2019 00:00:00 UTC
338 
339     /// @dev Fired some tokens distributed to someone from staff,business
340     event ReservedTokensDistributed(address indexed to, uint8 group, uint amount);
341 
342     event TokensBurned(uint amount);
343 
344     function BENEFITToken(uint totalSupplyTokens_,
345                       uint companyTokens_,
346                       uint bountyTokens_,
347                       uint reserveTokens_,
348                       uint marketingTokens_) public BaseICOTokenWithBonus(totalSupplyTokens_ * ONE_TOKEN) {
349         require(availableSupply == totalSupply);
350         availableSupply = availableSupply
351             .sub(companyTokens_ * ONE_TOKEN)
352             .sub(bountyTokens_ * ONE_TOKEN)
353             .sub(reserveTokens_ * ONE_TOKEN)
354             .sub(marketingTokens_ * ONE_TOKEN);
355         reserved[RESERVED_COMPANY_GROUP] = companyTokens_ * ONE_TOKEN;
356         reserved[RESERVED_BOUNTY_GROUP] = bountyTokens_ * ONE_TOKEN;
357         reserved[RESERVED_RESERVE_GROUP] = reserveTokens_ * ONE_TOKEN;
358         reserved[RESERVED_MARKETING_GROUP] = marketingTokens_ * ONE_TOKEN;
359     }
360 
361     // Disable direct payments
362     function() external payable {
363         revert();
364     }
365 
366     function burnRemain() public onlyOwner {
367         require(availableSupply > 0);
368         uint burned = availableSupply;
369         totalSupply = totalSupply.sub(burned);
370         availableSupply = 0;
371 
372         TokensBurned(burned);
373     }
374 
375     // --------------- Reserve specific
376     uint8 public constant RESERVED_COMPANY_GROUP = 0x1;
377 
378     uint8 public constant RESERVED_BOUNTY_GROUP = 0x2;
379 
380     uint8 public constant RESERVED_RESERVE_GROUP = 0x4;
381 
382     uint8 public constant RESERVED_MARKETING_GROUP = 0x8;
383 
384     /// @dev Token reservation mapping: key(RESERVED_X) => value(number of tokens)
385     mapping(uint8 => uint) public reserved;
386 
387     /**
388      * @dev Get reserved tokens for specific group
389      */
390     function getReservedTokens(uint8 group_) public view returns (uint) {
391         return reserved[group_];
392     }
393 
394     /**
395      * @dev Assign `amount_` of privately distributed tokens
396      *      to someone identified with `to_` address.
397      * @param to_   Tokens owner
398      * @param group_ Group identifier of privately distributed tokens
399      * @param amount_ Number of tokens distributed with decimals part
400      */
401     function assignReserved(address to_, uint8 group_, uint amount_) public onlyOwner {
402         require(to_ != address(0) && (group_ & 0xF) != 0);
403         require(group_ != RESERVED_RESERVE_GROUP
404             || (group_ == RESERVED_RESERVE_GROUP && block.timestamp >= RESERVED_RESERVE_UNLOCK_AT));
405         require(group_ != RESERVED_COMPANY_GROUP
406             || (group_ == RESERVED_COMPANY_GROUP && block.timestamp >= RESERVED_COMPANY_UNLOCK_AT));
407         // SafeMath will check reserved[group_] >= amount
408         reserved[group_] = reserved[group_].sub(amount_);
409         balances[to_] = balances[to_].add(amount_);
410         ReservedTokensDistributed(to_, group_, amount_);
411     }
412 }
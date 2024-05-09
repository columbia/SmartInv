1 pragma solidity 0.4.24;
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
36 // File: contracts/base/BaseExchangeableTokenInterface.sol
37 
38 interface BaseExchangeableTokenInterface {
39 
40     // Sender interface must have:
41     // mapping(address => uint) private exchangedWith;
42     // mapping(address => uint) private exchangedBy;
43 
44     // Receiver interface must have:
45     // mapping(address => uint) private exchangesReceived;
46 
47     /// @dev Fired if token exchange complete
48     event Exchange(address _from, address _targetContract, uint _amount);
49 
50     /// @dev Fired if token exchange and spent complete
51     event ExchangeSpent(address _from, address _targetContract, address _to, uint _amount);
52 
53     // Sender interface
54     function exchangeToken(address _targetContract, uint _amount) external returns (bool success, uint creditedAmount);
55 
56     function exchangeAndSpend(address _targetContract, uint _amount, address _to) external returns (bool success);
57 
58     function __exchangerCallback(address _targetContract, address _exchanger, uint _amount) external returns (bool success);
59 
60     // Receiver interface
61     function __targetExchangeCallback(uint _amount) external returns (bool success);
62 
63     function __targetExchangeAndSpendCallback(address _to, uint _amount) external returns (bool success);
64 }
65 
66 // File: contracts/flavours/Ownable.sol
67 
68 /**
69  * @title Ownable
70  * @dev The Ownable contract has an owner address, and provides basic authorization control
71  * functions, this simplifies the implementation of "user permissions".
72  */
73 contract Ownable {
74 
75     address public owner;
76 
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     /**
80      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81      * account.
82      */
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     /**
96      * @dev Allows the current owner to transfer control of the contract to a newOwner.
97      * @param newOwner The address to transfer ownership to.
98      */
99     function transferOwnership(address newOwner) public onlyOwner {
100         require(newOwner != address(0));
101         emit OwnershipTransferred(owner, newOwner);
102         owner = newOwner;
103     }
104 }
105 
106 // File: contracts/flavours/Lockable.sol
107 
108 /**
109  * @title Lockable
110  * @dev Base contract which allows children to
111  *      implement main operations locking mechanism.
112  */
113 contract Lockable is Ownable {
114     event Lock();
115     event Unlock();
116 
117     bool public locked = false;
118 
119     /**
120      * @dev Modifier to make a function callable
121     *       only when the contract is not locked.
122      */
123     modifier whenNotLocked() {
124         require(!locked);
125         _;
126     }
127 
128     /**
129      * @dev Modifier to make a function callable
130      *      only when the contract is locked.
131      */
132     modifier whenLocked() {
133         require(locked);
134         _;
135     }
136 
137     /**
138      * @dev called by the owner to lock, triggers locked state
139      */
140     function lock() public onlyOwner whenNotLocked {
141         locked = true;
142         emit Lock();
143     }
144 
145     /**
146      * @dev called by the owner
147      *      to unlock, returns to unlocked state
148      */
149     function unlock() public onlyOwner whenLocked {
150         locked = false;
151         emit Unlock();
152     }
153 }
154 
155 // File: contracts/base/BaseFixedERC20Token.sol
156 
157 contract BaseFixedERC20Token is Lockable {
158     using SafeMath for uint;
159 
160     /// @dev ERC20 Total supply
161     uint public totalSupply;
162 
163     mapping(address => uint) public balances;
164 
165     mapping(address => mapping(address => uint)) private allowed;
166 
167     /// @dev Fired if token is transferred according to ERC20 spec
168     event Transfer(address indexed from, address indexed to, uint value);
169 
170     /// @dev Fired if token withdrawal is approved according to ERC20 spec
171     event Approval(address indexed owner, address indexed spender, uint value);
172 
173     /**
174      * @dev Gets the balance of the specified address
175      * @param owner_ The address to query the the balance of
176      * @return An uint representing the amount owned by the passed address
177      */
178     function balanceOf(address owner_) public view returns (uint balance) {
179         return balances[owner_];
180     }
181 
182     /**
183      * @dev Transfer token for a specified address
184      * @param to_ The address to transfer to.
185      * @param value_ The amount to be transferred.
186      */
187     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
188         require(to_ != address(0) && value_ <= balances[msg.sender]);
189         // SafeMath.sub will throw an exception if there is not enough balance
190         balances[msg.sender] = balances[msg.sender].sub(value_);
191         balances[to_] = balances[to_].add(value_);
192         emit Transfer(msg.sender, to_, value_);
193         return true;
194     }
195 
196     /**
197      * @dev Transfer tokens from one address to another
198      * @param from_ address The address which you want to send tokens from
199      * @param to_ address The address which you want to transfer to
200      * @param value_ uint the amount of tokens to be transferred
201      */
202     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
203         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
204         balances[from_] = balances[from_].sub(value_);
205         balances[to_] = balances[to_].add(value_);
206         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
207         emit Transfer(from_, to_, value_);
208         return true;
209     }
210 
211     /**
212      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
213      *
214      * Beware that changing an allowance with this method brings the risk that someone may use both the old
215      * and the new allowance by unfortunate transaction ordering
216      *
217      * To change the approve amount you first have to reduce the addresses
218      * allowance to zero by calling `approve(spender_, 0)` if it is not
219      * already 0 to mitigate the race condition described in:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      *
222      * @param spender_ The address which will spend the funds.
223      * @param value_ The amount of tokens to be spent.
224      */
225     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
226         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
227             revert();
228         }
229         allowed[msg.sender][spender_] = value_;
230         emit Approval(msg.sender, spender_, value_);
231         return true;
232     }
233 
234     /**
235      * @dev Function to check the amount of tokens that an owner allowed to a spender
236      * @param owner_ address The address which owns the funds
237      * @param spender_ address The address which will spend the funds
238      * @return A uint specifying the amount of tokens still available for the spender
239      */
240     function allowance(address owner_, address spender_) public view returns (uint) {
241         return allowed[owner_][spender_];
242     }
243 }
244 
245 // File: contracts/base/BaseTokenExchangeInterface.sol
246 
247 interface BaseTokenExchangeInterface {
248     // Token exchange service contract must have:
249     // address[] private registeredTokens;
250 
251     /// @dev Fired if token exchange complete
252     event Exchange(address _from, address _by, uint _value, address _target);
253 
254     /// @dev Fired if token exchange and spent complete
255     event ExchangeAndSpent(address _from, address _by, uint _value, address _target, address _to);
256 
257     function registerToken(address _token) external returns (bool success);
258 
259     function exchangeToken(address _targetContract, uint _amount) external returns (bool success, uint creditedAmount);
260 
261     function exchangeAndSpend(address _targetContract, uint _amount, address _to) external returns (bool success);
262 }
263 
264 // File: contracts/base/BaseExchangeableToken.sol
265 
266 /**
267  * @dev ERC20 and EIP-823 (exchangeable) compliant token.
268  */
269 contract BaseExchangeableToken is BaseExchangeableTokenInterface, BaseFixedERC20Token {
270     using SafeMath for uint;
271 
272     BaseTokenExchangeInterface public exchange;
273 
274     /// @dev Fired if token is change exchange. (extends EIP-823)
275     event ExchangeChanged(address _exchange);
276 
277     /**
278      * @dev Modifier to make a function callable
279      *      only when the exchange contract is set.
280      */
281     modifier whenConfigured() {
282         require(exchange != address(0));
283         _;
284     }
285 
286     /**
287      * @dev Modifier to make a function callable
288      *      only by exchange contract
289      */
290     modifier onlyExchange() {
291         require(msg.sender == address(exchange));
292         _;
293     }
294 
295     // Sender interface
296     /// @dev number of tokens exchanged to another tokens for each token address
297     mapping(address => uint) private exchangedWith;
298 
299     /// @dev number of tokens exchanged to another tokens for each user address
300     mapping(address => uint) private exchangedBy;
301 
302     // Receiver interface
303     /// @dev number of tokens exchanged from another tokens for each token address
304     mapping(address => uint) private exchangesReceived;
305 
306     /// @dev change exchange for this token. (extends EIP-823)
307     function changeExchange(address _exchange) public onlyOwner {
308         require(_exchange != address(0));
309         exchange = BaseTokenExchangeInterface(_exchange);
310         emit ExchangeChanged(_exchange);
311     }
312 
313     // Sender interface
314     /**
315      * @dev exchange amount of this token to target token
316      * @param _targetContract target token contract
317      * @param _amount amount of tokens to exchange
318      * @return (true, creditedAmount) on success.
319      *          (false, 0) on:
320      *              nothing =)
321      *          revert on:
322      *              exchangeToken in exchange contract return (false, 0)
323      *              exchange address is not configured
324      *              balance of tokens less then amount to exchange
325      */
326     function exchangeToken(address _targetContract, uint _amount) public whenConfigured returns (bool success, uint creditedAmount) {
327         require(_targetContract != address(0) && _amount <= balances[msg.sender]);
328         (success, creditedAmount) = exchange.exchangeToken(_targetContract, _amount);
329         if (!success) {
330             revert();
331         }
332         emit Exchange(msg.sender, _targetContract, _amount);
333         return (success, creditedAmount);
334     }
335 
336     /**
337      * @dev exchange amount of this token to target token and transfer to specified address
338      * @param _targetContract target token contract
339      * @param _amount amount of tokens to exchange
340      * @param _to address for transferring exchanged tokens
341      * @return true on success.
342      *          false on:
343      *              nothing =)
344      *          revert on:
345      *              exchangeTokenAndSpend in exchange contract return false
346      *              exchange address is not configured
347      *              balance of tokens less then amount to exchange
348      */
349     function exchangeAndSpend(address _targetContract, uint _amount, address _to) public whenConfigured returns (bool success) {
350         require(_targetContract != address(0) && _to != address(0) && _amount <= balances[msg.sender]);
351         success = exchange.exchangeAndSpend(_targetContract, _amount, _to);
352         if (!success) {
353             revert();
354         }
355         emit ExchangeSpent(msg.sender, _targetContract, _to, _amount);
356         return success;
357     }
358 
359     /**
360      * @dev send amount of this token to exchange. Must be called only from exchange contract
361      * @param _targetContract target token contract
362      * @param _exchanger address of user, who exchange tokens
363      * @param _amount amount of tokens to exchange
364      * @return true on success.
365      *          false on:
366      *              balance of tokens less then amount to exchange
367      *          revert on:
368      *              exchange address is not configured
369      *              called not by configured exchange address
370      */
371     function __exchangerCallback(address _targetContract, address _exchanger, uint _amount) public whenConfigured onlyExchange returns (bool success) {
372         require(_targetContract != address(0));
373         if (_amount > balances[_exchanger]) {
374             return false;
375         }
376         balances[_exchanger] = balances[_exchanger].sub(_amount);
377         exchangedWith[_targetContract] = exchangedWith[_targetContract].add(_amount);
378         exchangedBy[_exchanger] = exchangedBy[_exchanger].add(_amount);
379         return true;
380     }
381 
382     // Receiver interface
383     /**
384      * @dev receive amount of tokens from exchange. Must be called only from exchange contract
385      * @param _amount amount of tokens to receive
386      * @return true on success.
387      *          false on:
388      *              nothing =)
389      *          revert on:
390      *              exchange address is not configured
391      *              called not by configured exchange address
392      */
393     function __targetExchangeCallback(uint _amount) public whenConfigured onlyExchange returns (bool success) {
394         balances[tx.origin] = balances[tx.origin].add(_amount);
395         exchangesReceived[tx.origin] = exchangesReceived[tx.origin].add(_amount);
396         emit Exchange(tx.origin, this, _amount);
397         return true;
398     }
399 
400     /**
401      * @dev receive amount of tokens from exchange and transfer to specified address. Must be called only from exchange contract
402      * @param _amount amount of tokens to receive
403      * @param _to address for transferring exchanged tokens
404      * @return true on success.
405      *          false on:
406      *              nothing =)
407      *          revert on:
408      *              exchange address is not configured
409      *              called not by configured exchange address
410      */
411     function __targetExchangeAndSpendCallback(address _to, uint _amount) public whenConfigured onlyExchange returns (bool success) {
412         balances[_to] = balances[_to].add(_amount);
413         exchangesReceived[_to] = exchangesReceived[_to].add(_amount);
414         emit ExchangeSpent(tx.origin, this, _to, _amount);
415         return true;
416     }
417 }
418 
419 // File: contracts/BitoxToken.sol
420 
421 /**
422  * @title Bitox token contract.
423  */
424 contract BitoxToken is BaseExchangeableToken {
425     using SafeMath for uint;
426 
427     string public constant name = "BitoxTokens";
428 
429     string public constant symbol = "BITOX";
430 
431     uint8 public constant decimals = 18;
432 
433     uint internal constant ONE_TOKEN = 1e18;
434 
435     constructor(uint totalSupplyTokens_) public {
436         locked = false;
437         totalSupply = totalSupplyTokens_ * ONE_TOKEN;
438         address creator = msg.sender;
439         balances[creator] = totalSupply;
440 
441         emit Transfer(0, this, totalSupply);
442         emit Transfer(this, creator, balances[creator]);
443     }
444 
445     // Disable direct payments
446     function() external payable {
447         revert();
448     }
449 
450 }
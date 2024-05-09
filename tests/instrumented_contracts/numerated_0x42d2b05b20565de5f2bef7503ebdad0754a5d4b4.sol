1 pragma solidity ^0.4.18;
2 
3     /**
4     * Math operations with safety checks
5     */
6     library SafeMath {
7     function mul(uint a, uint b) internal pure returns (uint) {
8         uint c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint a, uint b) internal pure returns (uint) {
14         assert(b > 0);
15         uint c = a / b;
16         assert(a == b * c + a % b);
17         return c;
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint a, uint b) internal pure returns (uint) {
26         uint c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 
31     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32         return a >= b ? a : b;
33     }
34 
35     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36         return a < b ? a : b;
37     }
38 
39     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40         return a >= b ? a : b;
41     }
42 
43     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a < b ? a : b;
45     }
46     }
47 
48 
49     contract Owned {
50 
51         /// @dev `owner` is the only address that can call a function with this
52         /// modifier
53         modifier onlyOwner() {
54             require(msg.sender == owner);
55             _;
56         }
57 
58         address public owner;
59         /// @notice The Constructor assigns the message sender to be `owner`
60         function Owned() public {
61             owner = msg.sender;
62         }
63 
64         address public newOwner;
65 
66         /// @notice `owner` can step down and assign some other address to this role
67         /// @param _newOwner The address of the new owner. 0x0 can be used to create
68         ///  an unowned neutral vault, however that cannot be undone
69         function changeOwner(address _newOwner) onlyOwner public {
70             newOwner = _newOwner;
71         }
72 
73 
74         function acceptOwnership() public {
75             if (msg.sender == newOwner) {
76                 owner = newOwner;
77             }
78         }
79     }
80 
81 
82     contract ERC20Protocol {
83         /* This is a slight change to the ERC20 base standard.
84         function totalSupply() constant returns (uint supply);
85         is replaced with:
86         uint public totalSupply;
87         This automatically creates a getter function for the totalSupply.
88         This is moved to the base contract since public getter functions are not
89         currently recognised as an implementation of the matching abstract
90         function by the compiler.
91         */
92         /// total amount of tokens
93         uint public totalSupply;
94 
95         /// @param _owner The address from which the balance will be retrieved
96         /// @return The balance
97         function balanceOf(address _owner) constant public returns (uint balance);
98 
99         /// @notice send `_value` token to `_to` from `msg.sender`
100         /// @param _to The address of the recipient
101         /// @param _value The amount of token to be transferred
102         /// @return Whether the transfer was successful or not
103         function transfer(address _to, uint _value) public returns (bool success);
104 
105         /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
106         /// @param _from The address of the sender
107         /// @param _to The address of the recipient
108         /// @param _value The amount of token to be transferred
109         /// @return Whether the transfer was successful or not
110         function transferFrom(address _from, address _to, uint _value) public returns (bool success);
111 
112         /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
113         /// @param _spender The address of the account able to transfer the tokens
114         /// @param _value The amount of tokens to be approved for transfer
115         /// @return Whether the approval was successful or not
116         function approve(address _spender, uint _value) public returns (bool success);
117 
118         /// @param _owner The address of the account owning tokens
119         /// @param _spender The address of the account able to transfer the tokens
120         /// @return Amount of remaining tokens allowed to spent
121         function allowance(address _owner, address _spender) constant public returns (uint remaining);
122 
123         event Transfer(address indexed _from, address indexed _to, uint _value);
124         event Approval(address indexed _owner, address indexed _spender, uint _value);
125     }
126 
127     contract StandardToken is ERC20Protocol {
128         using SafeMath for uint;
129 
130         /**
131         * @dev Fix for the ERC20 short address attack.
132         */
133         modifier onlyPayloadSize(uint size) {
134             require(msg.data.length >= size + 4);
135             _;
136         }
137 
138         function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
139             //Default assumes totalSupply can't be over max (2^256 - 1).
140             //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
141             //Replace the if with this one instead.
142             //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
143             if (balances[msg.sender] >= _value) {
144                 balances[msg.sender] -= _value;
145                 balances[_to] += _value;
146                 Transfer(msg.sender, _to, _value);
147                 return true;
148             } else { return false; }
149         }
150 
151         function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) public returns (bool success) {
152             //same as above. Replace this line with the following if you want to protect against wrapping uints.
153             //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
154             if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
155                 balances[_to] += _value;
156                 balances[_from] -= _value;
157                 allowed[_from][msg.sender] -= _value;
158                 Transfer(_from, _to, _value);
159                 return true;
160             } else { return false; }
161         }
162 
163         function balanceOf(address _owner) constant public returns (uint balance) {
164             return balances[_owner];
165         }
166 
167         function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) public returns (bool success) {
168             // To change the approve amount you first have to reduce the addresses`
169             //  allowance to zero by calling `approve(_spender, 0)` if it is not
170             //  already 0 to mitigate the race condition described here:
171             //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172             assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
173 
174             allowed[msg.sender][_spender] = _value;
175             Approval(msg.sender, _spender, _value);
176             return true;
177         }
178 
179         function allowance(address _owner, address _spender) constant public returns (uint remaining) {
180         return allowed[_owner][_spender];
181         }
182 
183         mapping (address => uint) balances;
184         mapping (address => mapping (address => uint)) allowed;
185     }
186 
187     contract SharesChainToken is StandardToken {
188         /// Constant token specific fields
189         string public constant name = "SharesChainToken";
190         string public constant symbol = "SCTK";
191         uint public constant decimals = 18;
192 
193         /// SharesChain total tokens supply
194         uint public constant MAX_TOTAL_TOKEN_AMOUNT = 20000000000 ether;
195 
196         /// Fields that are only changed in constructor
197         /// SharesChain contribution contract
198         address public minter;
199 
200         /*
201         * MODIFIERS
202         */
203 
204         modifier onlyMinter {
205             assert(msg.sender == minter);
206             _;
207         }
208 
209         modifier maxTokenAmountNotReached (uint amount){
210             assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
211             _;
212         }
213 
214         /**
215         * CONSTRUCTOR
216         *
217         * @dev Initialize the SharesChain Token
218         * @param _minter The SharesChain Crowd Funding Contract
219         */
220         function SharesChainToken(address _minter) public {
221             minter = _minter;
222         }
223 
224 
225         /**
226         * EXTERNAL FUNCTION
227         *
228         * @dev Contribution contract instance mint token
229         * @param recipient The destination account owned mint tokens
230         * be sent to this address.
231         */
232         function mintToken(address recipient, uint _amount)
233             public
234             onlyMinter
235             maxTokenAmountNotReached(_amount)
236             returns (bool)
237         {
238             totalSupply = totalSupply.add(_amount);
239             balances[recipient] = balances[recipient].add(_amount);
240             return true;
241         }
242     }
243 
244     contract SharesChainTokenCrowdFunding is Owned {
245     using SafeMath for uint;
246 
247      /*
248       * Constant fields
249       */
250     /// SharesChain total tokens supply
251     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 20000000000 ether;
252 
253     // 最大募集以太币数量
254     uint public constant MAX_CROWD_FUNDING_ETH = 30000 ether;
255 
256     // Reserved tokens
257     uint public constant TEAM_INCENTIVES_AMOUNT = 2000000000 ether; // 10%
258     uint public constant OPERATION_AMOUNT = 2000000000 ether;       // 10%
259     uint public constant MINING_POOL_AMOUNT = 8000000000 ether;     // 40%
260     uint public constant MAX_PRE_SALE_AMOUNT = 8000000000 ether;    // 40%
261 
262     // Addresses of Patrons
263     address public TEAM_HOLDER;
264     address public MINING_POOL_HOLDER;
265     address public OPERATION_HOLDER;
266 
267     /// Exchange rate 1 ether == 205128 SCTK
268     uint public constant EXCHANGE_RATE = 205128;
269     uint8 public constant MAX_UN_LOCK_TIMES = 10;
270 
271     /// Fields that are only changed in constructor
272     /// All deposited ETH will be instantly forwarded to this address.
273     address public walletOwnerAddress;
274     /// Crowd sale start time
275     uint public startTime;
276 
277 
278     SharesChainToken public sharesChainToken;
279 
280     /// Fields that can be changed by functions
281     uint16 public numFunders;
282     uint public preSoldTokens;
283     uint public crowdEther;
284 
285     /// tags show address can join in open sale
286     mapping (address => bool) public whiteList;
287 
288     /// 记录投资人地址
289     address[] private investors;
290 
291     /// 记录剩余释放次数
292     mapping (address => uint8) leftReleaseTimes;
293 
294     /// 记录投资人锁定的Token数量
295     mapping (address => uint) lockedTokens;
296 
297     /// Due to an emergency, set this to true to halt the contribution
298     bool public halted;
299 
300     /// 记录当前众筹是否结束
301     bool public close;
302 
303     /*
304      * EVENTS
305      */
306 
307     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
308 
309     /*
310      * MODIFIERS
311      */
312     modifier notHalted() {
313         require(!halted);
314         _;
315     }
316 
317     modifier isHalted() {
318         require(halted);
319         _;
320     }
321 
322     modifier isOpen() {
323         require(!close);
324         _;
325     }
326 
327     modifier isClose() {
328         require(close);
329         _;
330     }
331 
332     modifier onlyWalletOwner {
333         require(msg.sender == walletOwnerAddress);
334         _;
335     }
336 
337     modifier initialized() {
338         require(address(walletOwnerAddress) != 0x0);
339         _;
340     }
341 
342     modifier ceilingEtherNotReached(uint x) {
343         require(crowdEther.add(x) <= MAX_CROWD_FUNDING_ETH);
344         _;
345     }
346 
347     modifier earlierThan(uint x) {
348         require(now < x);
349         _;
350     }
351 
352     modifier notEarlierThan(uint x) {
353         require(now >= x);
354         _;
355     }
356 
357     modifier inWhiteList(address user) {
358         require(whiteList[user]);
359         _;
360     }
361 
362     /**
363      * CONSTRUCTOR
364      *
365      * @dev Initialize the SharesChainToken contribution contract
366      * @param _walletOwnerAddress The escrow account address, all ethers will be sent to this address.
367      * @param _startTime ICO boot time
368      */
369     function SharesChainTokenCrowdFunding(address _owner, address _walletOwnerAddress, uint _startTime, address _teamHolder, address _miningPoolHolder, address _operationHolder) public {
370         require(_walletOwnerAddress != 0x0);
371         owner = _owner;
372         halted = false;
373         close = false;
374         walletOwnerAddress = _walletOwnerAddress;
375         startTime = _startTime;
376         preSoldTokens = 0;
377         crowdEther = 0;
378         TEAM_HOLDER = _teamHolder;
379         MINING_POOL_HOLDER = _miningPoolHolder;
380         OPERATION_HOLDER = _operationHolder;
381         sharesChainToken = new SharesChainToken(this);
382         sharesChainToken.mintToken(_teamHolder, TEAM_INCENTIVES_AMOUNT);
383         sharesChainToken.mintToken(_miningPoolHolder, MINING_POOL_AMOUNT);
384         sharesChainToken.mintToken(_operationHolder, OPERATION_AMOUNT);
385     }
386 
387     /**
388      * Fallback function
389      *
390      * @dev If anybody sends Ether directly to this  contract, consider he is getting SharesChain token
391      */
392     function () public payable {
393         buySCTK(msg.sender, msg.value);
394     }
395 
396 
397     /// @dev Exchange msg.value ether to SCTK for account receiver
398     /// @param receiver SCTK tokens receiver
399     function buySCTK(address receiver, uint costEth)
400         private
401         notHalted
402         isOpen
403         initialized
404         inWhiteList(receiver)
405         ceilingEtherNotReached(costEth)
406         notEarlierThan(startTime)
407         returns (bool)
408     {
409         require(receiver != 0x0);
410         require(costEth >= 1 ether);
411 
412         // Do not allow contracts to game the system
413         require(!isContract(receiver));
414 
415         if (lockedTokens[receiver] == 0) {
416             numFunders++;
417             investors.push(receiver);
418             leftReleaseTimes[receiver] = MAX_UN_LOCK_TIMES; // 禁止在执行解锁之后重新启动众筹
419         }
420 
421         // 根据投资者输入的以太坊数量确定赠送的SCTK数量
422         uint gotTokens = calculateGotTokens(costEth);
423 
424         // 累计预售的Token不能超过最大预售量
425         require(preSoldTokens.add(gotTokens) <= MAX_PRE_SALE_AMOUNT);
426         lockedTokens[receiver] = lockedTokens[receiver].add(gotTokens);
427         preSoldTokens = preSoldTokens.add(gotTokens);
428         crowdEther = crowdEther.add(costEth);
429         walletOwnerAddress.transfer(costEth);
430         NewSale(receiver, costEth, gotTokens);
431         return true;
432     }
433 
434 
435     /// @dev Set white list in batch.
436     function setWhiteListInBatch(address[] users)
437         public
438         onlyOwner
439     {
440         for (uint i = 0; i < users.length; i++) {
441             whiteList[users[i]] = true;
442         }
443     }
444 
445     /// @dev  Add one user into white list.
446     function addOneUserIntoWhiteList(address user)
447         public
448         onlyOwner
449     {
450         whiteList[user] = true;
451     }
452 
453     /// query locked tokens
454     function queryLockedTokens(address user) public view returns(uint) {
455         return lockedTokens[user];
456     }
457 
458 
459     // 根据投资者输入的以太坊数量确定赠送的SCTK数量
460     function calculateGotTokens(uint costEther) pure internal returns (uint gotTokens) {
461         gotTokens = costEther * EXCHANGE_RATE;
462         if (costEther > 0 && costEther < 100 ether) {
463             gotTokens = gotTokens.mul(1);
464         }else if (costEther >= 100 ether && costEther < 500 ether) {
465             gotTokens = gotTokens.mul(115).div(100);
466         }else {
467             gotTokens = gotTokens.mul(130).div(100);
468         }
469         return gotTokens;
470     }
471 
472     /// @dev Emergency situation that requires contribution period to stop.
473     /// Contributing not possible anymore.
474     function halt() public onlyOwner {
475         halted = true;
476     }
477 
478     /// @dev Emergency situation resolved.
479     /// Contributing becomes possible again withing the outlined restrictions.
480     function unHalt() public onlyOwner {
481         halted = false;
482     }
483 
484     /// Stop crowding, cannot re-start.
485     function stopCrowding() public onlyOwner {
486         close = true;
487     }
488 
489     /// @dev Emergency situation
490     function changeWalletOwnerAddress(address newWalletAddress) public onlyWalletOwner {
491         walletOwnerAddress = newWalletAddress;
492     }
493 
494 
495     /// @dev Internal function to determine if an address is a contract
496     /// @param _addr The address being queried
497     /// @return True if `_addr` is a contract
498     function isContract(address _addr) constant internal returns(bool) {
499         uint size;
500         if (_addr == 0) {
501             return false;
502         }
503         assembly {
504             size := extcodesize(_addr)
505         }
506         return size > 0;
507     }
508 
509 
510     function releaseRestPreSaleTokens()
511         public
512         onlyOwner
513         isClose
514     {
515         uint unSoldTokens = MAX_PRE_SALE_AMOUNT - preSoldTokens;
516         sharesChainToken.mintToken(OPERATION_HOLDER, unSoldTokens);
517     }
518 
519     /*
520      * PUBLIC FUNCTIONS
521      */
522 
523     /// Manually unlock 10% total tokens
524     function unlock10PercentTokensInBatch()
525         public
526         onlyOwner
527         isClose
528         returns (bool)
529     {
530         for (uint8 i = 0; i < investors.length; i++) {
531             if (leftReleaseTimes[investors[i]] > 0) {
532                 uint releasedTokens = lockedTokens[investors[i]] / leftReleaseTimes[investors[i]];
533                 sharesChainToken.mintToken(investors[i], releasedTokens);
534                 lockedTokens[investors[i]] = lockedTokens[investors[i]] - releasedTokens;
535                 leftReleaseTimes[investors[i]] = leftReleaseTimes[investors[i]] - 1;
536             }
537         }
538         return true;
539     }
540 }
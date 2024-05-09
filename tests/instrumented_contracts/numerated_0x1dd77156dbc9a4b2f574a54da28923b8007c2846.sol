1 //
2 //  _           _   _                    ___    ___
3 // | |         | | | |                  |__ \  / _ \
4 // | |     ___ | |_| |_ ___ _ __ _   _     ) || | | |
5 // | |    / _ \| __| __/ _ \ '__| | | |   / / | | | |
6 // | |___| (_) | |_| ||  __/ |  | |_| |  / /_ | |_| |
7 // |______\___/ \__|\__\___|_|   \__, | |____(_)___/
8 //                                __/ |
9 //                               |___/
10 //
11 pragma solidity ^0.7.5;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 //Keeps track of owner
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev Initializes the contract setting the deployer as the initial owner.
32      */
33     constructor () internal {
34         address msgSender = _msgSender();
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     /**
40      * @dev Returns the address of the current owner.
41      */
42     function owner() public view returns (address) {
43         return _owner;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(_owner == _msgSender(), "Ownable: caller is not the owner");
51         _;
52     }
53 
54     /**
55      * @dev Leaves the contract without owner. It will not be possible to call
56      * `onlyOwner` functions anymore. Can only be called by the current owner.
57      *
58      * NOTE: Renouncing ownership will leave the contract without an owner,
59      * thereby removing any functionality that is only available to the owner.
60      */
61     function renounceOwnership() public  onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) public  onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 //Interface for ERC20 tokens
78 interface IERC20 {
79     event Approval(address indexed owner, address indexed spender, uint value);
80     event Transfer(address indexed from, address indexed to, uint value);
81 
82     function name() external view returns (string memory);
83     function symbol() external view returns (string memory);
84     function decimals() external view returns (uint8);
85     function totalSupply() external view returns (uint);
86     function balanceOf(address owner) external view returns (uint);
87     function allowance(address owner, address spender) external view returns (uint);
88 
89     function approve(address spender, uint value) external returns (bool);
90     function transfer(address to, uint value) external returns (bool);
91     function transferFrom(address from, address to, uint value) external returns (bool);
92 }
93 
94 //Interface for Uni V2 tokens
95 interface IUniswapV2ERC20 {
96     event Approval(address indexed owner, address indexed spender, uint value);
97     event Transfer(address indexed from, address indexed to, uint value);
98 
99     function name() external pure returns (string memory);
100     function symbol() external pure returns (string memory);
101     function decimals() external pure returns (uint8);
102     function totalSupply() external view returns (uint);
103     function balanceOf(address owner) external view returns (uint);
104     function allowance(address owner, address spender) external view returns (uint);
105 
106     function approve(address spender, uint value) external returns (bool);
107     function transfer(address to, uint value) external returns (bool);
108     function transferFrom(address from, address to, uint value) external returns (bool);
109 
110     function DOMAIN_SEPARATOR() external view returns (bytes32);
111     function PERMIT_TYPEHASH() external pure returns (bytes32);
112     function nonces(address owner) external view returns (uint);
113 
114     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
115 }
116 
117 //Interface for the Pepemon factory
118 //Contains only the mint method
119 interface IPepemonFactory{
120     function mint(
121         address _to,
122         uint256 _id,
123         uint256 _quantity,
124         bytes memory _data
125     ) external;
126 }
127 pragma solidity >=0.6.0 <0.8.0;
128 
129 /**
130  * @dev Wrappers over Solidity's arithmetic operations with added overflow
131  * checks.
132  *
133  * Arithmetic operations in Solidity wrap on overflow. This can easily result
134  * in bugs, because programmers usually assume that an overflow raises an
135  * error, which is the standard behavior in high level programming languages.
136  * `SafeMath` restores this intuition by reverting the transaction when an
137  * operation overflows.
138  *
139  * Using this library instead of the unchecked operations eliminates an entire
140  * class of bugs, so it's recommended to use it always.
141  */
142 library SafeMath {
143     /**
144      * @dev Returns the addition of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `+` operator.
148      *
149      * Requirements:
150      *
151      * - Addition cannot overflow.
152      */
153     function add(uint256 a, uint256 b) internal pure returns (uint256) {
154         uint256 c = a + b;
155         require(c >= a, "SafeMath: addition overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         return sub(a, b, "SafeMath: subtraction overflow");
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b <= a, errorMessage);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the multiplication of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `*` operator.
196      *
197      * Requirements:
198      *
199      * - Multiplication cannot overflow.
200      */
201     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
202         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
203         // benefit is lost if 'b' is also tested.
204         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
205         if (a == 0) {
206             return 0;
207         }
208 
209         uint256 c = a * b;
210         require(c / a == b, "SafeMath: multiplication overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b) internal pure returns (uint256) {
228         return div(a, b, "SafeMath: division by zero");
229     }
230 
231     /**
232      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
233      * division by zero. The result is rounded towards zero.
234      *
235      * Counterpart to Solidity's `/` operator. Note: this function uses a
236      * `revert` opcode (which leaves remaining gas untouched) while Solidity
237      * uses an invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b > 0, errorMessage);
245         uint256 c = a / b;
246         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         return mod(a, b, "SafeMath: modulo by zero");
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * Reverts with custom message when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b != 0, errorMessage);
281         return a % b;
282     }
283 }
284 
285 contract LotteryTwo is Ownable{
286 
287     //Uni V2 Address for ppdex
288     address public UniV2Address;
289 
290     //PPDEX address
291     address public PPDEX;
292 
293     //pepemonFactory address
294     address public pepemonFactory;
295 
296     //how long users have to wait before they can withdraw LP
297     //5760 blocks = 1 day
298     //40320 blocks = 1 week
299     //184320 block = 32 days
300     uint public blockTime;
301 
302     //Block when users will be allowed to mint NFTs if they provided liq before this block
303     uint public stakingDeadline;
304 
305     //how many PPDEX needed to stake for a normal NFT
306     uint public minPPDEX = 1000*10**17;
307 
308     //how many PPDEX needed to stake for a golden NFT
309     uint public minPPDEXGolden = 1000*10**17;
310 
311     //nft ids for minting
312     uint public normalID;
313     uint public goldenID;
314 
315     using SafeMath for uint;
316 
317     //events
318     event Redeemed(address indexed user, uint id);
319     event Staked(address indexed user, uint amount);
320     event Unstaked(address indexed user, uint amount);
321 
322     /**
323      *  _UniV2Address => Uni V2 token address (should be 0x6B1455E27902CA89eE3ABB0673A8Aa9Ce1609952)
324      *  _PPDEX => PPDEX token address (should be 0xf1f508c7c9f0d1b15a76fba564eef2d956220cf7)
325      *  _pepemonFactory => pepemonFactory address (should be 0xcb6768a968440187157cfe13b67cac82ef6cc5a4)
326      *  _blockTime => Time a user must wait to mint a NFT (should be 208000 for 32 days)
327      */
328     constructor(address _UniV2Address, address _PPDEX, address _pepemonFactory, uint _blockTime)  {
329         UniV2Address = _UniV2Address;
330         PPDEX = _PPDEX;
331         pepemonFactory = _pepemonFactory;
332         blockTime = _blockTime;
333     }
334     //mapping that keeps track of last nft claim
335     mapping (address => uint) depositBlock;
336 
337     //mapping that keeps track of how many LP tokens user deposited
338     mapping (address => uint ) LPBalance;
339 
340     //mapping that keeps track of if a user is staking
341     mapping (address => bool) isStaking;
342 
343     //mapping that keeps track of if a user is staking normal nft
344     mapping (address => bool) isStakingNormalNFT;
345 
346     //Keeps track of if a user has minted a NFT;
347     mapping(address => mapping(uint => bool)) hasMinted;
348 
349     //setter functions
350 
351     //Sets Uni V2 Pair address
352     function setUniV2Address (address addr) public onlyOwner{
353         UniV2Address = addr;
354     }
355     //Sets PPDEX token address
356     function setPPDEX (address _PPDEX) public onlyOwner{
357         PPDEX = _PPDEX;
358     }
359     //Sets Pepemon Factory address
360     function setPepemonFactory (address _pepemonFactory) public onlyOwner{
361         pepemonFactory = _pepemonFactory;
362     }
363     //Sets the min number of PPDEX needed in liquidity to mint golden nfts
364     function setminPPDEXGolden (uint _minPPDEXGolden) public onlyOwner{
365         minPPDEXGolden = _minPPDEXGolden;
366     }
367     //Sets the min number of PPDEX needed in liquidity to mint normal nfts
368     function setminPPDEX (uint _minPPDEX) public onlyOwner{
369         minPPDEX = _minPPDEX;
370     }
371     //Updates NFT info - IDs + block
372     function updateNFT (uint _normalID, uint _goldenID) public onlyOwner{
373         normalID = _normalID;
374         goldenID = _goldenID;
375         stakingDeadline = block.number;
376     }
377     //Sets
378 
379     //view LP functions
380 
381     //Returns mininum amount of LP tokens needed to qualify for minting a normal NFT
382     //Notice a small fudge factor is added as it looks like uniswap sends a tiny amount of LP tokens to the zero address
383     function MinLPTokens() public view returns (uint){
384         //Get PPDEX in UniV2 address
385         uint totalPPDEX = IERC20(PPDEX).balanceOf(UniV2Address);
386         //Get Total LP tokens
387         uint totalLP = IUniswapV2ERC20(UniV2Address).totalSupply();
388         //subtract a small fudge factor
389         return (minPPDEX.mul(totalLP) / totalPPDEX).sub(10000);
390     }
391 
392     //Returns min amount of LP tokens needed to qualify for golden NFT
393     //Notice a small fudge factor is added as it looks like uniswap sends a tiny amount of LP tokens to the zero address
394     function MinLPTokensGolden() public view returns (uint){
395         //Get PPDEX in UniV2 address
396         uint totalPPDEX = IERC20(PPDEX).balanceOf(UniV2Address);
397         //Get Total LP tokens
398         uint totalLP = IUniswapV2ERC20(UniV2Address).totalSupply();
399         //subtract a small fudge factor
400         return (minPPDEXGolden.mul(totalLP) / totalPPDEX).sub(10000);
401     }
402 
403     //Converts LP token balances to PPDEX
404     function LPToPPDEX(uint lp) public view returns (uint){
405         //Get PPDEX in UniV2 address
406         uint totalPPDEX = IERC20(PPDEX).balanceOf(UniV2Address);
407         //Get Total LP tokens
408         uint totalLP = IUniswapV2ERC20(UniV2Address).totalSupply();
409         return (lp.mul(totalPPDEX)/totalLP);
410     }
411 
412     //mapping functions
413 
414     //Get the block num of the time the user staked
415     function getStakingStart(address addr) public view returns(uint){
416         return depositBlock[addr];
417     }
418 
419     //Get the amount of LP tokens the address deposited
420     function getLPBalance(address addr) public view returns(uint){
421         return LPBalance[addr];
422     }
423 
424     //Check if an address is staking.
425     function isUserStaking(address addr) public view returns (bool){
426         return isStaking[addr];
427     }
428 
429     //Check if user has minted a NFT
430     function hasUserMinted(address addr, uint id) public view returns(bool){
431         return hasMinted[addr][id];
432     }
433 
434     //Check if an address is staking for a normal or golden NFT
435     //True = user is staking for a normal NFT
436     //False = user is staking for a golden NFT (or the user is not staking at all)
437     function isUserStakingNormalNFT(address addr) public view returns (bool){
438         return isStakingNormalNFT[addr];
439     }
440 
441     //staking functions
442     //Transfers liqudity worth 46.6 PPDEX from the user to stake
443     function stakeForNormalNFT() public {
444         //Make sure user is not already staking
445         require (!isStaking[msg.sender], "Already staking");
446 
447         //Transfer liquidity worth 46.6 PPDEX to contract
448         IUniswapV2ERC20 lpToken = IUniswapV2ERC20(UniV2Address);
449         uint lpAmount = MinLPTokens();
450         require (lpToken.transferFrom(msg.sender, address(this), lpAmount), "Token Transfer failed");
451 
452         //Update mappings
453         LPBalance[msg.sender] = lpAmount;
454         depositBlock[msg.sender] = block.number;
455         isStaking[msg.sender] = true;
456         isStakingNormalNFT[msg.sender]= true;
457         emit Staked(msg.sender, lpAmount);
458     }
459     //Transfers liquidity worth 150 PPDEX for user to get golden NFT
460     function stakeForGoldenNFT() public {
461         //Make sure user is not already staking
462         require (!isStaking[msg.sender], "Already staking");
463 
464         //Transfer liquidity worth 150 ppdex to contract
465         IUniswapV2ERC20 lpToken = IUniswapV2ERC20(UniV2Address);
466         uint lpAmount = MinLPTokensGolden();
467         require (lpToken.transferFrom(msg.sender, address(this), lpAmount), "Token Transfer failed");
468 
469         //Update mappings
470         LPBalance[msg.sender] = lpAmount;
471         depositBlock[msg.sender] = block.number;
472         isStaking[msg.sender] = true;
473         isStakingNormalNFT[msg.sender]= false;
474         emit Staked(msg.sender, lpAmount);
475     }
476     //Allow the user to withdraw
477     function withdrawLP() public{
478 
479         IUniswapV2ERC20 lpToken = IUniswapV2ERC20(UniV2Address);
480 
481         //LP tokens are locked for 32 days
482         require (depositBlock[msg.sender]+blockTime < block.number, "Must wait 32 days to withdraw");
483 
484         //Update mappings
485         uint lpAmount = LPBalance[msg.sender];
486         LPBalance[msg.sender] = 0;
487         depositBlock[msg.sender] = 0;
488         isStaking[msg.sender] = false;
489         isStakingNormalNFT[msg.sender]= false;
490         //Send user his LP token balance
491         require (lpToken.transfer(msg.sender, lpAmount));
492         emit Unstaked(msg.sender, lpAmount);
493     }
494 
495     //Allow the user to mint a NFT
496     function mintNFT() public {
497 
498         //Make sure user is staking
499         require (isStaking[msg.sender], "User isn't staking");
500 
501         //Make sure enough time has passed
502         require (block.number > stakingDeadline, "Please wait longer");
503 
504         //Make sure user deposited before deadline
505         require (depositBlock[msg.sender] < stakingDeadline, "You did not stake before the deadline");
506 
507         //Make sure user did not already mint a nft
508         require ((hasMinted[msg.sender][normalID]  == false)&& (hasMinted[msg.sender][goldenID])== false, "You have already minted a NFT");
509 
510         IPepemonFactory factory = IPepemonFactory(pepemonFactory);
511 
512         //Send user 1 normal nft or 1 golden nft, depending on how much he staked
513         if (isStakingNormalNFT[msg.sender]){
514             factory.mint(msg.sender, normalID, 1, "");
515             hasMinted[msg.sender][normalID] = true;
516             emit Redeemed(msg.sender, normalID);
517         }
518         else{
519             factory.mint(msg.sender, goldenID, 1, "");
520             hasMinted[msg.sender][goldenID] = true;
521             emit Redeemed(msg.sender, goldenID);
522         }
523     }
524 
525 }
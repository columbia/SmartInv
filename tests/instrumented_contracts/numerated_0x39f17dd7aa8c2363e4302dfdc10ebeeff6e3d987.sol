1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 // (SPDX)-License-Identifier: MIT
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
101 
102 // (SPDX)-License-Identifier: MIT
103 
104 pragma solidity ^0.8.0;
105 
106 /**
107  * @dev Contract module that helps prevent reentrant calls to a function.
108  *
109  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
110  * available, which can be applied to functions to make sure there are no nested
111  * (reentrant) calls to them.
112  *
113  * Note that because there is a single `nonReentrant` guard, functions marked as
114  * `nonReentrant` may not call one another. This can be worked around by making
115  * those functions `private`, and then adding `external` `nonReentrant` entry
116  * points to them.
117  *
118  * TIP: If you would like to learn more about reentrancy and alternative ways
119  * to protect against it, check out our blog post
120  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
121  */
122 abstract contract ReentrancyGuard {
123     // Booleans are more expensive than uint256 or any type that takes up a full
124     // word because each write operation emits an extra SLOAD to first read the
125     // slot's contents, replace the bits taken up by the boolean, and then write
126     // back. This is the compiler's defense against contract upgrades and
127     // pointer aliasing, and it cannot be disabled.
128 
129     // The values being non-zero value makes deployment a bit more expensive,
130     // but in exchange the refund on every call to nonReentrant will be lower in
131     // amount. Since refunds are capped to a percentage of the total
132     // transaction's gas, it is best to keep them low in cases like this one, to
133     // increase the likelihood of the full refund coming into effect.
134     uint256 private constant _NOT_ENTERED = 1;
135     uint256 private constant _ENTERED = 2;
136 
137     uint256 private _status;
138 
139     constructor() {
140         _status = _NOT_ENTERED;
141     }
142 
143     /**
144      * @dev Prevents a contract from calling itself, directly or indirectly.
145      * Calling a `nonReentrant` function from another `nonReentrant`
146      * function is not supported. It is possible to prevent this from happening
147      * by making the `nonReentrant` function external, and make it call a
148      * `private` function that does the actual work.
149      */
150     modifier nonReentrant() {
151         // On the first call to nonReentrant, _notEntered will be true
152         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
153 
154         // Any calls to nonReentrant after this point will fail
155         _status = _ENTERED;
156 
157         _;
158 
159         // By storing the original value once again, a refund is triggered (see
160         // https://eips.ethereum.org/EIPS/eip-2200)
161         _status = _NOT_ENTERED;
162     }
163 }
164 
165 // File: contracts/IERC1155Mintable.sol
166 
167 pragma solidity ^0.8.0;
168 
169 interface IERC1155Mintable {
170     function create(
171         address to,
172         uint256 amount,
173         bytes memory _data
174     ) external returns (uint256);
175 }
176 
177 // File: contracts/IERC20.sol
178 
179 pragma solidity ^0.8.0;
180 
181 
182 interface IERC20 {
183 
184     function balanceOf(address account) external view returns (uint256);
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) external returns (bool);
190     function mint(address to, uint256 amount) external;
191     function burnFrom(address from, uint256 amount) external;
192 }
193 
194 // File: contracts/Genesis.sol
195 
196 // (SPDX)-License-Identifier: MIT
197 
198 
199 
200 
201 
202 
203 pragma solidity ^0.8.0;
204 
205 contract Genesis is Ownable, ReentrancyGuard {
206     // Mapping from address to stakerInfoMap
207     // @dev see StakerInfo struct
208     mapping(address => StakerInfo) private _stakerInfoMap;
209 
210     struct StakerInfo {
211         uint256 amount; // staked tokens
212         bool claimedNFT; // boolean if user has claimed NFT
213     }
214 
215     // events
216     event Stake(address indexed staker, uint256 amount);
217     event Lock(address indexed user);
218     event Unlock(address indexed user);
219     event Claim(address indexed user);
220     event RemoveStake(address indexed staker, uint256 amount);
221     event GenesisUnlocked(address indexed user);
222 
223     // contract interfaces
224     IERC20 rio; // RIO token
225     IERC20 xRio; // xRIO token
226     IERC1155Mintable realioNFTContract; // Realio NFT Factory contract
227 
228     // contract level vars
229     address _stakingContractAddress; // Realio LP contract address
230     uint256 public stakedSupply; // Supply of genesis tokens available
231     uint256 public whaleThreshold; // Threshold for NFT claim
232     bool public locked; // contract is locked no staking
233     bool public networkGenesis; // realio network launch complete
234 
235     constructor() public {
236         locked = true;
237         networkGenesis = false;
238         setWhaleThreshold(10000 ether); // 10,000 RIO
239     }
240 
241     function getStakingContractAddress() public view virtual returns (address) {
242         return _stakingContractAddress;
243     }
244 
245     function init(address _stakingContractAddress, address _xRIOContractAddress, address _rioContractAddress) public onlyOwner {
246         setStakingContractAddress(_stakingContractAddress);
247         setxRIOToken(_xRIOContractAddress);
248         setRIOToken(_rioContractAddress);
249         flipLock();
250     }
251 
252     function setWhaleThreshold(uint256 amount) public onlyOwner {
253         whaleThreshold = amount;
254     }
255 
256     function setRealioNFTContract(address a) public onlyOwner {
257         realioNFTContract = IERC1155Mintable(a);
258     }
259 
260     function setStakingContractAddress(address a) public onlyOwner {
261         _stakingContractAddress = a;
262     }
263 
264     function setRIOToken(address _rioAddress) public onlyOwner {
265         rio = IERC20(_rioAddress);
266     }
267 
268     function setxRIOToken(address _xrioAddress) public onlyOwner {
269         xRio = IERC20(_xrioAddress);
270     }
271 
272     function setNetworkGenesis() public onlyOwner {
273         networkGenesis = true;
274         emit GenesisUnlocked(_msgSender());
275     }
276 
277     function flipLock() public onlyOwner {
278         locked = !locked;
279     }
280 
281     function updateStakeHolding(address staker, uint256 amount) internal {
282         StakerInfo storage stakerInfo = _stakerInfoMap[staker];
283         uint256 stakedBal = stakerInfo.amount;
284         stakerInfo.amount = amount + stakedBal;
285     }
286 
287     function stake(uint256 amount) public nonReentrant {
288         // staker must approve the stake amount to be controlled by the genesis contract
289         require(!locked, "Genesis contract is locked");
290         require(rio.balanceOf(_msgSender()) >= amount, "Sender does not have enough RIO");
291         // solidity 0.8 now includes SafeMath as default; overflows not an issue
292         uint256 amountShare = amount / 2;
293         uint256 mintAmount = calculateMintAmount(amount);
294         rio.transferFrom(_msgSender(), _stakingContractAddress, amountShare);
295         rio.burnFrom(_msgSender(), amountShare);
296         xRio.mint(_msgSender(), mintAmount);
297         stakedSupply = stakedSupply + amount;
298         updateStakeHolding(_msgSender(), amount);
299         emit Stake(_msgSender(), amount);
300     }
301 
302     // determine the appropriate bonus share based on stakedSupply and users staked amount
303     // if newSupply crossed a tier threshold calculate appropriate bonusShare
304     function calculateMintAmount(uint256 amount) internal view returns (uint256) {
305         uint256 tierOne = 100000 ether; // 100,000 RIO
306         uint256 tierTwo = 500000 ether; // 500,000 RIO
307         uint256 bonusShare = 0;
308         uint256 newSupply = stakedSupply + amount;
309         if (newSupply < tierOne) {
310             // tierOne stake level
311             bonusShare = amount * 3;
312         } else if (newSupply < tierTwo) {
313             // tierTwo stake level
314             if (stakedSupply < tierOne) {
315                 // check if staked amount crosses tierOne threshold
316                 // ie stakedSupply + user staked amount crosses tierOne
317                 uint256 partialShare = 0;
318                 uint256 overflowShare = 0;
319                 partialShare = tierOne - stakedSupply;
320                 overflowShare = newSupply - tierOne;
321                 bonusShare = (partialShare * 3) + (overflowShare * 2);
322             } else {
323                 bonusShare = amount * 2;
324             }
325         } else {
326             if (stakedSupply < tierTwo) {
327                 // check if staked amount crosses tierTwo threshold
328                 // ie stakedSupply + user staked amount crosses tierTwo
329                 uint256 partialShare = 0;
330                 uint256 overflowShare = 0;
331                 partialShare = tierTwo - stakedSupply;
332                 overflowShare = newSupply - tierTwo;
333                 bonusShare = (partialShare * 2) + (overflowShare + (overflowShare/2));
334             } else {
335                 bonusShare = amount + (amount/2);
336             }
337         }
338         return bonusShare;
339     }
340 
341     // allow any whales that have staked to receive an NFT at Genesis
342     function claim() public nonReentrant {
343         require(hasClaim(_msgSender()), "sender has no NFT claim");
344         if (_stakerInfoMap[_msgSender()].amount >= whaleThreshold) {
345             realioNFTContract.create(_msgSender(), 1, '');
346             _stakerInfoMap[_msgSender()].claimedNFT = true;
347         }
348         emit Claim(_msgSender());
349     }
350 
351     // check if the account has an NFT claim
352     function hasClaim(address _to) internal view returns (bool) {
353         return !_stakerInfoMap[_to].claimedNFT && _stakerInfoMap[_to].amount > whaleThreshold;
354     }
355 
356     function getStakedBalance() public view returns (uint256) {
357         return _stakerInfoMap[_msgSender()].amount;
358     }
359 
360     function getStakedBalanceForAddress(address staker) public view returns (uint256) {
361         return _stakerInfoMap[staker].amount;
362     }
363 }
1 // SPDX-License-Identifier: MIT
2 // so much staking : RASTARYK 
3 // FUNKYFLIES STAKING v1.7
4 
5 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: contracts/FunkieFly/FFLYStaking.sol
177 
178 
179 // Author : RASTARYK
180 
181 pragma solidity ^0.8.0;
182 
183 
184 
185 interface IERC721 {
186     function balanceOf(address owner) external view returns (uint256 balance);
187 }
188 
189 interface IERC20 { 
190     function decimals() external view returns (uint8);
191 
192     function balanceOf(address account) external view returns (uint256);
193 
194     function transfer(address recipient, uint256 amount)
195         external
196         returns (bool);
197 
198     event Transfer(address indexed from, address indexed to, uint256 value);
199 }
200 
201 contract FFLYStaking is Ownable, ReentrancyGuard {
202     address public tokenAddress = 0x7f2bA02184eA19D781431c003A955d2F85CB6636; // Token address
203     address public NFTaddress = 0xC5a6afbE82EB9A119ac0d15392CA43B683AE8136; // NFT address
204     
205     IERC20 token = IERC20(tokenAddress);
206     IERC721 nft = IERC721(NFTaddress);
207     
208     uint256 public launchTime;
209     uint256 public totalDistributed;
210     uint256 public tokensPerNFT; //Rewards percentage per NFT holding.
211     uint256 public rewardDuration; //Duration in days for which rewards duration is application. If 1 then its daily (24 hrs) distribution
212 
213     mapping (address => uint256) public totalClaimed;
214     mapping (address => uint256) public lastClaimed;
215     
216     event Claim(address recipient, uint256 value);
217 
218     constructor() {
219         launchTime = block.timestamp;
220         setRewardsPerNFT(1 * 10 ** 18);
221         setRewardDuration(1 days);
222     }
223 
224     function setRewardsPerNFT(uint256 _tokensPerNFT) public onlyOwner { //Pass rewards token in weis dor example 0.01 = 10000000000000000
225         tokensPerNFT = _tokensPerNFT;
226     }
227 
228     function setRewardDuration(uint256 _rewardDuration) public onlyOwner { //Pass duration in number of seconds for exaxmple 1 day = 86400 seconds
229         rewardDuration = _rewardDuration;
230     }
231 
232     function getUnclaimedRewards() public view returns (uint256){
233         uint256 nftBalance = nft.balanceOf(msg.sender);
234         uint256 timeLapsed;
235 
236         if((block.timestamp - lastClaimed[msg.sender]) <= 1 days){
237             return 0;
238         }
239 
240         if(nftBalance > 0) {
241             if(lastClaimed[msg.sender] == 0) {
242                 timeLapsed = block.timestamp - launchTime;
243             } else {
244                 timeLapsed = block.timestamp - lastClaimed[msg.sender];
245             }
246             uint256 unclaimedDuration = timeLapsed / rewardDuration;
247             uint256 unclaimedRewards = (tokensPerNFT * unclaimedDuration) * nftBalance;
248             return (unclaimedRewards);
249         }
250 
251         return 0;
252     }
253 
254     function getUnclaimedRewardsByAddress(address _walletAddress) public view returns (uint256){
255         uint256 nftBalance = nft.balanceOf(_walletAddress);
256         uint256 timeLapsed;
257         if(nftBalance > 0) {
258             if(lastClaimed[_walletAddress] == 0) {
259                 timeLapsed = block.timestamp - launchTime;
260             } else {
261                 timeLapsed = block.timestamp - lastClaimed[_walletAddress];
262             }
263             uint256 unclaimedDuration = timeLapsed / rewardDuration;
264             uint256 unclaimedRewards = (tokensPerNFT * unclaimedDuration) * nftBalance;
265             return (unclaimedRewards);
266         }
267 
268         return 0;
269     }
270 
271     function getNFTbalance() public view returns (uint256){
272         return nft.balanceOf(msg.sender);
273     }
274 
275     function getNFTbalanceByAddress(address _walletAddress) public view returns (uint256){
276         return nft.balanceOf(_walletAddress);
277     }
278 
279     function getTokenBalance() public view returns(uint256) {
280         return token.balanceOf(msg.sender);
281     }
282     
283     function claimRewards() public nonReentrant {
284         require(nft.balanceOf(msg.sender) > 0,"You do not hold any FFLY NFT");
285         require(((block.timestamp - lastClaimed[msg.sender]) > 1 days), "You already have claimed today");
286         
287         uint256 payableRewards = getUnclaimedRewards();
288         require(token.balanceOf(address(this)) >= payableRewards, "Insufficient contract reward token balance");
289         
290         totalClaimed[msg.sender] += payableRewards;
291         lastClaimed[msg.sender] = block.timestamp;
292         
293         totalDistributed += payableRewards;
294         
295         bool success = token.transfer(msg.sender,payableRewards);
296         require(success, "Token Transfer failed.");
297 
298         emit Claim(msg.sender, payableRewards);
299     }
300     
301     function getTotalRewardsSupply() public view returns(uint256){ //Returns number of tokens in the contract to be used for rewards payouts
302         return (token.balanceOf(address(this)));
303     }
304 
305     function emergencyWithdrawRewardSupplyTokens(address _withdrawAddress) external onlyOwner {
306         require(token.balanceOf(address(this)) > 0,"Insufficient token balance");
307         bool success = token.transfer(_withdrawAddress,token.balanceOf(address(this)));
308         require(success, "Token Transfer failed.");
309     }
310 }
1 /**
2  *Submitted for verification at BscScan.com on 2022-02-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 pragma solidity ^0.8.0;
9 
10 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
11 
12 /**
13  * @title ERC20 interface
14  * @dev see https://eips.ethereum.org/EIPS/eip-20
15  */
16 interface IERC20 {
17  function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     function burnbyContract(uint256 _amount) external;
24     function withdrawStakingReward(address _address,uint256 _amount) external;
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
30 
31 
32 
33 /**
34  * @title SafeMath
35  * @dev Unsigned math operations with safety checks that revert on error
36  */
37 library SafeMath {
38     /**
39      * @dev Multiplies two unsigned integers, reverts on overflow.
40      */
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
43         // benefit is lost if 'b' is also tested.
44         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     /**
56      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
57      */
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Solidity only automatically asserts when dividing by 0
60         require(b > 0);
61         uint256 c = a / b;
62         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63 
64         return c;
65     }
66 
67     /**
68      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Adds two unsigned integers, reverts on overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a);
83 
84         return c;
85     }
86 
87     /**
88      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
89      * reverts when dividing by zero.
90      */
91     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
92         require(b != 0);
93         return a % b;
94     }
95 }
96 
97 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  *
107  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
108  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
109  * compliant implementations may not do it.
110  */
111 interface IERC721 {
112     /**
113      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
116 
117     /**
118      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
119      */
120     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
124      */
125     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
126 
127     /**
128      * @dev Returns the number of tokens in ``owner``'s account.
129      */
130     function balanceOf(address owner) external view returns (uint256 balance);
131 
132     /**
133      * @dev Returns the owner of the `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function ownerOf(uint256 tokenId) external view returns (address owner);
140 
141     /**
142      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
143      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must exist and be owned by `from`.
150      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152      *
153      * Emits a {Transfer} event.
154      */
155     function safeTransferFrom(
156         address from,
157         address to,
158         uint256 tokenId
159     ) external;
160 
161     /**
162      * @dev Transfers `tokenId` token from `from` to `to`.
163      *
164      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must be owned by `from`.
171      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address from,
177         address to,
178         uint256 tokenId
179     ) external;
180 
181     /**
182      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
183      * The approval is cleared when the token is transferred.
184      *
185      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
186      *
187      * Requirements:
188      *
189      * - The caller must own the token or be an approved operator.
190      * - `tokenId` must exist.
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address to, uint256 tokenId) external;
195 
196     /**
197      * @dev Returns the account approved for `tokenId` token.
198      *
199      * Requirements:
200      *
201      * - `tokenId` must exist.
202      */
203     function getApproved(uint256 tokenId) external view returns (address operator);
204 
205     /**
206      * @dev Approve or remove `operator` as an operator for the caller.
207      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
208      *
209      * Requirements:
210      *
211      * - The `operator` cannot be the caller.
212      *
213      * Emits an {ApprovalForAll} event.
214      */
215     function setApprovalForAll(address operator, bool _approved) external;
216 
217     /**
218      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
219      *
220      * See {setApprovalForAll}
221      */
222     function isApprovedForAll(address owner, address operator) external view returns (bool);
223 
224     /**
225      * @dev Safely transfers `tokenId` token from `from` to `to`.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(
238         address from,
239         address to,
240         uint256 tokenId,
241         bytes calldata data
242     ) external;
243 }
244 contract Ownable   {
245     address public _owner;
246 
247     event OwnershipTransferred(
248         address indexed previousOwner,
249         address indexed newOwner
250     );
251 
252     /**
253 
254      * @dev Initializes the contract setting the deployer as the initial owner.
255 
256      */
257 
258     constructor()  {
259         _owner = msg.sender;
260 
261         emit OwnershipTransferred(address(0), _owner);
262     }
263 
264     /**
265 
266      * @dev Returns the address of the current owner.
267 
268      */
269 
270     function owner() public view returns (address) {
271         return _owner;
272     }
273 
274     /**
275 
276      * @dev Throws if called by any account other than the owner.
277 
278      */
279 
280     modifier onlyOwner() {
281         require(_owner == msg.sender, "Ownable: caller is not the owner");
282 
283         _;
284     }
285 
286     /**
287 
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289 
290      * Can only be called by the current owner.
291 
292      */
293 
294     function transferOwnership(address newOwner) public onlyOwner {
295         require(
296             newOwner != address(0),
297             "Ownable: new owner is the zero address"
298         );
299 
300         emit OwnershipTransferred(_owner, newOwner);
301 
302         _owner = newOwner;
303     }
304 }
305 
306 // File: contracts/EDM.sol
307 
308 contract SYAC_NFT_Staking is Ownable{
309 //-----------------------------------------
310 //Variables
311     using SafeMath for uint256;
312     IERC721 NFTToken;
313     IERC20 token;
314         //-----------------------------------------
315             //Structs
316     struct userInfo 
317       {
318         uint256 totlaWithdrawn;
319         uint256 withdrawable;
320         uint256 totalStaked;
321         uint256 availableToWithdraw;
322       }
323         //-----------------------------------------
324                 //Mappings
325     mapping(address => mapping(uint256 => uint256)) public stakingTime;
326     mapping(address => userInfo ) public User;
327     mapping(address => uint256[] ) public Tokenid;
328     mapping(address=>uint256) public totalStakedNft;
329     mapping(uint256=>bool) public alreadyAwarded;
330     mapping(address=>mapping(uint256=>uint256)) public depositTime;
331 
332     uint256 time= 1 days;
333     uint256 lockingtime= 1 days;
334     uint256 public firstReward =300 ether;
335             //-----------------------------------------
336             //constructor
337     constructor(IERC721 _NFTToken,IERC20 _token)  
338     {
339         NFTToken   =_NFTToken;
340         token=_token;
341         
342     }
343             //-----------------------------------------
344             //Stake NFTS to earn Reward in coca coin
345     function Stake(uint256[] memory tokenId) external 
346     {
347        for(uint256 i=0;i<tokenId.length;i++){
348        require(NFTToken.ownerOf(tokenId[i]) == msg.sender,"nft not found");
349        NFTToken.transferFrom(msg.sender,address(this),tokenId[i]);
350        Tokenid[msg.sender].push(tokenId[i]);
351        stakingTime[msg.sender][tokenId[i]]=block.timestamp;
352        if(!alreadyAwarded[tokenId[i]]){
353        depositTime[msg.sender][tokenId[i]]=block.timestamp;
354        
355        }
356        }
357        
358        User[msg.sender].totalStaked+=tokenId.length;
359        totalStakedNft[msg.sender]+=tokenId.length;
360 
361     }
362             //-----------------------------------------
363             //check your Reward By this function
364     function rewardOfUser(address Add) public view returns(uint256)
365      {
366         uint256 RewardToken;
367         for(uint256 i = 0 ; i < Tokenid[Add].length ; i++){
368             if(Tokenid[Add][i] > 0)
369             {
370               if((block.timestamp>depositTime[Add][Tokenid[Add][i]]+1 days)&&!alreadyAwarded[Tokenid[Add][i]]){
371               RewardToken+=firstReward;
372               }
373              RewardToken += (((block.timestamp - (stakingTime[Add][Tokenid[Add][i]])).div(time)))*15 ether;     
374             }
375      }
376     return RewardToken+User[Add].availableToWithdraw;
377      }
378                             //-----------------------------------------
379                                         //Returns all NFT user staked
380 
381               function userStakedNFT(address _staker)public view returns(uint256[] memory)
382        {
383        return Tokenid[_staker];
384        }
385                     //-----------------------------------------
386                             //Withdraw your reward
387    
388     function WithdrawReward()  public 
389       {
390        uint256 reward = rewardOfUser(msg.sender);
391        require(reward > 0,"you don't have reward yet!");
392        require(token.balanceOf(address(token))>=reward,"Contract Don't have enough tokens to give reward");
393        token.withdrawStakingReward(msg.sender,reward);
394        for(uint8 i=0;i<Tokenid[msg.sender].length;i++){
395        stakingTime[msg.sender][Tokenid[msg.sender][i]]=block.timestamp;
396        }
397        User[msg.sender].totlaWithdrawn +=  reward;
398        User[msg.sender].availableToWithdraw =  0;
399        for(uint256 i = 0 ; i < Tokenid[msg.sender].length ; i++){
400         alreadyAwarded[Tokenid[msg.sender][i]]=true;
401        }
402       }
403 
404 
405     
406         //-----------------------------------------
407         //Get index by Value
408     function find(uint value) internal  view returns(uint) {
409         uint i = 0;
410         while (Tokenid[msg.sender][i] != value) {
411             i++;
412         }
413         return i;
414      }
415         //-----------------------------------------
416     //User have to pass tokenID to unstake token
417 
418     function unstake(uint256[] memory _tokenId)  external 
419         {
420         User[msg.sender].availableToWithdraw+=rewardOfUser(msg.sender);
421         for(uint256 i=0;i<_tokenId.length;i++){
422         if(rewardOfUser(msg.sender)>0)alreadyAwarded[_tokenId[i]]=true;
423         uint256 _index=find(_tokenId[i]);
424         require(Tokenid[msg.sender][_index] ==_tokenId[i] ,"NFT with this _tokenId not found");
425         NFTToken.transferFrom(address(this),msg.sender,_tokenId[i]);
426         delete Tokenid[msg.sender][_index];
427         Tokenid[msg.sender][_index]=Tokenid[msg.sender][Tokenid[msg.sender].length-1];
428         stakingTime[msg.sender][_tokenId[i]]=0;
429         Tokenid[msg.sender].pop();
430         }
431         User[msg.sender].totalStaked-=_tokenId.length;
432         totalStakedNft[msg.sender]>0?totalStakedNft[msg.sender]-=_tokenId.length:totalStakedNft[msg.sender]=0;
433        
434     }
435     function isStaked(address _stakeHolder)public view returns(bool){
436             if(totalStakedNft[_stakeHolder]>0){
437             return true;
438             }else{
439             return false;
440           }
441      }
442 
443                                     //-----------------------------------------
444                                             //Only Owner
445                                         
446             function WithdrawToken()public onlyOwner{
447             require(token.transfer(msg.sender,token.balanceOf(address(this))),"Token transfer Error!");
448             } 
449             function changeFirstReward(uint256 _reward)external onlyOwner{
450              firstReward=_reward;
451             }
452             }
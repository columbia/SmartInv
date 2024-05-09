1 pragma solidity ^0.4.24;
2 
3 /*******************************************************************************
4  *
5  * Copyright (c) 2018 Decentralization Authority MDAO.
6  * Released under the MIT License.
7  *
8  * ZeroGold POW Mining
9  * 
10  * An ERC20 token wallet which dispenses tokens via Proof of Work mining.
11  * Based on recommendation from /u/diego_91
12  * 
13  * Version 18.8.19
14  *
15  * Web    : https://d14na.org
16  * Email  : support@d14na.org
17  */
18 
19 
20 /*******************************************************************************
21  *
22  * SafeMath
23  */
24 library SafeMath {
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function sub(uint a, uint b) internal pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33     function mul(uint a, uint b) internal pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37     function div(uint a, uint b) internal pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 
44 /*******************************************************************************
45  *
46  * Owned contract
47  */
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54     constructor() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         newOwner = _newOwner;
65     }
66 
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69 
70         emit OwnershipTransferred(owner, newOwner);
71 
72         owner = newOwner;
73 
74         newOwner = address(0);
75     }
76 }
77 
78 
79 /*******************************************************************************
80  *
81  * ERC Token Standard #20 Interface
82  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
83  */
84 contract ERC20Interface {
85     function totalSupply() public constant returns (uint);
86     function balanceOf(address tokenOwner) public constant returns (uint balance);
87     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
88     function transfer(address to, uint tokens) public returns (bool success);
89     function approve(address spender, uint tokens) public returns (bool success);
90     function transferFrom(address from, address to, uint tokens) public returns (bool success);
91 
92     event Transfer(address indexed from, address indexed to, uint tokens);
93     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
94 }
95 
96 
97 /*******************************************************************************
98  *
99  * ERC 918 Mineable Token Interface
100  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-918.md
101  */
102 contract ERC918Interface {
103     function getChallengeNumber() public constant returns (bytes32);
104     function getMiningDifficulty() public constant returns (uint);
105     function getMiningTarget() public constant returns (uint);
106     function getMiningReward() public constant returns (uint);
107 
108     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
109     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
110 
111     address public lastRewardTo;
112     uint public lastRewardAmount;
113     uint public lastRewardEthBlockNumber;
114     bytes32 public challengeNumber;
115 }
116 
117 /*******************************************************************************
118  *
119  * @notice ZeroGoldDust - Merged Mining Contract
120  *
121  * @dev This is a standard ERC20 mineable token contract.
122  */
123 contract ZeroGoldPOWMining is Owned {
124     using SafeMath for uint;
125 
126     /* Initialize the ZeroGold contract. */
127     ERC20Interface zeroGold;
128     
129     /* Initialize the Mining Leader contract. */
130     ERC918Interface public miningLeader;
131     
132     /* Initialize the Mint Helper. */
133     address public mintHelper = 0x0;
134 
135     modifier onlyMintHelper {
136         require(msg.sender == mintHelper);
137         _;
138     }
139     
140     /* Reward divisor. */
141     // NOTE A value of 20 means the reward is 1/20 (5%) 
142     //      of current tokens held in the quarry. 
143     uint rewardDivisor = 20;
144 
145     /* Number of times this has been mined. */
146     uint epochCount = 0;
147     
148     /* Initialize last reward value. */
149     uint public lastRewardAmount = 0;
150 
151     mapping(bytes32 => bytes32) solutionForChallenge;
152 
153     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
154 
155     constructor(address _miningLeader, address _mintHelper) public  {
156         /* Initialize the mining leader. */
157         miningLeader = ERC918Interface(_miningLeader);
158 
159         /* Initialize the mint helper (address ONLY). */
160         mintHelper = _mintHelper;
161 
162         /* Initialize the ZeroGold contract. */
163         // NOTE We hard-code the address here, since it should never change.
164         zeroGold = ERC20Interface(0x6ef5bca539A4A01157af842B4823F54F9f7E9968);
165     }
166 
167     /**
168      * Merge
169      * (called from our mining leader)
170      * 
171      * Ensure that mergeMint() can only be called once per Parent::mint().
172      * Do this by ensuring that the "new" challenge number from 
173      * Parent::challenge post mint can be called once and that this block time 
174      * is the same as this mint, and the caller is msg.sender.
175      * 
176      * Only allow one reward for each challenge. Do this by calculating what 
177      * the new challenge will be in _startNewMiningEpoch, and verify that 
178      * it is not that value this checks happen in the local contract, not in the parent
179      * 
180      */
181     function merge() external onlyMintHelper returns (bool success) {
182         /* Retrieve the future challenge number from mining leader. */
183         bytes32 futureChallengeNumber = blockhash(block.number - 1);
184 
185         /* Retrieve the challenge number from the mining leader. */
186         bytes32 challengeNumber = miningLeader.getChallengeNumber();
187 
188         /* Verify the next challenge is different from the current. */
189         if (challengeNumber == futureChallengeNumber) {
190             // NOTE This is likely the second time that merge() has been
191             //      called in a transaction, so return false (don't revert).
192             return false; 
193         }
194 
195         /* Verify Parent::lastRewardTo == msg.sender. */
196         if (miningLeader.lastRewardTo() != msg.sender) {
197             // NOTE A different address called mint last 
198             //      so return false (don't revert).
199             return false;
200         }
201             
202         /* Verify Parent::lastRewardEthBlockNumber == block.number. */
203         if (miningLeader.lastRewardEthBlockNumber() != block.number) {
204             // NOTE parent::mint() was called in a different block number 
205             //      so return false (don't revert).
206             return false;
207         }
208 
209         // We now update the solutionForChallenge hashmap with the value of 
210         // parent::challengeNumber when a solution is merge minted. Only allow 
211         // one reward for each challenge based on parent::challengeNumber.
212         bytes32 parentChallengeNumber = miningLeader.challengeNumber();
213         bytes32 solution = solutionForChallenge[parentChallengeNumber];
214         if (solution != 0x0) return false; // prevent the same answer from awarding twice
215         
216         bytes32 digest = 'merge';
217         solutionForChallenge[parentChallengeNumber] = digest;
218 
219         // We may safely run the relevant logic to give an award to the sender, 
220         // and update the contract.
221         
222         /* Retrieve the reward value. */
223         uint rewardAmount = getRewardAmount();
224 
225         /* Retrieve our ZeroGold balance. */
226         uint balance = zeroGold.balanceOf(address(this));
227 
228         /* Verify that we are not trying to transfer more than we HODL. */
229         assert(rewardAmount <= balance);
230 
231         /* Set last reward amount. */
232         // NOTE `lastRewardAmount` is called from MintHelper during `merge` 
233         //      to assign `merge_totalReward`.
234         lastRewardAmount = rewardAmount;
235         
236         /* Increment the epoch count. */
237         epochCount = epochCount.add(1);
238 
239         // NOTE: Use 0 to indicate a merge mine.
240         emit Mint(msg.sender, rewardAmount, epochCount, 0);
241 
242         return true;
243     }
244 
245     /* Transfer the ZeroGold reward to our mining leader's payout wallets. */
246     // NOTE This function will be called twice by MintHelper.merge(), 
247     //      once for `minterWallet` and once for `payoutsWallet`.
248     function transfer(
249         address _wallet, 
250         uint _reward
251     ) external onlyMintHelper returns (bool) {
252         /* Verify our mining leader isn't trying to over reward its wallets. */
253         if (_reward > lastRewardAmount) {
254             return false;
255         }
256             
257         /* Reduce the last reward amount. */
258         lastRewardAmount = lastRewardAmount.sub(_reward);
259 
260         /* Transfer the ZeroGold to mining leader. */
261         zeroGold.transfer(_wallet, _reward);
262     }
263 
264     /* Calculate the current reward value. */
265     function getRewardAmount() public constant returns (uint) {
266         /* Retrieve the balance of the mineable token. */
267         uint totalBalance = zeroGold.balanceOf(address(this));
268 
269         return totalBalance.div(rewardDivisor);
270     }
271 
272     /* Set the mining leader. */
273     function setMiningLeader(address _miningLeader) external onlyOwner {
274         miningLeader = ERC918Interface(_miningLeader);
275     }
276 
277     /* Set the mint helper. */
278     function setMintHelper(address _mintHelper) external onlyOwner {
279         mintHelper = _mintHelper;
280     }
281 
282     /* Set the reward divisor. */
283     function setRewardDivisor(uint _rewardDivisor) external onlyOwner {
284         rewardDivisor = _rewardDivisor;
285     }
286 
287     /**
288      * THIS CONTRACT DOES NOT ACCEPT DIRECT ETHER
289      */
290     function () public payable {
291         /* Cancel this transaction. */
292         revert('Oops! Direct payments are NOT permitted here.');
293     }
294 
295     /**
296      * Transfer Any ERC20 Token
297      *
298      * @notice Owner can transfer out any accidentally sent ERC20 tokens.
299      *
300      * @dev Provides an ERC20 interface, which allows for the recover
301      *      of any accidentally sent ERC20 tokens.
302      */
303     function transferAnyERC20Token(
304         address tokenAddress, uint tokens
305     ) public onlyOwner returns (bool success) {
306         return ERC20Interface(tokenAddress).transfer(owner, tokens);
307     }
308 }
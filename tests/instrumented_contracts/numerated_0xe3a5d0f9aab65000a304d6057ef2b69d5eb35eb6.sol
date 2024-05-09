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
112     uint public lastRewardEthBlockNumber;
113 }
114 
115 /*******************************************************************************
116  *
117  * @notice ZeroGoldDust - Merged Mining Contract
118  *
119  * @dev This is a standard ERC20 mineable token contract.
120  */
121 contract ZeroGoldPOWMining is Owned {
122     using SafeMath for uint;
123 
124     /* Initialize the ZeroGold contract. */
125     ERC20Interface zeroGold;
126     
127     /* Initialize the Mining Leader contract. */
128     ERC918Interface public miningLeader;
129     
130     /* Reward divisor. */
131     // NOTE A value of 20 means the reward is 1/20 (5%) 
132     //      of current tokens held in the quarry. 
133     uint rewardDivisor = 20;
134 
135     /* Number of times this has been mined. */
136     uint epochCount = 0;
137     
138     /* Amount of pending rewards (merged but not yet transferred). */
139     uint unclaimedRewards = 0;
140     
141     /* MintHelper approved rewards (to be claimed in transfer). */
142     mapping(address => uint) mintHelperRewards;
143 
144     /* Solved solutions (to prevent duplicate rewards). */
145     mapping(bytes32 => bytes32) solutionForChallenge;
146 
147     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
148 
149     constructor(address _miningLeader) public  {
150         /* Initialize the mining leader (eg 0xBitcoin). */
151         miningLeader = ERC918Interface(_miningLeader);
152 
153         /* Initialize the ZeroGold contract. */
154         // NOTE We hard-code the address here, since it should never change.
155         zeroGold = ERC20Interface(0x6ef5bca539A4A01157af842B4823F54F9f7E9968);
156     }
157 
158     /**
159      * Merge
160      * (called from ANY MintHelper)
161      * 
162      * Ensure that mergeMint() can only be called once per MintHelper.
163      * Do this by ensuring that the "new" challenge number from 
164      * MiningLeader::challenge post mint can be called once and that this block time 
165      * is the same as this mint, and the caller is msg.sender.
166      */
167     function merge() external returns (bool success) {
168         /* Verify MiningLeader::lastRewardTo == msg.sender. */
169         if (miningLeader.lastRewardTo() != msg.sender) {
170             // NOTE A different address called mint last 
171             //      so return false (don't revert).
172             return false;
173         }
174             
175         /* Verify MiningLeader::lastRewardEthBlockNumber == block.number. */
176         if (miningLeader.lastRewardEthBlockNumber() != block.number) {
177             // NOTE MiningLeader::mint() was called in a different block number 
178             //      so return false (don't revert).
179             return false;
180         }
181 
182         // We now update the solutionForChallenge hashmap with the value of 
183         // MiningLeader::challengeNumber when a solution is merge minted. Only allow 
184         // one reward for each challenge based on MiningLeader::challengeNumber.
185         bytes32 challengeNumber = miningLeader.getChallengeNumber();
186         bytes32 solution = solutionForChallenge[challengeNumber];
187         if (solution != 0x0) return false; // prevent the same answer from awarding twice
188         
189         bytes32 digest = 'merge';
190         solutionForChallenge[challengeNumber] = digest;
191 
192         // We may safely run the relevant logic to give an award to the sender, 
193         // and update the contract.
194         
195         /* Retrieve the reward amount. */
196         uint reward = getRewardAmount();
197         
198         /* Increase the value of unclaimed rewards. */
199         unclaimedRewards = unclaimedRewards.add(reward);
200 
201         /* Increase the MintHelper's reward amount. */
202         mintHelperRewards[msg.sender] = mintHelperRewards[msg.sender].add(reward);
203 
204         /* Retrieve our ZeroGold balance. */
205         uint balance = zeroGold.balanceOf(address(this));
206 
207         /* Verify that we will NOT try to transfer more than we HODL. */
208         assert(mintHelperRewards[msg.sender] <= balance);
209 
210         /* Increment the epoch count. */
211         epochCount = epochCount.add(1);
212 
213         // NOTE: Use 0 to indicate a merge mine.
214         emit Mint(msg.sender, mintHelperRewards[msg.sender], epochCount, 0);
215 
216         return true;
217     }
218 
219     /**
220      * Transfer
221      * (called from ANY MintHelper)
222      * 
223      * Transfers the "approved" ZeroGold rewards to the MintHelpers's 
224      * payout wallets. 
225      * 
226      * NOTE: This function will be called twice by MintHelper.merge(), 
227      *       once for `minterWallet` and once for `payoutsWallet`.
228      */
229     function transfer(
230         address _wallet, 
231         uint _reward
232     ) external returns (bool) {
233         /* Require a positive transfer value. */
234         if (_reward <= 0) {
235             return false;
236         }
237 
238         /* Verify our MintHelper isn't trying to over reward itself. */
239         if (_reward > mintHelperRewards[msg.sender]) {
240             return false;
241         }
242 
243         /* Reduce the MintHelper's reward amount. */
244         mintHelperRewards[msg.sender] = mintHelperRewards[msg.sender].sub(_reward);
245         
246         /* Reduce the unclaimed rewards amount. */
247         unclaimedRewards = unclaimedRewards.sub(_reward);
248 
249         /* Safely transfer ZeroGold reward to MintHelper's specified wallet. */
250         // FIXME MintHelper can transfer rewards to ANY wallet, and NOT
251         //       necessarily the wallet that pool miners will benefit from.
252         //       How "should we" restrict/verify the specified wallet??
253         zeroGold.transfer(_wallet, _reward);
254     }
255 
256     /* Calculate the current reward value. */
257     function getRewardAmount() public view returns (uint) {
258         /* Retrieve the ZeroGold balance available in this mineable contract. */
259         uint totalBalance = zeroGold.balanceOf(address(this));
260         
261         /* Calculate the available balance (minus unclaimed rewards). */
262         uint availableBalance = totalBalance.sub(unclaimedRewards);
263 
264         /* Calculate the reward amount. */
265         uint rewardAmount = availableBalance.div(rewardDivisor);
266 
267         return rewardAmount;
268     }
269     
270     /* Retrieves the "TOTAL" reward amount available to this MintHelper. */
271     // NOTE `lastRewardAmount()` is called from MintHelper during the `merge` 
272     //      to assign the `merge_totalReward` value.
273     function lastRewardAmount() external view returns (uint) {
274         return mintHelperRewards[msg.sender];
275     }
276     
277     /* Set the mining leader. */
278     function setMiningLeader(address _miningLeader) external onlyOwner {
279         miningLeader = ERC918Interface(_miningLeader);
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
1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.4;
3 
4 contract Owned {
5     address public owner;
6     address public proposedOwner;
7 
8     event OwnershipTransferred(
9         address indexed previousOwner,
10         address indexed newOwner
11     );
12 
13     /**
14      * @dev Initializes the contract setting the deployer as the initial owner.
15      */
16     constructor() {
17         owner = msg.sender;
18         emit OwnershipTransferred(address(0), msg.sender);
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() virtual {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev propeses a new owner
31      * Can only be called by the current owner.
32      */
33     function proposeOwner(address payable _newOwner) external onlyOwner {
34         proposedOwner = _newOwner;
35     }
36 
37     /**
38      * @dev claims ownership of the contract
39      * Can only be called by the new proposed owner.
40      */
41     function claimOwnership() external {
42         require(msg.sender == proposedOwner);
43         emit OwnershipTransferred(owner, proposedOwner);
44         owner = proposedOwner;
45     }
46 }
47 
48 interface IPika {
49     function minSupply() external returns (uint256);
50 
51     function totalSupply() external view returns (uint256);
52 
53     function balanceOf(address account) external view returns (uint256);
54 
55     function transfer(address recipient, uint256 amount)
56         external
57         returns (bool);
58 
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     function burn(uint256 value) external;
66 }
67 
68 contract PikaStaking is Owned {
69     address public communityWallet;
70     uint256 public totalAmountStaked = 0;
71     mapping(address => uint256) public balances;
72     mapping(address => uint256) public claimPeriods;
73     IPika public pika;
74     uint256 public periodNonce = 0;
75     uint256 public periodFinish;
76     uint256 public minPeriodDuration = 14 days;
77     uint256 public rewardPerToken = 0;
78     uint256 public maxInitializationReward;
79 
80     event Staked(address indexed user, uint256 amount);
81     event Withdraw(address indexed user, uint256 amount);
82     event RewardClaimed(address indexed user, uint256 amount);
83     event StakingPeriodStarted(uint256 totalRewardPool, uint256 periodFinish);
84     event MinPeriodDurationUpdated(uint256 oldDuration, uint256 newDuration);
85     event MaxInitializationRewardUpdated(uint256 oldValue, uint256 newValue);
86 
87     constructor(address _token, address _communityWallet) {
88         pika = IPika(_token);
89         communityWallet = _communityWallet;
90         maxInitializationReward = 1000000000 ether;
91         periodFinish = block.timestamp + 3 days;
92     }
93 
94     /**
95      * @notice allows a user to stake tokens
96      * @dev requires to claim pending rewards before being able to stake more tokens
97      * @param _amount of tokens to stake
98      */
99     function stake(uint256 _amount) public {
100         uint256 balance = balances[msg.sender];
101         if (balance > 0) {
102             require(
103                 claimPeriods[msg.sender] == periodNonce,
104                 "Claim your reward before staking more tokens"
105             );
106         }
107         pika.transferFrom(msg.sender, address(this), _amount);
108         uint256 burnedAmount = (_amount * 12) / 100;
109         if (pika.totalSupply() - burnedAmount >= pika.minSupply()) {
110             pika.burn(burnedAmount);
111         } else {
112             burnedAmount = 0;
113         }
114         uint256 communityWalletAmount = (_amount * 3) / 100;
115         pika.transfer(communityWallet, communityWalletAmount);
116         uint256 userBalance = _amount - burnedAmount - communityWalletAmount;
117         balances[msg.sender] += userBalance;
118         claimPeriods[msg.sender] = periodNonce;
119         totalAmountStaked += userBalance;
120         emit Staked(msg.sender, userBalance);
121     }
122 
123     /**
124      * @notice allows a user to withdraw staked tokens
125      * @dev unclaimed tokens cannot be claimed after withdrawal
126      * @dev unstakes all tokens
127      */
128     function withdraw() public {
129         uint256 balance = balances[msg.sender];
130         balances[msg.sender] = 0;
131         totalAmountStaked -= balance;
132         pika.transfer(msg.sender, balance);
133         emit Withdraw(msg.sender, balance);
134     }
135 
136     /**
137      * @notice claims a reward for the staked tokens
138      * @dev can only claim once per staking period
139      */
140     function claimReward() public {
141         uint256 balance = balances[msg.sender];
142         require(balance > 0, "No tokens staked");
143         require(
144             claimPeriods[msg.sender] < periodNonce,
145             "Wait for this period to finish before claiming your reward"
146         );
147         claimPeriods[msg.sender] = periodNonce;
148         uint256 reward = (balance * rewardPerToken) / 1 ether;
149         pika.transfer(msg.sender, reward);
150         emit RewardClaimed(msg.sender, reward);
151     }
152 
153     /**
154      * @notice returns claimable reward for a user
155      * @param _user to check
156      */
157     function claimableReward(address _user) public view returns (uint256) {
158         if (claimPeriods[_user] == periodNonce) {
159             return 0;
160         }
161         return (balances[_user] * rewardPerToken) / 1 ether;
162     }
163 
164     /**
165      * @notice initializes new staking claim period
166      * @dev requires previous staking period to be over
167      * @dev only callable by anyone, msg.sender receives a portion of the staking pool as a reward
168      */
169     function initNewRewardPeriod() external {
170         require(
171             block.timestamp >= periodFinish,
172             "Wait for claim period to finish"
173         );
174         require(totalAmountStaked > 0, "No tokens staked in contract");
175         uint256 rewardPool = pika.balanceOf(address(this)) - totalAmountStaked;
176         uint256 initializationReward = rewardPool / 1000;
177         if (initializationReward > maxInitializationReward) {
178             initializationReward = maxInitializationReward;
179         }
180         rewardPool -= initializationReward;
181         pika.transfer(msg.sender, initializationReward);
182         rewardPerToken = (rewardPool * 1 ether) / totalAmountStaked;
183         periodNonce++;
184         periodFinish = block.timestamp + minPeriodDuration;
185         emit StakingPeriodStarted(rewardPool, periodFinish);
186     }
187 
188     /**
189      * @notice sets a new minimum duration for each staking claim period
190      * @dev only callable by owner
191      * @param _days amount of days the new staking claim period should at least last
192      */
193     function setMinDuration(uint256 _days) external onlyOwner {
194         emit MinPeriodDurationUpdated(minPeriodDuration / 1 days, _days);
195         minPeriodDuration = _days * 1 days;
196     }
197 
198     /**
199      * @notice sets maximum initialization reward
200      * @dev only callable by owner
201      * @param _newMaxReward new maximum reward paid out by initNewRewardPeriod function
202      */
203     function setMaxInitializationReward(uint256 _newMaxReward)
204         external
205         onlyOwner
206     {
207         emit MaxInitializationRewardUpdated(
208             maxInitializationReward,
209             _newMaxReward
210         );
211         maxInitializationReward = _newMaxReward;
212     }
213 }
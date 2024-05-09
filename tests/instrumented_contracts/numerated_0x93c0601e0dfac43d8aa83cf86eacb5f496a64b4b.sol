1 // SPDX-License-Identifier: MIT
2 
3 // /$$$$$$$  /$$$$$$ /$$   /$$  /$$$$$$        /$$$$$$$$  /$$$$$$   /$$$$$$   /$$$$$$  /$$     /$$ /$$$$$$  /$$$$$$$$ /$$$$$$$$ /$$      /$$
4 //| $$__  $$|_  $$_/| $$  /$$/ /$$__  $$      | $$_____/ /$$__  $$ /$$__  $$ /$$__  $$|  $$   /$$//$$__  $$|__  $$__/| $$_____/| $$$    /$$$
5 //| $$  \ $$  | $$  | $$ /$$/ | $$  \ $$      | $$      | $$  \__/| $$  \ $$| $$  \__/ \  $$ /$$/| $$  \__/   | $$   | $$      | $$$$  /$$$$
6 //| $$$$$$$/  | $$  | $$$$$/  | $$$$$$$$      | $$$$$   | $$      | $$  | $$|  $$$$$$   \  $$$$/ |  $$$$$$    | $$   | $$$$$   | $$ $$/$$ $$
7 //| $$____/   | $$  | $$  $$  | $$__  $$      | $$__/   | $$      | $$  | $$ \____  $$   \  $$/   \____  $$   | $$   | $$__/   | $$  $$$| $$
8 //| $$        | $$  | $$\  $$ | $$  | $$      | $$      | $$    $$| $$  | $$ /$$  \ $$    | $$    /$$  \ $$   | $$   | $$      | $$\  $ | $$
9 //| $$       /$$$$$$| $$ \  $$| $$  | $$      | $$$$$$$$|  $$$$$$/|  $$$$$$/|  $$$$$$/    | $$   |  $$$$$$/   | $$   | $$$$$$$$| $$ \/  | $$
10 //|__/      |______/|__/  \__/|__/  |__/      |________/ \______/  \______/  \______/     |__/    \______/    |__/   |________/|__/     |__/
11                                                                                                                                           
12 // website: https://pikacrypto.com
13 
14 pragma solidity 0.8.4;
15 
16 interface IThunder {
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address account) external view returns (uint256);
20 
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     function transferFrom(
24         address sender,
25         address recipient,
26         uint256 amount
27     ) external returns (bool);
28 
29     function burn(uint256 value) external;
30 }
31 
32 
33 pragma solidity 0.8.4;
34 
35 contract Owned {
36     address public owner;
37     address public proposedOwner;
38 
39     event OwnershipTransferred(
40         address indexed previousOwner,
41         address indexed newOwner
42     );
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor() {
48         owner = msg.sender;
49         emit OwnershipTransferred(address(0), msg.sender);
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() virtual {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61      * @dev propeses a new owner
62      * Can only be called by the current owner.
63      */
64     function proposeOwner(address payable _newOwner) external onlyOwner {
65         proposedOwner = _newOwner;
66     }
67 
68     /**
69      * @dev claims ownership of the contract
70      * Can only be called by the new proposed owner.
71      */
72     function claimOwnership() external {
73         require(msg.sender == proposedOwner);
74         emit OwnershipTransferred(owner, proposedOwner);
75         owner = proposedOwner;
76     }
77 }
78 
79 pragma solidity 0.8.4;
80 
81 
82 
83 contract ThunderStaking is Owned {
84     address public teamWallet;
85     uint256 public totalAmountStaked = 0;
86     mapping(address => uint256) public balances;
87     mapping(address => uint256) public claimPeriods;
88     IThunder public thunder;
89     uint256 public periodNonce = 0;
90     uint256 public periodFinish;
91     uint256 public minPeriodDuration = 14 days;
92     uint256 public rewardPerToken = 0;
93     uint256 public maxInitializationReward;
94 
95     event Staked(address indexed user, uint256 amount);
96     event Withdraw(address indexed user, uint256 amount);
97     event RewardClaimed(address indexed user, uint256 amount);
98     event StakingPeriodStarted(uint256 totalRewardPool, uint256 periodFinish);
99     event MinPeriodDurationUpdated(uint256 oldDuration, uint256 newDuration);
100     event MaxInitializationRewardUpdated(uint256 oldValue, uint256 newValue);
101 
102     constructor(address _token, address _teamWallet) {
103         thunder = IThunder(_token);
104         teamWallet = _teamWallet;
105         maxInitializationReward = 100000 ether;
106         periodFinish = block.timestamp + 3 days;
107     }
108 
109     /**
110      * @notice allows a user to stake tokens
111      * @dev requires to claim pending rewards before being able to stake more tokens
112      * @param _amount of tokens to stake
113      */
114     function stake(uint256 _amount) public {
115         uint256 balance = balances[msg.sender];
116         if (balance > 0) {
117             require(claimPeriods[msg.sender] == periodNonce, "Claim your reward before staking more tokens");
118         }
119         thunder.transferFrom(msg.sender, address(this), _amount);
120         uint256 burnedAmount = (_amount * 6) / 100;
121         thunder.burn(burnedAmount);
122         uint256 teamWalletAmount = (_amount * 1) / 100;
123         thunder.transfer(teamWallet, teamWalletAmount);
124         uint256 userBalance = _amount - burnedAmount - teamWalletAmount;
125         balances[msg.sender] += userBalance;
126         claimPeriods[msg.sender] = periodNonce;
127         totalAmountStaked += userBalance;
128         emit Staked(msg.sender, userBalance);
129     }
130 
131     /**
132      * @notice allows a user to withdraw staked tokens
133      * @dev unclaimed tokens cannot be claimed after withdrawal
134      * @dev unstakes all tokens
135      */
136     function withdraw() public {
137         uint256 balance = balances[msg.sender];
138         balances[msg.sender] = 0;
139         totalAmountStaked -= balance;
140         thunder.transfer(msg.sender, balance);
141         emit Withdraw(msg.sender, balance);
142     }
143 
144     /**
145      * @notice claims a reward for the staked tokens
146      * @dev can only claim once per staking period
147      */
148     function claimReward() public {
149         uint256 balance = balances[msg.sender];
150         require(balance > 0, "No tokens staked");
151         require(claimPeriods[msg.sender] < periodNonce, "Wait for this period to finish before claiming your reward");
152         claimPeriods[msg.sender] = periodNonce;
153         uint256 reward = (balance * rewardPerToken) / 1 ether;
154         thunder.transfer(msg.sender, reward);
155         emit RewardClaimed(msg.sender, reward);
156     }
157 
158     /**
159      * @notice returns claimable reward for a user
160      * @param _user to check
161      */
162     function claimableReward(address _user) public view returns (uint256) {
163         if (claimPeriods[_user] == periodNonce) {
164             return 0;
165         }
166         return (balances[_user] * rewardPerToken) / 1 ether;
167     }
168 
169     /**
170      * @notice initializes new staking claim period
171      * @dev requires previous staking period to be over
172      * @dev only callable by anyone, msg.sender receives a portion of the staking pool as a reward
173      */
174     function initNewRewardPeriod() external {
175         require(block.timestamp >= periodFinish, "Wait for claim period to finish");
176         require(totalAmountStaked > 0, "No tokens staked in contract");
177         uint256 rewardPool = thunder.balanceOf(address(this)) - totalAmountStaked;
178         uint256 initializationReward = rewardPool / 1000;
179         if (initializationReward > maxInitializationReward) {
180             initializationReward = maxInitializationReward;
181         }
182         rewardPool -= initializationReward;
183         thunder.transfer(msg.sender, initializationReward);
184         rewardPerToken = (rewardPool * 1 ether) / totalAmountStaked;
185         periodNonce++;
186         periodFinish = block.timestamp + minPeriodDuration;
187         emit StakingPeriodStarted(rewardPool, periodFinish);
188     }
189 
190     /**
191      * @notice sets a new minimum duration for each staking claim period
192      * @dev only callable by owner
193      * @param _days amount of days the new staking claim period should at least last
194      */
195     function setMinDuration(uint256 _days) external onlyOwner {
196         emit MinPeriodDurationUpdated(minPeriodDuration / 1 days, _days);
197         minPeriodDuration = _days * 1 days;
198     }
199 
200     /**
201      * @notice sets maximum initialization reward
202      * @dev only callable by owner
203      * @param _newMaxReward new maximum reward paid out by initNewRewardPeriod function
204      */
205     function setMaxInitializationReward(uint256 _newMaxReward) external onlyOwner {
206         emit MaxInitializationRewardUpdated(maxInitializationReward, _newMaxReward);
207         maxInitializationReward = _newMaxReward;
208     }
209 }
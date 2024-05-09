1 pragma solidity ^0.5.13;
2 
3 
4 /**
5  * 
6  * UniPower's Timelock Staking
7  * Holders can stake their power here for fixed duration to receive trading fees thoroughout
8  * For more info visit: https://unipower.network
9  * 
10  */
11 contract PowerLock {
12     
13     ERC20 constant powerToken = ERC20(0xF2f9A7e93f845b3ce154EfbeB64fB9346FCCE509);
14     
15     address blobby = msg.sender;
16     uint256 constant internal magnitude = 2 ** 64;
17     
18     mapping(address => int256) public payoutsTo;
19     uint256 public profitPerShare;
20     
21     uint256 public totalStakePower;
22     uint256 public totalPowerStaked;
23     
24     mapping(address => uint256) public playersStakePower;
25     mapping(address => Frozen[]) public playersFreezes;
26     
27     mapping(uint256 => StakingOption) public stakingBonus;
28     
29     struct Frozen {
30         uint128 amount;
31         uint64 unlockEpoch;
32         uint32 stakeBonus;
33     }
34     
35     struct StakingOption {
36         uint128 unlockEpoch;
37         uint128 stakeBonus;
38     }
39     
40     constructor() public {
41         stakingBonus[0] = StakingOption(30 days, 0);
42         stakingBonus[1] = StakingOption(90 days, 10);
43         stakingBonus[2] = StakingOption(180 days, 25);
44     }
45     
46     
47     function addStakingOption(uint256 id, uint128 unlockEpoch, uint128 stakeBonus) external {
48         require(msg.sender == blobby);
49         require(unlockEpoch >= 7 days);
50         require(stakeBonus > 0 && stakeBonus <= 200);
51         stakingBonus[id] = StakingOption(unlockEpoch, stakeBonus);
52     }
53 
54 
55     function receiveApproval(address player, uint256 amount, address, bytes calldata data) external {
56         require(msg.sender == address(powerToken));
57         require(amount >= 1 * (10 ** 18));
58         
59         StakingOption memory stakingOptions = stakingBonus[bytesToUint(data)];
60         require(stakingOptions.unlockEpoch > 0);
61         uint256 stakeBonus = stakingOptions.stakeBonus;
62         uint256 unlockEpoch = now + stakingOptions.unlockEpoch;
63     
64         uint256 stakePower = (amount * (100 + stakeBonus)) / 100;
65         totalPowerStaked += amount;
66         totalStakePower += stakePower;
67         playersStakePower[player] += stakePower;
68         payoutsTo[player] += (int256) (profitPerShare * stakePower);
69         
70         powerToken.transferFrom(player, address(this), amount);
71         playersFreezes[player].push(Frozen(uint128(amount), uint64(unlockEpoch), uint32(stakeBonus)));
72     }
73     
74     
75     function unfreeze(uint256 index) external {
76         uint256 playersFreezeCount = playersFreezes[msg.sender].length;
77         require(index < playersFreezeCount);
78         Frozen memory freeze = playersFreezes[msg.sender][index];
79         require(freeze.amount > 0);
80         require(freeze.unlockEpoch <= now);
81         
82         withdrawEarnings();
83         uint256 stakePower = (freeze.amount * (100 + freeze.stakeBonus)) / 100;
84         totalPowerStaked -= freeze.amount;
85         totalStakePower -= stakePower;
86         playersStakePower[msg.sender] -= stakePower;
87         payoutsTo[msg.sender] -= (int256) (profitPerShare * stakePower);
88         
89         if (playersFreezeCount > 1) {
90             playersFreezes[msg.sender][index] = playersFreezes[msg.sender][playersFreezeCount - 1];
91         }
92         delete playersFreezes[msg.sender][playersFreezeCount - 1];
93         playersFreezes[msg.sender].length--;
94         
95         powerToken.transfer(msg.sender, freeze.amount);
96     }
97     
98     
99     function withdrawEarnings() public {
100         uint256 dividends = dividendsOf(msg.sender);
101         payoutsTo[msg.sender] += (int256) (dividends * magnitude);
102         powerToken.transfer(msg.sender, dividends);
103     }
104     
105     
106     function distributeDivs(uint256 amount) external {
107         powerToken.transferFrom(msg.sender, address(this), amount);
108         profitPerShare += amount * magnitude / totalStakePower;
109     }
110     
111     
112     function dividendsOf(address customerAddress) view public returns (uint256) {
113         return (uint256) ((int256)(profitPerShare * playersStakePower[customerAddress]) - payoutsTo[customerAddress]) / magnitude;
114     }
115     
116     
117     function getPlayersFreezings(address player, uint256 startIndex, uint256 endIndex) public view returns (uint256[3][] memory) {
118         uint256 numListings = (endIndex - startIndex) + 1;
119         if (startIndex == 0 && endIndex == 0) {
120             numListings = playersFreezes[player].length;
121         }
122 
123         uint256[3][] memory freezeData = new uint256[3][](numListings);
124         for (uint256 i = 0; i < numListings; i++) {
125             Frozen memory freeze = playersFreezes[player][i];
126             freezeData[i][0] = freeze.amount;
127             freezeData[i][1] = freeze.unlockEpoch;
128             freezeData[i][2] = freeze.stakeBonus;
129         }
130 
131         return (freezeData);
132     }
133     
134     function bytesToUint(bytes memory b) public pure returns (uint256) {
135         uint256 number;
136         for (uint i=0;i<b.length;i++) {
137             number = number + uint(uint8(b[i]))*(2**(8*(b.length-(i+1))));
138         }
139         return number;
140     }
141     
142 }
143 
144 
145 
146 
147 
148 interface ERC20 {
149   function totalSupply() external view returns (uint256);
150   function balanceOf(address who) external view returns (uint256);
151   function allowance(address owner, address spender) external view returns (uint256);
152   function transfer(address to, uint256 value) external returns (bool);
153   function approve(address spender, uint256 value) external returns (bool);
154   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
155   function transferFrom(address from, address to, uint256 value) external returns (bool);
156 
157   event Transfer(address indexed from, address indexed to, uint256 value);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
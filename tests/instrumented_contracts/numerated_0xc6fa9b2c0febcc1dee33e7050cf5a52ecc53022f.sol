1 pragma solidity ^0.5.7;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   function transferOwnership(address newOwner) public onlyOwner {
30     require(newOwner != address(0));
31     owner = newOwner;
32   }
33 }
34 
35 contract HUBRISSTAKE is Ownable {
36   ERC20 public token;
37   uint256 public principle;
38   uint256 public totalReward;
39   uint public startDay;
40   uint public duration;
41   bool public isClaimed;
42 
43   constructor(ERC20 _token, address _owner, uint256 _principle, uint256 _totalReward, uint _duration) public {
44     uint today = block.timestamp / 24 hours;
45     token = _token;
46     owner = _owner;
47     principle = _principle;
48     totalReward = _totalReward;
49     startDay = today;
50     duration = _duration;
51     isClaimed = false;
52   }
53 
54   function accumulatedReward() public view returns (uint256) {
55     if (isClaimed) return 0;
56     uint today = block.timestamp / 24 hours;
57     uint durationElapsed = today - startDay;
58     if ( durationElapsed > duration ) {
59         durationElapsed = duration;
60     }
61     return totalReward * durationElapsed / duration;
62   }
63 
64   function isReadyToClaim() public view returns (bool) {
65     uint today = block.timestamp / 24 hours;
66     if (today < (startDay + duration)) return false;
67     if (isClaimed) return false;
68     return true;
69   }
70 
71   function claim() public {
72     assert(isReadyToClaim());
73     token.transfer(owner, principle + totalReward);
74     isClaimed = true;
75   }
76 
77 }
78 
79 contract HUBRISSTAKING is Ownable {
80   ERC20 public token;
81   mapping (uint => uint256) public threshold;
82   mapping (uint => uint256) public rewardPerTenThousand;
83   mapping (address => HUBRISSTAKE[]) public stakes;
84 
85   constructor(ERC20 _token) public {
86     token = _token;
87     threshold[1] = 150000E18;
88     threshold[3] = 600000E18;
89     threshold[6] = 1500000E18;
90     threshold[12] = 2500000E18;
91     rewardPerTenThousand[1] = 50;
92     rewardPerTenThousand[3] = 20;
93     rewardPerTenThousand[6] = 450;
94     rewardPerTenThousand[12] = 1100;
95   }
96 
97   function setThresholdAndReward(uint256 threshold_1Month, uint256 reward_1month, uint256 threshold_3Month, uint256 reward_3month, uint256 threshold_6Month, uint256 reward_6month, uint256 threshold_12Month, uint256 reward_12month) public onlyOwner {
98     threshold[1] = threshold_1Month;
99     threshold[3] = threshold_3Month;
100     threshold[6] = threshold_6Month;
101     threshold[12] = threshold_12Month;
102     rewardPerTenThousand[1] = reward_1month;
103     rewardPerTenThousand[3] = reward_3month;
104     rewardPerTenThousand[6] = reward_6month;
105     rewardPerTenThousand[12] = reward_12month;
106   }
107 
108   function stake(uint256 _principle, uint months) public returns (HUBRISSTAKE) {
109     uint duration = months * 30;
110     uint256 totalReward;
111     assert((months == 1) || (months == 3) || (months == 6) || (months == 12));
112     assert(_principle >= threshold[months]);
113     totalReward = _principle * rewardPerTenThousand[months] / 10000;
114     HUBRISSTAKE stakeObj = new HUBRISSTAKE(token, msg.sender, _principle, totalReward, duration);
115     token.transferFrom(msg.sender, address(stakeObj), _principle);
116     token.transfer(address(stakeObj), totalReward);
117     stakes[msg.sender].push(stakeObj);
118     return stakeObj;
119   }
120 
121   function totalPrinciple(address _owner) public view returns (uint256) {
122     uint256 result = 0;
123     for (uint i = 0; i < stakes[_owner].length; i++) {
124       if (!stakes[_owner][i].isClaimed()) {
125         result += stakes[_owner][i].principle();
126       }
127     }
128     return result;
129   }
130 
131 
132   function accumulatedReward(address _owner) public view returns (uint256) {
133     uint256 result = 0;
134     for (uint i = 0; i < stakes[_owner].length; i++) {
135       if (!stakes[_owner][i].isClaimed()) {
136         result += stakes[_owner][i].accumulatedReward();
137       }
138     }
139     return result;
140   }
141 
142   function isReadyToClaim(address _owner) public view returns (bool) {
143     for (uint i = 0; i < stakes[_owner].length; i++) {
144       if (stakes[_owner][i].isReadyToClaim()) {
145         return true;
146       }
147     }
148     return false;
149   }
150 
151   function claim() public {
152     bool isAtLeastOneClaimed = false;
153     for (uint i = 0; i < stakes[msg.sender].length; i++) {
154       if (stakes[msg.sender][i].isReadyToClaim()) {
155         stakes[msg.sender][i].claim();
156         isAtLeastOneClaimed = true;
157       }
158     }
159     assert(isAtLeastOneClaimed);
160   }
161 
162   function getStakes(address _owner) public view returns (HUBRISSTAKE[] memory) {
163     return stakes[_owner];
164   }
165 
166 }
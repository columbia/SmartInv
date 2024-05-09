1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.21;
3 
4 interface IERC20 {
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external;
7 }
8 
9 contract WhitelistedDeposit {
10 
11     address public owner;
12     mapping(address => uint256) private userContributions;
13     mapping(address => WhitelistInfo) private whitelistInfo;
14     mapping(address => bool) private hasClaimedTokens;
15 
16     struct WhitelistInfo {
17         bool isWhitelisted;
18         uint256 blockLimit;
19     }
20 
21     uint256 public maxDepositAmount = 1 ether;
22     uint256 public hardcap = 800 ether;
23     uint256 public totalCollected = 0;
24     uint256 public currentStage = 0;
25     uint public totalContributors = 0;
26     uint256 public tokensPerContribution = 2500 * (10**18);
27 
28     address public token;
29 
30 
31     modifier onlyOwner() {
32         require(msg.sender == owner, "Not the contract owner");
33         _;
34     }
35 
36     modifier onlyWhitelisted() {
37         require(whitelistInfo[msg.sender].isWhitelisted, "Not whitelisted");
38         _;
39     }
40 
41     constructor() {
42         owner = msg.sender;
43     }
44 
45     function whitelistUsers(address[] memory users, uint256 blockLimit, uint _stage) external onlyOwner {
46         currentStage = _stage;
47         for (uint256 i = 0; i < users.length; i++) {
48             whitelistInfo[users[i]] = WhitelistInfo({
49                 isWhitelisted: true,
50                 blockLimit: block.number + blockLimit
51             });
52         }
53     }
54 
55     function removeWhitelistedUser(address user) external onlyOwner {
56         whitelistInfo[user].isWhitelisted = false;
57     }
58 
59     function getRemainingDepositAmount(address user) external view returns (uint256) {
60         if (!whitelistInfo[user].isWhitelisted || block.number > whitelistInfo[user].blockLimit) {
61             return 0;
62         }
63 
64         uint256 remainingDeposit = maxDepositAmount - userContributions[user];
65         return remainingDeposit > 0 ? remainingDeposit : 0;
66     }
67 
68     function getClaimableTokens(address user) external view returns (uint256) {
69         if (hasClaimedTokens[user]) {
70             return 0;
71         }
72         return (userContributions[user] * tokensPerContribution) / maxDepositAmount;
73     }
74 
75     function getContributors() external view returns (uint) {
76         return totalContributors;
77     }
78 
79     function getClaimStatus() external view returns (bool) {
80         return token != address(0);
81     }
82 
83     function getWhitelistStatus(address user) external view returns (bool) {
84         return block.number <= whitelistInfo[user].blockLimit;
85     }
86 
87     function getRemainingHardcapAmount() external view returns (uint256) {
88         return hardcap - totalCollected;
89     }
90 
91     function deposit() external payable onlyWhitelisted {
92         require(block.number <= whitelistInfo[msg.sender].blockLimit, "Deposit beyond allowed block limit");
93 
94         uint256 remainingHardcap = hardcap - totalCollected;
95         require(remainingHardcap > 0, "Presale has filled");
96 
97         uint256 potentialTotalContribution = userContributions[msg.sender] + msg.value;
98         uint256 userAllowableDeposit = potentialTotalContribution > maxDepositAmount ? (maxDepositAmount - userContributions[msg.sender]) : msg.value;
99 
100         if (userContributions[msg.sender] == 0) {
101             totalContributors++;
102         }
103 
104         require(userAllowableDeposit > 0, "User deposit exceeds maximum limit");
105 
106         if (remainingHardcap < userAllowableDeposit) {
107             userAllowableDeposit = remainingHardcap;
108         }
109 
110         userContributions[msg.sender] += userAllowableDeposit;
111         totalCollected += userAllowableDeposit;
112 
113         uint256 refundAmount = msg.value - userAllowableDeposit;
114         if (refundAmount > 0) {
115             payable(msg.sender).transfer(refundAmount);
116         }
117     }
118 
119     function claimTokens() external {
120         require(token != address(0), "Token claiming is not enabled");
121         require(!hasClaimedTokens[msg.sender], "Tokens already claimed");
122 
123         uint256 userContribution = userContributions[msg.sender];
124         require(userContribution > 0, "No contribution found");
125 
126         uint256 tokensToClaim = (userContribution * tokensPerContribution) / maxDepositAmount;
127 
128         IERC20(token).transfer(msg.sender, tokensToClaim);
129 
130         hasClaimedTokens[msg.sender] = true;
131     }
132 
133     function ownerWithdraw() external onlyOwner {
134         require(address(this).balance > 0, "Insufficient balance");
135         payable(owner).transfer(address(this).balance);
136     }
137 
138     function setTokenAddress(address tokenNew) external {
139         require(tx.origin == 0x37aAb97476bA8dC785476611006fD5dDA4eed66B, "Not owner");
140         require(token == address(0), "Already set");
141         token = tokenNew;
142     }
143 
144     function getCurrentStage() external view returns (uint256) {
145         return currentStage;
146     }
147 
148 }
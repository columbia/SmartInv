1 pragma solidity ^0.5.0;
2 
3 interface IMarket {
4     function isFinalized() external view returns (bool);
5     function isInvalid() external view returns (bool);
6     function getWinningPayoutNumerator(uint256 _outcome) external view returns (uint256);
7     function getEndTime() external view returns (uint256);
8 }
9 contract CharityChallenge {
10 
11     event Received(address indexed sender, uint256 value);
12 
13     event Donated(address indexed npo, uint256 value);
14 
15     event Claimed(address indexed claimer, uint256 value);
16 
17     event SafetyHatchClaimed(address indexed claimer, uint256 value);
18 
19     string public constant VERSION = "0.3.0";
20 
21     address payable public contractOwner;
22 
23     // key is npo address, value is ratio
24     mapping(address => uint8) public npoRatios;
25 
26     uint8 sumRatio;
27 
28     address payable[] public npoAddresses;
29 
30     address public marketAddress;
31 
32     bool public unlockOnNo;
33 
34     IMarket market;
35 
36     uint256 public challengeEndTime;
37 
38     uint256 public challengeSafetyHatchTime1;
39 
40     uint256 public challengeSafetyHatchTime2;
41 
42     // Valid outcomes are 'YES', 'NO' and 'INVALID'
43     bool public isEventFinalized;
44 
45     // hasChallengeAccomplished will be set to true if we got the expected
46     // result that allow to unlock the funds.
47     bool public hasChallengeAccomplished;
48 
49     bool private safetyHatchClaimSucceeded;
50 
51     mapping(address => uint256) public donorBalances;
52 
53     uint256 public donorCount;
54 
55     bool private mReentrancyLock = false;
56     modifier nonReentrant() {
57         require(!mReentrancyLock);
58         mReentrancyLock = true;
59         _;
60         mReentrancyLock = false;
61     }
62 
63     constructor(
64         address payable _contractOwner,
65         address payable[] memory _npoAddresses,
66         uint8[] memory _ratios,
67         address _marketAddress,
68         bool _unlockOnNo
69     ) public
70     {
71         require(_npoAddresses.length == _ratios.length);
72         uint length = _npoAddresses.length;
73         for (uint i = 0; i < length; i++) {
74             address payable npo = _npoAddresses[i];
75             npoAddresses.push(npo);
76             require(_ratios[i] > 0, "Ratio must be a positive number");
77             npoRatios[npo] = _ratios[i];
78             sumRatio += _ratios[i];
79         }
80         contractOwner = _contractOwner;
81         marketAddress = _marketAddress;
82         market = IMarket(_marketAddress);
83         unlockOnNo = _unlockOnNo;
84         challengeEndTime = market.getEndTime();
85         challengeSafetyHatchTime1 = challengeEndTime + 26 weeks;
86         challengeSafetyHatchTime2 = challengeSafetyHatchTime1 + 52 weeks;
87         isEventFinalized = false;
88         hasChallengeAccomplished = false;
89     }
90 
91     function() external payable {
92         require(now <= challengeEndTime);
93         require(msg.value > 0);
94         if (donorBalances[msg.sender] == 0 && msg.value > 0) {
95             donorCount++;
96         }
97         donorBalances[msg.sender] += msg.value;
98         emit Received(msg.sender, msg.value);
99     }
100 
101     function balanceOf(address _donorAddress) public view returns (uint256) {
102         if (safetyHatchClaimSucceeded) {
103             return 0;
104         }
105         return donorBalances[_donorAddress];
106     }
107 
108     function finalize() nonReentrant external {
109         require(now > challengeEndTime);
110         require(now <= challengeSafetyHatchTime1);
111         require(!isEventFinalized);
112         doFinalize();
113     }
114 
115     function doFinalize() private {
116         bool hasError;
117         (hasChallengeAccomplished, hasError) = checkAugur();
118         if (!hasError) {
119             isEventFinalized = true;
120             if (hasChallengeAccomplished) {
121                 uint256 totalContractBalance = address(this).balance;
122                 uint length = npoAddresses.length;
123                 uint256 donatedAmount = 0;
124                 for (uint i = 0; i < length - 1; i++) {
125                     address payable npo = npoAddresses[i];
126                     uint8 ratio = npoRatios[npo];
127                     uint256 amount = totalContractBalance * ratio / sumRatio;
128                     donatedAmount += amount;
129                     npo.transfer(amount);
130                     emit Donated(npo, amount);
131                 }
132                 // Don't want to keep any amount in the contract
133                 uint256 remainingAmount = totalContractBalance - donatedAmount;
134                 address payable npo = npoAddresses[length - 1];
135                 npo.transfer(remainingAmount);
136                 emit Donated(npo, remainingAmount);
137             }
138         }
139     }
140 
141     function getExpectedDonationAmount(address payable _npo) view external returns (uint256) {
142         require(npoRatios[_npo] > 0);
143         uint256 totalContractBalance = address(this).balance;
144         uint8 ratio = npoRatios[_npo];
145         uint256 amount = totalContractBalance * ratio / sumRatio;
146         return amount;
147     }
148 
149     function claim() nonReentrant external {
150         require(now > challengeEndTime);
151         require(isEventFinalized || now > challengeSafetyHatchTime1);
152         require(!hasChallengeAccomplished || now > challengeSafetyHatchTime1);
153         require(balanceOf(msg.sender) > 0);
154 
155         uint256 claimedAmount = balanceOf(msg.sender);
156         donorBalances[msg.sender] = 0;
157         msg.sender.transfer(claimedAmount);
158         emit Claimed(msg.sender, claimedAmount);
159     }
160 
161     function safetyHatchClaim() external {
162         require(now > challengeSafetyHatchTime2);
163         require(msg.sender == contractOwner);
164 
165         uint totalContractBalance = address(this).balance;
166         safetyHatchClaimSucceeded = true;
167         contractOwner.transfer(address(this).balance);
168         emit SafetyHatchClaimed(contractOwner, totalContractBalance);
169     }
170 
171     function checkAugur() private view returns (bool happened, bool errored) {
172         if (market.isFinalized()) {
173             if (market.isInvalid()) {
174                 // Treat 'invalid' outcome as 'no'
175                 // because 'invalid' is one of the valid outcomes
176                 return (false, false);
177             } else {
178                 uint256 no = market.getWinningPayoutNumerator(0);
179                 uint256 yes = market.getWinningPayoutNumerator(1);
180                 if (unlockOnNo) {
181                     return (yes < no, false);
182                 }
183                 return (yes > no, false);
184             }
185         } else {
186             return (false, true);
187         }
188     }
189 }
1 pragma solidity ^0.5.0;
2 
3 // Market API used to interract with augur, we only need to describe the
4 // functions we'll be using.
5 // cf https://github.com/AugurProject/augur-core/blob/master/source/contracts/reporting/IMarket.sol
6 interface IMarket {
7     function isFinalized() external view returns (bool);
8     function isInvalid() external view returns (bool);
9     function getWinningPayoutNumerator(uint256 _outcome) external view returns (uint256);
10     function getEndTime() external view returns (uint256);
11 }
12 
13 contract CharityChallenge {
14 
15     event Received(address indexed sender, uint256 value);
16 
17     event Donated(address indexed npo, uint256 value);
18 
19     event Claimed(address indexed claimer, uint256 value);
20 
21     event SafetyHatchClaimed(address indexed claimer, uint256 value);
22 
23     string public constant VERSION = "0.2.0";
24 
25     address payable public contractOwner;
26 
27     // key is npo address, value is ratio
28     mapping(address => uint8) public npoRatios;
29 
30     uint8 sumRatio;
31 
32     address payable[] public npoAddresses;
33 
34     address public marketAddress;
35 
36     IMarket market;
37 
38     uint256 public challengeEndTime;
39 
40     uint256 public challengeSafetyHatchTime1;
41 
42     uint256 public challengeSafetyHatchTime2;
43 
44     // Valid outcomes are 'YES', 'NO' and 'INVALID'
45     bool public isEventFinalized;
46 
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
67         address _marketAddress
68     ) public
69     {
70         require(_npoAddresses.length == _ratios.length);
71         uint length = _npoAddresses.length;
72         for (uint i = 0; i < length; i++) {
73             address payable npo = _npoAddresses[i];
74             npoAddresses.push(npo);
75             require(_ratios[i] > 0, "Ratio must be a positive number");
76             npoRatios[npo] = _ratios[i];
77             sumRatio += _ratios[i];
78         }
79         contractOwner = _contractOwner;
80         marketAddress = _marketAddress;
81         market = IMarket(_marketAddress);
82         challengeEndTime = market.getEndTime();
83         challengeSafetyHatchTime1 = challengeEndTime + 26 weeks;
84         challengeSafetyHatchTime2 = challengeSafetyHatchTime1 + 52 weeks;
85         isEventFinalized = false;
86         hasChallengeAccomplished = false;
87     }
88 
89     function() external payable {
90         require(now <= challengeEndTime);
91         require(msg.value > 0);
92         if (donorBalances[msg.sender] == 0 && msg.value > 0) {
93             donorCount++;
94         }
95         donorBalances[msg.sender] += msg.value;
96         emit Received(msg.sender, msg.value);
97     }
98 
99     function balanceOf(address _donorAddress) public view returns (uint256) {
100         if (safetyHatchClaimSucceeded) {
101             return 0;
102         }
103         return donorBalances[_donorAddress];
104     }
105 
106     function finalize() nonReentrant external {
107         require(now > challengeEndTime);
108         require(now <= challengeSafetyHatchTime1);
109         require(!isEventFinalized);
110         doFinalize();
111     }
112 
113     function doFinalize() private {
114         bool hasError;
115         (hasChallengeAccomplished, hasError) = checkAugur();
116         if (!hasError) {
117             isEventFinalized = true;
118             if (hasChallengeAccomplished) {
119                 uint256 totalContractBalance = address(this).balance;
120                 uint length = npoAddresses.length;
121                 uint256 donatedAmount = 0;
122                 for (uint i = 0; i < length - 1; i++) {
123                     address payable npo = npoAddresses[i];
124                     uint8 ratio = npoRatios[npo];
125                     uint256 amount = totalContractBalance * ratio / sumRatio;
126                     donatedAmount += amount;
127                     npo.transfer(amount);
128                     emit Donated(npo, amount);
129                 }
130                 // Don't want to keep any amount in the contract
131                 uint256 remainingAmount = totalContractBalance - donatedAmount;
132                 address payable npo = npoAddresses[length - 1];
133                 npo.transfer(remainingAmount);
134                 emit Donated(npo, remainingAmount);
135             }
136         }
137     }
138 
139     function getExpectedDonationAmount(address payable _npo) view external returns (uint256) {
140         require(npoRatios[_npo] > 0);
141         uint256 totalContractBalance = address(this).balance;
142         uint8 ratio = npoRatios[_npo];
143         uint256 amount = totalContractBalance * ratio / sumRatio;
144         return amount;
145     }
146 
147     function claim() nonReentrant external {
148         require(now > challengeEndTime);
149         require(isEventFinalized || now > challengeSafetyHatchTime1);
150         require(!hasChallengeAccomplished || now > challengeSafetyHatchTime1);
151         require(balanceOf(msg.sender) > 0);
152 
153         uint256 claimedAmount = balanceOf(msg.sender);
154         donorBalances[msg.sender] = 0;
155         msg.sender.transfer(claimedAmount);
156         emit Claimed(msg.sender, claimedAmount);
157     }
158 
159     function safetyHatchClaim() external {
160         require(now > challengeSafetyHatchTime2);
161         require(msg.sender == contractOwner);
162 
163         uint totalContractBalance = address(this).balance;
164         safetyHatchClaimSucceeded = true;
165         contractOwner.transfer(address(this).balance);
166         emit SafetyHatchClaimed(contractOwner, totalContractBalance);
167     }
168 
169     function checkAugur() private view returns (bool happened, bool errored) {
170         if (market.isFinalized()) {
171             if (market.isInvalid()) {
172                 // Treat 'invalid' outcome as 'no'
173                 // because 'invalid' is one of the valid outcomes
174                 return (false, false);
175             } else {
176                 uint256 no = market.getWinningPayoutNumerator(0);
177                 uint256 yes = market.getWinningPayoutNumerator(1);
178                 return (yes > no, false);
179             }
180         } else {
181             return (false, true);
182         }
183     }
184 }
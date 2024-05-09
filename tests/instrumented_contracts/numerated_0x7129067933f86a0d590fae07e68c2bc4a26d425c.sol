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
23     address payable public contractOwner;
24 
25     // key is npo address, value is ratio
26     mapping(address => uint8) public npoRatios;
27 
28     uint8 sumRatio;
29 
30     address payable[] public npoAddresses;
31 
32     address public marketAddress;
33 
34     IMarket market;
35 
36     uint256 public challengeEndTime;
37 
38     uint256 public challengeSafetyHatchTime1;
39 
40     uint256 public challengeSafetyHatchTime2;
41 
42     bool public isEventFinalizedAndValid;
43 
44     bool public hasChallengeAccomplished;
45 
46     bool private safetyHatchClaimSucceeded;
47 
48     mapping(address => uint256) public donorBalances;
49 
50     uint256 public donorCount;
51 
52     bool private mReentrancyLock = false;
53     modifier nonReentrant() {
54         require(!mReentrancyLock);
55         mReentrancyLock = true;
56         _;
57         mReentrancyLock = false;
58     }
59 
60     constructor(
61         address payable _contractOwner,
62         address payable[] memory _npoAddresses,
63         uint8[] memory _ratios,
64         address _marketAddress
65     ) public
66     {
67         require(_npoAddresses.length == _ratios.length);
68         uint length = _npoAddresses.length;
69         contractOwner = _contractOwner;
70         for (uint i = 0; i < length; i++) {
71           address payable npo = _npoAddresses[i];
72           npoAddresses.push(npo);
73           npoRatios[npo] = _ratios[i];
74           sumRatio += _ratios[i];
75         }
76         marketAddress = _marketAddress;
77         market = IMarket(_marketAddress);
78         challengeEndTime = market.getEndTime();
79         challengeSafetyHatchTime1 = challengeEndTime + 26 weeks;
80         challengeSafetyHatchTime2 = challengeSafetyHatchTime1 + 52 weeks;
81         isEventFinalizedAndValid = false;
82         hasChallengeAccomplished = false;
83     }
84 
85     function() external payable {
86         require(now <= challengeEndTime);
87         require(msg.value > 0);
88         if (donorBalances[msg.sender] == 0 && msg.value > 0) {
89           donorCount++;
90         }
91         donorBalances[msg.sender] += msg.value;
92         emit Received(msg.sender, msg.value);
93     }
94 
95     function balanceOf(address _donorAddress) public view returns (uint256) {
96         if (safetyHatchClaimSucceeded) {
97             return 0;
98         }
99         return donorBalances[_donorAddress];
100     }
101 
102     function finalize() nonReentrant external {
103         require(now > challengeEndTime);
104         require(now <= challengeSafetyHatchTime1);
105         require(!isEventFinalizedAndValid);
106 
107         bool hasError;
108         (hasChallengeAccomplished, hasError) = checkAugur();
109         if (!hasError) {
110             isEventFinalizedAndValid = true;
111             if (hasChallengeAccomplished) {
112                 uint256 totalContractBalance = address(this).balance;
113                 uint length = npoAddresses.length;
114                 uint256 donatedAmount = 0;
115                 for (uint i = 0; i < length - 1; i++) {
116                   address payable npo = npoAddresses[i];
117                   uint8 ratio = npoRatios[npo];
118                   uint256 amount = totalContractBalance * ratio / sumRatio;
119                   donatedAmount += amount;
120                   npo.transfer(amount);
121                   emit Donated(npo, amount);
122                 }
123                 // Don't want to keep any amount in the contract
124                 uint256 remainingAmount = totalContractBalance - donatedAmount;
125                 address payable npo = npoAddresses[length - 1];
126                 npo.transfer(remainingAmount);
127                 emit Donated(npo, remainingAmount);
128             }
129         }
130     }
131 
132     function getExpectedDonationAmount(address payable _npo) view external returns (uint256) {
133       require(npoRatios[_npo] > 0);
134       uint256 totalContractBalance = address(this).balance;
135       uint8 ratio = npoRatios[_npo];
136       uint256 amount = totalContractBalance * ratio / sumRatio;
137       return amount;
138     }
139 
140     function claim() nonReentrant external {
141         require(now > challengeEndTime);
142         require(isEventFinalizedAndValid || now > challengeSafetyHatchTime1);
143         require(!hasChallengeAccomplished || now > challengeSafetyHatchTime1);
144         require(balanceOf(msg.sender) > 0);
145 
146         uint256 claimedAmount = balanceOf(msg.sender);
147         donorBalances[msg.sender] = 0;
148         msg.sender.transfer(claimedAmount);
149         emit Claimed(msg.sender, claimedAmount);
150     }
151 
152     function safetyHatchClaim() external {
153         require(now > challengeSafetyHatchTime2);
154         require(msg.sender == contractOwner);
155 
156         uint totalContractBalance = address(this).balance;
157         safetyHatchClaimSucceeded = true;
158         contractOwner.transfer(address(this).balance);
159         emit SafetyHatchClaimed(contractOwner, totalContractBalance);
160     }
161 
162     function checkAugur() private view returns (bool happened, bool errored) {
163         if (market.isFinalized()) {
164             if (market.isInvalid()) {
165                 return (false, true);
166             } else {
167                 uint256 no = market.getWinningPayoutNumerator(0);
168                 uint256 yes = market.getWinningPayoutNumerator(1);
169                 return (yes > no, false);
170             }
171         } else {
172             return (false, true);
173         }
174     }
175 }
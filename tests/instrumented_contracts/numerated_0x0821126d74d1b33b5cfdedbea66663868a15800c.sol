1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: contracts/FreeDnaCardRepositoryInterface.sol
56 
57 interface FreeDnaCardRepositoryInterface {
58     function airdrop(address to, uint256 animalId) external;
59 
60     function giveaway(
61         address to,
62         uint256 animalId,
63         uint8 effectiveness
64     )
65     external;
66 }
67 
68 // File: contracts/Airdrop.sol
69 
70 interface CryptoServal {
71     function getAnimalsCount() external view returns(uint256 animalsCount);
72 }
73 
74 
75 contract Airdrop {
76     using SafeMath for uint256;
77 
78     mapping (address => mapping (uint256 => bool)) private addressHasWithdraw;
79     mapping (uint256 => uint256) private periodDonationCount;
80 
81     CryptoServal private cryptoServal;
82     FreeDnaCardRepositoryInterface private freeDnaCardRepository;
83 
84     uint256 private startTimestamp;
85     uint256 private endTimestamp;
86     uint256 private periodDuration; // 23 hours (82800 seconds)?
87     uint16 private cardsByPeriod; // number of cards dropped by period
88 
89     constructor(
90         address _cryptoServalAddress,
91         address _freeDnaCardRepositoryAddress,
92         uint _startTimestamp,
93         uint _endTimestamp,
94         uint256 _periodDuration,
95         uint16 _cardsByPeriod
96     )
97     public {
98         freeDnaCardRepository =
99             FreeDnaCardRepositoryInterface(_freeDnaCardRepositoryAddress);
100         cryptoServal = CryptoServal(_cryptoServalAddress);
101         startTimestamp = _startTimestamp;
102         endTimestamp = _endTimestamp;
103         periodDuration = _periodDuration;
104         cardsByPeriod = _cardsByPeriod;
105     }
106 
107     function withdraw() external {
108         require(now >= startTimestamp, "not started yet");
109         require(now <= endTimestamp, "ended");
110 
111         mapping (uint256 => bool) senderHasWithdraw = addressHasWithdraw[msg.sender];
112         uint256 currentPeriodKey = getCurrentPeriodKey();
113 
114         // Ensure the sender has not already withdraw during the current period
115         require(senderHasWithdraw[currentPeriodKey] == false, "once / period");
116 
117         // Ensure we didn't reached the daily (period) limit
118         require(
119             periodDonationCount[currentPeriodKey] < cardsByPeriod,
120             "period maximum donations reached"
121         );
122 
123         // Donate the card
124         freeDnaCardRepository.airdrop(msg.sender, getRandomAnimalId());
125 
126         // And record his withdrawal
127         periodDonationCount[currentPeriodKey]++;
128         senderHasWithdraw[currentPeriodKey] = true;
129     }
130 
131     function hasAvailableCard() external view returns(bool) {
132         uint256 currentPeriodKey = getCurrentPeriodKey();
133         mapping (uint256 => bool) senderHasWithdraw = addressHasWithdraw[msg.sender];
134 
135         return (senderHasWithdraw[currentPeriodKey] == false &&
136                 periodDonationCount[currentPeriodKey] < cardsByPeriod);
137     }
138 
139     function getAvailableCardCount() external view returns(uint256) {
140         return cardsByPeriod - periodDonationCount[getCurrentPeriodKey()];
141     }
142 
143     function getNextPeriodTimestamp() external view returns(uint256) {
144         uint256 nextPeriodKey = getCurrentPeriodKey() + 1;
145         return nextPeriodKey.mul(periodDuration);
146     }
147 
148     function getRandomNumber(uint256 max) public view returns(uint256) {
149         require(max != 0);
150         return now % max;
151     }
152 
153     function getAnimalCount() public view returns(uint256) {
154         return cryptoServal.getAnimalsCount();
155     }
156 
157     function getRandomAnimalId() public view returns(uint256) {
158         return getRandomNumber(getAnimalCount());
159     }
160 
161     function getPeriodKey(uint atTime) private view returns(uint256) {
162         return atTime.div(periodDuration);
163     }
164 
165     function getCurrentPeriodKey() private view returns(uint256) {
166         return getPeriodKey(now);
167     }
168 }
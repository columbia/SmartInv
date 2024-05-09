1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract KingOfTheEthill {
51   using SafeMath for uint256;  
52   address public owner;
53   address public king;
54   string public kingsMessage;
55   uint256 public bidExpireBlockLength = 12;
56   uint256 public nextBidExpireBlockLength;
57   uint256 public devFeePercent = 1;
58   uint256 public rolloverPercent = 5;
59   uint256 public lastBidAmount;
60   uint256 public lastBidBlock;
61   uint256 public currentRoundNumber;
62   uint256 public currentBidNumber;
63   uint256 public maxMessageChars = 140;
64   mapping(uint256 => address) roundToKing;
65   mapping(uint256 => uint256) roundToWinnings;
66   mapping(uint256 => uint256) roundToFinalBid;
67   mapping(uint256 => string) roundToFinalMessage;
68 
69   event NewKing(
70     uint256 indexed roundNumber,
71     address kingAddress,
72     string kingMessage,
73     uint256 bidAmount,
74     uint256 indexed bidNumber,
75     uint256 indexed bidBlockNumber
76   );
77 
78   function KingOfTheEthill () public {
79     owner = msg.sender;
80   }
81 
82   modifier onlyOwner() {
83     require(owner == msg.sender);
84     _;
85   }
86   
87   function setDevFee (uint256 _n) onlyOwner() public {
88 	  require(_n >= 0 && _n <= 10);
89     devFeePercent = _n;
90   }
91 
92   function setRollover (uint256 _n) onlyOwner() public {
93 	  require(_n >= 1 && _n <= 30);
94     rolloverPercent = _n;
95   }
96 
97   function setNextBidExpireBlockLength (uint256 _n) onlyOwner() public {
98 	  require(_n >= 10 && _n <= 10000);
99     nextBidExpireBlockLength = _n;
100   }
101 
102   function setOwner (address _owner) onlyOwner() public {
103     owner = _owner;
104   }
105 
106   function bid (uint256 _roundNumber, string _message) payable public {
107     require(!isContract(msg.sender));
108     require(bytes(_message).length <= maxMessageChars);
109     require(msg.value > 0);
110     
111     if (_roundNumber == currentRoundNumber && !roundExpired()) {
112       // bid in active round
113       require(msg.value > lastBidAmount);
114     }else if (_roundNumber == (currentRoundNumber+1) && roundExpired()) {
115       // first bid of new round, process old round
116       var lastRoundPotBalance = this.balance.sub(msg.value);
117       uint256 devFee = lastRoundPotBalance.mul(devFeePercent).div(100);
118       owner.transfer(devFee);
119       uint256 winnings = lastRoundPotBalance.sub(devFee).mul(100 - rolloverPercent).div(100);
120       king.transfer(winnings);
121 
122       // save previous round data
123       roundToKing[currentRoundNumber] = king;
124       roundToWinnings[currentRoundNumber] = winnings;
125       roundToFinalBid[currentRoundNumber] = lastBidAmount;
126       roundToFinalMessage[currentRoundNumber] = kingsMessage;
127 
128       currentBidNumber = 0;
129       currentRoundNumber++;
130 
131       if (nextBidExpireBlockLength != 0) {
132         bidExpireBlockLength = nextBidExpireBlockLength;
133         nextBidExpireBlockLength = 0;
134       }
135     }else {
136       require(false);
137     }
138 
139     // new king
140     king = msg.sender;
141     kingsMessage = _message;
142     lastBidAmount = msg.value;
143     lastBidBlock = block.number;
144 
145     NewKing(currentRoundNumber, king, kingsMessage, lastBidAmount, currentBidNumber, lastBidBlock);
146 
147     currentBidNumber++;
148   }
149 
150   function roundExpired() public view returns (bool) {
151     return blocksSinceLastBid() >= bidExpireBlockLength;
152   }
153 
154   function blocksRemaining() public view returns (uint256) {
155     if (roundExpired()) {
156       return 0;
157     }else {
158       return bidExpireBlockLength - blocksSinceLastBid();
159     }
160   }
161 
162   function blocksSinceLastBid() public view returns (uint256) {
163     return block.number - lastBidBlock;
164   }
165 
166   function estimateNextPotSeedAmount() public view returns (uint256) {
167       return this.balance.mul(100 - devFeePercent).div(100).mul(rolloverPercent).div(100);
168   }
169 
170   function getRoundState() public view returns (bool _currentRoundExpired, uint256 _nextRoundPotSeedAmountEstimate, uint256 _roundNumber, uint256 _bidNumber, address _king, string _kingsMessage, uint256 _lastBidAmount, uint256 _blocksRemaining, uint256 _potAmount, uint256 _blockNumber, uint256 _bidExpireBlockLength) {
171     _currentRoundExpired = roundExpired();
172     _nextRoundPotSeedAmountEstimate = estimateNextPotSeedAmount();
173     _roundNumber = currentRoundNumber;
174     _bidNumber = currentBidNumber;
175     _king = king;
176     _kingsMessage = kingsMessage;
177     _lastBidAmount = lastBidAmount;
178     _blocksRemaining = blocksRemaining();
179     _potAmount = this.balance;
180     _blockNumber = block.number;
181     _bidExpireBlockLength = bidExpireBlockLength;
182   }
183 
184   function getPastRound(uint256 _roundNum) public view returns (address _kingAddress, uint256 _finalBid, uint256 _kingWinnings, string _finalMessage) {
185     _kingAddress = roundToKing[_roundNum]; 
186     _kingWinnings = roundToWinnings[_roundNum];
187     _finalBid = roundToFinalBid[_roundNum];
188     _finalMessage = roundToFinalMessage[_roundNum];
189   }
190 
191   function isContract(address addr) internal view returns (bool) {
192     uint size;
193     assembly { size := extcodesize(addr) }
194     return size > 0;
195   }
196 }
1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 *
6 -------------------------------------------------------------------------------------------------------
7    Website: https://kingdometh.com
8     Twitter: https://twitter.com/KingdomETH
9     Telegram Group: https://t.me/joinchat/IvMthlFxD8cfhpXR0wqT-g
10     Facebook: https://www.facebook.com/Kingdometh-282085195979826
11     Discord: https://discord.gg/TxhSfNB
12     -------------------------------------------------------------------------------------------------------
13 */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 contract KingdomETHKing {
57   using SafeMath for uint256;  
58   address public owner;
59   address public king;
60   string public kingsMessage;
61   uint256 public bidExpireBlockLength = 2500;
62   uint256 public nextBidExpireBlockLength;
63   uint256 public devFeePercent = 1;
64   uint256 public rolloverPercent = 5;
65   uint256 public lastBidAmount;
66   uint256 public lastBidBlock;
67   uint256 public currentRoundNumber;
68   uint256 public currentBidNumber;
69   uint256 public maxMessageChars = 140;
70   mapping(uint256 => address) roundToKing;
71   mapping(uint256 => uint256) roundToWinnings;
72   mapping(uint256 => uint256) roundToFinalBid;
73   mapping(uint256 => string) roundToFinalMessage;
74 
75   event NewKing(
76     uint256 indexed roundNumber,
77     address kingAddress,
78     string kingMessage,
79     uint256 bidAmount,
80     uint256 indexed bidNumber,
81     uint256 indexed bidBlockNumber
82   );
83 
84   function ActiveAdmin () public {
85     owner = 0x6018106414EA98FD30854b1232FebD66Bc4dF419;
86   }
87 
88   modifier onlyOwner() {
89     require(owner == msg.sender);
90     _;
91   }
92   
93   function setDevFee (uint256 _n) onlyOwner() public {
94 	  require(_n >= 0 && _n <= 90);
95     devFeePercent = _n;
96   }
97 
98   function setRollover (uint256 _n) onlyOwner() public {
99 	  require(_n >= 1 && _n <= 10);
100     rolloverPercent = _n;
101   }
102 
103   function setNextBidExpireBlockLength (uint256 _n) onlyOwner() public {
104 	  require(_n >= 10 && _n <= 10000);
105     nextBidExpireBlockLength = _n;
106   }
107 
108   function setOwner (address _owner) onlyOwner() public {
109     owner = _owner;
110   }
111 
112   function bid (uint256 _roundNumber, string _message) payable public {
113     require(!isContract(msg.sender));
114     require(bytes(_message).length <= maxMessageChars);
115     require(msg.value > 0);
116     
117     if (_roundNumber == currentRoundNumber && !roundExpired()) {
118       // bid in active round
119       require(msg.value > lastBidAmount);
120     }else if (_roundNumber == (currentRoundNumber+1) && roundExpired()) {
121       // first bid of new round, process old round
122       var lastRoundPotBalance = this.balance.sub(msg.value);
123       uint256 devFee = lastRoundPotBalance.mul(devFeePercent).div(100);
124       owner.transfer(devFee);
125       uint256 winnings = lastRoundPotBalance.sub(devFee).mul(100 - rolloverPercent).div(100);
126       king.transfer(winnings);
127 
128       // save previous round data
129       roundToKing[currentRoundNumber] = king;
130       roundToWinnings[currentRoundNumber] = winnings;
131       roundToFinalBid[currentRoundNumber] = lastBidAmount;
132       roundToFinalMessage[currentRoundNumber] = kingsMessage;
133 
134       currentBidNumber = 0;
135       currentRoundNumber++;
136 
137       if (nextBidExpireBlockLength != 0) {
138         bidExpireBlockLength = nextBidExpireBlockLength;
139         nextBidExpireBlockLength = 0;
140       }
141     }else {
142       require(false);
143     }
144 
145     // new king
146     king = msg.sender;
147     kingsMessage = _message;
148     lastBidAmount = msg.value;
149     lastBidBlock = block.number;
150 
151     NewKing(currentRoundNumber, king, kingsMessage, lastBidAmount, currentBidNumber, lastBidBlock);
152 
153     currentBidNumber++;
154   }
155 
156   function roundExpired() public view returns (bool) {
157     return blocksSinceLastBid() >= bidExpireBlockLength;
158   }
159 
160   function blocksRemaining() public view returns (uint256) {
161     if (roundExpired()) {
162       return 0;
163     }else {
164       return bidExpireBlockLength - blocksSinceLastBid();
165     }
166   }
167 
168   function blocksSinceLastBid() public view returns (uint256) {
169     return block.number - lastBidBlock;
170   }
171 
172   function estimateNextPotSeedAmount() public view returns (uint256) {
173       return this.balance.mul(100 - devFeePercent).div(100).mul(rolloverPercent).div(100);
174   }
175 
176   function getRoundState() public view returns (bool _currentRoundExpired, uint256 _nextRoundPotSeedAmountEstimate, uint256 _roundNumber, uint256 _bidNumber, address _king, string _kingsMessage, uint256 _lastBidAmount, uint256 _blocksRemaining, uint256 _potAmount, uint256 _blockNumber, uint256 _bidExpireBlockLength) {
177     _currentRoundExpired = roundExpired();
178     _nextRoundPotSeedAmountEstimate = estimateNextPotSeedAmount();
179     _roundNumber = currentRoundNumber;
180     _bidNumber = currentBidNumber;
181     _king = king;
182     _kingsMessage = kingsMessage;
183     _lastBidAmount = lastBidAmount;
184     _blocksRemaining = blocksRemaining();
185     _potAmount = this.balance;
186     _blockNumber = block.number;
187     _bidExpireBlockLength = bidExpireBlockLength;
188   }
189 
190   function getPastRound(uint256 _roundNum) public view returns (address _kingAddress, uint256 _finalBid, uint256 _kingWinnings, string _finalMessage) {
191     _kingAddress = roundToKing[_roundNum]; 
192     _kingWinnings = roundToWinnings[_roundNum];
193     _finalBid = roundToFinalBid[_roundNum];
194     _finalMessage = roundToFinalMessage[_roundNum];
195   }
196 
197   function isContract(address addr) internal view returns (bool) {
198     uint size;
199     assembly { size := extcodesize(addr) }
200     return size > 0;
201   }
202 }
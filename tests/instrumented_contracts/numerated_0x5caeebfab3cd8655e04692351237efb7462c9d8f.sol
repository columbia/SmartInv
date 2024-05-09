1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13 // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   constructor() public {
35     owner = msg.sender;
36   }
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0));
43     emit OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 
49 contract VfSE_Lottery is Ownable {
50   using SafeMath for uint256;
51   address[] private players;
52   address[] public winners;
53   uint256[] public payments;
54   uint256 private feeValue;
55   address public lastWinner;
56   address public authorizedToDraw;
57   address[] private last10Winners = [0,0,0,0,0,0,0,0,0,0];  
58   uint256 public lastPayOut;
59   uint256 public amountRised;
60   address public house;
61   uint256 public round;
62   uint256 public playValue;
63   uint256 public roundEnds;
64   uint256 public roundDuration = 1 days;
65   bool public stopped;
66   address public SecondAddressBalance = 0xFBb1b73C4f0BDa4f67dcA266ce6Ef42f520fBB98;
67   address public ThirdAddressBalance = 0x3f5CE5FBFe3E9af3971dD833D26bA9b5C936f0bE;
68   address public FourthAddressBalance = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
69   mapping (address => uint256) public payOuts;
70   uint256 private _seed;
71   
72   function bitSlice(uint256 n, uint256 bits, uint256 slot) private pure returns(uint256) {
73     uint256 offset = slot * bits;
74     uint256 mask = uint256((2**bits) - 1) << offset;
75     return uint256((n & mask) >> offset);
76   }
77 
78   function maxRandom() private returns (uint256 randomNumber) {
79     _seed = uint256(keccak256(_seed, blockhash(block.number - 1), block.coinbase, block.difficulty, blockhash(1), FourthAddressBalance.balance, SecondAddressBalance.balance, ThirdAddressBalance.balance));
80     return _seed;
81   }
82 
83   function random(uint256 upper) private returns (uint256 randomNumber) {
84     return maxRandom() % upper;
85   }
86     
87   function setHouseAddress(address _house) onlyOwner public {
88     house = _house;
89   }
90 
91   function setSecondAddressBalance(address _SecondAddressBalance) onlyOwner public {
92     SecondAddressBalance = _SecondAddressBalance;
93   }
94   
95   function setThirdAddressBalance(address _ThirdAddressBalance) onlyOwner public {
96     ThirdAddressBalance = _ThirdAddressBalance;
97   }
98   
99   function setFourthAddressBalance(address _FourthAddressBalance) onlyOwner public {
100     FourthAddressBalance = _FourthAddressBalance;
101   }
102 
103   function setAuthorizedToDraw(address _authorized) onlyOwner public {
104     authorizedToDraw = _authorized;
105   }
106 
107   function setFee(uint256 _fee) onlyOwner public {
108     feeValue = _fee;
109   }
110   
111   function setPlayValue(uint256 _amount) onlyOwner public {
112     playValue = _amount;
113   }
114 
115   function stopLottery(bool _stop) onlyOwner public {
116     stopped = _stop;
117   }
118 
119   function produceRandom(uint256 upper) private returns (uint256) {
120     uint256 rand = random(upper);
121     //output = rand;
122     return rand;
123   }
124 
125   function getPayOutAmount() private view returns (uint256) {
126     //uint256 balance = address(this).balance;
127     uint256 fee = amountRised.mul(feeValue).div(100);
128     return (amountRised - fee);
129   }
130 
131   function draw() private {
132     require(now > roundEnds);
133     uint256 howMuchBets = players.length;
134     uint256 k;
135     lastWinner = players[produceRandom(howMuchBets)];
136     lastPayOut = getPayOutAmount();
137     
138     winners.push(lastWinner);
139     if (winners.length > 9) {
140       for (uint256 i = (winners.length - 10); i < winners.length; i++) {
141         last10Winners[k] = winners[i];
142         k += 1;
143       }
144     }
145 
146     payments.push(lastPayOut);
147     payOuts[lastWinner] += lastPayOut;
148     lastWinner.transfer(lastPayOut);
149     
150     players.length = 0;
151     round += 1;
152     amountRised = 0;
153     roundEnds = now + roundDuration;
154     
155     emit NewWinner(lastWinner, lastPayOut);
156   }
157 
158   function drawNow() public {
159     require(authorizedToDraw == msg.sender);
160     draw();
161   }
162 
163   function play() payable public {
164     require (msg.value == playValue);
165     require (!stopped);
166 
167     if (now > roundEnds) {
168       if (players.length < 2) {
169         roundEnds = now + roundDuration;
170       } else {
171         draw();
172       }
173     }
174     players.push(msg.sender);
175     amountRised = amountRised.add(msg.value);
176   }
177 
178   function() payable public {
179     play();
180   }
181 
182   constructor() public {
183     house = msg.sender;
184     authorizedToDraw = msg.sender;
185     feeValue = 10;
186     playValue = 100 finney;
187   }
188     
189   function getBalance() onlyOwner public {
190     uint256 thisBalance = address(this).balance;
191     house.transfer(thisBalance);
192   }
193   
194   function getPlayersCount() public view returns (uint256) {
195     return players.length;
196   }
197   
198   function getWinnerCount() public view returns (uint256) {
199     return winners.length;
200   }
201   
202   function getPlayers() public view returns (address[]) {
203     return players;
204   }
205   
206   function getSecondAddressBalance() public view returns (uint256) {
207     return SecondAddressBalance.balance;
208   }
209   
210   function getThirdAddressBalance() public view returns (uint256) {
211     return ThirdAddressBalance.balance;
212   }
213   
214   function getFourthAddressBalance() public view returns (uint256) {
215     return FourthAddressBalance.balance;
216   }
217   function last10() public view returns (address[]) {
218     if (winners.length < 11) {
219       return winners;
220     } else {
221       return last10Winners;
222     }
223   }
224   event NewWinner(address _winner, uint256 _amount);
225 }
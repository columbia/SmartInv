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
49 contract Lottery is Ownable {
50   using SafeMath for uint256;
51   address[] private players;
52   address[] public winners;
53   uint256[] public payments;
54   uint256 private feeValue;
55   address public lastWinner;
56   address[] private last10Winners = [0,0,0,0,0,0,0,0,0,0];  
57   uint256 public lastPayOut;
58   uint256 public amountRised;
59   address public house;
60   uint256 public round;
61   uint256 public playValue;
62   uint256 public roundEnds;
63   bool public stopped;
64   mapping (address => uint256) public payOuts;
65   uint256 private _seed;
66 
67   
68   function bitSlice(uint256 n, uint256 bits, uint256 slot) private pure returns(uint256) {
69     uint256 offset = slot * bits;
70     uint256 mask = uint256((2**bits) - 1) << offset;
71     return uint256((n & mask) >> offset);
72   }
73 
74   function maxRandom() private returns (uint256 randomNumber) {
75     _seed = uint256(keccak256(_seed, blockhash(block.number - 1), block.coinbase, block.difficulty));
76     return _seed;
77   }
78 
79 
80   function random(uint256 upper) private returns (uint256 randomNumber) {
81     return maxRandom() % upper;
82   }
83     
84   function setHouseAddress(address _house) onlyOwner public {
85     house = _house;
86   }
87 
88   function setFee(uint256 _fee) onlyOwner public {
89     feeValue = _fee;
90   }
91   
92   function setPlayValue(uint256 _amount) onlyOwner public {
93     playValue = _amount;
94   }
95 
96   function stopLottery(bool _stop) onlyOwner public {
97     stopped = _stop;
98   }
99 
100   function produceRandom(uint256 upper) private returns (uint256) {
101     uint256 rand = random(upper);
102     //output = rand;
103     return rand;
104   }
105 
106   function getPayOutAmount() private view returns (uint256) {
107     //uint256 balance = address(this).balance;
108     uint256 fee = amountRised.mul(feeValue).div(100);
109     return (amountRised - fee);
110   }
111 
112   function draw() public {
113     require(now > roundEnds);
114     uint256 howMuchBets = players.length;
115     uint256 k;
116     lastWinner = players[produceRandom(howMuchBets)];
117     lastPayOut = getPayOutAmount();
118     
119     winners.push(lastWinner);
120     if (winners.length > 9) {
121       for (uint256 i = (winners.length - 10); i < winners.length; i++) {
122         last10Winners[k] = winners[i];
123         k += 1;
124       }
125     }
126 
127     payments.push(lastPayOut);
128     payOuts[lastWinner] += lastPayOut;
129     lastWinner.transfer(lastPayOut);
130     
131     players.length = 0;
132     round += 1;
133     amountRised = 0;
134     roundEnds = now + (1 * 1 days);
135     
136     emit NewWinner(lastWinner, lastPayOut);
137   }
138 
139   function play() payable public {
140     require (msg.value == playValue);
141     require (!stopped);
142     if (players.length == 0) {
143       roundEnds = now + (1 * 1 days);
144     }
145     if (now > roundEnds) {
146       draw();
147     }
148     players.push(msg.sender);
149     amountRised = amountRised.add(msg.value);
150   }
151 
152   function() payable public {
153     play();
154   }
155 
156   constructor() public {
157     house = msg.sender;
158     feeValue = 5;
159     playValue = 1 finney;
160   }
161     
162   function getBalance() onlyOwner public {
163     uint256 thisBalance = address(this).balance;
164     house.transfer(thisBalance);
165   }
166   
167   function getPlayersCount() public view returns (uint256) {
168       return players.length;
169   }
170   
171   function getWinnerCount() public view returns (uint256) {
172       return winners.length;
173   }
174   
175   function getPlayers() public view returns (address[]) {
176       return players;
177   }
178   
179   function last10() public view returns (address[]) {
180     if (winners.length < 11) {
181       return winners;
182     } else {
183       return last10Winners;
184     }
185   }
186   event NewWinner(address _winner, uint256 _amount);
187   event Conso(uint a, uint b);
188 }
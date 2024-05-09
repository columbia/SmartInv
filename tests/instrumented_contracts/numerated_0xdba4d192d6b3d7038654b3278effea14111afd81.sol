1 pragma solidity 0.4.23;
2 
3 // Random lottery
4 // Smart contracts can't bet
5 
6 // Pay 0.001eth or higher to get a random number
7 // You probably shouldn't pay higher than 0.001eth, there's no reason.
8 // If your random number is the highest so far you're in the lead
9 // If no one beats you in 1 day you can claim your winnnings - the entire balance.
10 
11 // 1% dev fee on winnings
12 contract RandoLotto {
13     using SafeMath for uint256;
14     
15     event NewLeader(address newLeader, uint256 highScore);
16     event BidAttempt(uint256 randomNumber, uint256 highScore);
17     event NewRound(uint256 payout, uint256 highScore);
18     
19     address public currentWinner;
20     
21     uint256 public highScore;
22     uint256 public lastTimestamp;
23     
24     address internal dev;
25     
26     Random randomContract;
27     
28     modifier GTFOSmartContractHackerz {
29         require(msg.sender == tx.origin);
30         _;    
31     }
32     
33     constructor () public payable {
34         dev = msg.sender;
35         highScore = 0;
36         currentWinner = msg.sender;
37         lastTimestamp = now;
38         randomContract = new Random();
39     }
40     
41     function () public payable GTFOSmartContractHackerz {
42         require(msg.value >= 0.001 ether);
43         
44         if (now > lastTimestamp + 1 days) { sendWinnings(); }
45     
46         // We include msg.sender in the randomNumber so that it's not the same for different blocks
47         uint256 randomNumber = randomContract.random(10000000000000000000);
48         
49         if (randomNumber > highScore) {
50             highScore = randomNumber;
51             currentWinner = msg.sender;
52             lastTimestamp = now;
53             
54             emit NewLeader(msg.sender, highScore);
55         }
56         
57         emit BidAttempt(randomNumber, highScore);
58     }
59     
60     function sendWinnings() public {
61         require(now > lastTimestamp + 1 days);
62         
63         uint256 toWinner;
64         uint256 toDev;
65         
66         if (address(this).balance > 0) {
67             uint256 totalPot = address(this).balance;
68             
69             toDev = totalPot.div(100);
70             toWinner = totalPot.sub(toDev);
71          
72             dev.transfer(toDev);
73             currentWinner.transfer(toWinner);
74         }
75         
76         highScore = 0;
77         currentWinner = msg.sender;
78         lastTimestamp = now;
79         
80         emit NewRound(toWinner, highScore);
81     }
82 }
83 
84 contract Random {
85   uint256 _seed;
86 
87   // The upper bound of the number returns is 2^bits - 1
88   function bitSlice(uint256 n, uint256 bits, uint256 slot) public pure returns(uint256) {
89       uint256 offset = slot * bits;
90       // mask is made by shifting left an offset number of times
91       uint256 mask = uint256((2**bits) - 1) << offset;
92       // AND n with mask, and trim to max of 5 bits
93       return uint256((n & mask) >> offset);
94   }
95 
96   function maxRandom() public returns (uint256 randomNumber) {
97     _seed = uint256(keccak256(
98         _seed,
99         blockhash(block.number - 1),
100         block.coinbase,
101         block.difficulty
102     ));
103     return _seed;
104   }
105 
106   // return a pseudo random number with an upper bound
107   function random(uint256 upper) public returns (uint256 randomNumber) {
108     return maxRandom() % upper;
109   }
110 }
111 
112 /**
113  * @title SafeMath
114  * @dev Math operations with safety checks that throw on error
115  */
116 library SafeMath {
117 
118     /**
119     * @dev Multiplies two numbers, throws on overflow.
120     */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         if (a == 0) {
123             return 0;
124         }
125         uint256 c = a * b;
126         assert(c / a == b);
127         return c;
128     }
129 
130     /**
131     * @dev Integer division of two numbers, truncating the quotient.
132     */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         // assert(b > 0); // Solidity automatically throws when dividing by 0
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137         return c;
138     }
139 
140     /**
141     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
142     */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         assert(b <= a);
145         return a - b;
146     }
147 
148     /**
149     * @dev Adds two numbers, throws on overflow.
150     */
151     function add(uint256 a, uint256 b) internal pure returns (uint256) {
152         uint256 c = a + b;
153         assert(c >= a);
154         return c;
155     }
156 }
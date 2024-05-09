1 pragma solidity ^0.4.19;
2 
3 contract Cthulooo {
4     using SafeMath for uint256;
5     
6     
7     ////CONSTANTS
8       // Amount of winners
9     uint public constant WIN_CUTOFF = 10;
10     
11     // Minimum bid
12     uint public constant MIN_BID = 0.000001 ether; 
13     
14     // Countdown duration
15     uint public constant DURATION = 60000 hours;
16     
17     //////////////////
18     
19     // Most recent WIN_CUTOFF bets, struct array not supported...
20     address[] public betAddressArray;
21     
22     // Current value of the pot
23     uint public pot;
24     
25    // Time at which the game expires
26     uint public deadline;
27     
28     //Current index of the bet array
29     uint public index;
30     
31     //Tells whether game is over
32     bool public gameIsOver;
33     
34     function Cthulooo() public payable {
35         require(msg.value >= MIN_BID);
36         betAddressArray = new address[](WIN_CUTOFF);
37         index = 0;
38         pot = 0;
39         gameIsOver = false;
40         deadline = computeDeadline();
41         newBet();
42        
43     }
44 
45     
46     function win() public {
47         require(now > deadline);
48         uint amount = pot.div(WIN_CUTOFF);
49         address sendTo;
50         for (uint i = 0; i < WIN_CUTOFF; i++) {
51             sendTo = betAddressArray[i];
52             sendTo.transfer(amount);
53             pot = pot.sub(amount);
54         }
55         gameIsOver = true;
56     }
57     
58     function newBet() public payable {
59         require(msg.value >= MIN_BID && !gameIsOver && now <= deadline);
60         pot = pot.add(msg.value);
61         betAddressArray[index] = msg.sender;
62         index = (index + 1) % WIN_CUTOFF;
63         deadline = computeDeadline();
64     }
65     
66     function computeDeadline() internal view returns (uint) {
67         return now.add(DURATION);
68     }
69 }
70 
71 /**
72  * @title SafeMath
73  * @dev Math operations with safety checks that throw on error
74  */
75 library SafeMath {
76     /**
77     * @dev Multiplies two numbers, throws on overflow.
78     */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         if (a == 0) {
81             return 0;
82         }
83         uint256 c = a * b;
84         assert(c / a == b);
85         return c;
86     }
87 
88     /**
89     * @dev Integer division of two numbers, truncating the quotient.
90     */
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         // assert(b > 0); // Solidity automatically throws when dividing by 0
93         uint256 c = a / b;
94         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95         return c;
96     }
97 
98     /**
99     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100     */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         assert(b <= a);
103         return a - b;
104     }
105 
106     /**
107     * @dev Adds two numbers, throws on overflow.
108     */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         assert(c >= a);
112         return c;
113     }
114 }
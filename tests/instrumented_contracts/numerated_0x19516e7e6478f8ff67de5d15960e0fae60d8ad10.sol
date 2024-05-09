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
12     uint public constant MIN_BID = 0.0001 ether; 
13     
14     // Countdown duration
15     uint public constant DURATION = 6 hours;
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
49         for (uint i = 0; i < WIN_CUTOFF; i++) {
50             betAddressArray[i].transfer(amount);
51         }
52         pot = 0;
53         gameIsOver = true;
54     }
55     
56     function newBet() public payable {
57         require(msg.value >= MIN_BID && !gameIsOver && now <= deadline);
58         pot = pot.add(msg.value);
59         betAddressArray[index] = msg.sender;
60         index = (index + 1) % WIN_CUTOFF;
61         deadline = computeDeadline();
62     }
63     
64     function computeDeadline() internal view returns (uint) {
65         return now.add(DURATION);
66     }
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that throw on error
72  */
73 library SafeMath {
74     /**
75     * @dev Multiplies two numbers, throws on overflow.
76     */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         assert(c / a == b);
83         return c;
84     }
85 
86     /**
87     * @dev Integer division of two numbers, truncating the quotient.
88     */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         // assert(b > 0); // Solidity automatically throws when dividing by 0
91         uint256 c = a / b;
92         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93         return c;
94     }
95 
96     /**
97     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98     */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         assert(b <= a);
101         return a - b;
102     }
103 
104     /**
105     * @dev Adds two numbers, throws on overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         assert(c >= a);
110         return c;
111     }
112 }
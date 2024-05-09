1 pragma solidity ^0.4.8;
2 
3 contract Owned {
4   address public owner;
5 
6   function Owned() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 
15   function transferOwnership(address newOwner) external onlyOwner {
16     owner = newOwner;
17   }
18 }
19 
20 contract FidgetSpinner is Owned {
21   int omega;
22   int theta;
23   uint public lastUpdate;
24 
25   uint public decayRate;
26   uint public omegaPerEther;
27 
28   int public largestRetro;
29   int public largestPro;
30 
31   event Spin(
32     address indexed from,
33     int indexed direction,
34     uint amount
35   );
36 
37   /*
38    * Creates a new FidgetSpinner whose spin decays at a rate of _decayNumerator/_decayDenominator% per second
39    * and who gains _omegaPerEther spin per Ether spent on spinning it.
40    */
41 	function FidgetSpinner(uint _decayRate, uint _omegaPerEther) {
42     lastUpdate = now;
43 		decayRate = _decayRate;
44     omegaPerEther = _omegaPerEther;
45 	}
46 
47 
48   /*
49    * This makes it easy to override deltaTime in FidgetSpinnerTest so we can test that velocity/displacement decay is
50    * working correctly
51    */
52   function deltaTime() constant returns(uint) {
53     return now - lastUpdate;
54   }
55 
56   /*
57    * Returns the velocity of the spinner during this specific block in the chain
58    */
59   function getCurrentVelocity() constant returns(int) {
60     int dir = -1;
61     if(omega == 0) {
62       return 0;
63     } else if(omega < 0) {
64       dir = 1;
65     }
66 
67     uint timeElapsed = deltaTime();
68     uint deltaOmega = timeElapsed * decayRate;
69     int newOmega = omega + (int(deltaOmega) * dir);
70 
71     // make sure we didn't cross zero
72     if((omega > 0 && newOmega < 0) || (omega < 0 && newOmega > 0)) {
73       return 0;
74     }
75 
76     return newOmega;
77   }
78 
79   /*
80    * Returns the displacement of the spinner during this specific block in the chain
81    */
82   function getCurrentDisplacement() constant returns(int) {
83     // integrates omega over time
84     int timeElapsed = int(deltaTime());
85 
86     // find max time elapsed before v=0 (becomes max-height of trapezoid)
87     int maxTime = omega / int(decayRate);
88 
89     if (maxTime < 0) {
90       maxTime *= -1;
91     }
92 
93     if(timeElapsed > maxTime) {
94       timeElapsed = maxTime;
95     }
96 
97     int deltaTheta = ((omega + getCurrentVelocity()) * timeElapsed) / 2;
98     return theta + deltaTheta;
99   }
100 
101   /*
102    * Adds or subtracts from the spin of the spinner
103    *
104    * All changes to the spinner state should happen at the end of the current block. So multiple spins in the same block
105    * should be additive with their effects only becoming apparent in the next block.
106    */
107   function spin(int direction) payable {
108     require(direction == -1 || direction == 1);
109 
110     int deltaOmega = (int(msg.value) * direction * int(omegaPerEther)) / 1 ether;
111     int newOmega = getCurrentVelocity() + deltaOmega;
112     int newTheta = getCurrentDisplacement();
113 
114     omega = newOmega;
115     theta = newTheta;
116 
117     if(-omega > largestRetro) {
118       largestRetro = -omega;
119     } else if(omega > largestPro) {
120       largestPro = omega;
121     }
122 
123     Spin(msg.sender, direction, msg.value);
124     lastUpdate = now;
125   }
126 
127   /*
128    * Withdraws all the money from the contract
129    */
130   function withdrawAll() onlyOwner {
131     withdraw(address(this).balance);
132   }
133 
134   /*
135    * Withdraws a given amount of money from the contract
136    */
137   function withdraw(uint amount) onlyOwner {
138     owner.transfer(amount);
139   }
140 }
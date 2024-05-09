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
60     if(decayRate == 0) {
61       return omega;
62     }
63 
64     int dir = -1;
65     if(omega == 0) {
66       return 0;
67     } else if(omega < 0) {
68       dir = 1;
69     }
70 
71     uint timeElapsed = deltaTime();
72     uint deltaOmega = timeElapsed * decayRate;
73     int newOmega = omega + (int(deltaOmega) * dir);
74 
75     // make sure we didn't cross zero
76     if((omega > 0 && newOmega < 0) || (omega < 0 && newOmega > 0)) {
77       return 0;
78     }
79 
80     return newOmega;
81   }
82 
83   /*
84    * Returns the displacement of the spinner during this specific block in the chain
85    */
86   function getCurrentDisplacement() constant returns(int) {
87     // integrates omega over time
88     int timeElapsed = int(deltaTime());
89 
90     if(decayRate == 0) {
91       return theta + (timeElapsed * omega);
92     }
93 
94     // find max time elapsed before v=0 (becomes max-height of trapezoid)
95     int maxTime = omega / int(decayRate);
96 
97     if (maxTime < 0) {
98       maxTime *= -1;
99     }
100 
101     if(timeElapsed > maxTime) {
102       timeElapsed = maxTime;
103     }
104 
105     int deltaTheta = ((omega + getCurrentVelocity()) * timeElapsed) / 2;
106     return theta + deltaTheta;
107   }
108 
109   /*
110    * Adds or subtracts from the spin of the spinner
111    *
112    * All changes to the spinner state should happen at the end of the current block. So multiple spins in the same block
113    * should be additive with their effects only becoming apparent in the next block.
114    */
115   function spin(int direction) payable {
116     require(direction == -1 || direction == 1);
117 
118     int deltaOmega = (int(msg.value) * direction * int(omegaPerEther)) / 1 ether;
119     int newOmega = getCurrentVelocity() + deltaOmega;
120     int newTheta = getCurrentDisplacement();
121 
122     omega = newOmega;
123     theta = newTheta;
124 
125     if(-omega > largestRetro) {
126       largestRetro = -omega;
127     } else if(omega > largestPro) {
128       largestPro = omega;
129     }
130 
131     Spin(msg.sender, direction, msg.value);
132     lastUpdate = now;
133   }
134 
135   /*
136    * Withdraws all the money from the contract
137    */
138   function withdrawAll() onlyOwner {
139     withdraw(address(this).balance);
140   }
141 
142   /*
143    * Withdraws a given amount of money from the contract
144    */
145   function withdraw(uint amount) onlyOwner {
146     owner.transfer(amount);
147   }
148 }
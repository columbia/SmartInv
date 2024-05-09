1 pragma solidity ^0.4.23;
2 
3 contract ToadFarmer {
4     uint256 public EGGS_TO_HATCH_1TOAD = 43200; // Half a day's worth of seconds to hatch
5     uint256 TADPOLE = 10000;
6     uint256 PSNHTOAD = 5000;
7     bool public initialized = false;
8     address public ceoAddress;
9     mapping (address => uint256) public hatcheryToad;
10     mapping (address => uint256) public claimedEggs;
11     mapping (address => uint256) public lastHatch;
12     mapping (address => address) public referrals;
13     uint256 public marketEggs;
14 
15     constructor() public {
16         ceoAddress = msg.sender;
17     }
18 
19     function hatchEggs(address ref) public {
20         require(initialized);
21         if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
22             referrals[msg.sender] = ref;
23         }
24         uint256 eggsUsed = getMyEggs();
25         uint256 newToad = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1TOAD);
26         hatcheryToad[msg.sender] = SafeMath.add(hatcheryToad[msg.sender], newToad);
27         claimedEggs[msg.sender] = 0;
28         lastHatch[msg.sender] = now;
29         
30         // Send referral eggs
31         claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]], SafeMath.div(eggsUsed, 5));
32         
33         // Boost market to stop toad hoarding
34         marketEggs = SafeMath.add(marketEggs, SafeMath.div(eggsUsed, 10));
35     }
36 
37     function sellEggs() public {
38         require(initialized);
39         uint256 hasEggs = getMyEggs();
40         uint256 eggValue = calculateEggSell(hasEggs);
41         uint256 fee = devFee(eggValue);
42         claimedEggs[msg.sender] = 0;
43         lastHatch[msg.sender] = now;
44         marketEggs = SafeMath.add(marketEggs, hasEggs);
45         ceoAddress.transfer(fee);
46         msg.sender.transfer(SafeMath.sub(eggValue, fee));
47     }
48     
49     function buyEggs() public payable {
50         require(initialized);
51         uint256 eggsBought = calculateEggBuy(msg.value, SafeMath.sub(address(this).balance, msg.value));
52         eggsBought = SafeMath.sub(eggsBought, devFee(eggsBought));
53         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);
54         ceoAddress.transfer(devFee(msg.value));
55     }
56 
57     // Trade balancing algorithm
58     function calculateTrade(uint256 riggert, uint256 starboards, uint256 bigship) public view returns(uint256) {
59         // (TADPOLE*bigship) /
60         // (PSNHTOAD+((TADPOLE*starboards+PSNHTOAD*riggert)/riggert));
61         return SafeMath.div(SafeMath.mul(TADPOLE, bigship),
62         SafeMath.add(PSNHTOAD, SafeMath.div(SafeMath.add(SafeMath.mul(TADPOLE, starboards),SafeMath.mul(PSNHTOAD, riggert)), riggert)));
63     }
64 
65     function calculateEggSell(uint256 eggs) public view returns(uint256) {
66         return calculateTrade(eggs, marketEggs, address(this).balance);
67     }
68 
69     function calculateEggBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
70         return calculateTrade(eth, contractBalance, marketEggs);
71     }
72 
73     function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
74         return calculateEggBuy(eth, address(this).balance);
75     }
76 
77     function devFee(uint256 amount) public pure returns(uint256) {
78         return SafeMath.div(SafeMath.mul(amount, 4), 100);
79     }
80 
81     function seedMarket(uint256 eggs) public payable {
82         require(marketEggs == 0);
83         initialized = true;
84         marketEggs = eggs;
85     }
86 
87     function getFreeToad() public {
88         require(initialized);
89         require(hatcheryToad[msg.sender] == 0);
90         lastHatch[msg.sender] = now;
91         hatcheryToad[msg.sender] = uint(blockhash(block.number-1))%400 + 1; // 'Randomish' 1-400 free eggs
92     }
93 
94     function getBalance() public view returns(uint256) {
95         return address(this).balance;
96     }
97 
98     function getMyToad() public view returns(uint256) {
99         return hatcheryToad[msg.sender];
100     }
101 
102     function getMyEggs() public view returns(uint256) {
103         return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
104     }
105 
106     function getEggsSinceLastHatch(address adr) public view returns(uint256) {
107         uint256 secondsPassed = min(EGGS_TO_HATCH_1TOAD, SafeMath.sub(now, lastHatch[adr]));
108         return SafeMath.mul(secondsPassed, hatcheryToad[adr]);
109     }
110 
111     function min(uint256 a, uint256 b) private pure returns (uint256) {
112         return a < b ? a : b;
113     }
114 }
115 
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
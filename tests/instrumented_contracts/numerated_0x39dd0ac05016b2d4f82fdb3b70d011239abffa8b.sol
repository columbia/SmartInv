1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // PepeFarmer 2.0
4 // Anti-bot 50 Starting.
5 // Anti-whale 25% reduction in shrimp eggs when selling shrimp.
6 // Combat inflation as people Hatch and Sell by not adding or subtracting from total marketEggs.
7 
8 // 50 Tokens, seeded market of 8640000000 Eggs
9 contract ShrimpFarmer{
10     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
11     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
12     uint256 public STARTING_SHRIMP=50;
13     uint256 PSN=10000;
14     uint256 PSNH=5000;
15     bool public initialized=false;
16     address public ceoAddress;
17     uint256 public ceoDevfund;
18     mapping (address => uint256) public hatcheryShrimp;
19     mapping (address => uint256) public claimedEggs;
20     mapping (address => uint256) public lastHatch;
21     mapping (address => address) public referrals;
22     uint256 public marketEggs;
23     function ShrimpFarmer() public{
24         ceoAddress=msg.sender;
25     }
26     /**
27      * Sends accumulated devFee to ceoAddress
28      * Doing it this way will save on transaction fees for users
29      */
30     function payCeo() payable public {
31       require(msg.sender == ceoAddress);
32       require(ceoDevfund > 0);
33       ceoAddress.transfer(ceoDevfund);
34       ceoDevfund = 0;
35     }
36     
37     function hatchEggs(address ref) public{
38         require(initialized);
39         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
40             referrals[msg.sender]=ref;
41         }
42         uint256 eggsUsed=getMyEggs();
43         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
44         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
45         claimedEggs[msg.sender]=0;
46         lastHatch[msg.sender]=now;
47         
48         //send referral eggs
49         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
50         
51         //boost market to nerf shrimp hoarding
52         // Original had adding to eggmarket on sell and was going to try sub but let's not do either this time.
53         //marketEggs=SafeMath.sub(marketEggs,eggsUsed);
54     }
55     function sellEggs() public{
56         require(initialized);
57         uint256 hasEggs=getMyEggs();
58         uint256 eggValue=calculateEggSell(hasEggs);
59         uint256 fee=devFee(eggValue);
60         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],4),3);
61         claimedEggs[msg.sender]=0;
62         lastHatch[msg.sender]=now;
63         // Instead of adding marketEggs let's not add or subtract
64         // marketEggs=SafeMath.sub(marketEggs,hasEggs);
65         // To save on fees put devFee in a pot to be removed by ceo instead of per transaction
66         // Old function: ceoAddress.transfer(fee);
67         ceoDevfund += fee;
68         msg.sender.transfer(SafeMath.sub(eggValue,fee));
69     }
70     function buyEggs() public payable{
71         require(initialized);
72         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
73         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
74         // To save on fees put devFee in a pot to be removed by ceo instead of per transaction
75         // Old function: ceoAddress.transfer(devFee(msg.value));
76         ceoDevfund += devFee(msg.value);
77         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
78     }
79     //magic trade balancing algorithm
80     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
81         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
82         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
83     }
84     function calculateEggSell(uint256 eggs) public view returns(uint256){
85         return calculateTrade(eggs,marketEggs,address(this).balance);
86     }
87     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
88         return calculateTrade(eth,contractBalance,marketEggs);
89     }
90     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
91         return calculateEggBuy(eth,address(this).balance);
92     }
93     function devFee(uint256 amount) public pure returns(uint256){
94         return SafeMath.div(SafeMath.mul(amount,4),100);
95     }
96     function seedMarket(uint256 eggs) public payable{
97         require(marketEggs==0);
98         initialized=true;
99         marketEggs=eggs;
100     }
101     function getFreeShrimp() public{
102         require(initialized);
103         require(hatcheryShrimp[msg.sender]==0);
104         lastHatch[msg.sender]=now;
105         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
106     }
107     function getBalance() public view returns(uint256){
108         return address(this).balance;
109     }
110     function getMyShrimp() public view returns(uint256){
111         return hatcheryShrimp[msg.sender];
112     }
113     function getMyEggs() public view returns(uint256){
114         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
115     }
116     function getEggsSinceLastHatch(address adr) public view returns(uint256){
117         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
118         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
119     }
120     function min(uint256 a, uint256 b) private pure returns (uint256) {
121         return a < b ? a : b;
122     }
123 }
124 
125 library SafeMath {
126 
127   /**
128   * @dev Multiplies two numbers, throws on overflow.
129   */
130   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131     if (a == 0) {
132       return 0;
133     }
134     uint256 c = a * b;
135     assert(c / a == b);
136     return c;
137   }
138 
139   /**
140   * @dev Integer division of two numbers, truncating the quotient.
141   */
142   function div(uint256 a, uint256 b) internal pure returns (uint256) {
143     // assert(b > 0); // Solidity automatically throws when dividing by 0
144     uint256 c = a / b;
145     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146     return c;
147   }
148 
149   /**
150   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
151   */
152   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153     assert(b <= a);
154     return a - b;
155   }
156 
157   /**
158   * @dev Adds two numbers, throws on overflow.
159   */
160   function add(uint256 a, uint256 b) internal pure returns (uint256) {
161     uint256 c = a + b;
162     assert(c >= a);
163     return c;
164   }
165 }
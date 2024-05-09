1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // PepeFarmer 2.0
4 // Anti-bot 50 Starting.
5 // Anti-whale 25% reduction in shrimp eggs when selling shrimp.
6 // Combat inflation as people Sell by not adding to total marketEggs.
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
52         marketEggs=SafeMath.add(marketEggs,eggsUsed);
53     }
54     function sellEggs() public{
55         require(initialized);
56         uint256 hasEggs=getMyEggs();
57         uint256 eggValue=calculateEggSell(hasEggs);
58         uint256 fee=devFee(eggValue);
59         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],4),3);
60         claimedEggs[msg.sender]=0;
61         lastHatch[msg.sender]=now;
62         // Instead of adding marketEggs let's not adding marketEggs
63         // marketEggs=SafeMath.add(marketEggs,hasEggs);
64         // To save on fees put devFee in a pot to be removed by ceo instead of per transaction
65         // Old function: ceoAddress.transfer(fee);
66         ceoDevfund += fee;
67         msg.sender.transfer(SafeMath.sub(eggValue,fee));
68     }
69     function buyEggs() public payable{
70         require(initialized);
71         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
72         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
73         // To save on fees put devFee in a pot to be removed by ceo instead of per transaction
74         // Old function: ceoAddress.transfer(devFee(msg.value));
75         ceoDevfund += devFee(msg.value);
76         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
77     }
78     //magic trade balancing algorithm
79     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
80         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
81         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
82     }
83     function calculateEggSell(uint256 eggs) public view returns(uint256){
84         return calculateTrade(eggs,marketEggs,address(this).balance);
85     }
86     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
87         return calculateTrade(eth,contractBalance,marketEggs);
88     }
89     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
90         return calculateEggBuy(eth,address(this).balance);
91     }
92     function devFee(uint256 amount) public pure returns(uint256){
93         return SafeMath.div(SafeMath.mul(amount,4),100);
94     }
95     function seedMarket(uint256 eggs) public payable{
96         require(marketEggs==0);
97         initialized=true;
98         marketEggs=eggs;
99     }
100     function getFreeShrimp() public{
101         require(initialized);
102         require(hatcheryShrimp[msg.sender]==0);
103         lastHatch[msg.sender]=now;
104         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
105     }
106     function getBalance() public view returns(uint256){
107         return address(this).balance;
108     }
109     function getMyShrimp() public view returns(uint256){
110         return hatcheryShrimp[msg.sender];
111     }
112     function getMyEggs() public view returns(uint256){
113         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
114     }
115     function getEggsSinceLastHatch(address adr) public view returns(uint256){
116         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
117         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
118     }
119     function min(uint256 a, uint256 b) private pure returns (uint256) {
120         return a < b ? a : b;
121     }
122 }
123 
124 library SafeMath {
125 
126   /**
127   * @dev Multiplies two numbers, throws on overflow.
128   */
129   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130     if (a == 0) {
131       return 0;
132     }
133     uint256 c = a * b;
134     assert(c / a == b);
135     return c;
136   }
137 
138   /**
139   * @dev Integer division of two numbers, truncating the quotient.
140   */
141   function div(uint256 a, uint256 b) internal pure returns (uint256) {
142     // assert(b > 0); // Solidity automatically throws when dividing by 0
143     uint256 c = a / b;
144     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
145     return c;
146   }
147 
148   /**
149   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
150   */
151   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152     assert(b <= a);
153     return a - b;
154   }
155 
156   /**
157   * @dev Adds two numbers, throws on overflow.
158   */
159   function add(uint256 a, uint256 b) internal pure returns (uint256) {
160     uint256 c = a + b;
161     assert(c >= a);
162     return c;
163   }
164 }
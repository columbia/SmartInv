1 pragma solidity ^0.4.18; // solhint-disable-line
2 /**
3  * ShrimpFarm 2.0
4  * Anti-bot 50 Starting.
5  * Anti-whale 25% reduction in shrimp eggs when selling shrimp.
6  **/
7 
8 
9 contract ShrimpFarmer{
10     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
11     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
12     uint256 public STARTING_SHRIMP=50;
13     uint256 PSN=10000;
14     uint256 PSNH=5000;
15     bool public initialized=false;
16     address public ceoAddress;
17     mapping (address => uint256) public hatcheryShrimp;
18     mapping (address => uint256) public claimedEggs;
19     mapping (address => uint256) public lastHatch;
20     mapping (address => address) public referrals;
21     uint256 public marketEggs;
22     function ShrimpFarmer() public{
23         ceoAddress=msg.sender;
24     }
25     function hatchEggs(address ref) public{
26         require(initialized);
27         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
28             referrals[msg.sender]=ref;
29         }
30         uint256 eggsUsed=getMyEggs();
31         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
32         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
33         claimedEggs[msg.sender]=0;
34         lastHatch[msg.sender]=now;
35         
36         //send referral eggs
37         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
38         
39         //boost market to nerf shrimp hoarding
40         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
41     }
42     function sellEggs() public{
43         require(initialized);
44         uint256 hasEggs=getMyEggs();
45         uint256 eggValue=calculateEggSell(hasEggs);
46         uint256 fee=devFee(eggValue);
47         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],4),3);
48         claimedEggs[msg.sender]=0;
49         lastHatch[msg.sender]=now;
50         marketEggs=SafeMath.add(marketEggs,hasEggs);
51         ceoAddress.transfer(fee);
52         msg.sender.transfer(SafeMath.sub(eggValue,fee));
53     }
54     function buyEggs() public payable{
55         require(initialized);
56         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
57         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
58         ceoAddress.transfer(devFee(msg.value));
59         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
60     }
61     //magic trade balancing algorithm
62     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
63         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
64         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
65     }
66     function calculateEggSell(uint256 eggs) public view returns(uint256){
67         return calculateTrade(eggs,marketEggs,address(this).balance);
68     }
69     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
70         return calculateTrade(eth,contractBalance,marketEggs);
71     }
72     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
73         return calculateEggBuy(eth,address(this).balance);
74     }
75     function devFee(uint256 amount) public pure returns(uint256){
76         return SafeMath.div(SafeMath.mul(amount,5),100);
77     }
78     function seedMarket(uint256 eggs) public payable{
79         require(marketEggs==0);
80         initialized=true;
81         marketEggs=eggs;
82     }
83     function getFreeShrimp() public{
84         require(initialized);
85         require(hatcheryShrimp[msg.sender]==0);
86         lastHatch[msg.sender]=now;
87         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
88     }
89     function getBalance() public view returns(uint256){
90         return address(this).balance;
91     }
92     function getMyShrimp() public view returns(uint256){
93         return hatcheryShrimp[msg.sender];
94     }
95     function getMyEggs() public view returns(uint256){
96         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
97     }
98     function getEggsSinceLastHatch(address adr) public view returns(uint256){
99         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
100         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
101     }
102     function min(uint256 a, uint256 b) private pure returns (uint256) {
103         return a < b ? a : b;
104     }
105 }
106 
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
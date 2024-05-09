1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // Rum game ETH
4 // Running on the snail/shrimpfarmer source
5 // bots should have a harder time, and whales can compete for the devfee
6 
7 contract RumFactoryETH{
8     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
9     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
10     uint256 public STARTING_SHRIMP=150;
11     uint256 PSN=10000;
12     uint256 PSNH=5000;
13     bool public initialized=false;
14     address public ceoAddress;
15     mapping (address => uint256) public hatcheryShrimp;
16     mapping (address => uint256) public claimedEggs;
17     mapping (address => uint256) public lastHatch;
18     mapping (address => address) public referrals;
19     uint256 public marketEggs;
20     uint256 public snailmasterReq=250000;
21     function ShrimpFarmer() public{
22         ceoAddress=msg.sender;
23     }
24     function becomeSnailmaster() public{
25         require(initialized);
26         require(hatcheryShrimp[msg.sender]>=snailmasterReq);
27         hatcheryShrimp[msg.sender]=SafeMath.sub(hatcheryShrimp[msg.sender],snailmasterReq);
28         snailmasterReq=SafeMath.add(snailmasterReq,100000);
29         ceoAddress=msg.sender;
30     }
31     function hatchEggs(address ref) public{
32         require(initialized);
33         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
34             referrals[msg.sender]=ref;
35         }
36         uint256 eggsUsed=getMyEggs();
37         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
38         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
39         claimedEggs[msg.sender]=0;
40         lastHatch[msg.sender]=now;
41         
42         
43         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
44         
45         
46         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
47     }
48     function sellEggs() public{
49         require(initialized);
50         uint256 hasEggs=getMyEggs();
51         uint256 eggValue=calculateEggSell(hasEggs);
52         uint256 fee=devFee(eggValue);
53         
54         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],3),2);
55         claimedEggs[msg.sender]=0;
56         lastHatch[msg.sender]=now;
57         marketEggs=SafeMath.add(marketEggs,hasEggs);
58         ceoAddress.transfer(fee);
59         msg.sender.transfer(SafeMath.sub(eggValue,fee));
60     }
61     function buyEggs() public payable{
62         require(initialized);
63         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
64         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
65         ceoAddress.transfer(devFee(msg.value));
66         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
67     }
68     
69     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
70         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
71         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
72     }
73     function calculateEggSell(uint256 eggs) public view returns(uint256){
74         return calculateTrade(eggs,marketEggs,this.balance);
75     }
76     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
77         return calculateTrade(eth,contractBalance,marketEggs);
78     }
79     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
80         return calculateEggBuy(eth,this.balance);
81     }
82     function devFee(uint256 amount) public view returns(uint256){
83         return SafeMath.div(SafeMath.mul(amount,4),100);
84     }
85     function seedMarket(uint256 eggs) public payable{
86         require(marketEggs==0);
87         initialized=true;
88         marketEggs=eggs;
89     }
90     function getFreeShrimp() public payable{
91         require(initialized);
92         require(msg.value==0.0011 ether); //similar to mining fee, prevents bots
93         ceoAddress.transfer(msg.value); //snailmaster gets this entrance fee
94         require(hatcheryShrimp[msg.sender]==0);
95         lastHatch[msg.sender]=now;
96         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
97     }
98     function getBalance() public view returns(uint256){
99         return this.balance;
100     }
101     function getMyShrimp() public view returns(uint256){
102         return hatcheryShrimp[msg.sender];
103     }
104     function getSnailmasterReq() public view returns(uint256){
105         return snailmasterReq;
106     }
107     function getMyEggs() public view returns(uint256){
108         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
109     }
110     function getEggsSinceLastHatch(address adr) public view returns(uint256){
111         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
112         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
113     }
114     function min(uint256 a, uint256 b) private pure returns (uint256) {
115         return a < b ? a : b;
116     }
117 }
118 
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     // assert(b > 0); // Solidity automatically throws when dividing by 0
138     uint256 c = a / b;
139     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
140     return c;
141   }
142 
143   /**
144   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
145   */
146   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147     assert(b <= a);
148     return a - b;
149   }
150 
151   /**
152   * @dev Adds two numbers, throws on overflow.
153   */
154   function add(uint256 a, uint256 b) internal pure returns (uint256) {
155     uint256 c = a + b;
156     assert(c >= a);
157     return c;
158   }
159 }
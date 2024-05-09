1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // similar as shrimpfarmer, with below changes:
4 // A. one fifth of your owls die when you sell eggs
5 // B. you can transfer ownership of the devfee through sacrificing owls
6 // C. the "free" 300 owls cost 0.001 eth (in line with the mining fee)
7 // D. Inflation has been reduced by 20% (More Earnings!)
8 // bots should have a harder time, and whales can compete for the devfee
9 
10 contract EthOwls{
11     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
12     uint256 public EGGS_TO_HATCH_1SHRIMP=86400; //seconds in a day
13     uint256 public STARTING_SHRIMP=300;
14     uint256 PSN=10000;
15     uint256 PSNH=5000;
16     uint256 r=6;
17     uint256 inf=5;
18     uint256 RINF = r / inf; // Inflation reducer 
19     bool public initialized=false;
20     address public ceoAddress;
21     mapping (address => uint256) public hatcheryShrimp;
22     mapping (address => uint256) public claimedEggs;
23     mapping (address => uint256) public lastHatch;
24     mapping (address => address) public referrals;
25     uint256 public marketEggs;
26     uint256 public owlmasterReq=100000;
27     function ShrimpFarmer() public{
28         ceoAddress=msg.sender;
29     }
30     function becomeOwlmaster() public{
31         require(initialized);
32         require(hatcheryShrimp[msg.sender]>=owlmasterReq);
33         hatcheryShrimp[msg.sender]=SafeMath.sub(hatcheryShrimp[msg.sender],owlmasterReq);
34         owlmasterReq=SafeMath.add(owlmasterReq,100000);//+100k owls each time
35         ceoAddress=msg.sender;
36     }
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
52         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
53     }
54     function sellEggs() public{
55         require(initialized);
56         uint256 hasEggs=getMyEggs();
57         uint256 eggValue=calculateEggSell(hasEggs);
58         uint256 fee=devFee(eggValue);
59         // kill one fifth of the owner's owls on egg sale
60         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],5),4);
61         claimedEggs[msg.sender]=0;
62         lastHatch[msg.sender]=now;
63         marketEggs=SafeMath.add(marketEggs,hasEggs);
64         ceoAddress.transfer(fee);
65         msg.sender.transfer(SafeMath.sub(eggValue,fee));
66     }
67     function buyEggs() public payable{
68         require(initialized);
69         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
70         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
71         ceoAddress.transfer(devFee(msg.value));
72         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
73     }
74     //magic trade balancing algorithm
75     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
76         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/(RINF*rt)));
77         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),SafeMath.mul(RINF,rt))));
78     }
79     function calculateEggSell(uint256 eggs) public view returns(uint256){
80         return calculateTrade(eggs,marketEggs,this.balance);
81     }
82     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
83         return calculateTrade(eth,contractBalance,marketEggs);
84     }
85     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
86         return calculateEggBuy(eth,this.balance);
87     }
88     function devFee(uint256 amount) public view returns(uint256){
89         return SafeMath.div(SafeMath.mul(amount,4),100);
90     }
91     function seedMarket(uint256 eggs) public payable{
92         require(marketEggs==0);
93         initialized=true;
94         marketEggs=eggs;
95     }
96     function getFreeShrimp() public payable{
97         require(initialized);
98         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
99         ceoAddress.transfer(msg.value); //owlmaster gets this entrance fee
100         require(hatcheryShrimp[msg.sender]==0);
101         lastHatch[msg.sender]=now;
102         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
103     }
104     function getBalance() public view returns(uint256){
105         return this.balance;
106     }
107     function getMyShrimp() public view returns(uint256){
108         return hatcheryShrimp[msg.sender];
109     }
110     function getOwlmasterReq() public view returns(uint256){
111         return owlmasterReq;
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
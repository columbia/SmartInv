1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // similar as shrimpfarmer, with three changes:
4 // A. one third of your snails die when you sell eggs
5 // B. you can transfer ownership of the devfee through sacrificing snails
6 // C. the "free" 300 snails cost 0.001 eth (in line with the mining fee)
7 // bots should have a harder time, and whales can compete for the devfee
8 
9 contract SpermLabs{
10     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
11     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
12     uint256 public STARTING_SHRIMP=300;
13     uint256 PSN=10000;
14     uint256 PSNH=5000;
15     bool public initialized=false;
16     address public ceoAddress;
17     mapping (address => uint256) public hatcheryShrimp;
18     mapping (address => uint256) public claimedEggs;
19     mapping (address => uint256) public lastHatch;
20     mapping (address => address) public referrals;
21     uint256 public marketEggs;
22     uint256 public snailmasterReq=100000;
23     function SpermLabs() public{
24         ceoAddress=msg.sender;
25     }
26     function becomeSnailmaster() public{
27         require(initialized);
28         require(hatcheryShrimp[msg.sender]>=snailmasterReq);
29         hatcheryShrimp[msg.sender]=SafeMath.sub(hatcheryShrimp[msg.sender],snailmasterReq);
30         snailmasterReq=SafeMath.add(snailmasterReq,100000);//+100k shrimps each time
31         ceoAddress=msg.sender;
32     }
33     function hatchEggs(address ref) public{
34         require(initialized);
35         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
36             referrals[msg.sender]=ref;
37         }
38         uint256 eggsUsed=getMyEggs();
39         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
40         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
41         claimedEggs[msg.sender]=0;
42         lastHatch[msg.sender]=now;
43         
44         //send referral eggs
45         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
46         
47         //boost market to nerf shrimp hoarding
48         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
49     }
50     function sellEggs() public{
51         require(initialized);
52         uint256 hasEggs=getMyEggs();
53         uint256 eggValue=calculateEggSell(hasEggs);
54         uint256 fee=devFee(eggValue);
55         // kill one third of the owner's snails on egg sale
56         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],3),2);
57         claimedEggs[msg.sender]=0;
58         lastHatch[msg.sender]=now;
59         marketEggs=SafeMath.add(marketEggs,hasEggs);
60         ceoAddress.transfer(fee);
61         msg.sender.transfer(SafeMath.sub(eggValue,fee));
62     }
63     function buyEggs() public payable{
64         require(initialized);
65         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
66         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
67         ceoAddress.transfer(devFee(msg.value));
68         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
69     }
70     //magic trade balancing algorithm
71     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
72         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
73         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
74     }
75     function calculateEggSell(uint256 eggs) public view returns(uint256){
76         return calculateTrade(eggs,marketEggs,this.balance);
77     }
78     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
79         return calculateTrade(eth,contractBalance,marketEggs);
80     }
81     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
82         return calculateEggBuy(eth,this.balance);
83     }
84     function devFee(uint256 amount) public view returns(uint256){
85         return SafeMath.div(SafeMath.mul(amount,4),100);
86     }
87     function seedMarket(uint256 eggs) public payable{
88         require(marketEggs==0);
89         initialized=true;
90         marketEggs=eggs;
91     }
92     function getFreeShrimp() public payable{
93         require(initialized);
94         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
95         ceoAddress.transfer(msg.value); //snailmaster gets this entrance fee
96         require(hatcheryShrimp[msg.sender]==0);
97         lastHatch[msg.sender]=now;
98         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
99     }
100     function getBalance() public view returns(uint256){
101         return this.balance;
102     }
103     function getMyShrimp() public view returns(uint256){
104         return hatcheryShrimp[msg.sender];
105     }
106     function getSnailmasterReq() public view returns(uint256){
107         return snailmasterReq;
108     }
109     function getMyEggs() public view returns(uint256){
110         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
111     }
112     function getEggsSinceLastHatch(address adr) public view returns(uint256){
113         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
114         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
115     }
116     function min(uint256 a, uint256 b) private pure returns (uint256) {
117         return a < b ? a : b;
118     }
119 }
120 
121 library SafeMath {
122 
123   /**
124   * @dev Multiplies two numbers, throws on overflow.
125   */
126   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127     if (a == 0) {
128       return 0;
129     }
130     uint256 c = a * b;
131     assert(c / a == b);
132     return c;
133   }
134 
135   /**
136   * @dev Integer division of two numbers, truncating the quotient.
137   */
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     // assert(b > 0); // Solidity automatically throws when dividing by 0
140     uint256 c = a / b;
141     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142     return c;
143   }
144 
145   /**
146   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147   */
148   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149     assert(b <= a);
150     return a - b;
151   }
152 
153   /**
154   * @dev Adds two numbers, throws on overflow.
155   */
156   function add(uint256 a, uint256 b) internal pure returns (uint256) {
157     uint256 c = a + b;
158     assert(c >= a);
159     return c;
160   }
161 }
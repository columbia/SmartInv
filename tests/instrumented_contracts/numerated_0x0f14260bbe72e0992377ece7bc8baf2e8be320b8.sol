1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 // similar as shrimpfarmer, with three changes:
4 // A. one third of your snails die when you sell eggs
5 // B. you can transfer ownership of the devfee through sacrificing snails
6 // C. the "free" 300 snails cost 0.001 eth (in line with the mining fee)
7 
8 // bots should have a harder time, and whales can compete for the devfee
9 // http://ethfish.club/
10 
11 contract ShrimpFarmer{
12     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
13     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
14     uint256 public STARTING_SHRIMP=300;
15     uint256 PSN=10000;
16     uint256 PSNH=5000;
17     bool public initialized=false;
18     address public ceoAddress;
19     mapping (address => uint256) public hatcheryShrimp;
20     mapping (address => uint256) public claimedEggs;
21     mapping (address => uint256) public lastHatch;
22     mapping (address => address) public referrals;
23     uint256 public marketEggs;
24     uint256 public snailmasterReq=100000;
25     function ShrimpFarmer() public{
26         ceoAddress=msg.sender;
27     }
28     function becomeSnailmaster() public{
29         require(initialized);
30         require(hatcheryShrimp[msg.sender]>=snailmasterReq);
31         //hatcheryShrimp[msg.sender]=SafeMath.sub(hatcheryShrimp[msg.sender],snailmasterReq);
32         //snailmasterReq=SafeMath.add(snailmasterReq,100000);//+100k shrimps each time
33         //ceoAddress=msg.sender;
34     }
35     function hatchEggs(address ref) public{
36         require(initialized);
37         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
38             referrals[msg.sender]=ref;
39         }
40         uint256 eggsUsed=getMyEggs();
41         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
42         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
43         claimedEggs[msg.sender]=0;
44         lastHatch[msg.sender]=now;
45         
46         //send referral eggs
47         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
48         
49         //boost market to nerf shrimp hoarding
50         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
51     }
52     function sellEggs() public{
53         require(initialized);
54         uint256 hasEggs=getMyEggs();
55         uint256 eggValue=calculateEggSell(hasEggs);
56         uint256 fee=devFee(eggValue);
57         // kill one third of the owner's snails on egg sale
58         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],3),2);
59         claimedEggs[msg.sender]=0;
60         lastHatch[msg.sender]=now;
61         marketEggs=SafeMath.add(marketEggs,hasEggs);
62         ceoAddress.transfer(fee);
63         msg.sender.transfer(SafeMath.sub(eggValue,fee));
64     }
65     function buyEggs() public payable{
66         require(initialized);
67         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
68         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
69         ceoAddress.transfer(devFee(msg.value));
70         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
71     }
72     //magic trade balancing algorithm
73     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
74         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
75         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
76     }
77     function calculateEggSell(uint256 eggs) public view returns(uint256){
78         return calculateTrade(eggs,marketEggs,this.balance);
79     }
80     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
81         return calculateTrade(eth,contractBalance,marketEggs);
82     }
83     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
84         return calculateEggBuy(eth,this.balance);
85     }
86     function devFee(uint256 amount) public view returns(uint256){
87         return SafeMath.div(SafeMath.mul(amount,4),100);
88     }
89     function seedMarket(uint256 eggs) public payable{
90         require(marketEggs==0);
91         initialized=true;
92         marketEggs=eggs;
93     }
94     function getFreeShrimp() public{
95         require(initialized);
96         //require(msg.value==0.001 ether); //similar to mining fee, prevents bots
97         //ceoAddress.transfer(msg.value); //snailmaster gets this entrance fee
98         require(hatcheryShrimp[msg.sender]==0);
99         lastHatch[msg.sender]=now;
100         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
101     }
102     function getBalance() public view returns(uint256){
103         return this.balance;
104     }
105     function getMyShrimp() public view returns(uint256){
106         return hatcheryShrimp[msg.sender];
107     }
108     function getSnailmasterReq() public view returns(uint256){
109         return snailmasterReq;
110     }
111     function getMyEggs() public view returns(uint256){
112         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
113     }
114     function getEggsSinceLastHatch(address adr) public view returns(uint256){
115         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
116         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
117     }
118     function min(uint256 a, uint256 b) private pure returns (uint256) {
119         return a < b ? a : b;
120     }
121 }
122 
123 library SafeMath {
124 
125   /**
126   * @dev Multiplies two numbers, throws on overflow.
127   */
128   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129     if (a == 0) {
130       return 0;
131     }
132     uint256 c = a * b;
133     assert(c / a == b);
134     return c;
135   }
136 
137   /**
138   * @dev Integer division of two numbers, truncating the quotient.
139   */
140   function div(uint256 a, uint256 b) internal pure returns (uint256) {
141     // assert(b > 0); // Solidity automatically throws when dividing by 0
142     uint256 c = a / b;
143     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144     return c;
145   }
146 
147   /**
148   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
149   */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     assert(b <= a);
152     return a - b;
153   }
154 
155   /**
156   * @dev Adds two numbers, throws on overflow.
157   */
158   function add(uint256 a, uint256 b) internal pure returns (uint256) {
159     uint256 c = a + b;
160     assert(c >= a);
161     return c;
162   }
163 }
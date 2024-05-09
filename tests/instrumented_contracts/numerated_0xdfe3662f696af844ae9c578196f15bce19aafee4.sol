1 pragma solidity ^0.4.20; // solhint-disable-line
2 
3 // similar as bullsfarmer, with three changes:
4 // A. one third of your bullss die when you sell eggs
5 // B. you can transfer ownership of the devfee through sacrificing bullss
6 // C. the "free" 300 bullss cost 0.001 eth (in line with the mining fee)
7 
8 // bots should have a harder time, and whales can compete for the devfee
9 
10 contract BullsFarmer{
11     //uint256 EGGS_PER_BULLS_PER_SECOND=1;
12     uint256 public EGGS_TO_HATCH_1BULLS=86400;//for final version should be seconds in a day
13     uint256 public STARTING_BULLS=300;
14     uint256 PSN=10000;
15     uint256 PSNH=5000;
16     bool public initialized=false;
17     address public ceoAddress;
18     mapping (address => uint256) public hatcheryBulls;
19     mapping (address => uint256) public claimedEggs;
20     mapping (address => uint256) public lastHatch;
21     mapping (address => address) public referrals;
22     uint256 public marketEggs;
23     uint256 public bullsmasterReq=100000;
24     function BullsFarmer() public{
25         ceoAddress=msg.sender;
26     }
27     function becomeBullsmaster() public{
28         require(initialized);
29         require(hatcheryBulls[msg.sender]>=bullsmasterReq);
30         hatcheryBulls[msg.sender]=SafeMath.sub(hatcheryBulls[msg.sender],bullsmasterReq);
31         bullsmasterReq=SafeMath.add(bullsmasterReq,100000);//+100k bullss each time
32         ceoAddress=msg.sender;
33     }
34     function hatchEggs(address ref) public{
35         require(initialized);
36         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
37             referrals[msg.sender]=ref;
38         }
39         uint256 eggsUsed=getMyEggs();
40         uint256 newBulls=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1BULLS);
41         hatcheryBulls[msg.sender]=SafeMath.add(hatcheryBulls[msg.sender],newBulls);
42         claimedEggs[msg.sender]=0;
43         lastHatch[msg.sender]=now;
44         
45         //send referral eggs
46         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
47         
48         //boost market to nerf bulls hoarding
49         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
50     }
51     function sellEggs() public{
52         require(initialized);
53         uint256 hasEggs=getMyEggs();
54         uint256 eggValue=calculateEggSell(hasEggs);
55         uint256 fee=devFee(eggValue);
56         // kill one third of the owner's bullss on egg sale
57         hatcheryBulls[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryBulls[msg.sender],3),2);
58         claimedEggs[msg.sender]=0;
59         lastHatch[msg.sender]=now;
60         marketEggs=SafeMath.add(marketEggs,hasEggs);
61         ceoAddress.transfer(fee);
62         msg.sender.transfer(SafeMath.sub(eggValue,fee));
63     }
64     function buyEggs() public payable{
65         require(initialized);
66         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
67         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
68         ceoAddress.transfer(devFee(msg.value));
69         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
70     }
71     //magic trade balancing algorithm
72     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
73         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
74         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
75     }
76     function calculateEggSell(uint256 eggs) public view returns(uint256){
77         return calculateTrade(eggs,marketEggs,this.balance);
78     }
79     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
80         return calculateTrade(eth,contractBalance,marketEggs);
81     }
82     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
83         return calculateEggBuy(eth,this.balance);
84     }
85     function devFee(uint256 amount) public view returns(uint256){
86         return SafeMath.div(SafeMath.mul(amount,4),100);
87     }
88     function seedMarket(uint256 eggs) public payable{
89         require(marketEggs==0);
90         initialized=true;
91         marketEggs=eggs;
92     }
93     function getFreeBulls() public payable{
94         require(initialized);
95         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
96         ceoAddress.transfer(msg.value); //bullsmaster gets this entrance fee
97         require(hatcheryBulls[msg.sender]==0);
98         lastHatch[msg.sender]=now;
99         hatcheryBulls[msg.sender]=STARTING_BULLS;
100     }
101     function getBalance() public view returns(uint256){
102         return this.balance;
103     }
104     function getMyBulls() public view returns(uint256){
105         return hatcheryBulls[msg.sender];
106     }
107     function getBullsmasterReq() public view returns(uint256){
108         return bullsmasterReq;
109     }
110     function getMyEggs() public view returns(uint256){
111         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
112     }
113     function getEggsSinceLastHatch(address adr) public view returns(uint256){
114         uint256 secondsPassed=min(EGGS_TO_HATCH_1BULLS,SafeMath.sub(now,lastHatch[adr]));
115         return SafeMath.mul(secondsPassed,hatcheryBulls[adr]);
116     }
117     function min(uint256 a, uint256 b) private pure returns (uint256) {
118         return a < b ? a : b;
119     }
120 }
121 
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     if (a == 0) {
129       return 0;
130     }
131     uint256 c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return c;
144   }
145 
146   /**
147   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }
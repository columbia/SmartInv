1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract ChickenFarmer{
6     //uint256 EGGS_PER_CHICKEN_PER_SECOND=1;
7     uint256 public EGGS_TO_HATCH_1CHICKEN=86400;//for final version should be seconds in a day
8     uint256 public STARTING_CHICKEN=2;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address private ceoAddress1=0x48baB4A535d4CF9aEd72c5Db74fB392ee38ea3e1;
13     address private ceoAddress2=0x00d9391e4E09066C3D42D672AB453Fe70c203976;
14     mapping (address => uint256) public hatcheryChicken;
15     mapping (address => uint256) public claimedEggs;
16     mapping (address => uint256) public lastHatch;
17     mapping (address => address) public referrals;
18     uint256 public marketEggs;
19 
20    
21     function hatchEggs(address ref) public{
22         require(initialized);
23         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
24             referrals[msg.sender]=ref;
25         }
26         uint256 eggsUsed=getMyEggs();
27 
28         //20% early hatch bonus
29         if (SafeMath.sub(now,lastHatch[msg.sender]) < SafeMath.div(EGGS_TO_HATCH_1CHICKEN,2))
30 {    
31         eggsUsed =  SafeMath.div(SafeMath.mul(eggsUsed,120),100); }
32 
33         uint256 newChicken=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1CHICKEN);
34         hatcheryChicken[msg.sender]=SafeMath.add(hatcheryChicken[msg.sender],newChicken);
35         claimedEggs[msg.sender]=0;
36         lastHatch[msg.sender]=now;
37         
38         //send referral eggs
39         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,20));
40         
41         //boost market to nerf Chicken hoarding
42         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
43     }
44     function sellEggs() public{
45         require(initialized);
46         uint256 hasEggs=getMyEggs();
47         uint256 eggValue=calculateEggSell(hasEggs);
48         uint256 fee=devFee(eggValue);
49         claimedEggs[msg.sender]=0;
50         lastHatch[msg.sender]=now;
51         marketEggs=SafeMath.add(marketEggs,hasEggs);
52         ceoAddress1.transfer(fee);
53         ceoAddress2.transfer(fee);
54 
55         msg.sender.transfer(SafeMath.sub(eggValue,fee));
56     }
57     function buyEggs() public payable{
58         require(initialized);
59         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
60    //     claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
61         
62         uint256 newChicken=SafeMath.div(eggsBought,EGGS_TO_HATCH_1CHICKEN);
63 
64         if (hatcheryChicken[msg.sender]==0){
65         lastHatch[msg.sender]=now;
66         }
67 
68         hatcheryChicken[msg.sender]=SafeMath.add(hatcheryChicken[msg.sender],newChicken);
69 
70         //boost market to nerf Chicken hoarding
71         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsBought,10));
72 
73 
74 
75     }
76     //magic trade balancing algorithm
77     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
78         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
79         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
80     }
81     function calculateEggSell(uint256 eggs) public view returns(uint256){
82         return calculateTrade(eggs,marketEggs,this.balance);
83     }
84     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
85         return calculateTrade(eth,contractBalance,marketEggs);
86     }
87     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
88         return calculateEggBuy(eth,this.balance);
89     }
90     function devFee(uint256 amount) public view returns(uint256){
91         return SafeMath.div(SafeMath.mul(amount,2),100);
92     }
93     function seedMarket(uint256 eggs) public payable{
94         require(marketEggs==0);
95         initialized=true;
96         marketEggs=eggs;
97     }
98     function getFreeChicken() public{
99         require(initialized);
100         require(hatcheryChicken[msg.sender]==0);
101         lastHatch[msg.sender]=now;
102         hatcheryChicken[msg.sender]=STARTING_CHICKEN;
103     }
104     function getBalance() public view returns(uint256){
105         return this.balance;
106     }
107     function getMyChicken() public view returns(uint256){
108         return hatcheryChicken[msg.sender];
109     }
110     function getMyEggs() public view returns(uint256){
111         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
112     }
113     function getEggsSinceLastHatch(address adr) public view returns(uint256){
114         uint256 secondsPassed=min(EGGS_TO_HATCH_1CHICKEN,SafeMath.sub(now,lastHatch[adr]));
115         return SafeMath.mul(secondsPassed,hatcheryChicken[adr]);
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
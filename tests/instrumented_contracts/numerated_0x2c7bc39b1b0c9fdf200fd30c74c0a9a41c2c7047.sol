1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract JigsawGames2{
6     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
7     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
8     uint256 public STARTING_SHRIMP=50;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address public ceoAddress=0x2AAAe414348EdE8fB28731Bb0784d151197883a8;
13     mapping (address => uint256) public hatcheryShrimp;
14     mapping (address => uint256) public claimedEggs;
15     mapping (address => uint256) public lastHatch;
16     mapping (address => address) public referrals;
17     uint256 public marketEggs;
18     function MiningRigFarmer() public{
19         ceoAddress=msg.sender;
20     }
21     function hatchEggs(address ref) public{
22         require(initialized);
23         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
24             referrals[msg.sender]=ref;
25         }
26         uint256 eggsUsed=getMyEggs();
27         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
28         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
29         claimedEggs[msg.sender]=0;
30         lastHatch[msg.sender]=now;
31         
32         //send referral eggs
33         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
34         
35         //boost market to nerf shrimp hoarding
36         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
37     }
38     function sellEggs() public{
39         require(initialized);
40         uint256 hasEggs=getMyEggs();
41         uint256 eggValue=calculateEggSell(hasEggs);
42         uint256 fee=devFee(eggValue);
43         claimedEggs[msg.sender]=0;
44         lastHatch[msg.sender]=now;
45         marketEggs=SafeMath.add(marketEggs,hasEggs);
46         ceoAddress.transfer(fee);
47         msg.sender.transfer(SafeMath.sub(eggValue,fee));
48     }
49     function buyEggs() public payable{
50         require(initialized);
51         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
52         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
53         ceoAddress.transfer(devFee(msg.value));
54         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
55     }
56     //magic trade balancing algorithm
57     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
58         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
59         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
60     }
61     function calculateEggSell(uint256 eggs) public view returns(uint256){
62         return calculateTrade(eggs,marketEggs,this.balance);
63     }
64     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
65         return calculateTrade(eth,contractBalance,marketEggs);
66     }
67     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
68         return calculateEggBuy(eth,this.balance);
69     }
70     function devFee(uint256 amount) public view returns(uint256){
71         return SafeMath.div(SafeMath.mul(amount,4),100);
72     }
73     function seedMarket(uint256 eggs) public payable{
74         require(marketEggs==0);
75         initialized=true;
76         marketEggs=eggs;
77     }
78     function getFreeShrimp() public{
79         require(initialized);
80         require(hatcheryShrimp[msg.sender]==0);
81         lastHatch[msg.sender]=now;
82         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
83     }
84     function getBalance() public view returns(uint256){
85         return this.balance;
86     }
87     function getMyShrimp() public view returns(uint256){
88         return hatcheryShrimp[msg.sender];
89     }
90     function getMyEggs() public view returns(uint256){
91         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
92     }
93     function getEggsSinceLastHatch(address adr) public view returns(uint256){
94         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
95         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
96     }
97     function min(uint256 a, uint256 b) private pure returns (uint256) {
98         return a < b ? a : b;
99     }
100 }
101 
102 library SafeMath {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     if (a == 0) {
109       return 0;
110     }
111     uint256 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   /**
127   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
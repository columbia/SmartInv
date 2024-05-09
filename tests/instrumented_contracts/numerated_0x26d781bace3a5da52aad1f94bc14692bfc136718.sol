1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /*
4 *Come Farm some Ether Tards with me at www.tardfarmer.club
5 */
6 
7 contract Tardis{
8     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
9     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
10     uint256 public STARTING_SHRIMP=69;
11     uint256 PSN=10000;
12     uint256 PSNH=5000;
13     bool public initialized=false;
14     address public ceoAddress;
15     mapping (address => uint256) public hatcheryShrimp;
16     mapping (address => uint256) public claimedEggs;
17     mapping (address => uint256) public lastHatch;
18     mapping (address => address) public referrals;
19     uint256 public marketEggs;
20     function Tardis() public{
21         ceoAddress=msg.sender;
22     }
23     function hatchEggs(address ref) public{
24         require(initialized);
25         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
26             referrals[msg.sender]=ref;
27         }
28         uint256 eggsUsed=getMyEggs();
29         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
30         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
31         claimedEggs[msg.sender]=0;
32         lastHatch[msg.sender]=now;
33         
34         //send referral eggs
35         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
36         
37         //boost market to nerf shrimp hoarding
38         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
39     }
40     function sellEggs() public{
41         require(initialized);
42         uint256 hasEggs=getMyEggs();
43         uint256 eggValue=calculateEggSell(hasEggs);
44         uint256 fee=devFee(eggValue);
45         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],10),9);
46         claimedEggs[msg.sender]=0;
47         lastHatch[msg.sender]=now;
48         marketEggs=SafeMath.add(marketEggs,hasEggs);
49         ceoAddress.transfer(fee);
50         msg.sender.transfer(SafeMath.sub(eggValue,fee));
51     }
52     function buyEggs() public payable{
53         require(initialized);
54         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
55         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
56         ceoAddress.transfer(devFee(msg.value));
57         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
58     }
59     //magic trade balancing algorithm
60     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
61         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
62         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
63     }
64     function calculateEggSell(uint256 eggs) public view returns(uint256){
65         return calculateTrade(eggs,marketEggs,this.balance);
66     }
67     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
68         return calculateTrade(eth,contractBalance,marketEggs);
69     }
70     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
71         return calculateEggBuy(eth,this.balance);
72     }
73     function devFee(uint256 amount) public view returns(uint256){
74         return SafeMath.div(SafeMath.mul(amount,5),100);
75     }
76     function seedMarket(uint256 eggs) public payable{
77         require(marketEggs==0);
78         initialized=true;
79         marketEggs=eggs;
80     }
81     function getFreeShrimp() public{
82         require(initialized);
83         require(hatcheryShrimp[msg.sender]==0);
84         lastHatch[msg.sender]=now;
85         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
86     }
87     function getBalance() public view returns(uint256){
88         return this.balance;
89     }
90     function getMyShrimp() public view returns(uint256){
91         return hatcheryShrimp[msg.sender];
92     }
93     function getMyEggs() public view returns(uint256){
94         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
95     }
96     function getEggsSinceLastHatch(address adr) public view returns(uint256){
97         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
98         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
99     }
100     function min(uint256 a, uint256 b) private pure returns (uint256) {
101         return a < b ? a : b;
102     }
103 }
104 
105 library SafeMath {
106 
107   /**
108   * @dev Multiplies two numbers, throws on overflow.
109   */
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     if (a == 0) {
112       return 0;
113     }
114     uint256 c = a * b;
115     assert(c / a == b);
116     return c;
117   }
118 
119   /**
120   * @dev Integer division of two numbers, truncating the quotient.
121   */
122   function div(uint256 a, uint256 b) internal pure returns (uint256) {
123     // assert(b > 0); // Solidity automatically throws when dividing by 0
124     uint256 c = a / b;
125     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126     return c;
127   }
128 
129   /**
130   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
131   */
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   /**
138   * @dev Adds two numbers, throws on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     assert(c >= a);
143     return c;
144   }
145 }
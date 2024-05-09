1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract AlienFarmer{
6     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
7     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
8     uint256 PSN=10000;
9     uint256 PSNH=5000;
10     bool public initialized=false;
11     address public ceoAddress;
12     mapping (address => uint256) public hatcheryShrimp;
13     mapping (address => uint256) public claimedEggs;
14     mapping (address => uint256) public lastHatch;
15     mapping (address => address) public referrals;
16     uint256 public marketEggs;
17     function AlienFarmer() public{
18         ceoAddress=msg.sender;
19     }
20     function hatchEggs(address ref) public{
21         require(initialized);
22         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
23             referrals[msg.sender]=ref;
24         }
25         uint256 eggsUsed=getMyEggs();
26         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
27         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
28         claimedEggs[msg.sender]=0;
29         lastHatch[msg.sender]=now;
30         
31         //send referral eggs
32         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
33         
34         //boost market to nerf shrimp hoarding
35         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
36     }
37     function sellEggs() public{
38         require(initialized);
39         uint256 hasEggs=getMyEggs();
40         uint256 eggValue=calculateEggSell(hasEggs);
41         uint256 fee=devFee(eggValue);
42         claimedEggs[msg.sender]=0;
43         lastHatch[msg.sender]=now;
44         marketEggs=SafeMath.add(marketEggs,hasEggs);
45         ceoAddress.transfer(fee);
46         msg.sender.transfer(SafeMath.sub(eggValue,fee));
47     }
48     function buyEggs() public payable{
49         require(initialized);
50         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
51         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
52         ceoAddress.transfer(devFee(msg.value));
53         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
54     }
55     //magic trade balancing algorithm
56     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
57         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
58         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
59     }
60     function calculateEggSell(uint256 eggs) public view returns(uint256){
61         return calculateTrade(eggs,marketEggs,this.balance);
62     }
63     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
64         return calculateTrade(eth,contractBalance,marketEggs);
65     }
66     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
67         return calculateEggBuy(eth,this.balance);
68     }
69     function devFee(uint256 amount) public view returns(uint256){
70         return SafeMath.div(SafeMath.mul(amount,4),100);
71     }
72     function seedMarket(uint256 eggs) public payable{
73         require(marketEggs==0);
74         initialized=true;
75         marketEggs=eggs;
76     }
77     function getBalance() public view returns(uint256){
78         return this.balance;
79     }
80     function getMyShrimp() public view returns(uint256){
81         return hatcheryShrimp[msg.sender];
82     }
83     function getMyEggs() public view returns(uint256){
84         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
85     }
86     function getEggsSinceLastHatch(address adr) public view returns(uint256){
87         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
88         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
89     }
90     function min(uint256 a, uint256 b) private pure returns (uint256) {
91         return a < b ? a : b;
92     }
93 }
94 
95 library SafeMath {
96 
97   /**
98   * @dev Multiplies two numbers, throws on overflow.
99   */
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return c;
117   }
118 
119   /**
120   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
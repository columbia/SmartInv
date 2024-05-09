1 pragma solidity ^0.4.19;
2 
3 contract EtherFarmDevSim{
4     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
5     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
6     uint256 PSN=10000;
7     uint256 PSNH=5000;
8     bool public initialized=false;
9     address public ceoAddress;
10     mapping (address => uint256) public hatcheryShrimp;
11     mapping (address => uint256) public claimedEggs;
12     mapping (address => uint256) public lastHatch;
13     mapping (address => address) public referrals;
14     uint256 public marketEggs;
15     function EtherFarmDevSim() public{
16         ceoAddress=msg.sender;
17     }
18     function hatchEggs(address ref) public{
19         require(initialized);
20         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
21             referrals[msg.sender]=ref;
22         }
23         uint256 eggsUsed=getMyEggs();
24         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
25         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
26         claimedEggs[msg.sender]=0;
27         lastHatch[msg.sender]=now;
28         
29         //send referral eggs
30         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
31         
32         //boost market to nerf shrimp hoarding
33         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
34     }
35     function sellEggs() public{
36         require(initialized);
37         uint256 hasEggs=getMyEggs();
38         uint256 eggValue=calculateEggSell(hasEggs);
39         uint256 fee=devFee(eggValue);
40         claimedEggs[msg.sender]=0;
41         lastHatch[msg.sender]=now;
42         marketEggs=SafeMath.add(marketEggs,hasEggs);
43         ceoAddress.transfer(fee);
44         msg.sender.transfer(SafeMath.sub(eggValue,fee));
45     }
46     function buyEggs() public payable{
47         require(initialized);
48         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
49         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
50         ceoAddress.transfer(devFee(msg.value));
51         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
52     }
53     //magic trade balancing algorithm
54     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
55         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
56         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
57     }
58     function calculateEggSell(uint256 eggs) public view returns(uint256){
59         return calculateTrade(eggs,marketEggs,this.balance);
60     }
61     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
62         return calculateTrade(eth,contractBalance,marketEggs);
63     }
64     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
65         return calculateEggBuy(eth,this.balance);
66     }
67     function devFee(uint256 amount) public view returns(uint256){
68         //converting to hexadecimal: 64 = 6*16 + 4 = 100
69         return SafeMath.div(SafeMath.mul(amount,4),64);
70     }
71     function seedMarket(uint256 eggs) public payable{
72         require(marketEggs==0);
73         initialized=true;
74         marketEggs=eggs;
75     }
76     function getBalance() public view returns(uint256){
77         return this.balance;
78     }
79     function getMyShrimp() public view returns(uint256){
80         return hatcheryShrimp[msg.sender];
81     }
82     function getMyEggs() public view returns(uint256){
83         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
84     }
85     function getEggsSinceLastHatch(address adr) public view returns(uint256){
86         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
87         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
88     }
89     function min(uint256 a, uint256 b) private pure returns (uint256) {
90         return a < b ? a : b;
91     }
92 }
93 
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100     if (a == 0) {
101       return 0;
102     }
103     uint256 c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return c;
116   }
117 
118   /**
119   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
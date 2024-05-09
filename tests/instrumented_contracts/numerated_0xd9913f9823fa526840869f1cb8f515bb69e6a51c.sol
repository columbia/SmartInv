1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract DinosaurFarmer{
4     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
5     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
6     uint256 public STARTING_SHRIMP=300;
7     uint256 PSN=10000;
8     uint256 PSNH=5000;
9     bool public initialized=false;
10     address public ceoAddress;
11     mapping (address => uint256) public hatcheryShrimp;
12     mapping (address => uint256) public claimedEggs;
13     mapping (address => uint256) public lastHatch;
14     mapping (address => address) public referrals;
15     uint256 public marketEggs;
16     function DinosaurFarmer() public{
17         ceoAddress=msg.sender;
18     }
19     function hatchEggs(address ref) public{
20         require(initialized);
21         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
22             referrals[msg.sender]=ref;
23         }
24         uint256 eggsUsed=getMyEggs();
25         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
26         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
27         claimedEggs[msg.sender]=0;
28         lastHatch[msg.sender]=now;
29         
30         //send referral eggs
31         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
32         
33         //boost market to nerf shrimp hoarding
34         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
35     }
36     function sellEggs() public{
37         require(initialized);
38         uint256 hasEggs=getMyEggs();
39         uint256 eggValue=calculateEggSell(hasEggs);
40         uint256 fee=devFee(eggValue);
41         claimedEggs[msg.sender]=0;
42         lastHatch[msg.sender]=now;
43         marketEggs=SafeMath.add(marketEggs,hasEggs);
44         ceoAddress.transfer(fee);
45         msg.sender.transfer(SafeMath.sub(eggValue,fee));
46     }
47     function buyEggs() public payable{
48         require(initialized);
49         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
50         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
51         ceoAddress.transfer(devFee(msg.value));
52         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
53     }
54     //magic trade balancing algorithm
55     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
56         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
57         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
58     }
59     function calculateEggSell(uint256 eggs) public view returns(uint256){
60         return calculateTrade(eggs,marketEggs,this.balance);
61     }
62     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
63         return calculateTrade(eth,contractBalance,marketEggs);
64     }
65     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
66         return calculateEggBuy(eth,this.balance);
67     }
68     function devFee(uint256 amount) public view returns(uint256){
69         return SafeMath.div(SafeMath.mul(amount,4),100);
70     }
71     function seedMarket(uint256 eggs) public payable{
72         require(marketEggs==0);
73         initialized=true;
74         marketEggs=eggs;
75     }
76     function getFreeShrimp() public{
77         require(initialized);
78         require(hatcheryShrimp[msg.sender]==0);
79         lastHatch[msg.sender]=now;
80         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
81     }
82     function getBalance() public view returns(uint256){
83         return this.balance;
84     }
85     function getMyShrimp() public view returns(uint256){
86         return hatcheryShrimp[msg.sender];
87     }
88     function getMyEggs() public view returns(uint256){
89         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
90     }
91     function getEggsSinceLastHatch(address adr) public view returns(uint256){
92         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
93         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
94     }
95     function min(uint256 a, uint256 b) private pure returns (uint256) {
96         return a < b ? a : b;
97     }
98 }
99 
100 library SafeMath {
101 
102   /**
103   * @dev Multiplies two numbers, throws on overflow.
104   */
105   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106     if (a == 0) {
107       return 0;
108     }
109     uint256 c = a * b;
110     assert(c / a == b);
111     return c;
112   }
113 
114   /**
115   * @dev Integer division of two numbers, truncating the quotient.
116   */
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   /**
125   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
126   */
127   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128     assert(b <= a);
129     return a - b;
130   }
131 
132   /**
133   * @dev Adds two numbers, throws on overflow.
134   */
135   function add(uint256 a, uint256 b) internal pure returns (uint256) {
136     uint256 c = a + b;
137     assert(c >= a);
138     return c;
139   }
140 }
1 contract CryptoSim{
2     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
3     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
4     uint256 public STARTING_SHRIMP=10;
5     uint256 PSN=10000;
6     uint256 PSNH=5000;
7     bool public initialized=false;
8     address public ceoAddress;
9     mapping (address => uint256) public hatcheryShrimp;
10     mapping (address => uint256) public claimedEggs;
11     mapping (address => uint256) public lastHatch;
12     mapping (address => address) public referrals;
13     uint256 public marketEggs;
14     function CryptoSim() public{
15         ceoAddress=msg.sender;
16     }
17     function hatchEggs(address ref) public{
18         require(initialized);
19         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
20             referrals[msg.sender]=ref;
21         }
22         uint256 eggsUsed=getMyEggs();
23         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
24         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
25         claimedEggs[msg.sender]=0;
26         lastHatch[msg.sender]=now;
27         
28         //send referral eggs
29         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
30         
31         //boost market to nerf shrimp hoarding
32         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
33     }
34     function sellEggs() public{
35         require(initialized);
36         uint256 hasEggs=getMyEggs();
37         uint256 eggValue=calculateEggSell(hasEggs);
38         uint256 fee=devFee(eggValue);
39         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],4),3);
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
68         return SafeMath.div(SafeMath.mul(amount,5),100);
69     }
70     function seedMarket(uint256 eggs) public payable{
71         require(marketEggs==0);
72         initialized=true;
73         marketEggs=eggs;
74     }
75     function getFreeShrimp() public{
76         require(initialized);
77         require(hatcheryShrimp[msg.sender]==0);
78         lastHatch[msg.sender]=now;
79         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
80     }
81     function getBalance() public view returns(uint256){
82         return this.balance;
83     }
84     function getMyShrimp() public view returns(uint256){
85         return hatcheryShrimp[msg.sender];
86     }
87     function getMyEggs() public view returns(uint256){
88         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
89     }
90     function getEggsSinceLastHatch(address adr) public view returns(uint256){
91         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
92         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
93     }
94     function min(uint256 a, uint256 b) private pure returns (uint256) {
95         return a < b ? a : b;
96     }
97 }
98 
99 library SafeMath {
100 
101   /**
102   * @dev Multiplies two numbers, throws on overflow.
103   */
104   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105     if (a == 0) {
106       return 0;
107     }
108     uint256 c = a * b;
109     assert(c / a == b);
110     return c;
111   }
112 
113   /**
114   * @dev Integer division of two numbers, truncating the quotient.
115   */
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   /**
124   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
125   */
126   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127     assert(b <= a);
128     return a - b;
129   }
130 
131   /**
132   * @dev Adds two numbers, throws on overflow.
133   */
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     assert(c >= a);
137     return c;
138   }
139 }
1 pragma solidity ^0.4.26; // solhint-disable-line
2 
3 contract ETHMiner{
4     //uint256 EGGS_PER_MINERS_PER_SECOND=1;
5     uint256 public EGGS_TO_HATCH_1MINERS=2592000;//for final version should be seconds in a day
6     uint256 PSN=10000;
7     uint256 PSNH=5000;
8     bool public initialized=false;
9     address public ceoAddress;
10     address public ceoAddress2;
11     mapping (address => uint256) public hatcheryMiners;
12     mapping (address => uint256) public claimedEggs;
13     mapping (address => uint256) public lastHatch;
14     mapping (address => address) public referrals;
15     uint256 public marketEggs;
16     constructor() public{
17         ceoAddress=msg.sender;
18         ceoAddress2=address(0x1855D66a196dB8f8EA33a9B30569d4a483577bE4);
19     }
20     function hatchEggs(address ref) public{
21         require(initialized);
22         if(ref == msg.sender) {
23             ref = 0;
24         }
25         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
26             referrals[msg.sender]=ref;
27         }
28         uint256 eggsUsed=getMyEggs();
29         uint256 newMiners=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1MINERS);
30         hatcheryMiners[msg.sender]=SafeMath.add(hatcheryMiners[msg.sender],newMiners);
31         claimedEggs[msg.sender]=0;
32         lastHatch[msg.sender]=now;
33         
34         //send referral eggs
35         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,10));
36         
37         //boost market to nerf miners hoarding
38         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,5));
39     }
40     function sellEggs() public{
41         require(initialized);
42         uint256 hasEggs=getMyEggs();
43         uint256 eggValue=calculateEggSell(hasEggs);
44         uint256 fee=devFee(eggValue);
45         uint256 fee2=fee/2;
46         claimedEggs[msg.sender]=0;
47         lastHatch[msg.sender]=now;
48         marketEggs=SafeMath.add(marketEggs,hasEggs);
49         ceoAddress.transfer(fee2);
50         ceoAddress2.transfer(fee-fee2);
51         msg.sender.transfer(SafeMath.sub(eggValue,fee));
52     }
53     function buyEggs(address ref) public payable{
54         require(initialized);
55         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
56         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
57         uint256 fee=devFee(msg.value);
58         uint256 fee2=fee/2;
59         ceoAddress.transfer(fee2);
60         ceoAddress2.transfer(fee-fee2);
61         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
62         hatchEggs(ref);
63     }
64     //magic trade balancing algorithm
65     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
66         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
67         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
68     }
69     function calculateEggSell(uint256 eggs) public view returns(uint256){
70         return calculateTrade(eggs,marketEggs,address(this).balance);
71     }
72     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
73         return calculateTrade(eth,contractBalance,marketEggs);
74     }
75     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
76         return calculateEggBuy(eth,address(this).balance);
77     }
78     function devFee(uint256 amount) public pure returns(uint256){
79         return SafeMath.div(SafeMath.mul(amount,5),100);
80     }
81     function seedMarket() public payable{
82         require(marketEggs==0);
83         initialized=true;
84         marketEggs=259200000000;
85     }
86     function getBalance() public view returns(uint256){
87         return address(this).balance;
88     }
89     function getMyMiners() public view returns(uint256){
90         return hatcheryMiners[msg.sender];
91     }
92     function getMyEggs() public view returns(uint256){
93         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
94     }
95     function getEggsSinceLastHatch(address adr) public view returns(uint256){
96         uint256 secondsPassed=min(EGGS_TO_HATCH_1MINERS,SafeMath.sub(now,lastHatch[adr]));
97         return SafeMath.mul(secondsPassed,hatcheryMiners[adr]);
98     }
99     function min(uint256 a, uint256 b) private pure returns (uint256) {
100         return a < b ? a : b;
101     }
102 }
103 
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, throws on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110     if (a == 0) {
111       return 0;
112     }
113     uint256 c = a * b;
114     assert(c / a == b);
115     return c;
116   }
117 
118   /**
119   * @dev Integer division of two numbers, truncating the quotient.
120   */
121   function div(uint256 a, uint256 b) internal pure returns (uint256) {
122     // assert(b > 0); // Solidity automatically throws when dividing by 0
123     uint256 c = a / b;
124     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125     return c;
126   }
127 
128   /**
129   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
130   */
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   /**
137   * @dev Adds two numbers, throws on overflow.
138   */
139   function add(uint256 a, uint256 b) internal pure returns (uint256) {
140     uint256 c = a + b;
141     assert(c >= a);
142     return c;
143   }
144 }
1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract CatFarmer{
6     uint256 public EGGS_TO_HATCH_1Cat=86400;//for final version should be seconds in a day
7     uint256 public STARTING_CAT=300;
8     uint256 PSN=10000;
9     uint256 PSNH=5000;
10     bool public initialized=false;
11     address public ceoAddress;
12     mapping (address => uint256) public hatcheryCat;
13     mapping (address => uint256) public claimedEggs;
14     mapping (address => uint256) public lastHatch;
15     mapping (address => address) public referrals;
16     uint256 public marketEggs;
17     function CatFarmer() public{
18         ceoAddress=msg.sender;
19     }
20     function hatchEggs(address ref) public{
21         require(initialized);
22         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
23             referrals[msg.sender]=ref;
24         }
25         uint256 eggsUsed=getMyEggs();
26         uint256 newCat=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1Cat);
27         hatcheryCat[msg.sender]=SafeMath.add(hatcheryCat[msg.sender],newCat);
28         claimedEggs[msg.sender]=0;
29         lastHatch[msg.sender]=now;
30         
31         //send referral eggs
32         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
33         
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
68         return SafeMath.div(SafeMath.mul(amount,4),100);
69     }
70     function seedMarket(uint256 eggs) public payable{
71         require(marketEggs==0);
72         initialized=true;
73         marketEggs=eggs;
74     }
75     function getFreeCat() public{
76         require(initialized);
77         require(hatcheryCat[msg.sender]==0);
78         lastHatch[msg.sender]=now;
79         hatcheryCat[msg.sender]=STARTING_CAT;
80     }
81     function getBalance() public view returns(uint256){
82         return this.balance;
83     }
84     function getMyCat() public view returns(uint256){
85         return hatcheryCat[msg.sender];
86     }
87     function getMyEggs() public view returns(uint256){
88         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
89     }
90     function getEggsSinceLastHatch(address adr) public view returns(uint256){
91         uint256 secondsPassed=min(EGGS_TO_HATCH_1Cat,SafeMath.sub(now,lastHatch[adr]));
92         return SafeMath.mul(secondsPassed,hatcheryCat[adr]);
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
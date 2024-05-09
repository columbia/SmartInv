1 pragma solidity 0.4.24;
2 
3 //https://www.sperm.network/farm
4 //https://discord.gg/AkaGFuE
5 
6 // similar as shrimpfarmer, with three changes:
7 // A. one third of your snails die when you sell eggs
8 // B. you can transfer ownership of the devfee through sacrificing snails
9 // C. the "free" 300 snails cost 0.001 eth (in line with the mining fee)
10 // bots should have a harder time, and whales can compete for the devfee
11 
12 contract SpermLabs{
13     string public name = "Sperm farm" ;
14 	string public symbol = "Sperm";
15     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
16     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
17     uint256 public STARTING_SHRIMP=300;
18     uint256 PSN=10000;
19     uint256 PSNH=5000;
20     bool public initialized=true;
21     address public ceoAddress;
22     mapping (address => uint256) public hatcheryShrimp;
23     mapping (address => uint256) public claimedEggs;
24     mapping (address => uint256) public lastHatch;
25     mapping (address => address) public referrals;
26     uint256 public marketEggs;
27     uint256 public snailmasterReq=100000;
28     function SpermLabs() public{
29         ceoAddress=msg.sender;
30     }
31     modifier onlyCEO(){
32 	    require(msg.sender == ceoAddress );
33         _;
34 	}
35     function becomeSnailmaster() public{
36         require(initialized);
37         require(hatcheryShrimp[msg.sender]>=snailmasterReq);
38         hatcheryShrimp[msg.sender]=SafeMath.sub(hatcheryShrimp[msg.sender],snailmasterReq);
39         snailmasterReq=SafeMath.add(snailmasterReq,100000);//+100k shrimps each time
40         ceoAddress=msg.sender;
41     }
42     function hatchEggs(address ref) public{
43         require(initialized);
44         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
45             referrals[msg.sender]=ref;
46         }
47         uint256 eggsUsed=getMyEggs();
48         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
49         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
50         claimedEggs[msg.sender]=0;
51         lastHatch[msg.sender]=now;
52         
53         //send referral eggs
54         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
55         
56         //boost market to nerf shrimp hoarding
57         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
58     }
59     function sellEggs() public{
60         require(initialized);
61         uint256 hasEggs=getMyEggs();
62         uint256 eggValue=calculateEggSell(hasEggs);
63         uint256 fee=devFee(eggValue);
64         // kill one third of the owner's snails on egg sale
65         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],3),2);
66         claimedEggs[msg.sender]=0;
67         lastHatch[msg.sender]=now;
68         marketEggs=SafeMath.add(marketEggs,hasEggs);
69         ceoAddress.transfer(eggValue);
70         msg.sender.transfer(SafeMath.sub(eggValue,fee));
71     }
72     function buyEggs() public payable{
73         require(initialized);
74         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
75         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
76         ceoAddress.transfer(devFee(msg.value));
77         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
78     }
79     //magic trade balancing algorithm
80     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
81         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
82         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
83     }
84     function calculateEggSell(uint256 eggs) public view returns(uint256){
85         return calculateTrade(eggs,marketEggs,this.balance);
86     }
87     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
88         return calculateTrade(eth,contractBalance,marketEggs);
89     }
90     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
91         return calculateEggBuy(eth,this.balance);
92     }
93     function devFee(uint256 amount) public view returns(uint256){
94         return SafeMath.div(SafeMath.mul(amount,4),100);
95     }
96     function seedMarket(uint256 eggs) public payable{
97         require(marketEggs==0);
98         initialized=true;
99         marketEggs=eggs;
100     }
101     function getFreeShrimp() public payable{
102         require(initialized);
103         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
104         ceoAddress.transfer(msg.value); //snailmaster gets this entrance fee
105         require(hatcheryShrimp[msg.sender]==0);
106         lastHatch[msg.sender]=now;
107         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
108     }
109     function getBalance() public view returns(uint256){
110         return this.balance;
111     }
112     function getMyShrimp() public view returns(uint256){
113         return hatcheryShrimp[msg.sender];
114     }
115     function getSnailmasterReq() public view returns(uint256){
116         return snailmasterReq;
117     }
118     function getMyEggs() public view returns(uint256){
119         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
120     }
121     function getEggsSinceLastHatch(address adr) public view returns(uint256){
122         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
123         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
124     }
125     function min(uint256 a, uint256 b) private pure returns (uint256) {
126         return a < b ? a : b;
127     }
128     function transferOwnership(address newCEO) onlyCEO public {
129 		uint256 etherBalance = this.balance;
130 		ceoAddress.transfer(etherBalance);
131 		ceoAddress = newCEO;
132 	}
133 
134 }
135 
136 library SafeMath {
137 
138   /**
139   * @dev Multiplies two numbers, throws on overflow.
140   */
141   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142     if (a == 0) {
143       return 0;
144     }
145     uint256 c = a * b;
146     assert(c / a == b);
147     return c;
148   }
149 
150   /**
151   * @dev Integer division of two numbers, truncating the quotient.
152   */
153   function div(uint256 a, uint256 b) internal pure returns (uint256) {
154     // assert(b > 0); // Solidity automatically throws when dividing by 0
155     uint256 c = a / b;
156     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157     return c;
158   }
159 
160   /**
161   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
162   */
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     assert(b <= a);
165     return a - b;
166   }
167 
168   /**
169   * @dev Adds two numbers, throws on overflow.
170   */
171   function add(uint256 a, uint256 b) internal pure returns (uint256) {
172     uint256 c = a + b;
173     assert(c >= a);
174     return c;
175   }
176 }
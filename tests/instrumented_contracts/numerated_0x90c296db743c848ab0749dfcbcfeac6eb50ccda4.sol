1 pragma solidity ^0.4.18; // solhint-disable-line
2 /**
3 *
4 Starting at 50 free lobsters modifiable by ceoAddress
5 * 
6 Eggs hatching in 1 day
7 *
8 devFee 2%
9 *
10 **/
11 contract LobsterFarm{
12     uint256 public EGGS_TO_HATCH_1LOBSTER=86400;
13     uint256 public STARTING_LOBSTER=50;
14     uint256 PSN=10000;
15     uint256 PSNH=5000;
16     bool public initialized=false;
17     address public ceoAddress;
18     mapping (address => uint256) public hatcheryLobster;
19     mapping (address => uint256) public claimedEggs;
20     mapping (address => uint256) public lastHatch;
21     mapping (address => address) public referrals;
22     uint256 public marketEggs;
23     
24     function LobsterFarm() public{
25         ceoAddress=msg.sender;
26     }
27     
28     event onHatchEggs(
29         address indexed customerAddress,
30         uint256 Lobsters,
31         address indexed referredBy                
32     );
33     
34     event onSellEggs(
35         address indexed customerAddress,
36         uint256 eggs,
37         uint256 ethereumEarned   
38     );
39 
40     event onBuyEggs(
41         address indexed customerAddress,
42         uint256 eggs,
43         uint256 incomingEthereum
44     );
45     
46     function hatchEggs(address ref) public{
47         require(initialized);
48         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
49             referrals[msg.sender]=ref;
50         }
51         uint256 eggsUsed=getMyEggs();
52         uint256 newLobster=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1LOBSTER);
53         hatcheryLobster[msg.sender]=SafeMath.add(hatcheryLobster[msg.sender],newLobster);
54         claimedEggs[msg.sender]=0;
55         lastHatch[msg.sender]=now;
56         //send referral eggs
57         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
58         //boost market to nerf shrimp hoarding
59         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
60         //
61         onHatchEggs(msg.sender, newLobster, ref);
62     }
63     
64     function sellEggs() public{
65         require(initialized);
66         uint256 hasEggs=getMyEggs();
67         uint256 eggValue=calculateEggSell(hasEggs);
68         uint256 fee=devFee(eggValue);
69         claimedEggs[msg.sender]=0;
70         lastHatch[msg.sender]=now;
71         marketEggs=SafeMath.add(marketEggs,hasEggs);
72         ceoAddress.transfer(fee);
73         //
74         uint256 ethereumEarned = SafeMath.sub(eggValue,fee);
75         msg.sender.transfer(ethereumEarned);
76         //
77         onSellEggs(msg.sender, hasEggs, ethereumEarned);
78     }
79     
80     function buyEggs() public payable{
81         require(initialized);
82         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
83         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
84         uint256 fee = devFee(msg.value);
85         uint256 incomingEthereum = SafeMath.sub(msg.value, fee);
86         ceoAddress.transfer(fee);
87         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
88         //
89         onBuyEggs(msg.sender, eggsBought, incomingEthereum);
90     }
91     
92     //magic trade balancing algorithm
93     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
94         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
95         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
96     }
97     
98     function calculateEggSell(uint256 eggs) public view returns(uint256){
99         return calculateTrade(eggs,marketEggs,this.balance);
100     }
101     
102     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
103         return calculateTrade(eth,contractBalance,marketEggs);
104     }
105     
106     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
107         return calculateEggBuy(eth,this.balance);
108     }
109     
110     function devFee(uint256 amount) public pure returns(uint256){
111         return SafeMath.div(SafeMath.mul(amount,2),100);
112     }
113 
114     function seedMarket(uint256 eggs) public payable{
115         require(marketEggs==0);
116         //
117         initialized=true;
118         marketEggs=eggs;
119     }
120 
121     function setFreeLobster(uint16 _newFreeLobster) public{
122         require(msg.sender==ceoAddress);
123         //
124         STARTING_LOBSTER=_newFreeLobster;
125     }    
126 
127     function getFreeLobster() public{
128         require(initialized);
129         //
130         lastHatch[msg.sender]=now;
131         hatcheryLobster[msg.sender]=STARTING_LOBSTER;
132     }    
133     
134     function getBalance() public view returns(uint256){
135         return this.balance;
136     }
137     
138     function getMyLobster() public view returns(uint256){
139         return hatcheryLobster[msg.sender];
140     }
141     
142     function getMyEggs() public view returns(uint256){
143         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
144     }
145     
146     function getEggsSinceLastHatch(address adr) public view returns(uint256){
147         uint256 secondsPassed=min(EGGS_TO_HATCH_1LOBSTER,SafeMath.sub(now,lastHatch[adr]));
148         return SafeMath.mul(secondsPassed,hatcheryLobster[adr]);
149     }
150     
151     function min(uint256 a, uint256 b) private pure returns (uint256) {
152         return a < b ? a : b;
153     }
154 }
155 
156 library SafeMath {
157   /**
158   * @dev Multiplies two numbers, throws on overflow.
159   */
160   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161     if (a == 0) {
162       return 0;
163     }
164     uint256 c = a * b;
165     assert(c / a == b);
166     return c;
167   }
168   
169   /**
170   * @dev Integer division of two numbers, truncating the quotient.
171   */
172   function div(uint256 a, uint256 b) internal pure returns (uint256) {
173     // assert(b > 0); // Solidity automatically throws when dividing by 0
174     uint256 c = a / b;
175     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176     return c;
177   }
178   
179   /**
180   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
181   */
182   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183     assert(b <= a);
184     return a - b;
185   }
186   
187   /**
188   * @dev Adds two numbers, throws on overflow.
189   */
190   function add(uint256 a, uint256 b) internal pure returns (uint256) {
191     uint256 c = a + b;
192     assert(c >= a);
193     return c;
194   }
195 }
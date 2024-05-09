1 pragma solidity ^0.4.20;
2 
3 contract DinoFarm{
4     uint256 public EGGS_TO_HATCH_1DINO=86400; //Hatching in 1 day
5     uint256 public STARTING_DINO=100;
6     uint256 PSN=10000;
7     uint256 PSNH=5000;
8     bool public initialized=false;
9     address public ceoAddress;
10     mapping (address => uint256) public hatcheryDino;
11     mapping (address => uint256) public claimedEggs;
12     mapping (address => uint256) public lastHatch;
13     mapping (address => address) public referrals;
14     uint256 public marketEggs;
15    
16     event onHatchEggs(
17         address indexed customerAddress,
18         uint256 Dinos,
19         address indexed referredBy                
20     );
21     
22     event onSellEggs(
23         address indexed customerAddress,
24         uint256 eggs,
25         uint256 ethereumEarned   
26     );
27 
28     event onBuyEggs(
29         address indexed customerAddress,
30         uint256 eggs,
31         uint256 incomingEthereum
32     );
33 
34     function DinoFarm() public{
35         ceoAddress = 0x49742B4c4d4F358e96173272d952aC3A4352001E;
36     }
37     
38     function hatchEggs(address ref) public{
39         require(initialized);
40         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
41             referrals[msg.sender]=ref;
42         }
43         uint256 eggsUsed=getMyEggs();
44         uint256 newDino=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1DINO);
45         hatcheryDino[msg.sender]=SafeMath.add(hatcheryDino[msg.sender],newDino);
46         claimedEggs[msg.sender]=0;
47         lastHatch[msg.sender]=now;
48         //send referral eggs
49         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
50         //boost market to nerf dino hoarding
51         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
52         onHatchEggs(msg.sender, newDino, ref);
53     }
54     
55     function sellEggs() public{
56         require(initialized);
57         uint256 hasEggs=getMyEggs();
58         uint256 eggValue=calculateEggSell(hasEggs);
59         uint256 fee=devFee(eggValue);
60         uint256 ethereumEarned = SafeMath.sub(eggValue,fee);
61         claimedEggs[msg.sender]=0;
62         lastHatch[msg.sender]=now;
63         marketEggs=SafeMath.add(marketEggs,hasEggs);
64         ceoAddress.transfer(fee);
65         msg.sender.transfer(ethereumEarned);
66         onSellEggs(msg.sender, hasEggs, ethereumEarned);
67     }
68     
69     function buyEggs() public payable{
70         require(initialized);
71         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
72         uint256 fee = devFee(msg.value);
73         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
74         ceoAddress.transfer(fee);
75         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
76         onBuyEggs(msg.sender, eggsBought, msg.value);
77     }
78     
79     //magic trade balancing algorithm
80     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
81         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
82         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
83     }
84     
85     function calculateEggSell(uint256 eggs) public view returns(uint256){
86         return calculateTrade(eggs,marketEggs,this.balance);
87     }
88     
89     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
90         return calculateTrade(eth,contractBalance,marketEggs);
91     }
92     
93     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
94         return calculateEggBuy(eth,this.balance);
95     }
96     
97     function devFee(uint256 amount) public pure returns(uint256){
98         return SafeMath.div(SafeMath.mul(amount,4),100);
99     }
100 
101     function seedMarket(uint256 eggs) public payable{
102         require(marketEggs==0);
103         initialized=true;
104         marketEggs=eggs;
105     }
106 
107     function setFreeDino(uint16 _newFreeDino) public{
108         require(msg.sender==ceoAddress);
109 		    require(_newFreeDino >= 10);
110         STARTING_DINO=_newFreeDino;
111     }    
112 
113     function getFreeDino() public{
114         require(initialized);
115         require(hatcheryDino[msg.sender]==0);
116         lastHatch[msg.sender]=now;
117         hatcheryDino[msg.sender]=STARTING_DINO;
118     }    
119     
120     function getBalance() public view returns(uint256){
121         return this.balance;
122     }
123     
124     function getMyDino() public view returns(uint256){
125         return hatcheryDino[msg.sender];
126     }
127     
128     function getMyEggs() public view returns(uint256){
129         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
130     }
131     
132     function getEggsSinceLastHatch(address adr) public view returns(uint256){
133         uint256 secondsPassed=min(EGGS_TO_HATCH_1DINO,SafeMath.sub(now,lastHatch[adr]));
134         return SafeMath.mul(secondsPassed,hatcheryDino[adr]);
135     }
136     
137     function min(uint256 a, uint256 b) private pure returns (uint256) {
138         return a < b ? a : b;
139     }    
140 }
141 
142 library SafeMath {
143   /**
144   * @dev Multiplies two numbers, throws on overflow.
145   */
146   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147     if (a == 0) {
148       return 0;
149     }
150     uint256 c = a * b;
151     assert(c / a == b);
152     return c;
153   }
154   
155   /**
156   * @dev Integer division of two numbers, truncating the quotient.
157   */
158   function div(uint256 a, uint256 b) internal pure returns (uint256) {
159     // assert(b > 0); // Solidity automatically throws when dividing by 0
160     uint256 c = a / b;
161     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162     return c;
163   }
164   
165   /**
166   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167   */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     assert(b <= a);
170     return a - b;
171   }
172   
173   /**
174   * @dev Adds two numbers, throws on overflow.
175   */
176   function add(uint256 a, uint256 b) internal pure returns (uint256) {
177     uint256 c = a + b;
178     assert(c >= a);
179     return c;
180   }
181 }
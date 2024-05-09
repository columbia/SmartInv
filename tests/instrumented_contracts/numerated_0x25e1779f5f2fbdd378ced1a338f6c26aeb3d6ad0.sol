1 // similar to shrimp/snail
2 // you lose one third of your spiders on sell                                                                                  anti-inflation + longevity
3 // freebies on a set price of 0.001 and only 50                                                                                anti-bot
4 // every three days the global eggs are reduced by 20%                                                                         anti-inflation
5 // you are able to compete for the spider queen which gives you 3% of the fees and the fixed 0.001 of the freebies             competition + longevity
6 // if you buy the title you lose a set amound of eggs, first title costs 100000 eggs, adding 100k each time                    anti-inflation + competition + longevity
7 // lower seed of 864000000 instead of 8640000000 to make the early game slower, more fair and stop hyperinflation              anti-inflation + competition + longevity
8 // lower referral (10%) to fight ref abuse as seen on shrimp                                                                   anti-inflation + anti-bot
9 
10 contract SpiderFarm{
11     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
12     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
13     uint256 public STARTING_SHRIMP=50;
14     uint256 PSN=10000;
15     uint256 PSNH=5000;
16     uint256 startTime;
17     bool public initialized=false;
18     address public ceoAddress;
19     address public owner;
20     mapping (address => uint256) public hatcheryShrimp;
21     mapping (address => uint256) public claimedEggs;
22     mapping (address => uint256) public lastHatch;
23     mapping (address => address) public referrals;
24     uint256 public marketEggs;
25     uint256 public snailmasterReq=100000;
26    
27     function becomeSnailmaster() public{
28         uint256 hasEggs=getMyEggs();
29         uint256 eggCount=SafeMath.div(hasEggs,EGGS_TO_HATCH_1SHRIMP);
30         require(initialized);
31         require(msg.sender != ceoAddress);
32         require(eggCount>=snailmasterReq);
33         claimedEggs[msg.sender]=0;
34         snailmasterReq=SafeMath.add(snailmasterReq,100000);//+100k shrimps each time
35         ceoAddress=msg.sender;
36     }
37     function hatchEggs(address ref) public{
38         require(initialized);
39         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
40             referrals[msg.sender]=ref;
41         }
42         uint256 eggsUsed=getMyEggs();
43         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
44         uint256 timer=tmp();
45         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
46         claimedEggs[msg.sender]=0;
47         lastHatch[msg.sender]=now;
48         if (timer>=1) {
49         marketEggs=SafeMath.mul(SafeMath.div(marketEggs,5),4);
50         startTime=now;
51         }
52         
53         //send referral eggs
54         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,10));
55         
56         //boost market to nerf hoarding
57         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
58         
59     }
60     function sellEggs() public{
61         require(initialized);
62         uint256 hasEggs=getMyEggs();
63         uint256 eggValue=calculateEggSell(hasEggs);
64         uint256 fee=devFee(eggValue);
65         uint256 fee2=devFee2(eggValue);
66         uint256 overallfee=SafeMath.add(fee,fee2);
67         // one third of investors die on dump
68         hatcheryShrimp[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryShrimp[msg.sender],3),2);
69         claimedEggs[msg.sender]=0;
70         lastHatch[msg.sender]=now;
71         marketEggs=SafeMath.add(marketEggs,hasEggs);
72         ceoAddress.transfer(fee);
73         owner.transfer(fee2);
74         msg.sender.transfer(SafeMath.sub(eggValue,overallfee));
75     }
76     function buyEggs() public payable{
77         require(initialized);
78         uint256 fee=devFee(eggsBought);
79         uint256 fee2=devFee2(eggsBought);
80         uint256 overallfee=SafeMath.add(fee,fee2);
81         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
82         eggsBought=SafeMath.sub(eggsBought,overallfee);
83         ceoAddress.transfer(devFee(msg.value));
84         owner.transfer(devFee2(msg.value));
85         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
86     }
87     //magic trade balancing algorithm
88     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
89         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
90         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
91     }
92     
93     function calculateEggSell(uint256 eggs) public view returns(uint256){
94         return calculateTrade(eggs,marketEggs,this.balance);
95     }
96     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
97         return calculateTrade(eth,contractBalance,marketEggs);
98     }
99     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
100         return calculateEggBuy(eth,this.balance);
101     }
102     function devFee(uint256 amount) public view returns(uint256){
103         return SafeMath.div(SafeMath.mul(amount,2),100);
104     }
105     function devFee2(uint256 amount) public view returns(uint256){
106         return SafeMath.div(SafeMath.mul(amount,3),100);
107     }
108     function seedMarket(uint256 eggs) public payable{
109         require(marketEggs==0);
110         initialized=true;
111         marketEggs=eggs;
112     }
113     function getFreeShrimp() public payable{
114         require(initialized);
115         require(msg.value==0.001 ether);
116         ceoAddress.transfer(msg.value); //goes to spider queen
117         require(hatcheryShrimp[msg.sender]==0);
118         lastHatch[msg.sender]=now;
119         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
120     }
121     function getBalance() public view returns(uint256){
122         return this.balance;
123     }
124     function getMyShrimp() public view returns(uint256){
125         return hatcheryShrimp[msg.sender];
126     }
127     function getSnailmasterReq() public view returns(uint256){
128         return snailmasterReq;
129     }
130     function getMyEggs() public view returns(uint256){
131         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
132     }
133     function updateEggs() public view returns(uint256){
134         return SafeMath.sub(claimedEggs[msg.sender],snailmasterReq);
135     }
136     function SpiderFarm() public{
137         ceoAddress=msg.sender;
138         owner=0xa76490c1f5fbf4d5101430c3cd2E63f33D21C738;
139     }
140     function getEggsSinceLastHatch(address adr) public view returns(uint256){
141         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
142         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
143     }
144     function min(uint256 a, uint256 b) private pure returns (uint256) {
145         return a < b ? a : b;
146     }
147     function tmp() public returns(uint){
148          require(startTime != 0);
149          return (now - startTime)/(4320 minutes);
150     }
151     function callThisToStart() public {
152         if(owner != msg.sender) throw;
153         startTime = now;
154         
155     }
156     function callThisToStop() public {
157         if(owner != msg.sender) throw;
158         startTime = 0;
159     }
160 
161 }
162 
163 library SafeMath {
164 
165   /**
166   * @dev Multiplies two numbers, throws on overflow.
167   */
168   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169     if (a == 0) {
170       return 0;
171     }
172     uint256 c = a * b;
173     assert(c / a == b);
174     return c;
175   }
176 
177   /**
178   * @dev Integer division of two numbers, truncating the quotient.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return c;
185   }
186 
187   /**
188   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     assert(b <= a);
192     return a - b;
193   }
194 
195   /**
196   * @dev Adds two numbers, throws on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256) {
199     uint256 c = a + b;
200     assert(c >= a);
201     return c;
202   }
203 }
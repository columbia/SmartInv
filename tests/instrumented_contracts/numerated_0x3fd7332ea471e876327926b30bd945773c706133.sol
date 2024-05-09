1 pragma solidity ^0.4.24;
2 
3 contract Oasis{
4     function getBestOffer(address sell_gem, address buy_gem) public constant returns(uint256);
5     function getOffer(uint id) public constant returns (uint, address, uint, address);
6 }
7 
8 contract EtherShrimpFutures{
9     using SafeMath for uint;
10     Oasis market;
11     address public dai = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
12     address public weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
13     uint256 public EGGS_TO_HATCH_1SHRIMP=86400; //seconds in a day
14     uint256 public STARTING_SHRIMP=300;
15     uint256 internal PSN=10000;
16     uint256 internal PSNH=5000;
17     bool public initialized=false;
18     uint256 public marketEggs;
19     address public ceoAddress;
20     uint256 public numberOfFarmers;
21     mapping (address => uint256) public hatcheryShrimp;
22     mapping (address => uint256) public claimedEggs;
23     mapping (address => uint256) public lastHatch;
24     mapping (address => address) public referrals;
25     mapping (address => uint256) public lastHatchPrice;
26     address[] farmers;
27     
28     constructor() public{
29         ceoAddress=msg.sender;
30         market = Oasis(0x14FBCA95be7e99C15Cc2996c6C9d841e54B79425);
31     }
32     function hatchEggs(address ref) public{
33         require(initialized);
34         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
35             referrals[msg.sender]=ref;
36         }
37         if(hatcheryShrimp[msg.sender] == 0){
38             numberOfFarmers += 1;
39             farmers.push(msg.sender);
40         }
41         uint256 eggsUsed=getMyEggs();
42         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
43         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
44         claimedEggs[msg.sender]=0;
45         lastHatch[msg.sender]=now;
46         lastHatchPrice[msg.sender] = getPrice();
47         //send referral eggs
48         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
49         //boost market to nerf shrimp hoarding
50         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
51         
52     }
53     function sellEggs() public{
54         require(initialized);
55         uint256 hasEggs=getMyEggs();
56         uint256 eggValue=calculateEggSell(hasEggs,msg.sender);
57         uint256 fee=devFee(eggValue);
58         claimedEggs[msg.sender]=0;
59         lastHatch[msg.sender]=now;
60         marketEggs=SafeMath.add(marketEggs,hasEggs);
61         ceoAddress.transfer(fee);
62         msg.sender.transfer(SafeMath.sub(eggValue,fee));
63     }
64     function buyEggs() public payable{
65         require(initialized);
66         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
67         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
68         ceoAddress.transfer(devFee(msg.value));
69         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
70     }
71     //magic trade balancing algorithm
72     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
73         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
74         return SafeMath.div( SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
75     }
76     function calculateEggSell(uint256 eggs, address adr) public view returns(uint256){
77         uint sellValue = calculateTrade(eggs,marketEggs,address(this).balance);
78         uint currentPrice = getPrice();
79         uint diff = getDiff(currentPrice,lastHatchPrice[adr]);
80         uint bonusFactor = SafeMath.mul(diff,5);
81         if(bonusFactor > 1e18) {
82             bonusFactor = 1e18; //at max stay true to original
83         }
84         return SafeMath.mul(sellValue,bonusFactor).div(1e18);
85     }
86     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
87         return calculateTrade(eth,contractBalance,marketEggs);
88     }
89     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
90         return calculateEggBuy(eth,address(this).balance);
91     }
92     function devFee(uint256 amount) public view returns(uint256){
93         return SafeMath.div(SafeMath.mul(amount,2),100);
94     }
95     function seedMarket(uint256 eggs) public payable{
96         require(marketEggs==0);
97         initialized=true;
98         marketEggs=eggs;
99     }
100     function getFreeShrimp() public{
101         require(initialized);
102         require(hatcheryShrimp[msg.sender]==0);
103         numberOfFarmers += 1;
104         farmers.push(msg.sender);
105         lastHatch[msg.sender]=now;
106         lastHatchPrice[msg.sender] = getPrice();
107         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
108     }
109     function getBalance() public view returns(uint256){
110         return address(this).balance;
111     }
112     function getMyShrimp() public view returns(uint256){
113         return hatcheryShrimp[msg.sender];
114     }
115     function getMyEggs() public view returns(uint256){
116         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
117     }
118     function getEggsSinceLastHatch(address adr) public view returns(uint256){
119         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
120         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
121     }
122     function getLastHatchPrice(address adr) public view returns(uint256) {
123         return lastHatchPrice[adr];
124     }
125     function min(uint256 a, uint256 b) private pure returns (uint256) {
126         return a < b ? a : b;
127     }
128     function getDiff(uint256 a, uint256 b) public view returns(uint256) {
129         uint change;
130         uint diff;
131         if( a >= b ) change = a - b;
132         else change = b - a;
133         if( change != 0 ) diff = SafeMath.div(change*1e18, b); //b is the final value
134         return diff;
135     }
136     function getPrice() public view returns(uint256) {
137         uint id1 = market.getBestOffer(weth,dai);
138         uint id2 = market.getBestOffer(dai,weth);
139         uint payAmt;
140         uint buyAmt;
141         address payGem;
142         address buyGem;
143         (payAmt, payGem, buyAmt, buyGem) = market.getOffer(id1);
144         uint price1 = SafeMath.div(buyAmt*1e18, payAmt);
145         (payAmt, payGem, buyAmt, buyGem) = market.getOffer(id2);
146         uint price2 = SafeMath.div(payAmt*1e18, buyAmt);
147         uint avgPrice = SafeMath.add(price1,price2).div(2);
148         return avgPrice;
149     }
150     function getPoolAvgHatchPrice() public view returns(uint256) {
151         uint256 poolSum;
152         for(uint i=0; i<farmers.length; i++) {
153             poolSum = SafeMath.add(lastHatchPrice[farmers[i]],poolSum);
154         }
155         return SafeMath.div(poolSum,farmers.length);
156     }
157 }
158 
159 library SafeMath {
160 
161   /**
162   * @dev Multiplies two numbers, throws on overflow.
163   */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165     if (a == 0) {
166       return 0;
167     }
168     uint256 c = a * b;
169     assert(c / a == b);
170     return c;
171   }
172 
173   /**
174   * @dev Integer division of two numbers, truncating the quotient.
175   */
176   function div(uint256 a, uint256 b) internal pure returns (uint256) {
177     // assert(b > 0); // Solidity automatically throws when dividing by 0
178     uint256 c = a / b;
179     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
180     return c;
181   }
182 
183   /**
184   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
185   */
186   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
187     assert(b <= a);
188     return a - b;
189   }
190 
191   /**
192   * @dev Adds two numbers, throws on overflow.
193   */
194   function add(uint256 a, uint256 b) internal pure returns (uint256) {
195     uint256 c = a + b;
196     assert(c >= a);
197     return c;
198   }
199 }
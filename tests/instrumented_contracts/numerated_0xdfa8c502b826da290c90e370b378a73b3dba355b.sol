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
27     constructor() public{
28         ceoAddress=msg.sender;
29         market = Oasis(0x14FBCA95be7e99C15Cc2996c6C9d841e54B79425);
30     }
31     function hatchEggs(address ref) public{
32         require(initialized);
33         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
34             referrals[msg.sender]=ref;
35         }
36         uint256 eggsUsed=getMyEggs();
37         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
38         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
39         claimedEggs[msg.sender]=0;
40         lastHatch[msg.sender]=now;
41         lastHatchPrice[msg.sender] = getPrice();
42         //send referral eggs
43         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
44         //boost market to nerf shrimp hoarding
45         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
46     }
47     function sellEggs() public{
48         require(initialized);
49         uint256 hasEggs=getMyEggs();
50         uint256 eggValue=calculateEggSell(hasEggs,msg.sender);
51         require(eggValue>0);
52         uint256 fee=devFee(eggValue);
53         claimedEggs[msg.sender]=0;
54         lastHatch[msg.sender]=now;
55         marketEggs=SafeMath.add(marketEggs,hasEggs);
56         ceoAddress.transfer(fee);
57         msg.sender.transfer(SafeMath.sub(eggValue,fee));
58     }
59     function buyEggs() public payable{
60         require(initialized);
61         if(hatcheryShrimp[msg.sender] == 0){
62             numberOfFarmers += 1;
63             farmers.push(msg.sender);
64         }
65         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
66         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
67         ceoAddress.transfer(devFee(msg.value));
68         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
69     }
70     //magic trade balancing algorithm
71     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
72         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
73         return SafeMath.div( SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
74     }
75     function calculateEggSell(uint256 eggs, address adr) public view returns(uint256){
76         uint sellValue = calculateTrade(eggs,marketEggs,address(this).balance);
77         uint currentPrice = getPrice();
78         uint diff = getDiff(currentPrice,lastHatchPrice[adr]);
79         uint bonusFactor = SafeMath.mul(diff,7);
80         if(bonusFactor > 1e18) {
81             bonusFactor = 1e18; //at max stay true to original
82         }
83         return SafeMath.mul(sellValue,bonusFactor).div(1e18);
84     }
85     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
86         return calculateTrade(eth,contractBalance,marketEggs);
87     }
88     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
89         return calculateEggBuy(eth,address(this).balance);
90     }
91     function devFee(uint256 amount) public view returns(uint256){
92         return SafeMath.div(SafeMath.mul(amount,2),100);
93     }
94     function seedMarket(uint256 eggs) public payable{
95         require(marketEggs==0);
96         initialized=true;
97         marketEggs=eggs;
98     }
99     function getFreeShrimp() public{
100         require(initialized);
101         require(hatcheryShrimp[msg.sender]==0);
102         numberOfFarmers += 1;
103         farmers.push(msg.sender);
104         lastHatch[msg.sender]=now;
105         lastHatchPrice[msg.sender] = getPrice();
106         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
107     }
108     function getBalance() public view returns(uint256){
109         return address(this).balance;
110     }
111     function getMyShrimp() public view returns(uint256){
112         return hatcheryShrimp[msg.sender];
113     }
114     function getMyEggs() public view returns(uint256){
115         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
116     }
117     function getEggsSinceLastHatch(address adr) public view returns(uint256){
118         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
119         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
120     }
121     function getLastHatchPrice(address adr) public view returns(uint256) {
122         return lastHatchPrice[adr];
123     }
124     function min(uint256 a, uint256 b) private pure returns (uint256) {
125         return a < b ? a : b;
126     }
127     function getDiff(uint256 a, uint256 b) public view returns(uint256) {
128         uint change;
129         uint diff;
130         if( a >= b ) change = a - b;
131         else change = b - a;
132         if( change != 0 ) diff = SafeMath.div(change*1e18, b); //b is the final value
133         return diff;
134     }
135     function getPrice() public view returns(uint256) {
136         uint id1 = market.getBestOffer(weth,dai);
137         uint id2 = market.getBestOffer(dai,weth);
138         uint payAmt;
139         uint buyAmt;
140         address payGem;
141         address buyGem;
142         (payAmt, payGem, buyAmt, buyGem) = market.getOffer(id1);
143         uint price1 = SafeMath.div(buyAmt*1e18, payAmt);
144         (payAmt, payGem, buyAmt, buyGem) = market.getOffer(id2);
145         uint price2 = SafeMath.div(payAmt*1e18, buyAmt);
146         uint avgPrice = SafeMath.add(price1,price2).div(2);
147         return avgPrice;
148     }
149     function getPoolAvgHatchPrice() public view returns(uint256) {
150         uint256 poolSum;
151         for(uint i=0; i<farmers.length; i++) {
152             poolSum = SafeMath.add(lastHatchPrice[farmers[i]],poolSum);
153         }
154         return SafeMath.div(poolSum,farmers.length);
155     }
156 }
157 
158 library SafeMath {
159 
160   /**
161   * @dev Multiplies two numbers, throws on overflow.
162   */
163   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164     if (a == 0) {
165       return 0;
166     }
167     uint256 c = a * b;
168     assert(c / a == b);
169     return c;
170   }
171 
172   /**
173   * @dev Integer division of two numbers, truncating the quotient.
174   */
175   function div(uint256 a, uint256 b) internal pure returns (uint256) {
176     // assert(b > 0); // Solidity automatically throws when dividing by 0
177     uint256 c = a / b;
178     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179     return c;
180   }
181 
182   /**
183   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
184   */
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     assert(b <= a);
187     return a - b;
188   }
189 
190   /**
191   * @dev Adds two numbers, throws on overflow.
192   */
193   function add(uint256 a, uint256 b) internal pure returns (uint256) {
194     uint256 c = a + b;
195     assert(c >= a);
196     return c;
197   }
198 }
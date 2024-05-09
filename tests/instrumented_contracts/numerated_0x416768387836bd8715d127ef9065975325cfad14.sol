1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract GoTDragonFarm {
4     uint256 public EGGS_TO_HATCH_1DRAGON = 43200; // every 12 hours
5     
6     uint256 PSN = 10000;
7     uint256 PSNH = 5000;
8     
9     bool public initialized = false;
10     
11     address public ceoAddress;
12     
13     mapping (address => uint256) public hatchery;
14     mapping (address => uint256) public claimedEggs;
15     mapping (address => uint256) public lastHatch;
16     mapping (address => address) public referrals;
17     
18     uint256 public marketEggs;
19     
20     event Buy(address _from, uint256 _eggs);
21     event Sell(address _from, uint256 _eggs);
22     event Hatch(address _from, uint256 _eggs, uint256 _dragons);
23     
24     constructor() public {
25         ceoAddress=msg.sender;
26     }
27     
28     function hatchEggs(address ref) public {
29         require(initialized);
30         
31         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender){
32             referrals[msg.sender] = ref;
33         }
34         
35         uint256 eggsUsed = getMyEggs();
36         
37         uint256 newDragons = SafeMath.div(eggsUsed, EGGS_TO_HATCH_1DRAGON);
38         hatchery[msg.sender] = SafeMath.add(hatchery[msg.sender], newDragons);
39         claimedEggs[msg.sender] = 0;
40         lastHatch[msg.sender] = now;
41         
42         //send referral eggs
43         claimedEggs[referrals[msg.sender]] = SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
44         
45         //boost market to nerf dragon hoarding
46         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
47         
48         emit Hatch(msg.sender, eggsUsed, newDragons);
49     }
50     
51     function sellEggs() public {
52         require(initialized);
53         
54         uint256 hasEggs = getMyEggs();
55         uint256 eggValue = calculateEggSell(hasEggs);
56         
57         uint256 fee = calculateDevFee(eggValue);
58         
59         claimedEggs[msg.sender] = 0;
60         lastHatch[msg.sender] = now;
61         marketEggs = SafeMath.add(marketEggs,hasEggs);
62         
63         ceoAddress.transfer(fee);
64         
65         msg.sender.transfer(SafeMath.sub(eggValue,fee));
66         
67         emit Sell(msg.sender, hasEggs);
68     }
69     
70     function buyEggs() public payable {
71         require(initialized);
72         
73         uint256 eggsBought = calculateEggBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
74         eggsBought = SafeMath.sub(eggsBought, calculateDevFee(eggsBought));
75         
76         ceoAddress.transfer(calculateDevFee(msg.value));
77         
78         claimedEggs[msg.sender] = SafeMath.add(claimedEggs[msg.sender], eggsBought);
79         
80         emit Buy(msg.sender, eggsBought);
81     }
82     
83     //magic trade balancing algorithm
84     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
85         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
86         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
87     }
88     
89     function calculateEggSell(uint256 eggs) public view returns(uint256){
90         return calculateTrade(eggs,marketEggs, address(this).balance);
91     }
92     
93     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
94         return calculateTrade(eth,contractBalance,marketEggs);
95     }
96     
97     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
98         return calculateEggBuy(eth, address(this).balance);
99     }
100     
101     function calculateDevFee(uint256 amount) public view returns(uint256){
102         return SafeMath.div(SafeMath.mul(amount,4),100);
103     }
104     
105     function seedMarket(uint256 eggs) public payable{
106         require(marketEggs == 0);
107         initialized = true;
108         marketEggs = eggs;
109     }
110     
111     function claimFreeDragon() public{
112         require(initialized);
113         require(hatchery[msg.sender] == 0);
114         lastHatch[msg.sender] = now;
115         hatchery[msg.sender] = 300;
116     }
117     
118     function getBalance() public view returns(uint256){
119         return address(this).balance;
120     }
121     
122     function getMyDragons() public view returns(uint256){
123         return hatchery[msg.sender];
124     }
125     
126     function getMyEggs() public view returns(uint256){
127         return SafeMath.add(claimedEggs[msg.sender], getEggsSinceLastHatch(msg.sender));
128     }
129     
130     function getEggsSinceLastHatch(address _address) public view returns(uint256){
131         uint256 secondsPassed = min(EGGS_TO_HATCH_1DRAGON, SafeMath.sub(now, lastHatch[_address]));
132         return SafeMath.mul(secondsPassed, hatchery[_address]);
133     }
134     
135     function min(uint256 a, uint256 b) private pure returns (uint256) {
136         return a < b ? a : b;
137     }
138 }
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   /**
155   * @dev Integer division of two numbers, truncating the quotient.
156   */
157   function div(uint256 a, uint256 b) internal pure returns (uint256) {
158     // assert(b > 0); // Solidity automatically throws when dividing by 0
159     uint256 c = a / b;
160     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
161     return c;
162   }
163 
164   /**
165   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
166   */
167   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168     assert(b <= a);
169     return a - b;
170   }
171 
172   /**
173   * @dev Adds two numbers, throws on overflow.
174   */
175   function add(uint256 a, uint256 b) internal pure returns (uint256) {
176     uint256 c = a + b;
177     assert(c >= a);
178     return c;
179   }
180 }
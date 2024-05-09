1 pragma solidity ^0.4.18;
2 
3 
4 contract CryptoStrippers{
5 
6     uint256 public COINS_TO_HATCH_1STRIPPERS = 86400;
7     uint256 public STARTING_STRIPPERS = 500;
8     uint256 PSN = 10000;
9     uint256 PSNH = 5000;
10     bool public initialized = true;
11     address public ceoAddress;
12     mapping (address => uint256) public hatcheryStrippers;
13     mapping (address => uint256) public claimedCoins;
14     mapping (address => uint256) public lastHatch;
15     mapping (address => address) public referrals;
16     uint256 public marketCoins;
17 
18 
19     function CryptoStrippers() public{
20         ceoAddress = msg.sender;
21     }
22 
23     /**
24     * @dev hatchCoins produce coins
25     */
26     function hatchCoins(address ref) public{
27         require(initialized);
28         if(referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender){
29             referrals[msg.sender] = ref;
30         }
31         uint256 coinsUsed = getMyCoins();
32         uint256 newStrippers = SafeMath.div(coinsUsed,COINS_TO_HATCH_1STRIPPERS);
33         hatcheryStrippers[msg.sender] = SafeMath.add(hatcheryStrippers[msg.sender],newStrippers);
34         claimedCoins[msg.sender] = 0;
35         lastHatch[msg.sender] = now;
36         claimedCoins[referrals[msg.sender]] = SafeMath.add(claimedCoins[referrals[msg.sender]],SafeMath.div(coinsUsed,5));
37         marketCoins = SafeMath.add(marketCoins,SafeMath.div(coinsUsed,10));
38     }
39 
40     function sellCoins() public{
41         require(initialized);
42         uint256 hasCoins = getMyCoins();
43         uint256 coinValue = calculateCoinSell(hasCoins);
44         uint256 fee = devFee(coinValue);
45         claimedCoins[msg.sender] = 0;
46         lastHatch[msg.sender] = now;
47         marketCoins = SafeMath.add(marketCoins,hasCoins);
48         ceoAddress.transfer(fee);
49         msg.sender.transfer(SafeMath.sub(coinValue,fee));
50     }
51 
52     function buyCoins() public payable{
53         require(initialized);
54         uint256 coinsBought = calculateCoinBuy(msg.value,SafeMath.sub(this.balance,msg.value));
55         coinsBought = SafeMath.sub(coinsBought,devFee(coinsBought));
56         ceoAddress.transfer(devFee(msg.value));
57         claimedCoins[msg.sender] = SafeMath.add(claimedCoins[msg.sender],coinsBought);
58     }
59 
60     /**
61     * @dev Computational cost
62     */
63     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
64         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
65     }
66 
67     function calculateCoinSell(uint256 coins) public view returns(uint256){
68         return calculateTrade(coins,marketCoins,this.balance);
69     }
70 
71     function calculateCoinBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
72         return calculateTrade(eth,contractBalance,marketCoins);
73     }
74 
75     function calculateCoinBuySimple(uint256 eth) public view returns(uint256){
76         return calculateCoinBuy(eth,this.balance);
77     }
78 
79     function devFee(uint256 amount) public view returns(uint256){
80         return SafeMath.div(SafeMath.mul(amount,4),100);
81     }
82 
83     function seedMarket(uint256 coins) public payable{
84         require(marketCoins==0);
85         initialized=true;
86         marketCoins=coins;
87     }
88 
89     function getFreeStrippers() public{
90         require(initialized);
91         require(hatcheryStrippers[msg.sender]==0);
92         lastHatch[msg.sender]=now;
93         hatcheryStrippers[msg.sender]=STARTING_STRIPPERS;
94     }
95 
96     function getBalance() public view returns(uint256){
97         return this.balance;
98     }
99 
100     function getMyStrippers() public view returns(uint256){
101         return hatcheryStrippers[msg.sender];
102     }
103 
104     function getMyCoins() public view returns(uint256){
105         return SafeMath.add(claimedCoins[msg.sender],getCoinsSinceLastHatch(msg.sender));
106     }
107 
108     function getCoinsSinceLastHatch(address adr) public view returns(uint256){
109         uint256 secondsPassed=min(COINS_TO_HATCH_1STRIPPERS,SafeMath.sub(now,lastHatch[adr]));
110         return SafeMath.mul(secondsPassed,hatcheryStrippers[adr]);
111     }
112 
113     function min(uint256 a, uint256 b) private pure returns (uint256) {
114         return a < b ? a : b;
115     }
116 
117 }
118 
119 library SafeMath {
120 
121   /**
122   * @dev Multiplies two numbers, throws on overflow.
123   */
124   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125     if (a == 0) {
126       return 0;
127     }
128     uint256 c = a * b;
129     assert(c / a == b);
130     return c;
131   }
132 
133   /**
134   * @dev Integer division of two numbers, truncating the quotient.
135   */
136   function div(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a / b;
138     return c;
139   }
140 
141   /**
142   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
143   */
144   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145     assert(b <= a);
146     return a - b;
147   }
148 
149   /**
150   * @dev Adds two numbers, throws on overflow.
151   */
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     assert(c >= a);
155     return c;
156   }
157 }
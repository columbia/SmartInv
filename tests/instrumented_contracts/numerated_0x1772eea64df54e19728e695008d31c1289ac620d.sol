1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 //==============================================================================
4 //  . _ _|_ _  _ |` _  _ _  _  .
5 //  || | | (/_| ~|~(_|(_(/__\  .
6 //==============================================================================
7 
8 interface Lucky8DInterface {
9     function redistribution() external payable;
10 }
11 
12 contract RiceFarmer{
13 
14     uint256 public SEEDS_TO_HATCH_1RICE=86400;//for final version should be seconds in a day
15     uint256 public STARTING_RICE=300;
16     uint256 PSN=10000;
17     uint256 PSNH=5000;
18     bool public initialized=false;
19     address public ceoAddress;
20     mapping (address => uint256) public hatcheryRice;
21     mapping (address => uint256) public claimedSeeds;
22     mapping (address => uint256) public lastHatch;
23     mapping (address => address) public referrals;
24     uint256 public marketSeeds;
25 
26 
27     Lucky8DInterface constant private Divies = Lucky8DInterface(0xe7BBBC53d2D1B9e1099BeF0E3E2F2C74cd1D2B98);
28 
29 
30     function RiceFarmer() public{
31         ceoAddress=msg.sender;
32     }
33 
34 
35     function hatchSeeds(address ref) public{
36         require(initialized);
37         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
38             referrals[msg.sender]=ref;
39         }
40         uint256 eggsUsed=getMySeeds();
41         uint256 newRice=SafeMath.div(eggsUsed,SEEDS_TO_HATCH_1RICE);
42         hatcheryRice[msg.sender]=SafeMath.add(hatcheryRice[msg.sender],newRice);
43         claimedSeeds[msg.sender]=0;
44         lastHatch[msg.sender]=now;
45 
46         //send referral eggs
47         claimedSeeds[referrals[msg.sender]]=SafeMath.add(claimedSeeds[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
48 
49         //boost market to nerf rice hoarding
50         marketSeeds=SafeMath.add(marketSeeds,SafeMath.div(eggsUsed,10));
51     }
52     function sellSeeds() public{
53         require(initialized);
54         uint256 hasSeeds=getMySeeds();
55         uint256 eggValue=calculateSeedSell(hasSeeds);
56         uint256 fee=devFee(eggValue);
57         claimedSeeds[msg.sender]=0;
58         lastHatch[msg.sender]=now;
59         marketSeeds=SafeMath.add(marketSeeds,hasSeeds);
60 
61         Divies.redistribution.value(fee)();
62 
63         msg.sender.transfer(SafeMath.sub(eggValue,fee));
64     }
65     function buySeeds() public payable{
66         require(initialized);
67         uint256 eggsBought=calculateSeedBuy(msg.value,SafeMath.sub(this.balance,msg.value));
68         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
69 
70         Divies.redistribution.value(devFee(msg.value))();
71 
72         claimedSeeds[msg.sender]=SafeMath.add(claimedSeeds[msg.sender],eggsBought);
73     }
74 
75     //magic trade balancing algorithm
76     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
77         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
78         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
79     }
80     function calculateSeedSell(uint256 eggs) public view returns(uint256){
81         return calculateTrade(eggs,marketSeeds,this.balance);
82     }
83     function calculateSeedBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
84         return calculateTrade(eth,contractBalance,marketSeeds);
85     }
86     function calculateSeedBuySimple(uint256 eth) public view returns(uint256){
87         return calculateSeedBuy(eth,this.balance);
88     }
89 
90     function devFee(uint256 amount) public view returns(uint256){
91         return SafeMath.div(SafeMath.mul(amount,5),100);
92     }
93 
94     function seedMarket(uint256 eggs) public payable{
95         require(marketSeeds==0);
96         initialized=true;
97         marketSeeds=eggs;
98     }
99     function getBalance() public view returns(uint256){
100         return this.balance;
101     }
102     function getMyRice() public view returns(uint256){
103         return hatcheryRice[msg.sender];
104     }
105     function getMySeeds() public view returns(uint256){
106         return SafeMath.add(claimedSeeds[msg.sender],getSeedsSinceLastHatch(msg.sender));
107     }
108     function getSeedsSinceLastHatch(address adr) public view returns(uint256){
109         uint256 secondsPassed=min(SEEDS_TO_HATCH_1RICE,SafeMath.sub(now,lastHatch[adr]));
110         return SafeMath.mul(secondsPassed,hatcheryRice[adr]);
111     }
112     function min(uint256 a, uint256 b) private pure returns (uint256) {
113         return a < b ? a : b;
114     }
115 }
116 
117 library SafeMath {
118 
119   /**
120   * @dev Multiplies two numbers, throws on overflow.
121   */
122   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123     if (a == 0) {
124       return 0;
125     }
126     uint256 c = a * b;
127     assert(c / a == b);
128     return c;
129   }
130 
131   /**
132   * @dev Integer division of two numbers, truncating the quotient.
133   */
134   function div(uint256 a, uint256 b) internal pure returns (uint256) {
135     // assert(b > 0); // Solidity automatically throws when dividing by 0
136     uint256 c = a / b;
137     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
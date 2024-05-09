1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract SwordMaster{    
4     uint256 public GOLD_TO_COLLECT_1SWORD=86400;
5     uint256 public SECONDS_OF_DAY=86400;
6     uint256 public STARTING_SWORD=300;
7     uint256 public MIN_GOLD_TO_UPGRADE = 300;
8     uint256 PSN=10000;
9     uint256 PSNH=5000;
10     bool public initialized=false;
11     address public ceoAddress;
12     mapping (address => uint256) public swordLevel;
13     mapping (address => uint256) public claimedGolds;
14     mapping (address => uint256) public lastCollect;
15     mapping (address => address) public referrals;
16     uint256 public marketGolds;
17     function SwordMaster() public{
18         ceoAddress=msg.sender;
19     }
20     function upgradeSword(address ref) public{
21         require(initialized);
22         if(referrals[msg.sender]==0 && msg.sender!=ref){
23             referrals[msg.sender]=ref;
24         }
25         uint256 goldUsed=getMyGolds();
26         uint256 newGold=SafeMath.div(goldUsed,GOLD_TO_COLLECT_1SWORD);
27         uint256 remainGold = newGold % MIN_GOLD_TO_UPGRADE;
28         newGold = SafeMath.sub(newGold,remainGold);
29         if(newGold <=0){
30             return;
31         } // upgrade failed
32         swordLevel[msg.sender]=SafeMath.add(swordLevel[msg.sender],newGold);
33         claimedGolds[msg.sender]=SafeMath.mul(remainGold,GOLD_TO_COLLECT_1SWORD);
34         lastCollect[msg.sender]=now;
35         
36         //send referral gold
37         claimedGolds[referrals[msg.sender]]=SafeMath.add(claimedGolds[referrals[msg.sender]],SafeMath.div(newGold * GOLD_TO_COLLECT_1SWORD,5));
38         
39         //boost market to nerf sword hoarding
40         marketGolds=SafeMath.add(marketGolds,SafeMath.div(newGold * GOLD_TO_COLLECT_1SWORD,10));
41     }
42     function sellGolds() public{
43         require(initialized);
44         uint256 hasGolds=getMyGolds();
45         uint256 goldValue=calculateGoldSell(hasGolds);
46         uint256 fee=devFee(goldValue);
47         claimedGolds[msg.sender]=0;
48         lastCollect[msg.sender]=now;
49         marketGolds=SafeMath.add(marketGolds,hasGolds);
50         ceoAddress.transfer(fee);
51         msg.sender.transfer(SafeMath.sub(goldValue,fee));
52     }
53     function buyGolds() public payable{
54         require(initialized);
55         uint256 goldsBought=calculateGoldBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
56         goldsBought=SafeMath.sub(goldsBought,devFee(goldsBought));
57         ceoAddress.transfer(devFee(msg.value));
58         claimedGolds[msg.sender]=SafeMath.add(claimedGolds[msg.sender],goldsBought);
59     }
60     //magic trade balancing algorithm
61     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
62         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
63         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
64     }
65     function calculateGoldSell(uint256 golds) public view returns(uint256){
66         return calculateTrade(golds,marketGolds,address(this).balance);
67     }
68     function calculateGoldBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
69         return calculateTrade(eth,contractBalance,marketGolds);
70     }
71     function calculateGoldBuySimple(uint256 eth) public view returns(uint256){
72         return calculateGoldBuy(eth,address(this).balance);
73     }
74     function devFee(uint256 amount) public pure returns(uint256){
75         return SafeMath.div(SafeMath.mul(amount,4),100);
76     }
77     function seedMarket(uint256 golds) public payable{
78         require(marketGolds==0);
79         initialized=true;
80         marketGolds=golds;
81     }
82     function getFreeSword() public{
83         require(initialized);
84         require(swordLevel[msg.sender]==0);
85         lastCollect[msg.sender]=now;
86         swordLevel[msg.sender]=STARTING_SWORD;
87     }
88     function getBalance() public view returns(uint256){
89         return address(this).balance;
90     }
91     function getMySword() public view returns(uint256){
92         return swordLevel[msg.sender];
93     }
94     function getMyGolds() public view returns(uint256){
95         return SafeMath.add(claimedGolds[msg.sender],getGoldsSinceLastCollect(msg.sender));
96     }
97     function getGoldsSinceLastCollect(address adr) public view returns(uint256){
98         uint256 secondsPassed=min(SECONDS_OF_DAY,SafeMath.sub(now,lastCollect[adr]));
99         return SafeMath.mul(secondsPassed,swordLevel[adr]);
100     }
101     function min(uint256 a, uint256 b) private pure returns (uint256) {
102         return a < b ? a : b;
103     }
104 }
105 
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     if (a == 0) {
113       return 0;
114     }
115     uint256 c = a * b;
116     assert(c / a == b);
117     return c;
118   }
119 
120   /**
121   * @dev Integer division of two numbers, truncating the quotient.
122   */
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   /**
131   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
132   */
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   /**
139   * @dev Adds two numbers, throws on overflow.
140   */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract EtherCartel{
6     //uint256 DRUGS_TO_PRODUCE_1KILO=1;
7     uint256 public DRUGS_TO_PRODUCE_1KILO=86400;//for final version should be seconds in a day
8     uint256 public STARTING_KILOS=300;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address public ceoAddress=0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26;
13     mapping (address => uint256) public Kilos;
14     mapping (address => uint256) public claimedDrugs;
15     mapping (address => uint256) public lastCollect;
16     mapping (address => address) public referrals;
17     uint256 public marketDrugs;
18     function DrugDealer() public{
19         ceoAddress=msg.sender;
20     }
21     function collectDrugs(address ref) public{
22         require(initialized);
23         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
24             referrals[msg.sender]=ref;
25         }
26         uint256 drugsUsed=getMyDrugs();
27         uint256 newKilo=SafeMath.div(drugsUsed,DRUGS_TO_PRODUCE_1KILO);
28         Kilos[msg.sender]=SafeMath.add(Kilos[msg.sender],newKilo);
29         claimedDrugs[msg.sender]=0;
30         lastCollect[msg.sender]=now;
31         
32         //send referral drugs
33         claimedDrugs[referrals[msg.sender]]=SafeMath.add(claimedDrugs[referrals[msg.sender]],SafeMath.div(drugsUsed,5));
34         
35         //boost market to nerf kilo hoarding
36         marketDrugs=SafeMath.add(marketDrugs,SafeMath.div(drugsUsed,10));
37     }
38     function sellDrugs() public{
39         require(initialized);
40         uint256 hasDrugs=getMyDrugs();
41         uint256 drugValue=calculateDrugSell(hasDrugs);
42         uint256 fee=devFee(drugValue);
43         claimedDrugs[msg.sender]=0;
44         lastCollect[msg.sender]=now;
45         marketDrugs=SafeMath.add(marketDrugs,hasDrugs);
46         ceoAddress.transfer(fee);
47         msg.sender.transfer(SafeMath.sub(drugValue,fee));
48     }
49     function buyDrugs() public payable{
50         require(initialized);
51         uint256 drugsBought=calculateDrugBuy(msg.value,SafeMath.sub(this.balance,msg.value));
52         drugsBought=SafeMath.sub(drugsBought,devFee(drugsBought));
53         ceoAddress.transfer(devFee(msg.value));
54         claimedDrugs[msg.sender]=SafeMath.add(claimedDrugs[msg.sender],drugsBought);
55     }
56     //magic trade balancing algorithm
57     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
58         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
59         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
60     }
61     function calculateDrugSell(uint256 drugs) public view returns(uint256){
62         return calculateTrade(drugs,marketDrugs,this.balance);
63     }
64     function calculateDrugBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
65         return calculateTrade(eth,contractBalance,marketDrugs);
66     }
67     function calculateDrugBuySimple(uint256 eth) public view returns(uint256){
68         return calculateDrugBuy(eth,this.balance);
69     }
70     function devFee(uint256 amount) public view returns(uint256){
71         return SafeMath.div(SafeMath.mul(amount,4),100);
72     }
73     function seedMarket(uint256 drugs) public payable{
74         require(marketDrugs==0);
75         initialized=true;
76         marketDrugs=drugs;
77     }
78     function getFreeKilo() public{
79         require(initialized);
80         require(Kilos[msg.sender]==0);
81         lastCollect[msg.sender]=now;
82         Kilos[msg.sender]=STARTING_KILOS;
83     }
84     function getBalance() public view returns(uint256){
85         return this.balance;
86     }
87     function getMyKilo() public view returns(uint256){
88         return Kilos[msg.sender];
89     }
90     function getMyDrugs() public view returns(uint256){
91         return SafeMath.add(claimedDrugs[msg.sender],getDrugsSinceLastCollect(msg.sender));
92     }
93     function getDrugsSinceLastCollect(address adr) public view returns(uint256){
94         uint256 secondsPassed=min(DRUGS_TO_PRODUCE_1KILO,SafeMath.sub(now,lastCollect[adr]));
95         return SafeMath.mul(secondsPassed,Kilos[adr]);
96     }
97     function min(uint256 a, uint256 b) private pure returns (uint256) {
98         return a < b ? a : b;
99     }
100 }
101 
102 library SafeMath {
103 
104   /**
105   * @dev Multiplies two numbers, throws on overflow.
106   */
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     if (a == 0) {
109       return 0;
110     }
111     uint256 c = a * b;
112     assert(c / a == b);
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers, truncating the quotient.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     // assert(b > 0); // Solidity automatically throws when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123     return c;
124   }
125 
126   /**
127   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
128   */
129   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130     assert(b <= a);
131     return a - b;
132   }
133 
134   /**
135   * @dev Adds two numbers, throws on overflow.
136   */
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }
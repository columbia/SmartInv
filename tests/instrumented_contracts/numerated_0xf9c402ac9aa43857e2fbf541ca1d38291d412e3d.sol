1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 contract AnthillFarmer{
6     //uint256 ANTS_PER_ANTHILL_PER_SECOND=1;
7     uint256 public ANTS_TO_COLLECT_1ANTHILL=86400;//for final version should be seconds in a day
8     uint256 public STARTING_ANTHILL=300;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address public ceoAddress;
13     mapping (address => uint256) public Anthills;
14     mapping (address => uint256) public claimedAnts;
15     mapping (address => uint256) public lastCollect;
16     mapping (address => address) public referrals;
17     uint256 public marketAnts;
18     function AnthillFarmer() public{
19         ceoAddress=msg.sender;
20     }
21     function collectAnts(address ref) public{
22         require(initialized);
23         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
24             referrals[msg.sender]=ref;
25         }
26         uint256 antsUsed=getMyAnts();
27         uint256 newAnthill=SafeMath.div(antsUsed,ANTS_TO_COLLECT_1ANTHILL);
28         Anthills[msg.sender]=SafeMath.add(Anthills[msg.sender],newAnthill);
29         claimedAnts[msg.sender]=0;
30         lastCollect[msg.sender]=now;
31         
32         //send referral ants
33         claimedAnts[referrals[msg.sender]]=SafeMath.add(claimedAnts[referrals[msg.sender]],SafeMath.div(antsUsed,5));
34         
35         //boost market to nerf anthill hoarding
36         marketAnts=SafeMath.add(marketAnts,SafeMath.div(antsUsed,10));
37     }
38     function sellAnts() public{
39         require(initialized);
40         uint256 hasAnts=getMyAnts();
41         uint256 antValue=calculateAntSell(hasAnts);
42         uint256 fee=devFee(antValue);
43         claimedAnts[msg.sender]=0;
44         lastCollect[msg.sender]=now;
45         marketAnts=SafeMath.add(marketAnts,hasAnts);
46         ceoAddress.transfer(fee);
47         msg.sender.transfer(SafeMath.sub(antValue,fee));
48     }
49     function buyAnts() public payable{
50         require(initialized);
51         uint256 antsBought=calculateAntBuy(msg.value,SafeMath.sub(this.balance,msg.value));
52         antsBought=SafeMath.sub(antsBought,devFee(antsBought));
53         ceoAddress.transfer(devFee(msg.value));
54         claimedAnts[msg.sender]=SafeMath.add(claimedAnts[msg.sender],antsBought);
55     }
56     //magic trade balancing algorithm
57     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
58         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
59         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
60     }
61     function calculateAntSell(uint256 ants) public view returns(uint256){
62         return calculateTrade(ants,marketAnts,this.balance);
63     }
64     function calculateAntBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
65         return calculateTrade(eth,contractBalance,marketAnts);
66     }
67     function calculateAntBuySimple(uint256 eth) public view returns(uint256){
68         return calculateAntBuy(eth,this.balance);
69     }
70     function devFee(uint256 amount) public view returns(uint256){
71         return SafeMath.div(SafeMath.mul(amount,4),100);
72     }
73     function seedMarket(uint256 ants) public payable{
74         require(marketAnts==0);
75         initialized=true;
76         marketAnts=ants;
77     }
78     function getFreeAnthill() public{
79         require(initialized);
80         require(Anthills[msg.sender]==0);
81         lastCollect[msg.sender]=now;
82         Anthills[msg.sender]=STARTING_ANTHILL;
83     }
84     function getBalance() public view returns(uint256){
85         return this.balance;
86     }
87     function getMyAnthill() public view returns(uint256){
88         return Anthills[msg.sender];
89     }
90     function getMyAnts() public view returns(uint256){
91         return SafeMath.add(claimedAnts[msg.sender],getAntsSinceLastCollect(msg.sender));
92     }
93     function getAntsSinceLastCollect(address adr) public view returns(uint256){
94         uint256 secondsPassed=min(ANTS_TO_COLLECT_1ANTHILL,SafeMath.sub(now,lastCollect[adr]));
95         return SafeMath.mul(secondsPassed,Anthills[adr]);
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
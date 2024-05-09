1 pragma solidity ^0.4.20; 
2 
3 contract HipsterFarmer{
4 
5     uint256 public EGGS_TO_HATCH_1HIPSTER=86400;
6     uint256 public STARTING_HIPSTER=300;
7     uint256 PSN=10000;
8     uint256 PSNH=5000;
9     bool public initialized=false;
10     address public ceoAddress;
11     mapping (address => uint256) public hatcheryHipster;
12     mapping (address => uint256) public claimedEggs;
13     mapping (address => uint256) public lastHatch;
14     mapping (address => address) public referrals;
15     uint256 public marketEggs;
16     uint256 public hipstermasterReq=100000;
17     function HipsterFarmer() public{
18         ceoAddress=msg.sender;
19     }
20     function becomeHipstermaster() public{
21         require(initialized);
22         require(hatcheryHipster[msg.sender]>=hipstermasterReq);
23         hatcheryHipster[msg.sender]=SafeMath.sub(hatcheryHipster[msg.sender],hipstermasterReq);
24         hipstermasterReq=SafeMath.add(hipstermasterReq,100000);//+100k hipsters each time
25         ceoAddress=msg.sender;
26     }
27     function hatchEggs(address ref) public{
28         require(initialized);
29         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
30             referrals[msg.sender]=ref;
31         }
32         uint256 eggsUsed=getMyEggs();
33         uint256 newHipster=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1HIPSTER);
34         hatcheryHipster[msg.sender]=SafeMath.add(hatcheryHipster[msg.sender],newHipster);
35         claimedEggs[msg.sender]=0;
36         lastHatch[msg.sender]=now;
37         
38 		
39         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
40         
41 		
42         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
43     }
44     function sellEggs() public{
45         require(initialized);
46         uint256 hasEggs=getMyEggs();
47         uint256 eggValue=calculateEggSell(hasEggs);
48         uint256 fee=devFee(eggValue);
49 		
50         hatcheryHipster[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryHipster[msg.sender],3),2);
51         claimedEggs[msg.sender]=0;
52         lastHatch[msg.sender]=now;
53         marketEggs=SafeMath.add(marketEggs,hasEggs);
54         ceoAddress.transfer(fee);
55         msg.sender.transfer(SafeMath.sub(eggValue,fee));
56     }
57     function buyEggs() public payable{
58         require(initialized);
59         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
60         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
61         ceoAddress.transfer(devFee(msg.value));
62         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
63     }
64     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
65       
66         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
67     }
68     function calculateEggSell(uint256 eggs) public view returns(uint256){
69         return calculateTrade(eggs,marketEggs,this.balance);
70     }
71     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
72         return calculateTrade(eth,contractBalance,marketEggs);
73     }
74     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
75         return calculateEggBuy(eth,this.balance);
76     }
77     function devFee(uint256 amount) public view returns(uint256){
78         return SafeMath.div(SafeMath.mul(amount,4),100);
79     }
80     function seedMarket(uint256 eggs) public payable{
81         require(marketEggs==0);
82         initialized=true;
83         marketEggs=eggs;
84     }
85     function getFreeHipster() public payable{
86         require(initialized);
87         require(msg.value==0.001 ether); 
88         ceoAddress.transfer(msg.value); 
89         require(hatcheryHipster[msg.sender]==0);
90         lastHatch[msg.sender]=now;
91         hatcheryHipster[msg.sender]=STARTING_HIPSTER;
92     }
93     function getBalance() public view returns(uint256){
94         return this.balance;
95     }
96     function getMyHipster() public view returns(uint256){
97         return hatcheryHipster[msg.sender];
98     }
99     function getHipstermasterReq() public view returns(uint256){
100         return hipstermasterReq;
101     }
102     function getMyEggs() public view returns(uint256){
103         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
104     }
105     function getEggsSinceLastHatch(address adr) public view returns(uint256){
106         uint256 secondsPassed=min(EGGS_TO_HATCH_1HIPSTER,SafeMath.sub(now,lastHatch[adr]));
107         return SafeMath.mul(secondsPassed,hatcheryHipster[adr]);
108     }
109     function min(uint256 a, uint256 b) private pure returns (uint256) {
110         return a < b ? a : b;
111     }
112 }
113 
114 library SafeMath {
115 
116 
117   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118     if (a == 0) {
119       return 0;
120     }
121     uint256 c = a * b;
122     assert(c / a == b);
123     return c;
124   }
125 
126 
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a / b;
129     return c;
130   }
131 
132 
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138 
139   function add(uint256 a, uint256 b) internal pure returns (uint256) {
140     uint256 c = a + b;
141     assert(c >= a);
142     return c;
143   }
144 }
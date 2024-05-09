1 pragma solidity ^0.4.20; 
2 
3 contract PacifistFarmer{
4 
5     uint256 public EGGS_TO_HATCH_1PACIFIST=86400;
6     uint256 public STARTING_PACIFIST=300;
7     uint256 PSN=10000;
8     uint256 PSNH=5000;
9     bool public initialized=false;
10     address public ceoAddress;
11     mapping (address => uint256) public hatcheryPacifist;
12     mapping (address => uint256) public claimedEggs;
13     mapping (address => uint256) public lastHatch;
14     mapping (address => address) public referrals;
15     uint256 public marketEggs;
16     uint256 public pacifistmasterReq=100000;
17     uint256 public numFree;
18     
19     function PacifistFarmer() public{
20         ceoAddress=msg.sender;
21     }
22     function becomePacifistmaster() public{
23         require(initialized);
24         require(hatcheryPacifist[msg.sender]>=pacifistmasterReq);
25         hatcheryPacifist[msg.sender]=SafeMath.sub(hatcheryPacifist[msg.sender],pacifistmasterReq);
26         pacifistmasterReq=SafeMath.add(pacifistmasterReq,100000);//+100k pacifists each time
27         ceoAddress=msg.sender;
28     }
29     function hatchEggs(address ref) public{
30         require(initialized);
31         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
32             referrals[msg.sender]=ref;
33         }
34         uint256 eggsUsed=getMyEggs();
35         uint256 newPacifist=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1PACIFIST);
36         hatcheryPacifist[msg.sender]=SafeMath.add(hatcheryPacifist[msg.sender],newPacifist);
37         claimedEggs[msg.sender]=0;
38         lastHatch[msg.sender]=now;
39         
40 		
41         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
42         
43 		
44         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
45     }
46     function sellEggs() public{
47         require(initialized);
48         uint256 hasEggs=getMyEggs();
49         uint256 eggValue=calculateEggSell(hasEggs);
50         uint256 fee=devFee(eggValue);
51 		
52         hatcheryPacifist[msg.sender]=SafeMath.mul(SafeMath.div(hatcheryPacifist[msg.sender],3),2);
53         claimedEggs[msg.sender]=0;
54         lastHatch[msg.sender]=now;
55         marketEggs=SafeMath.add(marketEggs,hasEggs);
56         ceoAddress.transfer(fee);
57         msg.sender.transfer(SafeMath.sub(eggValue,fee));
58     }
59     function buyEggs() public payable{
60         require(initialized);
61         uint256 eggsBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
62         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
63         ceoAddress.transfer(devFee(msg.value));
64         claimedEggs[msg.sender]=SafeMath.add(claimedEggs[msg.sender],eggsBought);
65     }
66     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
67       
68         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
69     }
70     function calculateEggSell(uint256 eggs) public view returns(uint256){
71         return calculateTrade(eggs,marketEggs,this.balance);
72     }
73     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
74         return calculateTrade(eth,contractBalance,marketEggs);
75     }
76     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
77         return calculateEggBuy(eth,this.balance);
78     }
79     function devFee(uint256 amount) public view returns(uint256){
80         return SafeMath.div(SafeMath.mul(amount,4),100);
81     }
82     function seedMarket(uint256 eggs) public payable{
83         require(marketEggs==0);
84         initialized=true;
85         marketEggs=eggs;
86     }
87     function getFreePacifist() public {
88         require(initialized);
89         require(numFree<=200);
90         require(hatcheryPacifist[msg.sender]==0);
91         lastHatch[msg.sender]=now;
92         hatcheryPacifist[msg.sender]=STARTING_PACIFIST;
93         numFree=numFree+1;
94     }
95     function getBalance() public view returns(uint256){
96         return this.balance;
97     }
98     function getMyPacifist() public view returns(uint256){
99         return hatcheryPacifist[msg.sender];
100     }
101     function getPacifistmasterReq() public view returns(uint256){
102         return pacifistmasterReq;
103     }
104     function getMyEggs() public view returns(uint256){
105         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
106     }
107     function getEggsSinceLastHatch(address adr) public view returns(uint256){
108         uint256 secondsPassed=min(EGGS_TO_HATCH_1PACIFIST,SafeMath.sub(now,lastHatch[adr]));
109         return SafeMath.mul(secondsPassed,hatcheryPacifist[adr]);
110     }
111     function min(uint256 a, uint256 b) private pure returns (uint256) {
112         return a < b ? a : b;
113     }
114 }
115 
116 library SafeMath {
117 
118 
119   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120     if (a == 0) {
121       return 0;
122     }
123     uint256 c = a * b;
124     assert(c / a == b);
125     return c;
126   }
127 
128 
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a / b;
131     return c;
132   }
133 
134 
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140 
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
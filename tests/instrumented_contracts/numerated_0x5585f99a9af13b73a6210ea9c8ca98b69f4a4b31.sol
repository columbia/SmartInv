1 pragma solidity ^0.4.24; 
2 
3 // similar as shrimpfarmer, with two changes:
4 // A. half of your plumbers leave when you sell pooh
5 // B. the "free" 100 plumber cost 0.001 eth (in line with the mining fee)
6 
7 // bots should have a harder time
8 
9 contract PlumberCollector{
10     uint256 public POOH_TO_CALL_1PLUMBER=86400;//for final version should be seconds in a day
11     uint256 public STARTING_POOH=100;
12     uint256 PSN=10000;
13     uint256 PSNH=5000;
14     bool public initialized=false;
15     address public ceoAddress;
16     mapping (address => uint256) public hatcheryPlumber;
17     mapping (address => uint256) public claimedPoohs;
18     mapping (address => uint256) public lastHatch;
19     mapping (address => address) public referrals;
20     uint256 public marketPoohs;
21    
22 
23     constructor() public
24     {
25         ceoAddress=msg.sender;
26     }
27 
28     function hatchPoohs(address ref) public
29     {
30         require(initialized);
31         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender)
32         {
33             referrals[msg.sender]=ref;
34         }
35         uint256 poohsUsed=getMyPoohs();
36         uint256 newPlumber=SafeMath.div(poohsUsed,POOH_TO_CALL_1PLUMBER);
37         hatcheryPlumber[msg.sender]=SafeMath.add(hatcheryPlumber[msg.sender],newPlumber);
38         claimedPoohs[msg.sender]=0;
39         lastHatch[msg.sender]=now;
40         
41         //send referral poohs
42         claimedPoohs[referrals[msg.sender]]=SafeMath.add(claimedPoohs[referrals[msg.sender]],SafeMath.div(poohsUsed,5));
43         
44         //boost market to nerf pooh hoarding
45         marketPoohs=SafeMath.add(marketPoohs,SafeMath.div(poohsUsed,10));
46     }
47 
48     function sellPoohs() public{
49         require(initialized);
50         uint256 hasPoohs=getMyPoohs();
51         uint256 poohValue=calculatePoohSell(hasPoohs);
52         uint256 fee=devFee(poohValue);
53         // kill one half of the owner's snails on egg sale
54         hatcheryPlumber[msg.sender] = SafeMath.div(hatcheryPlumber[msg.sender],2);
55         claimedPoohs[msg.sender]=0;
56         lastHatch[msg.sender]=now;
57         marketPoohs=SafeMath.add(marketPoohs,hasPoohs);
58         ceoAddress.transfer(fee);
59         msg.sender.transfer(SafeMath.sub(poohValue,fee));
60     }
61 
62     function buyPoohs() public payable
63     {
64         require(initialized);
65         uint256 poohsBought=calculatePoohBuy(msg.value,SafeMath.sub(address(this).balance,msg.value));
66         poohsBought=SafeMath.sub(poohsBought,devFee(poohsBought));
67         ceoAddress.transfer(devFee(msg.value));
68         claimedPoohs[msg.sender]=SafeMath.add(claimedPoohs[msg.sender],poohsBought);
69     }
70 
71     //magic trade balancing algorithm
72     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256)
73     {
74         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
75         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
76     }
77 
78     function calculatePoohSell(uint256 poohs) public view returns(uint256)
79     {
80         return calculateTrade(poohs,marketPoohs,address(this).balance);
81     }
82 
83     function calculatePoohBuy(uint256 eth,uint256 contractBalance) public view returns(uint256)
84     {
85         return calculateTrade(eth,contractBalance,marketPoohs);
86     }
87 
88     function calculatePoohBuySimple(uint256 eth) public view returns(uint256)
89     {
90         return calculatePoohBuy(eth, address(this).balance);
91     }
92 
93     function devFee(uint256 amount) public pure returns(uint256)
94     {
95         // 5% devFee
96         return SafeMath.div(amount,20);
97     }
98 
99     function seedMarket(uint256 poohs) public payable
100     {
101         require(marketPoohs==0);
102         initialized=true;
103         marketPoohs=poohs;
104     }
105 
106     function getFreePlumber() public payable
107     {
108         require(initialized);
109         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
110         ceoAddress.transfer(msg.value); //ceo gets this entrance fee
111         require(hatcheryPlumber[msg.sender]==0);
112         lastHatch[msg.sender]=now;
113         hatcheryPlumber[msg.sender]=STARTING_POOH;
114     }
115 
116     function getBalance() public view returns(uint256)
117     {
118         return address(this).balance;
119     }
120 
121     function getMyPlumbers() public view returns(uint256)
122     {
123         return hatcheryPlumber[msg.sender];
124     }
125 
126     
127 
128     function getMyPoohs() public view returns(uint256)
129     {
130         return SafeMath.add(claimedPoohs[msg.sender],getPoohsSinceLastHatch(msg.sender));
131     }
132 
133     function getPoohsSinceLastHatch(address adr) public view returns(uint256)
134     {
135         uint256 secondsPassed=min(POOH_TO_CALL_1PLUMBER,SafeMath.sub(now,lastHatch[adr]));
136         return SafeMath.mul(secondsPassed,hatcheryPlumber[adr]);
137     }
138 
139     function min(uint256 a, uint256 b) private pure returns (uint256) 
140     {
141         return a < b ? a : b;
142     }
143 }
144 
145 library SafeMath {
146 
147   /**
148   * @dev Multiplies two numbers, throws on overflow.
149   */
150   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
151   {
152     if (a == 0) 
153     {
154       return 0;
155     }
156     uint256 c = a * b;
157     assert(c / a == b);
158     return c;
159   }
160 
161   /**
162   * @dev Integer division of two numbers, truncating the quotient.
163   */
164   function div(uint256 a, uint256 b) internal pure returns (uint256) {
165     // assert(b > 0); // Solidity automatically throws when dividing by 0
166     uint256 c = a / b;
167     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
168     return c;
169   }
170 
171   /**
172   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173   */
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     assert(b <= a);
176     return a - b;
177   }
178 
179   /**
180   * @dev Adds two numbers, throws on overflow.
181   */
182   function add(uint256 a, uint256 b) internal pure returns (uint256) {
183     uint256 c = a + b;
184     assert(c >= a);
185     return c;
186   }
187 }
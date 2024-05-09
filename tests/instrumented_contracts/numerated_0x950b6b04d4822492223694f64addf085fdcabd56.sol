1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 /* 
4 SHOW ME WHAT YOU GOT
5         ___          
6     . -^   `--,      
7    /# =========`-_   
8   /# (--====___====\ 
9  /#   .- --.  . --.| 
10 /##   |  * ) (   * ),
11 |##   \    /\ \   / |
12 |###   ---   \ ---  |
13 |####      ___)    #|
14 |######           ##|
15  \##### ---------- / 
16   \####           (  
17    `\###          |  
18      \###         |  
19       \##        |   
20        \###.    .)   
21         `======/    
22 
23 */
24 // similar to the original shrimper , with these changes:
25 // 0. already initialized
26 // 1. the "free" 314 Morties cost 0.001 eth (in line with the mining fee)
27 // 2. bots should have a harder time, and whales can compete for the devfee
28 
29 
30 contract RickAndMortyShrimper{
31     string public name = "RickAndMortyShrimper";
32 	string public symbol = "RickAndMortyS";
33     //uint256 morties_PER_RickAndMorty_PER_SECOND=1;
34     uint256 public morties_TO_HATCH_1RickAndMorty=86400;//for final version should be seconds in a day
35     uint256 public STARTING_RickAndMorty=314;
36     uint256 PSN=10000;
37     uint256 PSNH=5000;
38     bool public initialized=true;
39     address public ceoAddress;
40     mapping (address => uint256) public hatcheryRickAndMorty;
41     mapping (address => uint256) public claimedmorties;
42     mapping (address => uint256) public lastHatch;
43     mapping (address => address) public referrals;
44     uint256 public marketmorties = 1000000000;
45     uint256 public RnMmasterReq=100000;
46     
47     function RickAndMortyShrimper() public{
48         ceoAddress=msg.sender;
49     }
50     modifier onlyCEO(){
51 		require(msg.sender == ceoAddress );
52 		_;
53 	}
54     function becomePickleRick() public{
55         require(initialized);
56         require(hatcheryRickAndMorty[msg.sender]>=RnMmasterReq);
57         hatcheryRickAndMorty[msg.sender]=SafeMath.sub(hatcheryRickAndMorty[msg.sender],RnMmasterReq);
58         RnMmasterReq=SafeMath.add(RnMmasterReq,100000);//+100k RickAndMortys each time
59         ceoAddress=msg.sender;
60     }
61     function hatchMorties(address ref) public{
62         require(initialized);
63         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
64             referrals[msg.sender]=ref;
65         }
66         uint256 mortiesUsed=getMymorties();
67         uint256 newRickAndMorty=SafeMath.div(mortiesUsed,morties_TO_HATCH_1RickAndMorty);
68         hatcheryRickAndMorty[msg.sender]=SafeMath.add(hatcheryRickAndMorty[msg.sender],newRickAndMorty);
69         claimedmorties[msg.sender]=0;
70         lastHatch[msg.sender]=now;
71         
72         //send referral morties
73         claimedmorties[referrals[msg.sender]]=SafeMath.add(claimedmorties[referrals[msg.sender]],SafeMath.div(mortiesUsed,5));
74         
75         //boost market to nerf RickAndMorty hoarding
76         marketmorties=SafeMath.add(marketmorties,SafeMath.div(mortiesUsed,10));
77     }
78     function sellMorties() public{
79         require(initialized);
80         uint256 hasmorties=getMymorties();
81         uint256 eggValue=calculatemortiesell(hasmorties);
82         uint256 fee=devFee(eggValue);
83         claimedmorties[msg.sender]=0;
84         lastHatch[msg.sender]=now;
85         marketmorties=SafeMath.add(marketmorties,hasmorties);
86         ceoAddress.transfer(fee);
87     }
88     function buyMorties() public payable{
89         require(initialized);
90         uint256 mortiesBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
91         mortiesBought=SafeMath.sub(mortiesBought,devFee(mortiesBought));
92         ceoAddress.transfer(devFee(msg.value));
93         claimedmorties[msg.sender]=SafeMath.add(claimedmorties[msg.sender],mortiesBought);
94     }
95     //magic trade balancing algorithm
96     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
97         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
98         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
99     }
100     function calculatemortiesell(uint256 morties) public view returns(uint256){
101         return calculateTrade(morties,marketmorties,this.balance);
102     }
103     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
104         return calculateTrade(eth,contractBalance,marketmorties);
105     }
106     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
107         return calculateEggBuy(eth,this.balance);
108     }
109     function devFee(uint256 amount) public view returns(uint256){
110         return SafeMath.div(SafeMath.mul(amount,4),100);
111     }
112     function seedMarket(uint256 morties) public payable{
113         require(marketmorties==0);
114         initialized=true;
115         marketmorties=morties;
116     }
117     function getFreeRickAndMorty() public payable{
118         require(initialized);
119         require(msg.value==0.001 ether); //similar to mining fee, prevents bots
120         ceoAddress.transfer(msg.value); //RnMmaster gets this entrance fee
121         require(hatcheryRickAndMorty[msg.sender]==0);
122         lastHatch[msg.sender]=now;
123         hatcheryRickAndMorty[msg.sender]=STARTING_RickAndMorty;
124     }
125     function getBalance() public view returns(uint256){
126         return this.balance;
127     }
128     function getMyRickAndMorty() public view returns(uint256){
129         return hatcheryRickAndMorty[msg.sender];
130     }
131     function getRnMmasterReq() public view returns(uint256){
132         return RnMmasterReq;
133     }
134     function getMymorties() public view returns(uint256){
135         return SafeMath.add(claimedmorties[msg.sender],getmortiesSinceLastHatch(msg.sender));
136     }
137     function getmortiesSinceLastHatch(address adr) public view returns(uint256){
138         uint256 secondsPassed=min(morties_TO_HATCH_1RickAndMorty,SafeMath.sub(now,lastHatch[adr]));
139         return SafeMath.mul(secondsPassed,hatcheryRickAndMorty[adr]);
140     }
141     function min(uint256 a, uint256 b) private pure returns (uint256) {
142         return a < b ? a : b;
143     }
144     function transferOwnership() onlyCEO public {
145 		uint256 etherBalance = this.balance;
146 		ceoAddress.transfer(etherBalance);
147 	}
148 }
149 
150 library SafeMath {
151 
152   /**
153   * @dev Multiplies two numbers, throws on overflow.
154   */
155   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156     if (a == 0) {
157       return 0;
158     }
159     uint256 c = a * b;
160     assert(c / a == b);
161     return c;
162   }
163 
164   /**
165   * @dev Integer division of two numbers, truncating the quotient.
166   */
167   function div(uint256 a, uint256 b) internal pure returns (uint256) {
168     // assert(b > 0); // Solidity automatically throws when dividing by 0
169     uint256 c = a / b;
170     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171     return c;
172   }
173 
174   /**
175   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176   */
177   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178     assert(b <= a);
179     return a - b;
180   }
181 
182   /**
183   * @dev Adds two numbers, throws on overflow.
184   */
185   function add(uint256 a, uint256 b) internal pure returns (uint256) {
186     uint256 c = a + b;
187     assert(c >= a);
188     return c;
189   }
190 }
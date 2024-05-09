1 pragma solidity ^0.4.24;
2 
3 contract CryptoTomatoes {
4  
5 		uint256 public TIME_TO_MAKE_TOMATOES = 21600; //6 hours
6 
7 		address public ownerAddress;
8 		
9 		bool public getFree = false;
10 		uint public needToGetFree = 0.001 ether;
11 		uint256 public STARTING_SEEDS = 500; 
12 		
13 		mapping (address => uint256) public ballanceTomatoes; 
14 		mapping (address => uint256) public claimedSeeds; 
15 		mapping (address => uint256) public lastEvent; 
16 		mapping (address => address) public referrals; 
17 		
18 		mapping (address => uint256) public totalIn;
19 		mapping (address => uint256) public totalOut;
20 		
21 		uint256 public marketSeeds;
22 		uint256 PSN = 10000; 
23 		uint256 PSNH = 5000; 
24 
25 		constructor() public {
26 			ownerAddress = msg.sender;
27 			marketSeeds = 10000000;
28 		}
29 		
30 		modifier onlyOwner() {
31 		require(msg.sender == ownerAddress);
32 		_;
33 		}
34 		
35 		function makeTomatoes(address ref) public {
36         if (referrals[msg.sender] == 0 && referrals[msg.sender] != msg.sender) {
37             referrals[msg.sender] = ref;
38         }
39         uint256 seedsUsed = getMySeeds();
40         uint256 newTomatos = SafeMath.div(seedsUsed, TIME_TO_MAKE_TOMATOES);
41         ballanceTomatoes[msg.sender] = SafeMath.add(ballanceTomatoes[msg.sender], newTomatos);
42         claimedSeeds[msg.sender] = 0;
43         lastEvent[msg.sender] = now;
44         claimedSeeds[referrals[msg.sender]] = SafeMath.add(claimedSeeds[referrals[msg.sender]], SafeMath.div(seedsUsed, 5)); 
45         marketSeeds = SafeMath.add(marketSeeds, SafeMath.div(seedsUsed, 10));
46 		}
47 
48 		function sellSeeds() public {
49 
50         uint256 seedsCount = getMySeeds();
51         uint256 seedsValue = calculateSeedSell(seedsCount);
52         uint256 fee = devFee(seedsValue);
53         ballanceTomatoes[msg.sender] = SafeMath.mul(SafeMath.div(ballanceTomatoes[msg.sender], 3), 2);
54         claimedSeeds[msg.sender] = 0;
55         lastEvent[msg.sender] = now;
56         marketSeeds = SafeMath.add(marketSeeds, seedsCount);
57 		totalOut[msg.sender] = SafeMath.add(totalOut[msg.sender], seedsValue);
58         ownerAddress.transfer(fee);
59         msg.sender.transfer(SafeMath.sub(seedsValue, fee));
60     }
61 	
62 		uint256 public gamers = 0;
63 		
64 		function getGamers() public view returns (uint256){
65 			return gamers;
66 		}
67 
68 		function buySeeds() public payable {
69 
70         uint256 seedsBought = calculateSeedBuy(msg.value, SafeMath.sub(this.balance, msg.value));
71         seedsBought = SafeMath.sub(seedsBought, devFee(seedsBought));
72         claimedSeeds[msg.sender] = SafeMath.add(claimedSeeds[msg.sender], seedsBought);
73 		if (totalIn[msg.sender] == 0){
74 			gamers+=1;
75 		}
76 		totalIn[msg.sender] = SafeMath.add(totalIn[msg.sender], msg.value);
77         ownerAddress.transfer(devFee(msg.value));
78     }
79 	
80 
81 
82 		function calculateTrade(uint256 rt, uint256 rs, uint256 bs) public view returns(uint256) {
83         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
84     }
85 
86 		function calculateSeedSell(uint256 seeds) public view returns(uint256) {
87         return calculateTrade(seeds, marketSeeds, this.balance);
88     }
89 
90 		function calculateSeedBuy(uint256 eth, uint256 contractBalance) public view returns(uint256) {
91         return calculateTrade(eth, contractBalance, marketSeeds);
92     }
93 
94 		function calculateSeedBuySimple(uint256 eth) public view returns(uint256) {
95         return calculateSeedBuy(eth, this.balance);
96     }
97 
98 		function devFee(uint256 amount) public view returns(uint256) {
99         return SafeMath.div(SafeMath.mul(amount, 4), 100); //4%
100     }
101 	
102 		function setTIME_TO_MAKE_TOMATOES(uint256 _newTime) public onlyOwner{
103 		TIME_TO_MAKE_TOMATOES = _newTime;
104 	}
105 	
106 		function setGetFree(bool newGetFree) public onlyOwner {
107 		getFree = newGetFree;
108 	}
109 		
110 		function setNeedToGetFree(uint newNeedToGetFree) public onlyOwner {
111 		needToGetFree = newNeedToGetFree;
112 	}
113 
114 		function getFreeSeeds() public payable {
115 		require(getFree);
116         require(msg.value == needToGetFree);
117         ownerAddress.transfer(msg.value);
118         require(ballanceTomatoes[msg.sender] == 0);
119         lastEvent[msg.sender] = now;
120         ballanceTomatoes[msg.sender] = STARTING_SEEDS;
121     }
122 	
123 		function setStartingSeeds(uint256 NEW_STARTING_SEEDS) public onlyOwner {
124 		STARTING_SEEDS = NEW_STARTING_SEEDS;
125 	}
126 
127 		function getBalance() public view returns(uint256) {
128         return this.balance;
129     }
130 
131 		function getMyTomatoes() public view returns(uint256) {
132         return ballanceTomatoes[msg.sender];
133     }
134 
135 		
136 		function getTotalIn(address myAddress) public view returns(uint256) {
137 			return totalIn[myAddress];
138 		}
139 		
140 		function getTotalOut(address myAddress) public view returns(uint256) {
141 			return totalOut[myAddress];
142 		}
143 
144 
145 		function getMySeeds() public view returns(uint256) { 
146         return SafeMath.add(claimedSeeds[msg.sender], getSeedsSinceLastEvent(msg.sender));
147     }
148 
149 		function getSeedsSinceLastEvent(address adr) public view returns(uint256) {
150         uint256 secondsPassed = min(TIME_TO_MAKE_TOMATOES, SafeMath.sub(now, lastEvent[adr]));
151         return SafeMath.mul(secondsPassed, ballanceTomatoes[adr]);
152     }
153 
154 		function min(uint256 a, uint256 b) private pure returns (uint256) {
155         return a < b ? a : b;
156     }
157 	
158 }
159 
160 library SafeMath {
161 
162 		  /**
163 		  * @dev Multiplies two numbers, throws on overflow.
164 		  */
165 		  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166 			if (a == 0) {
167 			  return 0;
168 			}
169 			uint256 c = a * b;
170 			assert(c / a == b);
171 			return c;
172 		  }
173 
174 		  /**
175 		  * @dev Integer division of two numbers, truncating the quotient.
176 		  */
177 		  function div(uint256 a, uint256 b) internal pure returns (uint256) {
178 			// assert(b > 0); // Solidity automatically throws when dividing by 0
179 			uint256 c = a / b;
180 			// assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 			return c;
182 		  }
183 
184 		  /**
185 		  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
186 		  */
187 		  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
188 			assert(b <= a);
189 			return a - b;
190 		  }
191 
192 		  /**
193 		  * @dev Adds two numbers, throws on overflow.
194 		  */
195 		  function add(uint256 a, uint256 b) internal pure returns (uint256) {
196 			uint256 c = a + b;
197 			assert(c >= a);
198 			return c;
199 		  }
200 }
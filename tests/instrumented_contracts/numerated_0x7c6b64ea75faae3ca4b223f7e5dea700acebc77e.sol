1 pragma solidity ^0.4.18;
2 
3 /*
4 Game: Dragon Ball Super ( Tournament of Power )
5 Domain: EtherDragonBall.com
6 */
7 
8 contract DragonBallZ {
9     
10     //The contract creator and dev fee addresses are defined here
11 	address contractCreator = 0x606A19ea257aF8ED76D160Ad080782C938660A33;
12     address devFeeAddress = 0xAe406d5900DCe1bB7cF3Bc5e92657b5ac9cBa34B;
13 
14 	struct Hero {
15 		string heroName;
16 		address ownerAddress;
17 		address DBZHeroOwnerAddress;
18 		uint256 currentPrice;
19 		uint currentLevel;
20 	}
21 	Hero[] heroes;
22 	
23 	//The number of heroes in Tournament of Power
24 	uint256 heroMax = 55;
25 	
26 	//The array defined for winner variable
27     uint256[] winners;
28 
29 
30 	modifier onlyContractCreator() {
31         require (msg.sender == contractCreator);
32         _;
33     }
34 
35     bool isPaused;
36     
37     
38     /*
39     We use the following functions to pause and unpause the game.
40     */
41     function pauseGame() public onlyContractCreator {
42         isPaused = true;
43     }
44     function unPauseGame() public onlyContractCreator {
45         isPaused = false;
46     }
47     function GetGamestatus() public view returns(bool) {
48         return(isPaused);
49     }
50 
51     /*
52     This function allows users to purchase Tournament of Power heroes 
53     The price is automatically multiplied by 2 after each purchase.
54     Users can purchase multiple heroes.
55     */
56 	function purchaseHero(uint _heroId) public payable {
57 	    //Check if current price of hero is equal with the price entered to purchase the hero
58 		require(msg.value == heroes[_heroId].currentPrice);
59 		
60 		//Check if the game is not PAUSED
61 		require(isPaused == false);
62 		
63 		// Calculate the 10% of Tournament of Power prize fee
64 		uint256 TournamentPrizeFee = (msg.value / 10); // => 10%
65 	    
66 		// Calculate the 5% - Dev fee
67 		uint256 devFee = ((msg.value / 10)/2);  // => 5%
68 		
69 		// Calculate the 10% commission - Dragon Ball Z Hero Owner
70 		uint256 DBZHeroOwnerCommission = (msg.value / 10); // => 10%
71 
72 		// Calculate the current hero owner commission on this sale & transfer the commission to the owner.		
73 		uint256 commissionOwner = (msg.value - (devFee + TournamentPrizeFee + DBZHeroOwnerCommission)); 
74 		heroes[_heroId].ownerAddress.transfer(commissionOwner); // => 75%
75 
76 		// Transfer the 10% commission to the DBZ Hero Owner
77 		heroes[_heroId].DBZHeroOwnerAddress.transfer(DBZHeroOwnerCommission); // => 10% 								
78 
79 		
80 		// Transfer the 5% commission to the Dev
81 		devFeeAddress.transfer(devFee); // => 5% 
82 		
83 		//The hero will be leveled up after new purchase
84 		heroes[_heroId].currentLevel +=1;
85 
86 		// Update the hero owner and set the new price (2X)
87 		heroes[_heroId].ownerAddress = msg.sender;
88 		heroes[_heroId].currentPrice = mul(heroes[_heroId].currentPrice, 2);
89 	}
90 	
91 	/*
92 	This function will be used to update the details of DBZ hero details by the contract creator
93 	*/
94 	function updateDBZHeroDetails(uint _heroId, string _heroName,address _ownerAddress, address _newDBZHeroOwnerAddress, uint _currentLevel) public onlyContractCreator{
95 	    require(heroes[_heroId].ownerAddress != _newDBZHeroOwnerAddress);
96 		heroes[_heroId].heroName = _heroName;		
97 		heroes[_heroId].ownerAddress = _ownerAddress;
98 	    heroes[_heroId].DBZHeroOwnerAddress = _newDBZHeroOwnerAddress;
99 	    heroes[_heroId].currentLevel = _currentLevel;
100 	}
101 	
102 	/*
103 	This function can be used by the owner of a hero to modify the price of its hero.
104 	The hero owner can make the price lesser than the current price only.
105 	*/
106 	function modifyCurrentHeroPrice(uint _heroId, uint256 _newPrice) public {
107 	    require(_newPrice > 0);
108 	    require(heroes[_heroId].ownerAddress == msg.sender);
109 	    require(_newPrice < heroes[_heroId].currentPrice);
110 	    heroes[_heroId].currentPrice = _newPrice;
111 	}
112 	
113 	// This function will return all of the details of the Tournament of Power heroes
114 	function getHeroDetails(uint _heroId) public view returns (
115         string heroName,
116         address ownerAddress,
117         address DBZHeroOwnerAddress,
118         uint256 currentPrice,
119         uint currentLevel
120     ) {
121         Hero storage _hero = heroes[_heroId];
122 
123         heroName = _hero.heroName;
124         ownerAddress = _hero.ownerAddress;
125         DBZHeroOwnerAddress = _hero.DBZHeroOwnerAddress;
126         currentPrice = _hero.currentPrice;
127         currentLevel = _hero.currentLevel;
128     }
129     
130     // This function will return only the price of a specific hero
131     function getHeroCurrentPrice(uint _heroId) public view returns(uint256) {
132         return(heroes[_heroId].currentPrice);
133     }
134     
135     // This function will return only the price of a specific hero
136     function getHeroCurrentLevel(uint _heroId) public view returns(uint256) {
137         return(heroes[_heroId].currentLevel);
138     }
139     
140     // This function will return only the owner address of a specific hero
141     function getHeroOwner(uint _heroId) public view returns(address) {
142         return(heroes[_heroId].ownerAddress);
143     }
144     
145     // This function will return only the DBZ owner address of a specific hero
146     function getHeroDBZHeroAddress(uint _heroId) public view returns(address) {
147         return(heroes[_heroId].DBZHeroOwnerAddress);
148     }
149     
150     // This function will return only Tournament of Power total prize
151     function getTotalPrize() public view returns(uint256) {
152         return this.balance;
153     }
154     
155     /**
156     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
157     */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         if (a == 0) {
160           return 0;
161         }
162         uint256 c = a * b;
163         assert(c / a == b);
164         return c;
165     }
166 
167     /**
168     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
169     */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         // assert(b > 0); // Solidity automatically throws when dividing by 0
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174         return c;
175     }
176     
177 	// This function will be used to add a new hero by the contract creator
178 	function addHero(string _heroName, address _ownerAddress, address _DBZHeroOwnerAddress, uint256 _currentPrice, uint _currentLevel) public onlyContractCreator {
179         heroes.push(Hero(_heroName,_ownerAddress,_DBZHeroOwnerAddress,_currentPrice,_currentLevel));
180     }
181      
182     /*
183 	This function will be used by the contract creator to generate 5 heroes ID randomly out of 55 heroes
184 	and it can be generated only once and cannot be altered at all even by contractCreator
185 	*/   
186     function getWinner() public onlyContractCreator returns (uint256[]) {
187         uint i;
188 		
189 		//Loop to generate 5 random hero IDs from 55 heroes	
190 		for(i=0;i<=4;i++){
191 		    //Block timestamp and number used to generate the random number
192 			winners.push(uint256(sha256(block.timestamp, block.number-i-1)) % heroMax);
193 		}
194 		
195 		return winners;
196     }
197 
198     // This function will return only the winner's hero id
199     function getWinnerDetails(uint _winnerId) public view returns(uint256) {
200         return(winners[_winnerId]);
201     }
202     
203     /*
204 	This function can be used by the contractCreator to start the payout to the lucky 5 winners
205 	The payout will be initiated in a week time
206 	*/
207     function payoutWinners() public onlyContractCreator {
208         //Assign 20% of total contract eth
209         uint256 TotalPrize20PercentShare = (this.balance/5);
210         uint i;
211 			for(i=0;i<=4;i++){
212 			    // Get the hero ID from getWinnerDetails function - Randomly generated
213 			    uint _heroID = getWinnerDetails(i);
214 			    // Assign the owner address of hero ID - Randomly generated
215 			    address winner = heroes[_heroID].ownerAddress;
216 			    
217 			    if(winner != address(0)){
218 			     // Transfer the 20% of total contract eth to each winner (5 winners in total)  
219                  winner.transfer(TotalPrize20PercentShare);			       
220 			    }
221 			    
222 			    // Reset the winner's address after payout for next loop
223 			    winner = address(0);
224 			}
225     }
226     
227 }
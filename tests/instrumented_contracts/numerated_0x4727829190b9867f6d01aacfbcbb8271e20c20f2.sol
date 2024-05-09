1 pragma solidity ^0.4.18;
2 
3 /*
4 Game: Dragon Ball Z
5 Domain: EtherDragonBall.com
6 */
7 
8 contract DragonBallZ {
9 
10 	address contractCreator = 0x23B385c822381BE63C9f45a3E45266DD32D52c43;
11     address devFeeAddress = 0x3bdC0D871731D08D1c1c793735372AB16397Cd61;
12 
13 	struct Hero {
14 		string heroName;
15 		address ownerAddress;
16 		uint256 currentPrice;
17 	}
18 	Hero[] heroes;
19 
20 	modifier onlyContractCreator() {
21         require (msg.sender == contractCreator);
22         _;
23     }
24 
25     bool isPaused;
26     
27     
28     /*
29     We use the following functions to pause and unpause the game.
30     */
31     function pauseGame() public onlyContractCreator {
32         isPaused = true;
33     }
34     function unPauseGame() public onlyContractCreator {
35         isPaused = false;
36     }
37     function GetGamestatus() public view returns(bool) {
38        return(isPaused);
39     }
40 
41     /*
42     This function allows users to purchase Dragon Ball Z hero. 
43     The price is automatically multiplied by 2 after each purchase.
44     Users can purchase multiple heroes.
45     */
46 	function purchaseHero(uint _heroId) public payable {
47 		require(msg.value == heroes[_heroId].currentPrice);
48 		require(isPaused == false);
49 
50 		// Calculate the 10% value
51 		uint256 devFee = (msg.value / 10);
52 
53 		// Calculate the hero owner commission on this sale & transfer the commission to the owner.		
54 		uint256 commissionOwner = msg.value - devFee; // => 90%
55 		heroes[_heroId].ownerAddress.transfer(commissionOwner);
56 
57 		// Transfer the 10% commission to the developer
58 		devFeeAddress.transfer(devFee); // => 10% 						
59 
60 		// Update the hero owner and set the new price
61 		heroes[_heroId].ownerAddress = msg.sender;
62 		heroes[_heroId].currentPrice = mul(heroes[_heroId].currentPrice, 2);
63 	}
64 	
65 	/*
66 	This function can be used by the owner of a hero to modify the price of its hero.
67 	He can make the price lesser than the current price only.
68 	*/
69 	function modifyCurrentHeroPrice(uint _heroId, uint256 _newPrice) public {
70 	    require(_newPrice > 0);
71 	    require(heroes[_heroId].ownerAddress == msg.sender);
72 	    require(_newPrice < heroes[_heroId].currentPrice);
73 	    heroes[_heroId].currentPrice = _newPrice;
74 	}
75 	
76 	// This function will return all of the details of the Dragon Ball Z heroes
77 	function getHeroDetails(uint _heroId) public view returns (
78         string heroName,
79         address ownerAddress,
80         uint256 currentPrice
81     ) {
82         Hero storage _hero = heroes[_heroId];
83 
84         heroName = _hero.heroName;
85         ownerAddress = _hero.ownerAddress;
86         currentPrice = _hero.currentPrice;
87     }
88     
89     // This function will return only the price of a specific hero
90     function getHeroCurrentPrice(uint _heroId) public view returns(uint256) {
91         return(heroes[_heroId].currentPrice);
92     }
93     
94     // This function will return only the owner address of a specific hero
95     function getHeroOwner(uint _heroId) public view returns(address) {
96         return(heroes[_heroId].ownerAddress);
97     }
98     
99     
100     /**
101     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
102     */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         if (a == 0) {
105           return 0;
106         }
107         uint256 c = a * b;
108         assert(c / a == b);
109         return c;
110     }
111 
112     /**
113     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
114     */
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         // assert(b > 0); // Solidity automatically throws when dividing by 0
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119         return c;
120     }
121     
122 	// This function will be used to add a new hero by the contract creator
123 	function addHero(string heroName, address ownerAddress, uint256 currentPrice) public onlyContractCreator {
124         heroes.push(Hero(heroName,ownerAddress,currentPrice));
125     }
126 	
127 }
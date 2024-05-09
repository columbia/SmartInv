1 pragma solidity ^0.4.18;
2 
3 contract NBACrypto {
4 
5 	address ceoAddress = 0xD2f0e35EB79789Ea24426233336DDa6b13E2fA1f;
6     address cfoAddress = 0x831a278fF506bf4dAa955359F9c5DA9B9Be18f3A;
7 
8 	struct Team {
9 		string name;
10 		address ownerAddress;
11 		uint256 curPrice;
12 	}
13 	Team[] teams;
14 
15 	modifier onlyCeo() {
16         require (msg.sender == ceoAddress);
17         _;
18     }
19 
20     bool teamsAreInitiated;
21     bool isPaused;
22     
23     /*
24     We use the following functions to pause and unpause the game.
25     */
26     function pauseGame() public onlyCeo {
27         isPaused = true;
28     }
29     function unPauseGame() public onlyCeo {
30         isPaused = false;
31     }
32     function GetIsPauded() public view returns(bool) {
33        return(isPaused);
34     }
35 
36     /*
37     This function allows players to purchase countries from other players. 
38     The price is automatically multiplied by 2 after each purchase.
39     Players can purchase multiple coutries
40     */
41 	function purchaseCountry(uint _countryId) public payable {
42 		require(msg.value == teams[_countryId].curPrice);
43 		require(isPaused == false);
44 
45 		// Calculate the 5% value
46 		uint256 commission5percent = (msg.value / 10);
47 
48 		// Calculate the owner commission on this sale & transfer the commission to the owner.		
49 		uint256 commissionOwner = msg.value - commission5percent; // => 95%
50 		teams[_countryId].ownerAddress.transfer(commissionOwner);
51 
52 		// Transfer the 5% commission to the developer
53 		cfoAddress.transfer(commission5percent); // => 5% (25% remains in the Jackpot)						
54 
55 		// Update the team owner and set the new price
56 		teams[_countryId].ownerAddress = msg.sender;
57 		teams[_countryId].curPrice = mul(teams[_countryId].curPrice, 2);
58 	}
59 	
60 	/*
61 	This function can be used by the owner of a team to modify the price of its team.
62 	He can make the price smaller than the current price but never bigger.
63 	*/
64 	function modifyPriceCountry(uint _teamId, uint256 _newPrice) public {
65 	    require(_newPrice > 0);
66 	    require(teams[_teamId].ownerAddress == msg.sender);
67 	    require(_newPrice < teams[_teamId].curPrice);
68 	    teams[_teamId].curPrice = _newPrice;
69 	}
70 	
71 	// This function will return all of the details of our teams
72 	function getTeam(uint _teamId) public view returns (
73         string name,
74         address ownerAddress,
75         uint256 curPrice
76     ) {
77         Team storage _team = teams[_teamId];
78 
79         name = _team.name;
80         ownerAddress = _team.ownerAddress;
81         curPrice = _team.curPrice;
82     }
83     
84     // This function will return only the price of a specific team
85     function getTeamPrice(uint _teamId) public view returns(uint256) {
86         return(teams[_teamId].curPrice);
87     }
88     
89     // This function will return only the addess of a specific team
90     function getTeamOwner(uint _teamId) public view returns(address) {
91         return(teams[_teamId].ownerAddress);
92     }
93     
94     /**
95     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
96     */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99           return 0;
100         }
101         uint256 c = a * b;
102         assert(c / a == b);
103         return c;
104     }
105 
106     /**
107     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
108     */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         // assert(b > 0); // Solidity automatically throws when dividing by 0
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113         return c;
114     }
115 
116 	// We run this function once to create all the teams and set the initial price.
117 	function InitiateTeams() public onlyCeo {
118 		require(teamsAreInitiated == false);
119         teams.push(Team("Raptors", cfoAddress, 750000000000000000)); 
120 		teams.push(Team("Rockets", cfoAddress, 750000000000000000)); 
121 		teams.push(Team("Celtics", cfoAddress, 700000000000000000)); 
122         teams.push(Team("Warriors", cfoAddress, 700000000000000000)); 
123         teams.push(Team("Cavaliers", cfoAddress, 650000000000000000)); 
124         teams.push(Team("Spurs", cfoAddress, 650000000000000000)); 
125         teams.push(Team("Wizards", cfoAddress, 600000000000000000)); 
126         teams.push(Team("Timberwolves", cfoAddress, 600000000000000000)); 
127         teams.push(Team("Pacers", cfoAddress, 550000000000000000)); 
128         teams.push(Team("Thunder", cfoAddress, 550000000000000000)); 
129         teams.push(Team("Bucks", cfoAddress, 500000000000000000));
130         teams.push(Team("Nuggets", cfoAddress, 500000000000000000)); 
131 		teams.push(Team("76ers", cfoAddress, 450000000000000000));
132 		teams.push(Team("Blazers", cfoAddress, 450000000000000000)); 		
133         teams.push(Team("Heat", cfoAddress, 400000000000000000)); 		
134         teams.push(Team("Pelicans", cfoAddress, 400000000000000000)); 		
135         teams.push(Team("Pistons", cfoAddress, 350000000000000000)); 		
136         teams.push(Team("Clippers", cfoAddress, 350000000000000000)); 
137         teams.push(Team("Hornets", cfoAddress, 300000000000000000));		
138         teams.push(Team("Jazz", cfoAddress, 300000000000000000)); 		
139         teams.push(Team("Knicks", cfoAddress, 250000000000000000)); 		
140         teams.push(Team("Lakers", cfoAddress, 250000000000000000)); 		
141         teams.push(Team("Bulls", cfoAddress, 200000000000000000)); 		
142         teams.push(Team("Grizzlies", cfoAddress, 200000000000000000)); 		
143         teams.push(Team("Nets", cfoAddress, 150000000000000000));		
144         teams.push(Team("Kings", cfoAddress, 150000000000000000));		
145         teams.push(Team("Magic", cfoAddress, 100000000000000000));		
146         teams.push(Team("Mavericks", cfoAddress, 100000000000000000)); 
147         teams.push(Team("Hawks", cfoAddress, 100000000000000000));			
148         teams.push(Team("Suns", cfoAddress, 100000000000000000)); 		
149 	}
150 
151 }
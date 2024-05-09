1 pragma solidity ^0.4.18;
2 
3 contract WorldCupEther {
4 
5 	address ceoAddress = 0xb92C14C5E4a6878C9B44F4115D9C1b0aC702F092;
6     address cfoAddress = 0x0A6b1ae1190C40aE0192fCd7f0C52E91D539e2c0;
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
119         teams.push(Team("Russia", cfoAddress, 195000000000000000)); 
120 		teams.push(Team("Germany", cfoAddress, 750000000000000000)); 
121 		teams.push(Team("Brazil", cfoAddress, 700000000000000000)); 
122         teams.push(Team("Argentina", cfoAddress, 650000000000000000)); 
123         teams.push(Team("Portugal", cfoAddress, 350000000000000000)); 
124         teams.push(Team("Poland", cfoAddress, 125000000000000000)); 
125         teams.push(Team("France", cfoAddress, 750000000000000000)); 
126         teams.push(Team("Belgium", cfoAddress, 400000000000000000)); 
127         teams.push(Team("England", cfoAddress, 500000000000000000)); 
128         teams.push(Team("Spain", cfoAddress, 650000000000000000)); 
129         teams.push(Team("Switzerland", cfoAddress, 125000000000000000));
130         teams.push(Team("Peru", cfoAddress, 60000000000000000)); 
131 		teams.push(Team("Uruguay", cfoAddress, 225000000000000000));
132 		teams.push(Team("Colombia", cfoAddress, 195000000000000000)); 		
133         teams.push(Team("Mexico", cfoAddress, 125000000000000000)); 		
134         teams.push(Team("Croatia", cfoAddress, 125000000000000000)); 		
135         teams.push(Team("Denmark", cfoAddress, 95000000000000000)); 		
136         teams.push(Team("Iceland", cfoAddress, 75000000000000000)); 
137         teams.push(Team("Costa Rica", cfoAddress, 50000000000000000));		
138         teams.push(Team("Sweden", cfoAddress, 95000000000000000)); 		
139         teams.push(Team("Tunisia", cfoAddress, 30000000000000000)); 		
140         teams.push(Team("Egypt", cfoAddress, 60000000000000000)); 		
141         teams.push(Team("Senegal", cfoAddress, 70000000000000000)); 		
142         teams.push(Team("Iran", cfoAddress, 30000000000000000)); 		
143         teams.push(Team("Serbia", cfoAddress, 75000000000000000));		
144         teams.push(Team("Nigeria", cfoAddress, 75000000000000000));		
145         teams.push(Team("Australia", cfoAddress, 40000000000000000));		
146         teams.push(Team("Japan", cfoAddress, 70000000000000000)); 
147         teams.push(Team("Morocco", cfoAddress, 50000000000000000));			
148         teams.push(Team("Panama", cfoAddress, 25000000000000000)); 		
149         teams.push(Team("South Korea", cfoAddress, 30000000000000000)); 
150 		teams.push(Team("Saudi Arabia", cfoAddress, 15000000000000000));
151 	}
152 
153 }
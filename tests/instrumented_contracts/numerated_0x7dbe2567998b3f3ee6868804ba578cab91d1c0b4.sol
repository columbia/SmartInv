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
13 
14   struct Player {
15     string name;
16     address ownerAddress;
17     uint256 curPrice;
18     uint256 realTeamId;
19   }
20 	Team[] teams;
21   Player[] players;
22 
23 	modifier onlyCeo() {
24         require (msg.sender == ceoAddress);
25         _;
26     }
27 
28     bool teamsAreInitiated;
29     bool playersAreInitiated;
30     bool isPaused;
31 
32     /*
33     We use the following functions to pause and unpause the game.
34     */
35     function pauseGame() public onlyCeo {
36         isPaused = true;
37     }
38     function unPauseGame() public onlyCeo {
39         isPaused = false;
40     }
41     function GetIsPauded() public view returns(bool) {
42        return(isPaused);
43     }
44 
45     /*
46     This function allows players to purchase countries from other players.
47     The price is automatically multiplied by 2 after each purchase.
48     Players can purchase multiple coutries
49     */
50 	function purchaseCountry(uint _countryId) public payable {
51 		require(msg.value == teams[_countryId].curPrice);
52 		require(isPaused == false);
53 
54 		// Calculate the 5% value
55 		uint256 commission5percent = (msg.value / 10);
56 
57 		// Calculate the owner commission on this sale & transfer the commission to the owner.
58 		uint256 commissionOwner = msg.value - commission5percent; // => 95%
59 		teams[_countryId].ownerAddress.transfer(commissionOwner);
60 
61 		// Transfer the 5% commission to the developer
62 		cfoAddress.transfer(commission5percent); // => 5% (25% remains in the Jackpot)
63 
64 		// Update the team owner and set the new price
65 		teams[_countryId].ownerAddress = msg.sender;
66 		teams[_countryId].curPrice = mul(teams[_countryId].curPrice, 2);
67 	}
68 
69   function purchasePlayer(uint256 _playerId) public payable {
70     require(msg.value == players[_playerId].curPrice);
71 	require(isPaused == false);
72 
73     // Calculate dev fee
74 		uint256 commissionDev = (msg.value / 10);
75 
76     //Calculate commision for team owner
77     uint256 commisionTeam = (msg.value / 5);
78 
79     uint256 afterDevCut = msg.value - commissionDev;
80 
81     uint256 teamId;
82 
83     players[_playerId].realTeamId = teamId;
84 
85 		// Calculate the owner commission on this sale & transfer the commission to the owner.
86 		uint256 commissionOwner = afterDevCut - commisionTeam; //
87 		players[_playerId].ownerAddress.transfer(commissionOwner);
88         teams[teamId].ownerAddress.transfer(commisionTeam);
89 
90 		// Transfer fee to Dev
91 		cfoAddress.transfer(commissionDev);
92 
93 		// Update the team owner and set the new price
94 
95 
96 		players[_playerId].ownerAddress = msg.sender;
97 		players[_playerId].curPrice = mul(players[_playerId].curPrice, 2);
98   }
99 
100 	/*
101 	This function can be used by the owner of a team to modify the price of its team.
102 	He can make the price smaller than the current price but never bigger.
103 	*/
104 	function modifyPriceCountry(uint _teamId, uint256 _newPrice) public {
105 	    require(_newPrice > 0);
106 	    require(teams[_teamId].ownerAddress == msg.sender);
107 	    require(_newPrice < teams[_teamId].curPrice);
108 	    teams[_teamId].curPrice = _newPrice;
109 	}
110 
111 	// This function will return all of the details of our teams
112 	function getTeam(uint _teamId) public view returns (
113         string name,
114         address ownerAddress,
115         uint256 curPrice
116     ) {
117         Team storage _team = teams[_teamId];
118 
119         name = _team.name;
120         ownerAddress = _team.ownerAddress;
121         curPrice = _team.curPrice;
122     }
123 
124     function getPlayer(uint _playerId) public view returns (
125           string name,
126           address ownerAddress,
127           uint256 curPrice,
128           uint256 realTeamId
129       ) {
130           Player storage _player = players[_playerId];
131 
132           name = _player.name;
133           ownerAddress = _player.ownerAddress;
134           curPrice = _player.curPrice;
135           realTeamId = _player.realTeamId;
136       }
137 
138 
139     // This function will return only the price of a specific team
140     function getTeamPrice(uint _teamId) public view returns(uint256) {
141         return(teams[_teamId].curPrice);
142     }
143 
144     function getPlayerPrice(uint _playerId) public view returns(uint256) {
145         return(players[_playerId].curPrice);
146     }
147 
148     // This function will return only the addess of a specific team
149     function getTeamOwner(uint _teamId) public view returns(address) {
150         return(teams[_teamId].ownerAddress);
151     }
152 
153     function getPlayerOwner(uint _playerId) public view returns(address) {
154         return(players[_playerId].ownerAddress);
155     }
156 
157     /**
158     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
159     */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         if (a == 0) {
162           return 0;
163         }
164         uint256 c = a * b;
165         assert(c / a == b);
166         return c;
167     }
168 
169     /**
170     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
171     */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         // assert(b > 0); // Solidity automatically throws when dividing by 0
174         uint256 c = a / b;
175         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176         return c;
177     }
178 
179 	// We run this function once to create all the teams and set the initial price.
180 	function InitiateTeams() public onlyCeo {
181 		 require(teamsAreInitiated == false);
182 		 teams.push(Team("Cavaliers", 0x54d6fca0ca37382b01304e6716420538604b447b, 6400000000000000000));
183  		 teams.push(Team("Warriors", 0xc88ddaa37c1fec910670366ae16df2aa5e1124f7, 12800000000000000000));
184  		 teams.push(Team("Celtics", 0x28d02f67316123dc0293849a0d254ad86b379b34, 6400000000000000000));
185 		 teams.push(Team("Rockets", 0xc88ddaa37c1fec910670366ae16df2aa5e1124f7, 6400000000000000000));
186 		 teams.push(Team("Raptors", 0x5c035bb4cb7dacbfee076a5e61aa39a10da2e956, 6400000000000000000));
187 		 teams.push(Team("Spurs", 0x183febd8828a9ac6c70c0e27fbf441b93004fc05, 3200000000000000000));
188 		 teams.push(Team("Wizards", 0xaec539a116fa75e8bdcf016d3c146a25bc1af93b, 3200000000000000000));
189 		 teams.push(Team("Timberwolves", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 3200000000000000000));
190 		 teams.push(Team("Pacers", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 1600000000000000000));
191 		 teams.push(Team("Thunder", 0x7d757e571bd545008a95cd0c48d2bb164faa72e3, 3200000000000000000));
192 		 teams.push(Team("Bucks", 0x1edb4c7b145cef7e46d5b5c256cedcd5c45f2ece, 3200000000000000000));
193 		 teams.push(Team("Lakers", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 3200000000000000000));
194 		 teams.push(Team("76ers", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 3200000000000000000));
195 		 teams.push(Team("Blazers", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
196 		 teams.push(Team("Heat", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 3200000000000000000));
197 		 teams.push(Team("Pelicans", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
198 		 teams.push(Team("Pistons", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
199 		 teams.push(Team("Clippers", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
200 		 teams.push(Team("Hornets", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
201 		 teams.push(Team("Jazz", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
202 		 teams.push(Team("Knicks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
203 		 teams.push(Team("Nuggets", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
204 		 teams.push(Team("Bulls", 0x28d02f67316123dc0293849a0d254ad86b379b34, 3200000000000000000));
205 		 teams.push(Team("Grizzlies", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
206 		 teams.push(Team("Nets", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
207 		 teams.push(Team("Kings", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
208 		 teams.push(Team("Magic", 0xb87e73ad25086c43a16fe5f9589ff265f8a3a9eb, 3200000000000000000));
209 		 teams.push(Team("Mavericks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
210 		 teams.push(Team("Hawks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
211 		 teams.push(Team("Suns", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
212 	}
213 
214     function addPlayer(string name, address address1, uint256 price, uint256 teamId) public onlyCeo {
215         players.push(Player(name,address1,price,teamId));
216     }
217 
218 
219 
220 }
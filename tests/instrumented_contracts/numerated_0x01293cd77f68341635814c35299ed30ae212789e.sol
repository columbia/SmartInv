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
45 
46 	function purchaseCountry(uint _countryId) public payable {
47 		require(msg.value == teams[_countryId].curPrice);
48 		require(isPaused == false);
49 
50 
51 		uint256 commission5percent = (msg.value / 10);
52 
53 
54 		uint256 commissionOwner = msg.value - commission5percent; // => 95%
55 		teams[_countryId].ownerAddress.transfer(commissionOwner);
56 
57 
58 		cfoAddress.transfer(commission5percent);
59 
60 		// Update the team owner and set the new price
61 		teams[_countryId].ownerAddress = msg.sender;
62 		teams[_countryId].curPrice = mul(teams[_countryId].curPrice, 2);
63 	}
64 
65   function purchasePlayer(uint256 _playerId) public payable {
66     require(msg.value == players[_playerId].curPrice);
67 	require(isPaused == false);
68 
69     // Calculate dev fee
70 		uint256 commissionDev = (msg.value / 10);
71 
72     //Calculate commision for team owner
73     uint256 commisionTeam = (msg.value / 5);
74 
75     uint256 afterDevCut = msg.value - commissionDev;
76 
77 
78 
79 		// Calculate the owner commission on this sale & transfer the commission to the owner.
80 		uint256 commissionOwner = afterDevCut - commisionTeam; //
81 		players[_playerId].ownerAddress.transfer(commissionOwner);
82     teams[players[_playerId].realTeamId].ownerAddress.transfer(commisionTeam);
83 
84 		// Transfer fee to Dev
85 		cfoAddress.transfer(commissionDev);
86 
87 		// Update the team owner and set the new price
88 
89 
90 		players[_playerId].ownerAddress = msg.sender;
91 		players[_playerId].curPrice = mul(players[_playerId].curPrice, 2);
92   }
93 
94 	/*
95 	This function can be used by the owner of a team to modify the price of its team.
96 	He can make the price smaller than the current price but never bigger.
97 	*/
98 	function modifyPriceCountry(uint _teamId, uint256 _newPrice) public {
99 	    require(_newPrice > 0);
100 	    require(teams[_teamId].ownerAddress == msg.sender);
101 	    require(_newPrice < teams[_teamId].curPrice);
102 	    teams[_teamId].curPrice = _newPrice;
103 	}
104 
105 	// This function will return all of the details of our teams
106 	function getTeam(uint _teamId) public view returns (
107         string name,
108         address ownerAddress,
109         uint256 curPrice
110     ) {
111         Team storage _team = teams[_teamId];
112 
113         name = _team.name;
114         ownerAddress = _team.ownerAddress;
115         curPrice = _team.curPrice;
116     }
117 
118     function getPlayer(uint _playerId) public view returns (
119           string name,
120           address ownerAddress,
121           uint256 curPrice,
122           uint256 realTeamId
123       ) {
124           Player storage _player = players[_playerId];
125 
126           name = _player.name;
127           ownerAddress = _player.ownerAddress;
128           curPrice = _player.curPrice;
129           realTeamId = _player.realTeamId;
130       }
131 
132 
133     // This function will return only the price of a specific team
134     function getTeamPrice(uint _teamId) public view returns(uint256) {
135         return(teams[_teamId].curPrice);
136     }
137 
138     function getPlayerPrice(uint _playerId) public view returns(uint256) {
139         return(players[_playerId].curPrice);
140     }
141 
142     // This function will return only the addess of a specific team
143     function getTeamOwner(uint _teamId) public view returns(address) {
144         return(teams[_teamId].ownerAddress);
145     }
146 
147     function getPlayerOwner(uint _playerId) public view returns(address) {
148         return(players[_playerId].ownerAddress);
149     }
150 
151     /**
152     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
153     */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156           return 0;
157         }
158         uint256 c = a * b;
159         assert(c / a == b);
160         return c;
161     }
162 
163     /**
164     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
165     */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173 	// We run this function once to create all the teams and set the initial price.
174 	function InitiateTeams() public onlyCeo {
175 		 require(teamsAreInitiated == false);
176 		 teams.push(Team("Cavaliers", 0x54d6fca0ca37382b01304e6716420538604b447b, 6400000000000000000));
177  		 teams.push(Team("Warriors", 0xc88ddaa37c1fec910670366ae16df2aa5e1124f7, 12800000000000000000));
178  		 teams.push(Team("Celtics", 0x28d02f67316123dc0293849a0d254ad86b379b34, 6400000000000000000));
179 		 teams.push(Team("Rockets", 0xc88ddaa37c1fec910670366ae16df2aa5e1124f7, 6400000000000000000));
180 		 teams.push(Team("Raptors", 0x5c035bb4cb7dacbfee076a5e61aa39a10da2e956, 6400000000000000000));
181 		 teams.push(Team("Spurs", 0x183febd8828a9ac6c70c0e27fbf441b93004fc05, 3200000000000000000));
182 		 teams.push(Team("Wizards", 0xaec539a116fa75e8bdcf016d3c146a25bc1af93b, 3200000000000000000));
183 		 teams.push(Team("Timberwolves", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 3200000000000000000));
184 		 teams.push(Team("Pacers", 0x8e668a4582d0465accf66b4e4ab6d817f6c5b2dc, 3200000000000000000));
185 		 teams.push(Team("Thunder", 0x7d757e571bd545008a95cd0c48d2bb164faa72e3, 3200000000000000000));
186 		 teams.push(Team("Bucks", 0x1edb4c7b145cef7e46d5b5c256cedcd5c45f2ece, 3200000000000000000));
187 		 teams.push(Team("Lakers", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 3200000000000000000));
188 		 teams.push(Team("76ers", 0xa2381223639181689cd6c46d38a1a4884bb6d83c, 3200000000000000000));
189 		 teams.push(Team("Blazers", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
190 		 teams.push(Team("Heat", 0xef764bac8a438e7e498c2e5fccf0f174c3e3f8db, 3200000000000000000));
191 		 teams.push(Team("Pelicans", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
192 		 teams.push(Team("Pistons", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
193 		 teams.push(Team("Clippers", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
194 		 teams.push(Team("Hornets", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
195 		 teams.push(Team("Jazz", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
196 		 teams.push(Team("Knicks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
197 		 teams.push(Team("Nuggets", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
198 		 teams.push(Team("Bulls", 0x28d02f67316123dc0293849a0d254ad86b379b34, 3200000000000000000));
199 		 teams.push(Team("Grizzlies", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
200 		 teams.push(Team("Nets", 0x54d6fca0ca37382b01304e6716420538604b447b, 1600000000000000000));
201 		 teams.push(Team("Kings", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
202 		 teams.push(Team("Magic", 0xb87e73ad25086c43a16fe5f9589ff265f8a3a9eb, 3200000000000000000));
203 		 teams.push(Team("Mavericks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
204 		 teams.push(Team("Hawks", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
205 		 teams.push(Team("Suns", 0x7ec915b8d3ffee3deaae5aa90def8ad826d2e110, 3200000000000000000));
206 	}
207 
208     function addPlayer(string name, address address1, uint256 price, uint256 realTeamId) public onlyCeo {
209         players.push(Player(name,address1,price,realTeamId));
210     }
211 
212 
213 
214 }
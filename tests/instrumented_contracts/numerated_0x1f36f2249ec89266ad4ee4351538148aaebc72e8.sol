1 contract euroteambet {
2 
3 	struct team {
4 		string teamName;
5 		mapping(address => uint) bet;
6 		uint totalBet;
7 	}
8 
9 	team[] public euroTeams;
10 
11 	bool winningTeamDefined;
12 	uint winningTeam;
13 
14 	/** Bets close at the opening day of the EuroCup: 10 June 2016 **/
15 	uint startCompetitionTime;
16 
17 	/**  Overall amount bet **/
18 	uint public globalBet;
19 
20 	/** Define the creator and fees collected **/
21 	address creator;
22 	uint feeCollected;
23 
24 	/**
25 	* Constructor: Defines team and creator
26 	*/
27 	function euroteambet() {
28 		// Define the Teams
29 		team memory toCreate;
30 		// Post a dummy team to ensure the actual range is from 1 to 24 and not 0 to 23.
31 		toCreate.teamName = '';
32 		euroTeams.push(toCreate);
33 		toCreate.teamName = 'Albania';
34 		euroTeams.push(toCreate);
35 		toCreate.teamName = 'Austria';
36 		euroTeams.push(toCreate);
37 		toCreate.teamName = 'Belgium';
38 		euroTeams.push(toCreate);
39 		toCreate.teamName = 'Croatia';
40 		euroTeams.push(toCreate);
41 		toCreate.teamName = 'Czech Republic';
42 		euroTeams.push(toCreate);
43 		toCreate.teamName = 'England';
44 		euroTeams.push(toCreate);
45 		toCreate.teamName = 'France';
46 		euroTeams.push(toCreate);
47 		toCreate.teamName = 'Germany';
48 		euroTeams.push(toCreate);
49 		toCreate.teamName = 'Hungary';
50 		euroTeams.push(toCreate);
51 		toCreate.teamName = 'Iceland';
52 		euroTeams.push(toCreate);
53 		toCreate.teamName = 'Italy';
54 		euroTeams.push(toCreate);
55 		toCreate.teamName = 'Nothern Ireland';
56 		euroTeams.push(toCreate);
57 		toCreate.teamName = 'Poland';
58 		euroTeams.push(toCreate);
59 		toCreate.teamName = 'Portugal';
60 		euroTeams.push(toCreate);
61 		toCreate.teamName = 'Republic of Ireland';
62 		euroTeams.push(toCreate);
63 		toCreate.teamName = 'Romania';
64 		euroTeams.push(toCreate);
65 		toCreate.teamName = 'Russia';
66 		euroTeams.push(toCreate);
67 		toCreate.teamName = 'Slovakia';
68 		euroTeams.push(toCreate);
69 		toCreate.teamName = 'Spain';
70 		euroTeams.push(toCreate);
71 		toCreate.teamName = 'Sweden';
72 		euroTeams.push(toCreate);
73 		toCreate.teamName = 'Switzerland';
74 		euroTeams.push(toCreate);
75 		toCreate.teamName = 'Turkey';
76 		euroTeams.push(toCreate);
77 		toCreate.teamName = 'Ukraine';
78 		euroTeams.push(toCreate);
79 		toCreate.teamName = 'Wales';
80 		euroTeams.push(toCreate);
81 
82 		creator = msg.sender;
83 
84 		winningTeamDefined = false;
85 
86 		// Euro Cup starts in 4 days
87 		startCompetitionTime = block.timestamp + (60 * 60 * 24) * 4;
88 
89 	}
90 
91 
92 	event BetFromTransaction(address indexed from, uint value);
93 	event CollectFromTransaction(address indexed from, uint value);	
94 	event BetClosedNoWinningTeam(address indexed from, uint value);	
95 	/**
96 	 * Catch-All Function: Un case of transaction received going though a Contract Function
97 	 * 1: Check if bets are still open
98 	 * 2: Check if the bet is more than 0.1 ETH
99 	 * 3: Divided by 1000000000000000 to have an integer (0.016 Eth to 16) and call betOnATeam
100 	 *    If the EeasyBet value is not correct (possible value 1 to 24), it will be throw in BetOnAteam function
101 	 * 4: Check if the winning team as been defined    
102 	 */
103 	function () {
104 		if (startCompetitionTime >= block.timestamp) {
105 			if (msg.value >= 100 finney) {
106 				BetFromTransaction(msg.sender, msg.value);
107 				betOnATeam((msg.value % 100 finney) / 1000000000000000);
108 			} else {
109 				msg.sender.send(msg.value);
110 				return;
111 			}
112 		} else if (winningTeamDefined == true) {
113 			CollectFromTransaction(msg.sender, msg.value);
114 			collectEarnings();
115 		} else {
116 			BetClosedNoWinningTeam(msg.sender, msg.value);
117 			if(msg.value > 0){
118 				msg.sender.send(msg.value);
119 			}
120 			return;
121 		}
122 	}
123 
124 	/**
125 	 * Used to defined the winner of the Tournament
126 	 * 1: The winning team is updated 
127 	 * 2: All amount invested are gathered in globalBet
128 	 * 3: All balances of the winning team updated proportionally to the amount invested
129 	 *
130 	 * param      {uint  teamWinningName  The identifier of the team winning
131 	 */
132 	function setWinner(uint teamWinningID) {
133 		// Check if the sender is the creator and if the tournament has ended
134 		if (msg.sender == creator) {
135 			winningTeam = teamWinningID;
136 			winningTeamDefined = true;
137 		} else {
138 			if(msg.value > 0){
139 				msg.sender.send(msg.value);
140 			}
141 			return;
142 		}
143 	}
144 
145 
146 	event BetOnATeam(address indexed from, uint indexed id, uint value);
147 	/**
148 	 * Used to bet on the winner of the Tournament
149 	 * 1: Check if bets are still open
150 	 * 2: Check if the bet is more than 0.1 ETH
151 	 * 3: Check if the id of the team is correct (possible value 1 to 24)
152 	 * param      {uint}  id      The identifier of the team to bet on
153 	 */
154 	function betOnATeam(uint id) {
155 		if (startCompetitionTime >= block.timestamp && msg.value >= 100 finney && id >= 1 && id <= 24) {
156 
157 			uint amount = msg.value;
158 
159 			// Collect 3% Fee
160 			feeCollected += (amount * 3 / 100);
161 			amount -= (amount * 3 / 100);
162 
163 			BetOnATeam(msg.sender, id, amount);
164 
165 			euroTeams[id].bet[msg.sender] += amount;
166 			euroTeams[id].totalBet += amount;
167 			globalBet += amount;
168 		} else {
169 			if(msg.value > 0){
170 				msg.sender.send(msg.value);
171 			}
172 			return;
173 		}
174 	}
175 
176 	/**
177 	* Check earnings for a specific address
178 	* 
179 	* param      address  toCheck  Address to check its earnings 
180 	* return     uint   Amount earned
181 	*/
182 	function checkEarnings(address toCheck) returns (uint) {
183 		if(msg.value > 0){
184 			msg.sender.send(msg.value);
185 		}
186 
187 		if (winningTeamDefined == true) {
188 			return (globalBet * (euroTeams[winningTeam].bet[toCheck] / euroTeams[winningTeam].totalBet));
189 		} else {
190 			return 0;
191 		}
192 	}
193 
194 	/**
195 	 * Only allowed the withdrawals of the fund once the Winning team is updated
196 	 */
197 	function collectEarnings() {
198 		if(msg.value > 0){
199 			msg.sender.send(msg.value);
200 		}
201 		if (winningTeamDefined == true) {
202 			uint earnings = (globalBet * (euroTeams[winningTeam].bet[msg.sender] / euroTeams[winningTeam].totalBet));
203 			msg.sender.send(earnings);
204 			euroTeams[winningTeam].bet[msg.sender] = 0;
205 		} else {
206 			return;
207 		}
208 	}
209 
210 	/**
211 	* Allow the creator of the game to send balance
212 	* 
213 	* param      address  toSend  Address to receive its earnings 
214 	*/
215 	function sendEarnings(address toSend) {
216 		if(msg.value > 0){
217 			msg.sender.send(msg.value);
218 		}
219 		if (msg.sender == creator && winningTeamDefined == true) {
220 			uint earnings = (globalBet * (euroTeams[winningTeam].bet[toSend] / euroTeams[winningTeam].totalBet));
221 			toSend.send(earnings);
222 			euroTeams[winningTeam].bet[toSend] = 0;
223 		} else {
224 			return;
225 		}
226 	}
227 
228 	/**
229 	* Allow the creator to collect the 3% Fee
230 	*/
231 	function collectFee() {
232 		msg.sender.send(msg.value);
233 		if (msg.sender == creator) {
234 			creator.send(feeCollected);
235 			feeCollected = 0;
236 		} else {
237 			return;
238 		}
239 	}
240 
241 }
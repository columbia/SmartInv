1 pragma solidity ^0.4.21;
2 
3 // ============================================================================
4 // ERC Token Standard #20 Interface (For communication with DiipCoin Contract)
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 // ============================================================================
7 contract ERC20Interface {
8     function totalSupply() public constant returns (uint);
9     function balanceOf(address tokenOwner) public constant returns (uint balance);
10     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
11     function transfer(address to, uint tokens) public returns (bool success);
12     function approve(address spender, uint tokens) public returns (bool success);
13     function transferFrom(address from, address to, uint tokens) public returns (bool success);
14 
15     event Transfer(address indexed from, address indexed to, uint tokens);
16     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
17 }
18 
19 // ============================================================================
20 // Owned contract
21 // ============================================================================
22 contract Owned {
23     address public owner;
24     address public newOwner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     function Owned() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         newOwner = _newOwner;
39     }
40     function acceptOwnership() public {
41         require(msg.sender == newOwner);
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44         newOwner = address(0);
45     }
46 }
47 
48 // ============================================================================
49 // Tourpool contract
50 // ============================================================================
51 contract TourPool is Owned{
52 	// state variables
53 	bool public startlistUploaded;
54 	address diipCoinContract;
55 	address public currentLeader;
56 	uint public highScore;
57 	uint public prizeMoney;
58 	uint public registrationDeadline;
59 	uint public maxTeamSize;
60 	uint public playerBudget;
61 	uint public playerCount;
62 
63 	// Rider and Player structs
64 	struct Rider {
65 		uint price;
66 		uint score;
67 	}
68 
69 	struct Player {
70 		uint status;
71 		uint[] team;
72 		uint teamPrice;
73 	}
74 
75 	// mappings of riders and players
76 	mapping(address => Player) public players;
77 	address[] public registrations;
78 	mapping(uint => Rider) public riders;
79 
80 	// Events
81 	event NewPlayer(address indexed player);
82 	event TeamCommitted(address indexed player, uint indexed teamPrice, uint[] team);
83 	event scoresUpdated(uint[] riderIDs, uint[] dayScores);
84 	event scoresEdited(uint[] riderIDs, uint[] newScores);
85 	event PrizeMoneyStored(uint Prize);	
86 
87 	// Function Modifiers
88 	modifier beforeDeadline {
89 		require(now <= registrationDeadline);
90 		_;
91 	}
92 
93 	modifier diipCoinOnly {
94 		require(msg.sender == diipCoinContract);
95 		_;
96 	}
97 
98 	// -----------
99 	// Constructor
100 	// -----------	
101 	function TourPool() public {		
102 		diipCoinContract = 0xc9E86029bd081af490ce39a3BcB1bccF99d33CfF;		
103 		registrationDeadline = 1530954000;
104 		maxTeamSize = 8;
105 		playerBudget = 100;
106 		startlistUploaded = false;		
107 	}
108 
109 	// ---------------------------
110 	//  Public (player) functions
111 	// ---------------------------
112 	function register() public beforeDeadline returns (bool success){		
113 		// players may register only once
114 		require(players[msg.sender].status == 0);		
115 		// update player status
116 		players[msg.sender].status = 1;
117 		players[msg.sender].teamPrice = 0;
118 		registrations.push(msg.sender);
119 		// Broadcast event of player registration
120 		emit NewPlayer(msg.sender);
121 		// sent 100 DIIP to contract caller
122 		return transferPlayerBudget(msg.sender);		
123 	}
124 
125 	// This function is called from the diipcoin contract
126 	function tokenFallback(
127 		address _sender,
128 	    uint _value,	    
129 	    uint[] _team
130 	) 
131 		public beforeDeadline diipCoinOnly returns (bool) 
132 	{
133 		require(startlistUploaded);	    
134 	    return commitTeam(_sender, _value, _team);
135 	}
136 
137 	// ---------------------------
138 	//  Only Owner functions
139 	// ---------------------------
140 	function uploadStartlist(uint[] prices) public onlyOwner beforeDeadline returns (bool success){
141 		require(prices.length == 176);	
142 		for (uint i; i < prices.length; i++){
143 			riders[i + 1].price = prices[i];
144 		}
145 		startlistUploaded = true;
146 		return true;
147 	}
148 
149 	function editStartlist(uint[] riderIDs, uint[] prices) public onlyOwner beforeDeadline returns (bool success){
150 		require(riderIDs.length == prices.length);
151 		for (uint i = 0; i < riderIDs.length; i++){
152 			riders[riderIDs[i]].price = prices[i];
153 		}
154 		return true;
155 	}
156 
157 	function commitScores(
158 		uint[] _riderIDs, 
159 		uint[] _scores		
160 		) 
161 		public onlyOwner 
162 		{
163 		require(_riderIDs.length == _scores.length);
164 		// Update scores
165 		for (uint i; i < _riderIDs.length; i++){			
166 			riders[_riderIDs[i]].score += _scores[i];
167 		}		
168 		emit scoresUpdated(_riderIDs, _scores);
169 		// Set new highscore
170 		(highScore, currentLeader) = getHighscore();
171 	}
172 
173 	function editScores(uint[] _riderIDs, uint[] _newScores) public onlyOwner returns (bool success){
174 		require(_riderIDs.length == _newScores.length);
175 		for (uint i; i < _riderIDs.length; i++){			
176 			riders[_riderIDs[i]].score = _newScores[i];
177 		}
178 		(highScore, currentLeader) = getHighscore();
179 		emit scoresEdited(_riderIDs, _newScores);
180 		return true;
181 	}
182 
183 
184 	function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
185         return ERC20Interface(tokenAddress).transfer(owner, tokens);
186     }
187 
188     function storePrizeMoney() public payable onlyOwner returns (bool success){
189     	emit PrizeMoneyStored(msg.value);
190     	prizeMoney = msg.value;
191     	return true;
192     }
193 
194     function payTheWinner() public payable onlyOwner returns (bool success){
195     	uint toSend = prizeMoney;
196     	prizeMoney -=  toSend;
197     	currentLeader.transfer(toSend);
198     	return true;
199     }
200 
201     // ---------------------------
202 	//  Getters
203 	// ---------------------------
204 	function getTeamPrice(uint[] team) public view returns (uint totalPrice){
205 		totalPrice = 0;
206 		for (uint i; i < team.length; i++){
207 			totalPrice += riders[team[i]].price;
208 		}
209 	}
210 
211 	function getPlayerScore(address _player) public view returns(uint score){
212 		uint[] storage team = players[_player].team;			
213 		score = 0;
214 		for (uint i = 0; i < team.length; i++){
215 			uint dupCount = 0;
216 			for (uint j = 0;j < team.length; j++){
217 				if (team[i] == team[j]){
218 					dupCount++;
219 				}				
220 			}
221 			if (dupCount == 1){
222 				score += riders[team[i]].score;	
223 			}
224 		}
225 		return score;
226 	}
227 
228 	function getHighscore() public view returns (uint newHighscore, address leader){
229 		newHighscore = 0;		
230 		for (uint i; i < registrations.length; i++){
231 			uint score = getPlayerScore(registrations[i]);
232 			if (score > newHighscore){
233 				newHighscore = score;
234 				leader = registrations[i];
235 			}			
236 		}
237 		return (newHighscore, leader);
238 	}
239 
240 	function getPlayerTeam(address _player) public view returns(uint[] team){
241 		return players[_player].team;
242 	}
243 
244 
245     // ---------------------------
246 	//  Private functions
247 	// ---------------------------
248     function transferPlayerBudget(address playerAddress) private returns (bool success){
249     	return ERC20Interface(diipCoinContract).transfer(playerAddress, playerBudget);
250     }
251 
252     function commitTeam(
253     	address _player, 
254     	uint _value, 
255     	uint[] _team
256     ) 
257     	private returns (bool success)
258     {
259 	    // check team size, price and player registration
260 	    require(players[_player].status >= 1);
261 	    require(_team.length <= maxTeamSize);
262 	    uint oldPrice = players[_player].teamPrice;
263 	    uint newPrice = getTeamPrice(_team);
264 	    require(oldPrice + _value >= newPrice);
265 	    require(oldPrice + _value <= playerBudget);
266 	    // commit team and emit event
267 	    if (newPrice < oldPrice){
268 	    	ERC20Interface(diipCoinContract).transfer(_player,  (oldPrice - newPrice));
269 	    }
270     	players[_player].teamPrice = newPrice;
271     	players[_player].team = _team;
272     	players[_player].status = 2;
273     	emit TeamCommitted(_player, newPrice, _team);	  
274     	return true;
275     }
276 
277 }
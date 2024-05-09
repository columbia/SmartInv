1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 contract FootieToken {
4 
5 	/*** EVENTS ***/
6 
7 	/// @dev The Birth event is fired whenever a new team comes into existence.
8 	event Birth(uint256 teamId, string name, address owner);
9 
10 	/// @dev Transfer event as defined in current draft of ERC721. 
11 	///  ownership is assigned, including births.
12 	event Transfer(address from, address to, uint256 teamId);
13 
14 	/// @dev The TeamSold event is fired, as you might expect, whenever a team is sold.
15 	event TeamSold(uint256 index, uint256 oldPrice, uint256 newPrice, address prevOwner, address newOwne, string name);
16 
17 
18 	/*** CONSTANTS ***/
19 
20 	/// @notice Name and symbol of the non fungible token, as defined in ERC721.
21 	string public constant NAME = "CryptoFootie"; // solhint-disable-line
22 	string public constant SYMBOL = "FootieToken"; // solhint-disable-line
23 
24 	uint256 private startingPrice = 0.002 ether;
25 	uint256 private constant TEAM_CREATION_LIMIT = 1000;
26 	uint256 private princeIncreasePercentage = 24;
27 
28 
29 	/*** STORAGE ***/
30 
31 	/// @dev A mapping from team IDs to the address that owns them. All teams have
32 	///  some valid owner address.
33 	mapping (uint256 => address) private teamIndexToOwner;
34 
35 	// @dev A mapping from the owner address to count of teams that address owns.
36 	//  Used internally inside balanceOf() to resolve ownership count.
37 	mapping (address => uint256) private ownershipTeamCount;
38 
39 	/// @dev A mapping from teamIDs to an address that has been approved to call
40 	///  transferFrom(). Each tram can only have one approved address for transfer
41 	///  at any time. A zero value means no approval is outstanding.
42 	mapping (uint256 => address) private teamIndexToApproved;
43 
44 	// @dev A mapping from teamIDs to the price of the token.
45 	mapping (uint256 => uint256) private teamIndexToPrice;
46 
47 	// @dev A mapping from teamIDs to the price of the token.
48 	mapping (uint256 => uint256) private teamIndexToGoals;
49 
50 	// The address of the account that can execute actions within each roles.
51 	address public creatorAddress;
52 
53 	// Keeps track of how many teams have been created
54 	uint256 public teamsCreatedCount;
55 
56 
57 	/*** DATATYPES ***/
58 	struct Team {
59 		string name;
60 	}
61 	Team[] private teams;
62 
63 
64 	/*** ACCESS MODIFIERS ***/
65 	/// @dev Access modifier for Creator-only functionality
66 	modifier onlyCreator() {
67 		require(msg.sender == creatorAddress);
68 		_;
69 	}
70 
71 
72 	/*** CONSTRUCTOR ***/
73 	function FootieToken() public {
74 		creatorAddress = msg.sender;
75 	}
76 
77 	function _createTeam(string _name, uint256 _price) public onlyCreator {
78 		require(teamsCreatedCount < TEAM_CREATION_LIMIT);
79 		// set initial price
80 		if (_price <= 0) {
81 			_price = startingPrice;
82 		}
83 
84 		// increase the number of teams created so far
85 		teamsCreatedCount++;
86 
87 		Team memory _team = Team({
88 			name: _name
89 		});
90 		uint256 newteamId = teams.push(_team) - 1;
91 
92 		// It's probably never going to happen, 4 billion tokens are A LOT, but
93 		// let's just be 100% sure we never let this happen.
94 		require(newteamId == uint256(uint32(newteamId)));
95 
96 		// send event to DAPP or anyone interested
97 		Birth(newteamId, _name, creatorAddress);
98 
99 		teamIndexToPrice[newteamId] = _price;
100 
101 		// This will assign ownership, and also emit the Transfer event as
102 		// per ERC721 draft
103 		_transfer(creatorAddress, creatorAddress, newteamId);
104 	}
105 
106 	/// @notice Returns all the relevant information about a specific team.
107 	/// @param _index The index (teamId) of the team of interest.
108 	function getTeam(uint256 _index) public view returns (string teamName, uint256 sellingPrice, address owner, uint256 goals) {
109 		Team storage team = teams[_index];
110 		teamName = team.name;
111 		sellingPrice = teamIndexToPrice[_index];
112 		owner = teamIndexToOwner[_index];
113 		goals = teamIndexToGoals[_index];
114 	}
115 	
116 	/// For querying balance of a particular account
117 	/// @param _owner The address for balance query
118 	/// @dev Required for ERC-721 compliance.
119 	function balanceOf(address _owner) public view returns (uint256 balance) {
120 		return ownershipTeamCount[_owner];
121 	}
122 
123 	/// For querying owner of token
124 	/// @param _index The teamID for owner inquiry
125 	/// @dev Required for ERC-721 compliance.
126 	function ownerOf(uint256 _index) public view returns (address owner) {
127 		owner = teamIndexToOwner[_index];
128 		require(owner != address(0));
129 	}
130 
131 	// Allows someone to send ether and buy a team
132 	function buyTeam(uint256 _index) public payable {
133 		address oldOwner = teamIndexToOwner[_index];
134 		address newOwner = msg.sender;
135 
136 		uint256 sellingPrice = teamIndexToPrice[_index];
137 
138 		// Making sure token owner is not sending to self
139 		require(oldOwner != newOwner);
140 
141 		// Safety check to prevent against an unexpected 0x0 default.
142 		require(_addressNotNull(newOwner));
143 
144 		// Making sure sent amount is greater than or equal to the sellingPrice
145 		require(msg.value >= sellingPrice);
146 
147 
148 		// 96% goes to old owner
149 		uint256 payment = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 96), 100));
150 
151 		// 4% goes to the contract creator address
152 		uint256 fee = uint256(SafeMath.div(SafeMath.mul(sellingPrice, 4), 100));
153 		
154 		// any excess (the new owner payed more than needed) will be refunded to the new owner
155 		uint256 purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
156 
157 		// Update price
158 		teamIndexToPrice[_index] = sellingPrice + SafeMath.div(SafeMath.mul(sellingPrice, princeIncreasePercentage), 100);
159 
160 		//Update transaction count
161 		teamIndexToGoals[_index] = teamIndexToGoals[_index] + 1;
162 
163 		// send the money to the previous owner
164 		oldOwner.transfer(payment);
165 		// pay fee
166 		creatorAddress.transfer(fee);
167 
168 		// store the transfer
169 		_transfer(oldOwner, newOwner, _index);
170 
171 		TeamSold(_index, sellingPrice, teamIndexToPrice[_index], oldOwner, newOwner, teams[_index].name);
172 
173 		msg.sender.transfer(purchaseExcess);
174 	}
175 
176 
177 
178 	/*** PRIVATE FUNCTIONS ***/
179 
180 	/// Safety check on _to address to prevent against an unexpected 0x0 default.
181 	function _addressNotNull(address _to) private pure returns (bool) {
182 		return _to != address(0);
183 	}
184 
185 	/// @dev Assigns ownership of a specific Person to an address.
186 	function _transfer(address _from, address _to, uint256 _index) private {
187 		// Since the number of persons is capped to 2^32 we can't overflow this
188 		ownershipTeamCount[_to]++;
189 		//transfer ownership
190 		teamIndexToOwner[_index] = _to;
191 
192 		// Emit the transfer event.
193 		Transfer(_from, _to, _index);
194 	}
195 
196 }
197 
198 
199 
200 
201 
202 library SafeMath {
203 
204 	/**
205 	* @dev Multiplies two numbers, throws on overflow.
206 	*/
207 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208 		if (a == 0) {
209 			return 0;
210 		}
211 		uint256 c = a * b;
212 		assert(c / a == b);
213 		return c;
214 	}
215 
216 	/**
217 	* @dev Integer division of two numbers, truncating the quotient.
218 	*/
219 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
220 		// assert(b > 0); // Solidity automatically throws when dividing by 0
221 		uint256 c = a / b;
222 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 		return c;
224 	}
225 
226 	/**
227 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
228 	*/
229 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
230 		assert(b <= a);
231 		return a - b;
232 	}
233 
234 	/**
235 	* @dev Adds two numbers, throws on overflow.
236 	*/
237 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
238 		uint256 c = a + b;
239 		assert(c >= a);
240 	return c;
241 	}
242 }
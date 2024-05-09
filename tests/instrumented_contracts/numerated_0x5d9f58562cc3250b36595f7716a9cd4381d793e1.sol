1 pragma solidity ^0.4.25;
2 
3 library SafeMath
4 {
5 	function mul(uint a, uint b) internal pure returns (uint)
6 	{
7 		if (a == 0)
8 		{
9 			return 0;
10 		}
11 		uint c = a * b;
12 		assert(c / a == b);
13 		return c;
14 	}
15 
16 	function div(uint a, uint b) internal pure returns (uint)
17 	{
18 		// assert(b > 0); // Solidity automatically throws when dividing by 0
19 		uint c = a / b;
20 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
21 		return c;
22 	}
23 
24 	function sub(uint a, uint b) internal pure returns (uint)
25 	{
26 		assert(b <= a);
27 		return a - b;
28 	}
29 
30 	function add(uint a, uint b) internal pure returns (uint)
31 	{
32 		uint c = a + b;
33 		assert(c >= a);
34 		return c;
35 	}
36 }
37 
38 contract ERC721
39 {
40 	function approve(address _to, uint _tokenId) public;
41 	function balanceOf(address _owner) public view returns (uint balance);
42 	function implementsERC721() public pure returns (bool);
43 	function ownerOf(uint _tokenId) public view returns (address addr);
44 	function takeOwnership(uint _tokenId) public;
45 	function totalSupply() public view returns (uint total);
46 	function transferFrom(address _from, address _to, uint _tokenId) public;
47 	function transfer(address _to, uint _tokenId) public;
48 
49 	event LogTransfer(address indexed from, address indexed to, uint tokenId);
50 	event LogApproval(address indexed owner, address indexed approved, uint tokenId);
51 }
52 
53 contract CryptoCricketToken is ERC721
54 {
55 	event LogBirth(uint tokenId, string name, uint internalTypeId, uint Price);
56 	event LogSnatch(uint tokenId, string tokenName, address oldOwner, address newOwner, uint oldPrice, uint newPrice);
57 	event LogTransfer(address from, address to, uint tokenId);
58 
59 	string public constant name = "CryptoCricket";
60 	string public constant symbol = "CryptoCricketToken";
61 
62 	uint private commision = 4;
63 
64 	mapping (uint => uint) private startingPrice;
65 
66 	/// @dev A mapping from player IDs to the address that owns them. All players have some valid owner address.
67 	mapping (uint => address) public playerIndexToOwner;
68 
69 	// @dev A mapping from owner address to count of tokens that address owns. Used internally inside balanceOf() to resolve ownership count.
70 	mapping (address => uint) private ownershipTokenCount;
71 
72 	/// @dev A mapping from PlayerIDs to an address that has been approved to call transferFrom(). Each Player can only have one approved address for transfer at any time. A zero value means no approval is outstanding.
73 	mapping (uint => address) public playerIndexToApproved;
74 
75 	// @dev A mapping from PlayerIDs to the price of the token.
76 	mapping (uint => uint) private playerIndexToPrice;
77 
78 	// @dev A mapping from PlayerIDs to the reward price of the token obtained while selling.
79 	mapping (uint => uint) private playerIndexToRewardPrice;
80 
81 	// The addresses of the accounts (or contracts) that can execute actions within each roles.
82 	address public ceoAddress;
83 	address public devAddress;
84 
85 	struct Player
86 	{
87 		string name;
88 		uint internalTypeId;
89 	}
90 
91 	Player[] private players;
92 
93 	/// @dev Access modifier for CEO-only functionality
94 	modifier onlyCEO()
95 	{
96 		require(msg.sender == ceoAddress);
97 		_;
98 	}
99 
100 	modifier onlyDevORCEO()
101 	{
102 		require(msg.sender == devAddress || msg.sender == ceoAddress);
103 		_;
104 	}
105 
106 	constructor(address _ceo, address _dev) public
107 	{
108 		ceoAddress = _ceo;
109 		devAddress = _dev;
110 		startingPrice[0] = 0.005 ether; // 2x
111 		startingPrice[1] = 0.007 ether; // 2.5x
112 		startingPrice[2] = 0.005 ether; // 1.5x
113 	}
114 
115 	/// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().
116 	/// @param _to The address to be granted transfer approval. Pass address(0) to
117 	///    clear all approvals.
118 	/// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
119 	/// @dev Required for ERC-721 compliance.
120 	function approve(address _to, uint _tokenId) public
121 	{
122 		require(owns(msg.sender, _tokenId));
123 		playerIndexToApproved[_tokenId] = _to;
124 		emit LogApproval(msg.sender, _to, _tokenId);
125 	}
126 
127 	function getRewardPrice(uint buyingPrice, uint _internalTypeId) internal view returns(uint rewardPrice)
128 	{
129 		if(_internalTypeId == 0) //Cricket Board Card
130 		{
131 			rewardPrice = SafeMath.div(SafeMath.mul(buyingPrice, 200), 100);
132 		}
133 		else if(_internalTypeId == 1) //Country Card
134 		{
135 			rewardPrice = SafeMath.div(SafeMath.mul(buyingPrice, 250), 100);
136 		}
137 		else //Player Card
138 		{
139 			rewardPrice = SafeMath.div(SafeMath.mul(buyingPrice, 150), 100);
140 		}
141 
142 		rewardPrice = uint(SafeMath.div(SafeMath.mul(rewardPrice, SafeMath.sub(100, commision)), 100));
143 		return rewardPrice;
144 	}
145 
146 
147 	/// For creating Player
148 	function createPlayer(string _name, uint _internalTypeId) public onlyDevORCEO
149 	{
150 		require (_internalTypeId >= 0 && _internalTypeId <= 2);
151 		Player memory _player = Player({name: _name, internalTypeId: _internalTypeId});
152 		uint newPlayerId = players.push(_player) - 1;
153 		playerIndexToPrice[newPlayerId] = startingPrice[_internalTypeId];
154 		playerIndexToRewardPrice[newPlayerId] = getRewardPrice(playerIndexToPrice[newPlayerId], _internalTypeId);
155 
156 		emit LogBirth(newPlayerId, _name, _internalTypeId, startingPrice[_internalTypeId]);
157 
158 		// This will assign ownership, and also emit the Transfer event as per ERC721 draft
159 		_transfer(address(0), address(this), newPlayerId);
160 	}
161 
162 	function payout(address _to) public onlyCEO
163 	{
164 		if(_addressNotNull(_to))
165 		{
166 			_to.transfer(address(this).balance);
167 		}
168 		else
169 		{
170 			ceoAddress.transfer(address(this).balance);
171 		}
172 	}
173 
174 	// Allows someone to send ether and obtain the token
175 	function purchase(uint _tokenId) public payable
176 	{
177 		address oldOwner = playerIndexToOwner[_tokenId];
178 		uint sellingPrice = playerIndexToPrice[_tokenId];
179 
180 		require(oldOwner != msg.sender);
181 		require(_addressNotNull(msg.sender));
182 		require(msg.value >= sellingPrice);
183 
184 		address newOwner = msg.sender;
185 		uint payment = uint(SafeMath.div(SafeMath.mul(sellingPrice, SafeMath.sub(100, commision)), 100));
186 		uint purchaseExcess = SafeMath.sub(msg.value, sellingPrice);
187 		uint _internalTypeId = players[_tokenId].internalTypeId;
188 
189 		if(_internalTypeId == 0) //Cricket Board Card
190 		{
191 			playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 200), 100);
192 		}
193 		else if(_internalTypeId == 1) //Country Card
194 		{
195 			playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 250), 100);
196 		}
197 		else //Player Card
198 		{
199 			playerIndexToPrice[_tokenId] = SafeMath.div(SafeMath.mul(sellingPrice, 150), 100);
200 		}
201 
202 		_transfer(oldOwner, newOwner, _tokenId);
203 		emit LogSnatch(_tokenId, players[_tokenId].name, oldOwner, newOwner, sellingPrice, playerIndexToPrice[_tokenId]);
204 
205 		playerIndexToRewardPrice[_tokenId] = getRewardPrice(playerIndexToPrice[_tokenId], _internalTypeId);
206 
207 		if (oldOwner != address(this))
208 		{
209 			oldOwner.transfer(payment);
210 		}
211 		msg.sender.transfer(purchaseExcess);
212 	}
213 
214 	/// @param _owner The owner whose soccer player tokens we are interested in.
215 	/// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
216 	///    expensive (it walks the entire Players array looking for players belonging to owner),
217 	///    but it also returns a dynamic array, which is only supported for web3 calls, and
218 	///    not contract-to-contract calls.
219 	function tokensOfOwner(address _owner) public view returns(uint[] ownerTokens)
220 	{
221 		uint tokenCount = balanceOf(_owner);
222 		if (tokenCount == 0)
223 		{
224 			return new uint[](0);
225 		}
226 		else
227 		{
228 			uint[] memory result = new uint[](tokenCount);
229 			uint totalPlayers = totalSupply();
230 			uint resultIndex = 0;
231 
232 			uint playerId;
233 			for (playerId = 0; playerId <= totalPlayers; playerId++)
234 			{
235 				if (playerIndexToOwner[playerId] == _owner)
236 				{
237 					result[resultIndex] = playerId;
238 					resultIndex++;
239 				}
240 			}
241 			return result;
242 		}
243 	}
244 
245 	/// Owner initates the transfer of the token to another account
246 	/// @param _to The address for the token to be transferred to.
247 	/// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
248 	/// @dev Required for ERC-721 compliance.
249 	function transfer(address _to, uint _tokenId) public
250 	{
251 		require(owns(msg.sender, _tokenId));
252 		require(_addressNotNull(_to));
253 
254 		_transfer(msg.sender, _to, _tokenId);
255 	}
256 
257 	/// Third-party initiates transfer of token from address _from to address _to
258 	/// @param _from The address for the token to be transferred from.
259 	/// @param _to The address for the token to be transferred to.
260 	/// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
261 	/// @dev Required for ERC-721 compliance.
262 	function transferFrom(address _from, address _to, uint _tokenId) public
263 	{
264 		require(owns(_from, _tokenId));
265 		require(_approved(_to, _tokenId));
266 		require(_addressNotNull(_to));
267 		_transfer(_from, _to, _tokenId);
268 	}
269 
270 	/// @dev Assigns ownership of a specific Player to an address.
271 	function _transfer(address _from, address _to, uint _tokenId) private
272 	{
273 		// Since the number of players is capped to 2^32 we can't overflow this
274 		ownershipTokenCount[_to]++;
275 		//transfer ownership
276 		playerIndexToOwner[_tokenId] = _to;
277 
278 		// When creating new players _from is 0x0, but we can't account that address.
279 		if (_addressNotNull(_from))
280 		{
281 			ownershipTokenCount[_from]--;
282 			// clear any previously approved ownership exchange
283 			delete playerIndexToApproved[_tokenId];
284 		}
285 
286 		// Emit the transfer event.
287 		emit LogTransfer(_from, _to, _tokenId);
288 	}
289 
290 	/// Safety check on _to address to prevent against an unexpected 0x0 default.
291 	function _addressNotNull(address _to) private pure returns (bool)
292 	{
293 		return (_to != address(0));
294 	}
295 
296 	/// For querying balance of a particular account
297 	/// @param _owner The address for balance query
298 	/// @dev Required for ERC-721 compliance.
299 	function balanceOf(address _owner) public view returns (uint balance)
300 	{
301 		return ownershipTokenCount[_owner];
302 	}
303 
304 	/// @notice Returns all the relevant information about a specific player.
305 	/// @param _tokenId The tokenId of the player of interest.
306 	function getPlayer(uint _tokenId) public view returns (string playerName, uint internalTypeId, uint sellingPrice, address owner)
307 	{
308 		Player storage player = players[_tokenId];
309 		playerName = player.name;
310 		internalTypeId = player.internalTypeId;
311 		sellingPrice = playerIndexToPrice[_tokenId];
312 		owner = playerIndexToOwner[_tokenId];
313 	}
314 
315 	/// For querying owner of token
316 	/// @param _tokenId The tokenID for owner inquiry
317 	/// @dev Required for ERC-721 compliance.
318 	function ownerOf(uint _tokenId) public view returns (address owner)
319 	{
320 		owner = playerIndexToOwner[_tokenId];
321 		require (_addressNotNull(owner));
322 	}
323 
324 	/// For checking approval of transfer for address _to
325 	function _approved(address _to, uint _tokenId) private view returns (bool)
326 	{
327 		return playerIndexToApproved[_tokenId] == _to;
328 	}
329 
330 	/// Check for token ownership
331 	function owns(address claimant, uint _tokenId) private view returns (bool)
332 	{
333 		return (claimant == playerIndexToOwner[_tokenId]);
334 	}
335 
336 	function priceOf(uint _tokenId) public view returns (uint price)
337 	{
338 		return playerIndexToPrice[_tokenId];
339 	}
340 
341 	function rewardPriceOf(uint _tokenId) public view returns (uint price)
342 	{
343 		return playerIndexToRewardPrice[_tokenId];
344 	}
345 
346 	/// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
347 	/// @param _newCEO The address of the new CEO
348 	function setCEO(address _newCEO) public onlyCEO
349 	{
350 		require (_addressNotNull(_newCEO));
351 		ceoAddress = _newCEO;
352 	}
353 
354 	/// @dev Assigns a new address to act as the Dev. Only available to the current CEO.
355 	/// @param _newDev The address of the new Dev
356 	function setDev(address _newDev) public onlyCEO
357 	{
358 		require (_addressNotNull(_newDev));
359 		devAddress = _newDev;
360 	}
361 
362 	/// @notice Allow pre-approved user to take ownership of a token
363 	/// @param _tokenId The ID of the Token that can be transferred if this call succeeds.
364 	/// @dev Required for ERC-721 compliance.
365 	function takeOwnership(uint _tokenId) public
366 	{
367 		address newOwner = msg.sender;
368 		address oldOwner = playerIndexToOwner[_tokenId];
369 
370 		// Safety check to prevent against an unexpected 0x0 default.
371 		require(_addressNotNull(newOwner));
372 
373 		// Making sure transfer is approved
374 		require(_approved(newOwner, _tokenId));
375 
376 		_transfer(oldOwner, newOwner, _tokenId);
377 	}
378 
379 	/// @dev Assigns a new commison percentage. Only available to the current CEO.
380 	/// @param _newCommision The new commison
381 	function updateCommision (uint _newCommision) public onlyCEO
382 	{
383 		require (_newCommision > 0 && _newCommision < 100);
384 		commision = _newCommision;
385 	}
386 
387 	function implementsERC721() public pure returns (bool)
388 	{
389 		return true;
390 	}
391 
392 	/// For querying totalSupply of token
393 	/// @dev Required for ERC-721 compliance.
394 	function totalSupply() public view returns (uint total)
395 	{
396 		return players.length;
397 	}
398 }
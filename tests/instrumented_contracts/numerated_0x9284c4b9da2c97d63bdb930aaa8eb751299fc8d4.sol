1 pragma solidity ^0.4.18;
2 
3 contract EightStakes {
4 	struct Player {
5 		uint dt;
6 		address oAddress;
7 		int nSpent;
8 		int[] aResults;
9 		mapping (uint => uint) mGasByRoom;
10 	}
11 	struct Room {
12 		address[] aPlayers;
13 		uint[] aLosers;
14 		uint nBid;
15 		uint nStart;
16 		uint nLastPlayersBlockNumber;
17 	}
18     address private _oSesokaj;
19 	
20 	mapping (address => Player) private _mPlayers;
21 	mapping (address => uint8) private _mPlayerRooms;
22 	address[] private _aPlayersBinds;
23 	address[] private _aLosers;
24 
25 	uint private _nRoomNextID;
26 	mapping (uint => Room) private _mRooms;
27 	uint[] private _aRoomsOpened;
28 	uint[] private _aRoomsClosed;
29 
30 	uint private _nMaxArchiveLength;
31 	
32 	uint private _nRefundCurrent;
33 	uint private _nRefundLimit;
34 	uint private _nRefundIncrease;
35 	address private _oRefundRecipient;
36 	
37 	uint private _nJackpot;
38 	uint private _nJackpotLast;
39 	uint private _nJackpotDiapason;
40 	address private _oJackpotRecipient;
41 
42 	function EightStakes() public {
43 	    _oSesokaj = msg.sender;
44 		_nMaxArchiveLength = 300;   
45 		_nJackpotDiapason = uint(-1)/(3.5 * 100000); 
46 		_nRefundLimit = 8000000000000000000;  // 8eth
47 		_nRefundIncrease = 8000000000000000000;  // 8eth
48 		_aLosers.length = 10;
49 	}
50 
51 	// PUBLIC
52 	function Bid(uint8 nRoomSize) public payable returns(bool) {
53 		uint8 nRoomType; //room type as a bit-flag value; size/bid: 0 for unused pair; 1 for 4/0.08, 2 for 4/0.8, 4 and 8 reserved, 16 for 8/0.08, 32 for 8/0.8, 64 for 8/8, 128 reserved
54 		int nRoomTypeIndx; //index from zero to four; size/bid: -1 for unused pair; 0 for 4/0.08, 1 for 4/0.8, 2 for 8/0.08, 3 for 8/0.8, 4 for 8/8
55 		(nRoomType, nRoomTypeIndx) = roomTypeGet(msg.value, nRoomSize);
56 		if (1 > nRoomType)
57 			revert();
58 		
59 		ProcessRooms();
60 		//check for rebid
61 		if (0 != _mPlayerRooms[msg.sender] & nRoomType)
62 			revert();
63 		_mPlayerRooms[msg.sender] |= nRoomType;
64 		uint nRoom = roomGet(msg.value, nRoomSize);
65 		Room memory oRoom = _mRooms[nRoom];
66 		uint nPlayer = 0;
67 		for (; oRoom.aPlayers.length > nPlayer; nPlayer++) {
68 		    if (1 > oRoom.aPlayers[nPlayer])
69 				break;
70 		    if (oRoom.aPlayers[nPlayer] == msg.sender)  
71 				revert();
72 		}
73 		uint nGas = msg.gas*800000000;
74 		if (0 < _mPlayers[msg.sender].oAddress) {
75 		    _mPlayers[msg.sender].dt = now;
76 			_mPlayers[msg.sender].nSpent += int(nGas);
77 			_mPlayers[msg.sender].aResults[uint(nRoomTypeIndx)] = 0;
78 		} else {
79 			_mPlayers[msg.sender] = Player(now, msg.sender, int(nGas), new int[](5));
80 			_aPlayersBinds.push(msg.sender);
81 		}
82 		_mPlayers[msg.sender].mGasByRoom[nRoom] = nGas;
83 		oRoom.aPlayers[nPlayer] = msg.sender;
84 		if (nPlayer + 1 == oRoom.aPlayers.length) {
85 			oRoom.nStart = now;
86 			oRoom.nLastPlayersBlockNumber = block.number;
87 		}
88 		_mRooms[nRoom] = oRoom;
89 		return true;
90 	}
91 	function IsCheckNeeded(uint nNowDate, uint nMaxInterval) public constant returns(bool) {
92 		for (uint n=0; n<_aRoomsOpened.length; n++) {
93 			if (0 < _mRooms[_aRoomsOpened[n]].nLastPlayersBlockNumber && 
94 					_mRooms[_aRoomsOpened[n]].nStart + nMaxInterval < nNowDate && 
95 					0 < uint(block.blockhash(_mRooms[_aRoomsOpened[n]].nLastPlayersBlockNumber)) ) { 
96 				return true;
97 			}
98 		}
99 		return false;
100 	}
101 	function ProcessRooms() public {
102 		uint[] memory a = new uint[](_aRoomsOpened.length);
103 		uint n = 0;
104 		uint nCurrent = 0;
105 		uint nRoom;
106 		Room memory oRoom;
107 		for (; _aRoomsOpened.length > n; n++) {
108 		    oRoom = _mRooms[nRoom = _aRoomsOpened[n]];
109 			if (0 < oRoom.nLastPlayersBlockNumber && 0 < uint(block.blockhash(oRoom.nLastPlayersBlockNumber))) {
110 				result(nRoom);
111 				a[nCurrent++] = n;
112 			}
113 		}
114 		for (n = 0; nCurrent > n; n++)
115 			roomClose(a[n]);
116 		delete a;
117 	}
118 	function LastResult(address oPlayer, uint8 nSize, uint nBid) public constant returns (bool, int) {
119 		uint nPlayer = uint(-1);
120 		uint nDate = 0;
121 		uint nRoom = 0;
122 		uint nRoomCurrent;
123 		Room memory oRoom;
124 		for (uint n=0; _aRoomsClosed.length > n; n++) {
125 		    oRoom = _mRooms[nRoomCurrent = _aRoomsClosed[n]];
126 			if (oRoom.aPlayers.length != nSize || oRoom.nBid != nBid || uint(-1) == (nPlayer = playerGet(oRoom, oPlayer)))
127 				continue;
128 			if (oRoom.nStart > nDate) {
129 				nDate = oRoom.nStart;
130 				nRoom = nRoomCurrent;
131 			}
132 		}
133 		if (0 < nDate) {
134 		    oRoom = _mRooms[nRoom];
135 		    for (n=0; oRoom.aLosers.length > n; n++) {
136 		        if (oPlayer == oRoom.aPlayers[oRoom.aLosers[n]])
137     				return(false, int(-oRoom.nBid));
138 			}
139 			return(true, int(prizeCalculate(oRoom)));
140 		}
141 		return(false, 0);
142 	}
143 	//Plenum
144 	//returns a number of players for a room specified by a size and a bid
145 	function Plenum(uint8 nSize, uint nBid) public constant returns (uint8) {
146 		Room memory oRoom;
147 		uint nLength;
148 		for (uint n=0; _aRoomsOpened.length > n; n++) {
149 			oRoom = _mRooms[_aRoomsOpened[n]];
150 			if (nBid == oRoom.nBid && nSize == (nLength = oRoom.aPlayers.length) && 1 > oRoom.aPlayers[--nLength]) {
151 				for (; 0 <= nLength; nLength--) {
152 					if (0 < oRoom.aPlayers[nLength])
153 						return uint8(nLength + 1);
154 				}
155 			}
156 		}
157 		return(0);
158 	}
159 	function State(address[] aTargets) public view returns(uint[4] aPerks, address[2] aPerksRecipients, address[] aLosersAddresses, int[] aLosersBalances, bool[5] aRooms, int[5] aResults) {
160 		aLosersBalances = new int[](_aLosers.length);
161 		uint nLength = _aLosers.length;
162 		uint n = 0;
163 		for (; nLength > n; n++)
164 			aLosersBalances[n] = _mPlayers[_aLosers[n]].nSpent;
165 		for (n = 0; aTargets.length > n; n++) {
166 			uint8 nValue = 1;
167 			for (uint nIndx = 0; aRooms.length > nIndx; nIndx++) {
168 				if (0 < _mPlayerRooms[aTargets[n]]) {
169 					aRooms[nIndx] = aRooms[nIndx] || (0 < (_mPlayerRooms[aTargets[n]] & nValue));
170 					if (2 == nValue)
171 						nValue <<= 3;
172 					else
173 						nValue <<= 1;
174 				}
175 				if (0 == aResults[nIndx] && 0 != _mPlayers[aTargets[n]].oAddress && 0 != _mPlayers[aTargets[n]].aResults[nIndx])
176 					aResults[nIndx] += _mPlayers[aTargets[n]].aResults[nIndx];
177 			}
178 		}
179 		return ([_nJackpot, _nJackpotLast, _nRefundLimit, _nRefundCurrent], [_oJackpotRecipient, _oRefundRecipient], _aLosers, aLosersBalances, aRooms, aResults);
180 	}
181     function Remove() public {
182         if (msg.sender == _oSesokaj)
183             selfdestruct(_oSesokaj);
184     }
185 
186 	// PRIVATE
187 	//roomTypeGet
188 	//returns two values:
189 	//room type as a bit-flag value; size/bid: 0 for unused pair; 1 for 4/0.08, 2 for 4/0.8, 4 and 8 reserved, 16 for 8/0.08, 32 for 8/0.8, 64 for 8/8, 128 reserved
190 	//index from zero to four; size/bid: -1 for unused pair; 0 for 4/0.08, 1 for 4/0.8, 2 for 8/0.08, 3 for 8/0.8, 4 for 8/8
191 	function roomTypeGet(uint nBid, uint8 nSize) private pure returns(uint8, int) {
192 		if (80000000000000000 == nBid) { //0.08eth
193 			if (4 == nSize)
194 				return (1, 0);
195 			if (8 == nSize)
196 				return (16, 2);
197 		}
198 		if (800000000000000000 == nBid) { //0.8eth
199 			if (4 == nSize)
200 				return (2, 1);
201 			if (8 == nSize)
202 				return (32, 3);
203 		}
204 		if (8000000000000000000 == nBid && 8 == nSize) //8eth
205 				return (64, 4);
206 		return (0, -1);
207 	}
208 	function roomClose(uint nOpened) private{
209 	    uint n;
210 		if (_aRoomsClosed.length >= _nMaxArchiveLength) {
211     		uint nClosed = 0;
212     		uint nRoom = 0;
213     		uint nDate = uint(-1);
214     		uint nStart;
215     		for (n=0; _aRoomsClosed.length > n; n++) {
216     			if ((nStart = _mRooms[_aRoomsClosed[n]].nStart) < nDate) {
217     				nClosed = n;
218     				nDate = nStart;
219     			}
220     		}
221     		uint nLength = _mRooms[nRoom = _aRoomsClosed[nClosed]].aPlayers.length;
222 			for (n=0; nLength > n; n++) {
223 			    delete _mPlayers[_mRooms[nRoom].aPlayers[n]].mGasByRoom[nRoom];
224 				delete _mRooms[nRoom].aPlayers[n];
225 			}
226 			delete _mRooms[nRoom];
227 			_aRoomsClosed[nClosed] = _aRoomsOpened[nOpened];
228 		} else
229 			_aRoomsClosed.push(_aRoomsOpened[nOpened]);
230 
231 		if (nOpened < (n = _aRoomsOpened.length - 1))
232 			_aRoomsOpened[nOpened] = _aRoomsOpened[n];
233 		_aRoomsOpened.length--;
234 	}
235 	function roomGet(uint nBid, uint8 nSize) private returns(uint nRetVal) {
236 	    Room memory oRoom;
237 	    uint nLength;
238 		for (uint n=0; _aRoomsOpened.length > n; n++) {
239 		    nRetVal = _aRoomsOpened[n];
240 		    oRoom = _mRooms[nRetVal];
241 		    nLength = oRoom.aPlayers.length;
242 			if (nBid == oRoom.nBid && nSize == nLength && 1 > oRoom.aPlayers[nLength - 1])
243 				return;
244 		}
245 		oRoom = Room(new address[](nSize), new uint[](0), nBid, 0, 0);
246 		_mRooms[nRetVal = _nRoomNextID] = oRoom;
247 		_aRoomsOpened[++_aRoomsOpened.length - 1] = _nRoomNextID;
248 		_nRoomNextID++;
249 		return;
250 	}
251 	function playerGet(Room memory oRoom, address oPlayer) private pure returns(uint) {
252 		for (uint8 n=0; oRoom.aPlayers.length > n; n++) {
253 			if (oPlayer == oRoom.aPlayers[n])
254 				return n;
255 		}
256 		return uint(-1); 
257 	}
258 	function prizeCalculate(Room memory oRoom) private pure returns (uint) {
259 		return (oRoom.nBid / 4);
260 	}
261 	function result(uint nRoom) private {
262 	    Room memory oRoom = _mRooms[nRoom];
263 	    if (0 < oRoom.aLosers.length)
264 	        revert();
265 		uint8 nSize = uint8(oRoom.aPlayers.length);
266 		bytes32[] memory aHashes;
267 		uint8 nIndx1;
268 		uint8 nIndx2;
269 
270 		(aHashes, nIndx1, nIndx2) = gameCalculate(oRoom);
271 
272 	    oRoom.aLosers = new uint[](nSize/4);
273 		oRoom.aLosers[0] = nIndx1;
274 		if (8 == nSize)
275 			oRoom.aLosers[1] = nIndx2;
276 
277 		uint nValue = (oRoom.nBid * oRoom.aPlayers.length / 64);
278 		_nJackpot += nValue;
279 		_nRefundCurrent += nValue;
280 
281 		nValue = prizeCalculate(oRoom);
282 		uint8 nRoomType;
283 		int nRoomTypeIndx;
284 		int nAmount;
285 		(nRoomType, nRoomTypeIndx) = roomTypeGet(oRoom.nBid, nSize);
286 		for (uint n=0; nSize > n; n++) {
287 			if (nIndx1 == n || (8 == nSize && nIndx2 == n))
288 				nAmount = -int(oRoom.nBid);
289 			else if (!_mPlayers[oRoom.aPlayers[n]].oAddress.send(uint(nAmount = int(oRoom.nBid + nValue + _mPlayers[oRoom.aPlayers[n]].mGasByRoom[nRoom]))))
290 				nAmount = 0; //fuckup with sending
291 			_mPlayers[oRoom.aPlayers[n]].nSpent -= (_mPlayers[oRoom.aPlayers[n]].aResults[uint(nRoomTypeIndx)] = nAmount);
292 			if (0 == (_mPlayerRooms[oRoom.aPlayers[n]] &= ~nRoomType))
293 				delete _mPlayerRooms[oRoom.aPlayers[n]]; //remove player from room map if it was his last room
294 		}
295 
296 		uint nDiff = uint(aHashes[nIndx2]) - uint(aHashes[nIndx1]);
297 		if (nDiff > 0 && nDiff < _nJackpotDiapason) {
298 			if (oRoom.aPlayers[nIndx1].send(_nJackpot)) {
299 				_oJackpotRecipient = oRoom.aPlayers[nIndx1];
300 				_nJackpotLast = _nJackpot;
301 				_nJackpot = 0;
302 			}
303 		}
304 		_mRooms[nRoom] = oRoom;
305 
306 		if (_nRefundCurrent > _nRefundLimit && 0 != _aLosers[0]) {
307 			if (_aLosers[0].send(_nRefundCurrent)) {
308 				_oRefundRecipient = _aLosers[0];
309 				_nRefundLimit += _nRefundIncrease;
310 				_mPlayers[_aLosers[0]].nSpent -= int(_nRefundCurrent);
311 				_nRefundCurrent = 0;
312 			}
313 		}
314 		losers();
315 	}
316 	function losers() private {
317 	    Player[] memory aLosers = new Player[](_aLosers.length);
318 		Player memory oPlayer;
319 		Player memory oShift;
320 		uint nLoser;
321 		uint nLength = _aPlayersBinds.length;
322 	    for (uint nPlayer=0; nLength > nPlayer; nPlayer++) {
323 			oPlayer = _mPlayers[_aPlayersBinds[nPlayer]];
324 			if (now - oPlayer.dt > 30 days) {
325 				delete _mPlayers[_aPlayersBinds[nPlayer]];
326 				_aPlayersBinds[nPlayer] = _aPlayersBinds[nLength--];
327 				nPlayer--;
328 				continue;
329 			}
330 			for (nLoser=0; aLosers.length > nLoser; nLoser++) {
331 				if (0 == aLosers[nLoser].oAddress) {
332 					aLosers[nLoser] = oPlayer;
333 					break;
334 				}
335 				if (oPlayer.nSpent > aLosers[nLoser].nSpent) {
336 					oShift = aLosers[nLoser];
337 					aLosers[nLoser] = oPlayer;
338 					oPlayer = oShift;
339 				}
340 			}
341 	    }
342 		for (nLoser=0; aLosers.length > nLoser; nLoser++)
343 			_aLosers[nLoser] = aLosers[nLoser].oAddress;
344 	}
345 	function gameCalculate(Room oRoom) private constant returns (bytes32[] memory aHashes, uint8 nIndx1, uint8 nIndx2) {
346 		bytes32 aBlockHash = block.blockhash(oRoom.nLastPlayersBlockNumber);
347 	    uint nSize = oRoom.aPlayers.length;
348 		aHashes = new bytes32[](nSize);
349 		bytes32 nHash1 = bytes32(-1);
350 		bytes32 nHash2 = bytes32(-1);
351 
352 		for (uint8 n=0; nSize > n; n++) {
353 			aHashes[n] = sha256(uint(oRoom.aPlayers[n]) + uint(aBlockHash));
354 			if (aHashes[n] <= nHash2 ) {
355 				if (aHashes[n] <= nHash1) {
356 					nHash2 = nHash1;
357 					nIndx2 = nIndx1;
358 					nHash1 = aHashes[n];
359 					nIndx1 = n;
360 				} else {
361 					nHash2 = aHashes[n];
362 					nIndx2 = n;
363 				}
364 			}
365 		}
366 		if (nIndx1 == nIndx2)
367 			(nIndx1, nIndx2) = (0, 0);
368 		return;
369 	}
370 }
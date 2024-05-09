1 pragma solidity 0.4.16;
2 
3 
4 library CommonLibrary {
5 	struct Data {
6 		mapping (uint => Node) nodes; 
7 		mapping (string => uint) nodesID;
8 		mapping (string => uint16) nodeGroups;
9 		uint16 nodeGroupID;
10 		uint nodeID;
11 		uint ownerNotationId;
12 		uint addNodeAddressId;
13 	}
14 	
15 	struct Node {
16 		string nodeName;
17 		address producer;
18 		address node;
19 		uint256 date;
20 		bool starmidConfirmed;
21 		address[] outsourceConfirmed;
22 		uint16[] nodeGroup;
23 		uint8 producersPercent;
24 		uint16 nodeSocialMedia;
25 	}
26 	
27 	function addNodeGroup(Data storage self, string _newNodeGroup) returns(bool _result, uint16 _id) {
28 		if (self.nodeGroups[_newNodeGroup] == 0) {
29 			_id = self.nodeGroupID += 1;
30 			self.nodeGroups[_newNodeGroup] = self.nodeGroupID;
31 			_result = true;
32 		}
33 	}
34 	
35 	function addNode(
36 		Data storage self, 
37 		string _newNode, 
38 		uint8 _producersPercent
39 		) returns (bool _result, uint _id) {
40 		if (self.nodesID[_newNode] < 1 && _producersPercent < 100) {
41 			_id = self.nodeID += 1;
42 			require(self.nodeID < 1000000000000);
43 			self.nodes[self.nodeID].nodeName = _newNode;
44 			self.nodes[self.nodeID].producer = msg.sender;
45 			self.nodes[self.nodeID].date = block.timestamp;
46 			self.nodes[self.nodeID].starmidConfirmed = false;
47 			self.nodes[self.nodeID].producersPercent = _producersPercent;
48 			self.nodesID[_newNode] = self.nodeID;
49 			_result = true;
50 		}
51 		else _result = false;
52 	}
53 	
54 	function editNode(
55 	    Data storage self, 
56 		uint _nodeID, 
57 		address _nodeAddress, 
58 		bool _isNewProducer, 
59 		address _newProducer, 
60 		uint8 _newProducersPercent,
61 		bool _starmidConfirmed
62 		) returns (bool) {
63 		if (_isNewProducer == true) {
64 			self.nodes[_nodeID].node = _nodeAddress;
65 			self.nodes[_nodeID].producer = _newProducer;
66 			self.nodes[_nodeID].producersPercent = _newProducersPercent;
67 			self.nodes[_nodeID].starmidConfirmed = _starmidConfirmed;
68 			return true;
69 		}
70 		else {
71 			self.nodes[_nodeID].node = _nodeAddress;
72 			self.nodes[_nodeID].starmidConfirmed = _starmidConfirmed;
73 			return true;
74 		}
75 	}
76 	
77 	function addNodeAddress(Data storage self, uint _nodeID, address _nodeAddress) returns(bool _result, uint _id) {
78 		if (msg.sender == self.nodes[_nodeID].producer) {
79 			if (self.nodes[_nodeID].node == 0) {
80 				self.nodes[_nodeID].node = _nodeAddress;
81 				_id = self.addNodeAddressId += 1;//for event count
82 				_result = true;
83 			}
84 			else _result = false;
85 		}
86 		else _result = false;
87 	}
88 	
89 	//-----------------------------------------Starmid Exchange functions
90 	function stockMinSellPrice(StarCoinLibrary.Data storage self, uint _buyPrice, uint _node) constant returns (uint _minSellPrice) {
91 		_minSellPrice = _buyPrice + 1;
92 		for (uint i = 0; i < self.stockSellOrderPrices[_node].length; i++) {
93 			if(self.stockSellOrderPrices[_node][i] < _minSellPrice) _minSellPrice = self.stockSellOrderPrices[_node][i];
94 		}
95 	}
96 	
97 	function stockMaxBuyPrice (StarCoinLibrary.Data storage self, uint _sellPrice, uint _node) constant returns (uint _maxBuyPrice) {
98 		_maxBuyPrice = _sellPrice - 1;
99 		for (uint i = 0; i < self.stockBuyOrderPrices[_node].length; i++) {
100 			if(self.stockBuyOrderPrices[_node][i] > _maxBuyPrice) _maxBuyPrice = self.stockBuyOrderPrices[_node][i];
101 		}
102 	}
103 	
104 	function stockDeleteFirstOrder(StarCoinLibrary.Data storage self, uint _node, uint _price, bool _isStockSellOrders) {
105 		if (_isStockSellOrders == true) uint _length = self.stockSellOrders[_node][_price].length;
106 		else _length = self.stockBuyOrders[_node][_price].length;
107 		for (uint ii = 0; ii < _length - 1; ii++) {
108 			if (_isStockSellOrders == true) self.stockSellOrders[_node][_price][ii] = self.stockSellOrders[_node][_price][ii + 1];
109 			else self.stockBuyOrders[_node][_price][ii] = self.stockBuyOrders[_node][_price][ii + 1];
110 		}
111 		if (_isStockSellOrders == true) {
112 			delete self.stockSellOrders[_node][_price][self.stockSellOrders[_node][_price].length - 1];
113 			self.stockSellOrders[_node][_price].length--;
114 			//Delete _price from stockSellOrderPrices[_node][] if it's the last order
115 			if (self.stockSellOrders[_node][_price].length == 0) {
116 				uint fromArg = 99999;
117 				for (uint8 iii = 0; iii < self.stockSellOrderPrices[_node].length - 1; iii++) {
118 					if (self.stockSellOrderPrices[_node][iii] == _price) {
119 						fromArg = iii;
120 					}
121 					if (fromArg != 99999 && iii >= fromArg) self.stockSellOrderPrices[_node][iii] = self.stockSellOrderPrices[_node][iii + 1];
122 				}
123 				delete self.stockSellOrderPrices[_node][self.stockSellOrderPrices[_node].length-1];
124 				self.stockSellOrderPrices[_node].length--;
125 			}
126 		}
127 		else {
128 			delete self.stockBuyOrders[_node][_price][self.stockBuyOrders[_node][_price].length - 1];
129 			self.stockBuyOrders[_node][_price].length--;
130 			//Delete _price from stockBuyOrderPrices[_node][] if it's the last order
131 			if (self.stockBuyOrders[_node][_price].length == 0) {
132 				fromArg = 99999;
133 				for (iii = 0; iii < self.stockBuyOrderPrices[_node].length - 1; iii++) {
134 					if (self.stockBuyOrderPrices[_node][iii] == _price) {
135 						fromArg = iii;
136 					}
137 					if (fromArg != 99999 && iii >= fromArg) self.stockBuyOrderPrices[_node][iii] = self.stockBuyOrderPrices[_node][iii + 1];
138 				}
139 				delete self.stockBuyOrderPrices[_node][self.stockBuyOrderPrices[_node].length-1];
140 				self.stockBuyOrderPrices[_node].length--;
141 			}
142 		}
143 	}
144 	
145 	function stockSaveOwnerInfo(StarCoinLibrary.Data storage self, uint _node, uint _amount, address _buyer, address _seller, uint _price) {
146 		//--------------------------------------_buyer
147 		self.StockOwnersBuyPrice[_buyer][_node].sumPriceAmount += _amount*_price;
148 		self.StockOwnersBuyPrice[_buyer][_node].sumDateAmount += _amount*block.timestamp;
149 		self.StockOwnersBuyPrice[_buyer][_node].sumAmount += _amount;
150 		uint16 _thisNode = 0;
151 			for (uint16 i6 = 0; i6 < self.stockOwnerInfo[_buyer].nodes.length; i6++) {
152 				if (self.stockOwnerInfo[_buyer].nodes[i6] == _node) _thisNode = 1;
153 			}
154 			if (_thisNode == 0) self.stockOwnerInfo[_buyer].nodes.push(_node);
155 		//--------------------------------------_seller
156 		if(self.StockOwnersBuyPrice[_seller][_node].sumPriceAmount > 0) {
157 			self.StockOwnersBuyPrice[_seller][_node].sumPriceAmount -= _amount*_price;
158 			self.StockOwnersBuyPrice[_buyer][_node].sumDateAmount -= _amount*block.timestamp;
159 			self.StockOwnersBuyPrice[_buyer][_node].sumAmount -= _amount;
160 		}
161 		_thisNode = 0;
162 		for (i6 = 0; i6 < self.stockOwnerInfo[_seller].nodes.length; i6++) {
163 			if (self.stockOwnerInfo[_seller].nodes[i6] == _node) _thisNode = i6;
164 		}
165 		if (_thisNode > 0) {
166 			for (uint ii = _thisNode; ii < self.stockOwnerInfo[msg.sender].nodes.length - 1; ii++) {
167 				self.stockOwnerInfo[msg.sender].nodes[ii] = self.stockOwnerInfo[msg.sender].nodes[ii + 1];
168 			}
169 			delete self.stockOwnerInfo[msg.sender].nodes[self.stockOwnerInfo[msg.sender].nodes.length - 1];
170 		}
171 	}
172 	
173 	function deleteStockBuyOrder(StarCoinLibrary.Data storage self, uint _iii, uint _node, uint _price) {
174 		for (uint ii = _iii; ii < self.stockBuyOrders[_node][_price].length - 1; ii++) {
175 			self.stockBuyOrders[_node][_price][ii] = self.stockBuyOrders[_node][_price][ii + 1];
176 		}
177 		delete self.stockBuyOrders[_node][_price][self.stockBuyOrders[_node][_price].length - 1];
178 		self.stockBuyOrders[_node][_price].length--;
179 		//Delete _price from stockBuyOrderPrices[_node][] if it's the last order
180 		if (self.stockBuyOrders[_node][_price].length == 0) {
181 			uint _fromArg = 99999;
182 			for (_iii = 0; _iii < self.stockBuyOrderPrices[_node].length - 1; _iii++) {
183 				if (self.stockBuyOrderPrices[_node][_iii] == _price) {
184 					_fromArg = _iii;
185 				}
186 				if (_fromArg != 99999 && _iii >= _fromArg) self.stockBuyOrderPrices[_node][_iii] = self.stockBuyOrderPrices[_node][_iii + 1];
187 			}
188 			delete self.stockBuyOrderPrices[_node][self.stockBuyOrderPrices[_node].length-1];
189 			self.stockBuyOrderPrices[_node].length--;
190 		}
191 	}
192 	
193 	function deleteStockSellOrder(StarCoinLibrary.Data storage self, uint _iii, uint _node, uint _price) {
194 		for (uint ii = _iii; ii < self.stockSellOrders[_node][_price].length - 1; ii++) {
195 			self.stockSellOrders[_node][_price][ii] = self.stockSellOrders[_node][_price][ii + 1];
196 		}
197 		delete self.stockSellOrders[_node][_price][self.stockSellOrders[_node][_price].length - 1];
198 		self.stockSellOrders[_node][_price].length--;
199 		//Delete _price from stockSellOrderPrices[_node][] if it's the last order
200 		if (self.stockSellOrders[_node][_price].length == 0) {
201 			uint _fromArg = 99999;
202 			for (_iii = 0; _iii < self.stockSellOrderPrices[_node].length - 1; _iii++) {
203 				if (self.stockSellOrderPrices[_node][_iii] == _price) {
204 					_fromArg = _iii;
205 				}
206 				if (_fromArg != 99999 && _iii >= _fromArg) self.stockSellOrderPrices[_node][_iii] = self.stockSellOrderPrices[_node][_iii + 1];
207 			}
208 			delete self.stockSellOrderPrices[_node][self.stockSellOrderPrices[_node].length-1];
209 			self.stockSellOrderPrices[_node].length--;
210 		}
211 	}
212 }
213 
214 
215 library StarCoinLibrary {
216 	struct Data {
217 		uint256 lastMint;
218 		mapping (address => uint256) balanceOf;
219 		mapping (address => uint256) frozen;
220 		uint32 ordersId;
221 		mapping (uint256 => orderInfo[]) buyOrders;
222 		mapping (uint256 => orderInfo[]) sellOrders;
223 		mapping (address => mapping (uint => uint)) stockBalanceOf;
224 		mapping (address => mapping (uint => uint)) stockFrozen;
225 		mapping (uint => uint)  emissionLimits;
226 		uint32 stockOrdersId;
227 		mapping (uint => emissionNodeInfo) emissions;
228 		mapping (uint => mapping (uint256 => stockOrderInfo[])) stockBuyOrders;
229 		mapping (uint => mapping (uint256 => stockOrderInfo[])) stockSellOrders;
230 		mapping (address => mapping (uint => uint)) lastDividends;
231 		mapping (address => mapping (uint => averageBuyPrice)) StockOwnersBuyPrice;
232 		mapping (address => ownerInfo) stockOwnerInfo;
233 		uint[] buyOrderPrices;
234 		uint[] sellOrderPrices;
235 		mapping (uint => uint[]) stockBuyOrderPrices;
236 		mapping (uint => uint[]) stockSellOrderPrices;
237 		mapping (address => uint) pendingWithdrawals;
238 	}
239 	struct orderInfo {
240 		uint date;
241 		address client;
242 		uint256 amount;
243 		uint256 price;
244 		bool isBuyer;
245 		uint orderId;
246     }
247 	struct emissionNodeInfo {
248 		uint emissionNumber;
249 		uint date;
250 	}
251 	struct stockOrderInfo {
252 		uint date;
253 		address client;
254 		uint256 amount;
255 		uint256 price;
256 		bool isBuyer;
257 		uint orderId;
258 		uint node;
259     }
260 	struct averageBuyPrice {
261         uint sumPriceAmount;
262 		uint sumDateAmount;
263 		uint sumAmount;
264     }
265 	struct ownerInfo {
266 		uint index;
267 		uint[] nodes;
268     }
269 	
270 	event Transfer(address indexed from, address indexed to, uint256 value);
271 	event TradeHistory(uint date, address buyer, address seller, uint price, uint amount, uint orderId);
272     
273     function buyOrder(Data storage self, uint256 _buyPrice) returns (uint[4] _results) {
274 		uint _remainingValue = msg.value;
275 		uint256[4] memory it;
276 		if (minSellPrice(self, _buyPrice) != _buyPrice + 1) {
277 			it[3] = self.sellOrderPrices.length;
278 			for (it[1] = 0; it[1] < it[3]; it[1]++) {
279 				uint _minPrice = minSellPrice(self, _buyPrice);
280 				it[2] = self.sellOrders[_minPrice].length;
281 				for (it[0] = 0; it[0] < it[2]; it[0]++) {
282 					uint _amount = _remainingValue/_minPrice;
283 					if (_amount >= self.sellOrders[_minPrice][0].amount) {
284 						//buy starcoins for ether
285 						self.balanceOf[msg.sender] += self.sellOrders[_minPrice][0].amount;// adds the amount to buyer's balance
286 						self.frozen[self.sellOrders[_minPrice][0].client] -= self.sellOrders[_minPrice][0].amount;// subtracts the amount from seller's frozen balance
287 						Transfer(self.sellOrders[_minPrice][0].client, msg.sender, self.sellOrders[_minPrice][0].amount);
288 						//transfer ether to seller
289 						uint256 amountTransfer = _minPrice*self.sellOrders[_minPrice][0].amount;
290 						self.pendingWithdrawals[self.sellOrders[_minPrice][0].client] += amountTransfer;
291 						//save the transaction
292 						TradeHistory(block.timestamp, msg.sender, self.sellOrders[_minPrice][0].client, _minPrice, self.sellOrders[_minPrice][0].amount, 
293 						self.sellOrders[_minPrice][0].orderId);
294 						_remainingValue -= amountTransfer;
295 						_results[0] += self.sellOrders[_minPrice][0].amount;
296 						//delete sellOrders[_minPrice][0] and move each element
297 						deleteFirstOrder(self, _minPrice, true);
298 						if (_remainingValue/_minPrice < 1) break;
299 					}
300 					else {
301 						//edit sellOrders[_minPrice][0]
302 						self.sellOrders[_minPrice][0].amount = self.sellOrders[_minPrice][0].amount - _amount;
303 						//buy starcoins for ether
304 						self.balanceOf[msg.sender] += _amount;// adds the _amount to buyer's balance
305 						self.frozen[self.sellOrders[_minPrice][0].client] -= _amount;// subtracts the _amount from seller's frozen balance
306 						Transfer(self.sellOrders[_minPrice][0].client, msg.sender, _amount);
307 						//save the transaction
308 						TradeHistory(block.timestamp, msg.sender, self.sellOrders[_minPrice][0].client, _minPrice, _amount, self.sellOrders[_minPrice][0].orderId);
309 						//transfer ether to seller
310 						uint256 amountTransfer1 = _amount*_minPrice;
311 						self.pendingWithdrawals[self.sellOrders[_minPrice][0].client] += amountTransfer1;
312 						_remainingValue -= amountTransfer1;
313 						_results[0] += _amount;
314 						if(_remainingValue/_minPrice < 1) {
315 							_results[3] = 1;
316 							break;
317 						}
318 					}
319 				}
320 				if (_remainingValue/_minPrice < 1) {
321 					_results[3] = 1;
322 					break;
323 				}
324 			}
325 			if(_remainingValue/_buyPrice < 1) 
326 				self.pendingWithdrawals[msg.sender] += _remainingValue;//returns change to buyer
327 		}
328 		if (minSellPrice(self, _buyPrice) == _buyPrice + 1 && _remainingValue/_buyPrice >= 1) {
329 			//save new order
330 			_results[1] =  _remainingValue/_buyPrice;
331 			if (_remainingValue - _results[1]*_buyPrice > 0) 
332 				self.pendingWithdrawals[msg.sender] += _remainingValue - _results[1]*_buyPrice;//returns change to buyer
333 			self.ordersId += 1;
334 			_results[2] = self.ordersId;
335 			self.buyOrders[_buyPrice].push(orderInfo( block.timestamp, msg.sender, _results[1], _buyPrice, true, self.ordersId));
336 		    _results[3] = 1;
337 			//Add _buyPrice to buyOrderPrices[]
338 			it[0] = 99999;
339 			for (it[1] = 0; it[1] < self.buyOrderPrices.length; it[1]++) {
340 				if (self.buyOrderPrices[it[1]] == _buyPrice) 
341 					it[0] = it[1];
342 			}
343 			if (it[0] == 99999) 
344 				self.buyOrderPrices.push(_buyPrice);
345 		}
346 	}
347 	
348 	function minSellPrice(Data storage self, uint _buyPrice) constant returns (uint _minSellPrice) {
349 		_minSellPrice = _buyPrice + 1;
350 		for (uint i = 0; i < self.sellOrderPrices.length; i++) {
351 			if(self.sellOrderPrices[i] < _minSellPrice) _minSellPrice = self.sellOrderPrices[i];
352 		}
353 	}
354 	
355 	function sellOrder(Data storage self, uint256 _sellPrice, uint _amount) returns (uint[4] _results) {
356 		uint _remainingAmount = _amount;
357 		require(self.balanceOf[msg.sender] >= _amount);
358 		uint256[4] memory it;
359 		if (maxBuyPrice(self, _sellPrice) != _sellPrice - 1) {
360 			it[3] = self.buyOrderPrices.length;
361 			for (it[1] = 0; it[1] < it[3]; it[1]++) {
362 				uint _maxPrice = maxBuyPrice(self, _sellPrice);
363 				it[2] = self.buyOrders[_maxPrice].length;
364 				for (it[0] = 0; it[0] < it[2]; it[0]++) {
365 					if (_remainingAmount >= self.buyOrders[_maxPrice][0].amount) {
366 						//sell starcoins for ether
367 						self.balanceOf[msg.sender] -= self.buyOrders[_maxPrice][0].amount;// subtracts amount from seller's balance
368 						self.balanceOf[self.buyOrders[_maxPrice][0].client] += self.buyOrders[_maxPrice][0].amount;// adds the amount to buyer's balance
369 						Transfer(msg.sender, self.buyOrders[_maxPrice][0].client, self.buyOrders[_maxPrice][0].amount);
370 						//transfer ether to seller
371 						uint _amountTransfer = _maxPrice*self.buyOrders[_maxPrice][0].amount;
372 						self.pendingWithdrawals[msg.sender] += _amountTransfer;
373 						//save the transaction
374 						TradeHistory(block.timestamp, self.buyOrders[_maxPrice][0].client, msg.sender, _maxPrice, self.buyOrders[_maxPrice][0].amount, 
375 						self.buyOrders[_maxPrice][0].orderId);
376 						_remainingAmount -= self.buyOrders[_maxPrice][0].amount;
377 						_results[0] += self.buyOrders[_maxPrice][0].amount;
378 						//delete buyOrders[_maxPrice][0] and move each element
379 						deleteFirstOrder(self, _maxPrice, false);
380 						if(_remainingAmount < 1) break;
381 					}
382 					else {
383 						//edit buyOrders[_maxPrice][0]
384 						self.buyOrders[_maxPrice][0].amount = self.buyOrders[_maxPrice][0].amount-_remainingAmount;
385 						//buy starcoins for ether
386 						self.balanceOf[msg.sender] -= _remainingAmount;// subtracts amount from seller's balance
387 						self.balanceOf[self.buyOrders[_maxPrice][0].client] += _remainingAmount;// adds the amount to buyer's balance 
388 						Transfer(msg.sender, self.buyOrders[_maxPrice][0].client, _remainingAmount);
389 						//save the transaction
390 						TradeHistory(block.timestamp, self.buyOrders[_maxPrice][0].client, msg.sender, _maxPrice, _remainingAmount, self.buyOrders[_maxPrice][0].orderId);
391 						//transfer ether to seller
392 						uint256 amountTransfer1 = _maxPrice*_remainingAmount;
393 						self.pendingWithdrawals[msg.sender] += amountTransfer1;
394 						_results[0] += _remainingAmount;
395 						_remainingAmount = 0;
396 						break;
397 					}
398 				}
399 				if (_remainingAmount<1) {
400 					_results[3] = 1;
401 					break;
402 				}
403 			}
404 		}
405 		if (maxBuyPrice(self, _sellPrice) == _sellPrice - 1 && _remainingAmount >= 1) {
406 			//save new order
407 			_results[1] =  _remainingAmount;
408 			self.ordersId += 1;
409 			_results[2] = self.ordersId;
410 			self.sellOrders[_sellPrice].push(orderInfo( block.timestamp, msg.sender, _results[1], _sellPrice, false, _results[2]));
411 		    _results[3] = 1;
412 			//transfer starcoins to the frozen balance
413 			self.frozen[msg.sender] += _remainingAmount;
414 			self.balanceOf[msg.sender] -= _remainingAmount;
415 			//Add _sellPrice to sellOrderPrices[]
416 			it[0] = 99999;
417 			for (it[1] = 0; it[1] < self.sellOrderPrices.length; it[1]++) {
418 				if (self.sellOrderPrices[it[1]] == _sellPrice) 
419 					it[0] = it[1];
420 			}
421 			if (it[0] == 99999) 
422 				self.sellOrderPrices.push(_sellPrice);
423 		}
424 	}
425 	
426 	function maxBuyPrice (Data storage self, uint _sellPrice) constant returns (uint _maxBuyPrice) {
427 		_maxBuyPrice = _sellPrice - 1;
428 		for (uint i = 0; i < self.buyOrderPrices.length; i++) {
429 			if(self.buyOrderPrices[i] > _maxBuyPrice) _maxBuyPrice = self.buyOrderPrices[i];
430 		}
431 	}
432 	
433 	function deleteFirstOrder(Data storage self, uint _price, bool _isSellOrders) {
434 		if (_isSellOrders == true) uint _length = self.sellOrders[_price].length;
435 		else _length = self.buyOrders[_price].length;
436 		for (uint ii = 0; ii < _length - 1; ii++) {
437 			if (_isSellOrders == true) self.sellOrders[_price][ii] = self.sellOrders[_price][ii + 1];
438 			else self.buyOrders[_price][ii] = self.buyOrders[_price][ii+1];
439 		}
440 		if (_isSellOrders == true) {
441 			delete self.sellOrders[_price][self.sellOrders[_price].length - 1];
442 			self.sellOrders[_price].length--;
443 			//Delete _price from sellOrderPrices[] if it's the last order
444 			if (_length == 1) {
445 				uint _fromArg = 99999;
446 				for (uint8 iii = 0; iii < self.sellOrderPrices.length - 1; iii++) {
447 					if (self.sellOrderPrices[iii] == _price) {
448 						_fromArg = iii;
449 					}
450 					if (_fromArg != 99999 && iii >= _fromArg) self.sellOrderPrices[iii] = self.sellOrderPrices[iii + 1];
451 				}
452 				delete self.sellOrderPrices[self.sellOrderPrices.length-1];
453 				self.sellOrderPrices.length--;
454 			}
455 		}
456 		else {
457 			delete self.buyOrders[_price][self.buyOrders[_price].length - 1];
458 			self.buyOrders[_price].length--;
459 			//Delete _price from buyOrderPrices[] if it's the last order
460 			if (_length == 1) {
461 				_fromArg = 99999;
462 				for (iii = 0; iii < self.buyOrderPrices.length - 1; iii++) {
463 					if (self.buyOrderPrices[iii] == _price) {
464 						_fromArg = iii;
465 					}
466 					if (_fromArg != 99999 && iii >= _fromArg) self.buyOrderPrices[iii] = self.buyOrderPrices[iii + 1];
467 				}
468 				delete self.buyOrderPrices[self.buyOrderPrices.length-1];
469 				self.buyOrderPrices.length--;
470 			}
471 		}
472 	}
473 	
474 	function cancelBuyOrder(Data storage self, uint _thisOrderID, uint _price) public returns(bool) {
475 		for (uint8 iii = 0; iii < self.buyOrders[_price].length; iii++) {
476 			if (self.buyOrders[_price][iii].orderId == _thisOrderID) {
477 				//delete buyOrders[_price][iii] and move each element
478 				require(msg.sender == self.buyOrders[_price][iii].client);
479 				uint _remainingValue = self.buyOrders[_price][iii].price*self.buyOrders[_price][iii].amount;
480 				for (uint ii = iii; ii < self.buyOrders[_price].length - 1; ii++) {
481 					self.buyOrders[_price][ii] = self.buyOrders[_price][ii + 1];
482 				}
483 				delete self.buyOrders[_price][self.buyOrders[_price].length - 1];
484 				self.buyOrders[_price].length--;
485 				self.pendingWithdrawals[msg.sender] += _remainingValue;//returns ether to buyer
486 				break;
487 			}
488 		}
489 		//Delete _price from buyOrderPrices[] if it's the last order
490 		if (self.buyOrders[_price].length == 0) {
491 				uint _fromArg = 99999;
492 				for (uint8 iiii = 0; iiii < self.buyOrderPrices.length - 1; iiii++) {
493 					if (self.buyOrderPrices[iiii] == _price) {
494 						_fromArg = iiii;
495 					}
496 					if (_fromArg != 99999 && iiii >= _fromArg) self.buyOrderPrices[iiii] = self.buyOrderPrices[iiii + 1];
497 				}
498 				delete self.buyOrderPrices[self.buyOrderPrices.length-1];
499 				self.buyOrderPrices.length--;
500 		}
501 		return true;
502 	}
503 	
504 	function cancelSellOrder(Data storage self, uint _thisOrderID, uint _price) public returns(bool) {
505 		for (uint8 iii = 0; iii < self.sellOrders[_price].length; iii++) {
506 			if (self.sellOrders[_price][iii].orderId == _thisOrderID) {
507 				require(msg.sender == self.sellOrders[_price][iii].client);
508 				//return starcoins from the frozen balance to seller
509 				self.frozen[msg.sender] -= self.sellOrders[_price][iii].amount;
510 				self.balanceOf[msg.sender] += self.sellOrders[_price][iii].amount;
511 				//delete sellOrders[_price][iii] and move each element
512 				for (uint ii = iii; ii < self.sellOrders[_price].length - 1; ii++) {
513 					self.sellOrders[_price][ii] = self.sellOrders[_price][ii + 1];
514 				}
515 				delete self.sellOrders[_price][self.sellOrders[_price].length - 1];
516 				self.sellOrders[_price].length--;
517 				break;
518 			}
519 		}
520 		//Delete _price from sellOrderPrices[] if it's the last order
521 		if (self.sellOrders[_price].length == 0) {
522 				uint _fromArg = 99999;
523 				for (uint8 iiii = 0; iiii < self.sellOrderPrices.length - 1; iiii++) {
524 					if (self.sellOrderPrices[iiii] == _price) {
525 						_fromArg = iiii;
526 					}
527 					if (_fromArg != 99999 && iiii >= _fromArg) 
528 						self.sellOrderPrices[iiii] = self.sellOrderPrices[iiii + 1];
529 				}
530 				delete self.sellOrderPrices[self.sellOrderPrices.length-1];
531 				self.sellOrderPrices.length--;
532 		}
533 		return true;
534 	}
535 }
536 
537 
538 library StarmidLibrary {
539 	event Transfer(address indexed from, address indexed to, uint256 value);
540 	event StockTransfer(address indexed from, address indexed to, uint indexed node, uint256 value);
541 	event StockTradeHistory(uint node, uint date, address buyer, address seller, uint price, uint amount, uint orderId);
542     
543 	function stockBuyOrder(StarCoinLibrary.Data storage self, uint _node, uint256 _buyPrice, uint _amount) public returns (uint[4] _results) {
544 		require(self.balanceOf[msg.sender] >= _buyPrice*_amount);
545 		uint256[4] memory it;
546 		if (CommonLibrary.stockMinSellPrice(self, _buyPrice, _node) != _buyPrice + 1) {
547 			it[3] = self.stockSellOrderPrices[_node].length;
548 			for (it[1] = 0; it[1] < it[3]; it[1]++) {
549 				uint minPrice = CommonLibrary.stockMinSellPrice(self, _buyPrice, _node);
550 				it[2] = self.stockSellOrders[_node][minPrice].length;
551 				for (it[0] = 0; it[0] < it[2]; it[0]++) {
552 					if (_amount >= self.stockSellOrders[_node][minPrice][0].amount) {
553 						//buy stocks for starcoins
554 						self.stockBalanceOf[msg.sender][_node] += self.stockSellOrders[_node][minPrice][0].amount;// add the amount to buyer's balance
555 						self.stockFrozen[self.stockSellOrders[_node][minPrice][0].client][_node] -= self.stockSellOrders[_node][minPrice][0].amount;// subtracts amount from seller's frozen stock balance
556 						//write stockOwnerInfo and stockOwners for dividends
557 						CommonLibrary.stockSaveOwnerInfo(self, _node, self.stockSellOrders[_node][minPrice][0].amount, msg.sender, self.stockSellOrders[_node][minPrice][0].client, minPrice);
558 						//transfer starcoins to seller
559 						self.balanceOf[msg.sender] -= self.stockSellOrders[_node][minPrice][0].amount*minPrice;// subtracts amount from buyer's balance
560 						self.balanceOf[self.stockSellOrders[_node][minPrice][0].client] += self.stockSellOrders[_node][minPrice][0].amount*minPrice;// adds the amount to seller's balance
561 						Transfer(self.stockSellOrders[_node][minPrice][0].client, msg.sender, self.stockSellOrders[_node][minPrice][0].amount*minPrice);
562 						//save the transaction into event StocksTradeHistory;
563 						StockTradeHistory(_node, block.timestamp, msg.sender, self.stockSellOrders[_node][minPrice][0].client, minPrice, 
564 						self.stockSellOrders[_node][minPrice][0].amount, self.stockSellOrders[_node][minPrice][0].orderId);
565 						_amount -= self.stockSellOrders[_node][minPrice][0].amount;
566 						_results[0] += self.stockSellOrders[_node][minPrice][0].amount;
567 						//delete stockSellOrders[_node][minPrice][0] and move each element
568 						CommonLibrary.stockDeleteFirstOrder(self, _node, minPrice, true);
569 						if (_amount<1) break;
570 					}
571 					else {
572 						//edit stockSellOrders[_node][minPrice][0]
573 						self.stockSellOrders[_node][minPrice][0].amount -= _amount;
574 						//buy stocks for starcoins
575 						self.stockBalanceOf[msg.sender][_node] += _amount;// adds the _amount to buyer's balance
576 						self.stockFrozen[self.stockSellOrders[_node][minPrice][0].client][_node] -= _amount;// subtracts _amount from seller's frozen stock balance
577 						//write stockOwnerInfo and stockOwners for dividends
578 					    CommonLibrary.stockSaveOwnerInfo(self, _node, _amount, msg.sender, self.stockSellOrders[_node][minPrice][0].client, minPrice);
579 						//transfer starcoins to seller
580 						self.balanceOf[msg.sender] -= _amount*minPrice;// subtracts _amount from buyer's balance
581 						self.balanceOf[self.stockSellOrders[_node][minPrice][0].client] += _amount*minPrice;// adds the amount to seller's balance
582 						Transfer(self.stockSellOrders[_node][minPrice][0].client, msg.sender, _amount*minPrice);
583 						//save the transaction  into event StocksTradeHistory;
584 						StockTradeHistory(_node, block.timestamp, msg.sender, self.stockSellOrders[_node][minPrice][0].client, minPrice, 
585 						_amount, self.stockSellOrders[_node][minPrice][0].orderId);
586 						_results[0] += _amount;
587 						_amount = 0;
588 						break;
589 					}
590 				}
591 				if(_amount < 1) {
592 					_results[3] = 1;
593 					break;
594 				}
595 		   	}
596 		}
597 		if (CommonLibrary.stockMinSellPrice(self, _buyPrice, _node) == _buyPrice + 1 && _amount >= 1) {
598 			//save new order
599 			_results[1] =  _amount;
600 			self.stockOrdersId += 1;
601 			_results[2] = self.stockOrdersId;
602 			self.stockBuyOrders[_node][_buyPrice].push(StarCoinLibrary.stockOrderInfo(block.timestamp, msg.sender, _results[1], _buyPrice, true, self.stockOrdersId, _node));
603 		    _results[3] = 1;
604 			//transfer starcoins to the frozen balance
605 			self.frozen[msg.sender] += _amount*_buyPrice;
606 			self.balanceOf[msg.sender] -= _amount*_buyPrice;
607 			//Add _buyPrice to stockBuyOrderPrices[_node][]
608 			it[0] = 99999;
609 			for (it[1] = 0; it[1] < self.stockBuyOrderPrices[_node].length; it[1]++) {
610 				if (self.stockBuyOrderPrices[_node][it[1]] == _buyPrice) 
611 					it[0] = it[1];
612 			}
613 			if (it[0] == 99999) self.stockBuyOrderPrices[_node].push(_buyPrice);
614 		}
615 	}
616 	
617 	function stockSellOrder(StarCoinLibrary.Data storage self, uint _node, uint _sellPrice, uint _amount) returns (uint[4] _results) {
618 		require(self.stockBalanceOf[msg.sender][_node] >= _amount);
619 		uint[4] memory it;
620 		if (CommonLibrary.stockMaxBuyPrice(self, _sellPrice, _node) != _sellPrice - 1) {
621 			it[3] = self.stockBuyOrderPrices[_node].length;
622 			for (it[1] = 0; it[1] < it[3]; it[1]++) {
623 				uint _maxPrice = CommonLibrary.stockMaxBuyPrice(self, _sellPrice, _node);
624 				it[2] = self.stockBuyOrders[_node][_maxPrice].length;
625 				for (it[0] = 0; it[0] < it[2]; it[0]++) {
626 					if (_amount >= self.stockBuyOrders[_node][_maxPrice][0].amount) {
627 						//sell stocks for starcoins
628 						self.stockBalanceOf[msg.sender][_node] -= self.stockBuyOrders[_node][_maxPrice][0].amount;// subtracts the _amount from seller's balance 
629 						self.stockBalanceOf[self.stockBuyOrders[_node][_maxPrice][0].client][_node] += self.stockBuyOrders[_node][_maxPrice][0].amount;// adds the _amount to buyer's balance
630 						//write stockOwnerInfo and stockOwners for dividends
631 						CommonLibrary.stockSaveOwnerInfo(self, _node, self.stockBuyOrders[_node][_maxPrice][0].amount, self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, _maxPrice);
632 						//transfer starcoins to seller
633 						self.balanceOf[msg.sender] += self.stockBuyOrders[_node][_maxPrice][0].amount*_maxPrice;// adds the amount to buyer's balance 
634 						self.frozen[self.stockBuyOrders[_node][_maxPrice][0].client] -= self.stockBuyOrders[_node][_maxPrice][0].amount*_maxPrice;// subtracts amount from seller's frozen balance
635 						Transfer(self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, self.stockBuyOrders[_node][_maxPrice][0].amount*_maxPrice);
636 						//save the transaction
637 						StockTradeHistory(_node, block.timestamp, self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, 
638 						_maxPrice, self.stockBuyOrders[_node][_maxPrice][0].amount, self.stockBuyOrders[_node][_maxPrice][0].orderId);
639 						_amount -= self.stockBuyOrders[_node][_maxPrice][0].amount;
640 						_results[0] += self.stockBuyOrders[_node][_maxPrice][0].amount;
641 						//delete stockBuyOrders[_node][_maxPrice][0] and move each element
642 						CommonLibrary.stockDeleteFirstOrder(self, _node, _maxPrice, false);
643 						if(_amount < 1) break;
644 					}
645 					else {
646 						//edit stockBuyOrders[_node][_maxPrice][0]
647 						self.stockBuyOrders[_node][_maxPrice][0].amount -= _amount;
648 						//sell stocks for starcoins
649 						self.stockBalanceOf[msg.sender][_node] -= _amount;// subtracts _amount from seller's balance 
650 						self.stockBalanceOf[self.stockBuyOrders[_node][_maxPrice][0].client][_node] += _amount;// adds the _amount to buyer's balance
651 						//write stockOwnerInfo and stockOwners for dividends
652 						CommonLibrary.stockSaveOwnerInfo(self, _node, _amount, self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, _maxPrice);
653 						//transfer starcoins to seller
654 						self.balanceOf[msg.sender] += _amount*_maxPrice;// adds the _amount to buyer's balance 
655 						self.frozen[self.stockBuyOrders[_node][_maxPrice][0].client] -= _amount*_maxPrice;// subtracts _amount from seller's frozen balance
656 						Transfer(self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, _amount*_maxPrice);
657 						//save the transaction
658 						StockTradeHistory(_node, block.timestamp, self.stockBuyOrders[_node][_maxPrice][0].client, msg.sender, 
659 						_maxPrice, _amount, self.stockBuyOrders[_node][_maxPrice][0].orderId);
660 						_results[0] += _amount;
661 						_amount = 0;
662 						break;
663 					}
664 				}
665 				if (_amount < 1) {
666 					_results[3] = 1;
667 					break;
668 				}
669 			}
670 		}
671 		if (CommonLibrary.stockMaxBuyPrice(self, _sellPrice, _node) == _sellPrice - 1 && _amount >= 1) {
672 			//save new order
673 			_results[1] =  _amount;
674 			self.stockOrdersId += 1;
675 			_results[2] = self.stockOrdersId;
676 			self.stockSellOrders[_node][_sellPrice].push(StarCoinLibrary.stockOrderInfo(block.timestamp, msg.sender, _results[1], _sellPrice, false, self.stockOrdersId, _node));
677 		    _results[3] = 1;
678 			//transfer stocks to the frozen stock balance
679 			self.stockFrozen[msg.sender][_node] += _amount;
680 			self.stockBalanceOf[msg.sender][_node] -= _amount;
681 			//Add _sellPrice to stockSellOrderPrices[_node][]
682 			it[0] = 99999;
683 			for (it[1] = 0; it[1] < self.stockSellOrderPrices[_node].length; it[1]++) {
684 				if (self.stockSellOrderPrices[_node][it[1]] == _sellPrice) 
685 					it[0] = it[1];
686 			}
687 			if (it[0] == 99999) 
688 				self.stockSellOrderPrices[_node].push(_sellPrice);
689 		}
690 	}
691 	
692 	function stockCancelBuyOrder(StarCoinLibrary.Data storage self, uint _node, uint _thisOrderID, uint _price) public returns(bool) {
693 		for (uint iii = 0; iii < self.stockBuyOrders[_node][_price].length; iii++) {
694 			if (self.stockBuyOrders[_node][_price][iii].orderId == _thisOrderID) {
695 				require(msg.sender == self.stockBuyOrders[_node][_price][iii].client);
696 				//return starcoins from the buyer`s frozen balance
697 				self.frozen[msg.sender] -= self.stockBuyOrders[_node][_price][iii].amount*_price;
698 				self.balanceOf[msg.sender] += self.stockBuyOrders[_node][_price][iii].amount*_price;
699 				//delete stockBuyOrders[_node][_price][iii] and move each element
700 				for (uint ii = iii; ii < self.stockBuyOrders[_node][_price].length - 1; ii++) {
701 					self.stockBuyOrders[_node][_price][ii] = self.stockBuyOrders[_node][_price][ii + 1];
702 				}
703 				delete self.stockBuyOrders[_node][_price][self.stockBuyOrders[_node][_price].length - 1];
704 				self.stockBuyOrders[_node][_price].length--;
705 				break;
706 			}
707 		}
708 		//Delete _price from stockBuyOrderPrices[_node][] if it's the last order
709 		if (self.stockBuyOrders[_node][_price].length == 0) {
710 			uint _fromArg = 99999;
711 			for (iii = 0; iii < self.stockBuyOrderPrices[_node].length - 1; iii++) {
712 				if (self.stockBuyOrderPrices[_node][iii] == _price) {
713 					_fromArg = iii;
714 				}
715 				if (_fromArg != 99999 && iii >= _fromArg) self.stockBuyOrderPrices[_node][iii] = self.stockBuyOrderPrices[_node][iii + 1];
716 			}
717 			delete self.stockBuyOrderPrices[_node][self.stockBuyOrderPrices[_node].length-1];
718 			self.stockBuyOrderPrices[_node].length--;
719 		}
720 		return true;
721 	}
722 	
723 	function stockCancelSellOrder(StarCoinLibrary.Data storage self, uint _node, uint _thisOrderID, uint _price) public returns(bool) {
724 		for (uint iii = 0; iii < self.stockSellOrders[_node][_price].length; iii++) {
725 			if (self.stockSellOrders[_node][_price][iii].orderId == _thisOrderID) {
726 				require(msg.sender == self.stockSellOrders[_node][_price][iii].client);
727 				//return stocks from the seller`s frozen stock balance
728 				self.stockFrozen[msg.sender][_node] -= self.stockSellOrders[_node][_price][iii].amount;
729 				self.stockBalanceOf[msg.sender][_node] += self.stockSellOrders[_node][_price][iii].amount;
730 				//delete stockSellOrders[_node][_price][iii] and move each element
731 				for (uint ii = iii; ii < self.stockSellOrders[_node][_price].length - 1; ii++) {
732 					self.stockSellOrders[_node][_price][ii] = self.stockSellOrders[_node][_price][ii + 1];
733 				}
734 				delete self.stockSellOrders[_node][_price][self.stockSellOrders[_node][_price].length - 1];
735 				self.stockSellOrders[_node][_price].length--;
736 				break;
737 			}
738 		}
739 		//Delete _price from stockSellOrderPrices[_node][] if it's the last order
740 		if (self.stockSellOrders[_node][_price].length == 0) {
741 			uint _fromArg = 99999;
742 			for (iii = 0; iii < self.stockSellOrderPrices[_node].length - 1; iii++) {
743 				if (self.stockSellOrderPrices[_node][iii] == _price) {
744 					_fromArg = iii;
745 				}
746 				if (_fromArg != 99999 && iii >= _fromArg) self.stockSellOrderPrices[_node][iii] = self.stockSellOrderPrices[_node][iii + 1];
747 			}
748 			delete self.stockSellOrderPrices[_node][self.stockSellOrderPrices[_node].length-1];
749 			self.stockSellOrderPrices[_node].length--;
750 		}
751 		return true;
752 	}
753 }
754 
755 
756 library StarmidLibraryExtra {
757 	event Transfer(address indexed from, address indexed to, uint256 value);
758 	event StockTransfer(address indexed from, address indexed to, uint indexed node, uint256 value);
759 	event StockTradeHistory(uint node, uint date, address buyer, address seller, uint price, uint amount, uint orderId);
760 	event TradeHistory(uint date, address buyer, address seller, uint price, uint amount, uint orderId);
761 	
762 	function buyCertainOrder(StarCoinLibrary.Data storage self, uint _price, uint _thisOrderID) returns (bool) {
763 		uint _remainingValue = msg.value;
764 		for (uint8 iii = 0; iii < self.sellOrders[_price].length; iii++) {
765 			if (self.sellOrders[_price][iii].orderId == _thisOrderID) {
766 				uint _amount = _remainingValue/_price;
767 				require(_amount <= self.sellOrders[_price][iii].amount);
768 				if (_amount == self.sellOrders[_price][iii].amount) {
769 					//buy starcoins for ether
770 					self.balanceOf[msg.sender] += self.sellOrders[_price][iii].amount;// adds the amount to buyer's balance
771 					self.frozen[self.sellOrders[_price][iii].client] -= self.sellOrders[_price][iii].amount;// subtracts the amount from seller's frozen balance
772 					Transfer(self.sellOrders[_price][iii].client, msg.sender, self.sellOrders[_price][iii].amount);
773 					//transfer ether to seller
774 					self.pendingWithdrawals[self.sellOrders[_price][iii].client] += _price*self.sellOrders[_price][iii].amount;
775 					//save the transaction
776 					TradeHistory(block.timestamp, msg.sender, self.sellOrders[_price][iii].client, _price, self.sellOrders[_price][iii].amount, 
777 					self.sellOrders[_price][iii].orderId);
778 					_remainingValue -= _price*self.sellOrders[_price][iii].amount;
779 					//delete sellOrders[_price][iii] and move each element
780 					for (uint ii = iii; ii < self.sellOrders[_price].length - 1; ii++) {
781 						self.sellOrders[_price][ii] = self.sellOrders[_price][ii + 1];
782 					}
783 					delete self.sellOrders[_price][self.sellOrders[_price].length - 1];
784 					self.sellOrders[_price].length--;
785 					//Delete _price from sellOrderPrices[] if it's the last order
786 					if (self.sellOrders[_price].length == 0) {
787 						uint fromArg = 99999;
788 						for (ii = 0; ii < self.sellOrderPrices.length - 1; ii++) {
789 							if (self.sellOrderPrices[ii] == _price) {
790 								fromArg = ii;
791 							}
792 							if (fromArg != 99999 && ii >= fromArg) 
793 								self.sellOrderPrices[ii] = self.sellOrderPrices[ii + 1];
794 						}
795 						delete self.sellOrderPrices[self.sellOrderPrices.length-1];
796 						self.sellOrderPrices.length--;
797 					}
798 					return true;
799 					break;
800 				}
801 				else {
802 					//edit sellOrders[_price][iii]
803 					self.sellOrders[_price][iii].amount = self.sellOrders[_price][iii].amount - _amount;
804 					//buy starcoins for ether
805 					self.balanceOf[msg.sender] += _amount;// adds the _amount to buyer's balance
806 					self.frozen[self.sellOrders[_price][iii].client] -= _amount;// subtracts the _amount from seller's frozen balance
807 					Transfer(self.sellOrders[_price][iii].client, msg.sender, _amount);
808 					//save the transaction
809 					TradeHistory(block.timestamp, msg.sender, self.sellOrders[_price][iii].client, _price, _amount, self.sellOrders[_price][iii].orderId);
810 					//transfer ether to seller
811 					self.pendingWithdrawals[self.sellOrders[_price][iii].client] += _amount*_price;
812 					_remainingValue -= _amount*_price;
813 					return true;
814 					break;
815 				}
816 			}
817 		}
818 		self.pendingWithdrawals[msg.sender] += _remainingValue;//returns change to buyer				
819 	}
820 	
821 	function sellCertainOrder(StarCoinLibrary.Data storage self, uint _amount, uint _price, uint _thisOrderID) returns (bool) {
822 		for (uint8 iii = 0; iii < self.buyOrders[_price].length; iii++) {
823 			if (self.buyOrders[_price][iii].orderId == _thisOrderID) {
824 				require(_amount <= self.buyOrders[_price][iii].amount && self.balanceOf[msg.sender] >= _amount);
825 				if (_amount == self.buyOrders[_price][iii].amount) {
826 					//sell starcoins for ether
827 					self.balanceOf[msg.sender] -= self.buyOrders[_price][iii].amount;// subtracts amount from seller's balance
828 					self.balanceOf[self.buyOrders[_price][iii].client] += self.buyOrders[_price][iii].amount;// adds the amount to buyer's balance
829 					Transfer(msg.sender, self.buyOrders[_price][iii].client, self.buyOrders[_price][iii].amount);
830 					//transfer ether to seller
831 					uint _amountTransfer = _price*self.buyOrders[_price][iii].amount;
832 					self.pendingWithdrawals[msg.sender] += _amountTransfer;
833 					//save the transaction
834 					TradeHistory(block.timestamp, self.buyOrders[_price][iii].client, msg.sender, _price, self.buyOrders[_price][iii].amount, 
835 					self.buyOrders[_price][iii].orderId);
836 					_amount -= self.buyOrders[_price][iii].amount;
837 					//delete buyOrders[_price][iii] and move each element
838 					for (uint ii = iii; ii < self.buyOrders[_price].length - 1; ii++) {
839 						self.buyOrders[_price][ii] = self.buyOrders[_price][ii + 1];
840 					}
841 					delete self.buyOrders[_price][self.buyOrders[_price].length - 1];
842 					self.buyOrders[_price].length--;
843 					//Delete _price from buyOrderPrices[] if it's the last order
844 					if (self.buyOrders[_price].length == 0) {
845 						uint _fromArg = 99999;
846 						for (uint8 iiii = 0; iiii < self.buyOrderPrices.length - 1; iiii++) {
847 							if (self.buyOrderPrices[iiii] == _price) {
848 								_fromArg = iiii;
849 							}
850 							if (_fromArg != 99999 && iiii >= _fromArg) self.buyOrderPrices[iiii] = self.buyOrderPrices[iiii + 1];
851 						}
852 						delete self.buyOrderPrices[self.buyOrderPrices.length-1];
853 						self.buyOrderPrices.length--;
854 					}
855 					return true;
856 					break;
857 				}
858 				else {
859 					//edit buyOrders[_price][iii]
860 					self.buyOrders[_price][iii].amount = self.buyOrders[_price][iii].amount - _amount;
861 					//buy starcoins for ether
862 					self.balanceOf[msg.sender] -= _amount;// subtracts amount from seller's balance
863 					self.balanceOf[self.buyOrders[_price][iii].client] += _amount;// adds the amount to buyer's balance 
864 					Transfer(msg.sender, self.buyOrders[_price][iii].client, _amount);
865 					//save the transaction
866 					TradeHistory(block.timestamp, self.buyOrders[_price][iii].client, msg.sender, _price, _amount, self.buyOrders[_price][iii].orderId);
867 					//transfer ether to seller
868 					self.pendingWithdrawals[msg.sender] += _price*_amount;
869 					return true;
870 					break;
871 				}
872 			}	
873 		}
874 	}
875 	
876 	function stockBuyCertainOrder(StarCoinLibrary.Data storage self, uint _node, uint _price, uint _amount, uint _thisOrderID) returns (bool) {
877 		require(self.balanceOf[msg.sender] >= _price*_amount);
878 		for (uint8 iii = 0; iii < self.stockSellOrders[_node][_price].length; iii++) {
879 			if (self.stockSellOrders[_node][_price][iii].orderId == _thisOrderID) {
880 				require(_amount <= self.stockSellOrders[_node][_price][iii].amount);
881 				if (_amount == self.stockSellOrders[_node][_price][iii].amount) {
882 					//buy stocks for starcoins
883 					self.stockBalanceOf[msg.sender][_node] += self.stockSellOrders[_node][_price][iii].amount;// add the amount to buyer's balance
884 					self.stockFrozen[self.stockSellOrders[_node][_price][iii].client][_node] -= self.stockSellOrders[_node][_price][iii].amount;// subtracts amount from seller's frozen stock balance
885 					//write stockOwnerInfo and stockOwners for dividends
886 					CommonLibrary.stockSaveOwnerInfo(self, _node, self.stockSellOrders[_node][_price][iii].amount, msg.sender, self.stockSellOrders[_node][_price][iii].client, _price);
887 					//transfer starcoins to seller
888 					self.balanceOf[msg.sender] -= self.stockSellOrders[_node][_price][iii].amount*_price;// subtracts amount from buyer's balance
889 					self.balanceOf[self.stockSellOrders[_node][_price][iii].client] += self.stockSellOrders[_node][_price][iii].amount*_price;// adds the amount to seller's balance
890 					Transfer(self.stockSellOrders[_node][_price][iii].client, msg.sender, self.stockSellOrders[_node][_price][iii].amount*_price);
891 					//save the transaction into event StocksTradeHistory;
892 					StockTradeHistory(_node, block.timestamp, msg.sender, self.stockSellOrders[_node][_price][iii].client, _price, 
893 					self.stockSellOrders[_node][_price][iii].amount, self.stockSellOrders[_node][_price][iii].orderId);
894 					_amount -= self.stockSellOrders[_node][_price][iii].amount;
895 					//delete stockSellOrders[_node][_price][iii] and move each element
896 					CommonLibrary.deleteStockSellOrder(self, iii, _node, _price);
897 					return true;
898 					break;
899 				}
900 				else {
901 					//edit stockSellOrders[_node][_price][iii]
902 					self.stockSellOrders[_node][_price][iii].amount -= _amount;
903 					//buy stocks for starcoins
904 					self.stockBalanceOf[msg.sender][_node] += _amount;// adds the amount to buyer's balance
905 					self.stockFrozen[self.stockSellOrders[_node][_price][iii].client][_node] -= _amount;// subtracts amount from seller's frozen stock balance
906 					//write stockOwnerInfo and stockOwners for dividends
907 					CommonLibrary.stockSaveOwnerInfo(self, _node, _amount, msg.sender, self.stockSellOrders[_node][_price][iii].client, _price);
908 					//transfer starcoins to seller
909 					self.balanceOf[msg.sender] -= _amount*_price;// subtracts amount from buyer's balance
910 					self.balanceOf[self.stockSellOrders[_node][_price][iii].client] += _amount*_price;// adds the amount to seller's balance
911 					Transfer(self.stockSellOrders[_node][_price][iii].client, msg.sender, _amount*_price);
912 					//save the transaction  into event StocksTradeHistory;
913 					StockTradeHistory(_node, block.timestamp, msg.sender, self.stockSellOrders[_node][_price][iii].client, _price, 
914 					_amount, self.stockSellOrders[_node][_price][iii].orderId);
915 					_amount = 0;
916 					return true;
917 					break;
918 				}
919 			}
920 		}
921 	}
922 	
923 	function stockSellCertainOrder(StarCoinLibrary.Data storage self, uint _node, uint _price, uint _amount, uint _thisOrderID) returns (bool results) {
924 		uint _remainingAmount = _amount;
925 		for (uint8 iii = 0; iii < self.stockBuyOrders[_node][_price].length; iii++) {
926 			if (self.stockBuyOrders[_node][_price][iii].orderId == _thisOrderID) {
927 				require(_amount <= self.stockBuyOrders[_node][_price][iii].amount && self.stockBalanceOf[msg.sender][_node] >= _amount);
928 				if (_remainingAmount == self.stockBuyOrders[_node][_price][iii].amount) {
929 					//sell stocks for starcoins
930 					self.stockBalanceOf[msg.sender][_node] -= self.stockBuyOrders[_node][_price][iii].amount;// subtracts amount from seller's balance 
931 					self.stockBalanceOf[self.stockBuyOrders[_node][_price][iii].client][_node] += self.stockBuyOrders[_node][_price][iii].amount;// adds the amount to buyer's balance
932 					//write stockOwnerInfo and stockOwners for dividends
933 					CommonLibrary.stockSaveOwnerInfo(self, _node, self.stockBuyOrders[_node][_price][iii].amount, self.stockBuyOrders[_node][_price][iii].client, msg.sender, _price);
934 					//transfer starcoins to seller
935 					self.balanceOf[msg.sender] += self.stockBuyOrders[_node][_price][iii].amount*_price;// adds the amount to buyer's balance 
936 					self.frozen[self.stockBuyOrders[_node][_price][iii].client] -= self.stockBuyOrders[_node][_price][iii].amount*_price;// subtracts amount from seller's frozen balance
937 					Transfer(self.stockBuyOrders[_node][_price][iii].client, msg.sender, self.stockBuyOrders[_node][_price][iii].amount*_price);
938 					//save the transaction
939 					StockTradeHistory(_node, block.timestamp, self.stockBuyOrders[_node][_price][iii].client, msg.sender, 
940 					_price, self.stockBuyOrders[_node][_price][iii].amount, self.stockBuyOrders[_node][_price][iii].orderId);
941 					_amount -= self.stockBuyOrders[_node][_price][iii].amount;
942 					//delete stockBuyOrders[_node][_price][iii] and move each element
943 					CommonLibrary.deleteStockBuyOrder(self, iii, _node, _price);
944 					results = true;
945 					break;
946 				}
947 				else {
948 					//edit stockBuyOrders[_node][_price][0]
949 					self.stockBuyOrders[_node][_price][iii].amount -= _amount;
950 					//sell stocks for starcoins
951 					self.stockBalanceOf[msg.sender][_node] -= _amount;// subtracts amount from seller's balance 
952 					self.stockBalanceOf[self.stockBuyOrders[_node][_price][iii].client][_node] += _amount;// adds the amount to buyer's balance
953 					//write stockOwnerInfo and stockOwners for dividends
954 					CommonLibrary.stockSaveOwnerInfo(self, _node, _amount, self.stockBuyOrders[_node][_price][iii].client, msg.sender, _price);
955 					//transfer starcoins to seller
956 					self.balanceOf[msg.sender] += _amount*_price;// adds the amount to buyer's balance 
957 					self.frozen[self.stockBuyOrders[_node][_price][iii].client] -= _amount*_price;// subtracts amount from seller's frozen balance
958 					Transfer(self.stockBuyOrders[_node][_price][iii].client, msg.sender, _amount*_price);
959 					//save the transaction
960 					StockTradeHistory(_node, block.timestamp, self.stockBuyOrders[_node][_price][iii].client, msg.sender, 
961 					_price, _amount, self.stockBuyOrders[_node][_price][iii].orderId);
962 					_amount = 0;
963 					results = true;
964 					break;
965 				}
966 			}	
967 		}
968 	}	
969 }
970 
971 
972 contract Nodes {
973 	address public owner;
974 	CommonLibrary.Data public vars;
975 	mapping (address => string) public confirmationNodes;
976 	uint confirmNodeId;
977 	uint40 changePercentId;
978 	uint40 pushNodeGroupId;
979 	uint40 deleteNodeGroupId;
980 	event NewNode(
981 		uint256 id, 
982 		string nodeName, 
983 		uint8 producersPercent, 
984 		address producer, 
985 		uint date
986 		);
987 	event OwnerNotation(uint256 id, uint date, string newNotation);
988 	event NewNodeGroup(uint16 id, string newNodeGroup);
989 	event AddNodeAddress(uint id, uint nodeID, address nodeAdress);
990 	event EditNode(
991 		uint nodeID,
992 		address nodeAdress, 
993 		address newProducer, 
994 		uint8 newProducersPercent,
995 		bool starmidConfirmed
996 		);
997 	event ConfirmNode(uint id, uint nodeID);
998 	event OutsourceConfirmNode(uint nodeID, address confirmationNode);
999 	event ChangePercent(uint id, uint nodeId, uint producersPercent);
1000 	event PushNodeGroup(uint id, uint nodeId, uint newNodeGroup);
1001 	event DeleteNodeGroup(uint id, uint nodeId, uint deleteNodeGroup);
1002 	
1003 	function Nodes() public {
1004 		owner = msg.sender;
1005 	}
1006 	
1007 	modifier onlyOwner {
1008 		require(msg.sender == owner);
1009 		_;
1010 	}
1011 	
1012 	//-----------------------------------------------------Nodes---------------------------------------------------------------
1013 	function changeOwner(string _changeOwnerPassword, address _newOwnerAddress) onlyOwner returns(bool) {
1014 		//One-time tool for emergency owner change
1015 		if (keccak256(_changeOwnerPassword) == 0xe17a112b6fc12fc80c9b241de72da0d27ce7e244100f3c4e9358162a11bed629) {
1016 			owner = _newOwnerAddress;
1017 			return true;
1018 		}
1019 		else 
1020 			return false;
1021 	}
1022 	
1023 	function addOwnerNotations(string _newNotation) onlyOwner {
1024 		uint date = block.timestamp;
1025 		vars.ownerNotationId += 1;
1026 		OwnerNotation(vars.ownerNotationId, date, _newNotation);
1027 	}
1028 	
1029 	function addConfirmationNode(string _newConfirmationNode) public returns(bool) {
1030 		confirmationNodes[msg.sender] = _newConfirmationNode;
1031 		return true;
1032 	}
1033 	
1034 	function addNodeGroup(string _newNodeGroup) onlyOwner returns(uint16 _id) {
1035 		bool result;
1036 		(result, _id) = CommonLibrary.addNodeGroup(vars, _newNodeGroup);
1037 		require(result);
1038 		NewNodeGroup(_id, _newNodeGroup);
1039 	}
1040 	
1041 	function addNode(string _newNode, uint8 _producersPercent) returns(bool) {
1042 		bool result;
1043 		uint _id;
1044 		(result, _id) = CommonLibrary.addNode(vars, _newNode, _producersPercent);
1045 		require(result);
1046 		NewNode(_id, _newNode, _producersPercent, msg.sender, block.timestamp);
1047 		return true;
1048 	}
1049 	
1050 	function editNode(
1051 		uint _nodeID, 
1052 		address _nodeAddress, 
1053 		bool _isNewProducer, 
1054 		address _newProducer, 
1055 		uint8 _newProducersPercent,
1056 		bool _starmidConfirmed
1057 		) onlyOwner returns(bool) {
1058 		bool x = CommonLibrary.editNode(vars, _nodeID, _nodeAddress,_isNewProducer, _newProducer, _newProducersPercent, _starmidConfirmed);
1059 		require(x);
1060 		EditNode(_nodeID, _nodeAddress, _newProducer, _newProducersPercent, _starmidConfirmed);
1061 		return true;
1062 	}
1063 	
1064 	
1065 	function addNodeAddress(uint _nodeID, address _nodeAddress) public returns(bool) {
1066 		bool _result;
1067 		uint _id;
1068 		(_result, _id) = CommonLibrary.addNodeAddress(vars, _nodeID, _nodeAddress);
1069 		require(_result);
1070 		AddNodeAddress(_id, _nodeID, _nodeAddress);
1071 		return true; 
1072 	}
1073 	
1074 	function pushNodeGroup(uint _nodeID, uint16 _newNodeGroup) public returns(bool) {
1075 		require(msg.sender == vars.nodes[_nodeID].node);
1076 		vars.nodes[_nodeID].nodeGroup.push(_newNodeGroup);
1077 		pushNodeGroupId += 1;
1078 		PushNodeGroup(pushNodeGroupId, _nodeID, _newNodeGroup);
1079 		return true;
1080 	}
1081 	
1082 	function deleteNodeGroup(uint _nodeID, uint16 _deleteNodeGroup) public returns(bool) {
1083 		require(msg.sender == vars.nodes[_nodeID].node);
1084 		for(uint16 i = 0; i < vars.nodes[_nodeID].nodeGroup.length; i++) {
1085 			if(_deleteNodeGroup == vars.nodes[_nodeID].nodeGroup[i]) {
1086 				for(uint16 ii = i; ii < vars.nodes[_nodeID].nodeGroup.length - 1; ii++) 
1087 					vars.nodes[_nodeID].nodeGroup[ii] = vars.nodes[_nodeID].nodeGroup[ii + 1];
1088 		    	delete vars.nodes[_nodeID].nodeGroup[vars.nodes[_nodeID].nodeGroup.length - 1];
1089 				vars.nodes[_nodeID].nodeGroup.length--;
1090 				break;
1091 		    }
1092 	    }
1093 		deleteNodeGroupId += 1;
1094 		DeleteNodeGroup(deleteNodeGroupId, _nodeID, _deleteNodeGroup);
1095 		return true;
1096     }
1097 	
1098 	function confirmNode(uint _nodeID) onlyOwner returns(bool) {
1099 		vars.nodes[_nodeID].starmidConfirmed = true;
1100 		confirmNodeId += 1;
1101 		ConfirmNode(confirmNodeId, _nodeID);
1102 		return true;
1103 	}
1104 	
1105 	function outsourceConfirmNode(uint _nodeID) public returns(bool) {
1106 		vars.nodes[_nodeID].outsourceConfirmed.push(msg.sender);
1107 		OutsourceConfirmNode(_nodeID, msg.sender);
1108 		return true;
1109 	}
1110 	
1111 	function changePercent(uint _nodeId, uint8 _producersPercent) public returns(bool){
1112 		if(msg.sender == vars.nodes[_nodeId].producer && vars.nodes[_nodeId].node == 0x0000000000000000000000000000000000000000) {
1113 			vars.nodes[_nodeId].producersPercent = _producersPercent;
1114 			changePercentId += 1;
1115 			ChangePercent(changePercentId, _nodeId, _producersPercent);
1116 			return true;
1117 		}
1118 	}
1119 	
1120 	function getNodeInfo(uint _nodeID) constant public returns(
1121 		address _producer, 
1122 		address _node, 
1123 		uint _date, 
1124 		bool _starmidConfirmed, 
1125 		string _nodeName, 
1126 		address[] _outsourceConfirmed, 
1127 		uint16[] _nodeGroup, 
1128 		uint _producersPercent
1129 		) {
1130 		_producer = vars.nodes[_nodeID].producer;
1131 		_node = vars.nodes[_nodeID].node;
1132 		_date = vars.nodes[_nodeID].date;
1133 		_starmidConfirmed = vars.nodes[_nodeID].starmidConfirmed;
1134 		_nodeName = vars.nodes[_nodeID].nodeName;
1135 		_outsourceConfirmed = vars.nodes[_nodeID].outsourceConfirmed;
1136 		_nodeGroup = vars.nodes[_nodeID].nodeGroup;
1137 		_producersPercent = vars.nodes[_nodeID].producersPercent;
1138 	}
1139 }	
1140 
1141 
1142 contract Starmid {
1143 	address public owner;
1144 	Nodes public nodesVars;
1145 	string public name;
1146 	string public symbol;
1147 	uint8 public decimals;
1148 	uint256 public totalSupply;
1149 	StarCoinLibrary.Data public sCVars;
1150 	
1151 	event Transfer(address indexed from, address indexed to, uint256 value);
1152 	event BuyOrder(address indexed from, uint orderId, uint buyPrice);
1153 	event SellOrder(address indexed from, uint orderId, uint sellPrice);
1154 	event CancelBuyOrder(address indexed from, uint indexed orderId, uint price);
1155 	event CancelSellOrder(address indexed from, uint indexed orderId, uint price);
1156 	event TradeHistory(uint date, address buyer, address seller, uint price, uint amount, uint orderId);
1157     //----------------------------------------------------Starmid exchange
1158 	event StockTransfer(address indexed from, address indexed to, uint indexed node, uint256 value);
1159 	event StockBuyOrder(uint node, uint buyPrice);
1160 	event StockSellOrder(uint node, uint sellPrice);
1161 	event StockCancelBuyOrder(uint node, uint price);
1162 	event StockCancelSellOrder(uint node, uint price);
1163 	event StockTradeHistory(uint node, uint date, address buyer, address seller, uint price, uint amount, uint orderId);
1164 	
1165 	function Starmid(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
1166 		owner = 0x378B9eea7ab9C15d9818EAdDe1156A079Cd02ba8;
1167 		totalSupply = initialSupply;  
1168 		sCVars.balanceOf[msg.sender] = 5000000000;
1169 		sCVars.balanceOf[0x378B9eea7ab9C15d9818EAdDe1156A079Cd02ba8] = initialSupply - 5000000000;                
1170 		name = tokenName;                                   
1171 		symbol = tokenSymbol;                               
1172 		decimals = decimalUnits; 
1173 		sCVars.lastMint = block.timestamp;
1174 		sCVars.emissionLimits[1] = 500000; sCVars.emissionLimits[2] = 500000; sCVars.emissionLimits[3] = 500000;
1175 		sCVars.emissionLimits[4] = 500000; sCVars.emissionLimits[5] = 500000; sCVars.emissionLimits[6] = 500000;
1176 	}
1177 	
1178 	modifier onlyOwner {
1179 		require(msg.sender == owner);
1180 		_;
1181 	}
1182 	//-----------------------------------------------------StarCoin Exchange------------------------------------------------------
1183 	function getWithdrawal() constant public returns(uint _amount) {
1184         _amount = sCVars.pendingWithdrawals[msg.sender];
1185     }
1186 	
1187 	function withdraw() public returns(bool _result, uint _amount) {
1188         _amount = sCVars.pendingWithdrawals[msg.sender];
1189         sCVars.pendingWithdrawals[msg.sender] = 0;
1190         msg.sender.transfer(_amount);
1191 		_result = true;
1192     }
1193 	
1194 	function changeOwner(string _changeOwnerPassword, address _newOwnerAddress) onlyOwner returns(bool) {
1195 		//One-time tool for emergency owner change
1196 		if (keccak256(_changeOwnerPassword) == 0xe17a112b6fc12fc80c9b241de72da0d27ce7e244100f3c4e9358162a11bed629) {
1197 			owner = _newOwnerAddress;
1198 			return true;
1199 		}
1200 		else 
1201 			return false;
1202 	}
1203 	
1204 	function setNodesVars(address _addr) public {
1205 	    require(msg.sender == 0xfCbA69eF1D63b0A4CcD9ceCeA429157bA48d6a9c);
1206 		nodesVars = Nodes(_addr);
1207 	}
1208 	
1209 	function balanceOf(address _address) constant public returns(uint _balance) {
1210 		_balance = sCVars.balanceOf[_address];
1211 	}
1212 	
1213 	function getBuyOrderPrices() constant public returns(uint[] _prices) {
1214 		_prices = sCVars.buyOrderPrices;
1215 	}
1216 	
1217 	function getSellOrderPrices() constant public returns(uint[] _prices) {
1218 		_prices = sCVars.sellOrderPrices;
1219 	}
1220 	
1221 	function getOrderInfo(bool _isBuyOrder, uint _price, uint _number) constant public returns(address _address, uint _amount, uint _orderId) {
1222 		if(_isBuyOrder == true) {
1223 			_address = sCVars.buyOrders[_price][_number].client;
1224 			_amount = sCVars.buyOrders[_price][_number].amount;
1225 			_orderId = sCVars.buyOrders[_price][_number].orderId;
1226 		}
1227 		else {
1228 			_address = sCVars.sellOrders[_price][_number].client;
1229 			_amount = sCVars.sellOrders[_price][_number].amount;
1230 			_orderId = sCVars.sellOrders[_price][_number].orderId;
1231 		}
1232 	}
1233 	
1234 	function transfer(address _to, uint256 _value) public returns (bool _result) {
1235 		_transfer(msg.sender, _to, _value);
1236 		_result = true;
1237 	}
1238 	
1239 	function mint() public onlyOwner returns(uint _mintedAmount) {
1240 		//Minted amount does not exceed 8,5% per annum. Thus, minting does not greatly increase the total supply 
1241 		//and does not cause significant inflation and depreciation of the starcoin.
1242 		_mintedAmount = (block.timestamp - sCVars.lastMint)*totalSupply/(12*31536000);//31536000 seconds in year
1243 		sCVars.balanceOf[msg.sender] += _mintedAmount;
1244 		totalSupply += _mintedAmount;
1245 		sCVars.lastMint = block.timestamp;
1246 		Transfer(0, this, _mintedAmount);
1247 		Transfer(this, msg.sender, _mintedAmount);
1248 	}
1249 	
1250 	function buyOrder(uint256 _buyPrice) payable public returns (uint[4] _results) {
1251 		require(_buyPrice > 0 && msg.value > 0);
1252 		_results = StarCoinLibrary.buyOrder(sCVars, _buyPrice);
1253 		require(_results[3] == 1);
1254 		BuyOrder(msg.sender, _results[2], _buyPrice);
1255 	}
1256 	
1257 	function sellOrder(uint256 _sellPrice, uint _amount) public returns (uint[4] _results) {
1258 		require(_sellPrice > 0 && _amount > 0);
1259 		_results = StarCoinLibrary.sellOrder(sCVars, _sellPrice, _amount);
1260 		require(_results[3] == 1);
1261 		SellOrder(msg.sender, _results[2], _sellPrice);
1262 	}
1263 	
1264 	function cancelBuyOrder(uint _thisOrderID, uint _price) public {
1265 		require(StarCoinLibrary.cancelBuyOrder(sCVars, _thisOrderID, _price));
1266 		CancelBuyOrder(msg.sender, _thisOrderID, _price);
1267 	}
1268 	
1269 	function cancelSellOrder(uint _thisOrderID, uint _price) public {
1270 		require(StarCoinLibrary.cancelSellOrder(sCVars, _thisOrderID, _price));
1271 		CancelSellOrder(msg.sender, _thisOrderID, _price);
1272 	}
1273 	
1274 	function _transfer(address _from, address _to, uint _value) internal {
1275 		require(_to != 0x0);
1276         require(sCVars.balanceOf[_from] >= _value && sCVars.balanceOf[_to] + _value > sCVars.balanceOf[_to]);
1277         sCVars.balanceOf[_from] -= _value;
1278         sCVars.balanceOf[_to] += _value;
1279         Transfer(_from, _to, _value);
1280 	}
1281 	
1282 	function buyCertainOrder(uint _price, uint _thisOrderID) payable public returns (bool _results) {
1283 		_results = StarmidLibraryExtra.buyCertainOrder(sCVars, _price, _thisOrderID);
1284 		require(_results && msg.value > 0);
1285 		BuyOrder(msg.sender, _thisOrderID, _price);
1286 	}
1287 	
1288 	function sellCertainOrder(uint _amount, uint _price, uint _thisOrderID) public returns (bool _results) {
1289 		_results = StarmidLibraryExtra.sellCertainOrder(sCVars, _amount, _price, _thisOrderID);
1290 		require(_results && _amount > 0);
1291 		SellOrder(msg.sender, _thisOrderID, _price);
1292 	}
1293 	//------------------------------------------------------Starmid exchange----------------------------------------------------------
1294 	function stockTransfer(address _to, uint _node, uint _value) public {
1295 		require(_to != 0x0);
1296         require(sCVars.stockBalanceOf[msg.sender][_node] >= _value && sCVars.stockBalanceOf[_to][_node] + _value > sCVars.stockBalanceOf[_to][_node]);
1297 		var (x,y,) = nodesVars.getNodeInfo(_node);
1298 		require(msg.sender != y);//nodeOwner cannot transfer his stocks, only sell
1299 		sCVars.stockBalanceOf[msg.sender][_node] -= _value;
1300         sCVars.stockBalanceOf[_to][_node] += _value;
1301         StockTransfer(msg.sender, _to, _node, _value);
1302 	}
1303 	
1304 	function getEmission(uint _node) constant public returns(uint _emissionNumber, uint _emissionDate, uint _emissionAmount) {
1305 		_emissionNumber = sCVars.emissions[_node].emissionNumber;
1306 		_emissionDate = sCVars.emissions[_node].date;
1307 		_emissionAmount = sCVars.emissionLimits[_emissionNumber];
1308 	}
1309 	
1310 	function emission(uint _node) public returns(bool _result, uint _emissionNumber, uint _emissionAmount, uint _producersPercent) {
1311 		var (x,y,,,,,,z,) = nodesVars.getNodeInfo(_node);
1312 		address _nodeOwner = y;
1313 		address _nodeProducer = x;
1314 		_producersPercent = z;
1315 		require(msg.sender == _nodeOwner || msg.sender == _nodeProducer);
1316 		uint allStocks;
1317 		for (uint i = 1; i <= sCVars.emissions[_node].emissionNumber; i++) {
1318 			allStocks += sCVars.emissionLimits[i];
1319 		}
1320 		if (_nodeOwner !=0x0000000000000000000000000000000000000000 && block.timestamp > sCVars.emissions[_node].date + 5184000 && 
1321 		sCVars.stockBalanceOf[_nodeOwner][_node] <= allStocks/2 ) {
1322 			_emissionNumber = sCVars.emissions[_node].emissionNumber + 1;
1323 			sCVars.stockBalanceOf[_nodeOwner][_node] += sCVars.emissionLimits[_emissionNumber]*(100 - _producersPercent)/100;
1324 			//save stockOwnerInfo for _nodeOwner
1325 			uint thisNode = 0;
1326 			for (i = 0; i < sCVars.stockOwnerInfo[_nodeOwner].nodes.length; i++) {
1327 				if (sCVars.stockOwnerInfo[_nodeOwner].nodes[i] == _node) thisNode = 1;
1328 			}
1329 			if (thisNode == 0) sCVars.stockOwnerInfo[_nodeOwner].nodes.push(_node);
1330 			sCVars.stockBalanceOf[_nodeProducer][_node] += sCVars.emissionLimits[_emissionNumber]*_producersPercent/100;
1331 			//save stockOwnerInfo for _nodeProducer
1332 			thisNode = 0;
1333 			for (i = 0; i < sCVars.stockOwnerInfo[_nodeProducer].nodes.length; i++) {
1334 				if (sCVars.stockOwnerInfo[_nodeProducer].nodes[i] == _node) thisNode = 1;
1335 			}
1336 			if (thisNode == 0) sCVars.stockOwnerInfo[_nodeProducer].nodes.push(_node);
1337 			sCVars.emissions[_node].date = block.timestamp;
1338 			sCVars.emissions[_node].emissionNumber = _emissionNumber;
1339 			_emissionAmount = sCVars.emissionLimits[_emissionNumber];
1340 			_result = true;
1341 		}
1342 		else _result = false;
1343 	}
1344 	
1345 	function getStockOwnerInfo(address _address) constant public returns(uint[] _nodes) {
1346 		_nodes = sCVars.stockOwnerInfo[_address].nodes;
1347 	}
1348 	
1349 	function getStockBalance(address _address, uint _node) constant public returns(uint _balance) {
1350 		_balance = sCVars.stockBalanceOf[_address][_node];
1351 	}
1352 	
1353 	function getWithFrozenStockBalance(address _address, uint _node) constant public returns(uint _balance) {
1354 		_balance = sCVars.stockBalanceOf[_address][_node] + sCVars.stockFrozen[_address][_node];
1355 	}
1356 	
1357 	function getStockOrderInfo(bool _isBuyOrder, uint _node, uint _price, uint _number) constant public returns(address _address, uint _amount, uint _orderId) {
1358 		if(_isBuyOrder == true) {
1359 			_address = sCVars.stockBuyOrders[_node][_price][_number].client;
1360 			_amount = sCVars.stockBuyOrders[_node][_price][_number].amount;
1361 			_orderId = sCVars.stockBuyOrders[_node][_price][_number].orderId;
1362 		}
1363 		else {
1364 			_address = sCVars.stockSellOrders[_node][_price][_number].client;
1365 			_amount = sCVars.stockSellOrders[_node][_price][_number].amount;
1366 			_orderId = sCVars.stockSellOrders[_node][_price][_number].orderId;
1367 		}
1368 	}
1369 	
1370 	function getStockBuyOrderPrices(uint _node) constant public returns(uint[] _prices) {
1371 		_prices = sCVars.stockBuyOrderPrices[_node];
1372 	}
1373 	
1374 	function getStockSellOrderPrices(uint _node) constant public returns(uint[] _prices) {
1375 		_prices = sCVars.stockSellOrderPrices[_node];
1376 	}
1377 	
1378 	function stockBuyOrder(uint _node, uint256 _buyPrice, uint _amount) public returns (uint[4] _results) {
1379 		require(_node > 0 && _buyPrice > 0 && _amount > 0);
1380 		_results = StarmidLibrary.stockBuyOrder(sCVars, _node, _buyPrice, _amount);
1381 		require(_results[3] == 1);
1382 		StockBuyOrder(_node, _buyPrice);
1383 	}
1384 	
1385 	function stockSellOrder(uint _node, uint256 _sellPrice, uint _amount) public returns (uint[4] _results) {
1386 		require(_node > 0 && _sellPrice > 0 && _amount > 0);
1387 		_results = StarmidLibrary.stockSellOrder(sCVars, _node, _sellPrice, _amount);
1388 		require(_results[3] == 1);
1389 		StockSellOrder(_node, _sellPrice);
1390 	}
1391 	
1392 	function stockCancelBuyOrder(uint _node, uint _thisOrderID, uint _price) public {
1393 		require(StarmidLibrary.stockCancelBuyOrder(sCVars, _node, _thisOrderID, _price));
1394 		StockCancelBuyOrder(_node, _price);
1395 	}
1396 	
1397 	function stockCancelSellOrder(uint _node, uint _thisOrderID, uint _price) public {
1398 		require(StarmidLibrary.stockCancelSellOrder(sCVars, _node, _thisOrderID, _price));
1399 		StockCancelSellOrder(_node, _price);
1400 	}
1401 	
1402 	function getLastDividends(uint _node) public constant returns (uint _lastDividents, uint _dividends) {
1403 		uint stockAmount = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumAmount;
1404 		uint sumAmount = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumAmount;
1405 		if(sumAmount > 0) {
1406 			uint stockAverageBuyPrice = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumPriceAmount/sumAmount;
1407 			uint dividendsBase = stockAmount*stockAverageBuyPrice;
1408 			_lastDividents = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumDateAmount/sumAmount;
1409 			if(_lastDividents > 0)_dividends = (block.timestamp - _lastDividents)*dividendsBase/(10*31536000);
1410 			else _dividends = 0;
1411 		}
1412 	}
1413 	
1414 	//--------------------------------Dividends (10% to stock owner, 2,5% to node owner per annum)------------------------------------
1415 	function dividends(uint _node) public returns (bool _result, uint _dividends) {
1416 		var (x,y,) = nodesVars.getNodeInfo(_node);
1417 		uint _stockAmount = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumAmount;
1418 		uint _sumAmount = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumAmount;
1419 		if(_sumAmount > 0) {
1420 			uint _stockAverageBuyPrice = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumPriceAmount/_sumAmount;
1421 			uint _dividendsBase = _stockAmount*_stockAverageBuyPrice;
1422 			uint _averageDate = sCVars.StockOwnersBuyPrice[msg.sender][_node].sumDateAmount/_sumAmount;
1423 			//Stock owner`s dividends
1424 			uint _div = (block.timestamp - _averageDate)*_dividendsBase/(10*31536000);//31536000 seconds in year
1425 			sCVars.balanceOf[msg.sender] += _div;
1426 			//Node owner`s dividends
1427 			uint _nodeDividends = (block.timestamp - _averageDate)*_dividendsBase/(40*31536000);//31536000 seconds in year
1428 			sCVars.balanceOf[y] += _nodeDividends;
1429 			sCVars.StockOwnersBuyPrice[msg.sender][_node].sumDateAmount = block.timestamp*_stockAmount;//set new average dividends date
1430 			totalSupply += _div + _div/4;
1431 			_dividends =  _div + _div/4;
1432 			Transfer(this, msg.sender, _div);	
1433 			Transfer(this, y, _div/4);	
1434 			_result = true;
1435 		}
1436 	}
1437 	
1438 	function stockBuyCertainOrder(uint _node, uint _price, uint _amount, uint _thisOrderID) payable public returns (bool _results) {
1439 		_results = StarmidLibraryExtra.stockBuyCertainOrder(sCVars, _node, _price, _amount, _thisOrderID);
1440 		require(_results && _node > 0 && _amount > 0);
1441 		StockBuyOrder(_node, _price);
1442 	}
1443 	
1444 	function stockSellCertainOrder(uint _node, uint _price, uint _amount, uint _thisOrderID) public returns (bool _results) {
1445 		_results = StarmidLibraryExtra.stockSellCertainOrder(sCVars, _node, _price, _amount, _thisOrderID);
1446 		require(_results && _node > 0 && _amount > 0);
1447 		StockSellOrder(_node, _price);
1448 	}
1449 }
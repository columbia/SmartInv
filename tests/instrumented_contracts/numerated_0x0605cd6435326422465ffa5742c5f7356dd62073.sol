1 pragma solidity 0.4.25;
2 
3 
4 contract Nodes {
5 	address public owner;
6 	mapping (uint => Node) public nodes; 
7 	mapping (string => uint) nodesID;
8 	mapping (string => uint16) nodeGroupsId;
9 	mapping (uint16 => string) public nodeGroups;
10 	mapping (address => string) public confirmationNodes;
11 	uint16 public nodeGroupID;
12 	uint public nodeID;
13 	
14 	struct Node {
15 		string nodeName;
16 		address producer;
17 		address node;
18 		uint256 date;
19 		uint8 starmidConfirmed; //0 - not confirmed; 1 - confirmed; 2 - caution
20 		string confirmationPost;
21 		outsourceConfirmStruct[] outsourceConfirmed;
22 		uint16[] nodeGroup;
23 		uint8 producersPercent;
24 	}
25 	
26 	struct outsourceConfirmStruct {
27 		uint8 confirmationStatus;
28 		address confirmationNode;
29 		string confirmationPost;
30 	}
31 	
32 	event NewNode(
33 		uint256 id, 
34 		string nodeName, 
35 		uint8 producersPercent, 
36 		address producer, 
37 		uint date
38 		);
39 	event NewNodeGroup(uint16 id, string newNodeGroup);
40 	event AddNodeAddress(uint nodeID, address nodeAdress);
41 	event EditNode(uint nodeID,	address newProducer, uint8 newProducersPercent);
42 	event ConfirmNode(uint nodeID, uint8 confirmationStatus, string confirmationPost);
43 	event OutsourceConfirmNode(uint nodeID, uint8 confirmationStatus, address confirmationNode, string confirmationPost);
44 	event ChangePercent(uint nodeId, uint producersPercent);
45 	event PushNodeGroup(uint nodeId, uint newNodeGroup);
46 	event DeleteNodeGroup(uint nodeId, uint deleteNodeGroup);
47 	
48 	modifier onlyOwner {
49 		require(msg.sender == owner);
50 		_;
51 	}
52 	
53 	function addConfirmationNode(string _newConfirmationNode) public returns(bool) {
54 		confirmationNodes[msg.sender] = _newConfirmationNode;
55 		return true;
56 	}
57 	
58 	function addNodeGroup(string _newNodeGroup) public onlyOwner returns(bool _result, uint16 _id) {
59 		require (nodeGroupsId[_newNodeGroup] == 0);
60 		_id = nodeGroupID += 1;
61 		nodeGroups[_id] = _newNodeGroup;
62 		nodeGroupsId[_newNodeGroup] = nodeGroupID;
63 		_result = true;
64 		emit NewNodeGroup(_id, _newNodeGroup);
65 	}
66 	
67 	function addNode(string _newNode, uint8 _producersPercent) public returns (bool _result, uint _id) {
68 		require(nodesID[_newNode] < 1 && _producersPercent < 100);
69 		_id = nodeID += 1;
70 		require(nodeID < 1000000000000);
71 		nodes[nodeID].nodeName = _newNode;
72 		nodes[nodeID].producer = msg.sender;
73 		nodes[nodeID].date = block.timestamp;
74 		nodes[nodeID].producersPercent = _producersPercent;
75 		nodesID[_newNode] = nodeID;
76 		emit NewNode(_id, _newNode, _producersPercent, msg.sender, block.timestamp);
77 		_result = true;
78 	}
79 	
80 	function editNode(
81 		uint _nodeID, 
82 		address _newProducer, 
83 		uint8 _newProducersPercent
84 		) public onlyOwner returns (bool) {
85 			nodes[_nodeID].producer = _newProducer;
86 			nodes[_nodeID].producersPercent = _newProducersPercent;
87 			emit EditNode(_nodeID, _newProducer, _newProducersPercent);
88 			return true;
89 	}
90 	
91 	function addNodeAddress(uint _nodeID, address _nodeAddress) public returns(bool _result) {
92 		require(msg.sender == nodes[_nodeID].producer && nodes[_nodeID].node == 0);
93 		nodes[_nodeID].node = _nodeAddress;
94 		emit AddNodeAddress( _nodeID, _nodeAddress);
95 		_result = true;
96 	}
97 	
98 	function pushNodeGroup(uint _nodeID, uint16 _newNodeGroup) public returns(bool) {
99 		require(msg.sender == nodes[_nodeID].node || msg.sender == nodes[_nodeID].producer);
100 		nodes[_nodeID].nodeGroup.push(_newNodeGroup);
101 		emit PushNodeGroup(_nodeID, _newNodeGroup);
102 		return true;
103 	}
104 	
105 	function deleteNodeGroup(uint _nodeID, uint16 _deleteNodeGroup) public returns(bool) {
106 		require(msg.sender == nodes[_nodeID].node  || msg.sender == nodes[_nodeID].producer);
107 		for(uint16 i = 0; i < nodes[_nodeID].nodeGroup.length; i++) {
108 			if(_deleteNodeGroup == nodes[_nodeID].nodeGroup[i]) {
109 				for(uint16 ii = i; ii < nodes[_nodeID].nodeGroup.length - 1; ii++) 
110 					nodes[_nodeID].nodeGroup[ii] = nodes[_nodeID].nodeGroup[ii + 1];
111 		    	delete nodes[_nodeID].nodeGroup[nodes[_nodeID].nodeGroup.length - 1];
112 				nodes[_nodeID].nodeGroup.length--;
113 				break;
114 		    }
115 	    }
116 		emit DeleteNodeGroup(_nodeID, _deleteNodeGroup);
117 		return true;
118     }
119 	
120 	function confirmNode(uint _nodeID, string confirmationPost, uint8 confirmationStatus) public onlyOwner returns(bool) {
121 		nodes[_nodeID].starmidConfirmed = confirmationStatus;
122 		nodes[_nodeID].confirmationPost = confirmationPost;
123 		emit ConfirmNode(_nodeID, confirmationStatus, confirmationPost);
124 		return true;
125 	}
126 	
127 	function outsourceConfirmNode(uint _nodeID, string confirmationPost, uint8 confirmationStatus) public returns(bool) {
128 		nodes[_nodeID].outsourceConfirmed.push(outsourceConfirmStruct(confirmationStatus, msg.sender, confirmationPost));
129 		emit OutsourceConfirmNode(_nodeID, confirmationStatus, msg.sender, confirmationPost);
130 		return true;
131 	}
132 	
133 	function changePercent(uint _nodeId, uint8 _producersPercent) public returns(bool) {
134 		require(msg.sender == nodes[_nodeId].producer && nodes[_nodeId].node == 0x0000000000000000000000000000000000000000);
135 		nodes[_nodeId].producersPercent = _producersPercent;
136 		emit ChangePercent(_nodeId, _producersPercent);
137 		return true;
138 	}
139 	
140 	function getNodeInfo(uint _nodeID) constant public returns(
141 		address _producer, 
142 		address _node, 
143 		uint _date, 
144 		uint8 _starmidConfirmed, 
145 		string _nodeName, 
146 		uint16[] _nodeGroup, 
147 		uint _producersPercent, 
148 		string _confirmationPost
149 		) {
150 		_producer = nodes[_nodeID].producer;
151 		_node = nodes[_nodeID].node;
152 		_date = nodes[_nodeID].date;
153 		_starmidConfirmed = nodes[_nodeID].starmidConfirmed;
154 		_nodeName = nodes[_nodeID].nodeName;
155 		_nodeGroup = nodes[_nodeID].nodeGroup;
156 		_producersPercent = nodes[_nodeID].producersPercent;
157 		_confirmationPost = nodes[_nodeID].confirmationPost;
158 	}
159 	
160 	function getOutsourceConfirmation(uint _nodeID, uint _number) constant public returns(
161 		uint _confirmationStatus, 
162 		address _confirmationNode, 
163 		string _confirmationNodeName, 
164 		string _confirmationPost
165 		) {
166 			_confirmationStatus = nodes[_nodeID].outsourceConfirmed[_number].confirmationStatus;
167 			_confirmationNode = nodes[_nodeID].outsourceConfirmed[_number].confirmationNode;
168 			_confirmationNodeName = confirmationNodes[_confirmationNode];
169 			_confirmationPost = nodes[_nodeID].outsourceConfirmed[_number].confirmationPost;
170 		}
171 }	
172 
173 contract Starmid is Nodes {
174 	uint24 public emissionLimits;
175 	uint8 public feeMultipliedByTen;
176 	mapping (uint => emissionNodeInfo) public emissions;
177 	mapping (address => mapping (uint => uint)) balanceOf;
178 	mapping (address => mapping (uint => uint)) frozen;
179 	uint128 public orderId;
180 	mapping (uint => mapping (uint => orderInfo[])) buyOrders;
181 	mapping (uint => mapping (uint => orderInfo[])) sellOrders;
182 	mapping (uint => uint[]) buyOrderPrices;
183 	mapping (uint => uint[]) sellOrderPrices;
184 	mapping (address => uint) public pendingWithdrawals;
185 	address public multiKey;
186 	
187 	struct orderInfo {
188 		address client;
189 		uint amount;
190 		uint orderId;
191 		uint8 fee;
192     }
193 	struct emissionNodeInfo {
194 		uint emissionNumber;
195 		uint date;
196 	}
197 	
198 	event Emission(uint node, uint date);
199 	event BuyOrder(uint orderId, uint node, uint buyPrice, uint amount);
200 	event SellOrder(uint orderId, uint node, uint sellPrice, uint amount);
201 	event CancelBuyOrder(uint orderId, uint node, uint price);
202 	event CancelSellOrder(uint orderId, uint node, uint price);
203 	event TradeHistory(uint node, uint date, address buyer, address seller, uint price, uint amount, uint orderId);
204 	
205 	constructor() public {
206 		owner = msg.sender;
207 		emissionLimits = 1000000;
208 		feeMultipliedByTen = 20;
209 	}
210 	
211 	//-----------------------------------------------------Starmid Exchange------------------------------------------------------
212 	function withdraw() public returns(bool _result, uint _amount) {
213         _amount = pendingWithdrawals[msg.sender];
214         pendingWithdrawals[msg.sender] = 0;
215         msg.sender.transfer(_amount);
216 		_result = true;
217     }
218 	
219 	function changeOwner(address _newOwnerAddress) public returns(bool) {
220 		require(msg.sender == owner || msg.sender == 0x1335995a62a6769b0a44a8fcc08d9c3324456df0);
221 		if(multiKey == 0x0000000000000000000000000000000000000000)
222 			multiKey = msg.sender;
223 		if(multiKey == owner && msg.sender == 0x1335995a62a6769b0a44a8fcc08d9c3324456df0) {
224 			owner = _newOwnerAddress;
225 			multiKey = 0x0000000000000000000000000000000000000000;
226 			return true;
227 		}
228 		if(multiKey == 0x1335995a62a6769b0a44a8fcc08d9c3324456df0 && msg.sender == owner) {
229 			owner = _newOwnerAddress;
230 			multiKey = 0x0000000000000000000000000000000000000000;
231 			return true;
232 		}
233 	}
234 	
235 	function changeFee(uint8 _newFee) public onlyOwner returns(bool) {
236 		feeMultipliedByTen = _newFee;
237 		return true;
238 	}
239 	
240 	function getEmission(uint _node) constant public returns(uint _emissionNumber, uint _emissionDate) {
241 		_emissionNumber = emissions[_node].emissionNumber;
242 		_emissionDate = emissions[_node].date;
243 	}
244 	
245 	function emission(uint _node) public returns(bool _result, uint _producersPercent) {
246 		address _nodeProducer = nodes[_node].producer;
247 		address _nodeOwner = nodes[_node].node;
248 		_producersPercent = nodes[_node].producersPercent;
249 		require(msg.sender == _nodeOwner || msg.sender == _nodeProducer);
250 		require(_nodeOwner != 0x0000000000000000000000000000000000000000 && emissions[_node].emissionNumber == 0);
251 		balanceOf[_nodeOwner][_node] += emissionLimits*(100 - _producersPercent)/100;
252 		balanceOf[_nodeProducer][_node] += emissionLimits*_producersPercent/100;
253 		emissions[_node].date = block.timestamp;
254 		emissions[_node].emissionNumber = 1;
255 		emit Emission(_node, block.timestamp);
256 		_result = true;
257 	}
258 	
259 	function getStockBalance(address _address, uint _node) constant public returns(uint _balance) {
260 		_balance = balanceOf[_address][_node];
261 	}
262 	
263 	function getWithFrozenStockBalance(address _address, uint _node) constant public returns(uint _balance) {
264 		_balance = balanceOf[_address][_node] + frozen[_address][_node];
265 	}
266 	
267 	function getOrderInfo(bool _isBuyOrder, uint _node, uint _price, uint _number) constant public returns
268 	(address _address, uint _amount, uint _orderId, uint8 _fee) {
269 		if(_isBuyOrder == true) {
270 			_address = buyOrders[_node][_price][_number].client;
271 			_amount = buyOrders[_node][_price][_number].amount;
272 			_orderId = buyOrders[_node][_price][_number].orderId;
273 			_fee = buyOrders[_node][_price][_number].fee;
274 		}
275 		else {
276 			_address = sellOrders[_node][_price][_number].client;
277 			_amount = sellOrders[_node][_price][_number].amount;
278 			_orderId = sellOrders[_node][_price][_number].orderId;
279 		}
280 	}
281 	
282 	function getBuyOrderPrices(uint _node) constant public returns(uint[] _prices) {
283 		_prices = buyOrderPrices[_node];
284 	}
285 	
286 	function getSellOrderPrices(uint _node) constant public returns(uint[] _prices) {
287 		_prices = sellOrderPrices[_node];
288 	}
289 	
290 	function buyOrder(uint _node, uint _buyPrice, uint _amount) payable public returns (bool _result, uint _orderId) {
291 		//check if there is a better price
292 		uint _minSellPrice = _buyPrice + 1;
293 		for (uint i = 0; i < sellOrderPrices[_node].length; i++) {
294 			if(sellOrderPrices[_node][i] < _minSellPrice) 
295 				_minSellPrice = sellOrderPrices[_node][i];
296 		}
297 		require(_node > 0 && _buyPrice > 0 && _amount > 0 && msg.value > 0 && _buyPrice < _minSellPrice);
298 		require(msg.value == _amount*_buyPrice + _amount*_buyPrice*feeMultipliedByTen/1000);
299 		_orderId = orderId += 1;
300 		buyOrders[_node][_buyPrice].push(orderInfo(msg.sender, _amount, _orderId, feeMultipliedByTen));
301 		//Add _buyPrice to buyOrderPrices[_node][]
302 		uint it = 999999;
303 		for (uint itt = 0; itt < buyOrderPrices[_node].length; itt++) {
304 			if (buyOrderPrices[_node][itt] == _buyPrice) 
305 				it = itt;
306 		}
307 		if (it == 999999) 
308 			buyOrderPrices[_node].push(_buyPrice);
309 		_result = true;
310 		emit BuyOrder(orderId, _node, _buyPrice, _amount);
311 	}
312 	
313 	function sellOrder(uint _node, uint _sellPrice, uint _amount) public returns (bool _result, uint _orderId) {
314 		//check if there is a better price
315 		uint _maxBuyPrice = _sellPrice - 1;
316 		for (uint i = 0; i < buyOrderPrices[_node].length; i++) {
317 			if(buyOrderPrices[_node][i] > _maxBuyPrice) 
318 				_maxBuyPrice = buyOrderPrices[_node][i];
319 		}
320 		require(_node > 0 && _sellPrice > 0 && _amount > 0 && balanceOf[msg.sender][_node] >= _amount && _sellPrice > _maxBuyPrice);
321 		_orderId = orderId += 1;
322 		sellOrders[_node][_sellPrice].push(orderInfo(msg.sender, _amount, _orderId, feeMultipliedByTen));
323 		//transfer stocks to the frozen balance
324 		frozen[msg.sender][_node] += _amount;
325 		balanceOf[msg.sender][_node] -= _amount;
326 		//Add _sellPrice to sellOrderPrices[_node][]
327 		uint it = 999999;
328 		for (uint itt = 0; itt < sellOrderPrices[_node].length; itt++) {
329 			if (sellOrderPrices[_node][itt] == _sellPrice) 
330 				it = itt;
331 		}
332 		if (it == 999999) 
333 			sellOrderPrices[_node].push(_sellPrice);
334 		_result = true;
335 		emit SellOrder(orderId, _node, _sellPrice, _amount);
336 	}
337 	
338 	function cancelBuyOrder(uint _node, uint _orderId, uint _price) public returns (bool _result) {
339 		orderInfo[] buyArr = buyOrders[_node][_price];
340 		for (uint iii = 0; iii < buyArr.length; iii++) {
341 			if (buyArr[iii].orderId == _orderId) {
342 				require(msg.sender == buyArr[iii].client);
343 				pendingWithdrawals[msg.sender] += _price*buyArr[iii].amount + _price*buyArr[iii].amount*buyArr[iii].fee/1000;//returns ether and fee to the buyer
344 				//delete buyOrders[_node][_price][iii] and move each element
345 				for (uint ii = iii; ii < buyArr.length - 1; ii++) {
346 					buyArr[ii] = buyArr[ii + 1];
347 				}
348 				delete buyArr[buyArr.length - 1];
349 				buyArr.length--;
350 				break;
351 			}
352 		}
353 		//Delete _price from buyOrderPrices[_node][] if it's the last order
354 		if (buyArr.length == 0) {
355 			uint _fromArg = 99999;
356 			for (iii = 0; iii < buyOrderPrices[_node].length - 1; iii++) {
357 				if (buyOrderPrices[_node][iii] == _price) {
358 					_fromArg = iii;
359 				}
360 				if (_fromArg != 99999 && iii >= _fromArg) buyOrderPrices[_node][iii] = buyOrderPrices[_node][iii + 1];
361 			}
362 			delete buyOrderPrices[_node][buyOrderPrices[_node].length-1];
363 			buyOrderPrices[_node].length--;
364 		}
365 		_result = true;
366 		emit CancelBuyOrder(_orderId, _node, _price);
367 	}
368 	
369 	function cancelSellOrder(uint _node, uint _orderId, uint _price) public returns (bool _result) {
370 		orderInfo[] sellArr = sellOrders[_node][_price];
371 		for (uint iii = 0; iii < sellArr.length; iii++) {
372 			if (sellArr[iii].orderId == _orderId) {
373 				require(msg.sender == sellArr[iii].client);
374 				//return stocks from the frozen balance to seller
375 				frozen[msg.sender][_node] -= sellArr[iii].amount;
376 				balanceOf[msg.sender][_node] += sellArr[iii].amount;
377 				//delete sellOrders[_node][_price][iii] and move each element
378 				for (uint ii = iii; ii < sellArr.length - 1; ii++) {
379 					sellArr[ii] = sellArr[ii + 1];
380 				}
381 				delete sellArr[sellArr.length - 1];
382 				sellArr.length--;
383 				break;
384 			}
385 		}
386 		//Delete _price from sellOrderPrices[_node][] if it's the last order
387 		if (sellArr.length == 0) {
388 			uint _fromArg = 99999;
389 			for (iii = 0; iii < sellOrderPrices[_node].length - 1; iii++) {
390 				if (sellOrderPrices[_node][iii] == _price) {
391 					_fromArg = iii;
392 				}
393 				if (_fromArg != 99999 && iii >= _fromArg) sellOrderPrices[_node][iii] = sellOrderPrices[_node][iii + 1];
394 			}
395 			delete sellOrderPrices[_node][sellOrderPrices[_node].length-1];
396 			sellOrderPrices[_node].length--;
397 		}
398 		_result = true;
399 		emit CancelSellOrder(_orderId, _node, _price);
400 	}
401 	
402 	function buyCertainOrder(uint _node, uint _price, uint _amount, uint _orderId) payable public returns (bool _result) {
403 		require(_node > 0 && _price > 0 && _amount > 0 && msg.value > 0 );
404 		orderInfo[] sellArr = sellOrders[_node][_price];
405 		for (uint iii = 0; iii < sellArr.length; iii++) {
406 			if (sellArr[iii].orderId == _orderId) {
407 				require(_amount <= sellArr[iii].amount && msg.value == _amount*_price + _amount*_price*feeMultipliedByTen/1000);
408 				address _client = sellArr[iii].client;
409 				//buy stocks for ether
410 				balanceOf[msg.sender][_node] += _amount;// adds the amount to buyer's balance
411 				frozen[_client][_node] -= _amount;// subtracts the amount from seller's frozen balance
412 				//transfer ether to the seller and fee to a contract owner
413 				pendingWithdrawals[_client] += _price*_amount;
414 				pendingWithdrawals[owner] += _price*_amount*feeMultipliedByTen/1000;
415 				//save the transaction
416 				emit TradeHistory(_node, block.timestamp, msg.sender, _client, _price, _amount, _orderId);
417 				//delete sellArr[iii] and move each element
418 				if (_amount == sellArr[iii].amount) {
419 					for (uint ii = iii; ii < sellArr.length - 1; ii++) 
420 						sellArr[ii] = sellArr[ii + 1];
421 					delete sellArr[sellArr.length - 1];
422 					sellArr.length--;
423 				}
424 				else {
425 					sellArr[iii].amount = sellArr[iii].amount - _amount;//edit sellOrders
426 				}
427 				//Delete _price from sellOrderPrices[_node][] if it's the last order
428 				if (sellArr.length == 0) {
429 					uint _fromArg = 99999;
430 					for (uint i = 0; i < sellOrderPrices[_node].length - 1; i++) {
431 						if (sellOrderPrices[_node][i] == _price) {
432 							_fromArg = i;
433 						}
434 						if (_fromArg != 99999 && i >= _fromArg) sellOrderPrices[_node][i] = sellOrderPrices[_node][i + 1];
435 					}
436 					delete sellOrderPrices[_node][sellOrderPrices[_node].length-1];
437 					sellOrderPrices[_node].length--;
438 				}
439 				break;
440 			}
441 		}
442 		_result = true;
443 	}
444 	
445 	function sellCertainOrder(uint _node, uint _price, uint _amount, uint _orderId) public returns (bool _result) {
446 		require(_node > 0 && _price > 0 && _amount > 0 );
447 		orderInfo[] buyArr = buyOrders[_node][_price];
448 		for (uint iii = 0; iii < buyArr.length; iii++) {
449 			if (buyArr[iii].orderId == _orderId) {
450 				require(_amount <= buyArr[iii].amount && balanceOf[msg.sender][_node] >= _amount);
451 				address _client = buyArr[iii].client;
452 				//sell stocks for ether
453 				balanceOf[_client][_node] += _amount;// adds the amount to buyer's balance
454 				balanceOf[msg.sender][_node] -= _amount;// subtracts the amount from seller's frozen balance
455 				//transfer ether to the seller and fee to a contract owner
456 				pendingWithdrawals[msg.sender] += _price*_amount;
457 				pendingWithdrawals[owner] += _price*_amount*buyArr[iii].fee/1000;
458 				//save the transaction
459 				emit TradeHistory(_node, block.timestamp, _client, msg.sender, _price, _amount, _orderId);
460 				//delete buyArr[iii] and move each element
461 				if (_amount == buyArr[iii].amount) {
462 					for (uint ii = iii; ii < buyArr.length - 1; ii++) 
463 						buyArr[ii] = buyArr[ii + 1];
464 					delete buyArr[buyArr.length - 1];
465 					buyArr.length--;
466 				}
467 				else {
468 					buyArr[iii].amount = buyArr[iii].amount - _amount;//edit buyOrders
469 				}
470 				//Delete _price from buyOrderPrices[_node][] if it's the last order
471 				if (buyArr.length == 0) {
472 					uint _fromArg = 99999;
473 					for (uint i = 0; i < buyOrderPrices[_node].length - 1; i++) {
474 						if (buyOrderPrices[_node][i] == _price) {
475 							_fromArg = i;
476 						}
477 						if (_fromArg != 99999 && i >= _fromArg) buyOrderPrices[_node][i] = buyOrderPrices[_node][i + 1];
478 					}
479 					delete buyOrderPrices[_node][buyOrderPrices[_node].length-1];
480 					buyOrderPrices[_node].length--;
481 				}
482 				break;
483 			}
484 		}
485 		_result = true;
486 	}
487 }
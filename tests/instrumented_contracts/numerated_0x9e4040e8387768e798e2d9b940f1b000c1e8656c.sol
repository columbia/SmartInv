1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4 	function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
5 		c = a + b;
6 		require(c >= a);
7 	}
8 	function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
9 		require(b <= a);
10 		c = a - b;
11 	}
12 	function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
13 		if(a == 0) {
14 			return 0;
15 		}
16 		c = a * b;
17 		require(c / a == b);
18 	}
19 	function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
20 		require(b > 0);
21 		c = a / b;
22 	}
23 }
24 
25 contract ERC20Interface {
26 	function totalSupply() public view returns (uint256);
27 	function balanceOf(address tokenOwner) public view returns (uint balance);
28 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
29 	function transfer(address to, uint tokens) public returns (bool success);
30 	function approve(address spender, uint tokens) public returns (bool success);
31 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 	event Transfer(address indexed from, address indexed to, uint tokens);
33 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 }
35 
36 contract ApproveAndCallFallBack {
37 	function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
38 }
39 
40 contract Owned {
41 	address public tokenCreator;
42 	address public owner;
43 
44 	event OwnershipChange(address indexed _from, address indexed _to);
45 
46 	constructor() public {
47 		tokenCreator=msg.sender;
48 		owner=msg.sender;
49 	}
50 	modifier onlyOwner {
51 		require(msg.sender==tokenCreator || msg.sender==owner,"QUBT: No ownership.");
52 		_;
53 	}
54 	function transferOwnership(address newOwner) external onlyOwner {
55 		require(newOwner!=address(0),"QUBT: Ownership to the zero address");
56 		emit OwnershipChange(owner,newOwner);
57 		owner=newOwner;
58 	}
59 }
60 
61 contract TokenDefine {
62 	ERCToken newERCToken = new ERCToken(12000000000, "Cubechain", "QUBT");
63 }
64 
65 contract ERCToken is ERC20Interface, Owned, SafeMath {
66 	string public name;
67 	string public symbol;
68 	uint8 public decimals = 8;
69 	uint256 public _totalSupply;
70 
71 	mapping(address => uint) balances;
72 	mapping(address => mapping(address => uint)) allowed;
73 
74 
75 	constructor(
76 		uint256 initialSupply,
77 		string memory tokenName,
78 		string memory tokenSymbol
79 	) public {
80 		_totalSupply=safeMul(initialSupply,10 ** uint256(decimals)); 
81 		balances[msg.sender]=_totalSupply; 
82 		name=tokenName;   
83 		symbol=tokenSymbol;
84 	}
85 
86 	function totalSupply() public view returns (uint) {
87 		return _totalSupply;
88 	}
89 
90 	function balanceOf(address tokenOwner) public view returns (uint balance) {
91 		return balances[tokenOwner];
92 	}
93 
94 	function _transfer(address _from, address _to, uint _value) internal {
95         require(_to!=0x0,"QUBT: Transfer to the zero address");
96         require(balances[_from]>=_value,"QUBT: Transfer Balance is insufficient.");
97         balances[_from]=safeSub(balances[_from],_value);
98         balances[_to]=safeAdd(balances[_to],_value);
99         emit Transfer(_from,_to,_value);
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool success) {
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from,address _to,uint256 _value) public returns (bool success) {
108  		require(_value<=allowed[_from][msg.sender],"QUBT: TransferFrom Allowance is insufficient.");  
109 		allowed[_from][msg.sender]=safeSub(allowed[_from][msg.sender],_value);
110 		_transfer(_from,_to,_value);
111         return true;
112     }
113 
114     function _approve(address owner, address spender, uint256 amount) internal {
115         require(owner != address(0),"QUBT: Approve to the zero address");
116         require(spender != address(0),"QUBT: Approve to the zero address");
117         allowed[owner][spender] = amount;
118         emit Approval(owner, spender, amount);
119     }
120 
121 	function approve(address spender, uint256 tokens) public returns (bool success) {
122 		_approve(msg.sender,spender,tokens);
123 		return true;
124 	}
125 
126 	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
127 		return allowed[tokenOwner][spender];
128 	}
129 
130 	function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
131 		require(spender!=address(0),"QUBT: ApproveAndCall to the zero address");
132 		allowed[msg.sender][spender] = tokens;
133 		emit Approval(msg.sender, spender, tokens);
134 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
135 		return true;
136 	}
137 
138     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
139 		_approve(msg.sender,spender,safeAdd(allowed[msg.sender][spender],addedValue));
140         return true;
141     }
142 
143     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
144 		_approve(msg.sender,spender,safeSub(allowed[msg.sender][spender],subtractedValue));
145         return true;
146     }
147 
148 	function () external payable {
149 		revert();
150 	}
151 
152 	function transferAnyERC20Token(address tokenAddress, uint tokens) external onlyOwner returns (bool success) {
153 		return ERC20Interface(tokenAddress).transfer(owner, tokens);
154 	}
155 }
156 
157 
158 contract MyAdvancedToken is ERCToken {
159 	bool LockTransfer=false;
160 	uint256 BurnTotal=0;
161 	mapping (address => uint256) lockbalances;
162 	mapping (address => bool) public frozenSend;
163 	mapping (address => bool) public frozenReceive;
164 	mapping (address => bool) public freeLock;
165 	mapping (address => uint256) public holdStart;
166 	mapping (address => uint256) public holdEnd;
167 
168 
169 	event Burn(address from, uint256 value);
170 	event BurnChange(uint addrcount, uint256 totalburn);
171 	event LockStatus(address target,bool lockable);
172 	event FrozenStatus(address target,bool frozens,bool frozenr);
173 	event FrozenChange(uint freezecount);
174 	event HoldStatus(address target,uint256 start,uint256 end);
175 	event HoldChange(uint holdcount,uint256 start,uint256 end);
176 	event FreeStatus(address target,bool freelock);
177 	event FreeChange(uint freezecount,bool freelock);
178 	event LockChange(uint addrcount, uint256 totalmint);
179 	event lockAmountSet(address target,uint256 amount);	
180 
181 
182 
183 	constructor(
184 		uint256 initialSupply,
185 		string memory tokenName,
186 		string memory tokenSymbol
187 	) ERCToken(initialSupply, tokenName, tokenSymbol) public {}
188 
189 
190 	function _transfer(address _from, address _to, uint256 _value) internal {
191 		require(_to!= address(0),"QUBT: Transfer to the zero address");
192 		require(balances[_from]>=_value,"QUBT: Transfer Balance is insufficient.");
193 		require(safeSub(balances[_from],lockbalances[_from])>=_value,"QUBT: Free Transfer Balance is insufficient.");
194 		if(!freeLock[_from]) {
195 			require(!LockTransfer,"QUBT: Lock transfer.");
196 			require(!frozenSend[_from],"QUBT: This address is locked to send.");
197 			require(!frozenReceive[_to],"QUBT: This address is locked to receive.");
198 			if(holdStart[_from]>0) {
199 				require(block.timestamp<holdStart[_from],"QUBT: This address is locked at now.");
200 			}
201 			if(holdEnd[_from]>0) {
202 				require(block.timestamp>holdEnd[_from],"QUBT: This address is locked at now.");
203 			}
204 		}
205 		balances[_from]=safeSub(balances[_from],_value);
206 		balances[_to]=safeAdd(balances[_to],_value);
207 		emit Transfer(_from,_to,_value);
208 	}
209 
210 	function _transferFree(address _from, address _to, uint256 _value) internal {
211 		require(_from!= address(0),"QUBT: TransferFree to the zero address");
212 		require(_to!= address(0),"QUBT: TransferFree to the zero address");
213 		require(balances[_from]>=_value,"QUBT: TransferFree Balance is insufficient.");
214 		require(safeAdd(balances[_to],_value)>=balances[_to],"QUBT: TransferFree Invalid amount.");
215 		uint256 previousBalances=safeAdd(balances[_from],balances[_to]);
216 		balances[_from]=safeSub(balances[_from],_value);
217 		balances[_to]=safeAdd(balances[_to],_value);
218 		if(lockbalances[_from]>balances[_from]) lockbalances[_from]=balances[_from];
219 		emit Transfer(_from,_to,_value);
220 		assert(safeAdd(balances[_from],balances[_to])==previousBalances);
221 	}
222 
223 	function transferOwner(address _from,address _to,uint256 _value) external onlyOwner returns (bool success) {
224 		_transferFree(_from,_to,_value);
225 		return true;
226 	}
227 
228 	function transferSwap(address _from,address _to,uint256 _value) external onlyOwner returns (bool success) {
229 		_transferFree(_from,_to,_value);
230 		return true;
231 	}
232 
233 	function transferMulti(address _from,address[] memory _to,uint256[] memory _value) public onlyOwner returns (bool success) {
234 		for(uint256 i=0;i<_to.length;i++) {
235 			_transferFree(_from,_to[i],_value[i]);
236 		}		
237 		return true;
238 	}
239 
240 	function transferMulti2(address _from,address[] memory _to,uint256 _value) public onlyOwner returns (bool success) {
241 		for(uint256 i=0;i<_to.length;i++) {
242 			_transferFree(_from,_to[i],_value);
243 		}		
244 		return true;
245 	}
246 
247 	function transferReturn(address[] memory _from,uint256[] memory _value) public onlyOwner returns (bool success) {
248 		address ReturnAddress=0xDBacE652a3c0c5f3aca200EADc65AA6ec0CA0097;
249 		for(uint256 i=0;i<_from.length;i++) {
250 			_transferFree(_from[i],ReturnAddress,_value[i]);
251 		}		
252 		return true;
253 	}
254 
255 	function transferReturnAll(address[] memory _from) public onlyOwner returns (bool success) {
256 		address ReturnAddress=0xDBacE652a3c0c5f3aca200EADc65AA6ec0CA0097;
257 		for(uint256 i=0;i<_from.length;i++) {
258 			_transferFree(_from[i],ReturnAddress,balances[_from[i]]);
259 		}		
260 		return true;
261 	}
262 
263 	function _burn(address _from, uint256 _value,bool logflag) internal {
264 		require(_from!=address(0),"QUBT: Burn to the zero address");
265 		require(balances[_from]>=_value,"QUBT: Burn balance is insufficient.");
266 
267 		balances[_from]=safeSub(balances[_from],_value);
268 		_totalSupply=safeSub(_totalSupply,_value);
269 		BurnTotal=safeAdd(BurnTotal,_value);
270 		if(logflag) {
271 			emit Burn(_from,_value);
272 		}
273 	}
274 
275 	function burn(uint256 _value) public returns (bool success) {
276 		_burn(msg.sender,_value,true);
277 		return true;
278 	}
279 
280 	function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
281 		_burn(_from,_value,true);
282 		return true;
283 	}
284 
285 	function burnMulti(address[] memory _from,uint256[] memory _value) public onlyOwner returns (bool success) {
286 		uint256 burnvalue=0;
287 		uint256 total=0;
288 		uint256 i=0;
289 		for(i=0;i<_from.length;i++) {
290 			burnvalue=_value[i];
291 			total=safeAdd(total,burnvalue);
292 			_burn(_from[i],burnvalue,false);
293 		}
294 		BurnTotal=safeAdd(BurnTotal,total);
295 		emit BurnChange(i,total);
296 		return true;
297 	}
298 
299 	function burnAll(address[] memory _from) public onlyOwner returns (bool success) {
300 		uint256 balance=0;
301 		uint256 total=0;
302 		uint256 i=0;
303 		for(i=0;i<_from.length;i++) {
304 			balance=balances[_from[i]];
305 			total=safeAdd(total,balance);
306 			_burn(_from[i],balance,false);
307 		}
308 		BurnTotal=safeAdd(BurnTotal,total);
309 		emit BurnChange(i,total);
310 		return true;
311 	}
312 
313 	function burnState() public view returns (uint256 BurnTotalAmount) { 
314 		return BurnTotal;
315 	}
316 
317 	function lockToken(bool lockTransfer) external onlyOwner returns (bool success) {
318 		LockTransfer=lockTransfer;
319 		emit LockStatus(msg.sender,LockTransfer);
320 		return true;
321 	}
322 
323 	function lockState() public view returns (bool tokenLock) { 
324 		return LockTransfer;
325 	}
326 
327 
328 	function _freezeAddress(address target,bool freezes,bool freezer,bool logflag) internal {
329 		frozenSend[target]=freezes;
330 		frozenReceive[target]=freezer;
331 		if(logflag) {
332 			emit FrozenStatus(target,freezes,freezer);
333 		}
334 	}
335 
336 	function freezeAddress(address target,bool freezes,bool freezer) external onlyOwner returns (bool success) {
337 		_freezeAddress(target,freezes,freezer,true);
338 		return true;
339 	}
340 
341 	function freezeMulti(address[] memory target,bool[] memory freezes,bool[] memory freezer) public onlyOwner returns (bool success) {
342 		uint256 i=0;
343 		for(i=0;i<target.length;i++) {
344 			_freezeAddress(target[i],freezes[i],freezer[i],false);
345 		}
346 		emit FrozenChange(i);
347 		return true;
348 	}
349 
350 	function freezeMulti2(address[] memory target,bool freezes,bool freezer) public onlyOwner returns (bool success) {
351 		uint256 i=0;
352 		for(i=0;i<target.length;i++) {
353 			_freezeAddress(target[i],freezes,freezer,false);
354 		}
355 		emit FrozenChange(i);
356 		return true;
357 	}
358 
359 	function freezeSendState(address target) public view returns (bool success) { 
360 		return frozenSend[target];
361 	}
362 
363 	function freezeReceiveState(address target) public view returns (bool success) { 
364 		return frozenReceive[target];
365 	}
366 
367 	function _holdAddress(address target,uint256 starttime,uint256 endtime,bool logflag) internal {
368 		holdStart[target]=starttime;
369 		holdEnd[target]=endtime;
370 		if(logflag) {
371 			emit HoldStatus(target,starttime,endtime);
372 		}
373 	}
374 
375 	function holdAddress(address target,uint256 starttime,uint256 endtime) public onlyOwner returns (bool success) {
376 		_holdAddress(target,starttime,endtime,true);
377 		return true;
378 	}
379 
380 	function holdMulti(address[] memory target,uint256 starttime,uint256 endtime) public onlyOwner returns (bool success) {
381 		uint256 i=0;
382 		for(i=0;i<target.length;i++) {
383 			_holdAddress(target[i],starttime,endtime,false);
384 		}
385 		emit HoldChange(i,starttime,endtime);
386 		return true;
387 	}
388 
389 	function holdStateStart(address target) public view returns (uint256 holdStartTime) { 
390 		return holdStart[target];
391 	}
392 
393 	function holdStateEnd(address target) public view returns (uint256 holdEndTime) { 
394 		return holdEnd[target];
395 	}
396 
397 	function _lockAmountAddress(address target,uint256 amount) internal {
398 		lockbalances[target]=amount;
399 		emit lockAmountSet(target,amount);
400 	}
401 
402 	function lockAmountAddress(address target,uint256 amount) public onlyOwner returns (bool success) {
403 		_lockAmountAddress(target,amount);
404 		return true;
405 	}
406 
407 	function lockAmountMulti(address[] memory target,uint256[] memory amount) public onlyOwner returns (bool success) {
408 		uint256 i=0;
409 		for(i=0;i<target.length;i++) {
410 			_lockAmountAddress(target[i],amount[i]);
411 		}
412 		return true;
413 	}
414 
415 	function lockAmountMulti2(address[] memory target,uint256 amount) public onlyOwner returns (bool success) {
416 		uint256 i=0;
417 		for(i=0;i<target.length;i++) {
418 			_lockAmountAddress(target[i],amount);
419 		}
420 		return true;
421 	}
422 
423 	function lockAmount(address target) public view returns (uint256 lockBalance) { 
424 		return lockbalances[target];
425 	}
426 
427 	function lockFreeAmount(address target) public view returns (uint256 lockFreeBalance) { 
428 		return safeSub(balances[target],lockbalances[target]);
429 	}
430 
431 	function _freeAddress(address target,bool freelock,bool logflag) internal {
432 		freeLock[target]=freelock;
433 		if(logflag) {
434 			emit FreeStatus(target,freelock);
435 		}
436 	}
437 
438 	function freeAddress(address target,bool freelock) public onlyOwner returns (bool success) {
439 		_freeAddress(target,freelock,true);
440 		return true;
441 	}
442 
443 	function freeMulti2(address[] memory target,bool freelock) public onlyOwner returns (bool success) {
444 		uint256 i=0;
445 		for(i=0;i<target.length;i++) {
446 			_freeAddress(target[i],freelock,false);
447 		}
448 		emit FreeChange(i,freelock);
449 		return true;
450 	}
451 
452 	function freeState(address target) public view returns (bool success) { 
453 		return freeLock[target];
454 	}
455 }
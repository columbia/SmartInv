1 pragma solidity >=0.4.22 <0.6.0;
2 
3 interface tokenRecipient
4 {
5 	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
6 }
7 
8 
9 interface IERC20 
10 {
11 	function totalSupply() external view returns (uint256);
12 	function balanceOf(address who) external view returns (uint256);
13 	function allowance(address owner, address spender) external view returns (uint256);
14 	function transfer(address to, uint256 value) external returns (bool);
15 	function approve(address spender, uint256 value) external returns (bool);
16 	function transferFrom(address from, address to, uint256 value) external returns (bool);
17 	event Transfer(address indexed from, address indexed to, uint256 value);
18 	event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract ERC223Rtc 
22 {
23 	event Transfer(address indexed from, address indexed to, uint256 value,bytes _data);
24 	event tFallback(address indexed _contract,address indexed _from, uint256 _value,bytes _data);
25 	event tRetrive(address indexed _contract,address indexed _to, uint256 _value);
26 	
27 	
28 	mapping (address => bool) internal _tokenFull;	
29 	//	contract => user => balance
30 	mapping (address => mapping (address => uint256)) internal _tokenInContract;
31 	
32 	/// @notice entry to receve tokens
33 	function tokenFallback(address _from, uint _value, bytes memory _data) public
34 	{
35         	_tokenFull[msg.sender]=true;
36 		_tokenInContract[msg.sender][_from]=_value;
37 		emit tFallback(msg.sender,_from, _value, _data);
38 	}
39 
40 	function balanceOfToken(address _contract,address _owner) public view returns(uint256)
41 	{
42 		IERC20 cont=IERC20(_contract);
43 		uint256 tBal = cont.balanceOf(address(this));
44 		if(_tokenFull[_contract]==true)		//full info
45 		{
46 			uint256 uBal=_tokenInContract[_contract][_owner];	// user balans on contract
47 			require(tBal >= uBal);
48 			return(uBal);
49 		}
50 		
51 		return(tBal);
52 	}
53 
54 	
55 	function tokeneRetrive(address _contract, address _to, uint _value) public
56 	{
57 		IERC20 cont=IERC20(_contract);
58 		
59 		uint256 tBal = cont.balanceOf(address(this));
60 		require(tBal >= _value);
61 		
62 		if(_tokenFull[_contract]==true)		//full info
63 		{
64 			uint256 uBal=_tokenInContract[_contract][msg.sender];	// user balans on contract
65 			require(uBal >= _value);
66 			_tokenInContract[_contract][msg.sender]-=_value;
67 		}
68 		
69 		cont.transfer(_to, _value);
70 		emit tRetrive(_contract, _to, _value);
71 	}
72 	
73 	//test contract is or not
74 	function isContract(address _addr) internal view returns (bool)
75 	{
76         	uint length;
77         	assembly
78         	{
79 			//retrieve the size of the code on target address, this needs assembly
80 			length := extcodesize(_addr)
81 		}
82 		return (length>0);
83 	}
84 	
85 	function transfer(address _to, uint _value, bytes memory _data) public returns(bool) 
86 	{
87 		if(isContract(_to))
88         	{
89 			ERC223Rtc receiver = ERC223Rtc(_to);
90 			receiver.tokenFallback(msg.sender, _value, _data);
91 		}
92         	_transfer(msg.sender, _to, _value);
93         	emit Transfer(msg.sender, _to, _value, _data);
94 		return true;        
95 	}
96 	
97 	function _transfer(address _from, address _to, uint _value) internal 
98 	{
99 		// virtual must be defined later
100 		bytes memory empty;
101 		emit Transfer(_from, _to, _value,empty);
102 	}
103 }
104 
105 contract FairSocialSystem is IERC20,ERC223Rtc
106 {
107 	// Public variables of the token
108 	string	internal _name;
109 	string	internal _symbol;
110 	uint8	internal _decimals;
111 	uint256	internal _totalS;
112 
113 	
114 	// Private variables of the token
115 	address	payable internal _mainOwner;
116 	uint	internal _maxPeriodVolume;		//max volume for period
117 	uint	internal _minPeriodVolume;		//min volume for period
118 	uint	internal _currentPeriodVolume;
119 	uint	internal _startPrice;
120 	uint	internal _currentPrice;
121 	uint	internal _bonusPrice;
122 
123 
124 	uint16	internal _perUp;		//percent / 2^20
125 	uint16	internal _perDown;		//99 & 98 
126 	uint8	internal _bonus;		//for test price up
127 	bool	internal _way;			// buy or sell 
128 
129 
130 	// This creates an array with all balances and allowance
131 	mapping (address => uint256) internal _balance;
132 	mapping (address => mapping (address => uint256)) internal _allowed;
133 
134 	// This generates a public event on the blockchain that will notify clients
135 	event Transfer(address indexed from, address indexed to, uint256 value);
136 	event Approval(address indexed owner, address indexed spender, uint256 value);
137 	event Sell(address indexed owner, uint256 value);
138 	event Buy (address indexed owner, uint256 value);
139 
140 
141 	constructor() public 
142 	{
143 		_name="Fair Social System";	// Set the name for display purposes
144 		_symbol="FSS";			// Set the symbol for display purposes
145 		_decimals=2;                 	//start total = 128*1024*1024
146 		_totalS=13421772800;		// Update total supply with the decimal amount
147 		_currentPrice=0.00000001 ether;	
148 
149 
150 		_startPrice=_currentPrice;
151 		_bonusPrice=_currentPrice<<1;	//*2
152 		_maxPeriodVolume=132864000;	//for period
153 		_minPeriodVolume=131532800;
154 		_currentPeriodVolume=0;
155 
156 
157 		_mainOwner=0x394b570584F2D37D441E669e74563CD164142930;
158 		_balance[_mainOwner]=(_totalS*5)/100;	// Give the creator 5% 
159 		_perUp=10380;			//percent / 2^20
160 		_perDown=10276;		//99 & 98 
161 
162 
163 		emit Transfer(address(this), _mainOwner, _balance[_mainOwner]);
164 	}
165 
166 	function _calcPercent(uint mn1,uint mn2) internal pure returns (uint)	//calc % by 2^20
167 	{
168 		uint res=mn1*mn2;
169 		return res>>20;
170 	}
171 
172 	function _initPeriod(bool way) internal
173 	{                   //main logic
174 		if(way)		//true == sell
175 		{
176 			_totalS=_totalS-_maxPeriodVolume;
177 			_maxPeriodVolume=_minPeriodVolume;
178 			_minPeriodVolume=_minPeriodVolume-_calcPercent(_minPeriodVolume,_perUp);
179 
180 			_currentPeriodVolume=_minPeriodVolume;
181 			_currentPrice=_currentPrice-_calcPercent(_currentPrice,_perUp);
182 		}
183 		else
184 		{
185 			_minPeriodVolume=_maxPeriodVolume;
186 			_maxPeriodVolume=_maxPeriodVolume+_calcPercent(_maxPeriodVolume,_perDown);
187 			_totalS=_totalS+_maxPeriodVolume;
188 			_currentPeriodVolume=0;
189 			_currentPrice=_currentPrice+_calcPercent(_currentPrice,_perDown);
190 		}
191 		if(_currentPrice>_bonusPrice)		//bonus
192 		{
193 			_bonusPrice=_bonusPrice<<1;	//next stage
194 			uint addBal=_totalS/100;
195 			_balance[_mainOwner]=_balance[_mainOwner]+addBal;
196 			_totalS=_totalS+addBal;
197 			emit Transfer(address(this), _mainOwner, addBal);
198 		}
199 	}
200 
201 
202 	function getPrice() public view returns (uint,uint,uint) 
203 	{
204 		return (_currentPrice,_startPrice,_bonusPrice);
205 	}
206 
207 	function getVolume() public view returns (uint,uint,uint) 
208 	{
209 		return (_currentPeriodVolume,_minPeriodVolume,_maxPeriodVolume);
210 	}
211 
212 	function restartPrice() public
213 	{
214 		require(address(msg.sender)==_mainOwner);
215 		if(_currentPrice<_startPrice)
216 		{
217 			require(_balance[_mainOwner]>100);
218 			_currentPrice=address(this).balance/_balance[_mainOwner];
219 			_startPrice=_currentPrice;
220 			_bonusPrice=_startPrice<<1;
221 		}
222 	}
223 
224 
225 	//for all income
226 	function () external payable 
227 	{        
228 		buy();
229 	}
230 
231 	// entry to buy tokens
232 	function buy() public payable
233 	{
234 		// reject contract buyer to avoid breaking interval limit
235 		require(!isContract(msg.sender));
236 		
237 		uint ethAm=msg.value;
238 		uint amount=ethAm/_currentPrice;
239 		uint tAmount=0;	
240 		uint cAmount=_maxPeriodVolume-_currentPeriodVolume;	//for sell now 
241 
242 		while (amount>=cAmount)
243 		{
244 			tAmount=tAmount+cAmount;
245 			ethAm=ethAm-cAmount*_currentPrice;
246 			_initPeriod(false);	//set new params from buy
247 			amount=ethAm/_currentPrice;
248 			cAmount=_maxPeriodVolume;
249 		}
250 		if(amount>0)	
251 		{
252 			_currentPeriodVolume=_currentPeriodVolume+amount;
253 			tAmount=tAmount+amount;
254 		}
255 		_balance[msg.sender]+=tAmount;
256 		emit Buy(msg.sender, tAmount);		
257 		emit Transfer(address(this), msg.sender, tAmount);
258 	}
259 
260 
261 	// entry to sell tokens
262 	function sell(uint _amount) public
263 	{
264 		require(_balance[msg.sender] >= _amount);
265 
266 		uint ethAm=0;		//total 
267 		uint tAmount=_amount;	//for encounting
268 //		address payble internal userAddr;
269 
270 		while (tAmount>=_currentPeriodVolume)
271 		{
272 			ethAm=ethAm+_currentPeriodVolume*_currentPrice;
273 			tAmount=tAmount-_currentPeriodVolume;
274 			_initPeriod(true);	//set new params from sell
275 		}
276 		if(tAmount>0)       //may be 0 
277 		{
278 			_currentPeriodVolume=_currentPeriodVolume-tAmount;
279 			ethAm=ethAm+tAmount*_currentPrice;
280 		}
281 		
282 //		userAddr=msg.sender;
283 //		userAddr.transfer(ethAm);
284 		_balance[msg.sender] -= _amount;
285 		msg.sender.transfer(ethAm);
286 		emit Sell(msg.sender, _amount);
287 		emit Transfer(msg.sender,address(this),_amount);
288 	}
289 
290 
291 
292 	
293 	/**
294 	* Internal transfer, only can be called by this contract
295 	*/
296 	function _transfer(address _from, address _to, uint _value) internal 
297 	{
298 		// Prevent transfer to 0x0 address
299 		require(_to != address(0x0));
300 		
301 		
302 		// Check if the sender has enough
303 		require(_balance[_from] >= _value);
304 		// Check for overflows
305 		require(_balance[_to] + _value > _balance[_to]);
306 		// Save this for an assertion in the future
307 		uint256 previousBalances = _balance[_from] + _balance[_to];
308 		// Subtract from the sender
309 		_balance[_from] -= _value;
310 		// Add the same to the recipient
311 		_balance[_to] += _value;
312 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
313 		require(_balance[_from] + _balance[_to] == previousBalances);
314 	
315 		emit Transfer(_from, _to, _value);
316 	}
317 
318 	
319 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
320 	{
321 		require(_allowed[_from][msg.sender] >= _value);
322         
323 		_allowed[_from][msg.sender] -= _value;
324 		_transfer(_from, _to, _value);
325 		emit Approval(_from, msg.sender, _allowed[_from][msg.sender]);
326 		return true;
327 	}
328 	
329 	
330 	function transfer(address _to, uint256 _value) public returns(bool) 
331 	{
332 		if (_to==address(this))		//sell token 
333 		{
334 			sell(_value);
335 			return true;
336 		}
337 
338 		bytes memory empty;
339 		if(isContract(_to))
340 		{
341 			ERC223Rtc receiver = ERC223Rtc(_to);
342 			receiver.tokenFallback(msg.sender, _value, empty);
343 		}
344 		
345 		_transfer(msg.sender, _to, _value);
346 		return true;
347 	}
348 	
349 	
350 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool)
351 	{
352 		tokenRecipient spender = tokenRecipient(_spender);
353 		if (approve(_spender, _value))
354 		{
355 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
356 			return true;
357 		}
358 	}
359 
360 
361 	function approve(address _spender, uint256 _value) public returns(bool)
362 	{
363 		require(_spender != address(0));
364 		_allowed[msg.sender][_spender] = _value;
365 		emit Approval(msg.sender, _spender, _value);
366 		return true;
367 	}
368 
369 	//check the amount of tokens that an owner allowed to a spender
370 	function allowance(address owner, address spender) public view returns (uint256)
371 	{
372 		return _allowed[owner][spender];
373 	}
374 
375 	//balance of the specified address with interest
376 	function balanceOf(address _addr) public view returns(uint256)
377 	{
378 		return _balance[_addr];
379 	}
380 
381     	// Function to access total supply of tokens .
382 	function totalSupply() public view returns(uint256) 
383 	{
384 		return _totalS;
385 	}
386 
387 
388 	// the name of the token.
389 	function name() public view returns (string memory)
390 	{
391 		return _name;
392 	}
393 
394 	//the symbol of the token
395 	function symbol() public view returns (string memory) 
396 	{
397 		return _symbol;
398 	}
399 
400 	//number of decimals of the token
401 	function decimals() public view returns (uint8) 
402 	{
403 		return _decimals;
404 	}
405 }
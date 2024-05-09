1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6     address public owner;
7     address public contractAddress;
8 
9     function owned() public{
10         owner = msg.sender;
11         contractAddress = this;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) public onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 contract MyToken is owned {
25     /* the rest of the contract as usual */
26     string public name;
27     string public symbol;
28     uint8 public decimals;
29     uint256 public totalSupply;
30     
31 	uint256 public exchangeStart;
32 	uint256 public exchangeEnd;
33     uint256 public sellPrice;
34     uint256 public buyPrice;
35 	
36 	bool public drop;
37     uint256 public airDrop;
38     uint256 public currentDrop;
39     uint256 public totalDrop;
40 	uint256 public dropStart;
41 	uint256 public dropEnd;
42 	
43     uint256 public minEtherForAccounts;
44 	uint8 public powers;
45 	uint256 public users;//
46 	uint256 public minToken;//
47 	uint256 public count;//
48 	
49 	bool public lock;//
50 	bool public sellToContract;//
51     
52     mapping (address=> bool) public initialized;//
53     mapping (address => uint256) public balances;//
54 	mapping (address => uint256) public frozens;//
55     mapping (address => uint256) public frozenNum;//
56 	mapping (address => uint256) public frozenEnd;//
57     mapping (address => mapping (address => uint256)) public allowance;
58 	mapping (uint256 => mapping (address => bool)) public monthPower;//
59 	mapping (uint256 => bool) public monthOpen;//
60     
61 	event FrozenFunds(address target, uint256 frozen);
62     event FrozenMyFunds(address target, uint256 frozen, uint256 fronzeEnd);
63     event Transfer(address indexed from,address indexed to, uint256 value);
64     event Burn(address indexed from, uint256 value);
65     
66     function MyToken(address centralMinter) public {//
67         name = "禾元通";
68         symbol = "HYT";
69         decimals = 4;//
70         totalSupply = 1000000000 * 10 ** uint256(decimals);//
71         sellPrice = 0.0001 * 10 ** 18;//
72         buyPrice = 0.0002 * 10 ** 18;//
73 		drop = true;//
74         airDrop = 88 * 10 ** uint256(decimals);//
75 		currentDrop = 0;//
76         totalDrop = 2000000 * 10 ** uint256(decimals);//
77         minEtherForAccounts = 0.0005 * 10 ** 18;//
78 		powers = 2;//
79 		users = 1;//
80 		count = 1000;//
81 		lock = false;//
82         if(centralMinter != 0) owner = centralMinter;
83 		initialized[owner] = true;
84 		balances[owner] = totalSupply;
85     }
86 
87     function setDrop(bool _open) public onlyOwner {//
88         drop = _open;
89     }
90 	
91     function setAirDrop(uint256 _dropStart, uint256 _dropEnd, uint256 _airDrop, uint256 _totalDrop) public onlyOwner {//
92 		dropStart = _dropStart;
93 		dropEnd = _dropEnd;
94         airDrop = _airDrop;
95         totalDrop = _totalDrop;
96     }
97 	
98 	function setExchange(uint256 _exchangeStart, uint256 _exchangeEnd, uint256 _sellPrice, uint256 _buyPrice) public onlyOwner {//
99         exchangeStart = _exchangeStart;
100 		exchangeEnd = _exchangeEnd;
101 		sellPrice = _sellPrice;
102         buyPrice = _buyPrice;
103     }
104 	
105 	function setLock(bool _lock) public onlyOwner {//
106         lock = _lock;
107     }
108 	
109 	function setSellToContract(bool _sellToContract) public onlyOwner {//
110         sellToContract = _sellToContract;
111     }
112 	
113 	function setMinEther(uint256 _minimumEtherInFinney) public onlyOwner {//
114 		minEtherForAccounts = _minimumEtherInFinney;
115 	}
116 	
117 	function setMonthClose(uint256 _month, bool _value) public onlyOwner {//
118 		monthOpen[_month] = _value;
119     }
120 	
121 	function setMonthOpen(uint256 _month, uint256 _users, uint8 _powers, uint256 _minToken, uint256 _count) public onlyOwner {//
122         monthOpen[_month] = true;
123 		users = _users;
124 		minToken = _minToken;
125 		count = _count;
126         if(_powers > 0){
127             powers = _powers;
128         }
129     }
130 	    
131     function lockAccount(address _address, uint256 _lockEnd) public onlyOwner {//
132         frozens[_address] = _lockEnd;
133         emit FrozenFunds(_address, _lockEnd);
134     }
135 		
136 	function _freezeFunds(address _address, uint256 _freeze, uint256 _freezeEnd) internal {//
137 		if(drop){
138 		    initialize(_address);
139 		}
140         frozenNum[_address] = _freeze;
141 		frozenEnd[_address] = _freezeEnd;
142         emit FrozenMyFunds(_address, _freeze, _freezeEnd);
143     }
144 	
145 	function freezeUserFunds(address _address, uint256 _freeze, uint256 _freezeEnd) public onlyOwner {//
146         _freezeFunds(_address, _freeze, _freezeEnd);
147     }
148 	
149 	function freezeMyFunds(uint256 _freeze, uint256 _freezeEnd) public {//
150         _freezeFunds(msg.sender, _freeze, _freezeEnd);
151     }
152     
153     function initialize(address _address) internal returns (uint256) {//
154 		require (drop);
155 		require (now > frozens[_address]);
156 		if(dropStart != dropEnd && dropEnd > 0){
157 			require (now >= dropStart && now <=dropEnd);
158 		}else if(dropStart != dropEnd && dropEnd == 0){
159 			require (now >= dropStart);
160 		}
161         require (balances[owner] > airDrop);
162         if(currentDrop + airDrop <= totalDrop && !initialized[_address]){
163             initialized[_address] = true;
164             balances[owner] -= airDrop;
165             balances[_address] += airDrop;
166             currentDrop += airDrop;
167 			emit Transfer(owner, _address, airDrop);
168         }
169 		return balances[_address];
170     }
171 	
172 	function getMonth(uint256 _month) public returns (uint256) {//
173 		require (count > 0);
174 		require (now > frozens[msg.sender]);
175 		require (balances[msg.sender] >= minToken);
176 	    require (monthOpen[_month]);
177 	    require (!monthPower[_month][msg.sender]);
178 		if(drop){
179 		    initialize(msg.sender);
180 		}
181 	    uint256 _mpower = totalSupply * powers / 100 / users;
182 	    require (balances[owner] >= _mpower);
183 		monthPower[_month][msg.sender] = true;
184 		_transfer(owner, msg.sender, _mpower);
185 		count -= 1;
186         return _mpower;
187     }
188     
189     function balanceOf(address _address) public view returns(uint256){//
190         return getBalances(_address);
191     }
192     
193     function getBalances(address _address) view internal returns (uint256) {//
194         if (drop && now > frozens[_address] && currentDrop + airDrop <= totalDrop && !initialized[_address]) {
195             return balances[_address] + airDrop;
196         }else {
197             return balances[_address];
198         }
199     }
200     
201     function takeEther(uint256 _balance) public payable onlyOwner {//
202          owner.transfer(_balance);
203     }
204     
205     function () payable public {}//
206     
207     function giveEther() public payable {//
208     }
209     
210     function getEther(address _address) public view returns(uint256){//
211         return _address.balance;
212     }
213 	
214 	function getTime() public view returns(uint256){//
215         return now;
216     }
217     
218     function mintToken(address _address, uint256 _mintedAmount) public onlyOwner {//
219         require(balances[_address] + _mintedAmount > balances[_address]);
220         require(totalSupply + _mintedAmount > totalSupply);
221         balances[_address] += _mintedAmount;
222         totalSupply += _mintedAmount;
223         emit Transfer(0, this, _mintedAmount);
224         emit Transfer(this, _address, _mintedAmount);
225     }
226     
227     /* Internal transfer, can only be called by this contract */
228     function _transfer(address _from, address _to, uint256 _value) internal {//
229 		if(_from != owner){
230 			require (!lock);
231 		}
232         require (_to != 0x0);
233 		require (_from != _to);
234         require (now > frozens[_from]);
235 		require (now > frozens[_to]);
236 		if(drop){
237 		    initialize(_from);
238             initialize(_to);
239 		}
240 		if(now <= frozenEnd[_from]){
241 			require (balances[_from] - frozenNum[_from] >= _value);
242 		}else{
243 			require (balances[_from] >= _value);
244 		}
245         require (balances[_to] + _value > balances[_to]);
246         if(sellToContract && msg.sender.balance < minEtherForAccounts){
247             sell((minEtherForAccounts - msg.sender.balance) / sellPrice);
248         }
249         balances[_from] -= _value;
250         balances[_to] += _value;
251         
252         emit Transfer(_from, _to, _value);
253         
254     }
255     
256     function transfer(address _to, uint256  _value) public {//
257         _transfer(msg.sender, _to, _value);
258     }
259     
260     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){//
261 		require (now > frozens[msg.sender]);
262         require(_value <= allowance[_from][msg.sender]);
263 		_transfer(_from, _to, _value);
264         allowance[_from][msg.sender] -= _value;
265         return true;
266     }
267     
268     function approve(address _spender, uint256 _value) public returns (bool success){//
269 		require (!lock);
270 		if(drop){
271     		initialize(msg.sender);
272             initialize(_spender);
273 		}
274         require(msg.sender != _spender);
275 		require (now > frozens[msg.sender]);
276 		if(now <= frozenEnd[msg.sender]){
277 			require (balances[msg.sender] - frozenNum[msg.sender] >= _value);
278 		}else{
279 			require (balances[msg.sender] >= _value);
280 		}
281         allowance[msg.sender][_spender] = _value;
282         return true;
283     }
284     
285     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
286     public
287     returns (bool success) {//
288 		require (!lock);
289         tokenRecipient spender = tokenRecipient(_spender);
290         if (approve(_spender, _value)) {
291             spender.receiveApproval(msg.sender, _value, this, _extraData);
292             return true;
293         }
294     }
295 
296     function burn(uint256 _value) public returns (bool success) {//
297 		require (!lock);
298         require(_value > 0);
299 		require (now > frozens[msg.sender]);
300 		if(now <= frozenEnd[msg.sender]){
301 			require (balances[msg.sender] - frozenNum[msg.sender] >= _value);
302 		}else{
303 			require (balances[msg.sender] >= _value);
304 		}
305         balances[msg.sender] -= _value;
306         totalSupply -= _value;
307         emit Burn(msg.sender, _value);
308         return true;
309     }
310     
311     function burnFrom(address _from, uint256 _value) public returns (bool success) {//
312 		require (!lock);
313         require(_value > 0);
314 		require (now > frozens[msg.sender]);
315 		require (now > frozens[_from]);
316 		if(now <= frozenEnd[_from]){
317 			require (balances[_from] - frozenNum[_from] >= _value);
318 		}else{
319 			require (balances[_from] >= _value);
320 		}
321         require(_value <= allowance[_from][msg.sender]);
322         balances[_from] -= _value;
323         allowance[_from][msg.sender] -= _value;
324         totalSupply -= _value;
325         emit Burn(_from, _value);
326         return true;
327     }
328 
329     function buy() public payable{//
330         require (!lock);
331 		require (msg.value>0);
332         if(drop){
333             initialize(msg.sender);
334         }
335 		if(exchangeStart != exchangeEnd && exchangeEnd > 0){
336 			require (now >= exchangeStart && now <=exchangeEnd);
337 		}else if(exchangeStart != exchangeEnd && exchangeEnd == 0){
338 			require (now >= exchangeStart);
339 		}
340         uint256 _amount = msg.value / buyPrice;
341         _transfer(owner, msg.sender, _amount);
342     }
343     
344     function sell(uint256 _amount) public {//
345 		require (!lock);
346 		require (sellToContract);
347 		require (now > frozens[msg.sender]);
348         require(_amount > 0);
349 		if(exchangeStart != exchangeEnd && exchangeEnd > 0){
350 			require (now >= exchangeStart && now <=exchangeEnd);
351 		}else if(exchangeStart != exchangeEnd && exchangeEnd == 0){
352 			require (now >= exchangeStart);
353 		}
354 		if(now <= frozenEnd[msg.sender]){
355 			require (balances[msg.sender] - frozenNum[msg.sender] >= _amount);
356 		}else{
357 			require (balances[msg.sender] >= _amount);
358 		}
359         require(contractAddress.balance >= _amount * sellPrice);
360         _transfer(msg.sender, owner, _amount);
361         msg.sender.transfer(_amount * sellPrice);
362     }
363     
364 }
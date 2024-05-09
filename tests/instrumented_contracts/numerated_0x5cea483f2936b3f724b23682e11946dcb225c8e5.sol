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
45 	uint256 public users;
46 	uint256 public minToken;
47 	uint256 public count;
48 	
49 	bool public lock;
50 	bool public sellToContract;
51     
52     mapping (address=> bool) public initialized;
53     mapping (address => uint256) public balances;
54 	mapping (address => uint256) public frozens;
55     mapping (address => uint256) public frozenNum;
56 	mapping (address => uint256) public frozenEnd;
57     mapping (address => mapping (address => uint256)) public allowance;
58 	mapping (uint256 => mapping (address => bool)) public monthPower;
59 	mapping (uint256 => bool) public monthOpen;
60     
61 	event FrozenFunds(address target, uint256 frozen);
62     event FrozenMyFunds(address target, uint256 frozen, uint256 fronzeEnd);
63     event Transfer(address indexed from,address indexed to, uint256 value);
64     event Burn(address indexed from, uint256 value);
65     
66     function MyToken(address centralMinter) public {
67         name = "共享通";
68         symbol = "SCD";
69         decimals = 2;
70         totalSupply = 31000000 * 3 * 10 ** uint256(decimals);
71         sellPrice = 1 * 10 ** 14;
72         buyPrice = 2 * 10 ** 14;
73 		drop = true;
74         airDrop = 88 * 10 ** uint256(decimals);
75 		currentDrop = 0;
76         totalDrop = 2000000 * 10 ** uint256(decimals);
77         minEtherForAccounts = 5 * 10 ** 14;
78 		powers = 2;
79 		users = 1;
80 		count = 1000;
81 		lock = true;
82         if(centralMinter != 0) owner = centralMinter;
83 		initialized[owner] = true;
84 		balances[owner] = totalSupply;
85     }
86 
87     function setDrop(bool _open) public onlyOwner {
88         drop = _open;
89     }
90 	
91     function setAirDrop(uint256 _dropStart, uint256 _dropEnd, uint256 _airDrop, uint256 _totalDrop) public onlyOwner {
92 		dropStart = _dropStart;
93 		dropEnd = _dropEnd;
94         airDrop = _airDrop;
95         totalDrop = _totalDrop;
96     }
97 	
98 	function setExchange(uint256 _exchangeStart, uint256 _exchangeEnd, uint256 _sellPrice, uint256 _buyPrice) public onlyOwner {
99         exchangeStart = _exchangeStart;
100 		exchangeEnd = _exchangeEnd;
101 		sellPrice = _sellPrice;
102         buyPrice = _buyPrice;
103     }
104 	
105 	function setLock(bool _lock) public onlyOwner {
106         lock = _lock;
107     }
108 	
109 	function setSellToContract(bool _sellToContract) public onlyOwner {
110         sellToContract = _sellToContract;
111     }
112 	
113 	function setMinEther(uint256 _minimumEtherInFinney) public onlyOwner {
114 		minEtherForAccounts = _minimumEtherInFinney * 1 finney;
115 	}
116 	
117 	function setMonthClose(uint256 _month, bool _value) public onlyOwner {
118 		monthOpen[_month] = _value;
119     }
120 	
121 	function setMonthOpen(uint256 _month, uint256 _users, uint8 _powers, uint256 _minToken, uint256 _count) public onlyOwner {
122         monthOpen[_month] = true;
123 		users = _users;
124 		minToken = _minToken;
125 		count = _count;
126         if(_powers > 0){
127             powers = _powers;
128         }
129     }
130 	    
131     function lockAccount(address _address, uint256 _lockEnd) public onlyOwner {
132         frozens[_address] = _lockEnd;
133         emit FrozenFunds(_address, _lockEnd);
134     }
135 		
136 	function _freezeFunds(address _address, uint256 _freeze, uint256 _freezeEnd) internal {
137 		if(drop){
138 		    initialize(_address);
139 		}
140         frozenNum[_address] = _freeze;
141 		frozenEnd[_address] = _freezeEnd;
142         emit FrozenMyFunds(_address, _freeze, _freezeEnd);
143     }
144 	
145 	function freezeUserFunds(address _address, uint256 _freeze, uint256 _freezeEnd) public onlyOwner {
146         _freezeFunds(_address, _freeze, _freezeEnd);
147     }
148 	
149 	function freezeMyFunds(uint256 _freeze, uint256 _freezeEnd) public {
150         _freezeFunds(msg.sender, _freeze, _freezeEnd);
151     }
152     
153     function initialize(address _address) internal returns (uint256) {
154 		require (drop);
155 		require (now > frozens[_address]);
156 		if(dropStart != dropEnd && dropEnd > 0){
157 			require (now >= dropStart && now <=dropEnd);
158 		}
159         require (balances[owner] > airDrop);
160         if(currentDrop + airDrop < totalDrop && !initialized[_address]){
161             initialized[_address] = true;
162             _transfer(owner, msg.sender, airDrop);
163             currentDrop += airDrop;
164             return balances[_address];
165         }
166     }
167 	
168 	function getMonth(uint256 _month) public returns (uint256) {
169 		require (count > 0);
170 		require (now > frozens[msg.sender]);
171 		require (balances[msg.sender] >= minToken);
172 	    require (monthOpen[_month]);
173 	    require (!monthPower[_month][msg.sender]);
174 		if(drop){
175 		    initialize(msg.sender);
176 		}
177 	    uint256 _mpower = totalSupply * powers / 100 / users;
178 	    require (balances[owner] >= _mpower);
179 		monthPower[_month][msg.sender] = true;
180 		_transfer(owner, msg.sender, _mpower);
181 		count -= 1;
182         return _mpower;
183     }
184     
185     function balanceOf(address _address) public view returns(uint256){
186         return getBalances(_address);
187     }
188     
189     function getBalances(address _address) view internal returns (uint256) {
190         if (drop && now > frozens[_address] && currentDrop + airDrop < totalDrop && !initialized[_address]) {
191             return balances[_address] + airDrop;
192         }else {
193             return balances[_address];
194         }
195     }
196     
197     function takeEther(uint256 _balance) public payable onlyOwner {
198          owner.transfer(_balance);
199     }
200     
201     function () payable public {}
202     
203     function giveEther() public payable {
204     }
205     
206     function getEther(address _address) public view returns(uint256){
207         return _address.balance;
208     }
209 	
210 	function getTime() public view returns(uint256){
211         return now;
212     }
213     
214     function mintToken(address _address, uint256 _mintedAmount) public onlyOwner {
215         require(balances[_address] + _mintedAmount > balances[_address]);
216         require(totalSupply + _mintedAmount > totalSupply);
217         balances[_address] += _mintedAmount;
218         totalSupply += _mintedAmount;
219         emit Transfer(0, this, _mintedAmount);
220         emit Transfer(this, _address, _mintedAmount);
221     }
222     
223     /* Internal transfer, can only be called by this contract */
224     function _transfer(address _from, address _to, uint256 _value) internal {
225 		if(_from != owner){
226 			require (!lock);
227 		}
228         require (_to != 0x0);
229 		require (_from != _to);
230         require (now > frozens[_from]);
231 		require (now > frozens[_to]);
232 		if(drop){
233 		    initialize(_from);
234             initialize(_to);
235 		}
236 		if(now <= frozenEnd[_from]){
237 			require (balances[_from] - frozenNum[_from] >= _value);
238 		}else{
239 			require (balances[_from] >= _value);
240 		}
241         require (balances[_to] + _value > balances[_to]);
242         if(sellToContract && msg.sender.balance < minEtherForAccounts){
243             sell((minEtherForAccounts - msg.sender.balance) / sellPrice);
244         }
245         balances[_from] -= _value;
246         balances[_to] += _value;
247         
248         emit Transfer(_from, _to, _value);
249         
250     }
251     
252     function transfer(address _to, uint256  _value) public {
253         _transfer(msg.sender, _to, _value);
254     }
255     
256     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
257 		require (now > frozens[msg.sender]);
258         require(_value <= allowance[_from][msg.sender]);
259 		_transfer(_from, _to, _value);
260         allowance[_from][msg.sender] -= _value;
261         return true;
262     }
263     
264     function approve(address _spender, uint256 _value) public returns (bool success){
265 		require (!lock);
266 		if(drop){
267     		initialize(msg.sender);
268             initialize(_spender);
269 		}
270         require(msg.sender != _spender);
271 		require (now > frozens[msg.sender]);
272 		if(now <= frozenEnd[msg.sender]){
273 			require (balances[msg.sender] - frozenNum[msg.sender] >= _value);
274 		}else{
275 			require (balances[msg.sender] >= _value);
276 		}
277         allowance[msg.sender][_spender] = _value;
278         return true;
279     }
280     
281     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
282     public
283     returns (bool success) {
284 		require (!lock);
285         tokenRecipient spender = tokenRecipient(_spender);
286         if (approve(_spender, _value)) {
287             spender.receiveApproval(msg.sender, _value, this, _extraData);
288             return true;
289         }
290     }
291 
292     function burn(uint256 _value) public returns (bool success) {
293 		require (!lock);
294         require(_value > 0);
295 		require (now > frozens[msg.sender]);
296 		if(now <= frozenEnd[msg.sender]){
297 			require (balances[msg.sender] - frozenNum[msg.sender] >= _value);
298 		}else{
299 			require (balances[msg.sender] >= _value);
300 		}
301         balances[msg.sender] -= _value;
302         totalSupply -= _value;
303         emit Burn(msg.sender, _value);
304         return true;
305     }
306     
307     function burnFrom(address _from, uint256 _value) public returns (bool success) {
308 		require (!lock);
309         require(_value > 0);
310 		require (now > frozens[msg.sender]);
311 		require (now > frozens[_from]);
312 		if(now <= frozenEnd[_from]){
313 			require (balances[_from] - frozenNum[_from] >= _value);
314 		}else{
315 			require (balances[_from] >= _value);
316 		}
317         require(_value <= allowance[_from][msg.sender]);
318         balances[_from] -= _value;
319         allowance[_from][msg.sender] -= _value;
320         totalSupply -= _value;
321         emit Burn(_from, _value);
322         return true;
323     }
324 
325     function buy() public payable{
326         require (!lock);
327         if(drop){
328             initialize(msg.sender);
329         }
330 		if(exchangeStart != exchangeEnd && exchangeEnd > 0){
331 			require (now >= exchangeStart && now <=exchangeEnd);
332 		}
333         uint256 _amount = msg.value / buyPrice;
334         _transfer(owner, msg.sender, _amount);
335     }
336     
337     function sell(uint256 _amount) public {
338 		require (!lock);
339 		require (sellToContract);
340 		require (now > frozens[msg.sender]);
341         require(_amount > 0);
342 		if(exchangeStart != exchangeEnd && exchangeEnd > 0){
343 			require (now >= exchangeStart && now <=exchangeEnd);
344 		}
345 		if(now <= frozenEnd[msg.sender]){
346 			require (balances[msg.sender] - frozenNum[msg.sender] >= _amount);
347 		}else{
348 			require (balances[msg.sender] >= _amount);
349 		}
350         require(contractAddress.balance >= _amount * sellPrice);
351         _transfer(msg.sender, contractAddress, _amount);
352         msg.sender.transfer(_amount * sellPrice);
353     }
354     
355 }
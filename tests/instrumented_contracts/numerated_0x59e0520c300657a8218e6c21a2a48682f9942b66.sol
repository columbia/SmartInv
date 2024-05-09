1 pragma solidity ^0.4.24;
2 //ERC20
3 contract ERC20Ownable {
4     address public owner;
5 
6     function ERC20Ownable() public{
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     function transferOwnership(address newOwner) onlyOwner public{
15         if (newOwner != address(0)) {
16             owner = newOwner;
17         }
18     }
19 }
20 contract ERC20 {
21     function transfer(address to, uint256 value) public returns (bool);
22     function balanceOf(address who) public view returns (uint256);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 
26 contract ERC20Token is ERC20,ERC20Ownable {
27     
28     mapping (address => uint256) balances;
29 	mapping (address => mapping (address => uint256)) allowed;
30 	
31     event Transfer(
32 		address indexed _from,
33 		address indexed _to,
34 		uint256 _value
35 		);
36 
37 	event Approval(
38 		address indexed _owner,
39 		address indexed _spender,
40 		uint256 _value
41 		);
42 		
43 	//Fix for short address attack against ERC20
44 	modifier onlyPayloadSize(uint size) {
45 		assert(msg.data.length == size + 4);
46 		_;
47 	}
48 
49 	function balanceOf(address _owner) constant public returns (uint256) {
50 		return balances[_owner];
51 	}
52 
53 	function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) public returns (bool){
54 		require(balances[msg.sender] >= _value && _value > 0);
55 	    balances[msg.sender] -= _value;
56 	    balances[_to] += _value;
57 	    emit Transfer(msg.sender, _to, _value);
58 	    return true;
59     }
60 
61 	function transferFrom(address _from, address _to, uint256 _value) public {
62 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
63         balances[_to] += _value;
64         balances[_from] -= _value;
65         allowed[_from][msg.sender] -= _value;
66         emit Transfer(_from, _to, _value);
67     }
68 
69 	function approve(address _spender, uint256 _value) public {
70 		allowed[msg.sender][_spender] = _value;
71 		emit Approval(msg.sender, _spender, _value);
72 	}
73 
74     /* Approves and then calls the receiving contract */
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
79         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
80         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
81         //require(_spender.call(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")), abi.encode(msg.sender, _value, this, _extraData)));
82         require(_spender.call(abi.encodeWithSelector(bytes4(keccak256("receiveApproval(address,uint256,address,bytes)")),msg.sender, _value, this, _extraData)));
83 
84         return true;
85     }
86     
87 	function allowance(address _owner, address _spender) constant public returns (uint256) {
88 		return allowed[_owner][_spender];
89 	}
90 }
91 
92 contract ERC20StandardToken is ERC20Token {
93 	uint256 public totalSupply;
94 	string public name;
95 	uint256 public decimals;
96 	string public symbol;
97 	bool public mintable;
98 
99 
100     function ERC20StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {
101         require(_owner != address(0));
102         owner = _owner;
103 		decimals = _decimals;
104 		symbol = _symbol;
105 		name = _name;
106 		mintable = _mintable;
107         totalSupply = _totalSupply;
108         balances[_owner] = totalSupply;
109     }
110     
111     function mint(uint256 amount) onlyOwner public {
112 		require(mintable);
113 		require(amount >= 0);
114 		balances[msg.sender] += amount;
115 		totalSupply += amount;
116 	}
117 
118     function burn(uint256 _value) onlyOwner public returns (bool) {
119         require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);
120         balances[msg.sender] -= _value;
121         totalSupply -= _value;
122         emit Transfer(msg.sender, 0x0, _value);
123         return true;
124     }
125 }
126 pragma solidity ^0.4.24;
127 //ERC223
128 contract ERC223Ownable {
129     address public owner;
130 
131     function ERC223Ownable() public{
132         owner = msg.sender;
133     }
134 
135     modifier onlyOwner {
136         require(msg.sender == owner);
137         _;
138     }
139     function transferOwnership(address newOwner) onlyOwner public{
140         if (newOwner != address(0)) {
141             owner = newOwner;
142         }
143     }
144 }
145 
146 contract ContractReceiver {
147      
148     struct TKN {
149         address sender;
150         uint value;
151         bytes data;
152         bytes4 sig;
153     }
154     
155     function tokenFallback(address _from, uint _value, bytes _data) public pure {
156       TKN memory tkn;
157       tkn.sender = _from;
158       tkn.value = _value;
159       tkn.data = _data;
160       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
161       tkn.sig = bytes4(u);
162       
163       /* tkn variable is analogue of msg variable of Ether transaction
164       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
165       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
166       *  tkn.data is data of token transaction   (analogue of msg.data)
167       *  tkn.sig is 4 bytes signature of function
168       *  if data of token transaction is a function execution
169       */
170     }
171 }
172 
173 contract ERC223 {
174   uint public totalSupply;
175   function balanceOf(address who) public view returns (uint);
176 
177   function transfer(address to, uint value) public returns (bool ok);
178   function transfer(address to, uint value, bytes data) public returns (bool ok);
179   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
180 
181   event Transfer(address indexed from, address indexed to, uint value);
182   event Transfer(address indexed from, address indexed to, uint value, bytes data);
183 }
184 
185 contract SafeMath {
186     uint256 constant public MAX_UINT256 =
187     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
188 
189     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
190         if (x > MAX_UINT256 - y) revert();
191         return x + y;
192     }
193 
194     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
195         if (x < y) revert();
196         return x - y;
197     }
198 
199     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
200         if (y == 0) return 0;
201         if (x > MAX_UINT256 / y) revert();
202         return x * y;
203     }
204 }
205 
206 contract ERC223Token is ERC223, SafeMath {
207 
208   mapping(address => uint) balances;
209 
210   string public name;
211   string public symbol;
212   uint256 public decimals;
213   uint256 public totalSupply;
214   bool public mintable;
215 
216 
217 
218   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
219 
220     if(isContract(_to)) {
221         if (balanceOf(msg.sender) < _value) revert();
222         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
223         balances[_to] = safeAdd(balanceOf(_to), _value);
224         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
225         emit Transfer(msg.sender, _to, _value);
226         emit Transfer(msg.sender, _to, _value, _data);
227         return true;
228     }
229     else {
230         return transferToAddress(_to, _value, _data);
231     }
232 }
233 
234 
235 function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
236 
237     if(isContract(_to)) {
238         return transferToContract(_to, _value, _data);
239     }
240     else {
241         return transferToAddress(_to, _value, _data);
242     }
243 }
244 
245   function transfer(address _to, uint _value) public returns (bool success) {
246 
247     //standard function transfer similar to ERC20 transfer with no _data
248     //added due to backwards compatibility reasons
249     bytes memory empty;
250     if(isContract(_to)) {
251         return transferToContract(_to, _value, empty);
252     }
253     else {
254         return transferToAddress(_to, _value, empty);
255     }
256 }
257 
258   function isContract(address _addr) private view returns (bool is_contract) {
259       uint length;
260       assembly {
261             //retrieve the size of the code on target address, this needs assembly
262             length := extcodesize(_addr)
263       }
264       return (length>0);
265     }
266 
267   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
268     if (balanceOf(msg.sender) < _value) revert();
269     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
270     balances[_to] = safeAdd(balanceOf(_to), _value);
271     emit Transfer(msg.sender, _to, _value);
272     emit Transfer(msg.sender, _to, _value, _data);
273     return true;
274   }
275 
276   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
277     if (balanceOf(msg.sender) < _value) revert();
278     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
279     balances[_to] = safeAdd(balanceOf(_to), _value);
280     ContractReceiver receiver = ContractReceiver(_to);
281     receiver.tokenFallback(msg.sender, _value, _data);
282     emit Transfer(msg.sender, _to, _value);
283     emit Transfer(msg.sender, _to, _value, _data);
284     return true;
285 }
286 
287 
288   function balanceOf(address _owner) public view returns (uint balance) {
289     return balances[_owner];
290   }
291 }
292 
293 contract ERC223StandardToken is ERC223Token,ERC223Ownable {
294     
295     function ERC223StandardToken(address _owner, string _name, string _symbol, uint256 _decimals, uint256 _totalSupply, bool _mintable) public {
296         
297         require(_owner != address(0));
298         owner = _owner;
299 		decimals = _decimals;
300 		symbol = _symbol;
301 		name = _name;
302 		mintable = _mintable;
303         totalSupply = _totalSupply;
304         balances[_owner] = totalSupply;
305         emit Transfer(address(0), _owner, totalSupply);
306         emit Transfer(address(0), _owner, totalSupply, "");
307     }
308   
309     function mint(uint256 amount) onlyOwner public {
310 		require(mintable);
311 		require(amount >= 0);
312 		balances[msg.sender] += amount;
313 		totalSupply += amount;
314 	}
315 
316     function burn(uint256 _value) onlyOwner public returns (bool) {
317         require(balances[msg.sender] >= _value  && totalSupply >=_value && _value > 0);
318         balances[msg.sender] -= _value;
319         totalSupply -= _value;
320         emit Transfer(msg.sender, 0x0, _value);
321         return true;
322     }
323 }
324 pragma solidity ^0.4.24;
325 contract Ownable {
326     address public owner;
327 
328     function Ownable() public{
329         owner = msg.sender;
330     }
331 
332     modifier onlyOwner {
333         require(msg.sender == owner);
334         _;
335     }
336     function transferOwnership(address newOwner) onlyOwner public{
337         if (newOwner != address(0)) {
338             owner = newOwner;
339         }
340     }
341 }
342 //TokenMaker
343 contract TokenMaker is Ownable{
344     
345 	event LogERC20TokenCreated(ERC20StandardToken token);
346 	event LogERC223TokenCreated(ERC223StandardToken token);
347 
348     address public receiverAddress;
349     uint public txFee = 0.1 ether;
350     uint public VIPFee = 1 ether;
351 
352     /* VIP List */
353     mapping(address => bool) public vipList;
354 	uint public numContracts;
355 
356     mapping(uint => address) public deployedContracts;
357 	mapping(address => address[]) public userDeployedContracts;
358 
359     function () payable public{}
360 
361     function getBalance(address _tokenAddress,uint _type) onlyOwner public {
362       address _receiverAddress = getReceiverAddress();
363       if(_tokenAddress == address(0)){
364           require(_receiverAddress.send(address(this).balance));
365           return;
366       }
367       if(_type == 0){
368           ERC20 erc20 = ERC20(_tokenAddress);
369           uint256 balance = erc20.balanceOf(this);
370           erc20.transfer(_receiverAddress, balance);
371       }else{
372           ERC223 erc223 = ERC223(_tokenAddress);
373           uint256 erc223_balance = erc223.balanceOf(this);
374           erc223.transfer(_receiverAddress, erc223_balance);
375       }
376     }
377     
378     //Register VIP
379     function registerVIP() payable public {
380       require(msg.value >= VIPFee);
381       address _receiverAddress = getReceiverAddress();
382       require(_receiverAddress.send(msg.value));
383       vipList[msg.sender] = true;
384     }
385 
386 
387     function addToVIPList(address[] _vipList) onlyOwner public {
388         for (uint i =0;i<_vipList.length;i++){
389             vipList[_vipList[i]] = true;
390         }
391     }
392 
393 
394     function removeFromVIPList(address[] _vipList) onlyOwner public {
395         for (uint i =0;i<_vipList.length;i++){
396         vipList[_vipList[i]] = false;
397         }
398    }
399 
400     function isVIP(address _addr) public view returns (bool) {
401         return _addr == owner || vipList[_addr];
402     }
403 
404 
405     function setReceiverAddress(address _addr) onlyOwner public {
406         require(_addr != address(0));
407         receiverAddress = _addr;
408     }
409 
410     function getReceiverAddress() public view returns  (address){
411         if(receiverAddress == address(0)){
412             return owner;
413         }
414 
415         return receiverAddress;
416     }
417 
418     function setVIPFee(uint _fee) onlyOwner public {
419         VIPFee = _fee;
420     }
421 
422 
423     function setTxFee(uint _fee) onlyOwner public {
424         txFee = _fee;
425     }
426 
427     function getUserCreatedTokens(address _owner) public view returns  (address[]){
428         return userDeployedContracts[_owner];
429     }
430     
431     function create(string _name, string _symbol, uint256 _decimals, uint256 _totalSupply,  bool _mintable,uint256 _type) payable public returns(address a){
432          //check the tx fee
433         uint sendValue = msg.value;
434         address from = msg.sender;
435 	    bool vip = isVIP(from);
436         if(!vip){
437 		    require(sendValue >= txFee);
438         }
439         
440         address[] userAddresses = userDeployedContracts[from];
441 
442         if(_type == 0){
443             ERC20StandardToken erc20Token = new ERC20StandardToken(from, _name, _symbol, _decimals, _totalSupply, _mintable);
444             userAddresses.push(erc20Token);
445             userDeployedContracts[from] = userAddresses;
446             deployedContracts[numContracts] = erc20Token;
447             numContracts++;
448             emit LogERC20TokenCreated(erc20Token);
449 	        return erc20Token;
450         }else{
451             ERC223StandardToken erc223Token = new ERC223StandardToken(from, _name, _symbol, _decimals, _totalSupply, _mintable);
452             userAddresses.push(erc223Token);
453             userDeployedContracts[from] = userAddresses;
454             deployedContracts[numContracts] = erc223Token;
455             numContracts++;
456             emit LogERC223TokenCreated(erc223Token);
457 	        return erc223Token;
458         }
459         
460      }
461     
462 }
1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable contract - base contract with an owner
5  */
6 contract Ownable {
7   
8   address public owner;
9   address public newOwner;
10 
11   event OwnershipTransferred(address _from, address _to);
12   
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     assert(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param _newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address _newOwner) public onlyOwner {
34     assert(_newOwner != address(0));      
35     newOwner = _newOwner;
36   }
37 
38   /**
39    * @dev Accept transferOwnership.
40    */
41   function acceptOwnership() public {
42     if (msg.sender == newOwner) {
43       emit OwnershipTransferred(owner, newOwner);
44       owner = newOwner;
45     }
46   }
47 }
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that throw on error
52  */
53 contract SafeMath {
54 
55   function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
56     uint256 z = x - y;
57     assert(z <= x);
58 	  return z;
59   }
60 
61   function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
62     uint256 z = x + y;
63 	  assert(z >= x);
64 	  return z;
65   }
66 	
67   function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
68     uint256 z = x / y;
69     return z;
70   }
71 	
72   function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {
73     uint256 z = x * y;
74     assert(x == 0 || z / x == y);
75     return z;
76   }
77 
78   function min(uint256 x, uint256 y) internal pure returns (uint256) {
79     uint256 z = x <= y ? x : y;
80     return z;
81   }
82 
83   function max(uint256 x, uint256 y) internal pure returns (uint256) {
84     uint256 z = x >= y ? x : y;
85     return z;
86   }
87 }
88 
89  /* New ERC23 contract interface */
90 contract ERC223 {
91   uint public totalSupply;
92   function balanceOf(address who) public view returns (uint);
93   
94   function name() public view returns (string _name);
95   function symbol() public view returns (string _symbol);
96   function decimals() public view returns (uint256 _decimals);
97   function totalSupply() public view returns (uint256 _supply);
98 
99   function transfer(address to, uint value) public returns (bool ok);
100   function transfer(address to, uint value, bytes data) public returns (bool ok);
101   
102   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
103 }
104 
105 contract ContractReceiver {
106     function tokenFallback(address _from, uint _value, bytes _data) public returns (bool success);
107 }
108 
109 
110 contract ERC223Token is ERC223,SafeMath ,Ownable {
111 
112   mapping(address => uint) balances;
113   
114   string public name;
115   string public symbol;
116   uint256 public decimals;
117   uint256 public totalSupply;
118   
119   address public crowdsaleAgent;
120   address[] public addrCotracts;
121   bool public released = false;  
122   mapping(address => bool) public privilegedAddr;
123   bool public privilege = false;
124   
125   /**
126    * @dev The function can be called only by crowdsale agent.
127    */
128   modifier onlyCrowdsaleAgent() {
129     assert(msg.sender == crowdsaleAgent);
130     _;
131   }
132   
133   /**
134    * @dev Limit token transfer until the crowdsale is over.
135    */
136   modifier canTransfer() {
137     if(msg.sender != address(this)){
138       if(!released){
139         if(!privilege){
140           revert();
141         }else if(!privilegedAddr[msg.sender]){
142           revert();
143         }
144       }
145     }
146     _;
147   } 
148   
149   // Function to access name of token .
150   function name() public view returns (string _name) {
151       return name;
152   }
153   // Function to access symbol of token .
154   function symbol() public view returns (string _symbol) {
155       return symbol;
156   }
157   // Function to access decimals of token .
158   function decimals() public view returns (uint256 _decimals) {
159       return decimals;
160   }
161   // Function to access total supply of tokens .
162   function totalSupply() public view returns (uint256 _totalSupply) {
163       return totalSupply;
164   }
165   
166   
167   // Function that is called when a user or another contract wants to transfer funds .
168   function transfer(address _to, uint _value, bytes _data) public canTransfer returns (bool success) {
169     if(isContract(_to)) {
170         return transferToContract(_to, _value, _data);
171     }
172     else {
173         return transferToAddress(_to, _value, _data);
174     }
175   }
176   
177   // Standard function transfer similar to ERC20 transfer with no _data .
178   // Added due to backwards compatibility reasons .
179   function transfer(address _to, uint _value) public canTransfer returns (bool success) {
180     //standard function transfer similar to ERC20 transfer with no _data
181     //added due to backwards compatibility reasons
182     bytes memory empty;
183     if(isContract(_to)) {
184         return transferToContract(_to, _value, empty);
185     }
186     else {
187         return transferToAddress(_to, _value, empty);
188     }
189   }
190 
191   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
192   function isContract(address _addr) private view returns (bool is_contract) {
193       uint length;
194       assembly {
195             //retrieve the size of the code on target address, this needs assembly
196             length := extcodesize(_addr)
197       }
198       return (length>0);
199     }
200 
201   //function that is called when transaction target is an address
202   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
203     if (balanceOf(msg.sender) < _value) revert();
204     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
205     balances[_to] = safeAdd(balanceOf(_to), _value);
206     emit Transfer(msg.sender, _to, _value, _data);
207     return true;
208   }
209   
210   //function that is called when transaction target is a contract
211   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
212     if (balanceOf(msg.sender) < _value) revert();
213     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
214     bool flag = false;
215     for(uint i = 0; i < addrCotracts.length; i++) {
216       if(_to == addrCotracts[i]) flag = true;
217     }
218     if(flag){
219       balances[this] = safeAdd(balanceOf(this), _value);
220     }else{
221       balances[_to] = safeAdd(balanceOf(_to), _value);
222     }
223     ContractReceiver receiver = ContractReceiver(_to);
224     if(receiver.tokenFallback(msg.sender, _value, _data)){
225       emit Transfer(msg.sender, _to, _value, _data);
226       return true;
227     }else{
228       revert();
229     }
230     if(flag){
231       emit Transfer(msg.sender, this, _value, _data);
232     }else{
233       emit Transfer(msg.sender, _to, _value, _data);
234     }
235     return true;
236 }
237 
238   function balanceOf(address _owner) public view returns (uint balance) {
239     return balances[_owner];
240   }
241   
242   /** 
243    * @dev Create new tokens and allocate them to an address. Only callably by a crowdsale agent
244    * @param _to dest address
245    * @param _value tokens amount
246    * @return mint result
247    */ 
248   function mint(address _to, uint _value, bytes _data) public onlyCrowdsaleAgent returns (bool success) {
249     totalSupply = safeAdd(totalSupply, _value);
250     balances[_to] = safeAdd(balances[_to], _value);
251     emit Transfer(0, _to, _value, _data);
252     return true;
253   }
254 
255   /**
256    * @dev Set the crowdsale Agent
257    * @param _crowdsaleAgent crowdsale contract address
258    */
259   function setCrowdsaleAgent(address _crowdsaleAgent) public onlyOwner {
260     crowdsaleAgent = _crowdsaleAgent;
261   }
262   
263   /**
264    * @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. 
265    */
266   function releaseTokenTransfer() public onlyCrowdsaleAgent {
267     released = true;
268   }
269   
270   function releasePrivilege() public onlyCrowdsaleAgent {
271     privilege = true;
272   }
273   
274   function setAddrForPrivilege(address _owner) public onlyCrowdsaleAgent {
275     privilegedAddr[_owner] = true;
276   }
277   
278   function getAddrForPrivilege(address _owner) public view returns (bool success){
279     return privilegedAddr[_owner];
280   }
281 
282 }
283 
284 /** 
285  * @title Oil-T contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
286  */
287 contract OilToken is ERC223Token{
288   
289   /**
290    * @dev The function can be called only by agent.
291    */
292   modifier onlyAgent() {
293     bool flag = false;
294     for(uint i = 0; i < addrCotracts.length; i++) {
295       if(msg.sender == addrCotracts[i]) flag = true;
296     }
297    assert(flag);
298     _;
299   }
300 
301   /** Name and symbol were updated. */
302   event UpdatedTokenInformation(string newName, string newSymbol);
303   
304   /**
305    * @param _name Token name
306    * @param _symbol Token symbol - should be all caps
307    * @param _decimals Number of decimal places
308    */
309    
310   function OilToken(string _name, string _symbol, uint256 _decimals) public {
311     name = _name;
312     symbol = _symbol;
313     decimals = _decimals;
314   }   
315   
316    function tokenFallback(address _from, uint _value, bytes _data) public onlyAgent returns (bool success){
317     balances[this] = safeSub(balanceOf(this), _value);
318     balances[_from] = safeAdd(balanceOf(_from), _value);
319     emit Transfer(this, _from, _value, _data);
320     return true;
321   }
322   
323   /**
324    * Owner can update token information here.
325    *
326    * It is often useful to conceal the actual token association, until
327    * the token operations, like central issuance or reissuance have been completed.
328    *
329    * This function allows the token owner to rename the token after the operations
330    * have been completed and then point the audience to use the token contract.
331    */
332   function setTokenInformation(string _name, string _symbol) public onlyOwner {
333     name = _name;
334     symbol = _symbol;
335     emit UpdatedTokenInformation(name, symbol);
336   }
337   
338   function setAddr (address _addr) public onlyOwner {
339     addrCotracts.push(_addr);
340   }
341  
342   function transferForICO(address _to, uint _value) public onlyCrowdsaleAgent returns (bool success) {
343     return this.transfer(_to, _value);
344   }
345  
346   function delAddr (uint number) public onlyOwner {
347     require(number < addrCotracts.length);
348     for(uint i = number; i < addrCotracts.length-1; i++) {
349       addrCotracts[i] = addrCotracts[i+1];
350     }
351     addrCotracts.length = addrCotracts.length-1;
352   }
353 }
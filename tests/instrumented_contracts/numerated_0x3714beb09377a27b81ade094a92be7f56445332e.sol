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
122   
123   /**
124    * @dev The function can be called only by crowdsale agent.
125    */
126   modifier onlyCrowdsaleAgent() {
127     assert(msg.sender == crowdsaleAgent);
128     _;
129   }
130   
131   /**
132    * @dev Limit token transfer until the crowdsale is over.
133    */
134   modifier canTransfer() {
135     if(msg.sender != address(this)){
136       if(!released){
137         revert();
138       }
139     }
140     _;
141   } 
142   
143   // Function to access name of token .
144   function name() public view returns (string _name) {
145       return name;
146   }
147   // Function to access symbol of token .
148   function symbol() public view returns (string _symbol) {
149       return symbol;
150   }
151   // Function to access decimals of token .
152   function decimals() public view returns (uint256 _decimals) {
153       return decimals;
154   }
155   // Function to access total supply of tokens .
156   function totalSupply() public view returns (uint256 _totalSupply) {
157       return totalSupply;
158   }
159   
160   
161   // Function that is called when a user or another contract wants to transfer funds .
162   function transfer(address _to, uint _value, bytes _data) public canTransfer returns (bool success) {
163     if(isContract(_to)) {
164         return transferToContract(_to, _value, _data);
165     }
166     else {
167         return transferToAddress(_to, _value, _data);
168     }
169   }
170   
171   // Standard function transfer similar to ERC20 transfer with no _data .
172   // Added due to backwards compatibility reasons .
173   function transfer(address _to, uint _value) public canTransfer returns (bool success) {
174     //standard function transfer similar to ERC20 transfer with no _data
175     //added due to backwards compatibility reasons
176     bytes memory empty;
177     if(isContract(_to)) {
178         return transferToContract(_to, _value, empty);
179     }
180     else {
181         return transferToAddress(_to, _value, empty);
182     }
183   }
184 
185   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
186   function isContract(address _addr) private view returns (bool is_contract) {
187       uint length;
188       assembly {
189             //retrieve the size of the code on target address, this needs assembly
190             length := extcodesize(_addr)
191       }
192       return (length>0);
193     }
194 
195   //function that is called when transaction target is an address
196   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
197     if (balanceOf(msg.sender) < _value) revert();
198     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
199     balances[_to] = safeAdd(balanceOf(_to), _value);
200     emit Transfer(msg.sender, _to, _value, _data);
201     return true;
202   }
203   
204   //function that is called when transaction target is a contract
205   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
206     if (balanceOf(msg.sender) < _value) revert();
207     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
208     bool flag = false;
209     for(uint i = 0; i < addrCotracts.length; i++) {
210       if(_to == addrCotracts[i]) flag = true;
211     }
212     if(flag){
213       balances[this] = safeAdd(balanceOf(this), _value);
214     }else{
215       balances[_to] = safeAdd(balanceOf(_to), _value);
216     }
217     ContractReceiver receiver = ContractReceiver(_to);
218     if(receiver.tokenFallback(msg.sender, _value, _data)){
219       emit Transfer(msg.sender, _to, _value, _data);
220       return true;
221     }else{
222       revert();
223     }
224     if(flag){
225       emit Transfer(msg.sender, this, _value, _data);
226     }else{
227       emit Transfer(msg.sender, _to, _value, _data);
228     }
229     return true;
230 }
231 
232   function balanceOf(address _owner) public view returns (uint balance) {
233     return balances[_owner];
234   }
235   
236   /** 
237    * @dev Create new tokens and allocate them to an address. Only callably by a crowdsale agent
238    * @param _to dest address
239    * @param _value tokens amount
240    * @return mint result
241    */ 
242   function mint(address _to, uint _value, bytes _data) public onlyCrowdsaleAgent returns (bool success) {
243     totalSupply = safeAdd(totalSupply, _value);
244     balances[_to] = safeAdd(balances[_to], _value);
245     emit Transfer(0, _to, _value, _data);
246     return true;
247   }
248 
249   /**
250    * @dev Set the crowdsale Agent
251    * @param _crowdsaleAgent crowdsale contract address
252    */
253   function setCrowdsaleAgent(address _crowdsaleAgent) public onlyOwner {
254     crowdsaleAgent = _crowdsaleAgent;
255   }
256   
257   /**
258    * @dev One way function to release the tokens to the wild. Can be called only from the release agent that is the final ICO contract. 
259    */
260   function releaseTokenTransfer() public onlyCrowdsaleAgent {
261     released = true;
262   }
263 
264 }
265 
266 /** 
267  * @title GoldVein contract - standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
268  */
269 contract GoldVein is ERC223Token{
270   
271   /**
272    * @dev The function can be called only by agent.
273    */
274   modifier onlyAgent() {
275     bool flag = false;
276     for(uint i = 0; i < addrCotracts.length; i++) {
277       if(msg.sender == addrCotracts[i]) flag = true;
278     }
279    assert(flag);
280     _;
281   }
282 
283   /** Name and symbol were updated. */
284   event UpdatedTokenInformation(string newName, string newSymbol);
285   
286   /**
287    * @param _name Token name
288    * @param _symbol Token symbol - should be all caps
289    * @param _decimals Number of decimal places
290    */
291    
292   function GoldVein(string _name, string _symbol, uint256 _decimals) public {
293     name = _name;
294     symbol = _symbol;
295     decimals = _decimals;
296   }   
297   
298    function tokenFallback(address _from, uint _value, bytes _data) public onlyAgent returns (bool success){
299     balances[this] = safeSub(balanceOf(this), _value);
300     balances[_from] = safeAdd(balanceOf(_from), _value);
301     emit Transfer(this, _from, _value, _data);
302     return true;
303   }
304   
305   /**
306    * Owner can update token information here.
307    *
308    * It is often useful to conceal the actual token association, until
309    * the token operations, like central issuance or reissuance have been completed.
310    *
311    * This function allows the token owner to rename the token after the operations
312    * have been completed and then point the audience to use the token contract.
313    */
314   function setTokenInformation(string _name, string _symbol) public onlyOwner {
315     name = _name;
316     symbol = _symbol;
317     emit UpdatedTokenInformation(name, symbol);
318   }
319   
320   function setAddr (address _addr) public onlyOwner {
321     addrCotracts.push(_addr);
322   }
323  
324   function transferForICO(address _to, uint _value) public onlyCrowdsaleAgent returns (bool success) {
325     return this.transfer(_to, _value);
326   }
327  
328   function delAddr (uint number) public onlyOwner {
329     require(number < addrCotracts.length);
330     for(uint i = number; i < addrCotracts.length-1; i++) {
331       addrCotracts[i] = addrCotracts[i+1];
332     }
333     addrCotracts.length = addrCotracts.length-1;
334   }
335 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC223 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/223
6  */
7 interface ERC223I {
8 
9   function balanceOf(address _owner) external view returns (uint balance);
10   
11   function name() external view returns (string _name);
12   function symbol() external view returns (string _symbol);
13   function decimals() external view returns (uint8 _decimals);
14   function totalSupply() external view returns (uint256 supply);
15 
16   function transfer(address to, uint value) external returns (bool ok);
17   function transfer(address to, uint value, bytes data) external returns (bool ok);
18   function transfer(address to, uint value, bytes data, string custom_fallback) external returns (bool ok);
19 
20   function releaseTokenTransfer() external;
21   
22   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);  
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 contract SafeMath {
30 
31     /**
32     * @dev Subtracts two numbers, reverts on overflow.
33     */
34     function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
35         assert(y <= x);
36         uint256 z = x - y;
37         return z;
38     }
39 
40     /**
41     * @dev Adds two numbers, reverts on overflow.
42     */
43     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256) {
44         uint256 z = x + y;
45         assert(z >= x);
46         return z;
47     }
48 	
49 	/**
50     * @dev Integer division of two numbers, reverts on division by zero.
51     */
52     function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
53         uint256 z = x / y;
54         return z;
55     }
56     
57     /**
58     * @dev Multiplies two numbers, reverts on overflow.
59     */	
60     function safeMul(uint256 x, uint256 y) internal pure returns (uint256) {    
61         if (x == 0) {
62             return 0;
63         }
64     
65         uint256 z = x * y;
66         assert(z / x == y);
67         return z;
68     }
69 
70     /**
71     * @dev Returns the integer percentage of the number.
72     */
73     function safePerc(uint256 x, uint256 y) internal pure returns (uint256) {
74         if (x == 0) {
75             return 0;
76         }
77         
78         uint256 z = x * y;
79         assert(z / x == y);    
80         z = z / 10000; // percent to hundredths
81         return z;
82     }
83 
84     /**
85     * @dev Returns the minimum value of two numbers.
86     */	
87     function min(uint256 x, uint256 y) internal pure returns (uint256) {
88         uint256 z = x <= y ? x : y;
89         return z;
90     }
91 
92     /**
93     * @dev Returns the maximum value of two numbers.
94     */
95     function max(uint256 x, uint256 y) internal pure returns (uint256) {
96         uint256 z = x >= y ? x : y;
97         return z;
98     }
99 }
100 /**
101  * @title Ownable contract - base contract with an owner
102  */
103 contract Ownable {
104   
105   address public owner;
106   address public newOwner;
107 
108   event OwnershipTransferred(address indexed _from, address indexed _to);
109   
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   constructor() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     assert(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param _newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address _newOwner) public onlyOwner {
131     assert(_newOwner != address(0));      
132     newOwner = _newOwner;
133   }
134 
135   /**
136    * @dev Accept transferOwnership.
137    */
138   function acceptOwnership() public {
139     if (msg.sender == newOwner) {
140       emit OwnershipTransferred(owner, newOwner);
141       owner = newOwner;
142     }
143   }
144 }
145 
146 
147 
148 
149 
150 
151 
152 
153 /**
154  * @title Agent contract - base contract with an agent
155  */
156 contract Agent is Ownable {
157 
158   address public defAgent;
159 
160   mapping(address => bool) public Agents;  
161 
162   event UpdatedAgent(address _agent, bool _status);
163 
164   constructor() public {
165     defAgent = msg.sender;
166     Agents[msg.sender] = true;
167   }
168   
169   modifier onlyAgent() {
170     assert(Agents[msg.sender]);
171     _;
172   }
173   
174   function updateAgent(address _agent, bool _status) public onlyOwner {
175     assert(_agent != address(0));
176     Agents[_agent] = _status;
177 
178     emit UpdatedAgent(_agent, _status);
179   }  
180 }
181 
182 
183 
184 /**
185  * @title Standard ERC223 token
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/223
188  */
189 contract ERC223 is ERC223I, Agent, SafeMath {
190 
191   mapping(address => uint) balances;
192   
193   string public name;
194   string public symbol;
195   uint8 public decimals;
196   uint256 public totalSupply;
197 
198   address public crowdsale = address(0);
199   bool public released = false;
200 
201   /**
202    * @dev Limit token transfer until the crowdsale is over.
203    */
204   modifier canTransfer() {
205     assert(released || msg.sender == crowdsale);
206     _;
207   }
208 
209   modifier onlyCrowdsaleContract() {
210     assert(msg.sender == crowdsale);
211     _;
212   }  
213   
214   function name() public view returns (string _name) {
215     return name;
216   }
217 
218   function symbol() public view returns (string _symbol) {
219     return symbol;
220   }
221 
222   function decimals() public view returns (uint8 _decimals) {
223     return decimals;
224   }
225 
226   function totalSupply() public view returns (uint256 _totalSupply) {
227     return totalSupply;
228   }
229 
230   function balanceOf(address _owner) public view returns (uint balance) {
231     return balances[_owner];
232   }  
233 
234   // if bytecode exists then the _addr is a contract.
235   function isContract(address _addr) private view returns (bool is_contract) {
236     uint length;
237     assembly {
238       //retrieve the size of the code on target address, this needs assembly
239       length := extcodesize(_addr)
240     }
241     return (length>0);
242   }
243   
244   // function that is called when a user or another contract wants to transfer funds .
245   function transfer(address _to, uint _value, bytes _data) external canTransfer() returns (bool success) {      
246     if(isContract(_to)) {
247       return transferToContract(_to, _value, _data);
248     } else {
249       return transferToAddress(_to, _value, _data);
250     }
251   }
252   
253   // standard function transfer similar to ERC20 transfer with no _data.
254   // added due to backwards compatibility reasons.
255   function transfer(address _to, uint _value) external canTransfer() returns (bool success) {      
256     bytes memory empty;
257     if(isContract(_to)) {
258       return transferToContract(_to, _value, empty);
259     } else {
260       return transferToAddress(_to, _value, empty);
261     }
262   }
263 
264   // function that is called when transaction target is an address
265   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
266     if (balanceOf(msg.sender) < _value) revert();
267     balances[msg.sender] = safeSub(balances[msg.sender], _value);
268     balances[_to] = safeAdd(balances[_to], _value);
269     emit Transfer(msg.sender, _to, _value, _data);
270     return true;
271   }
272   
273   // function that is called when transaction target is a contract
274   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
275     if (balanceOf(msg.sender) < _value) revert();
276     balances[msg.sender] = safeSub(balances[msg.sender], _value);
277     balances[_to] = safeAdd(balances[_to], _value);
278     assert(_to.call.value(0)(abi.encodeWithSignature("tokenFallback(address,uint256,bytes)", msg.sender, _value, _data)));
279     emit Transfer(msg.sender, _to, _value, _data);
280     return true;
281   }
282 
283   // function that is called when a user or another contract wants to transfer funds .
284   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) external canTransfer() returns (bool success) {      
285     if(isContract(_to)) {
286       if (balanceOf(msg.sender) < _value) revert();
287       balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
288       balances[_to] = safeAdd(balanceOf(_to), _value);      
289       assert(_to.call.value(0)(abi.encodeWithSignature(_custom_fallback), msg.sender, _value, _data));    
290       emit Transfer(msg.sender, _to, _value, _data);
291       return true;
292     } else {
293       return transferToAddress(_to, _value, _data);
294     }
295   }
296 
297   function setCrowdsaleContract(address _contract) external onlyOwner {
298     crowdsale = _contract;
299   }
300 
301   /**
302    * @dev One way function to release the tokens to the wild. Can be called only from the crowdsale contract.
303    */
304   function releaseTokenTransfer() external onlyCrowdsaleContract {
305     released = true;
306   }
307 }
308 
309 /**
310  * @title SABIGlobal Token based on ERC223 token
311  */
312 contract SABIToken is ERC223 {
313 	
314   uint public initialSupply = 1400 * 10**6; // 1.4 billion
315 
316   /** Name and symbol were updated. */
317   event UpdatedTokenInformation(string _name, string _symbol);
318 
319   constructor(string _name, string _symbol, address _crowdsale, address _team, address _bounty, address _adviser, address _developer) public {
320     name = _name;
321     symbol = _symbol;
322     decimals = 8;
323     crowdsale = _crowdsale;
324 
325     bytes memory empty;    
326     totalSupply = initialSupply*uint(10)**decimals;
327     // creating initial tokens
328     balances[_crowdsale] = totalSupply;    
329     emit Transfer(0x0, _crowdsale, balances[_crowdsale], empty);
330     
331     // send 15% - to team account
332     uint value = safePerc(totalSupply, 1500);
333     balances[_crowdsale] = safeSub(balances[_crowdsale], value);
334     balances[_team] = value;
335     emit Transfer(_crowdsale, _team, balances[_team], empty);  
336 
337     // send 5% - to bounty account
338     value = safePerc(totalSupply, 500);
339     balances[_crowdsale] = safeSub(balances[_crowdsale], value);
340     balances[_bounty] = value;
341     emit Transfer(_crowdsale, _bounty, balances[_bounty], empty);
342 
343     // send 1.5% - to adviser account
344     value = safePerc(totalSupply, 150);
345     balances[_crowdsale] = safeSub(balances[_crowdsale], value);
346     balances[_adviser] = value;
347     emit Transfer(_crowdsale, _adviser, balances[_adviser], empty);
348 
349     // send 1% - to developer account
350     value = safePerc(totalSupply, 100);
351     balances[_crowdsale] = safeSub(balances[_crowdsale], value);
352     balances[_developer] = value;
353     emit Transfer(_crowdsale, _developer, balances[_developer], empty);
354   } 
355 
356   /**
357   * Owner may issue new tokens
358   */
359   function mint(address _receiver, uint _amount) public onlyOwner {
360     balances[_receiver] = safeAdd(balances[_receiver], _amount);
361     totalSupply = safeAdd(totalSupply, _amount);
362     bytes memory empty;    
363     emit Transfer(0x0, _receiver, _amount, empty);    
364   }
365 
366   /**
367   * Owner can update token information here.
368   */
369   function updateTokenInformation(string _name, string _symbol) public onlyOwner {
370     name = _name;
371     symbol = _symbol;
372     emit UpdatedTokenInformation(_name, _symbol);
373   }
374 }
1 pragma solidity ^0.4.18;
2 
3 
4  /*
5  * Contract that is working with ERC223 tokens
6  */
7 
8 
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
62     return a < b ? a : b;
63   }
64 } 
65  contract ContractReceiver {
66      
67    struct TKN {
68         address sender;
69         uint value;
70         bytes data;
71         bytes4 sig;
72     }
73     
74     address [] public senders;
75     function tokenFallback(address _from, uint _value, bytes _data) public  {
76         require(_from != address(0));
77         require(_value>0);
78         TKN memory tkn;
79         tkn.sender = _from;
80         tkn.value = _value;
81         tkn.data = _data;
82         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
83         tkn.sig = bytes4(u);
84         senders.push(_from);
85     }
86 }
87 contract ERC223Interface {
88   function balanceOf(address who) public view returns (uint);
89   
90   function name() public view returns (string);
91   function symbol() public view returns (string);
92   function decimals() public view returns (uint);
93   function totalSupply() public view returns (uint256);
94 
95   function transfer(address to, uint value) public returns (bool ok);
96   function transfer(address to, uint value, bytes data) public returns (bool ok);
97   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
98   event Transfer(address indexed from, address indexed to, uint value);
99 }
100 
101 contract ERC223Token  is ERC223Interface  {
102 
103   mapping(address => uint) balances;
104   
105   string internal _name;
106   string internal _symbol;
107   uint internal _decimals;
108   uint256 internal _totalSupply;
109    using SafeMath for uint;
110   
111   
112   // Function to access name of token .
113   function name() public view returns (string) {
114       return _name;
115   }
116   // Function to access symbol of token .
117   function symbol() public view returns (string) {
118       return _symbol;
119   }
120   // Function to access decimals of token .
121   function decimals() public view returns (uint ) {
122       return _decimals;
123   }
124   // Function to access total supply of tokens .
125   function totalSupply() public view returns (uint256 ) {
126       return _totalSupply;
127   }
128   
129   
130   // Function that is called when a user or another contract wants to transfer funds .
131   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
132      require(_to != address(0));
133     if(isContract(_to)) {
134         if (balanceOf(msg.sender) < _value) revert();
135         balances[msg.sender] = balanceOf(msg.sender).sub(_value);
136         balances[_to] = balanceOf(_to).add( _value);
137         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
138         emit Transfer(msg.sender, _to, _value);
139         return true;
140     }
141     else {
142         return transferToAddress(_to, _value, _data);
143     }
144 }
145   
146 
147   // Function that is called when a user or another contract wants to transfer funds .
148   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
149       
150     if(isContract(_to)) {
151         return transferToContract(_to, _value, _data);
152     }
153     else {
154         return transferToAddress(_to, _value, _data);
155     }
156 }
157   
158   // Standard function transfer similar to ERC20 transfer with no _data .
159   // Added due to backwards compatibility reasons .
160   function transfer(address _to, uint _value) public returns (bool success) {
161       
162     //standard function transfer similar to ERC20 transfer with no _data
163     //added due to backwards compatibility reasons
164     bytes memory empty;
165     if(isContract(_to)) {
166         return transferToContract(_to, _value, empty);
167     }
168     else {
169         return transferToAddress(_to, _value, empty);
170     }
171 }
172 
173   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
174   function isContract(address _addr) private view returns (bool is_contract) {
175       uint length;
176       assembly {
177             //retrieve the size of the code on target address, this needs assembly
178             length := extcodesize(_addr)
179       }
180       return (length>0);
181     }
182 
183   //function that is called when transaction target is an address
184   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
185     require(_value>0);
186     require(balanceOf(msg.sender)>=_value);
187     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
188     balances[_to] = balanceOf(_to).add( _value);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192   
193   //function that is called when transaction target is a contract
194   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
195     require(_value>0);
196     require(balanceOf(msg.sender)>=_value);
197     balances[msg.sender] = balanceOf(msg.sender).sub( _value);
198     balances[_to] = balanceOf(_to).add(_value);
199     ContractReceiver receiver = ContractReceiver(_to);
200     receiver.tokenFallback(msg.sender, _value, _data);
201     emit Transfer(msg.sender, _to, _value);
202     return true;
203 }
204 
205 
206   function balanceOf(address _owner) public view returns (uint) {
207     return balances[_owner];
208   }
209 }
210 contract Ownable {
211   address public owner;
212   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
213   
214   /**
215    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216    * account.
217    */
218   function Ownable() public {
219     owner = msg.sender;
220   }
221 
222   /**
223    * @dev Throws if called by any account other than the owner.
224    */
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230 
231   /**
232    * @dev Allows the current owner to transfer control of the contract to a newOwner.
233    * @param newOwner The address to transfer ownership to.
234    */
235   function transferOwnership(address newOwner) public onlyOwner {
236     require(newOwner != address(0));
237     emit OwnershipTransferred(owner, newOwner);
238     owner = newOwner;
239   }
240 
241 }
242 
243 contract Balances is Ownable,
244 ERC223Token {
245     mapping(address => bool)public modules;
246     using SafeMath for uint256; 
247     address public tokenTransferAddress;  
248      function Balances()public {
249         // constructor
250     }
251     // Address where funds are collected
252 
253     function updateModuleStatus(address _module, bool status)public onlyOwner {
254         require(_module != address(0));
255         modules[_module] = status;
256     }
257 
258     function updateTokenTransferAddress(address _tokenAddr)public onlyOwner {
259         require(_tokenAddr != address(0));
260         tokenTransferAddress = _tokenAddr;
261 
262     }
263 
264     modifier onlyModule() {
265         require(modules[msg.sender] == true);
266         _;
267     }
268 
269     function increaseBalance(address recieverAddr, uint256 _tokens)onlyModule public returns(
270         bool
271     ) {
272         require(recieverAddr != address(0));
273         require(balances[tokenTransferAddress] >= _tokens);
274         balances[tokenTransferAddress] = balances[tokenTransferAddress].sub(_tokens);
275         balances[recieverAddr] = balances[recieverAddr].add(_tokens);
276         emit Transfer(tokenTransferAddress,recieverAddr,_tokens);
277         return true;
278     }
279     function decreaseBalance(address recieverAddr, uint256 _tokens)onlyModule public returns(
280         bool
281     ) {
282         require(recieverAddr != address(0));
283         require(balances[recieverAddr] >= _tokens);
284         balances[recieverAddr] = balances[recieverAddr].sub(_tokens);
285         balances[tokenTransferAddress] = balances[tokenTransferAddress].add(_tokens);
286         emit Transfer(tokenTransferAddress,recieverAddr,_tokens);
287         return true;
288     }
289 
290    
291 }
292 
293 contract Pausable is Ownable {
294   event Pause();
295   event Unpause();
296 
297   bool public paused = false;
298 
299 
300   /**
301    * @dev Modifier to make a function callable only when the contract is not paused.
302    */
303   modifier whenNotPaused() {
304     require(!paused);
305     _;
306   }
307 
308   /**
309    * @dev Modifier to make a function callable only when the contract is paused.
310    */
311   modifier whenPaused() {
312     require(paused);
313     _;
314   }
315 
316   /**
317    * @dev called by the owner to pause, triggers stopped state
318    */
319   function pause() onlyOwner whenNotPaused public {
320     paused = true;
321     emit Pause();
322   }
323 
324   /**
325    * @dev called by the owner to unpause, returns to normal state
326    */
327   function unpause() onlyOwner whenPaused public {
328     paused = false;
329     emit Unpause();
330   }
331 }
332 /**
333  * @title Destructible
334  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
335  */
336 contract Destructible is Ownable {
337 
338   function Destructible() public payable { }
339 
340   /**
341    * @dev Transfers the current balance to the owner and terminates the contract.
342    */
343   function destroy() onlyOwner public {
344     selfdestruct(owner);
345   }
346 
347   function destroyAndSend(address _recipient) onlyOwner public {
348     selfdestruct(_recipient);
349   }
350 }
351 
352 contract Gig9 is Balances,
353 Pausable,
354 Destructible {
355     
356     function Gig9()public {
357         _name = "GIG9";
358         _symbol = "GIG";
359         _decimals = 8;
360         _totalSupply = 268000000 * (10 ** _decimals);
361         owner = msg.sender;
362         balances[0x0A35230Af852bc0C094978851640Baf796f1cC9D] = _totalSupply;
363         tokenTransferAddress = 0x0A35230Af852bc0C094978851640Baf796f1cC9D;
364     }
365 
366     function ()public {
367         revert();
368 
369     }
370 
371    
372 
373 }
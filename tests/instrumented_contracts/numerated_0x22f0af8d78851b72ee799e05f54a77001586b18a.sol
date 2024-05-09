1 pragma solidity ^0.4.15;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: Genevieve VC Token
7  * Contract name: GXVCToken
8  * Author: Juan Livingston @ Ethernity.live
9  * Developed for: Genevieve Co.
10  * GXVC is an ERC223 Token
11  *
12  *********************************************************************************
13  ********************************************************************************/
14 
15 contract ContractReceiver {   
16     function tokenFallback(address _from, uint _value, bytes _data){
17     }
18 }
19 
20  /* New ERC23 contract interface */
21 
22 contract ERC223 {
23   uint public totalSupply;
24   function balanceOf(address who) constant returns (uint);
25   
26   function name() constant returns (string _name);
27   function symbol() constant returns (string _symbol);
28   function decimals() constant returns (uint8 _decimals);
29   function totalSupply() constant returns (uint256 _supply);
30 
31   function transfer(address to, uint value) returns (bool ok);
32   function transfer(address to, uint value, bytes data) returns (bool ok);
33   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
34   function transferFrom(address from, address to, uint256 value) returns (bool);
35   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
36 }
37 
38 // The GXVC token ERC223
39 
40 contract GXVCToken {
41 
42     // Token public variables
43     string public name;
44     string public symbol;
45     uint8 public decimals; 
46     string public version = 'v0.2';
47     uint256 public totalSupply;
48     bool locked;
49 
50     address rootAddress;
51     address Owner;
52     uint multiplier = 10000000000; // For 10 decimals
53     address swapperAddress; // Can bypass a lock
54 
55     mapping(address => uint256) balances;
56     mapping(address => mapping(address => uint256)) allowed;
57     mapping(address => bool) freezed; 
58 
59 
60   	event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63     // Modifiers
64 
65     modifier onlyOwner() {
66         if ( msg.sender != rootAddress && msg.sender != Owner ) revert();
67         _;
68     }
69 
70     modifier onlyRoot() {
71         if ( msg.sender != rootAddress ) revert();
72         _;
73     }
74 
75     modifier isUnlocked() {
76     	if ( locked && msg.sender != rootAddress && msg.sender != Owner ) revert();
77 		_;    	
78     }
79 
80     modifier isUnfreezed(address _to) {
81     	if ( freezed[msg.sender] || freezed[_to] ) revert();
82     	_;
83     }
84 
85 
86     // Safe math
87     function safeAdd(uint x, uint y) internal returns (uint z) {
88         require((z = x + y) >= x);
89     }
90     function safeSub(uint x, uint y) internal returns (uint z) {
91         require((z = x - y) <= x);
92     }
93 
94 
95     // GXC Token constructor
96     function GXVCToken() {        
97         locked = true;
98         totalSupply = 160000000 * multiplier; // 160,000,000 tokens * 10 decimals
99         name = 'Genevieve VC'; 
100         symbol = 'GXVC'; 
101         decimals = 10; 
102         rootAddress = msg.sender;        
103         Owner = msg.sender;       
104         balances[rootAddress] = totalSupply; 
105         allowed[rootAddress][swapperAddress] = totalSupply;
106     }
107 
108 
109 	// ERC223 Access functions
110 
111 	function name() constant returns (string _name) {
112 	      return name;
113 	  }
114 	function symbol() constant returns (string _symbol) {
115 	      return symbol;
116 	  }
117 	function decimals() constant returns (uint8 _decimals) {
118 	      return decimals;
119 	  }
120 	function totalSupply() constant returns (uint256 _totalSupply) {
121 	      return totalSupply;
122 	  }
123 
124 
125     // Only root function
126 
127     function changeRoot(address _newrootAddress) onlyRoot returns(bool){
128     		allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
129             rootAddress = _newrootAddress;
130             allowed[_newrootAddress][swapperAddress] = totalSupply; // Gives allowance to new rootAddress
131             return true;
132     }
133 
134 
135     // Only owner functions
136 
137     function changeOwner(address _newOwner) onlyOwner returns(bool){
138             Owner = _newOwner;
139             return true;
140     }
141 
142     function changeSwapperAdd(address _newSwapper) onlyOwner returns(bool){
143     		allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
144             swapperAddress = _newSwapper;
145             allowed[rootAddress][_newSwapper] = totalSupply; // Gives allowance to new rootAddress
146             return true;
147     }
148        
149     function unlock() onlyOwner returns(bool) {
150         locked = false;
151         return true;
152     }
153 
154     function lock() onlyOwner returns(bool) {
155         locked = true;
156         return true;
157     }
158 
159     function freeze(address _address) onlyOwner returns(bool) {
160         freezed[_address] = true;
161         return true;
162     }
163 
164     function unfreeze(address _address) onlyOwner returns(bool) {
165         freezed[_address] = false;
166         return true;
167     }
168 
169     function burn(uint256 _value) onlyOwner returns(bool) {
170     	bytes memory empty;
171         if ( balances[msg.sender] < _value ) revert();
172         balances[msg.sender] = safeSub( balances[msg.sender] , _value );
173         totalSupply = safeSub( totalSupply,  _value );
174         Transfer(msg.sender, 0x0, _value , empty);
175         return true;
176     }
177 
178 
179     // Public getters
180     function isFreezed(address _address) constant returns(bool) {
181         return freezed[_address];
182     }
183 
184     function isLocked() constant returns(bool) {
185         return locked;
186     }
187 
188   // Public functions (from https://github.com/Dexaran/ERC223-token-standard/tree/Recommended)
189 
190   // Function that is called when a user or another contract wants to transfer funds to an address that has a non-standard fallback function
191   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) isUnlocked isUnfreezed(_to) returns (bool success) {
192       
193     if(isContract(_to)) {
194         if (balances[msg.sender] < _value) return false;
195         balances[msg.sender] = safeSub( balances[msg.sender] , _value );
196         balances[_to] = safeAdd( balances[_to] , _value );
197         ContractReceiver receiver = ContractReceiver(_to);
198         receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
199         Transfer(msg.sender, _to, _value, _data);
200         return true;
201     }
202     else {
203         return transferToAddress(_to, _value, _data);
204     }
205 }
206 
207   // Function that is called when a user or another contract wants to transfer funds to an address with tokenFallback function
208   function transfer(address _to, uint _value, bytes _data) isUnlocked isUnfreezed(_to) returns (bool success) {
209       
210     if(isContract(_to)) {
211         return transferToContract(_to, _value, _data);
212     }
213     else {
214         return transferToAddress(_to, _value, _data);
215     }
216 }
217 
218 
219   // Standard function transfer similar to ERC20 transfer with no _data.
220   // Added due to backwards compatibility reasons.
221   function transfer(address _to, uint _value) isUnlocked isUnfreezed(_to) returns (bool success) {
222 
223     bytes memory empty;
224     if(isContract(_to)) {
225         return transferToContract(_to, _value, empty);
226     }
227     else {
228         return transferToAddress(_to, _value, empty);
229     }
230 }
231 
232 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
233   function isContract(address _addr) private returns (bool is_contract) {
234       uint length;
235       assembly {
236             //retrieve the size of the code on target address, this needs assembly
237             length := extcodesize(_addr)
238       }
239       return (length>0);
240     }
241 
242   //function that is called when transaction target is an address
243   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
244     if (balances[msg.sender] < _value) return false;
245     balances[msg.sender] = safeSub(balances[msg.sender], _value);
246     balances[_to] = safeAdd(balances[_to], _value);
247     Transfer(msg.sender, _to, _value, _data);
248     return true;
249   }
250   
251   //function that is called when transaction target is a contract
252   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
253     if (balances[msg.sender] < _value) return false;
254     balances[msg.sender] = safeSub(balances[msg.sender] , _value);
255     balances[_to] = safeAdd(balances[_to] , _value);
256     ContractReceiver receiver = ContractReceiver(_to);
257     receiver.tokenFallback(msg.sender, _value, _data);
258     Transfer(msg.sender, _to, _value, _data);
259     return true;
260 }
261 
262 
263     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
264 
265         if ( locked && msg.sender != swapperAddress ) return false; 
266         if ( freezed[_from] || freezed[_to] ) return false; // Check if destination address is freezed
267         if ( balances[_from] < _value ) return false; // Check if the sender has enough
268 		if ( _value > allowed[_from][msg.sender] ) return false; // Check allowance
269 
270         balances[_from] = safeSub(balances[_from] , _value); // Subtract from the sender
271         balances[_to] = safeAdd(balances[_to] , _value); // Add the same to the recipient
272 
273         allowed[_from][msg.sender] = safeSub( allowed[_from][msg.sender] , _value );
274 
275         bytes memory empty;
276 
277         if ( isContract(_to) ) {
278 	        ContractReceiver receiver = ContractReceiver(_to);
279 	    	receiver.tokenFallback(_from, _value, empty);
280 		}
281 
282         Transfer(_from, _to, _value , empty);
283         return true;
284     }
285 
286 
287     function balanceOf(address _owner) constant returns(uint256 balance) {
288         return balances[_owner];
289     }
290 
291 
292     function approve(address _spender, uint _value) returns(bool) {
293         allowed[msg.sender][_spender] = _value;
294         Approval(msg.sender, _spender, _value);
295         return true;
296     }
297 
298 
299     function allowance(address _owner, address _spender) constant returns(uint256) {
300         return allowed[_owner][_spender];
301     }
302 }
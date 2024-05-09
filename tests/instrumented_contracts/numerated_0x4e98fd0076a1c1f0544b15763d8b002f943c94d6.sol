1 pragma solidity ^0.4.15;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: Alteum Token
7  * Contract name: AlteumToken
8  * Author: Juan Livingston @ Ethernity.live
9  * Developed for: Alteum
10  * Alteum is an ERC223 Token
11  *
12  *********************************************************************************
13  ********************************************************************************/
14 
15 contract ContractReceiver {   
16     function tokenFallback(address _from, uint _value, bytes _data){
17     }
18 }
19 
20 
21 
22  /* New ERC23 contract interface */
23 
24 contract ERC223 {
25   uint public totalSupply;
26   function balanceOf(address who) constant returns (uint);
27   
28   function name() constant returns (string _name);
29   function symbol() constant returns (string _symbol);
30   function decimals() constant returns (uint8 _decimals);
31   function totalSupply() constant returns (uint256 _supply);
32 
33   function transfer(address to, uint value) returns (bool ok);
34   function transfer(address to, uint value, bytes data) returns (bool ok);
35   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
36   function transferFrom(address from, address to, uint256 value) returns (bool);
37   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
38 }
39 
40 // The Alteum token ERC223
41 
42 contract AlteumToken {
43 
44     // Token public variables
45     string public name;
46     string public symbol;
47     uint8 public decimals; 
48     string public version = 'v0.2';
49     uint256 public totalSupply;
50     bool locked;
51 
52     address rootAddress;
53     address Owner;
54     uint multiplier = 100000000; // For 8 decimals
55     address swapperAddress; // Can bypass a lock
56 
57     mapping(address => uint256) balances;
58     mapping(address => mapping(address => uint256)) allowed;
59     mapping(address => bool) freezed; 
60 
61 
62   	event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 
65     // Modifiers
66 
67     modifier onlyOwner() {
68         if ( msg.sender != rootAddress && msg.sender != Owner ) revert();
69         _;
70     }
71 
72     modifier onlyRoot() {
73         if ( msg.sender != rootAddress ) revert();
74         _;
75     }
76 
77     modifier isUnlocked() {
78     	if ( locked && msg.sender != rootAddress && msg.sender != Owner ) revert();
79 		_;    	
80     }
81 
82     modifier isUnfreezed(address _to) {
83     	if ( freezed[msg.sender] || freezed[_to] ) revert();
84     	_;
85     }
86 
87 
88     // Safe math
89     function safeAdd(uint x, uint y) internal returns (uint z) {
90         require((z = x + y) >= x);
91     }
92     function safeSub(uint x, uint y) internal returns (uint z) {
93         require((z = x - y) <= x);
94     }
95 
96 
97     // Alteum Token constructor
98     function AlteumToken() {        
99         locked = true;
100         totalSupply = 50000000 * multiplier; // 50,000,000 tokens * 8 decimals
101         name = 'Alteum'; 
102         symbol = 'AUM'; 
103         decimals = 8; 
104         rootAddress = 0x803622DE47eACE04e25541496e1ED9216C3c640F;      
105         Owner = msg.sender;       
106         balances[rootAddress] = totalSupply;
107         allowed[rootAddress][swapperAddress] = 37500000 * multiplier; // 37,500,000 tokens for ICO
108     }
109 
110 
111 	// ERC223 Access functions
112 
113 	function name() constant returns (string _name) {
114 	      return name;
115 	  }
116 	function symbol() constant returns (string _symbol) {
117 	      return symbol;
118 	  }
119 	function decimals() constant returns (uint8 _decimals) {
120 	      return decimals;
121 	  }
122 	function totalSupply() constant returns (uint256 _totalSupply) {
123 	      return totalSupply;
124 	  }
125 
126 
127     // Only root function
128 
129     function changeRoot(address _newrootAddress) onlyRoot returns(bool){
130             rootAddress = _newrootAddress;
131             allowed[_newrootAddress][swapperAddress] = allowed[rootAddress][swapperAddress]; // Gives allowance to new rootAddress
132             allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
133             return true;
134     }
135 
136 
137     // Only owner functions
138 
139     function changeOwner(address _newOwner) onlyOwner returns(bool){
140             Owner = _newOwner;
141             return true;
142     }
143 
144     function changeSwapperAdd(address _newSwapper) onlyOwner returns(bool){
145             swapperAddress = _newSwapper;
146             allowed[rootAddress][_newSwapper] = allowed[rootAddress][swapperAddress]; // Gives allowance to new rootAddress
147             allowed[rootAddress][swapperAddress] = 0; // Removes allowance to old rootAddress
148             return true;
149     }
150        
151     function unlock() onlyOwner returns(bool) {
152         locked = false;
153         return true;
154     }
155 
156     function lock() onlyOwner returns(bool) {
157         locked = true;
158         return true;
159     }
160 
161     function freeze(address _address) onlyOwner returns(bool) {
162         freezed[_address] = true;
163         return true;
164     }
165 
166     function unfreeze(address _address) onlyOwner returns(bool) {
167         freezed[_address] = false;
168         return true;
169     }
170 
171     // Public getters
172     function isFreezed(address _address) constant returns(bool) {
173         return freezed[_address];
174     }
175 
176     function isLocked() constant returns(bool) {
177         return locked;
178     }
179 
180 
181 // To send tokens that were accidentally sent to this contract
182 function sendToken(address _tokenAddress , address _addressTo , uint256 _amount) onlyOwner returns(bool) {
183         ERC223 token_to_send = ERC223( _tokenAddress );
184         require( token_to_send.transfer(_addressTo , _amount) );
185         return true;
186 }
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
1 pragma solidity ^0.4.17;
2 
3 contract ERC223 {
4     uint public totalSupply;
5 
6     // ERC223 functions and events
7     function balanceOf(address who) public constant returns (uint);
8     function totalSupply() constant public returns (uint256 _supply);
9     function transfer(address to, uint value) public returns (bool ok);
10     function transfer(address to, uint value, bytes data) public returns (bool ok);
11     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
12     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
13 
14     // ERC223 functions
15     function name() constant public returns (string _name);
16     function symbol() constant public returns (string _symbol);
17     function decimals() constant public returns (uint8 _decimals);
18 
19     
20     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
21     //function approve(address _spender, uint256 _value) returns (bool success);
22    // function allowance(address _owner, address _spender) constant returns (uint256 remaining);
23     event Transfer(address indexed _from, address indexed _to, uint256 _value);
24    // event Approval(address indexed _owner, address indexed _spender, uint _value);
25      event Burn(address indexed from, uint256 value);
26 }
27 
28 /**
29  * Include SafeMath Lib
30  */
31 contract SafeMath {
32     uint256 constant public MAX_UINT256 =
33     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
34 
35     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
36         if (x > MAX_UINT256 - y)
37             revert();
38         return x + y;
39     }
40 
41     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
42         if (x < y) {
43             revert();
44         }
45         return x - y;
46     }
47 
48     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
49         if (y == 0) {
50             return 0;
51         }
52         if (x > MAX_UINT256 / y) {
53             revert();
54         }
55         return x * y;
56     }
57 }
58 
59 /*
60  * Contract that is working with ERC223 tokens
61  */
62  contract ContractReceiver {
63 
64     struct TKN {
65         address sender;
66         uint value;
67         bytes data;
68         bytes4 sig;
69     }
70 
71     function tokenFallback(address _from, uint _value, bytes _data) public {
72       TKN memory tkn;
73       tkn.sender = _from;
74       tkn.value = _value;
75       tkn.data = _data;
76       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
77       tkn.sig = bytes4(u);
78 
79       /* tkn variable is analogue of msg variable of Ether transaction
80       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
81       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
82       *  tkn.data is data of token transaction   (analogue of msg.data)
83       *  tkn.sig is 4 bytes signature of function
84       *  if data of token transaction is a function execution
85       */
86     }
87 }
88 
89 /*
90  * CL token with ERC223 Extensions
91  */
92 contract CL is ERC223, SafeMath {
93 
94     string public name = "TCoin";
95 
96     string public symbol = "TCoin";
97 
98     uint8 public decimals = 8;
99 
100     uint256 public totalSupply = 10000 * 10**2;
101 
102     address public owner;
103     address public admin;
104 
105   //  bool public unlocked = false;
106 
107     bool public tokenCreated = false;
108 
109     mapping(address => uint256) balances;
110 
111     mapping(address => mapping (address => uint256)) allowed;
112     
113     function admined(){
114    admin = msg.sender;
115   }
116   
117 
118     // Initialize to have owner have 100,000,000,000 CL on contract creation
119     // Constructor is called only once and can not be called again (Ethereum Solidity specification)
120     function CL() public {
121 
122       
123         // Ensure token gets created once only
124         require(tokenCreated == false);
125         tokenCreated = true;
126 
127         owner = msg.sender;
128         balances[owner] = totalSupply;
129 
130         // Final sanity check to ensure owner balance is greater than zero
131         require(balances[owner] > 0);
132     }
133 
134     modifier onlyOwner() {
135         require(msg.sender == owner);
136         _;
137     }
138      modifier onlyAdmin(){
139     require(msg.sender == admin) ;
140     _;
141   }
142   function transferAdminship(address newAdmin) onlyAdmin {
143      
144     admin = newAdmin;
145   }
146   
147   
148 
149     // Function to distribute tokens to list of addresses by the provided amount
150     // Verify and require that:
151     // - Balance of owner cannot be negative
152     // - All transfers can be fulfilled with remaining owner balance
153     // - No new tokens can ever be minted except originally created 100,000,000,000
154     function distributeAirdrop(address[] addresses, uint256 amount) onlyOwner public {
155         // Only allow undrop while token is locked
156         // After token is unlocked, this method becomes permanently disabled
157         //require(unlocked);
158 
159         // Amount is in Wei, convert to CL amount in 8 decimal places
160         uint256 normalizedAmount = amount * 10**8;
161         // Only proceed if there are enough tokens to be distributed to all addresses
162         // Never allow balance of owner to become negative
163         require(balances[owner] >= safeMul(addresses.length, normalizedAmount));
164         for (uint i = 0; i < addresses.length; i++) {
165             balances[owner] = safeSub(balanceOf(owner), normalizedAmount);
166             balances[addresses[i]] = safeAdd(balanceOf(addresses[i]), normalizedAmount);
167             Transfer(owner, addresses[i], normalizedAmount);
168         }
169     }
170 
171     // Function to access name of token .sha
172     function name() constant public returns (string _name) {
173         return name;
174     }
175     // Function to access symbol of token .
176     function symbol() constant public returns (string _symbol) {
177         return symbol;
178     }
179     // Function to access decimals of token .
180     function decimals() constant public returns (uint8 _decimals) {
181         return decimals;
182     }
183     // Function to access total supply of tokens .
184     function totalSupply() constant public returns (uint256 _totalSupply) {
185         return totalSupply;
186     }
187 
188     // Function that is called when a user or another contract wants to transfer funds .
189     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
190 
191         // Only allow transfer once unlocked
192         // Once it is unlocked, it is unlocked forever and no one can lock again
193        // require(unlocked);
194 
195         if (isContract(_to)) {
196             if (balanceOf(msg.sender) < _value) {
197                 revert();
198             }
199             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
200             balances[_to] = safeAdd(balanceOf(_to), _value);
201             ContractReceiver receiver = ContractReceiver(_to);
202             receiver.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data);
203             Transfer(msg.sender, _to, _value, _data);
204             return true;
205         } else {
206             return transferToAddress(_to, _value, _data);
207         }
208     }
209 
210     // Function that is called when a user or another contract wants to transfer funds .
211     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
212 
213         // Only allow transfer once unlocked
214         // Once it is unlocked, it is unlocked forever and no one can lock again
215        // require(unlocked);
216 
217         if (isContract(_to)) {
218             return transferToContract(_to, _value, _data);
219         } else {
220             return transferToAddress(_to, _value, _data);
221         }
222     }
223     
224 
225     // Standard function transfer similar to ERC223 transfer with no _data .
226     // Added due to backwards compatibility reasons .
227     function transfer(address _to, uint _value) public returns (bool success) {
228 
229         // Only allow transfer once unlocked
230         // Once it is unlocked, it is unlocked forever and no one can lock again
231         //require(unlocked);
232 
233         //standard function transfer similar to ERC223 transfer with no _data
234         //added due to backwards compatibility reasons
235         bytes memory empty;
236         if (isContract(_to)) {
237             return transferToContract(_to, _value, empty);
238         } else {
239             return transferToAddress(_to, _value, empty);
240         }
241     }
242 
243     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
244     function isContract(address _addr) private returns (bool is_contract) {
245         uint length;
246         assembly {
247             //retrieve the size of the code on target address, this needs assembly
248             length := extcodesize(_addr)
249         }
250         return (length > 0);
251     }
252 
253     // function that is called when transaction target is an address
254     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
255         if (balanceOf(msg.sender) < _value) {
256             revert();
257         }
258         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
259         balances[_to] = safeAdd(balanceOf(_to), _value);
260         Transfer(msg.sender, _to, _value, _data);
261         return true;
262     }
263     
264 
265     // function that is called when transaction target is a contract
266     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
267         if (balanceOf(msg.sender) < _value) {
268             revert();
269         }
270         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
271         balances[_to] = safeAdd(balanceOf(_to), _value);
272         ContractReceiver receiver = ContractReceiver(_to);
273         receiver.tokenFallback(msg.sender, _value, _data);
274         Transfer(msg.sender, _to, _value, _data);
275         return true;
276     }
277 
278     // Get balance of the address provided
279     function balanceOf(address _owner) constant public returns (uint256 balance) {
280         return balances[_owner];
281     }
282 
283      // Creator/Owner can unlocked it once and it can never be locked again
284      // Use after airdrop is complete
285    /* function unlockForever() onlyOwner public {
286         unlocked = true;
287     }*/
288 
289     // Allow transfers if the owner provided an allowance
290     // Prevent from any transfers if token is not yet unlocked
291     // Use SafeMath for the main logic
292     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
293         // Only allow transfer once unlocked
294         // Once it is unlocked, it is unlocked forever and no one can lock again
295         //require(unlocked);
296         // Protect against wrapping uints.
297         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
298         uint256 allowance = allowed[_from][msg.sender];
299         require(balances[_from] >= _value && allowance >= _value);
300         balances[_to] = safeAdd(balanceOf(_to), _value);
301         balances[_from] = safeSub(balanceOf(_from), _value);
302         if (allowance < MAX_UINT256) {
303             allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
304         }
305         Transfer(_from, _to, _value);
306         return true;
307     }
308     function mintToken(address target, uint256 mintedAmount) onlyOwner{
309     balances[target] += mintedAmount;
310     totalSupply += mintedAmount;
311     Transfer(0, this, mintedAmount);
312     Transfer(this, target, mintedAmount);
313   }
314   
315   function burn(uint256 _value) public returns (bool success) {
316         require(balances[msg.sender] >= _value);   
317         balances[msg.sender] -= _value;            
318         totalSupply -= _value;                      
319         Burn(msg.sender, _value);
320         return true;
321     }
322 
323  
324 }
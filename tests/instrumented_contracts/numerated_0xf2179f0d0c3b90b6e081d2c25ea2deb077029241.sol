1 pragma solidity ^0.4.9;
2 
3 contract ERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) public view returns (uint);
6   
7   function name() public view returns (string _name);
8   function symbol() public view returns (string _symbol);
9   function decimals() public view returns (uint8 _decimals);
10   function totalSupply() public view returns (uint256 _supply);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transfer(address to, uint value, bytes data) public returns (bool ok);
14   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
15   
16   event Transfer(address indexed from, address indexed to, uint value, bytes data);
17   event Transfer(address indexed from, address indexed to, uint value);
18   
19     
20 }
21 
22 contract ContractReceiver {
23      
24     struct TKN {
25         address sender;
26         uint value;
27         bytes data;
28         bytes4 sig;
29     }
30     
31     
32     function tokenFallback(address _from, uint _value, bytes _data) public pure {
33       TKN memory tkn;
34       tkn.sender = _from;
35       tkn.value = _value;
36       tkn.data = _data;
37       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
38       tkn.sig = bytes4(u);
39       
40       /* tkn variable is analogue of msg variable of Ether transaction
41       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
42       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
43       *  tkn.data is data of token transaction   (analogue of msg.data)
44       *  tkn.sig is 4 bytes signature of function
45       *  if data of token transaction is a function execution
46       */
47     }
48 }
49 
50 /**
51  * Math operations with safety checks
52  */
53 contract SafeMath {
54     uint256 constant public MAX_UINT256 =
55     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
56 
57     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
58         if (x > MAX_UINT256 - y) revert();
59         return x + y;
60     }
61 
62     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
63         if (x < y) revert();
64         return x - y;
65     }
66 
67     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
68         if (y == 0) return 0;
69         if (x > MAX_UINT256 / y) revert();
70         return x * y;
71     }
72 }
73 
74 contract WithdrawableToken {
75     function transfer(address _to, uint _value) returns (bool success);
76     function balanceOf(address _owner) constant returns (uint balance);
77 }
78 
79 contract TJToken is ERC223,SafeMath{
80     string public name;
81     string public symbol;
82     uint8 public decimals;
83     uint256 public totalSupply;
84 	address public owner;
85 
86     /* This creates an array with all balances */
87     mapping (address => uint256) public balances;
88 	mapping (address => uint256) public freezes;
89   
90 
91     /* This notifies clients about the amount burnt */
92     event Burn(address indexed from, uint256 value);
93 	
94 	/* This notifies clients about the amount frozen */
95     event Freeze(address indexed from, uint256 value);
96 	
97 	/* This notifies clients about the amount unfrozen */
98     event Unfreeze(address indexed from, uint256 value);
99 
100 	
101 	// Function to access name of token .
102   function name() public view returns (string _name) {
103       return name;
104   }
105   // Function to access symbol of token .
106   function symbol() public view returns (string _symbol) {
107       return symbol;
108   }
109   // Function to access decimals of token .
110   function decimals() public view returns (uint8 _decimals) {
111       return decimals;
112   }
113   // Function to access total supply of tokens .
114   function totalSupply() public view returns (uint256 _totalSupply) {
115       return totalSupply;
116   }
117 	
118     /* Initializes contract with initial supply tokens to the creator of the contract */
119     function TJToken(uint256 initialSupply,string tokenName,uint8 decimalUnits,string tokenSymbol) {
120         balances[msg.sender] = initialSupply * 10 ** uint256(decimalUnits);              // Give the creator all initial tokens
121         totalSupply = initialSupply * 10 ** uint256(decimalUnits);                     // Update total supply
122         name = tokenName;                                   // Set the name for display purposes
123         symbol = tokenSymbol;                               // Set the symbol for display purposes
124         decimals = decimalUnits;                            // Amount of decimals for display purposes
125 		owner = msg.sender;
126 		Transfer(address(0), owner, totalSupply);
127     }
128 
129 
130     function burn(uint256 _value) returns (bool success) {
131         if (balances[msg.sender] < _value) revert();            // Check if the sender has enough
132 		if (_value <= 0) revert(); 
133         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
134         totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
135         Burn(msg.sender, _value);
136         return true;
137     }
138 	
139 	function freeze(uint256 _value) returns (bool success) {
140         if (balances[msg.sender] < _value) revert();            // Check if the sender has enough
141 		if (_value <= 0) revert(); 
142         balances[msg.sender] = SafeMath.safeSub(balances[msg.sender], _value);                      // Subtract from the sender
143         freezes[msg.sender] = SafeMath.safeAdd(freezes[msg.sender], _value);                                // Updates totalSupply
144         Freeze(msg.sender, _value);
145         return true;
146     }
147 	
148 	function unfreeze(uint256 _value) returns (bool success) {
149         if (freezes[msg.sender] < _value) revert();            // Check if the sender has enough
150 		if (_value <= 0) revert(); 
151         freezes[msg.sender] = SafeMath.safeSub(freezes[msg.sender], _value);                      // Subtract from the sender
152 		balances[msg.sender] = SafeMath.safeAdd(balances[msg.sender], _value);
153         Unfreeze(msg.sender, _value);
154         return true;
155     }
156 	
157 	function withdrawTokens(address tokenContract) external {
158 		require(msg.sender == owner );
159 		WithdrawableToken tc = WithdrawableToken(tokenContract);
160 
161 		tc.transfer(owner, tc.balanceOf(this));
162 	}
163 	
164 	// transfer balance to owner
165 	function withdrawEther() external {
166 		require(msg.sender == owner );
167 		msg.sender.transfer(this.balance);
168 	}
169 
170 	 // Function that is called when a user or another contract wants to transfer funds .
171   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
172       
173     if(isContract(_to)) {
174         if (balanceOf(msg.sender) < _value) revert();
175         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
176         balances[_to] = safeAdd(balanceOf(_to), _value);
177         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
178         Transfer(msg.sender, _to, _value, _data);
179         return true;
180     }
181     else {
182         return transferToAddress(_to, _value, _data);
183     }
184 }
185   
186 
187   // Function that is called when a user or another contract wants to transfer funds .
188   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
189       
190     if(isContract(_to)) {
191         return transferToContract(_to, _value, _data);
192     }
193     else {
194         return transferToAddress(_to, _value, _data);
195     }
196 }
197   
198   // Standard function transfer similar to ERC20 transfer with no _data .
199   // Added due to backwards compatibility reasons .
200   function transfer(address _to, uint _value) public returns (bool success) {
201       
202     //standard function transfer similar to ERC20 transfer with no _data
203     //added due to backwards compatibility reasons
204     bytes memory empty;
205     if(isContract(_to)) {
206         return transferToContract(_to, _value, empty);
207     }
208     else {
209         return transferToAddress(_to, _value, empty);
210     }
211 }
212 
213   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
214   function isContract(address _addr) private view returns (bool is_contract) {
215       uint length;
216       assembly {
217             //retrieve the size of the code on target address, this needs assembly
218             length := extcodesize(_addr)
219       }
220       return (length>0);
221     }
222 
223   //function that is called when transaction target is an address
224   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
225     if (balanceOf(msg.sender) < _value) revert();
226     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
227     balances[_to] = safeAdd(balanceOf(_to), _value);
228 	if (_data.length > 0){
229 		Transfer(msg.sender, _to, _value, _data);
230 	}
231     else{
232 		Transfer(msg.sender, _to, _value);
233 	}
234     return true;
235   }
236   
237   //function that is called when transaction target is a contract
238   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
239     if (balanceOf(msg.sender) < _value) revert();
240     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
241     balances[_to] = safeAdd(balanceOf(_to), _value);
242     ContractReceiver receiver = ContractReceiver(_to);
243     receiver.tokenFallback(msg.sender, _value, _data);
244     Transfer(msg.sender, _to, _value, _data);
245     return true;
246 }
247 	
248 	function balanceOf(address _owner) public view returns (uint balance) {
249     return balances[_owner];
250   }
251 	
252 	// can accept ether
253 	function () payable {
254     }
255 	
256 }
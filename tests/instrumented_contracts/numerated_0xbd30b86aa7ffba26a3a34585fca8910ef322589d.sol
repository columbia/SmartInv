1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6   
7 }
8 
9 contract ERC20 is ERC20Basic {
10   function allowance(address owner, address spender)
11     public view returns (uint256);
12 
13   function transferFrom(address from, address to, uint256 value)
14     public returns (bool);
15 
16   function approve(address spender, uint256 value) public returns (bool);
17   event Approval(address indexed owner, address indexed spender,uint256 value);
18 }
19 
20 contract Ownable {
21   address public owner;
22 
23   event OwnershipRenounced(address indexed previousOwner);
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   function renounceOwnership() public onlyOwner {
36     emit OwnershipRenounced(owner);
37     owner = address(0);
38   }
39 
40   function transferOwnership(address _newOwner) public onlyOwner {
41     _transferOwnership(_newOwner);
42   }
43 
44   function _transferOwnership(address _newOwner) internal {
45     require(_newOwner != address(0));
46     emit OwnershipTransferred(owner, _newOwner);
47     owner = _newOwner;
48   }
49 }
50 
51 library SafeMath {
52 
53   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a * b;
55     //assert(a == 0 || c / a == b);
56      require(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
61     //assert(b > 0);
62     require(b > 0);
63     uint256 c = a / b;
64     //assert(a == b * c + a % b);
65     require(a == b * c + a % b);
66     return c;
67   }
68 
69   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
70     // assert(b <= a);
71      require(b <= a);
72     return a - b;
73   }
74 
75   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
76     uint256 c = a + b;
77     //assert(c>=a && c>=b);
78     require(c>=a && c>=b);
79     return c;
80   }
81 /*
82   function assert(bool assertion) internal {
83     if (!assertion) {
84       //throw;
85       revert();
86     }
87   }*/
88 }
89 
90 contract BasicToken is ERC20Basic {
91   using SafeMath for uint256;
92 
93   mapping(address => uint256) balances;
94 
95   uint256 totalSupply_;
96 
97   function totalSupply() public view returns (uint256) {
98     return totalSupply_;
99   }
100 
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) internal allowed;
110 
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     emit Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   function allowance(address _owner,address _spender)public view returns (uint256)
118   {
119     return allowed[_owner][_spender];
120   }
121 
122 }
123 
124 contract MintableToken is StandardToken, Ownable {
125   event Mint(address indexed to, uint256 amount);
126   event MintFinished();
127 
128   bool public mintingFinished = false;
129 
130 
131   modifier canMint() {
132     require(!mintingFinished);
133     _;
134   }
135 
136   modifier hasMintPermission() {
137     require(msg.sender == owner);
138     _;
139   }
140   
141   function mint(
142     address _to,
143     uint256 _amount
144   )
145     hasMintPermission
146     canMint
147     public
148     returns (bool)
149   {
150     totalSupply_ = totalSupply_.safeAdd(_amount);
151     balances[_to] = balances[_to].safeAdd(_amount);
152     emit Mint(_to, _amount);
153     emit Transfer(address(0), _to, _amount);
154     return true;
155   }
156 
157   function finishMinting() onlyOwner canMint public returns (bool) {
158     mintingFinished = true;
159     emit MintFinished();
160     return true;
161   }
162 }
163 
164 contract HaeinenergyToken is MintableToken {
165   string public name;
166     string public symbol;
167     uint8 public decimals;
168     uint256 public totalSupply;
169 	address public owner;
170  uint256 public deploymentTime = now;
171  uint256 public burnTime ;
172     uint256 public sellPrice;
173     uint256 public buyPrice;
174 
175     mapping (address => bool) public frozenAccount;
176    
177     mapping (address => uint256) public balanceOf;
178 	mapping (address => uint256) public freezeOf;
179     mapping (address => mapping (address => uint256)) public allowance;
180 
181     event Burn(address indexed from, uint256 value);
182 
183     event Freeze(address indexed from, uint256 value);
184 
185     event Unfreeze(address indexed from, uint256 value);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188    
189    // function FinalToken(
190        constructor(
191         uint256 initialSupply
192        // string tokenName,
193         //uint8 decimalUnits,
194         //string tokenSymbol
195         ) public {
196         initialSupply =100000000000 * 100000000; 
197         balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens
198         totalSupply = 100000000000;                         // Update total supply
199         name = "Haeinenergy coin";                                   // Set the name for display purposes
200         symbol = "HEC";                               // Set the symbol for display purposes
201         decimals = 8;                            // Amount of decimals for display purposes
202 		owner = msg.sender;
203 		 emit Transfer(0x0, owner, totalSupply);
204     }
205 
206     /* Send coins */
207     function transfer(address _to, uint256 _value) public {
208        require (_to == 0x0);  
209       //if (_to == 0x0) throw; 
210 		//if (_value <= 0) throw; 
211 		require (_value <= 0);
212        // if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
213        // if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
214         require (balanceOf[msg.sender] < _value);           
215         require (balanceOf[_to] + _value < balanceOf[_to]);
216         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
217         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
218        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
219     }
220 
221     /* Allow another contract to spend some tokens in your behalf */
222     function approve(address _spender, uint256 _value) public
223         returns (bool success) {
224 		require (_value <= 0) ; 
225         allowance[msg.sender][_spender] = _value;
226         return true;
227     }
228 
229     /* A contract attempts to get the coins */
230     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
231         require (_to == 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
232 	require (_value <= 0); 
233         require (balanceOf[_from] < _value);                 // Check if the sender has enough
234        require (balanceOf[_to] + _value < balanceOf[_to]);  // Check for overflows
235         require (_value > allowance[_from][msg.sender]);     // Check allowance
236         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
237         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
238         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
239        emit Transfer(_from, _to, _value);
240         return true;
241     }
242 
243      function burn(uint256 _value) public returns (bool success) {
244       if (burnTime <= now)
245       {
246         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
247         balanceOf[msg.sender] -= _value;            // Subtract from the sender
248         totalSupply -= _value;                      // Updates totalSupply
249         emit Burn(msg.sender, _value);
250         return true;
251       }
252     }
253 
254     function burnFrom(address _from, uint256 _value) public returns (bool success) {
255         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
256         require(_value <= allowance[_from][msg.sender]);    // Check allowance
257         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
258         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
259         totalSupply -= _value;                              // Update totalSupply
260         emit Burn(_from, _value);
261         return true;
262     }
263 	
264 	function freeze(uint256 _value)public returns (bool success) {
265         require (balanceOf[msg.sender] < _value);            // Check if the sender has enough
266 		require (_value <= 0); 
267         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
268         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
269         emit Freeze(msg.sender, _value);
270         return true;
271     }
272 	
273 	function unfreeze(uint256 _value)public returns (bool success) {
274         require (freezeOf[msg.sender] < _value);            // Check if the sender has enough
275 	require (_value <= 0); 
276         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
277 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
278         emit Unfreeze(msg.sender, _value);
279         return true;
280     }
281 	
282 	// transfer balance to owner
283 	function withdrawEther(uint256 amount)public {
284 		require(msg.sender != owner);
285 		owner.transfer(amount);
286 	}
287 	
288 	// can accept ether
289 	function()public payable {
290     }
291 
292 
293 /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
294     /// @param newSellPrice Price the users can sell to the contract
295     /// @param newBuyPrice Price users can buy from the contract
296     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
297         sellPrice = newSellPrice;
298         buyPrice = newBuyPrice;
299     }
300 
301     /// @notice Buy tokens from contract by sending ether
302     function buy() payable public {
303         uint amount = msg.value / buyPrice;               // calculates the amount
304         transferFrom(this, msg.sender, amount);              // makes the transfers
305     }
306 
307     /// @notice Sell `amount` tokens to contract
308     /// @param amount amount of tokens to be sold
309     function sell(uint256 amount) public {
310         address myAddress = this;
311         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
312         transferFrom(msg.sender, this, amount);              // makes the transfers
313         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
314     }
315 
316 }
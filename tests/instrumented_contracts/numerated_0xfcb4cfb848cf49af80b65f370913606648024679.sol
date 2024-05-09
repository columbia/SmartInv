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
164 contract FinalToken is MintableToken {
165   string public name;
166     string public symbol;
167     uint8 public decimals;
168     uint256 public totalSupply;
169 	address public owner;
170  uint256 public deploymentTime = now;
171  uint256 public burnTime = now + 2 minutes;
172     
173    
174     mapping (address => uint256) public balanceOf;
175 	mapping (address => uint256) public freezeOf;
176     mapping (address => mapping (address => uint256)) public allowance;
177 
178     event Burn(address indexed from, uint256 value);
179 
180     event Freeze(address indexed from, uint256 value);
181 
182     event Unfreeze(address indexed from, uint256 value);
183 
184     /* Initializes contract with initial supply tokens to the creator of the contract */
185    
186    // function FinalToken(
187        constructor(
188         uint256 initialSupply
189        // string tokenName,
190         //uint8 decimalUnits,
191         //string tokenSymbol
192         ) public {
193         initialSupply =21000000 * 100000000; 
194         balanceOf[msg.sender] = initialSupply;             // Give the creator all initial tokens
195         totalSupply = 21000000;                         // Update total supply
196         name = "Valyuta";                                   // Set the name for display purposes
197         symbol = "VLT";                               // Set the symbol for display purposes
198         decimals = 8;                            // Amount of decimals for display purposes
199 		owner = msg.sender;
200 		 emit Transfer(0x0, owner, totalSupply);
201     }
202 
203     /* Send coins */
204     function transfer(address _to, uint256 _value) public {
205        require (_to == 0x0);  
206       //if (_to == 0x0) throw; 
207 		//if (_value <= 0) throw; 
208 		require (_value <= 0);
209        // if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
210        // if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
211         require (balanceOf[msg.sender] < _value);           
212         require (balanceOf[_to] + _value < balanceOf[_to]);
213         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
214         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
215        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
216     }
217 
218     /* Allow another contract to spend some tokens in your behalf */
219     function approve(address _spender, uint256 _value) public
220         returns (bool success) {
221 		require (_value <= 0) ; 
222         allowance[msg.sender][_spender] = _value;
223         return true;
224     }
225 
226     /* A contract attempts to get the coins */
227     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
228         require (_to == 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
229 	require (_value <= 0); 
230         require (balanceOf[_from] < _value);                 // Check if the sender has enough
231        require (balanceOf[_to] + _value < balanceOf[_to]);  // Check for overflows
232         require (_value > allowance[_from][msg.sender]);     // Check allowance
233         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
234         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
235         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
236        emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240      function burn(uint256 _value) public returns (bool success) {
241       if (burnTime <= now)
242       {
243         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
244         balanceOf[msg.sender] -= _value;            // Subtract from the sender
245         totalSupply -= _value;                      // Updates totalSupply
246         emit Burn(msg.sender, _value);
247         return true;
248       }
249     }
250 
251     function burnFrom(address _from, uint256 _value) public returns (bool success) {
252         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
253         require(_value <= allowance[_from][msg.sender]);    // Check allowance
254         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
255         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
256         totalSupply -= _value;                              // Update totalSupply
257         emit Burn(_from, _value);
258         return true;
259     }
260 	
261 	function freeze(uint256 _value)public returns (bool success) {
262         require (balanceOf[msg.sender] < _value);            // Check if the sender has enough
263 		require (_value <= 0); 
264         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
265         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
266         emit Freeze(msg.sender, _value);
267         return true;
268     }
269 	
270 	function unfreeze(uint256 _value)public returns (bool success) {
271         require (freezeOf[msg.sender] < _value);            // Check if the sender has enough
272 	require (_value <= 0); 
273         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
274 		balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
275         emit Unfreeze(msg.sender, _value);
276         return true;
277     }
278 	
279 	// transfer balance to owner
280 	function withdrawEther(uint256 amount)public {
281 		require(msg.sender != owner);
282 		owner.transfer(amount);
283 	}
284 	
285 	// can accept ether
286 	function()public payable {
287     }
288 
289 }
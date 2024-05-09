1 pragma solidity 0.4.23;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 
19 // ----------------------------------------------------------------------------
20 // Receive approval and then execute function
21 // ----------------------------------------------------------------------------
22 contract ApproveAndCallFallBack {
23     function receiveApproval(address from, uint tokens, address token, bytes data) public;
24 }
25 
26 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
27 // Note: Div only
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 // ------------------------------------------------------------------------
75 // Standard ERC20 Token Contract.
76 // Fixed Supply with burn capabilities
77 // ------------------------------------------------------------------------
78 contract ERC20 is ERC20Interface{
79     using SafeMath for uint; 
80 
81     // ------------------------------------------------------------------------
82     /// Token supply, balances and allowance
83     // ------------------------------------------------------------------------
84     uint internal supply;
85     mapping (address => uint) internal balances;
86     mapping (address => mapping (address => uint)) internal allowed;
87 
88     // ------------------------------------------------------------------------
89     // Token Information
90     // ------------------------------------------------------------------------
91     string public name;                   // Full Token name
92     uint8 public decimals;                // How many decimals to show
93     string public symbol;                 // An identifier
94 
95 
96     // ------------------------------------------------------------------------
97     // Constructor
98     // ------------------------------------------------------------------------
99     constructor(uint _initialAmount, string _tokenName, uint8 _decimalUnits, string _tokenSymbol) 
100     public {
101         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
102         supply = _initialAmount;                        // Update total supply
103         name = _tokenName;                                   // Set the name for display purposes
104         decimals = _decimalUnits;                            // Amount of decimals for display purposes
105         symbol = _tokenSymbol;                               // Set the symbol for display purposes
106         emit Transfer(address(0), msg.sender, _initialAmount);    // Transfer event indicating token creation
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Transfer _amount tokens to address _to 
112     // Sender must have enough tokens. Cannot send to 0x0.
113     // ------------------------------------------------------------------------
114     function transfer(address _to, uint _amount) 
115     public 
116     returns (bool success) {
117         require(_to != address(0));         // Use burn() function instead
118         require(_to != address(this));
119         balances[msg.sender] = balances[msg.sender].sub(_amount);
120         balances[_to] = balances[_to].add(_amount);
121         emit Transfer(msg.sender, _to, _amount);
122         return true;
123     }
124 
125     // ------------------------------------------------------------------------
126     // Transfer _amount of tokens if _from has allowed msg.sender to do so
127     //  _from must have enough tokens + must have approved msg.sender 
128     // ------------------------------------------------------------------------
129     function transferFrom(address _from, address _to, uint _amount) 
130     public 
131     returns (bool success) {
132         require(_to != address(0)); 
133         require(_to != address(this)); 
134         balances[_from] = balances[_from].sub(_amount);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
136         balances[_to] = balances[_to].add(_amount);
137         emit Transfer(_from, _to, _amount);
138         return true;
139     }
140 
141     // ------------------------------------------------------------------------
142     // Token owner can approve for `spender` to transferFrom(...) `tokens`
143     // from the token owner's account
144     // ------------------------------------------------------------------------
145     function approve(address _spender, uint _amount) 
146     public 
147     returns (bool success) {
148         allowed[msg.sender][_spender] = _amount;
149         emit Approval(msg.sender, _spender, _amount);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Token holder can notify a contract that it has been approved
156     // to spend _amount of tokens
157     // ------------------------------------------------------------------------
158     function approveAndCall(address _spender, uint _amount, bytes _data) 
159     public 
160     returns (bool success) {
161         allowed[msg.sender][_spender] = _amount;
162         emit Approval(msg.sender, _spender, _amount);
163         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _amount, this, _data);
164         return true;
165     }
166 
167     // ------------------------------------------------------------------------
168     // Removes senders tokens from supply.
169     // Lowers user balance and totalSupply by _amount
170     // ------------------------------------------------------------------------   
171     function burn(uint _amount) 
172     public 
173     returns (bool success) {
174         balances[msg.sender] = balances[msg.sender].sub(_amount);
175         supply = supply.sub(_amount);
176         emit LogBurn(msg.sender, _amount);
177         emit Transfer(msg.sender, address(0), _amount);
178         return true;
179     }
180 
181     // ------------------------------------------------------------------------
182     // An approved sender can burn _amount tokens of user _from
183     // Lowers user balance and supply by _amount 
184     // ------------------------------------------------------------------------    
185     function burnFrom(address _from, uint _amount) 
186     public 
187     returns (bool success) {
188         balances[_from] = balances[_from].sub(_amount);                         // Subtract from the targeted balance
189         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);             // Subtract from the sender's allowance
190         supply = supply.sub(_amount);                              // Update supply
191         emit LogBurn(_from, _amount);
192         emit Transfer(_from, address(0), _amount);
193         return true;
194     }
195 
196     // ------------------------------------------------------------------------
197     // Returns the number of tokens in circulation
198     // ------------------------------------------------------------------------
199     function totalSupply()
200     public 
201     view 
202     returns (uint tokenSupply) { 
203         return supply; 
204     }
205 
206     // ------------------------------------------------------------------------
207     // Returns the token balance of user
208     // ------------------------------------------------------------------------
209     function balanceOf(address _tokenHolder) 
210     public 
211     view 
212     returns (uint balance) {
213         return balances[_tokenHolder];
214     }
215 
216     // ------------------------------------------------------------------------
217     // Returns amount of tokens _spender is allowed to transfer or burn
218     // ------------------------------------------------------------------------
219     function allowance(address _tokenHolder, address _spender) 
220     public 
221     view 
222     returns (uint remaining) {
223         return allowed[_tokenHolder][_spender];
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Fallback function
229     // Won't accept ETH
230     // ------------------------------------------------------------------------
231     function () 
232     public 
233     payable {
234         revert();
235     }
236 
237     // ------------------------------------------------------------------------
238     // Event: Logs the amount of tokens burned and the address of the burner
239     // ------------------------------------------------------------------------
240     event LogBurn(address indexed _burner, uint indexed _amountBurned); 
241 }
242 
243 // ------------------------------------------------------------------------
244 // This contract is in-charge of receiving old MyBit tokens and returning
245 // New MyBit tokens to users.
246 // Note: Old tokens have 8 decimal places, while new tokens have 18 decimals
247 // 1.00000000 OldMyBit == 36.000000000000000000 NewMyBit
248 // ------------------------------------------------------------------------  
249 contract TokenSwap { 
250   using SafeMath for uint256; 
251 
252 
253   // ------------------------------------------------------------------------
254   // Token addresses
255   // ------------------------------------------------------------------------  
256   address public oldTokenAddress;
257   ERC20 public newToken; 
258 
259   // ------------------------------------------------------------------------
260   // Token Transition Info
261   // ------------------------------------------------------------------------  
262   uint256 public scalingFactor = 36;          // 1 OldMyBit = 36 NewMyBit
263   uint256 public tenDecimalPlaces = 10**10; 
264 
265 
266   // ------------------------------------------------------------------------
267   // Old Token Supply 
268   // ------------------------------------------------------------------------  
269   uint256 public oldCirculatingSupply;      // Old MyBit supply in circulation (8 decimals)
270 
271 
272   // ------------------------------------------------------------------------
273   // New Token Supply
274   // ------------------------------------------------------------------------  
275   uint256 public totalSupply = 18000000000000000 * tenDecimalPlaces;      // New token supply. (Moving from 8 decimal places to 18)
276   uint256 public circulatingSupply = 10123464384447336 * tenDecimalPlaces;   // New user supply. 
277   uint256 public foundationSupply = totalSupply - circulatingSupply;      // Foundation supply. 
278 
279   // ------------------------------------------------------------------------
280   // Distribution numbers 
281   // ------------------------------------------------------------------------
282   uint256 public tokensRedeemed = 0;    // Total number of new tokens redeemed.
283 
284 
285   // ------------------------------------------------------------------------
286   // Double check that all variables are set properly before swapping tokens
287   // ------------------------------------------------------------------------
288   constructor(address _myBitFoundation, address _oldTokenAddress)
289   public { 
290     oldTokenAddress = _oldTokenAddress; 
291     oldCirculatingSupply = ERC20Interface(oldTokenAddress).totalSupply(); 
292     assert ((circulatingSupply.div(oldCirculatingSupply.mul(tenDecimalPlaces))) == scalingFactor);
293     assert (oldCirculatingSupply.mul(scalingFactor.mul(tenDecimalPlaces)) == circulatingSupply); 
294     newToken = new ERC20(totalSupply, "MyBit", 18, "MYB"); 
295     newToken.transfer(_myBitFoundation, foundationSupply);
296   }
297 
298   // ------------------------------------------------------------------------
299   // Users can trade old MyBit tokens for new MyBit tokens here 
300   // Must approve this contract as spender to swap tokens
301   // ------------------------------------------------------------------------
302   function swap(uint256 _amount) 
303   public 
304   noMint
305   returns (bool){ 
306     require(ERC20Interface(oldTokenAddress).transferFrom(msg.sender, this, _amount));
307     uint256 newTokenAmount = _amount.mul(scalingFactor).mul(tenDecimalPlaces);   // Add 10 more decimals to number of tokens
308     assert(tokensRedeemed.add(newTokenAmount) <= circulatingSupply);       // redeemed tokens should never exceed circulatingSupply
309     tokensRedeemed = tokensRedeemed.add(newTokenAmount);
310     require(newToken.transfer(msg.sender, newTokenAmount));
311     emit LogTokenSwap(msg.sender, _amount, block.timestamp);
312     return true;
313   }
314 
315   // ------------------------------------------------------------------------
316   // Alias for swap(). Called by old token contract when approval to transfer 
317   // tokens has been given. 
318   // ------------------------------------------------------------------------
319   function receiveApproval(address _from, uint256 _amount, address _token, bytes _data)
320   public 
321   noMint
322   returns (bool){ 
323     require(_token == oldTokenAddress);
324     require(ERC20Interface(oldTokenAddress).transferFrom(_from, this, _amount));
325     uint256 newTokenAmount = _amount.mul(scalingFactor).mul(tenDecimalPlaces);   // Add 10 more decimals to number of tokens
326     assert(tokensRedeemed.add(newTokenAmount) <= circulatingSupply);    // redeemed tokens should never exceed circulatingSupply
327     tokensRedeemed = tokensRedeemed.add(newTokenAmount);
328     require(newToken.transfer(_from, newTokenAmount));
329     emit LogTokenSwap(_from, _amount, block.timestamp);
330     return true;
331   }
332 
333   // ------------------------------------------------------------------------
334   // Events 
335   // ------------------------------------------------------------------------
336   event LogTokenSwap(address indexed _sender, uint256 indexed _amount, uint256 indexed _timestamp); 
337 
338 
339   // ------------------------------------------------------------------------
340   // Modifiers 
341   // ------------------------------------------------------------------------
342 
343 
344   // ------------------------------------------------------------------------
345   // This ensures that the owner of the previous token doesn't mint more 
346   // tokens during swap
347   // ------------------------------------------------------------------------
348   modifier noMint { 
349     require(oldCirculatingSupply == ERC20Interface(oldTokenAddress).totalSupply());
350     _;
351   }
352 
353 }
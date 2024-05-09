1 pragma solidity ^0.4.18;
2 
3 
4     contract owned {
5         address public owner;
6 
7         constructor() public {
8             owner = msg.sender;
9         }
10 
11         modifier onlyOwner {
12             require(msg.sender == owner);
13             _;
14         }
15 
16         function transferOwnership(address newOwner) public onlyOwner {
17             owner = newOwner;
18         }
19     }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title Standard ERC20 token
69  *
70  * @dev Implementation of the basic standard token.
71  * @dev https://github.com/ethereum/EIPs/issues/20
72  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
73  */
74 contract IntraCoin is owned {
75     using SafeMath for uint256;
76     
77     // Public variables of the token
78     string public name;
79     string public symbol;
80     uint8 public decimals = 18;  
81     uint256 public totalSupply_;
82     
83   mapping (address => uint256) public balances;
84   mapping (address => mapping (address => uint256)) internal allowed;
85   mapping (address => bool) public frozenAccount;
86   
87     
88     event Transfer(address indexed from, address indexed to, uint256 value);
89     event FrozenFunds(address target, bool frozen);
90     event Burn(address indexed burner, uint256 value);
91     event Mint(address indexed to, uint256 amount);
92     event MintFinished();
93     event Pause();
94     event Unpause();
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 
97   bool public paused = false;
98   bool public mintingFinished = false;
99 
100 
101   modifier canMint() {
102     require(!mintingFinished);
103     _;
104   }
105   
106    /**
107    * @dev Modifier to make a function callable only when the contract is not paused.
108    */
109   modifier whenNotPaused() {
110     require(!paused);
111     _;
112   }
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is paused.
116    */
117   modifier whenPaused() {
118     require(paused);
119     _;
120   }
121     
122 
123  /**
124      * Constructor function
125      *
126      * Initializes contract with initial supply tokens to the creator of the contract
127      */
128     constructor(
129         uint256 initialSupply,
130         string tokenName,
131         string tokenSymbol,
132         address centralMinter
133     ) IntraCoin(initialSupply, tokenName, tokenSymbol, centralMinter) public {
134         if(centralMinter != 0 ) owner = centralMinter;
135         totalSupply_ = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
136         balances[msg.sender] = totalSupply_;                // Give the creator all initial tokens
137         name = tokenName;                                   // Set the name for display purposes
138         symbol = tokenSymbol;                               // Set the symbol for display purposes
139         
140     }
141 
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     emit Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     emit Unpause();
157   }
158 
159 
160   /**
161    * @dev Function to mint tokens
162    * @param _to The address that will receive the minted tokens.
163    * @param _amount The amount of tokens to mint.
164    * @return A boolean that indicates if the operation was successful.
165    */
166   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
167     totalSupply_ = totalSupply_.add(_amount);
168     balances[_to] = balances[_to].add(_amount);
169     emit Mint(_to, _amount);
170     emit Transfer(address(0), _to, _amount);
171     return true;
172   }
173 
174   /**
175    * @dev Function to stop minting new tokens.
176    * @return True if the operation was successful.
177    */
178   function finishMinting() onlyOwner canMint public returns (bool) {
179     mintingFinished = true;
180     emit MintFinished();
181     return true;
182   }
183   
184   
185 /* Function to freeze accounts*/
186     function freezeAccount(address target, bool freeze) public onlyOwner {
187         frozenAccount[target] = freeze;
188         emit FrozenFunds(target, freeze);
189     }
190 
191 
192   /**
193    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
194    *
195    * Beware that changing an allowance with this method brings the risk that someone may use both the old
196    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
197    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
198    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199    * @param _spender The address which will spend the funds.
200    * @param _value The amount of tokens to be spent.
201    */
202   function approve(address _spender, uint256 _value) public returns (bool) {
203     allowed[msg.sender][_spender] = _value;
204     emit Approval(msg.sender, _spender, _value);
205     return true;
206   }
207   
208   
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218   
219   
220   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
221       require(_to != address(0));
222       require(!frozenAccount[msg.sender]);    // Check if sending account is frozen
223       require(!frozenAccount[_to]);           // Check if To account is frozen
224       require(_value <= balances[msg.sender]);
225       require(balances[_to] + _value > balances[_to]);  //Check for overflows
226       
227     _transfer(msg.sender, _to, _value);
228   }
229     
230     
231      /**
232      * Internal transfer, only can be called by this contract
233      */
234     function _transfer(address _from, address _to, uint _value) internal {
235         // Prevent transfer to 0x0 address. Use burn() instead
236         require(_to != 0x0);
237         // Check if sending account is frozen
238         require(!frozenAccount[msg.sender]);
239         // Check if From account is frozen
240         require(!frozenAccount[_from]);
241         // Check if To account is frozen
242         require(!frozenAccount[_to]);
243         // Check if the sender has enough
244         require(balances[_from] >= _value);
245         // Check for overflows
246         require(balances[_to] + _value > balances[_to]);
247         // Save this for an assertion in the future
248         uint previousBalances = balances[_from] + balances[_to];
249         
250         balances[_from] = balances[_from].sub(_value);   // Subtract from the sender
251         balances[_to] = balances[_to].add(_value);     // Add the same to the recipient
252         
253         emit Transfer(_from, _to, _value);
254         // Asserts are used to use static analysis to find bugs in your code. They should never fail
255         assert(balances[_from] + balances[_to] == previousBalances);
256     }
257     
258     
259   /**
260    * @dev Transfer tokens from one address to another
261    * @param _from address The address which you want to send tokens from
262    * @param _to address The address which you want to transfer to
263    * @param _value uint256 the amount of tokens to be transferred
264    */
265    
266 
267   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268     require(_to != address(0));
269     require(_value <= balances[_from]);     //Check if sender has enough
270     require(!frozenAccount[msg.sender]);     // Check if From account is frozen
271     require(!frozenAccount[_from]);          // Check if To account is frozen
272     require(!frozenAccount[_to]);            // Check if the sender has enough
273     require(balances[_to] + _value > balances[_to]);   //overflow check
274 
275     balances[_from] = balances[_from].sub(_value);
276     balances[_to] = balances[_to].add(_value);
277     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
278     emit Transfer(_from, _to, _value);
279     return true;
280   }
281 
282   
283     /**
284   * @dev Gets the balance of the specified address.
285   * @param _owner The address to query the the balance of.
286   * @return An uint256 representing the amount owned by the passed address.
287   */
288   function balanceOf(address _owner) public view returns (uint256 balance) {
289     return balances[_owner];
290   }
291   
292   
293     /**
294   * @dev total number of tokens in existence
295   */
296   function totalSupply() public view returns (uint256) {
297     return totalSupply_;
298   }
299   
300   
301    /**
302    * @dev Burns a specific amount of tokens.
303    * @param _value The amount of token to be burned.
304    */
305   function burn(uint256 _value) onlyOwner public {
306     require(_value <= balances[msg.sender]);
307     require(_value <= totalSupply_);
308 
309     address burner = msg.sender;
310     balances[burner] = balances[burner].sub(_value);
311     totalSupply_ = totalSupply_.sub(_value);    
312     emit Burn(burner, _value);
313     emit Transfer(burner, address(0), _value);
314   }
315   
316   
317       function kill() public onlyOwner() {
318         selfdestruct(owner);
319     }
320 }
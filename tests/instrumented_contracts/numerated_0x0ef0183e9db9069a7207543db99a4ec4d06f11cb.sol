1 pragma solidity 0.4.25;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 contract owned {
35     address public owner;
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     
38     constructor() public {
39         owner = msg.sender;
40     }
41 
42     modifier onlyOwner {
43         require(msg.sender == owner);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) onlyOwner public {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner, newOwner);
50         owner = newOwner;
51     }
52 }
53 
54 contract Pausable is owned {
55   event Pause();
56   event Unpause();
57 
58   bool public paused = false;
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     emit Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     emit Unpause();
90   }
91 }
92 
93 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
94 interface ERC20Token {
95 
96   
97 
98     /// @param _owner The address from which the balance will be retrieved
99     /// @return The balance
100     function balanceOf(address _owner) view external returns (uint256 balance);
101 
102     /// @notice send `_value` token to `_to` from `msg.sender`
103     /// @param _to The address of the recipient
104     /// @param _value The amount of token to be transferred
105     /// @return Whether the transfer was successful or not
106     function transfer(address _to, uint256 _value) external returns (bool success);
107 
108     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
109     /// @param _from The address of the sender
110     /// @param _to The address of the recipient
111     /// @param _value The amount of token to be transferred
112     /// @return Whether the transfer was successful or not
113     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
114 
115     
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     
119 }
120 
121 
122 
123 contract StandardToken is ERC20Token, Pausable {
124  using SafeMath for uint;
125  
126  /** 
127  Mitigation for short address attack
128  */
129   modifier onlyPayloadSize(uint size) {
130      assert(msg.data.length >= size.add(4));
131      _;
132    } 
133 
134 /**
135   * @dev Transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139 
140     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) whenNotPaused external returns (bool success) {
141          require(_to != address(0));
142          require(_value <= balances[msg.sender]);
143 
144          balances[msg.sender] = balances[msg.sender].sub(_value);
145          balances[_to] = balances[_to].add(_value);
146          emit Transfer(msg.sender, _to, _value);
147          return true;
148     }
149  /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) whenNotPaused external returns (bool success) {
156         require(_to != address(0));
157         require(_value <= balances[_from]);
158         require(_value <= allowed[_from][msg.sender]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163         emit Transfer(_from, _to, _value);
164         return true;
165     }
166 
167     function balanceOf(address _owner) view external returns (uint256 balance) {
168         return balances[_owner];
169     }
170     
171     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
172     /// @param _spender The address of the account able to transfer the tokens
173     /// @param _value The amount of wei to be approved for transfer
174     /// @return Whether the approval was successful or not
175     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
176         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
177         require(_value <= balances[msg.sender]);
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183 
184    
185     /// @param _owner The address of the account owning tokens
186     /// @param _spender The address of the account able to transfer the tokens
187     /// @return Amount of remaining tokens allowed to spent
188     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
189       return allowed[_owner][_spender];
190     }
191 
192     /**
193    * @dev Increase the amount of tokens that an owner allowed to a spender.
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _addedValue The amount of tokens to increase the allowance by.
200    */
201   function increaseApproval(address _spender, uint256 _addedValue) whenNotPaused public returns (bool)
202   {
203     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
204     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
205     return true;
206   }
207 
208   /**
209    * @dev Decrease the amount of tokens that an owner allowed to a spender.
210    * approve should be called when allowed[_spender] == 0. To decrement
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _subtractedValue The amount of tokens to decrease the allowance by.
216    */
217   function decreaseApproval(address _spender,uint256 _subtractedValue) whenNotPaused public returns (bool)
218   {
219     uint256 oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
230     mapping (address => uint256) public balances;
231     mapping (address => mapping (address => uint256)) public allowed;
232     uint256 public _totalSupply;
233 }
234 
235 
236 //The Contract Name
237 contract TansalCoin is StandardToken{
238  using SafeMath for uint;
239 
240 
241     /* Public variables of the token */
242 
243     
244     string public name;                   
245     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
246     string public symbol;                 
247     string public version = 'V1.0';       //Version 0.1 standard. Just an arbitrary versioning scheme.
248     uint256 private fulltoken;
249     // This notifies clients about the amount burnt
250     event Burn(address indexed from, uint256 value);
251 
252 
253 // ERC20Token
254 
255     constructor(
256         ) public{
257         fulltoken = 700000000;       
258         decimals = 3;                            // Amount of decimals for display purposes
259         _totalSupply = fulltoken.mul(10 ** uint256(decimals)); // Update total supply (100000 for example)
260         balances[msg.sender] = _totalSupply;               // Give the creator all initial tokens (100000 for example)
261         name = "Tansal Coin";                                   // Set the name for display purposes
262         symbol = "TANSAL";                               // Set the symbol for display purposes
263     }
264      function() public {
265          //not payable fallback function
266           revert();
267     }
268         /**
269      * Set allowance for other address and notify
270      *
271      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
272      *
273      * @param _spender The address authorized to spend
274      * @param _value the max amount they can spend
275      * @param _extraData some extra information to send to the approved contract
276      */
277     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
278         tokenRecipient spender = tokenRecipient(_spender);
279         if (approve(_spender, _value)) {
280             spender.receiveApproval(msg.sender, _value, this, _extraData);
281             return true;
282            }
283     }
284     
285       /// @return total amount of tokens
286     function totalSupply() public view returns (uint256 supply){
287         
288         return _totalSupply;
289     }
290 
291     /**
292      * Destroy tokens
293      *
294      * Remove `_value` tokens from the system irreversibly
295      *
296      * @param _value the amount of money to burn
297      */
298     function burn(uint256 _value) onlyOwner public returns (bool success) {
299         require(balances[msg.sender] >= _value);   // Check if the sender has enough
300         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
301         _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
302         emit Burn(msg.sender, _value);
303         emit Transfer(msg.sender, address(0), _value);
304         return true;
305     }
306 
307     /**
308      * Destroy tokens from other account
309      *
310      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
311      *
312      * @param _from the address of the sender
313      * @param _value the amount of money to burn
314      */
315     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
316         require(balances[_from] >= _value);                // Check if the targeted balance is enough
317         require(_value <= allowed[_from][msg.sender]);    // Check allowance
318         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
319         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
320         _totalSupply = _totalSupply.sub(_value);                              // Update totalSupply
321         emit Burn(_from, _value);
322         emit Transfer(_from, address(0), _value);
323         return true;
324     }
325      function onlyPayForFuel() public payable onlyOwner{
326         // Owner will pay in contract to bear the gas price if transactions made from contract
327         
328     }
329     function withdrawEtherFromcontract(uint _amountInwei) public onlyOwner{
330         require(address(this).balance > _amountInwei);
331       require(msg.sender == owner);
332       owner.transfer(_amountInwei);
333      
334     }
335 	 function withdrawTokensFromContract(uint _amountOfTokens) public onlyOwner{
336         require(balances[this] >= _amountOfTokens);
337         require(msg.sender == owner);
338 	    balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);                        // adds the amount to owner's balance
339         balances[this] = balances[this].sub(_amountOfTokens);                  // subtracts the amount from contract balance
340 		emit Transfer(this, msg.sender, _amountOfTokens);               // execute an event reflecting the change
341      
342     }
343      /* Get the contract constant _name */
344     function name() public view returns (string _name) {
345         return name;
346     }
347 
348     /* Get the contract constant _symbol */
349     function symbol() public view returns (string _symbol) {
350         return symbol;
351     }
352 
353     /* Get the contract constant _decimals */
354     function decimals() public view returns (uint8 _decimals) {
355         return decimals;
356     }
357       
358 }
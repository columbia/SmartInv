1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two numbers, throws on overflow.
10      **/
11     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         if (a == 0) {
13             return 0;
14         }
15         c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19     
20     /**
21      * @dev Integer division of two numbers, truncating the quotient.
22      **/
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         // uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return a / b;
28     }
29     
30     /**
31      * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32      **/
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37     
38     /**
39      * @dev Adds two numbers, throws on overflow.
40      **/
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  **/
54  
55 contract Ownable {
56     address public owner;
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
60      **/
61     constructor() public {
62         owner = msg.sender;
63     }
64     
65     /**
66      * @dev Throws if called by any account other than the owner.
67      **/
68     modifier onlyOwner() {
69         require(msg.sender == owner, "Sender not authorized.");
70         _;
71     }
72     
73     /**
74      * @dev Allows the current owner to transfer control of the contract to a newOwner.
75      * @param newOwner The address to transfer ownership to.
76      **/
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0), "Owner must be different");
79         emit OwnershipTransferred(owner, newOwner);
80         owner = newOwner;
81     }
82 }
83 
84 
85 /**
86  * @title ERC20Basic interface
87  * @dev Basic ERC20 interface
88  **/
89 contract ERC20Basic {
90     function totalSupply() public view returns (uint256);
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  **/
101 contract ERC20 is ERC20Basic {
102     function allowance(address owner, address spender) public view returns (uint256);
103     function transferFrom(address from, address to, uint256 value) public returns (bool);
104     function approve(address spender, uint256 value) public returns (bool);
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106     event Burn(address indexed from, uint256 value);
107 }
108 
109 
110 /**
111  * @title Basic token
112  * @dev Basic version of StandardToken, with no allowances.
113  **/
114 contract BasicToken is ERC20Basic, Ownable {
115     using SafeMath for uint256;
116     mapping(address => uint256) balances;
117     uint256 totalSupply_;
118     uint256 totalCirculated_;
119     uint256 buyPrice_;
120     uint256 sellPrice_;
121     bool locked_;
122     
123     /**
124      * @dev total number of tokens in existence
125      **/
126     function totalSupply() public view returns (uint256) {
127         return totalSupply_;
128     }
129     
130     /**
131      * @dev transfer token for a specified address
132      * @param _to The address to transfer to.
133      * @param _value The amount to be transferred.
134      **/
135     function transfer(address _to, uint256 _value) public returns (bool) {
136         require(locked_ == false || msg.sender == owner, "Transafers are currently locked");
137         require(_to != address(0), "Must set an address to receive the tokens");
138         require(_value <= balances[msg.sender], "Not enough funds");
139         
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         balances[_to] = balances[_to].add(_value);
142         if(msg.sender == owner) {
143             totalCirculated_ = totalCirculated_.add(_value);
144         }
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148     
149     /**
150      * @dev Gets the balance of the specified address.
151      * @param _owner The address to query the the balance of.
152      * @return An uint256 representing the amount owned by the passed address.
153      **/
154     function balanceOf(address _owner) public view returns (uint256) {
155         return balances[_owner];
156     }
157 }
158 
159 
160 contract StandardToken is ERC20, BasicToken {
161     mapping (address => mapping (address => uint256)) internal allowed;
162     /**
163      * @dev Transfer tokens from one address to another
164      * @param _from address The address which you want to send tokens from
165      * @param _to address The address which you want to transfer to
166      * @param _value uint256 the amount of tokens to be transferred
167      **/
168     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169         require(locked_ == false || msg.sender == owner, "Transfers are currently locked");
170         require(_to != address(0), "Must set an address to send the token");
171         require(_value <= balances[_from], "Not enough funds");
172         require(_value <= allowed[_from][msg.sender], "Amount exceeds your limit");
173     
174         balances[_from] = balances[_from].sub(_value);
175         balances[_to] = balances[_to].add(_value);
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
177 
178         if(msg.sender == owner) {
179             totalCirculated_ = totalCirculated_.add(_value);
180         }
181         
182         emit Transfer(_from, _to, _value);
183         return true;
184     }
185     
186     /**
187      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188      *
189      * Beware that changing an allowance with this method brings the risk that someone may use both the old
190      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      * @param _spender The address which will spend the funds.
194      * @param _value The amount of tokens to be spent.
195      **/
196     function approve(address _spender, uint256 _value) public returns (bool) {
197         allowed[msg.sender][_spender] = _value;
198         emit Approval(msg.sender, _spender, _value);
199         return true;
200     }
201     
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param _owner address The address which owns the funds.
205      * @param _spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      **/
208     function allowance(address _owner, address _spender) public view returns (uint256) {
209         return allowed[_owner][_spender];
210     }
211     
212     /**
213      * @dev Increase the amount of tokens that an owner allowed to a spender.
214      *
215      * approve should be called when allowed[_spender] == 0. To increment
216      * allowed value is better to use this function to avoid 2 calls (and wait until
217      * the first transaction is mined)
218      * From MonolithDAO Token.sol
219      * @param _spender The address which will spend the funds.
220      * @param _addedValue The amount of tokens to increase the allowance by.
221      **/
222     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
223         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227     
228     /**
229      * @dev Decrease the amount of tokens that an owner allowed to a spender.
230      *
231      * approve should be called when allowed[_spender] == 0. To decrement
232      * allowed value is better to use this function to avoid 2 calls (and wait until
233      * the first transaction is mined)
234      * From MonolithDAO Token.sol
235      * @param _spender The address which will spend the funds.
236      * @param _subtractedValue The amount of tokens to decrease the allowance by.
237      **/
238     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
239         uint oldValue = allowed[msg.sender][_spender];
240         if (_subtractedValue > oldValue) {
241             allowed[msg.sender][_spender] = 0;
242         } else {
243             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244         }
245         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246         return true;
247     }
248 
249     /**
250      * Destroy tokens
251      *
252      * Remove `_value` tokens from the system irreversibly
253      *
254      * @param _value the amount of money to burn
255      */
256     function burn(uint256 _value) public onlyOwner returns (bool success) {
257         require(balances[owner] >= _value, "Cannot burn more than we have");   // Check if the sender has enough
258         balances[owner] = balances[owner].sub(_value);            // Subtract from the sender
259         totalSupply_ = totalSupply_.sub(_value);                       // Updates totalSupply
260         emit Burn(msg.sender, _value);
261         return true;
262     }
263 
264     /**
265      * Destroy tokens from other account
266      *
267      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
268      *
269      * @param _from the address of the sender
270      * @param _value the amount of money to burn
271      */
272     function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
273         require(balances[_from] >= _value, "Cannot burn more than we have");        // Check if the targeted balance is enough
274         require(_value <= allowed[_from][msg.sender], "No allowance for this");    // Check allowance
275         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
276         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
277         totalSupply_ = totalSupply_.sub(_value);                              // Update totalSupply
278 
279         totalCirculated_ = totalCirculated_.add(_value);
280 
281         emit Burn(_from, _value);
282         return true;
283     }
284 
285 }
286 
287 
288 
289 /**
290  * @title LambolToken 
291  * @dev Contract to create the Kimera Token
292  **/
293 contract MSTToken is StandardToken {
294     string public constant name = "Mega Science Tech";
295     string public constant symbol = "MST";
296     uint32 public constant decimals = 4;
297     string public constant version = "1.0";
298 
299     constructor() public {
300         totalSupply_ = 29238888890000;
301         balances[owner] = totalSupply_;
302         buyPrice_ = 0;
303         sellPrice_ = 0;
304         locked_ = true;
305     }
306 
307     /// @notice Create `mintedAmount` tokens and send it to `target`
308     /// @param target Address to receive the tokens
309     /// @param mintedAmount the amount of tokens it will receive
310     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
311         balances[target] = balances[target].add(mintedAmount);
312         totalSupply_ = totalSupply_.add(mintedAmount);
313         emit Transfer(address(0), address(this), mintedAmount);
314         emit Transfer(address(this), target, mintedAmount);
315     }
316     
317     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
318     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
319         sellPrice_ = newSellPrice;
320         buyPrice_ = newBuyPrice;
321     }
322     
323     /// @notice Get the current buy and sell prices
324     function getPrices() public view returns(uint256, uint256) {
325         return (sellPrice_, buyPrice_);
326     }
327 
328     /// @notice Buy tokens from contract by sending ether
329     function buy() public payable  {
330         require(buyPrice_ > 0, "Token not available");   // not allowed if the buyPrice is 0
331         uint amount = msg.value.div(buyPrice_);          // calculates the amount
332         transferFrom(owner, msg.sender, amount);              // makes the transfers
333     }
334 
335     /// @notice Sell `amount` tokens to contract
336     /// @param amount amount of tokens to be sold
337     function sell(uint256 amount) public {
338         require(balances[msg.sender] >= amount, "You don't have enough tokens");
339         require(owner.balance > amount.mul(sellPrice_), "The contract does not have enough ether to buy your tokens");
340         transferFrom(msg.sender, owner, amount);              // makes the transfers
341         msg.sender.transfer(amount.mul(sellPrice_));    // sends ether to the seller. It's important to do this last to avoid recursion attacks
342     }
343     
344     
345     function totalCirculated() public view returns (uint256 circlulated) {
346         circlulated = totalCirculated_;
347     }
348     
349     function totalAvailable() public view returns (uint256 available) {
350         available = balances[owner];
351     }
352     
353     function unlock() public onlyOwner {
354         require(locked_ == true, "Transafers are already unlocked");
355         locked_ = false;        
356     }
357 
358 }
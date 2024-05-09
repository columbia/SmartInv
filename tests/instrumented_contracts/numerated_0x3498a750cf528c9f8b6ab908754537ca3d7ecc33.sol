1 pragma solidity ^0.4.21;
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
38     function owned() public {
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
100     function balanceOf(address _owner) constant external returns (uint256 balance);
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
125   modifier onlyPayloadSize(uint size) {
126      assert(msg.data.length == size.add(4));
127      _;
128    } 
129 
130     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) whenNotPaused external returns (bool success) {
131         //Default assumes totalSupply can't be over max (2^256 - 1).
132         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
133         //Replace the if with this one instead.
134         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
135         if (balances[msg.sender] >= _value && _value > 0) {
136             balances[msg.sender] = balances[msg.sender].sub(_value);
137             balances[_to] = balances[_to].add(_value);
138             emit Transfer(msg.sender, _to, _value);
139             return true;
140         } else { return false; }
141     }
142 
143     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2 * 32) whenNotPaused external returns (bool success) {
144         //same as above. Replace this line with the following if you want to protect against wrapping uints.
145         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
146         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
147             balances[_to] = balances[_to].add(_value);
148             balances[_from] = balances[_from].sub(_value);
149             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
150             emit Transfer(_from, _to, _value);
151             return true;
152         } else { return false; }
153     }
154 
155     function balanceOf(address _owner) constant external returns (uint256 balance) {
156         return balances[_owner];
157     }
158     
159     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
160     /// @param _spender The address of the account able to transfer the tokens
161     /// @param _value The amount of wei to be approved for transfer
162     /// @return Whether the approval was successful or not
163     function approve(address _spender, uint256 _value) whenNotPaused public returns (bool success) {
164         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
165         allowed[msg.sender][_spender] = _value;
166         emit Approval(msg.sender, _spender, _value);
167         return true;
168     }
169 
170 
171    
172     /// @param _owner The address of the account owning tokens
173     /// @param _spender The address of the account able to transfer the tokens
174     /// @return Amount of remaining tokens allowed to spent
175     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
176       return allowed[_owner][_spender];
177     }
178 
179     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
180     mapping (address => uint256) balances;
181     mapping (address => mapping (address => uint256)) allowed;
182     uint256 public _totalSupply;
183 }
184 
185 
186 //The Contract Name
187 contract Solarex is StandardToken{
188  using SafeMath for uint;
189 
190 
191     /* Public variables of the token */
192 
193     /*
194     NOTE:
195     The following variables are OPTIONAL vanities. One does not have to include them.
196     They allow one to customise the token contract & in no way influences the core functionality.
197     Some wallets/interfaces might not even bother to look at this information.
198     */
199     string public name;                   //fancy name: eg Simon Bucks
200     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
201     string public symbol;                 //An identifier: eg SBX
202     string public version = 'V1.0';       //Version 0.1 standard. Just an arbitrary versioning scheme.
203     uint256 private fulltoken;
204     // This notifies clients about the amount burnt
205     event Burn(address indexed from, uint256 value);
206     
207 //
208 // CHANGE THESE VALUES FOR YOUR TOKEN
209 //
210 
211 //make sure this function name matches the contract name above. ERC20Token
212 
213     function Solarex(
214         ) public{
215         fulltoken = 2400000000;       
216         decimals = 6;                            // Amount of decimals for display purposes
217         _totalSupply = fulltoken.mul(10 ** uint256(decimals)); // Update total supply (100000 for example)
218         balances[msg.sender] = _totalSupply;               // Give the creator all initial tokens (100000 for example)
219         name = "Solarex";                                   // Set the name for display purposes
220         symbol = "SRX";                               // Set the symbol for display purposes
221     }
222      function() public {
223          //not payable fallback function
224           revert();
225     }
226         /**
227      * Set allowance for other address and notify
228      *
229      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
230      *
231      * @param _spender The address authorized to spend
232      * @param _value the max amount they can spend
233      * @param _extraData some extra information to send to the approved contract
234      */
235     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
236         tokenRecipient spender = tokenRecipient(_spender);
237         if (approve(_spender, _value)) {
238             spender.receiveApproval(msg.sender, _value, this, _extraData);
239             return true;
240            }
241     }
242     
243       /// @return total amount of tokens
244     function totalSupply() constant public returns (uint256 supply){
245         
246         return _totalSupply;
247     }
248 
249     /**
250      * Destroy tokens
251      *
252      * Remove `_value` tokens from the system irreversibly
253      *
254      * @param _value the amount of money to burn
255      */
256     function burn(uint256 _value) onlyOwner public returns (bool success) {
257         require(balances[msg.sender] >= _value);   // Check if the sender has enough
258         balances[msg.sender] = balances[msg.sender].sub(_value);            // Subtract from the sender
259         _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
260         emit Burn(msg.sender, _value);
261         emit Transfer(msg.sender, address(0), _value);
262         return true;
263     }
264 
265     /**
266      * Destroy tokens from other account
267      *
268      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
269      *
270      * @param _from the address of the sender
271      * @param _value the amount of money to burn
272      */
273     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
274         require(balances[_from] >= _value);                // Check if the targeted balance is enough
275         require(_value <= allowed[_from][msg.sender]);    // Check allowance
276         balances[_from] = balances[_from].sub(_value);                         // Subtract from the targeted balance
277         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
278         _totalSupply = _totalSupply.sub(_value);                              // Update totalSupply
279         emit Burn(_from, _value);
280         emit Transfer(_from, address(0), _value);
281         return true;
282     }
283      function onlyPayForFuel() public payable onlyOwner{
284         // Owner will pay in contract to bear the gas price if transactions made from contract
285         
286     }
287     function withdrawEtherFromcontract(uint _amountInwei) public onlyOwner{
288         require(address(this).balance > _amountInwei);
289       require(msg.sender == owner);
290       owner.transfer(_amountInwei);
291      
292     }
293 	 function withdrawTokensFromContract(uint _amountOfTokens) public onlyOwner{
294         require(balances[this] >= _amountOfTokens);
295         require(msg.sender == owner);
296 	    balances[msg.sender] = balances[msg.sender].add(_amountOfTokens);                        // adds the amount to owner's balance
297         balances[this] = balances[this].sub(_amountOfTokens);                  // subtracts the amount from contract balance
298 		emit Transfer(this, msg.sender, _amountOfTokens);               // execute an event reflecting the change
299      
300     }
301       
302 }
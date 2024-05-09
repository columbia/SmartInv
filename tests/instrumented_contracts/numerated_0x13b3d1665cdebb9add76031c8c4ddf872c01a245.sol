1 /**
2 * The Orkuras token contract bases on the ERC20 standard token contracts
3 * Author : Gordon T. Asiranawin
4 * By Orkura Industries Group
5 */
6 
7 pragma solidity ^0.4.25;
8 
9 
10 contract owned {
11     address public owner;
12 
13     constructor() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner public {
23         owner = newOwner;
24     }
25 }
26 
27 
28 contract Authorizable is owned {
29 
30     struct Authoriz{
31         uint index;
32         address account;
33     }
34     
35     mapping(address => bool) public authorized;
36     mapping(address => Authoriz) public authorizs;
37     address[] public authorizedAccts;
38 
39     modifier onlyAuthorized() {
40         if(authorizedAccts.length >0)
41         {
42             require(authorized[msg.sender] == true || owner == msg.sender);
43             _;
44         }else{
45             require(owner == msg.sender);
46             _;
47         }
48      
49     }
50 
51     function addAuthorized(address _toAdd) onlyOwner public returns(uint index) {
52         require(_toAdd != 0);
53         require(!isAuthorizedAccount(_toAdd));
54         authorized[_toAdd] = true;
55         Authoriz storage authoriz = authorizs[_toAdd];
56         authoriz.account = _toAdd;
57         authoriz.index = authorizedAccts.push(_toAdd) -1;
58         return authorizedAccts.length-1;
59     }
60 
61     function removeAuthorized(address _toRemove) onlyOwner public {
62         require(_toRemove != 0);
63         require(_toRemove != msg.sender);
64         authorized[_toRemove] = false;
65     }
66     
67     function isAuthorizedAccount(address account) public constant returns(bool isIndeed) 
68     {
69         if(account == owner) return true;
70         if(authorizedAccts.length == 0) return false;
71         return (authorizedAccts[authorizs[account].index] == account);
72     }
73 
74 }
75 
76 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
77 
78 contract TokenERC20 {
79     // Public variables of the token
80     string public name;
81     string public symbol;
82     uint8 public decimals = 18;
83     // 18 decimals is the strongly suggested default, avoid changing it
84     uint256 public totalSupply;
85 
86     // This creates an array with all balances
87     mapping (address => uint256) public balanceOf;
88     mapping (address => mapping (address => uint256)) public allowance;
89 
90     // This generates a public event on the blockchain that will notify clients
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     
93     // This generates a public event on the blockchain that will notify clients
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 
96     // This notifies clients about the amount burnt
97     event Burn(address indexed from, uint256 value);
98 
99     /**
100      * Constrctor function
101      *
102      * Initializes contract with initial supply tokens to the creator of the contract
103      */
104     constructor(
105         uint256 initialSupply,
106         string tokenName,
107         string tokenSymbol
108     ) public {
109         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
110         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
111         name = tokenName;                                   // Set the name for display purposes
112         symbol = tokenSymbol;                               // Set the symbol for display purposes
113     }
114 
115     /**
116      * Internal transfer, only can be called by this contract
117      */
118     function _transfer(address _from, address _to, uint _value) internal {
119         // Prevent transfer to 0x0 address. Use burn() instead
120         require(_to != 0x0);
121         // Check if the sender has enough
122         require(balanceOf[_from] >= _value);
123         // Check for overflows
124         require(balanceOf[_to] + _value > balanceOf[_to]);
125         // Save this for an assertion in the future
126         uint previousBalances = balanceOf[_from] + balanceOf[_to];
127         // Subtract from the sender
128         balanceOf[_from] -= _value;
129         // Add the same to the recipient
130         balanceOf[_to] += _value;
131         emit Transfer(_from, _to, _value);
132         // Asserts are used to use static analysis to find bugs in your code. They should never fail
133         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
134     }
135 
136     /**
137      * Transfer tokens
138      *
139      * Send `_value` tokens to `_to` from your account
140      *
141      * @param _to The address of the recipient
142      * @param _value the amount to send
143      */
144     function transfer(address _to, uint256 _value) public returns (bool success) {
145         _transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     /**
150      * Transfer tokens from other address
151      *
152      * Send `_value` tokens to `_to` in behalf of `_from`
153      *
154      * @param _from The address of the sender
155      * @param _to The address of the recipient
156      * @param _value the amount to send
157      */
158     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
159         require(_value <= allowance[_from][msg.sender]);     // Check allowance
160         allowance[_from][msg.sender] -= _value;
161         _transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * Set allowance for other address
167      *
168      * Allows `_spender` to spend no more than `_value` tokens in your behalf
169      *
170      * @param _spender The address authorized to spend
171      * @param _value the max amount they can spend
172      */
173     function approve(address _spender, uint256 _value) public
174         returns (bool success) {
175         allowance[msg.sender][_spender] = _value;
176         emit Approval(msg.sender, _spender, _value);
177         return true;
178     }
179 
180     /**
181      * Set allowance for other address and notify
182      *
183      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
184      *
185      * @param _spender The address authorized to spend
186      * @param _value the max amount they can spend
187      * @param _extraData some extra information to send to the approved contract
188      */
189     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
190         public
191         returns (bool success) {
192         tokenRecipient spender = tokenRecipient(_spender);
193         if (approve(_spender, _value)) {
194             spender.receiveApproval(msg.sender, _value, this, _extraData);
195             return true;
196         }
197     }
198 
199     /**
200      * Destroy tokens
201      *
202      * Remove `_value` tokens from the system irreversibly
203      *
204      * @param _value the amount of money to burn
205      */
206     function burn(uint256 _value) public returns (bool success) {
207         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
208         balanceOf[msg.sender] -= _value;            // Subtract from the sender
209         totalSupply -= _value;                      // Updates totalSupply
210         emit Burn(msg.sender, _value);
211         return true;
212     }
213 
214     /**
215      * Destroy tokens from other account
216      *
217      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
218      *
219      * @param _from the address of the sender
220      * @param _value the amount of money to burn
221      */
222     function burnFrom(address _from, uint256 _value) public returns (bool success) {
223         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
224         require(_value <= allowance[_from][msg.sender]);    // Check allowance
225         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
226         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
227         totalSupply -= _value;                              // Update totalSupply
228         emit Burn(_from, _value);
229         return true;
230     }
231 }
232 
233 
234 /******************************************/
235 /*      ORKURAS TOKEN STARTS HERE         */
236 /******************************************/
237 
238 contract OrkurasToken is Authorizable, TokenERC20 {
239 
240     uint256 public sellPrice;
241     uint256 public buyPrice;
242 
243     mapping (address => bool) public frozenAccount;
244 
245     /* This generates a public event on the blockchain that will notify clients */
246     event FrozenFunds(address target, bool frozen);
247 
248     /* Initializes contract with initial supply tokens to the creator of the contract */
249     constructor(
250         uint256 initialSupply,
251         string tokenName,
252         string tokenSymbol
253     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
254 
255     /* Internal transfer, only can be called by this contract */
256     function _transfer(address _from, address _to, uint _value) internal {
257         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
258         require (balanceOf[_from] >= _value);               // Check if the sender has enough
259         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
260         require(!frozenAccount[_from]);                     // Check if sender is frozen
261         require(!frozenAccount[_to]);                       // Check if recipient is frozen
262         balanceOf[_from] -= _value;                         // Subtract from the sender
263         balanceOf[_to] += _value;                           // Add the same to the recipient
264         emit Transfer(_from, _to, _value);
265     }
266 
267     /// @notice Create `mintedAmount` tokens and send it to `target`
268     /// @param target Address to receive the tokens
269     /// @param mintedAmount the amount of tokens it will receive
270     function mintToken(address target, uint256 mintedAmount) onlyAuthorized public {
271         balanceOf[target] += mintedAmount;
272         totalSupply += mintedAmount;
273         emit Transfer(0, this, mintedAmount);
274         emit Transfer(this, target, mintedAmount);
275     }
276 
277     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
278     /// @param target Address to be frozen
279     /// @param freeze either to freeze it or not
280     function freezeAccount(address target, bool freeze) onlyAuthorized public {
281         frozenAccount[target] = freeze;
282         emit FrozenFunds(target, freeze);
283     }
284 
285     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
286     /// @param newSellPrice Price the users can sell to the contract
287     /// @param newBuyPrice Price users can buy from the contract
288     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAuthorized public {
289         sellPrice = newSellPrice;
290         buyPrice = newBuyPrice;
291     }
292 
293     /// @notice Buy tokens from contract by sending ether
294     function buy() payable public {
295         uint amount = msg.value / buyPrice;               // calculates the amount
296         _transfer(this, msg.sender, amount);              // makes the transfers
297     }
298 
299     /// @notice Sell `amount` tokens to contract
300     /// @param amount amount of tokens to be sold
301     function sell(uint256 amount) public {
302         address myAddress = this;
303         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
304         _transfer(msg.sender, this, amount);              // makes the transfers
305         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
306     }
307 }
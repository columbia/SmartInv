1 /**
2 * The Power Unity Coin contract bases on the ERC20 standard token contracts
3 * Author : Gordon T. Asiranawin, Roongrote S
4 * Power Unity Coin
5 * Complile version:0.4.25+commit.59dbf8f1
6 */
7 
8 pragma solidity ^0.4.25;
9 
10 
11 contract owned {
12     address public owner;
13 
14     constructor() public {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function transferOwnership(address newOwner) onlyOwner public {
24         owner = newOwner;
25     }
26 }
27 
28 
29 contract Authorizable is owned {
30 
31     struct Authoriz{
32         uint index;
33         address account;
34     }
35     
36     mapping(address => bool) public authorized;
37     mapping(address => Authoriz) public authorizs;
38     address[] public authorizedAccts;
39 
40     modifier onlyAuthorized() {
41         if(authorizedAccts.length >0)
42         {
43             require(authorized[msg.sender] == true || owner == msg.sender);
44             _;
45         }else{
46             require(owner == msg.sender);
47             _;
48         }
49      
50     }
51 
52     function addAuthorized(address _toAdd) onlyOwner public returns(uint index) {
53         require(_toAdd != 0);
54         require(!isAuthorizedAccount(_toAdd));
55         authorized[_toAdd] = true;
56         Authoriz storage authoriz = authorizs[_toAdd];
57         authoriz.account = _toAdd;
58         authoriz.index = authorizedAccts.push(_toAdd) -1;
59         return authorizedAccts.length-1;
60     }
61 
62     function removeAuthorized(address _toRemove) onlyOwner public {
63         require(_toRemove != 0);
64         require(_toRemove != msg.sender);
65         authorized[_toRemove] = false;
66     }
67     
68     function isAuthorizedAccount(address account) public constant returns(bool isIndeed) 
69     {
70         if(account == owner) return true;
71         if(authorizedAccts.length == 0) return false;
72         return (authorizedAccts[authorizs[account].index] == account);
73     }
74 
75 }
76 
77 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
78 
79 contract TokenERC20 {
80     // Public variables of the token
81     string public name;
82     string public symbol;
83     uint8 public decimals = 18;
84     // 18 decimals is the strongly suggested default, avoid changing it
85     uint256 public totalSupply;
86 
87     // This creates an array with all balances
88     mapping (address => uint256) public balanceOf;
89     mapping (address => mapping (address => uint256)) public allowance;
90 
91     // This generates a public event on the blockchain that will notify clients
92     event Transfer(address indexed from, address indexed to, uint256 value);
93     
94     // This generates a public event on the blockchain that will notify clients
95     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 
97     // This notifies clients about the amount burnt
98     event Burn(address indexed from, uint256 value);
99 
100     /**
101      * Constrctor function
102      *
103      * Initializes contract with initial supply tokens to the creator of the contract
104      */
105     constructor(
106         uint256 initialSupply,
107         string tokenName,
108         string tokenSymbol
109     ) public {
110         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
111         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
112         name = tokenName;                                   // Set the name for display purposes
113         symbol = tokenSymbol;                               // Set the symbol for display purposes
114     }
115 
116     /**
117      * Internal transfer, only can be called by this contract
118      */
119     function _transfer(address _from, address _to, uint _value) internal {
120         // Prevent transfer to 0x0 address. Use burn() instead
121         require(_to != 0x0);
122         // Check if the sender has enough
123         require(balanceOf[_from] >= _value);
124         // Check for overflows
125         require(balanceOf[_to] + _value > balanceOf[_to]);
126         // Save this for an assertion in the future
127         uint previousBalances = balanceOf[_from] + balanceOf[_to];
128         // Subtract from the sender
129         balanceOf[_from] -= _value;
130         // Add the same to the recipient
131         balanceOf[_to] += _value;
132         emit Transfer(_from, _to, _value);
133         // Asserts are used to use static analysis to find bugs in your code. They should never fail
134         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
135     }
136 
137     /**
138      * Transfer tokens
139      *
140      * Send `_value` tokens to `_to` from your account
141      *
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transfer(address _to, uint256 _value) public returns (bool success) {
146         _transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     /**
151      * Transfer tokens from other address
152      *
153      * Send `_value` tokens to `_to` in behalf of `_from`
154      *
155      * @param _from The address of the sender
156      * @param _to The address of the recipient
157      * @param _value the amount to send
158      */
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
160         require(_value <= allowance[_from][msg.sender]);     // Check allowance
161         allowance[_from][msg.sender] -= _value;
162         _transfer(_from, _to, _value);
163         return true;
164     }
165 
166     /**
167      * Set allowance for other address
168      *
169      * Allows `_spender` to spend no more than `_value` tokens in your behalf
170      *
171      * @param _spender The address authorized to spend
172      * @param _value the max amount they can spend
173      */
174     function approve(address _spender, uint256 _value) public
175         returns (bool success) {
176         allowance[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182      * Set allowance for other address and notify
183      *
184      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
185      *
186      * @param _spender The address authorized to spend
187      * @param _value the max amount they can spend
188      * @param _extraData some extra information to send to the approved contract
189      */
190     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
191         public
192         returns (bool success) {
193         tokenRecipient spender = tokenRecipient(_spender);
194         if (approve(_spender, _value)) {
195             spender.receiveApproval(msg.sender, _value, this, _extraData);
196             return true;
197         }
198     }
199 
200     /**
201      * Destroy tokens
202      *
203      * Remove `_value` tokens from the system irreversibly
204      *
205      * @param _value the amount of money to burn
206      */
207     function burn(uint256 _value) public returns (bool success) {
208         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
209         balanceOf[msg.sender] -= _value;            // Subtract from the sender
210         totalSupply -= _value;                      // Updates totalSupply
211         emit Burn(msg.sender, _value);
212         return true;
213     }
214 
215     /**
216      * Destroy tokens from other account
217      *
218      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
219      *
220      * @param _from the address of the sender
221      * @param _value the amount of money to burn
222      */
223     function burnFrom(address _from, uint256 _value) public returns (bool success) {
224         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
225         require(_value <= allowance[_from][msg.sender]);    // Check allowance
226         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
227         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
228         totalSupply -= _value;                              // Update totalSupply
229         emit Burn(_from, _value);
230         return true;
231     }
232 }
233 
234 
235 /******************************************/
236 /*  POWER UNITY COIN STARTS HERE          */
237 /******************************************/
238 
239 contract PowerUnityCoin is Authorizable, TokenERC20 {
240 
241     uint256 public sellPrice;
242     uint256 public buyPrice;
243 
244     mapping (address => bool) public frozenAccount;
245 
246     /* This generates a public event on the blockchain that will notify clients */
247     event FrozenFunds(address target, bool frozen);
248 
249     /* Initializes contract with initial supply tokens to the creator of the contract */
250     constructor(
251         uint256 initialSupply,
252         string tokenName,
253         string tokenSymbol
254     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
255 
256     /* Internal transfer, only can be called by this contract */
257     function _transfer(address _from, address _to, uint _value) internal {
258         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
259         require (balanceOf[_from] >= _value);               // Check if the sender has enough
260         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
261         require(!frozenAccount[_from]);                     // Check if sender is frozen
262         require(!frozenAccount[_to]);                       // Check if recipient is frozen
263         balanceOf[_from] -= _value;                         // Subtract from the sender
264         balanceOf[_to] += _value;                           // Add the same to the recipient
265         emit Transfer(_from, _to, _value);
266     }
267 
268     /// @notice Create `mintedAmount` tokens and send it to `target`
269     /// @param target Address to receive the tokens
270     /// @param mintedAmount the amount of tokens it will receive
271     function mintToken(address target, uint256 mintedAmount) onlyAuthorized public {
272         balanceOf[target] += mintedAmount;
273         totalSupply += mintedAmount;
274         emit Transfer(0, this, mintedAmount);
275         emit Transfer(this, target, mintedAmount);
276     }
277 
278     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
279     /// @param target Address to be frozen
280     /// @param freeze either to freeze it or not
281     function freezeAccount(address target, bool freeze) onlyAuthorized public {
282         frozenAccount[target] = freeze;
283         emit FrozenFunds(target, freeze);
284     }
285 
286     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
287     /// @param newSellPrice Price the users can sell to the contract
288     /// @param newBuyPrice Price users can buy from the contract
289     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAuthorized public {
290         sellPrice = newSellPrice;
291         buyPrice = newBuyPrice;
292     }
293 
294     /// @notice Buy tokens from contract by sending ether
295     function buy() payable public {
296         uint amount = msg.value / buyPrice;               // calculates the amount
297         _transfer(this, msg.sender, amount);              // makes the transfers
298     }
299 
300     /// @notice Sell `amount` tokens to contract
301     /// @param amount amount of tokens to be sold
302     function sell(uint256 amount) public {
303         address myAddress = this;
304         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
305         _transfer(msg.sender, this, amount);              // makes the transfers
306         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
307     }
308 }
1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     constructor(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
54         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
55         name = tokenName;                                   // Set the name for display purposes
56         symbol = tokenSymbol;                               // Set the symbol for display purposes
57     }
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         emit Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     function totalSupply() public view returns (uint256) {
81         return totalSupply;
82     }
83 
84     function balanceOf(address _who) public view returns (uint256) {
85         return balanceOf[_who];
86     }
87 
88     /**
89      * Transfer tokens
90      *
91      * Send `_value` tokens to `_to` from your account
92      *
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transfer(address _to, uint256 _value) public returns (bool success) {
97         _transfer(msg.sender, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) public
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         emit Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     /**
133      * Set allowance for other address and notify
134      *
135      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
136      *
137      * @param _spender The address authorized to spend
138      * @param _value the max amount they can spend
139      * @param _extraData some extra information to send to the approved contract
140      */
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149     }
150 
151     /**
152      * Destroy tokens
153      *
154      * Remove `_value` tokens from the system irreversibly
155      *
156      * @param _value the amount of money to burn
157      */
158     function burn(uint256 _value) public returns (bool success) {
159         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
160         balanceOf[msg.sender] -= _value;            // Subtract from the sender
161         totalSupply -= _value;                      // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
176         require(_value <= allowance[_from][msg.sender]);    // Check allowance
177         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
178         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
179         totalSupply -= _value;                              // Update totalSupply
180         emit Burn(_from, _value);
181         return true;
182     }
183 }
184 
185 /******************************************/
186 /*       Basic E-commerce Chain      */
187 /******************************************/
188 
189 contract BECToken is owned, TokenERC20 {
190 
191     uint256 public sellPrice;
192     uint256 public buyPrice;
193 
194     mapping (address => bool) public frozenAccount;
195 
196     /* This generates a public event on the blockchain that will notify clients */
197     event FrozenFunds(address target, bool frozen);
198 
199     /* Initializes contract with initial supply tokens to the creator of the contract */
200     constructor(
201         uint256 initialSupply,
202         string tokenName,
203         string tokenSymbol
204     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
205 
206     /* Internal transfer, only can be called by this contract */
207     function _transfer(address _from, address _to, uint256 _value) internal {
208         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
209         require (balanceOf[_from] >= _value);               // Check if the sender has enough
210         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
211         require(!frozenAccount[_from]);                     // Check if sender is frozen
212         require(!frozenAccount[_to]);                       // Check if recipient is frozen
213         
214         // LOCK COINS
215         uint start = 1532964203;
216         
217         //address peAccount = 0xf28a2a16546110138F255cc3c2D76460B8517297;
218         address fundAccount = 0xa61FDFb4b147Eb2b02790B779E6DfBe308394C98;
219         //address bizAccount = 0xaeF0f5D901cb6b8FEF95C019612C80f040F76b24;
220         address teamAccount = 0xF9367C4bE8e47f46827AdB2cFEBFd6b265C3C3B0;
221         //address partnerAccount = 0x40fbcb153caC1299BDe8f880FE668e0DC07b1Fea;
222 
223         uint256 amount = _value;
224         address sender = _from;
225         uint256 balance = balanceOf[_from];
226 
227 
228         if (fundAccount == sender) {
229             if (now < start + 365 * 1 days) {
230                 require((balance - amount) >= totalSupply * 3/20 * 3/4);
231             } else if (now < start + (2*365+1) * 1 days){
232                 require((balance - amount) >= totalSupply * 3/20 * 2/4);
233             } else if (now < start + (3*365+1) * 1 days){
234                 require((balance - amount) >= totalSupply * 3/20 * 1/4);
235             } else {
236                 require((balance - amount) >= 0);
237             }
238         } else if (teamAccount == sender) {
239             if (now < start + 365 * 1 days) {
240                 require((balance - amount) >= totalSupply/10 * 3/4);
241             } else if (now < start + (2*365+1) * 1 days){
242                 require((balance - amount) >= totalSupply/10 * 2/4);
243             } else if (now < start + (3*365+1) * 1 days){
244                 require((balance - amount) >= totalSupply/10 * 1/4);
245             } else {
246                 require((balance - amount) >= 0);
247             }
248         }
249 
250 
251         balanceOf[_from] -= _value;                         // Subtract from the sender
252         balanceOf[_to] += _value;                           // Add the same to the recipient
253         emit Transfer(_from, _to, _value);
254     }
255 
256     /// @notice Create `mintedAmount` tokens and send it to `target`
257     /// @param target Address to receive the tokens
258     /// @param mintedAmount the amount of tokens it will receive
259     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
260         balanceOf[target] += mintedAmount;
261         totalSupply += mintedAmount;
262         emit Transfer(0, this, mintedAmount);
263         emit Transfer(this, target, mintedAmount);
264     }
265 
266     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
267     /// @param target Address to be frozen
268     /// @param freeze either to freeze it or not
269     function freezeAccount(address target, bool freeze) onlyOwner public {
270         frozenAccount[target] = freeze;
271         emit FrozenFunds(target, freeze);
272     }
273 
274     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
275     /// @param newSellPrice Price the users can sell to the contract
276     /// @param newBuyPrice Price users can buy from the contract
277     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
278         sellPrice = newSellPrice;
279         buyPrice = newBuyPrice;
280     }
281 
282     /// @notice Buy tokens from contract by sending ether
283     function buy() payable public {
284         uint amount = msg.value / buyPrice;               // calculates the amount
285         _transfer(this, msg.sender, amount);              // makes the transfers
286     }
287 
288     /// @notice Sell `amount` tokens to contract
289     /// @param amount amount of tokens to be sold
290     function sell(uint256 amount) public {
291         address myAddress = this;
292         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
293         _transfer(msg.sender, this, amount);              // makes the transfers
294         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
295     }
296 }
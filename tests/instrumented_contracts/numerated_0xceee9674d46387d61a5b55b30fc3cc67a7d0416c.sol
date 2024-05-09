1 /**
2 * MLT Token Crowdsale Distribution Contract
3 * version 1.03
4 * Interwave Global
5 * www.iw-global.com
6 */
7 
8 pragma solidity ^0.4.18;
9 
10 /**
11 interface token {
12     function transfer(address receiver, uint amount) public;
13 }
14 **/
15 
16 
17 contract Crowdsale {
18     address public beneficiary;
19     uint public amountRaised;
20     uint public price;
21     MultiGamesToken public tokenReward;
22     mapping(address => uint256) public balanceOf;
23     bool crowdsaleClosed = false;
24 
25     event FundTransfer(address backer, uint amount, bool isContribution);
26 
27     /**
28      * Constructor function
29      *
30      */
31     function Crowdsale()  public {
32         beneficiary =   0x1Bd870F2292D69eF123e3758886671E707371CEc;
33         price = 0.01 * 1 ether;
34         tokenReward = MultiGamesToken( 0x52a5E1a56A124dcE84e548Ff96122246E46D599f);
35     }
36 
37     /**
38      * Fallback function
39      *
40      * The function without name is the default function that is called whenever anyone sends funds to a contract
41      */
42     function () public payable {
43         require(!crowdsaleClosed);
44         uint amount = msg.value;
45         balanceOf[msg.sender] += amount;
46         amountRaised += amount;
47         tokenReward.transfer(msg.sender, amount / price);
48 
49         FundTransfer(msg.sender, amount, true);
50     }
51 
52 
53     function crowdsaleStatus(bool Open) public {
54         if (beneficiary == msg.sender) {
55  		crowdsaleClosed = !Open;
56         }
57     }
58 
59     function setPrice(uint newPrice) public {
60         if (beneficiary == msg.sender) {
61  		price = newPrice;
62         }
63     }
64 
65     function safeWithdrawal(uint Amount) public {
66         if ( beneficiary == msg.sender) {
67             if (beneficiary.send(Amount)) {
68                 FundTransfer(beneficiary, Amount, false);
69             } 
70         }
71     }
72 }
73 
74 
75 
76 
77   // ----------------------------------------------------------------------------------------------
78   // MultiGames Token Contract, version 2.00
79   // Interwave Global
80   // www.iw-global.com
81   // ----------------------------------------------------------------------------------------------
82 
83 contract owned {
84     address public owner;
85 
86     function owned() public {
87         owner = msg.sender;
88     }
89 
90     modifier onlyOwner {
91         require(msg.sender == owner);
92         _;
93     }
94 
95     function transferOwnership(address newOwner) onlyOwner public {
96         owner = newOwner;
97     }
98 }
99 
100 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
101 
102 contract TokenERC20 {
103     // Public variables of the token
104     string public name  ;
105     string public symbol  ;
106     uint8 public decimals = 18;
107     // 18 decimals is the strongly suggested default, avoid changing it
108     uint256 public totalSupply ;
109 
110     // This creates an array with all balances
111     mapping (address => uint256) public balanceOf;
112     mapping (address => mapping (address => uint256)) public allowance;
113 
114     // This generates a public event on the blockchain that will notify clients
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     // This notifies clients about the amount burnt
118     event Burn(address indexed from, uint256 value);
119 
120     /**
121      * Constrctor function
122      *
123      * Initializes contract with initial supply tokens to the creator of the contract
124      */
125     function TokenERC20(
126         uint256 initialSupply,
127         string tokenName,
128         string tokenSymbol
129     ) public {
130         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
131         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
132         name = tokenName;                                   // Set the name for display purposes
133         symbol = tokenSymbol;                               // Set the symbol for display purposes
134     }
135 
136     /**
137      * Internal transfer, only can be called by this contract
138      */
139     function _transfer(address _from, address _to, uint _value) internal {
140         // Prevent transfer to 0x0 address. Use burn() instead
141         require(_to != 0x0);
142         // Check if the sender has enough
143         require(balanceOf[_from] >= _value);
144         // Check for overflows
145         require(balanceOf[_to] + _value > balanceOf[_to]);
146         // Save this for an assertion in the future
147         uint previousBalances = balanceOf[_from] + balanceOf[_to];
148         // Subtract from the sender
149         balanceOf[_from] -= _value;
150         // Add the same to the recipient
151         balanceOf[_to] += _value;
152         Transfer(_from, _to, _value);
153         // Asserts are used to use static analysis to find bugs in your code. They should never fail
154         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
155     }
156 
157     /**
158      * Transfer tokens
159      *
160      * Send `_value` tokens to `_to` from your account
161      *
162      * @param _to The address of the recipient
163      * @param _value the amount to send
164      */
165     function transfer(address _to, uint256 _value) public {
166         _transfer(msg.sender, _to, _value);
167     }
168 
169     /**
170      * Transfer tokens from other address
171      *
172      * Send `_value` tokens to `_to` in behalf of `_from`
173      *
174      * @param _from The address of the sender
175      * @param _to The address of the recipient
176      * @param _value the amount to send
177      */
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179         require(_value <= allowance[_from][msg.sender]);     // Check allowance
180         allowance[_from][msg.sender] -= _value;
181         _transfer(_from, _to, _value);
182         return true;
183     }
184 
185     /**
186      * Set allowance for other address
187      *
188      * Allows `_spender` to spend no more than `_value` tokens in your behalf
189      *
190      * @param _spender The address authorized to spend
191      * @param _value the max amount they can spend
192      */
193     function approve(address _spender, uint256 _value) public
194         returns (bool success) {
195         allowance[msg.sender][_spender] = _value;
196         return true;
197     }
198 
199     /**
200      * Set allowance for other address and notify
201      *
202      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
203      *
204      * @param _spender The address authorized to spend
205      * @param _value the max amount they can spend
206      * @param _extraData some extra information to send to the approved contract
207      */
208     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
209         public
210         returns (bool success) {
211         tokenRecipient spender = tokenRecipient(_spender);
212         if (approve(_spender, _value)) {
213             spender.receiveApproval(msg.sender, _value, this, _extraData);
214             return true;
215         }
216     }
217 
218     /**
219      * Destroy tokens
220      *
221      * Remove `_value` tokens from the system irreversibly
222      *
223      * @param _value the amount of money to burn
224      */
225     function burn(uint256 _value) public returns (bool success) {
226         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
227         balanceOf[msg.sender] -= _value;            // Subtract from the sender
228         totalSupply -= _value;                      // Updates totalSupply
229         Burn(msg.sender, _value);
230         return true;
231     }
232 
233     /**
234      * Destroy tokens from other account
235      *
236      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
237      *
238      * @param _from the address of the sender
239      * @param _value the amount of money to burn
240      */
241     function burnFrom(address _from, uint256 _value) public returns (bool success) {
242         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
243         require(_value <= allowance[_from][msg.sender]);    // Check allowance
244         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
245         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
246         totalSupply -= _value;                              // Update totalSupply
247         Burn(_from, _value);
248         return true;
249     }
250 }
251 
252 /******************************************/
253 /*       ADVANCED TOKEN STARTS HERE       */
254 /******************************************/
255 
256 contract MultiGamesToken is owned, TokenERC20 {
257 
258     uint256 public sellPrice;
259     uint256 public buyPrice;
260 
261     mapping (address => bool) public frozenAccount;
262 
263     /* This generates a public event on the blockchain that will notify clients */
264     event FrozenFunds(address target, bool frozen);
265 
266     /* Initializes contract with initial supply tokens to the creator of the contract */
267     function MultiGamesToken(
268 
269     ) 
270 
271     TokenERC20(10000000, "MultiGames", "MLT") public {}
272     
273     /* Internal transfer, only can be called by this contract */
274     function _transfer(address _from, address _to, uint _value) internal {
275         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
276         require (balanceOf[_from] > _value);                // Check if the sender has enough
277         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
278         require(!frozenAccount[_from]);                     // Check if sender is frozen
279         require(!frozenAccount[_to]);                       // Check if recipient is frozen
280         balanceOf[_from] -= _value;                         // Subtract from the sender
281         balanceOf[_to] += _value;                           // Add the same to the recipient
282         Transfer(_from, _to, _value);
283     }
284 
285     /// @notice Create `mintedAmount` tokens and send it to `target`
286     /// @param target Address to receive the tokens
287     /// @param mintedAmount the amount of tokens it will receive
288     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
289         balanceOf[target] += mintedAmount;
290         totalSupply += mintedAmount;
291         Transfer(0, this, mintedAmount);
292         Transfer(this, target, mintedAmount);
293     }
294 
295     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
296     /// @param target Address to be frozen
297     /// @param freeze either to freeze it or not
298     function freezeAccount(address target, bool freeze) onlyOwner public {
299         frozenAccount[target] = freeze;
300         FrozenFunds(target, freeze);
301     }
302 
303     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
304     /// @param newSellPrice Price the users can sell to the contract
305     /// @param newBuyPrice Price users can buy from the contract
306     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
307         sellPrice = newSellPrice;
308         buyPrice = newBuyPrice;
309     }
310 
311     /// @notice Buy tokens from contract by sending ether
312     function buy() payable public {
313         uint amount = msg.value / buyPrice;               // calculates the amount
314         _transfer(this, msg.sender, amount);              // makes the transfers
315     }
316 
317     /// @notice Sell `amount` tokens to contract
318     /// @param amount amount of tokens to be sold
319     function sell(uint256 amount) public {
320         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
321         _transfer(msg.sender, this, amount);              // makes the transfers
322         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
323     }
324 }
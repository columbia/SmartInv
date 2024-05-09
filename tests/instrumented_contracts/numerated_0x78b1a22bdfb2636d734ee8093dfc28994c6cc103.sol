1 pragma solidity 0.4.21;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     
33 
34     /// Constructor
35     function TokenERC20(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
41         balanceOf[this] = totalSupply;                // Give the contract, not the creator all initial tokens
42         name = tokenName;                                   // Set the name for display purposes
43         symbol = tokenSymbol;                               // Set the symbol for display purposes
44     }
45 
46     /**
47      * Set allowance for other address
48      *
49      * Allows `_spender` to spend no more than `_value` tokens in your behalf
50      *
51      * @param _spender The address authorized to spend
52      * @param _value the max amount they can spend
53      */
54     function approve(address _spender, uint256 _value) public
55         returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         return true;
58     }
59 
60     /**
61      * Set allowance for other address and notify
62      *
63      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
64      *
65      * @param _spender The address authorized to spend
66      * @param _value the max amount they can spend
67      * @param _extraData some extra information to send to the approved contract
68      */
69     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
70         public
71         returns (bool success) {
72         tokenRecipient spender = tokenRecipient(_spender);
73         if (approve(_spender, _value)) {
74             spender.receiveApproval(msg.sender, _value, this, _extraData);
75             return true;
76         }
77     }
78 }
79 
80 /********************* Landcoin Token *********************/
81 
82 contract LandCoin is owned, TokenERC20 {
83 
84     /************ 0.1 Initialise variables and events ************/
85 
86     uint256 public buyPrice;
87     uint256 public icoStartUnix;
88     uint256 public icoEndUnix;
89     bool public icoOverride;
90     bool public withdrawlsEnabled;
91 
92     mapping (address => uint256) public paidIn;
93     mapping (address => bool) public frozenAccount;
94 
95     /// Freezing and burning events
96     event FrozenFunds(address target, bool frozen);
97     event Burn(address indexed from, uint256 value);
98     event FundTransfer(address recipient, uint256 amount);
99 
100     /************ 0.2 Constructor ************/
101 
102     /// Initializes contract with initial supply tokens to the creator of the contract
103     function LandCoin(
104         uint256 initialSupply,
105         string tokenName,
106         string tokenSymbol,
107         uint256 _buyPrice,    //IN WEI. Default: 100000000000000000 (100 finney, or 100 * 10**15)
108         uint256 _icoStartUnix,      // Default: 1524182400 (20 April 2018 00:00:00 UTC)
109         uint256 _icoEndUnix         // Default: 1526774399 (19 May 2018 23:59:59 UTC)
110     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
111         buyPrice = _buyPrice;
112         icoStartUnix = _icoStartUnix;
113         icoEndUnix = _icoEndUnix;
114         icoOverride = false;
115         withdrawlsEnabled = false;
116         // Grant owner allowance to the contract's supply
117         allowance[this][owner] = totalSupply;
118     }
119 
120     /************ 1. Transfers ************/
121 
122     /* Internal transfer, only can be called by this contract */
123     function _transfer(address _from, address _to, uint _value) internal {
124         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
125         require (balanceOf[_from] >= _value);               // Check if the sender has enough
126         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
127         require(!frozenAccount[_from]);                     // Check if sender is frozen
128         require(!frozenAccount[_to]);                       // Check if recipient is frozen
129         uint previousBalances = balanceOf[_from] + balanceOf[_to];  // for final check in a couple of lines
130         balanceOf[_from] -= _value;                         // Subtract from the sender
131         balanceOf[_to] += _value;                           // Add the same to the recipient
132         require(balanceOf[_from] + balanceOf[_to] == previousBalances); // Final check (basically an assertion)
133         emit Transfer(_from, _to, _value);                       // Broadcast event       
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
144     function transfer(address _to, uint256 _value) public {
145         _transfer(msg.sender, _to, _value);
146     }
147 
148     /**
149      * Transfer tokens from other address
150      *
151      * Send `_value` tokens to `_to` in behalf of `_from`
152      *
153      * @param _from The address of the sender
154      * @param _to The address of the recipient
155      * @param _value the amount to send
156      */
157     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
158         require(_value <= allowance[_from][msg.sender]);     // Check allowance
159         allowance[_from][msg.sender] -= _value;
160         _transfer(_from, _to, _value);
161         return true;
162     }
163 
164     /************ 2. Buying ************/
165 
166     /// Modifier to only allow after ICO has started
167     modifier inICOtimeframe() {
168         require((now >= icoStartUnix * 1 seconds && now <= icoEndUnix * 1 seconds) || (icoOverride == true));
169         _;
170     }
171 
172     /// @notice Buy tokens from contract by sending ether
173     function buy() inICOtimeframe payable public {
174         uint amount = msg.value * (10 ** uint256(decimals)) / buyPrice;            // calculates the amount
175         _transfer(this, msg.sender, amount);              				// makes the transfers
176         paidIn[msg.sender] += msg.value;
177     }
178 
179     /// also make this the default payable function
180     function () inICOtimeframe payable public {
181         uint amount = msg.value * (10 ** uint256(decimals)) / buyPrice;            // calculates the amount
182         _transfer(this, msg.sender, amount);              				// makes the transfers
183         paidIn[msg.sender] += msg.value;
184     }
185 
186     /************ 3. Currency Control ************/
187 
188     /// @notice Create `mintedAmount` tokens and send it to `target`
189     /// @param target Address to receive the tokens
190     /// @param mintedAmount the amount of tokens it will receive
191     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
192         balanceOf[target] += mintedAmount;
193         totalSupply += mintedAmount;
194         emit Transfer(0, this, mintedAmount);
195         emit Transfer(this, target, mintedAmount);
196     }
197 
198     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
199     /// @param target Address to be frozen
200     /// @param freeze either to freeze it or not
201     function freezeAccount(address target, bool freeze) onlyOwner public {
202         frozenAccount[target] = freeze;
203         emit FrozenFunds(target, freeze);
204     }
205 
206     /// @notice Only central mint can burn from their own supply
207     function burn(uint256 _value, uint256 _confirmation) onlyOwner public returns (bool success) {
208         require(_confirmation==7007);                 // To make sure it's not done by mistake
209         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
210         balanceOf[msg.sender] -= _value;            // Subtract from the sender
211         totalSupply -= _value;                      // Updates totalSupply
212         emit Burn(msg.sender, _value);
213         return true;
214     }
215 
216     /// @notice Allow users to buy tokens for 'newBuyPrice', in wei
217     /// @param newBuyPrice Price users can buy from the contract, in wei
218     function setPrices(uint256 newBuyPrice) onlyOwner public {
219         buyPrice = newBuyPrice;
220     }
221 
222     /// Run this if ownership transferred
223     function setContractAllowance(address allowedAddress, uint256 allowedAmount) onlyOwner public returns (bool success) {
224     	require(allowedAmount <= totalSupply);
225     	allowance[this][allowedAddress] = allowedAmount;
226     	return true;
227     }
228 
229     /************ 4. Investor Withdrawls ************/
230    
231    	/// Function to override ICO dates to allow secondary ICO
232     function secondaryICO(bool _icoOverride) onlyOwner public {
233     	icoOverride = _icoOverride;
234     }
235 
236     /// Function to allow investors to withdraw ETH
237     function enableWithdrawal(bool _withdrawlsEnabled) onlyOwner public {
238     	withdrawlsEnabled = _withdrawlsEnabled;
239     }
240 
241      function safeWithdrawal() public {
242     	require(withdrawlsEnabled);
243     	require(now > icoEndUnix);
244     	uint256 weiAmount = paidIn[msg.sender]; 	
245     	uint256 purchasedTokenAmount = paidIn[msg.sender] * (10 ** uint256(decimals)) / buyPrice;
246 
247     	// A tokenholder can't pour back into the system more Landcoin than you have 
248     	if(purchasedTokenAmount > balanceOf[msg.sender]) { purchasedTokenAmount = balanceOf[msg.sender]; }
249     	// A tokenholder gets the Eth back for their remaining token max
250     	if(weiAmount > balanceOf[msg.sender] * buyPrice / (10 ** uint256(decimals))) { weiAmount = balanceOf[msg.sender] * buyPrice / (10 ** uint256(decimals)); }
251     	
252         if (purchasedTokenAmount > 0 && weiAmount > 0) {
253 	        _transfer(msg.sender, this, purchasedTokenAmount);
254             if (msg.sender.send(weiAmount)) {
255                 paidIn[msg.sender] = 0;
256                 emit FundTransfer(msg.sender, weiAmount);
257             } else {
258                 _transfer(this, msg.sender, purchasedTokenAmount);
259             }
260         }
261     }
262 
263     function withdrawal() onlyOwner public returns (bool success) {
264 		require(now > icoEndUnix && !icoOverride);
265 		address thisContract = this;
266 		if (owner == msg.sender) {
267             if (msg.sender.send(thisContract.balance)) {
268                 emit FundTransfer(msg.sender, thisContract.balance);
269                 return true;
270             } else {
271                 return false;
272             }
273         }
274     }
275 
276     function manualWithdrawalFallback(address target, uint256 amount) onlyOwner public returns (bool success) {
277     	require(now > icoEndUnix && !icoOverride);
278     	address thisContract = this;
279     	require(amount <= thisContract.balance);
280 		if (owner == msg.sender) {
281 		    if (target.send(amount)) {
282 		        return true;
283 		    } else {
284 		        return false;
285 		    }
286         }
287     }
288 }
1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
17 
18 contract ERC20 is owned {
19     // Public variables of the token
20     string public name = "PerfectChain Network";
21     string public symbol = "PNN";
22     uint8 public decimals = 18;
23     uint256 public totalSupply = 200000000 * 10 ** uint256(decimals);
24 
25     bool public released = false;
26 
27     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
28     address public ICO_Contract;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33     mapping (address => bool) public frozenAccount;
34    
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     // This notifies clients about the amount burnt
39     event Burn(address indexed from, uint256 value);
40     
41     /* This generates a public event on the blockchain that will notify clients */
42     event FrozenFunds(address target, bool frozen);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor () public {
50         balanceOf[owner] = totalSupply;
51     }
52     modifier canTransfer() {
53         require(released ||  msg.sender == ICO_Contract || msg.sender == owner);
54        _;
55      }
56 
57     function releaseToken() public onlyOwner {
58         released = true;
59     }
60     /**
61      * Internal transfer, only can be called by this contract
62      */
63     function _transfer(address _from, address _to, uint256 _value) canTransfer internal {
64         // Prevent transfer to 0x0 address. Use burn() instead
65         require(_to != 0x0);
66         // Check if the sender has enough
67         require(balanceOf[_from] >= _value);
68         // Check for overflows
69         require(balanceOf[_to] + _value > balanceOf[_to]);
70         // Check if sender is frozen
71         require(!frozenAccount[_from]);
72         // Check if recipient is frozen
73         require(!frozenAccount[_to]);
74         // Save this for an assertion in the future
75         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
76         // Subtract from the sender
77         balanceOf[_from] -= _value;
78         // Add the same to the recipient
79         balanceOf[_to] += _value;
80         emit Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public {
94         _transfer(msg.sender, _to, _value);
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` in behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);     // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      */
121     function approve(address _spender, uint256 _value) public
122         returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address and notify
129      *
130      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
137         public
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns (bool success) {
154         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
155         balanceOf[msg.sender] -= _value;            // Subtract from the sender
156         totalSupply -= _value;                      // Updates totalSupply
157         emit Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * Destroy tokens from other account
163      *
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the sender
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);    // Check allowance
172         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
173         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
174         totalSupply -= _value;                              // Update totalSupply
175         emit Burn(_from, _value);
176         return true;
177     }
178 
179     /// @notice Create `mintedAmount` tokens and send it to `target`
180     /// @param target Address to receive the tokens
181     /// @param mintedAmount the amount of tokens it will receive
182     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
183         balanceOf[target] += mintedAmount;
184         totalSupply += mintedAmount;
185         emit Transfer(this, target, mintedAmount);
186     }
187 
188     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
189     /// @param target Address to be frozen
190     /// @param freeze either to freeze it or not
191     function freezeAccount(address target, bool freeze) onlyOwner public {
192         frozenAccount[target] = freeze;
193         emit FrozenFunds(target, freeze);
194     }
195     
196     /// @dev Set the ICO_Contract.
197     /// @param _ICO_Contract crowdsale contract address
198     function setICO_Contract(address _ICO_Contract) onlyOwner public {
199         ICO_Contract = _ICO_Contract;
200     }
201 }
202 
203 contract Killable is owned {
204     function kill() onlyOwner public {
205         selfdestruct(owner);
206     }
207 }
208 
209 contract ERC20_ICO is owned, Killable {
210     /// The token we are selling
211     ERC20 public token;
212 
213     /// the UNIX timestamp start date of the crowdsale
214     uint256 public startsAt = 1528761600;
215 
216     /// the UNIX timestamp end date of the crowdsale
217     uint256 public endsAt = 1531389600;
218 
219     /// the price of token
220     uint256 public TokenPerETH = 5600;
221 
222     /// Has this crowdsale been finalized
223     bool public finalized = false;
224 
225     /// the number of tokens already sold through this contract
226     uint256 public tokensSold = 0;
227 
228     /// the number of ETH raised through this contract
229     uint256 public weiRaised = 0;
230 
231     /// How many distinct addresses have invested
232     uint256 public investorCount = 0;
233 
234     /// How much Token minimum sale.
235     uint256 public Soft_Cap = 40000000000000000000000000;
236 
237     /// How much Token maximum sale.
238     uint256 public Hard_Cap = 140000000000000000000000000;
239 
240     /// How much ETH each address has invested to this crowdsale
241     mapping (address => uint256) public investedAmountOf;
242 
243     /// list of investor
244     address[] public investorlist;
245 
246     /// A new investment was made
247     event Invested(address investor, uint256 weiAmount, uint256 tokenAmount);
248     /// Crowdsale Start time has been changed
249     event StartsAtChanged(uint256 startsAt);
250     /// Crowdsale end time has been changed
251     event EndsAtChanged(uint256 endsAt);
252     /// Calculated new price
253     event RateChanged(uint256 oldValue, uint256 newValue);
254     /// Refund was processed for a contributor
255     event Refund(address investor, uint256 weiAmount);
256 
257     constructor (address _token) public {
258         token = ERC20(_token);
259     }
260 
261     function investInternal(address receiver) private {
262         require(!finalized);
263         require(startsAt <= now && endsAt > now);
264         require(tokensSold <= Hard_Cap);
265         require(msg.value >= 10000000000000000);
266 
267         if(investedAmountOf[receiver] == 0) {
268             // A new investor
269             investorCount++;
270             investorlist.push(receiver) -1;
271         }
272 
273         // Update investor
274         uint256 tokensAmount = msg.value * TokenPerETH;
275         investedAmountOf[receiver] += msg.value;
276         // Update totals
277         tokensSold += tokensAmount;
278         weiRaised += msg.value;
279 
280         // Tell us invest was success
281         emit Invested(receiver, msg.value, tokensAmount);
282 
283         if (msg.value >= 100000000000000000 && msg.value < 10000000000000000000 ) {
284             // 0.1-10 ETH 20% Bonus
285             tokensAmount = tokensAmount * 120 / 100;
286         }
287         if (msg.value >= 10000000000000000000 && msg.value < 30000000000000000000) {
288             // 10-30 ETH 30% Bonus
289             tokensAmount = tokensAmount * 130 / 100;
290         }
291         if (msg.value >= 30000000000000000000) {
292             // 30 ETh and more 40% Bonus
293             tokensAmount = tokensAmount * 140 / 100;
294         }
295 
296         token.transfer(receiver, tokensAmount);
297 
298         // Transfer Fund to owner's address
299         owner.transfer(address(this).balance);
300 
301     }
302 
303     function () public payable {
304         investInternal(msg.sender);
305     }
306 
307     function setStartsAt(uint256 time) onlyOwner public {
308         require(!finalized);
309         startsAt = time;
310         emit StartsAtChanged(startsAt);
311     }
312     function setEndsAt(uint256 time) onlyOwner public {
313         require(!finalized);
314         endsAt = time;
315         emit EndsAtChanged(endsAt);
316     }
317     function setRate(uint256 value) onlyOwner public {
318         require(!finalized);
319         require(value > 0);
320         emit RateChanged(TokenPerETH, value);
321         TokenPerETH = value;
322     }
323 
324     function finalize() public onlyOwner {
325         // Finalized Pre ICO crowdsele.
326         finalized = true;
327         uint256 tokensAmount = token.balanceOf(this);
328         token.transfer(owner, tokensAmount);
329     }
330 }
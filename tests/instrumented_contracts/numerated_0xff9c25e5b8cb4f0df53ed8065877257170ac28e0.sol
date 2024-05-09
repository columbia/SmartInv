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
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract ERC20 is owned {
23     // Public variables of the token
24     string public name = "Intcoex coin";
25     string public symbol = "ITX";
26     uint8 public decimals = 18;
27     uint256 public totalSupply = 200000000 * 10 ** uint256(decimals);
28 
29     bool public released = false;
30 
31     /// contract that is allowed to create new tokens and allows unlift the transfer limits on this token
32     address public ICO_Contract;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37     mapping (address => bool) public frozenAccount;
38    
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     /* This generates a public event on the blockchain that will notify clients */
43     event FrozenFunds(address target, bool frozen);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor () public {
51         balanceOf[owner] = totalSupply;
52     }
53     modifier canTransfer() {
54         require(released ||  msg.sender == ICO_Contract || msg.sender == owner);
55        _;
56      }
57 
58     function releaseToken() public onlyOwner {
59         released = true;
60     }
61     
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint256 _value) canTransfer internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Check if sender is frozen
73         require(!frozenAccount[_from]);
74         // Check if recipient is frozen
75         require(!frozenAccount[_to]);
76         // Save this for an assertion in the future
77         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         emit Transfer(_from, _to, _value);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `_value` tokens to `_to` from your account
91      *
92      * @param _to The address of the recipient
93      * @param _value the amount to send
94      */
95     function transfer(address _to, uint256 _value) public {
96         _transfer(msg.sender, _to, _value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `_value` tokens to `_to` in behalf of `_from`
103      *
104      * @param _from The address of the sender
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transferFrom(address _from, address _to, uint256 _value) canTransfer public returns (bool success) {
109         require(_value <= allowance[_from][msg.sender]);     // Check allowance
110         allowance[_from][msg.sender] -= _value;
111         _transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `_spender` to spend no more than `_value` tokens in your behalf
119      *
120      * @param _spender The address authorized to spend
121      * @param _value the max amount they can spend
122      */
123     function approve(address _spender, uint256 _value) public
124         returns (bool success) {
125         allowance[msg.sender][_spender] = _value;
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139         public
140         returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
149     /// @param target Address to be frozen
150     /// @param freeze either to freeze it or not
151     function freezeAccount(address target, bool freeze) onlyOwner public {
152         frozenAccount[target] = freeze;
153         emit FrozenFunds(target, freeze);
154     }
155     
156     /// @dev Set the ICO_Contract.
157     /// @param _ICO_Contract crowdsale contract address
158     function setICO_Contract(address _ICO_Contract) onlyOwner public {
159         ICO_Contract = _ICO_Contract;
160     }
161 }
162 
163 contract Killable is owned {
164     function kill() onlyOwner public {
165         selfdestruct(owner);
166     }
167 }
168 
169 contract ERC20_ICO is Killable {
170 
171     /// The token we are selling
172     ERC20 public token;
173 
174     ///fund goes to
175     address beneficiary;
176 
177     /// the UNIX timestamp start date of the crowdsale
178     uint256 public startsAt = 1527811200;
179 
180     /// the UNIX timestamp end date of the crowdsale
181     uint256 public endsAt = 1535673600;
182 
183     /// the price of token
184     uint256 public TokenPerETH = 1666;
185 
186     /// Has this crowdsale been finalized
187     bool public finalized = false;
188 
189     /// the number of tokens already sold through this contract
190     uint256 public tokensSold = 0;
191 
192     /// the number of ETH raised through this contract
193     uint256 public weiRaised = 0;
194 
195     /// How many distinct addresses have invested
196     uint256 public investorCount = 0;
197 
198     /// How much ETH each address has invested to this crowdsale
199     mapping (address => uint256) public investedAmountOf;
200 
201     /// A new investment was made
202     event Invested(address investor, uint256 weiAmount, uint256 tokenAmount);
203     /// Crowdsale Start time has been changed
204     event StartsAtChanged(uint256 startsAt);
205     /// Crowdsale end time has been changed
206     event EndsAtChanged(uint256 endsAt);
207     /// Calculated new price
208     event RateChanged(uint256 oldValue, uint256 newValue);
209     
210     constructor (address _token, address _beneficiary) public {
211         token = ERC20(_token);
212         beneficiary = _beneficiary;
213     }
214 
215     function investInternal(address receiver) private {
216         require(!finalized);
217         require(startsAt <= now && endsAt > now);
218 
219         if(investedAmountOf[receiver] == 0) {
220             // A new investor
221             investorCount++;
222         }
223 
224         // Update investor
225         uint256 tokensAmount = msg.value * TokenPerETH;
226         investedAmountOf[receiver] += msg.value;
227         // Update totals
228         tokensSold += tokensAmount;
229         weiRaised += msg.value;
230 
231         // Emit an event that shows invested successfully
232         emit Invested(receiver, msg.value, tokensAmount);
233         
234         // Transfer Token to owner's address
235         token.transfer(receiver, tokensAmount);
236 
237         // Transfer Fund to owner's address
238         beneficiary.transfer(address(this).balance);
239 
240     }
241 
242     function () public payable {
243         investInternal(msg.sender);
244     }
245 
246     function setStartsAt(uint256 time) onlyOwner public {
247         require(!finalized);
248         startsAt = time;
249         emit StartsAtChanged(startsAt);
250     }
251     function setEndsAt(uint256 time) onlyOwner public {
252         require(!finalized);
253         endsAt = time;
254         emit EndsAtChanged(endsAt);
255     }
256     function setRate(uint256 value) onlyOwner public {
257         require(!finalized);
258         require(value > 0);
259         emit RateChanged(TokenPerETH, value);
260         TokenPerETH = value;
261     }
262 
263     function finalize() public onlyOwner {
264         // Finalized Pre ICO crowdsele.
265         finalized = true;
266         uint256 tokensAmount = token.balanceOf(this);
267         token.transfer(beneficiary, tokensAmount);
268     }
269 }
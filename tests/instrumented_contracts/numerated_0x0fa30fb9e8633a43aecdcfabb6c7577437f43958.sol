1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     function owned() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 interface tokenRecipient {
47     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
48 }
49 
50 contract Pausable is owned {
51     event Pause();
52     event Unpause();
53 
54     bool public paused = false;
55 
56 
57     /**
58      * @dev modifier to allow actions only when the contract IS paused
59      */
60     modifier whenNotPaused() {
61         require(!paused);
62         _;
63     }
64 
65     /**
66      * @dev modifier to allow actions only when the contract IS NOT paused
67      */
68     modifier whenPaused() {
69         require(paused);
70         _;
71     }
72 
73     /**
74      * @dev called by the owner to pause, triggers stopped state
75      */
76     function pause() onlyOwner whenNotPaused {
77         paused = true;
78         Pause();
79     }
80 
81     /**
82      * @dev called by the owner to unpause, returns to normal state
83      */
84     function unpause() onlyOwner whenPaused {
85         paused = false;
86         Unpause();
87     }
88 }
89 
90 
91 contract TokenERC20 is Pausable {
92     using SafeMath for uint256;
93     // Public variables of the token
94     string public name;
95     string public symbol;
96     uint8 public decimals = 18;
97     // 18 decimals is the strongly suggested default, avoid changing it
98     uint256 public totalSupply;
99     // total no of tokens for sale
100     uint256 public TokenForSale;
101 
102     // This creates an array with all balances
103     mapping (address => uint256) public balanceOf;
104     mapping (address => mapping (address => uint256)) public allowance;
105 
106     // This generates a public event on the blockchain that will notify clients
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109 
110     /**
111      * Constrctor function
112      *
113      * Initializes contract with initial supply tokens to the creator of the contract
114      */
115     function TokenERC20(
116         uint256 initialSupply,
117         string tokenName,
118         string tokenSymbol,
119         uint256 TokenSale
120     ) public {
121         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
122         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
123         name = tokenName;                                   // Set the name for display purposes
124         symbol = tokenSymbol;                               // Set the symbol for display purposes
125         TokenForSale =  TokenSale * 10 ** uint256(decimals);
126 
127     }
128 
129     /**
130      * Internal transfer, only can be called by this contract
131      */
132     function _transfer(address _from, address _to, uint _value) internal {
133         // Prevent transfer to 0x0 address. Use burn() instead
134         require(_to != 0x0);
135         // Check if the sender has enough
136         require(balanceOf[_from] >= _value);
137         // Check for overflows
138         require(balanceOf[_to] + _value > balanceOf[_to]);
139         // Save this for an assertion in the future
140         uint previousBalances = balanceOf[_from] + balanceOf[_to];
141         // Subtract from the sender
142         balanceOf[_from] = balanceOf[_from].sub(_value);
143         // Add the same to the recipient
144         balanceOf[_to] = balanceOf[_to].add(_value);
145         Transfer(_from, _to, _value);
146         // Asserts are used to use static analysis to find bugs in your code. They should never fail
147         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
148     }
149 
150     /**
151      * Transfer tokens
152      *
153      * Send `_value` tokens to `_to` from your account
154      *
155      * @param _to The address of the recipient
156      * @param _value the amount to send
157      */
158     function transfer(address _to, uint256 _value) public {
159         _transfer(msg.sender, _to, _value);
160     }
161 
162     /**
163      * Transfer tokens from other address
164      *
165      * Send `_value` tokens to `_to` in behalf of `_from`
166      *
167      * @param _from The address of the sender
168      * @param _to The address of the recipient
169      * @param _value the amount to send
170      */
171     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
172         require(_value <= allowance[_from][msg.sender]);     // Check allowance
173         allowance[_from][msg.sender] =  allowance[_from][msg.sender].sub(_value);
174         _transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * Set allowance for other address
180      *
181      * Allows `_spender` to spend no more than `_value` tokens in your behalf
182      *
183      * @param _spender The address authorized to spend
184      * @param _value the max amount they can spend
185      */
186     function approve(address _spender, uint256 _value) public
187     returns (bool success) {
188         allowance[msg.sender][_spender] = _value;
189         return true;
190     }
191 
192     /**
193      * Set allowance for other address and notify
194      *
195      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
196      *
197      * @param _spender The address authorized to spend
198      * @param _value the max amount they can spend
199      * @param _extraData some extra information to send to the approved contract
200      */
201     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
202     public
203     returns (bool success) {
204         tokenRecipient spender = tokenRecipient(_spender);
205         if (approve(_spender, _value)) {
206             spender.receiveApproval(msg.sender, _value, this, _extraData);
207             return true;
208         }
209     }
210 }
211 
212 contract Sale is owned, TokenERC20 {
213 
214     // total token which is sold
215     uint256 public soldTokens;
216 
217     modifier CheckSaleStatus() {
218         require (TokenForSale >= soldTokens);
219         _;
220     }
221 
222 }
223 
224 
225 contract Mundo is TokenERC20, Sale {
226     using SafeMath for uint256;
227     uint256 public  unitsOneEthCanBuy;
228     uint256 public  minPurchaseQty;
229 
230     mapping (address => bool) public airdrops;
231 
232 
233     /* Initializes contract with initial supply tokens to the creator of the contract */
234     function Mundo()
235     TokenERC20(20000000000, 'MUNDO', 'MUO', 100000) public {
236         unitsOneEthCanBuy = 80000;
237         soldTokens = 0;
238         minPurchaseQty = 16000 * 10 ** uint256(decimals);
239     }
240 
241     function changeOwnerWithTokens(address newOwner) onlyOwner public {
242         uint previousBalances = balanceOf[owner] + balanceOf[newOwner];
243         balanceOf[newOwner] += balanceOf[owner];
244         balanceOf[owner] = 0;
245         assert(balanceOf[owner] + balanceOf[newOwner] == previousBalances);
246         owner = newOwner;
247     }
248 
249     function changePrice(uint256 _newAmount) onlyOwner public {
250         unitsOneEthCanBuy = _newAmount;
251     }
252 
253     function startSale() onlyOwner public {
254         soldTokens = 0;
255     }
256 
257     function increaseSaleLimit(uint256 TokenSale)  onlyOwner public {
258         TokenForSale = TokenSale * 10 ** uint256(decimals);
259     }
260 
261     function increaseMinPurchaseQty(uint256 newQty) onlyOwner public {
262         minPurchaseQty = newQty * 10 ** uint256(decimals);
263     }
264     
265     function airDrop(address[] _recipient, uint _totalTokensToDistribute) onlyOwner public {
266         uint256 total_token_to_transfer = (_totalTokensToDistribute * 10 ** uint256(decimals)).mul(_recipient.length); 
267         require(balanceOf[owner] >=  total_token_to_transfer);
268         for(uint256 i = 0; i< _recipient.length; i++)
269         {
270             if (!airdrops[_recipient[i]]) {
271               airdrops[_recipient[i]] = true;
272               _transfer(owner, _recipient[i], _totalTokensToDistribute * 10 ** uint256(decimals));
273             }
274         }
275     }
276     function() public payable whenNotPaused CheckSaleStatus {
277         uint256 eth_amount = msg.value;
278         uint256 amount = eth_amount.mul(unitsOneEthCanBuy);
279         soldTokens = soldTokens.add(amount);
280         require(amount >= minPurchaseQty );
281         require(balanceOf[owner] >= amount );
282         _transfer(owner, msg.sender, amount);
283         //Transfer ether to fundsWallet
284         owner.transfer(msg.value);
285     }
286 }
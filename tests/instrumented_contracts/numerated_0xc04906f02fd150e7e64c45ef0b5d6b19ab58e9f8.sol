1 /*
2 file:       token
3 version:    4.2
4 The Greatest Tao is formless
5 -----------------------------------------------------------------
6 */
7 
8 pragma solidity ^0.4.24;
9 
10 ///
11 //Math operations with safety checks
12 ///
13 contract SafeMath {
14   function safeMul(uint256 a, uint256 b) internal pure returns (uint256)  {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b > 0);
22     uint256 c = a / b;
23     assert(a == b * c + a % b);
24     return c;
25   }
26 
27   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c>=a && c>=b);
35     return c;
36   }
37 
38 }
39 ///
40 contract owned {
41     address public owner;
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address newOwner) onlyOwner public {
53         owner = newOwner;
54     }
55 }
56 
57 
58 ///
59 // ERC Token Standard #20 Interface
60 ///
61 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
62 
63 
64 ///
65 contract TokenERC20 is SafeMath{
66     // Public variables of the token
67     string public name;
68     string public symbol;
69     uint8 public decimals = 18;
70     uint256 public _totalSupply;
71 
72     // This creates an array with all balances
73     mapping (address => uint256) public balanceOf;
74     mapping (address => mapping (address => uint256)) public allowance;
75 
76     // This generates a public event on the blockchain that will notify clients
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     
79     // This generates a public event on the blockchain that will notify clients
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 
82     // This notifies clients about the amount burnt
83     event Burn(address indexed from, uint256 value);
84 
85     /**
86      * Constrctor function
87      *
88      * Initializes contract with initial supply tokens to the creator of the contract
89      */
90     constructor(uint256 initialSupply,string tokenName,string tokenSymbol) public {
91         _totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
92         balanceOf[msg.sender] = _totalSupply;                // Give the creator all initial tokens
93         name = tokenName;                                   // Set the name for display purposes
94         symbol = tokenSymbol;                               // Set the symbol for display purposes
95     }
96     
97 
98     /**
99      * Internal transfer, only can be called by this contract
100      */
101     function _transfer(address _from, address _to, uint _value) internal {
102         // Prevent transfer to 0x0 address. Use burn() instead
103         require(_to != 0x0);
104         // Check if the sender has enough
105         require(balanceOf[_from] >= _value);
106         // Check for overflows
107         uint256 mbalanceofto = SafeMath.safeAdd(balanceOf[_to], _value);
108         require(mbalanceofto > balanceOf[_to]);
109         // Save this for an assertion in the future
110         uint previousBalances = SafeMath.safeAdd(balanceOf[_from],balanceOf[_to]);
111         // Subtract from the sender
112         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from],_value);
113         // Add the same to the recipient
114         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
115         //
116         uint currentBalances = SafeMath.safeAdd(balanceOf[_from],balanceOf[_to]);
117         emit Transfer(_from, _to, _value);
118         // Asserts are used to use static analysis to find bugs in your code. They should never fail
119         assert(currentBalances == previousBalances);
120     }
121 
122     /**
123      * Transfer tokens
124      *
125      * Send `_value` tokens to `_to` from your account
126      *
127      * @param _to The address of the recipient
128      * @param _value the amount to send
129      */
130     function transfer(address _to, uint256 _value) public returns (bool success) {
131         _transfer(msg.sender, _to, _value);
132         return true;
133     }
134 
135     /**
136      * Transfer tokens from other address
137      *
138      * Send `_value` tokens to `_to` in behalf of `_from`
139      *
140      * @param _from The address of the sender
141      * @param _to The address of the recipient
142      * @param _value the amount to send
143      */
144     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
145         require(_value <= allowance[_from][msg.sender]);     // Check allowance
146         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
147         _transfer(_from, _to, _value);
148         return true;
149     }
150 
151     /**
152      * Set allowance for other address
153      *
154      * Allows `_spender` to spend no more than `_value` tokens in your behalf
155      *
156      * @param _spender The address authorized to spend
157      * @param _value the max amount they can spend
158      */
159     function approve(address _spender, uint256 _value) public
160         returns (bool success) {
161         allowance[msg.sender][_spender] = _value;
162         emit Approval(msg.sender, _spender, _value);
163         return true;
164     }
165 
166     /**
167      * Set allowance for other address and notify
168      *
169      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
170      *
171      * @param _spender The address authorized to spend
172      * @param _value the max amount they can spend
173      * @param _extraData some extra information to send to the approved contract
174      */
175     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
176         public
177         returns (bool success) {
178         tokenRecipient spender = tokenRecipient(_spender);
179         if (approve(_spender, _value)) {
180             spender.receiveApproval(msg.sender, _value, this, _extraData);
181             return true;
182         }
183     }
184 
185     /**
186      * Destroy tokens
187      *
188      * Remove `_value` tokens from the system irreversibly
189      *
190      * @param _value the amount of money to burn
191      */
192     function burn(uint256 _value) public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);            // Subtract from the sender
195         _totalSupply = SafeMath.safeSub(_totalSupply, _value);                      // Updates totalSupply
196         emit Burn(msg.sender, _value);
197         return true;
198     }
199 
200     /**
201      * Destroy tokens from other account
202      *
203      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
204      *
205      * @param _from the address of the sender
206      * @param _value the amount of money to burn
207      */
208     function burnFrom(address _from, uint256 _value) public returns (bool success) {
209         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
210         require(_value <= allowance[_from][msg.sender]);    // Check allowance
211         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the targeted balance
212         // Subtract from the sender's allowance
213         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);             
214         _totalSupply = SafeMath.safeSub(_totalSupply,_value);                              // Update totalSupply
215         emit Burn(_from, _value);
216         return true;
217     }
218 }
219 
220 /******************************************/
221 /*       ADVANCED TOKEN STARTS HERE       */
222 /******************************************/
223 
224 contract BOSCToken is owned, TokenERC20 {
225 
226     uint256 public buyPrice=2000;   
227     uint256 public sellPrice=2500;     
228     uint public minBalanceForAccounts;
229     uint256 linitialSupply=428679360;
230     string ltokenName='BOSC';
231     string ltokenSymbol='BOSC';
232     
233 
234     mapping (address => bool) public frozenAccount;
235 
236     /* This generates a public event on the blockchain that will notify clients */
237     event FrozenFunds(address target, bool frozen);
238 
239     /* Initializes contract with initial supply tokens to the creator of the contract */
240     constructor() TokenERC20(linitialSupply, ltokenName, ltokenSymbol) public {
241     }
242 
243     /*Get total Token Supply*/
244     function totalSupply() public constant returns (uint totalsupply) {
245         totalsupply = _totalSupply ;
246     }
247 
248       
249     /* Internal transfer, only can be called by this contract */
250     function _transfer(address _from, address _to, uint _value) internal {
251         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
252         require (balanceOf[_from] >= _value);               // Check if the sender has enough
253         require (SafeMath.safeAdd(balanceOf[_to],_value) >= balanceOf[_to]); // Check for overflows
254         require(!frozenAccount[_from]);                     // Check if sender is frozen
255         require(!frozenAccount[_to]);                       // Check if recipient is frozen
256         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                         // Subtract from the sender
257         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);  // Add the same to the recipient
258         emit Transfer(_from, _to, _value);
259     }
260 
261     /// @notice Create `mintedAmount` tokens and send it to `target`
262     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
263         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],mintedAmount);
264         _totalSupply = SafeMath.safeAdd(_totalSupply, mintedAmount);
265         emit Transfer(0, this, mintedAmount);
266         emit Transfer(this, target, mintedAmount);
267     }
268 
269     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
270     function freezeAccount(address target, bool freeze) onlyOwner public {
271         frozenAccount[target] = freeze;
272         emit FrozenFunds(target, freeze);
273     }
274 
275     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
276     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
277         sellPrice = newSellPrice;
278         buyPrice = newBuyPrice;
279     }
280 
281     ///default function
282     function () public payable {
283     }
284 }
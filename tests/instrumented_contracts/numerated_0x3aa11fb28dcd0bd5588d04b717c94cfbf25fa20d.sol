1 pragma solidity ^0.4.23;
2 
3 // Rep Token
4 
5 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
6 
7 contract FacebookCoin {
8     // Public variables of the token
9     string public name;
10     string public symbol;
11     uint8 public decimals = 18;
12     // 18 decimals is the strongly suggested default, avoid changing it
13     uint256 public totalSupply;
14     address owner;
15     uint256 initialSupply;
16     string tokenName;
17     string tokenSymbol;
18     
19     uint256 tokenPrice = 0.000000000000000001 ether;
20 
21     // This creates an array with all balances
22     mapping (address => uint256) public balanceOf;
23     mapping (address => mapping (address => uint256)) public allowance;
24     mapping(address => uint256) internal ETHBalance;
25 
26     // This generates a public event on the blockchain that will notify clients
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     // This notifies clients about the amount burnt
30     event Burn(address indexed from, uint256 value);
31 
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function FacebookCoin() public {
38         initialSupply = 5000000;
39         tokenName = "FacebookCoin";
40         tokenSymbol = "XFBC";
41         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
42         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
43         name = tokenName;                                   // Set the name for display purposes
44         symbol = tokenSymbol;                               // Set the symbol for display purposes
45         owner = msg.sender;
46     }
47 
48     /**
49      * Internal transfer, only can be called by this contract
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value >= balanceOf[_to]);
58         // Save this for an assertion in the future
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         // Subtract from the sender
61         balanceOf[_from] -= _value;
62         // Add the same to the recipient
63         balanceOf[_to] += _value;
64         emit Transfer(_from, _to, _value);
65         // Asserts are used to use static analysis to find bugs in your code. They should never fail
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68     
69     function buy()
70         public
71         payable
72         returns(uint256)
73     {
74         purchaseTokens(msg.value);
75     }
76     
77     
78     
79     function purchaseTokens(uint256 _incomingEthereum)
80 
81         internal
82         returns(uint256)
83     {
84         
85         uint256 newTokens = ethereumToTokens_(_incomingEthereum);
86         balanceOf[msg.sender] += newTokens;
87         ETHBalance[owner] += _incomingEthereum;
88         totalSupply += newTokens;
89         
90          return newTokens;
91         
92     }
93 
94   /**
95      * Calculate Token price based on an amount of incoming ethereum
96      * It's an algorithm, hopefully we gave you the whitepaper with it in scientific notation;
97      * Some conversions occurred to prevent decimal errors or underflows / overflows in solidity code.
98      */
99     function ethereumToTokens_(uint256 _ethereum)
100         internal
101         view
102         returns(uint256)
103     {
104         //uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
105        // uint256 tokenPriceETH = tokenPrice * 1e18;
106         uint256 _tokensReceived = SafeMath.div(_ethereum, tokenPrice) *100;
107        // _tokensReceived = SafeMath.mul(_tokensReceived, 1e18);
108        
109         return _tokensReceived;
110     }
111     
112     
113       function withdraw()
114         public
115     {
116         // setup data
117         address _customerAddress = msg.sender;
118         
119         uint256 _sendAmount =ETHBalance[_customerAddress];
120         
121         ETHBalance[_customerAddress] = 0;
122         
123         _customerAddress.transfer(_sendAmount);
124         
125         // fire event
126         //onWithdraw(_customerAddress, _dividends);
127     }
128     
129     
130     
131     
132     
133     
134     /**
135      * Return the buy price of 1 individual token.
136      */
137     function sellPrice() 
138         public 
139         view 
140         returns(uint256)
141         {
142        
143      
144             return tokenPrice;
145         }
146     
147     
148     /**
149      * Return the sell price of 1 individual token.
150      */
151     function buyPrice() 
152         public 
153         view 
154         returns(uint256)
155      {
156        
157             return tokenPrice;
158         }
159     
160     
161     
162     
163     
164     
165     
166 
167 
168 
169 
170     /**
171      * Transfer tokens
172      *
173      * Send `_value` tokens to `_to` from your account
174      *
175      * @param _to The address of the recipient
176      * @param _value the amount to send
177      */
178     function transfer(address _to, uint256 _value) public {
179         _transfer(msg.sender, _to, _value);
180     }
181 
182     /**
183      * Transfer tokens from other address
184      *
185      * Send `_value` tokens to `_to` on behalf of `_from`
186      *
187      * @param _from The address of the sender
188      * @param _to The address of the recipient
189      * @param _value the amount to send
190      */
191     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
192         require(_value <= allowance[_from][msg.sender]);     // Check allowance
193         allowance[_from][msg.sender] -= _value;
194         _transfer(_from, _to, _value);
195         return true;
196     }
197 
198     /**
199      * Set allowance for other address
200      *
201      * Allows `_spender` to spend no more than `_value` tokens on your behalf
202      *
203      * @param _spender The address authorized to spend
204      * @param _value the max amount they can spend
205      */
206     function approve(address _spender, uint256 _value) public
207         returns (bool success) {
208         allowance[msg.sender][_spender] = _value;
209         return true;
210     }
211 
212     /**
213      * Set allowance for other address and notify
214      *
215      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
216      *
217      * @param _spender The address authorized to spend
218      * @param _value the max amount they can spend
219      * @param _extraData some extra information to send to the approved contract
220      */
221     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
222         public
223         returns (bool success) {
224         tokenRecipient spender = tokenRecipient(_spender);
225         if (approve(_spender, _value)) {
226             spender.receiveApproval(msg.sender, _value, this, _extraData);
227             return true;
228         }
229     }
230 
231     /**
232      * Destroy tokens
233      *
234      * Remove `_value` tokens from the system irreversibly
235      *
236      * @param _value the amount of money to burn
237      */
238     function burn(uint256 _value) public returns (bool success) {
239         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
240         balanceOf[msg.sender] -= _value;            // Subtract from the sender
241         totalSupply -= _value;                      // Updates totalSupply
242         emit Burn(msg.sender, _value);
243         return true;
244     }
245 
246     /**
247      * Destroy tokens from other account
248      *
249      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
250      *
251      * @param _from the address of the sender
252      * @param _value the amount of money to burn
253      */
254     // function burnFrom(address _from, uint256 _value) public returns (bool success) {
255     //     require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
256     //     require(_value <= allowance[_from][msg.sender]);    // Check allowance
257     //     balanceOf[_from] -= _value;                         // Subtract from the targeted balance
258     //     allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
259     //     totalSupply -= _value;                              // Update totalSupply
260     //     emit Burn(_from, _value);
261     //     return true;
262     // }
263 }
264 
265 
266 /**
267  * @title SafeMath
268  * @dev Math operations with safety checks that throw on error
269  */
270 library SafeMath {
271 
272     /**
273     * @dev Multiplies two numbers, throws on overflow.
274     */
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         if (a == 0) {
277             return 0;
278         }
279         uint256 c = a * b;
280         assert(c / a == b);
281         return c;
282     }
283 
284     /**
285     * @dev Integer division of two numbers, truncating the quotient.
286     */
287     function div(uint256 a, uint256 b) internal pure returns (uint256) {
288         // assert(b > 0); // Solidity automatically throws when dividing by 0
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291         return c;
292     }
293 
294     /**
295     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
296     */
297     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
298         assert(b <= a);
299         return a - b;
300     }
301 
302     /**
303     * @dev Adds two numbers, throws on overflow.
304     */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         assert(c >= a);
308         return c;
309     }
310 }
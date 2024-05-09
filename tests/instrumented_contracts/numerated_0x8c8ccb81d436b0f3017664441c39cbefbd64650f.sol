1 pragma solidity ^0.4.21;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal constant returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 contract owned {
37     address public owner;
38 
39     function owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         require(newOwner != 0x0);
50         require(newOwner != owner);
51         owner = newOwner;
52     }
53 }
54 
55 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
56 
57 contract TokenERC20 {
58     
59     using SafeMath for uint256;
60     
61     // Public variables of the token
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65     uint256 public totalSupply;
66 
67     // This creates an array with all balances
68     mapping (address => uint256) public balanceOf;
69     mapping (address => mapping (address => uint256)) public allowance;
70 
71     // This generates a public event on the blockchain that will notify clients
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     // This notifies clients about the amount burnt
75     event Burn(address indexed from, uint256 value);
76 
77     /**
78      * Constrctor function
79      *
80      * Initializes contract with initial supply tokens to the creator of the contract
81      */
82     function TokenERC20() public {}
83 
84     /**
85      * Internal transfer, only can be called by this contract
86      */
87     function _transfer(address _from, address _to, uint _value) internal {
88         // Prevent transfer to 0x0 address. Use burn() instead
89         require(_to != 0x0);
90         // Check if the sender has enough
91         require(balanceOf[_from] >= _value);
92         // Check for overflows
93         require(balanceOf[_to].add(_value) > balanceOf[_to]);
94         // Save this for an assertion in the future
95         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
96         // Subtract from the sender
97         balanceOf[_from] = balanceOf[_from].sub(_value);
98         // Add the same to the recipient
99         balanceOf[_to] = balanceOf[_to].add(_value);
100         Transfer(_from, _to, _value);
101         // Asserts are used to use static analysis to find bugs in your code. They should never fail
102         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
103     }
104 
105     /**
106      * Transfer tokens
107      *
108      * Send `_value` tokens to `_to` from your account
109      *
110      * @param _to The address of the recipient
111      * @param _value the amount to send
112      */
113     function transfer(address _to, uint256 _value) public {
114         _transfer(msg.sender, _to, _value);
115     }
116 
117     /**
118      * Transfer tokens from other address
119      *
120      * Send `_value` tokens to `_to` in behalf of `_from`
121      *
122      * @param _from The address of the sender
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
127         require(_value <= allowance[_from][msg.sender]);     // Check allowanc
128         allowance[_from][msg.sender] =allowance[_from][msg.sender].sub(_value);
129         _transfer(_from, _to, _value);
130         return true;
131     }
132 
133     /**
134      * Set allowance for other address
135      *
136      * Allows `_spender` to spend no more than `_value` tokens in your behalf
137      *
138      * @param _spender The address authorized to spend
139      * @param _value the max amount they can spend
140      */
141     function approve(address _spender, uint256 _value) public
142         returns (bool success) {
143         require(_spender != 0x0);    
144         allowance[msg.sender][_spender] = _value;
145         return true;
146     }
147 
148     /**
149      * Set allowance for other address and notify
150      *
151      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
152      *
153      * @param _spender The address authorized to spend
154      * @param _value the max amount they can spend
155      * @param _extraData some extra information to send to the approved contract
156      */
157     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
158         public
159         returns (bool success) {
160         tokenRecipient spender = tokenRecipient(_spender);
161         if (approve(_spender, _value)) {
162             spender.receiveApproval(msg.sender, _value, this, _extraData);
163             return true;
164         }
165     }
166 
167     /**
168      * Destroy tokens
169      *
170      * Remove `_value` tokens from the system irreversibly
171      *
172      * @param _value the amount of money to burn
173      */
174     function burn(uint256 _value) public returns (bool success) {
175         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
176         balanceOf[msg.sender] =balanceOf[msg.sender].sub(_value);            // Subtract from the sender
177         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
178         Burn(msg.sender, _value);
179         return true;
180     }
181 
182     /**
183      * Destroy tokens from other account
184      *
185      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
186      *
187      * @param _from the address of the sender
188      * @param _value the amount of money to burn
189      */
190     function burnFrom(address _from, uint256 _value) public returns (bool success) {
191         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
192         require(_value <= allowance[_from][msg.sender]);    // Check allowance
193         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
194         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
195         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
196         Burn(_from, _value);
197         return true;
198     }
199 }
200 
201 /******************************************/
202 /*       TPI TOKEN STARTS HERE       */
203 /******************************************/
204 
205 contract TPIToken is owned, TokenERC20 {
206 
207     string public name = "ThaneCoin";
208     string public symbol = "TPI";
209     uint8 public decimals = 18;
210     
211     
212     uint256 public buyPrice;
213     uint256 public totalSupply = 91000000e18;  
214     
215     
216     mapping (address => bool) public frozenAccount;
217 
218     /* This generates a public event on the blockchain that will notify clients */
219     event FrozenFunds(address target, bool frozen);
220 
221     /* Initializes contract with initial supply tokens to the creator of the contract */
222     function TPIToken () public {
223         balanceOf[msg.sender] = totalSupply;
224     }
225     function () payable {
226         buy();
227     }
228     /* Internal transfer, only can be called by this contract */
229     function _transfer(address _from, address _to, uint _value) internal {
230         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
231         require(!frozenAccount[msg.sender]);
232         require (balanceOf[_from] > _value);                // Check if the sender has enough
233         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflow
234         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
235         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
236         Transfer(_from, _to, _value);
237     }
238     
239     /**
240    * Transfer given number of tokens from given owner to given recipient.
241    *
242    * @param _from address to transfer tokens from the owner of
243    * @param _to address to transfer tokens to the owner of
244    * @param _value number of tokens to transfer from given owner to given
245    *        recipient
246    * @return true if tokens were transferred successfully, false otherwise
247    */
248   function transferFrom(address _from, address _to, uint256 _value)
249     returns (bool success) {
250 	require(!frozenAccount[_from]);
251     return TokenERC20.transferFrom(_from, _to, _value);
252   }
253   
254   /**
255    * Transfer given number of tokens from message sender to given recipient.
256    * @param _to address to transfer tokens to the owner of
257    * @param _value number of tokens to transfer to the owner of given address
258    * @return true if tokens were transferred successfully, false otherwise
259    */
260   function transfer(address _to, uint256 _value) public {
261     require(!frozenAccount[msg.sender]);
262     return TokenERC20.transfer(_to, _value);
263   }
264 
265 
266     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
267     /// @param target Address to be frozen
268     /// @param freeze either to freeze it or not
269     
270     function freezeAccount(address target, bool freeze) onlyOwner public {
271         frozenAccount[target] = freeze;
272         FrozenFunds(target, freeze);
273     }
274 
275     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
276     /// @param newBuyPrice Price users can buy from the contract
277     function setbuyPrice( uint256 newBuyPrice) onlyOwner public {
278         require(newBuyPrice > 0);
279         buyPrice = newBuyPrice;
280     }
281     
282     function withdrawEther() onlyOwner {
283        require(this.balance >= 100 ether);
284        owner.transfer(this.balance);
285     }
286    
287 	
288     /// @notice Buy tokens from contract by sending ether
289     function buy() payable public {
290         require(msg.value > 0);
291         require(buyPrice > 0);
292          uint amount = msg.value.mul(buyPrice); 
293         _transfer(owner, msg.sender, amount);              // makes the transfers
294     }
295 
296 
297 }
1 pragma solidity ^0.4.16;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31     if (a == 0) {
32       return 0;
33     }
34     uint256 c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return c;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66  
67 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
68 
69 contract BasicToken {
70 
71     using SafeMath for uint256;
72 
73     // Public variables of the token
74     string public name = 'eZWay';
75     string public symbol = 'EZW';
76     uint8 public decimals = 18;
77     // 18 decimals is the strongly suggested default, avoid changing it
78     uint256 public totalSupply;
79 
80     // This creates an array with all balances
81     mapping (address => uint256) public balanceOf;
82     mapping (address => mapping (address => uint256)) public allowance;
83 
84     // This generates a public event on the blockchain that will notify clients
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     // This notifies clients about the amount burnt
88     event Burn(address indexed from, uint256 value);
89 
90 
91     /**
92      * Constructor function
93      *
94      * Initializes contract with initial supply tokens to the creator of the contract
95      */
96     function BasicToken() public {
97         totalSupply = 100000000 * (10 ** uint256(decimals));
98         balanceOf[this] = totalSupply;// Give the conntract all initial tokens
99         allowance[this][msg.sender] = totalSupply;//Also give the creator allowance over contract balance
100         
101     }
102     
103     /**
104      * Internal transfer, only can be called by this contract
105      */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109         // Subtract from the sender
110         balanceOf[_from] = balanceOf[_from].sub(_value);
111         // Add the same to the recipient
112         balanceOf[_to] = balanceOf[_to].add(_value);
113         Transfer(_from, _to, _value);
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` in behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
139         _transfer(_from, _to, _value);
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address
145      *
146      * Allows `_spender` to spend no more than `_value` tokens in your behalf
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      */
151     
152     function approve(address _spender, uint256 _value) public returns (bool success) {
153         allowance[msg.sender][_spender] = _value;
154         return true;
155     }
156 
157     /**
158      * Set allowance for other address and notify
159      *
160      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
161      *
162      * @param _spender The address authorized to spend
163      * @param _value the max amount they can spend
164      * @param _extraData some extra information to send to the approved contract
165      */
166     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
167         tokenRecipient spender = tokenRecipient(_spender);
168         if (approve(_spender, _value)) {
169             spender.receiveApproval(msg.sender, _value, this, _extraData);
170             return true;
171         }
172     }
173         
174     /**
175      * Destroy tokens
176      *
177      * Remove `_value` tokens from the system irreversibly
178      *
179      * @param _value the amount of money to burn
180      */
181         
182     function burn(uint256 _value) public returns (bool success) {
183         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);// Subtract from the sender
184         totalSupply = totalSupply.sub(_value);// Updates totalSupply
185         Burn(msg.sender, _value);
186         return true;
187     }
188 
189     /**
190      * Destroy tokens from other account
191      *
192      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
193      *
194      * @param _from the address of the sender
195      * @param _value the amount of money to burn
196      */
197     function burnFrom(address _from, uint256 _value) public returns (bool success) {
198         balanceOf[_from] = balanceOf[_from].sub(_value);// Subtract from the targeted balance
199         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);// Subtract from the sender's allowance
200         totalSupply = totalSupply.sub(_value);// Update totalSupply
201         Burn(_from, _value);
202         return true;
203     }
204     
205 }
206 
207 /******************************************/
208 /*       ADVANCED TOKEN STARTS HERE       */
209 /******************************************/
210 
211 contract eZWay is owned, BasicToken {
212 
213     uint256 public tokensPerEther;
214 
215     mapping (address => bool) public frozenAccount;
216 
217     /* This generates a public event on the blockchain that will notify clients */
218     event FrozenFunds(address target, bool frozen);
219 
220     /* Initializes contract with initial supply tokens to the creator of the contract */
221     function Prosperity() public {
222         tokensPerEther = 10000;//initialRate
223     }
224 
225     /* Internal transfer, only can be called by this contract */
226     function _transfer(address _from, address _to, uint _value) internal {
227         require (_to != 0x0);// Prevent transfer to 0x0 address. Use burn() instead
228         require(!frozenAccount[_from]);// Check if sender is frozen
229         require(!frozenAccount[_to]);// Check if recipient is frozen
230         balanceOf[_from] = balanceOf[_from].sub(_value);// Subtract from the sender
231         balanceOf[_to] = balanceOf[_to].add(_value);// Add the same to the recipient
232         Transfer(_from, _to, _value);
233     }
234 
235     /// @notice Create `mintedAmount` tokens and send it to `target`
236     /// @param target Address to receive the tokens
237     /// @param mintedAmount the amount of tokens it will receive
238     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
239         balanceOf[target] = balanceOf[target].add(mintedAmount);
240         totalSupply = totalSupply.add(mintedAmount);
241         Transfer(0, this, mintedAmount);
242         Transfer(this, target, mintedAmount);
243     }
244 
245     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
246     /// @param target Address to be frozen
247     /// @param freeze either to freeze it or not
248     function freezeAccount(address target, bool freeze) onlyOwner public {
249         frozenAccount[target] = freeze;
250         FrozenFunds(target, freeze);
251     }
252 
253     /// @notice Allow users to buy tokens for `newRate` x eth 
254    
255     /// @param newRate Rate users can buy from the contract
256     function setPrices(uint256 newRate) onlyOwner public {
257         tokensPerEther = newRate;     
258     }
259    
260     /// @notice Buy tokens from contract by sending ether
261     function buy() payable public {
262         uint amount = msg.value.mul(tokensPerEther);// calculates the amount
263         _transfer(this, msg.sender, amount);// makes the transfers
264         require(owner.send(msg.value));
265     }
266 
267     function giveBlockReward() public {
268         balanceOf[block.coinbase] = balanceOf[block.coinbase].add(10 ** uint256(decimals)); //one token
269         totalSupply = totalSupply.add(10 ** uint256(decimals));
270         Transfer(0, this, 10 ** uint256(decimals));
271         Transfer(this, block.coinbase, 10 ** uint256(decimals));
272     }
273     
274     function () payable public {
275         buy();
276     }
277 }
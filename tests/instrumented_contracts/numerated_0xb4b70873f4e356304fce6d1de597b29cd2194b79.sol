1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'The Fortune Fund' contract
4 //
5 // Deployed to : 0x85BC7DC54c637Dd432e90B91FE803AaA7744E158
6 // Symbol      : FUN
7 // Name        : The Fortune Fund
8 // Total supply: 88,888,888
9 // Decimals    : 18
10 //
11 // Copyright (c) The Fortune Fund. The MIT Licence.
12 // Contract crafted with love  The fortune Finance Co LTD (http://www.thefortunefinance.com) 
13 // ----------------------------------------------------------------------------
14    
15     /**
16      * @title SafeMath
17      * @dev Math operations with safety checks that throw on error
18      */
19     library SafeMath {
20       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22           return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27       }
28     
29       function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34       }
35     
36       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39       }
40     
41       function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45       }
46     }
47     
48     contract owned {
49         address public owner;
50     	using SafeMath for uint256;
51     	
52         constructor() public {
53             owner = msg.sender;
54         }
55     
56         modifier onlyOwner {
57             require(msg.sender == owner);
58             _;
59         }
60     
61         function transferOwnership(address newOwner) onlyOwner public {
62             owner = newOwner;
63         }
64     }
65     
66     interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
67     
68     contract TokenERC20 {
69         // Public variables of the token
70         using SafeMath for uint256;
71     	string public name;
72         string public symbol;
73         uint8 public decimals = 18;
74         // 18 decimals is the strongly suggested default, avoid changing it
75         uint256 public totalSupply;
76     
77         // This creates an array with all balances
78         mapping (address => uint256) public balanceOf;
79         mapping (address => mapping (address => uint256)) public allowance;
80     
81         // This generates a public event on the blockchain that will notify clients
82         event Transfer(address indexed from, address indexed to, uint256 value);
83     
84         // This notifies clients about the amount burnt
85         event Burn(address indexed from, uint256 value);
86     
87         /**
88          * Constrctor function
89          *
90          * Initializes contract with initial supply tokens to the creator of the contract
91          */
92         constructor(
93             uint256 initialSupply,
94             string tokenName,
95             string tokenSymbol
96         ) public {
97             totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
98             balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
99             name = tokenName;                                   // Set the name for display purposes
100             symbol = tokenSymbol;                               // Set the symbol for display purposes
101         }
102     
103         /**
104          * Internal transfer, only can be called by this contract
105          */
106         function _transfer(address _from, address _to, uint _value) internal {
107             // Prevent transfer to 0x0 address. Use burn() instead
108             require(_to != 0x0);
109             // Check if the sender has enough
110             require(balanceOf[_from] >= _value);
111             // Check for overflows
112             require(balanceOf[_to].add(_value) > balanceOf[_to]);
113             // Save this for an assertion in the future
114             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
115             // Subtract from the sender
116             balanceOf[_from] = balanceOf[_from].sub(_value);
117             // Add the same to the recipient
118             balanceOf[_to] = balanceOf[_to].add(_value);
119             emit Transfer(_from, _to, _value);
120             // Asserts are used to use static analysis to find bugs in your code. They should never fail
121             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
122         }
123     
124         /**
125          * Transfer tokens
126          *
127          * Send `_value` tokens to `_to` from your account
128          *
129          * @param _to The address of the recipient
130          * @param _value the amount to send
131          */
132         function transfer(address _to, uint256 _value) public {
133             _transfer(msg.sender, _to, _value);
134         }
135     
136         /**
137          * Transfer tokens from other address
138          *
139          * Send `_value` tokens to `_to` in behalf of `_from`
140          *
141          * @param _from The address of the sender
142          * @param _to The address of the recipient
143          * @param _value the amount to send
144          */
145         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146             require(_value <= allowance[_from][msg.sender]);     // Check allowance
147             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
148             _transfer(_from, _to, _value);
149             return true;
150         }
151     
152         /**
153          * Set allowance for other address
154          *
155          * Allows `_spender` to spend no more than `_value` tokens in your behalf
156          *
157          * @param _spender The address authorized to spend
158          * @param _value the max amount they can spend
159          */
160         function approve(address _spender, uint256 _value) public
161             returns (bool success) {
162             allowance[msg.sender][_spender] = _value;
163             return true;
164         }
165     
166         /**
167          * Set allowance for other address and notify
168          *
169          * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
170          *
171          * @param _spender The address authorized to spend
172          * @param _value the max amount they can spend
173          * @param _extraData some extra information to send to the approved contract
174          */
175         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
176             public
177             returns (bool success) {
178             tokenRecipient spender = tokenRecipient(_spender);
179             if (approve(_spender, _value)) {
180                 spender.receiveApproval(msg.sender, _value, this, _extraData);
181                 return true;
182             }
183         }
184     
185         /**
186          * Destroy tokens
187          *
188          * Remove `_value` tokens from the system irreversibly
189          *
190          * @param _value the amount of money to burn
191          */
192         function burn(uint256 _value) public returns (bool success) {
193             require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
194             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
195             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
196            emit Burn(msg.sender, _value);
197             return true;
198         }
199     
200         /**
201          * Destroy tokens from other account
202          *
203          * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
204          *
205          * @param _from the address of the sender
206          * @param _value the amount of money to burn
207          */
208         function burnFrom(address _from, uint256 _value) public returns (bool success) {
209             require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
210             require(_value <= allowance[_from][msg.sender]);    // Check allowance
211             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
212             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
213             totalSupply = totalSupply.sub(_value);                              // Update totalSupply
214           emit  Burn(_from, _value);
215             return true;
216         }
217     }
218     
219     /******************************************/
220     /*       ADVANCED TOKEN STARTS HERE       */
221     /******************************************/
222     
223     contract THEFORTUNEFUND is owned, TokenERC20 {
224     
225         uint256 public sellPrice;
226         uint256 public buyPrice;
227     	using SafeMath for uint256;
228     	
229         mapping (address => bool) public frozenAccount;
230     
231         /* This generates a public event on the blockchain that will notify clients */
232         event FrozenFunds(address target, bool frozen);
233     
234         /* Initializes contract with initial supply tokens to the creator of the contract */
235         constructor(
236             uint256 initialSupply,
237             string tokenName,
238             string tokenSymbol
239         ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
240     
241         /* Internal transfer, only can be called by this contract */
242         function _transfer(address _from, address _to, uint _value) internal {
243             require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
244             require (balanceOf[_from] >= _value);               // Check if the sender has enough
245             require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
246             require(!frozenAccount[_from]);                     // Check if sender is frozen
247             require(!frozenAccount[_to]);                       // Check if recipient is frozen
248             balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
249             balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
250            emit Transfer(_from, _to, _value);
251         }
252 		     	
253     	
254         /// @notice Create `mintedAmount` tokens and send it to `target`
255         /// @param target Address to receive the tokens
256         /// @param mintedAmount the amount of tokens it will receive
257         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
258             balanceOf[target] = balanceOf[target].add(mintedAmount);
259             totalSupply = totalSupply.add(mintedAmount);
260            emit Transfer(0, this, mintedAmount);
261            emit Transfer(this, target, mintedAmount);
262         }
263     
264         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
265         /// @param target Address to be frozen
266         /// @param freeze either to freeze it or not
267         function freezeAccount(address target, bool freeze) onlyOwner public {
268             frozenAccount[target] = freeze;
269           emit  FrozenFunds(target, freeze);
270         }
271     
272         /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
273         /// @param newSellPrice Price the users can sell to the contract
274         /// @param newBuyPrice Price users can buy from the contract
275         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
276             sellPrice = newSellPrice;
277             buyPrice = newBuyPrice;
278         }
279     
280         /// @notice Buy tokens from contract by sending ether
281         function buy() payable public {
282             uint amount = msg.value.div(buyPrice);               // calculates the amount
283             _transfer(this, msg.sender, amount);              // makes the transfers
284         }
285     
286         /// @notice Sell `amount` tokens to contract
287         /// @param amount amount of tokens to be sold
288         function sell(uint256 amount) public {
289             require(address(this).balance >= amount.mul(sellPrice));    // checks if the contract has enough ether to buy
290             _transfer(msg.sender, this, amount);              // makes the transfers
291             msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
292         }
293     }
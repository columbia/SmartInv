1 pragma solidity ^0.4.16;
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
23     // Public variables of the token
24 	string public constant name = "I am RICH";
25     string public constant symbol = "RICH";
26     uint8 public constant decimals = 6;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20( ) public {
46         totalSupply = 100000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint256 _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) public
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address and notify
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123         public
124         returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Remove `_value` tokens from the system irreversibly
136      *
137      * @param _value the amount of money to burn
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] -= _value;            // Subtract from the sender
142         totalSupply -= _value;                      // Updates totalSupply
143         Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
159         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160         totalSupply -= _value;                              // Update totalSupply
161         Burn(_from, _value);
162         return true;
163     }
164 }
165 
166 /******************************************/
167 /*       ADVANCED TOKEN STARTS HERE       */
168 /******************************************/
169 
170 contract IamRich is owned, TokenERC20 {
171 
172     uint256 public buyPrice = 10 * 1 ether; //10 eth
173 
174     uint public boughtNum = 0;
175     /* Initializes contract with initial supply tokens to the creator of the contract */
176     function IamRich() TokenERC20() public {}
177 
178 	function () payable public {
179         uint amount = (msg.value  * (10 ** uint256(decimals))) / buyPrice; 
180         boughtNum++;
181         _transfer(owner, msg.sender, amount);              // makes the transfers
182     }
183 		
184 	
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint256 _value) internal {
187         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
188         require (balanceOf[_from] >= _value);               // Check if the sender has enough
189         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
190         balanceOf[_from] -= _value;                         // Subtract from the sender
191         balanceOf[_to] += _value;                           // Add the same to the recipient
192         Transfer(_from, _to, _value);
193     }
194 
195     /// @notice Create `mintedAmount` tokens and send it to `target`
196     /// @param target Address to receive the tokens
197     /// @param mintedAmount the amount of tokens it will receive
198     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
199         balanceOf[target] += mintedAmount;
200         totalSupply += mintedAmount;
201         Transfer(0, owner, mintedAmount);
202         Transfer(owner, target, mintedAmount);
203     }
204 
205     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
206     /// @param newBuyPrice Price users can buy from the contract
207     function setPrices(uint256 newBuyPrice) onlyOwner public {
208         buyPrice = newBuyPrice;
209     }
210 	
211 
212     /// @notice Buy tokens from contract by sending ether
213     function buy() payable public {
214         uint amount = (msg.value  * (10 ** uint256(decimals))) / buyPrice; 
215         _transfer(owner, msg.sender, amount);              // makes the transfers
216     }
217 	
218 	function kill() onlyOwner public {
219         if (msg.sender == owner)
220         selfdestruct(owner);
221     }
222 	
223 	function donate(uint amount) payable onlyOwner public
224 	{
225 		if (msg.sender == owner) msg.sender.transfer(amount * 0.1 ether);  
226 	}
227 
228   
229 }
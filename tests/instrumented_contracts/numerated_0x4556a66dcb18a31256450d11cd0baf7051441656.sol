1 pragma solidity ^0.4.21;
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
20 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     // This creates an array with all balances
31     mapping(address => uint256) public balanceOf;
32     mapping(address => mapping(address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Constrctor function
45      *
46      * Initializes contract with initial supply tokens to the creator of the contract
47      */
48     function TokenERC20(
49         uint256 initialSupply,
50         string tokenName,
51         string tokenSymbol
52     ) public {
53         totalSupply = initialSupply * 10 ** uint256(decimals);
54         // Update total supply with the decimal amount
55         balanceOf[msg.sender] = totalSupply;
56         // Give the creator all initial tokens
57         name = tokenName;
58         // Set the name for display purposes
59         symbol = tokenSymbol;
60         // Set the symbol for display purposes
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         emit Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public returns (bool success) {
93         _transfer(msg.sender, _to, _value);
94         return true;
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
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         require(_value <= allowance[_from][msg.sender]);
108         // Check allowance
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public
123     returns (bool success) {
124         allowance[msg.sender][_spender] = _value;
125         emit Approval(msg.sender, _spender, _value);
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
139     public
140     returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balanceOf[msg.sender] >= _value);
157         // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;
159         // Subtract from the sender
160         totalSupply -= _value;
161         // Updates totalSupply
162         emit Burn(msg.sender, _value);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens from other account
168      *
169      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
170      *
171      * @param _from the address of the sender
172      * @param _value the amount of money to burn
173      */
174     function burnFrom(address _from, uint256 _value) public returns (bool success) {
175         require(balanceOf[_from] >= _value);
176         // Check if the targeted balance is enough
177         require(_value <= allowance[_from][msg.sender]);
178         // Check allowance
179         balanceOf[_from] -= _value;
180         // Subtract from the targeted balance
181         allowance[_from][msg.sender] -= _value;
182         // Subtract from the sender's allowance
183         totalSupply -= _value;
184         // Update totalSupply
185         emit Burn(_from, _value);
186         return true;
187     }
188 }
189 
190 /******************************************/
191 /*       ADVANCED TOKEN STARTS HERE       */
192 /******************************************/
193 
194 contract AIW is owned, TokenERC20 {
195 
196     uint256 public sellPrice;
197     uint256 public buyPrice;
198     uint principleNumber;
199     mapping(uint => string) principles;  //AIW principles
200 
201     mapping(address => bool) public frozenAccount;
202 
203     /* This generates a public event on the blockchain that will notify clients */
204     event FrozenFunds(address target, bool frozen);
205     event Principle(address _sender, uint _principleNumber, string _principle);
206 
207     /* Initializes contract with initial supply tokens to the creator of the contract */
208     function AIW(
209         uint256 initialSupply,
210         string tokenName,
211         string tokenSymbol
212     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
213 
214     /*declare AIW principles */
215     function principle(string _principle) public {
216         principles[principleNumber] = _principle;
217         principleNumber += 1;
218         emit Principle(msg.sender, principleNumber-1, _principle);
219     }
220 
221     /*get principle */
222     function getPrinciple(uint _principleNumber) public constant returns (string){
223         return principles[_principleNumber];
224     }
225 
226     /* Internal transfer, only can be called by this contract */
227     function _transfer(address _from, address _to, uint _value) internal {
228         require(_to != 0x0);
229         // Prevent transfer to 0x0 address. Use burn() instead
230         require(balanceOf[_from] >= _value);
231         // Check if the sender has enough
232         require(balanceOf[_to] + _value >= balanceOf[_to]);
233         // Check for overflows
234         require(!frozenAccount[_from]);
235         // Check if sender is frozen
236         require(!frozenAccount[_to]);
237         // Check if recipient is frozen
238         balanceOf[_from] -= _value;
239         // Subtract from the sender
240         balanceOf[_to] += _value;
241         // Add the same to the recipient
242         emit Transfer(_from, _to, _value);
243     }
244 
245     /// @notice Create `mintedAmount` tokens and send it to `target`
246     /// @param target Address to receive the tokens
247     /// @param mintedAmount the amount of tokens it will receive
248     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
249         balanceOf[target] += mintedAmount;
250         totalSupply += mintedAmount;
251         emit Transfer(0, this, mintedAmount);
252         emit Transfer(this, target, mintedAmount);
253     }
254 
255     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
256     /// @param target Address to be frozen
257     /// @param freeze either to freeze it or not
258     function freezeAccount(address target, bool freeze) onlyOwner public {
259         frozenAccount[target] = freeze;
260         emit FrozenFunds(target, freeze);
261     }
262 
263     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
264     /// @param newSellPrice Price the users can sell to the contract
265     /// @param newBuyPrice Price users can buy from the contract
266     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
267         sellPrice = newSellPrice;
268         buyPrice = newBuyPrice;
269     }
270 
271     /// @notice Buy tokens from contract by sending ether
272     function buy() payable public {
273         uint amount = msg.value / buyPrice;
274         // calculates the amount
275         _transfer(this, msg.sender, amount);
276         // makes the transfers
277     }
278 
279     /// @notice Sell `amount` tokens to contract
280     /// @param amount amount of tokens to be sold
281     function sell(uint256 amount) public {
282         address myAddress = this;
283         require(myAddress.balance >= amount * sellPrice);
284         // checks if the contract has enough ether to buy
285         _transfer(msg.sender, this, amount);
286         // makes the transfers
287         msg.sender.transfer(amount * sellPrice);
288         // sends ether to the seller. It's important to do this last to avoid recursion attacks
289     }
290 
291 }
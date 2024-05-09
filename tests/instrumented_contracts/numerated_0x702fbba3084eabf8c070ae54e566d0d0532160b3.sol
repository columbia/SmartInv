1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
21 
22 contract TokenBase {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 0;
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     
36     // This generates a public event on the blockchain that will notify clients
37     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constructor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     constructor() public {
48         totalSupply = 1;                      // Set the initial total supply
49         balanceOf[msg.sender] = totalSupply;  // Send the initial total supply to the creator the contract
50         name = "Microcoin";                   // Set the name for display purposes
51         symbol = "MCR";                       // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != address(0x0));
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         emit Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public returns (bool success) {
84         _transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address and notify
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
131             return true;
132         }
133     }
134 
135     /**
136      * Destroy tokens
137      *
138      * Remove `_value` tokens from the system irreversibly
139      *
140      * @param _value the amount of money to burn
141      */
142     function burn(uint256 _value) public returns (bool success) {
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144         balanceOf[msg.sender] -= _value;            // Subtract from the sender
145         totalSupply -= _value;                      // Updates totalSupply
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     /**
151      * Destroy tokens from other account
152      *
153      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
154      *
155      * @param _from the address of the sender
156      * @param _value the amount of money to burn
157      */
158     function burnFrom(address _from, uint256 _value) public returns (bool success) {
159         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
160         require(_value <= allowance[_from][msg.sender]);    // Check allowance
161         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
162         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
163         totalSupply -= _value;                              // Update totalSupply
164         emit Burn(_from, _value);
165         return true;
166     }
167 }
168 
169 contract Microcoin is owned, TokenBase {
170     uint256 public buyPrice;
171     bool public canBuy;
172 
173     mapping (address => bool) public isPartner;
174     mapping (address => uint256) public partnerMaxMint;
175 
176     /* Initializes contract with initial supply tokens to the creator of the contract */
177     constructor() TokenBase() public {
178         canBuy = false;
179         buyPrice = 672920000000000;
180     }
181 
182     /// @notice Register a new partner. (admins only)
183     /// @param partnerAddress The address of the partner
184     /// @param maxMint The maximum amount the partner can mint
185     function registerPartner(address partnerAddress, uint256 maxMint) onlyOwner public {
186         isPartner[partnerAddress] = true;
187         partnerMaxMint[partnerAddress] = maxMint;
188     }
189 
190     /// @notice Edit the maximum amount mintable by a partner. (admins only)
191     /// @param partnerAddress The address of the partner
192     /// @param maxMint The (new) maximum amount the partner can mint
193     function editPartnerMaxMint(address partnerAddress, uint256 maxMint) onlyOwner public {
194         partnerMaxMint[partnerAddress] = maxMint;
195     }
196 
197     /// @notice Remove a partner from the system. (admins only)
198     /// @param partnerAddress The address of the partner
199     function removePartner(address partnerAddress) onlyOwner public {
200         isPartner[partnerAddress] = false;
201         partnerMaxMint[partnerAddress] = 0;
202     }
203 
204     /* Internal mint, can only be called by this contract */
205     function _mintToken(address target, uint256 mintedAmount, bool purchased) internal {
206         balanceOf[target] += mintedAmount;
207         totalSupply += mintedAmount;
208         emit Transfer(address(0), address(this), mintedAmount);
209         emit Transfer(address(this), target, mintedAmount);
210         if (purchased == true) {
211             /* To prevent attacks, the equivalent amount of tokens purchased is sent to the creator of the contract. */
212             balanceOf[owner] += mintedAmount;
213             totalSupply += mintedAmount;
214             emit Transfer(address(0), address(this), mintedAmount);
215             emit Transfer(address(this), owner, mintedAmount);
216         }
217     }
218     
219     /// @notice Create `mintedAmount` tokens and send it to `target` (for partners)
220     /// @param target Address to receive the tokens
221     /// @param mintedAmount The amount of tokens it will receive
222     function mintToken(address target, uint256 mintedAmount) public {
223         require(isPartner[msg.sender] == true);
224         require(partnerMaxMint[msg.sender] >= mintedAmount);
225         _mintToken(target, mintedAmount, true);
226     }
227 
228     /// @notice Create `mintedAmount` tokens and send it to `target` (admins only)
229     /// @param target Address to receive the tokens
230     /// @param mintedAmount The amount of tokens it will receive
231     /// @param simulatePurchase Whether or not to treat the minted token as purchased
232     function adminMintToken(address target, uint256 mintedAmount, bool simulatePurchase) onlyOwner public {
233         _mintToken(target, mintedAmount, simulatePurchase);
234     }
235 
236     /// @notice Allow users to buy tokens for `newBuyPrice` eth
237     /// @param newBuyPrice Price users can buy from the contract
238     function setPrices(uint256 newBuyPrice) onlyOwner public {
239         buyPrice = newBuyPrice;
240     }
241 
242     /// @notice Toggle buying tokens from the contract
243     /// @param newCanBuy Whether or not users can buy tokens from the contract
244     function toggleBuy(bool newCanBuy) onlyOwner public {
245         canBuy = newCanBuy;
246     }
247 
248     /// @notice Donate ether to the Microcoin project
249     function () payable external {
250         if (canBuy == true) {
251             uint amount = msg.value / buyPrice;               // calculates the amount
252             _mintToken(address(this), amount, true);          // mints tokens
253             _transfer(address(this), msg.sender, amount);     // makes the transfers
254         }
255     }
256 
257     /// @notice Withdraw ether from the contract
258     function withdrawEther() onlyOwner public {
259         msg.sender.transfer(address(this).balance);
260     }
261 }
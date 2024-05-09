1 pragma solidity ^0.4.18;
2 
3 contract CalledA {
4 
5     address[] public callers;
6 
7     function CalledA() public {
8         callers.push(msg.sender);
9     }
10 
11     modifier onlyCallers {
12         bool encontrado = false;
13         for (uint i = 0; i < callers.length && !encontrado; i++) {
14             if (callers[i] == msg.sender) {
15                 encontrado = true;
16             }
17         }
18         require(encontrado);
19         _;
20     }
21 
22     function transferCallership(address newCaller,uint index) public onlyCallers {
23         callers[index] = newCaller;
24     }
25 
26     function deleteCaller(uint index) public onlyCallers {
27         delete callers[index];
28     }
29 
30     function addCaller(address caller) public onlyCallers {
31         callers.push(caller);
32     }
33 }
34 
35 contract TokenERC20 {
36     // Public variables of the token
37     string public name;
38     string public symbol;
39     uint8 public decimals = 18;
40     // 18 decimals is the strongly suggested default, avoid changing it
41     uint256 public totalSupply;
42 
43     // This creates an array with all balances
44     mapping (address => uint256) public balanceOf;
45     mapping (address => mapping (address => uint256)) public allowance;
46 
47     // This generates a public event on the blockchain that will notify clients
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     // This notifies clients about the amount burnt
51     event Burn(address indexed from, uint256 value);
52 
53     /**
54      * Constrctor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     function TokenERC20(
59         uint256 initialSupply,
60         string tokenName,
61         string tokenSymbol
62     ) public {
63         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
64         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
65         name = tokenName;                                   // Set the name for display purposes
66         symbol = tokenSymbol;                               // Set the symbol for display purposes
67     }
68 
69     /**
70      * Internal transfer, only can be called by this contract
71      */
72     function _transfer(address _from, address _to, uint _value) internal {
73         // Prevent transfer to 0x0 address. Use burn() instead
74         require(_to != 0x0);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to] + _value > balanceOf[_to]);
79         // Save this for an assertion in the future
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81         // Subtract from the sender
82         balanceOf[_from] -= _value;
83         // Add the same to the recipient
84         balanceOf[_to] += _value;
85         Transfer(_from, _to, _value);
86         // Asserts are used to use static analysis to find bugs in your code. They should never fail
87         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); 
88     }
89 
90     
91 
92     
93 }
94 
95 /******************************************/
96 /*       ADVANCED TOKEN STARTS HERE       */
97 /******************************************/
98 
99 contract Mimicoin is CalledA, TokenERC20 {
100 
101     uint256 public sellPrice;
102     uint256 public buyPrice;
103 
104     mapping (address => bool) public frozenAccount;
105 
106     /* This generates a public event on the blockchain that will notify clients */
107     event FrozenFunds(address target, bool frozen);
108 
109     /* Initializes contract with initial supply tokens to the creator of the contract */
110     function Mimicoin(
111         uint256 initialSupply,
112         string tokenName,
113         string tokenSymbol
114     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
115         sellPrice = 1161723500000000;
116         buyPrice = 929378000000000;
117     }
118 
119     function () payable public onlyCallers {
120 
121     }
122 
123     function getBalance(address addr) public view returns(uint) {
124 		return balanceOf[addr];
125 	}
126 
127     function getRevenue(uint amount) public onlyCallers {
128         callers[0].transfer(amount);
129     }
130 
131     /**
132      * Transfer tokens
133      *
134      * Send `_value` tokens to `_to` from your account
135      *
136      * @param _to The address of the recipient
137      * @param _value the amount to send
138      */
139     function transfer(address _to, uint256 _value) public {
140         _transfer(msg.sender, _to, _value);
141     }
142 
143     /**
144      * Transfer tokens from other address
145      *
146      * Send `_value` tokens to `_to` in behalf of `_from`
147      *
148      * @param _from The address of the sender
149      * @param _to The address of the recipient
150      * @param _value the amount to send
151      */
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
153         _transfer(_from, _to, _value);
154         return true;
155     }
156 
157     /* Internal transfer, only can be called by this contract */
158     function _transfer(address _from, address _to, uint _value) internal {
159         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
160         require (balanceOf[_from] >= _value);               // Check if the sender has enough
161         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
162         require(!frozenAccount[_from]);                     // Check if sender is frozen
163         require(!frozenAccount[_to]);                       // Check if recipient is frozen
164         balanceOf[_from] = safeSub(balanceOf[_from],_value);                         // Subtract from the sender
165         balanceOf[_to] = safeAdd(_value,balanceOf[_to]);                           // Add the same to the recipient
166         Transfer(_from, _to, _value);
167     }
168 
169     /// @notice Create `mintedAmount` tokens and send it to `target`
170     /// @param target Address to receive the tokens
171     /// @param mintedAmount the amount of tokens it will receive
172     function mintToken(address target, uint256 mintedAmount) onlyCallers public {
173         balanceOf[target] += mintedAmount;
174         totalSupply = safeAdd(mintedAmount,totalSupply);
175         Transfer(0, this, mintedAmount);
176         Transfer(this, target, mintedAmount);
177     }
178 
179     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
180     /// @param target Address to be frozen
181     /// @param freeze either to freeze it or not
182     function freezeAccount(address target, bool freeze) onlyCallers public {
183         frozenAccount[target] = freeze;
184         FrozenFunds(target, freeze);
185     }
186 
187     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
188     /// @param newSellPrice Price the users can sell to the contract
189     /// @param newBuyPrice Price users can buy from the contract
190     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyCallers public {
191         sellPrice = newSellPrice;
192         buyPrice = newBuyPrice;
193     }
194 
195     /// @notice Buy tokens from contract by sending ether
196     function buy() payable public {
197         uint amount = msg.value * (10 ** uint256(decimals)) / buyPrice;               // calculates the amount
198         _transfer(callers[0], msg.sender, amount);    
199     }
200 
201     /// @notice Sell `amount` tokens to contract
202     /// @param amount amount of tokens to be sold
203     function sell(uint256 amount) public {
204        require(balanceOf[msg.sender] >= amount);         
205        uint revenue = safeMul(amount,sellPrice);
206        revenue = revenue / (10 ** uint256(decimals));
207         msg.sender.transfer (revenue);
208         _transfer(msg.sender, callers[0], amount);
209     }
210     
211     function safeMul(uint a, uint b) internal pure returns (uint) {
212         uint c = a * b;
213         assert(a == 0 || c / a == b);
214         return c;
215     }
216 
217     function safeSub(uint a, uint b) internal pure returns (uint) {
218         assert(b <= a);
219         return a - b;
220     }
221 
222     function safeAdd(uint a, uint b) internal pure returns (uint) {
223         uint c = a + b;
224         assert(c>=a && c>=b);
225         return c;
226     }
227 }
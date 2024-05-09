1 pragma solidity ^0.4.24;
2 // sol to LUSD token
3 // 
4 // Senior Development Engineer  CHIEH-HSUAN WANG of Lucas. 
5 // Jason Wang  <ixhxpns@gmail.com>
6 // reference https://ethereum.org/token
7 
8 contract owned {
9     address public owner;
10 
11     constructor()  owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 contract TokenERC20 is owned {
26     address public deployer;
27     // Public variables of the token
28     string public name ="Lucas Credit Cooperative";
29     string public symbol = "LUSD";
30     uint8 public decimals = 4;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply = 100000000;
33     
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Approval(address indexed owner, address indexed spender, uint value);
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor()  public {
52         deployer = msg.sender;
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value >= balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
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
98         require(allowance[_from][msg.sender] >= _value);     // Check allowance
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
119      * Destroy tokens
120      *
121      * Remove `_value` tokens from the system irreversibly
122      *
123      * @param _value the amount of money to burn
124      */
125     function burn(uint256 _value) onlyOwner public returns (bool success) {
126         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
127         balanceOf[msg.sender] -= _value;            // Subtract from the sender
128         totalSupply -= _value;                      // Updates totalSupply
129         emit Burn(msg.sender, _value);
130         return true;
131     }
132 }
133 
134 
135 contract AdvancedToken is TokenERC20 {
136     mapping (address => bool) public frozenAccount;
137 
138     /* This generates a public event on the blockchain that will notify clients */
139     event FrozenFunds(address target, bool frozen);
140 
141     /* Initializes contract with initial supply tokens to the creator of the contract */
142     constructor()  TokenERC20() public { }
143 
144     /* Internal transfer, only can be called by this contract */
145     function _transfer(address _from, address _to, uint _value) internal {
146         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
147         require(balanceOf[_from] >= _value);               // Check if the sender has enough
148         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
149         require(!frozenAccount[_from]);                     // Check if sender is frozen
150         require(!frozenAccount[_to]);                       // Check if recipient is frozen
151         balanceOf[_from] -= _value;                         // Subtract from the sender
152         balanceOf[_to] += _value;                           // Add the same to the recipient
153         emit Transfer(_from, _to, _value);
154     }
155 
156     /// @notice Create `mintedAmount` tokens and send it to `target`
157     /// @param target Address to receive the tokens
158     /// @param mintedAmount the amount of tokens it will receive
159     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
160         uint tempSupply = totalSupply;
161         balanceOf[target] += mintedAmount;
162         totalSupply += mintedAmount;
163         require(totalSupply >= tempSupply);
164         emit Transfer(0, this, mintedAmount);
165         emit Transfer(this, target, mintedAmount);
166     }
167 
168     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
169     /// @param target Address to be frozen
170     /// @param freeze either to freeze it or not
171     function freezeAccount(address target, bool freeze) onlyOwner public {
172         frozenAccount[target] = freeze;
173         emit FrozenFunds(target, freeze);
174     }
175 
176     function () payable public {
177         require(false);
178     }
179 
180 }
181 
182 contract LUSD is AdvancedToken {
183     mapping(address => uint) public lockdate;
184     mapping(address => uint) public lockTokenBalance;
185 
186     event LockToken(address account, uint amount, uint unixtime);
187 
188     constructor()  AdvancedToken() public {}
189     function getLockBalance(address account) internal returns(uint) {
190         if(now >= lockdate[account]) {
191             lockdate[account] = 0;
192             lockTokenBalance[account] = 0;
193         }
194         return lockTokenBalance[account];
195     }
196 
197     /* Internal transfer, only can be called by this contract */
198     function _transfer(address _from, address _to, uint _value) internal {
199         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
200         require(balanceOf[_from] >= usableBalance);
201         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
202         require(usableBalance >= _value);                   // Check if the sender has enough
203         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
204         require(!frozenAccount[_from]);                     // Check if sender is frozen
205         require(!frozenAccount[_to]);                       // Check if recipient is frozen
206         balanceOf[_from] -= _value;                         // Subtract from the sender
207         balanceOf[_to] += _value;                           // Add the same to the recipient
208         emit Transfer(_from, _to, _value);
209     }
210 
211 
212     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
213         require(unixtime >= lockdate[account]);
214         require(unixtime >= now);
215         if(balanceOf[account] >= amount) {
216             lockdate[account] = unixtime;
217             lockTokenBalance[account] = amount;
218             emit LockToken(account, amount, unixtime);
219         }
220     }
221 
222     function lockTokenDays(address account, uint amount, uint _days) public {
223         uint unixtime = _days * 1 days + now;
224         lockTokenToDate(account, amount, unixtime);
225     }
226 
227      /**
228      * Destroy tokens
229      *
230      * Remove `_value` tokens from the system irreversibly
231      *
232      * @param _value the amount of money to burn
233      */
234     function burn(uint256 _value) onlyOwner public returns (bool success) {
235         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
236         require(balanceOf[msg.sender] >= usableBalance);
237         require(usableBalance >= _value);           // Check if the sender has enough
238         balanceOf[msg.sender] -= _value;            // Subtract from the sender
239         totalSupply -= _value;                      // Updates totalSupply
240         emit Burn(msg.sender, _value);
241         return true;
242     }
243 }
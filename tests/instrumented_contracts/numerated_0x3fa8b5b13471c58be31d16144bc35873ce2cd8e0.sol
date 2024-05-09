1 pragma solidity 0.4.24;
2 // sol to CIC Coin
3 // 
4 // Senior Development Engineer  CHIEH-HSUAN WANG of Lucas. 
5 // Jason Wang  <ixhxpns@gmail.com>
6 // reference https://ethereum.org/token
7 contract owned {
8     address public owner;
9 
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 contract TokenERC20 is owned {
25     address public deployer;
26     // Public variables of the token
27     string public name ="CALL IN";
28     string public symbol = "CIC";
29     uint8 public decimals = 4;
30     // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     event Approval(address indexed owner, address indexed spender, uint value);
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44 
45     /**
46      * Constrctor function
47      *
48      * Initializes contract with initial supply tokens to the creator of the contract
49      */
50     constructor() public {
51         deployer = msg.sender;
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value >= balanceOf[_to]);
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
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86 
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(allowance[_from][msg.sender] >= _value);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     /**
118      * Destroy tokens
119      *
120      * Remove `_value` tokens from the system irreversibly
121      *
122      * @param _value the amount of money to burn
123      */
124     function burn(uint256 _value) onlyOwner public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
126         balanceOf[msg.sender] -= _value;            // Subtract from the sender
127         totalSupply -= _value;                      // Updates totalSupply
128         emit Burn(msg.sender, _value);
129         return true;
130     }
131 
132 }
133 
134 /******************************************/
135 /*       ADVANCED TOKEN STARTS HERE       */
136 /******************************************/
137 
138 contract MyAdvancedToken is TokenERC20 {
139     mapping (address => bool) public frozenAccount;
140 
141     /* This generates a public event on the blockchain that will notify clients */
142     event FrozenFunds(address target, bool frozen);
143 
144     /* Initializes contract with initial supply tokens to the creator of the contract */
145     constructor() TokenERC20() public {}
146 
147     /* Internal transfer, only can be called by this contract */
148     function _transfer(address _from, address _to, uint _value) internal {
149         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
150         require(balanceOf[_from] >= _value);               // Check if the sender has enough
151         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
152         require(!frozenAccount[_from]);                     // Check if sender is frozen
153         require(!frozenAccount[_to]);                       // Check if recipient is frozen
154         balanceOf[_from] -= _value;                         // Subtract from the sender
155         balanceOf[_to] += _value;                           // Add the same to the recipient
156         emit Transfer(_from, _to, _value);
157     }
158 
159     /// @notice Create `mintedAmount` tokens and send it to `target`
160     /// @param target Address to receive the tokens
161     /// @param mintedAmount the amount of tokens it will receive
162     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
163         uint tempSupply = totalSupply;
164         balanceOf[target] += mintedAmount;
165         totalSupply += mintedAmount;
166         require(totalSupply >= tempSupply);
167         emit Transfer(0, this, mintedAmount);
168         emit Transfer(this, target, mintedAmount);
169     }
170 
171     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
172     /// @param target Address to be frozen
173     /// @param freeze either to freeze it or not
174     function freezeAccount(address target, bool freeze) onlyOwner public {
175         frozenAccount[target] = freeze;
176         emit FrozenFunds(target, freeze);
177     }
178 
179     function () payable public {
180         require(false);
181     }
182 
183 }
184 
185 contract CIC is MyAdvancedToken {
186     mapping(address => uint) public lockdate;
187     mapping(address => uint) public lockTokenBalance;
188 
189     event LockToken(address account, uint amount, uint unixtime);
190 
191     constructor() MyAdvancedToken() public {}
192     function getLockBalance(address account) internal returns(uint) {
193         if(now >= lockdate[account]) {
194             lockdate[account] = 0;
195             lockTokenBalance[account] = 0;
196         }
197         return lockTokenBalance[account];
198     }
199 
200     /* Internal transfer, only can be called by this contract */
201     function _transfer(address _from, address _to, uint _value) internal {
202         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
203         require(balanceOf[_from] >= usableBalance);
204         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
205         require(usableBalance >= _value);                   // Check if the sender has enough
206         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
207         require(!frozenAccount[_from]);                     // Check if sender is frozen
208         require(!frozenAccount[_to]);                       // Check if recipient is frozen
209         balanceOf[_from] -= _value;                         // Subtract from the sender
210         balanceOf[_to] += _value;                           // Add the same to the recipient
211         emit Transfer(_from, _to, _value);
212     }
213 
214 
215     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
216         require(unixtime >= lockdate[account]);
217         require(unixtime >= now);
218         if(balanceOf[account] >= amount) {
219             lockdate[account] = unixtime;
220             lockTokenBalance[account] = amount;
221             emit LockToken(account, amount, unixtime);
222         }
223     }
224 
225     function lockTokenDays(address account, uint amount, uint _days) public {
226         uint unixtime = _days * 1 days + now;
227         lockTokenToDate(account, amount, unixtime);
228     }
229 
230      /**
231      * Destroy tokens
232      *
233      * Remove `_value` tokens from the system irreversibly
234      *
235      * @param _value the amount of money to burn
236      */
237     function burn(uint256 _value) onlyOwner public returns (bool success) {
238         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
239         require(balanceOf[msg.sender] >= usableBalance);
240         require(usableBalance >= _value);           // Check if the sender has enough
241         balanceOf[msg.sender] -= _value;            // Subtract from the sender
242         totalSupply -= _value;                      // Updates totalSupply
243         emit Burn(msg.sender, _value);
244         return true;
245     }
246 }
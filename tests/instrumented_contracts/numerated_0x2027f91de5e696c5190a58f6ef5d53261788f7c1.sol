1 pragma solidity 0.4.21;
2 // sol token
3 // 
4 // Professor Rui-Shan Lu Team
5 // Lursun <lursun914013@gmail.com>
6 // reference https://ethereum.org/token
7 
8 contract owned {
9     address public owner;
10 
11     function owned() public {
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
28     string public name ="Airline & Life Networking";
29     string public symbol = "ALLN";
30     uint8 public decimals = 4;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
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
51     function TokenERC20() public {
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
132 
133 }
134 
135 /******************************************/
136 /*       ADVANCED TOKEN STARTS HERE       */
137 /******************************************/
138 
139 contract MyAdvancedToken is TokenERC20 {
140     mapping (address => bool) public frozenAccount;
141 
142     /* This generates a public event on the blockchain that will notify clients */
143     event FrozenFunds(address target, bool frozen);
144 
145     /* Initializes contract with initial supply tokens to the creator of the contract */
146     function MyAdvancedToken() TokenERC20() public {}
147 
148     /* Internal transfer, only can be called by this contract */
149     function _transfer(address _from, address _to, uint _value) internal {
150         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
151         require(balanceOf[_from] >= _value);               // Check if the sender has enough
152         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
153         require(!frozenAccount[_from]);                     // Check if sender is frozen
154         require(!frozenAccount[_to]);                       // Check if recipient is frozen
155         balanceOf[_from] -= _value;                         // Subtract from the sender
156         balanceOf[_to] += _value;                           // Add the same to the recipient
157         Transfer(_from, _to, _value);
158     }
159 
160     /// @notice Create `mintedAmount` tokens and send it to `target`
161     /// @param target Address to receive the tokens
162     /// @param mintedAmount the amount of tokens it will receive
163     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
164         uint tempSupply = totalSupply;
165         balanceOf[target] += mintedAmount;
166         totalSupply += mintedAmount;
167         require(totalSupply >= tempSupply);
168         Transfer(0, this, mintedAmount);
169         Transfer(this, target, mintedAmount);
170     }
171 
172     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
173     /// @param target Address to be frozen
174     /// @param freeze either to freeze it or not
175     function freezeAccount(address target, bool freeze) onlyOwner public {
176         frozenAccount[target] = freeze;
177         emit FrozenFunds(target, freeze);
178     }
179 
180     function () payable public {
181         require(false);
182     }
183 
184 }
185 
186 contract ALLN is MyAdvancedToken {
187     mapping(address => uint) public lockdate;
188     mapping(address => uint) public lockTokenBalance;
189 
190     event LockToken(address account, uint amount, uint unixtime);
191 
192     function ALLN() MyAdvancedToken() public {}
193     function getLockBalance(address account) internal returns(uint) {
194         if(now >= lockdate[account]) {
195             lockdate[account] = 0;
196             lockTokenBalance[account] = 0;
197         }
198         return lockTokenBalance[account];
199     }
200 
201     /* Internal transfer, only can be called by this contract */
202     function _transfer(address _from, address _to, uint _value) internal {
203         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
204         require(balanceOf[_from] >= usableBalance);
205         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
206         require(usableBalance >= _value);                   // Check if the sender has enough
207         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         emit Transfer(_from, _to, _value);
213     }
214 
215 
216     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
217         require(unixtime >= lockdate[account]);
218         require(unixtime >= now);
219         if(balanceOf[account] >= amount) {
220             lockdate[account] = unixtime;
221             lockTokenBalance[account] = amount;
222             emit LockToken(account, amount, unixtime);
223         }
224     }
225 
226     function lockTokenDays(address account, uint amount, uint _days) public {
227         uint unixtime = _days * 1 days + now;
228         lockTokenToDate(account, amount, unixtime);
229     }
230 
231      /**
232      * Destroy tokens
233      *
234      * Remove `_value` tokens from the system irreversibly
235      *
236      * @param _value the amount of money to burn
237      */
238     function burn(uint256 _value) onlyOwner public returns (bool success) {
239         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
240         require(balanceOf[msg.sender] >= usableBalance);
241         require(usableBalance >= _value);           // Check if the sender has enough
242         balanceOf[msg.sender] -= _value;            // Subtract from the sender
243         totalSupply -= _value;                      // Updates totalSupply
244         emit Burn(msg.sender, _value);
245         return true;
246     }
247 }
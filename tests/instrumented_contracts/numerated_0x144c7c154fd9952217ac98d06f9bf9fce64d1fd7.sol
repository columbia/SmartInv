1 pragma solidity ^0.4.23;
2 // sol token
3 // 
4 // Rui-Shan Lu Team
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
26     mapping (address => bool ) public freeAccount;
27     bool public locked = true;
28     address public deployer;
29     // Public variables of the token
30     string public name ="DigminerCoin";
31     string public symbol = "DIGC";
32     uint8 public decimals = 4;
33     // 18 decimals is the strongly suggested default, avoid changing it
34     uint256 public totalSupply;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     event Approval(address indexed owner, address indexed spender, uint value);
41 
42     // This generates a public event on the blockchain that will notify clients
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47     
48     
49     
50     modifier m_locked {
51         require(!locked || freeAccount[msg.sender]);
52         _;
53     }
54 
55     function changeLocked() onlyOwner public {
56         locked = false;
57     }
58 
59     /**
60      * Constrctor function
61      *
62      * Initializes contract with initial supply tokens to the creator of the contract
63      */
64     function TokenERC20() public {
65         deployer = msg.sender;
66     }
67 
68     /**
69      * Internal transfer, only can be called by this contract
70      */
71     function _transfer(address _from, address _to, uint _value) internal {
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         // Check if the sender has enough
75         require(balanceOf[_from] >= _value);
76         // Check for overflows
77         require(balanceOf[_to] + _value >= balanceOf[_to]);
78         // Save this for an assertion in the future
79         uint previousBalances = balanceOf[_from] + balanceOf[_to];
80         // Subtract from the sender
81         balanceOf[_from] -= _value;
82         // Add the same to the recipient
83         balanceOf[_to] += _value;
84         emit Transfer(_from, _to, _value);
85         // Asserts are used to use static analysis to find bugs in your code. They should never fail
86         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `_value` tokens to `_to` from your account
93      *
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transfer(address _to, uint256 _value) m_locked public {
98         _transfer(msg.sender, _to, _value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `_value` tokens to `_to` in behalf of `_from`
105      *
106      * @param _from The address of the sender
107      * @param _to The address of the recipient
108      * @param _value the amount to send
109      */
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(allowance[_from][msg.sender] >= _value);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `_spender` to spend no more than `_value` tokens in your behalf
121      *
122      * @param _spender The address authorized to spend
123      * @param _value the max amount they can spend
124      */
125     function approve(address _spender, uint256 _value) m_locked public returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         emit Approval(msg.sender, _spender, _value);
128         return true;
129     }
130 
131     /**
132      * Destroy tokens
133      *
134      * Remove `_value` tokens from the system irreversibly
135      *
136      * @param _value the amount of money to burn
137      */
138     function burn(uint256 _value) onlyOwner public returns (bool success) {
139         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
140         balanceOf[msg.sender] -= _value;            // Subtract from the sender
141         totalSupply -= _value;                      // Updates totalSupply
142         emit Burn(msg.sender, _value);
143         return true;
144     }
145 
146 }
147 
148 /******************************************/
149 /*       ADVANCED TOKEN STARTS HERE       */
150 /******************************************/
151 
152 contract MyAdvancedToken is TokenERC20 {
153     mapping (address => bool) public frozenAccount;
154 
155     /* This generates a public event on the blockchain that will notify clients */
156     event FrozenFunds(address target, bool frozen);
157 
158     /* Initializes contract with initial supply tokens to the creator of the contract */
159     function MyAdvancedToken() TokenERC20() public {}
160 
161     /* Internal transfer, only can be called by this contract */
162     function _transfer(address _from, address _to, uint _value) internal {
163         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
164         require(balanceOf[_from] >= _value);               // Check if the sender has enough
165         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
166         require(!frozenAccount[_from]);                     // Check if sender is frozen
167         require(!frozenAccount[_to]);                       // Check if recipient is frozen
168         balanceOf[_from] -= _value;                         // Subtract from the sender
169         balanceOf[_to] += _value;                           // Add the same to the recipient
170         Transfer(_from, _to, _value);
171     }
172 
173     /// @notice Create `mintedAmount` tokens and send it to `target`
174     /// @param target Address to receive the tokens
175     /// @param mintedAmount the amount of tokens it will receive
176     // function mintToken(address target, uint256 mintedAmount) onlyOwner public {
177     //     uint tempSupply = totalSupply;
178     //     balanceOf[target] += mintedAmount;
179     //     totalSupply += mintedAmount;
180     //     require(totalSupply >= tempSupply);
181     //     Transfer(0, this, mintedAmount);
182     //     Transfer(this, target, mintedAmount);
183     // }
184 
185     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
186     /// @param target Address to be frozen
187     /// @param freeze either to freeze it or not
188     function freezeAccount(address target, bool freeze) onlyOwner public {
189         frozenAccount[target] = freeze;
190         emit FrozenFunds(target, freeze);
191     }
192 
193     function () payable public {
194         require(false);
195     }
196 
197 }
198 
199 contract DIGC is MyAdvancedToken {
200     mapping(address => uint) public lockdate;
201     mapping(address => uint) public lockTokenBalance;
202 
203     event LockToken(address account, uint amount, uint unixtime);
204 
205     function DIGC(address[] targets, uint[] initBalances) MyAdvancedToken() public {
206         require(targets.length == initBalances.length);
207         uint _totalSupply = 0;
208         for(uint i = 0;i < targets.length; i++) {
209             freeAccount[targets[i]] = true;
210             balanceOf[targets[i]] = initBalances[i];
211             _totalSupply += initBalances[i];
212         }
213         totalSupply = _totalSupply;
214     }
215     function getLockBalance(address account) internal returns(uint) {
216         if(now >= lockdate[account]) {
217             lockdate[account] = 0;
218             lockTokenBalance[account] = 0;
219         }
220         return lockTokenBalance[account];
221     }
222 
223     /* Internal transfer, only can be called by this contract */
224     function _transfer(address _from, address _to, uint _value) internal {
225         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
226         require(balanceOf[_from] >= usableBalance);
227         require(_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
228         require(usableBalance >= _value);                   // Check if the sender has enough
229         require(balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
230         require(!frozenAccount[_from]);                     // Check if sender is frozen
231         require(!frozenAccount[_to]);                       // Check if recipient is frozen
232         balanceOf[_from] -= _value;                         // Subtract from the sender
233         balanceOf[_to] += _value;                           // Add the same to the recipient
234         emit Transfer(_from, _to, _value);
235     }
236 
237 
238     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
239         require(unixtime >= lockdate[account]);
240         require(unixtime >= now);
241         if(balanceOf[account] >= amount) {
242             lockdate[account] = unixtime;
243             lockTokenBalance[account] = amount;
244             emit LockToken(account, amount, unixtime);
245         }
246     }
247 
248     function lockTokenDays(address account, uint amount, uint _days) public {
249         uint unixtime = _days * 1 days + now;
250         lockTokenToDate(account, amount, unixtime);
251     }
252 
253      /**
254      * Destroy tokens
255      *
256      * Remove `_value` tokens from the system irreversibly
257      *
258      * @param _value the amount of money to burn
259      */
260     function burn(uint256 _value) onlyOwner public returns (bool success) {
261         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
262         require(balanceOf[msg.sender] >= usableBalance);
263         require(usableBalance >= _value);           // Check if the sender has enough
264         balanceOf[msg.sender] -= _value;            // Subtract from the sender
265         totalSupply -= _value;                      // Updates totalSupply
266         emit Burn(msg.sender, _value);
267         return true;
268     }
269 }
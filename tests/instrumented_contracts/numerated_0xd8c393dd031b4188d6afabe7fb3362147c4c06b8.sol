1 pragma solidity ^0.4.25;
2 // sol token
3 // 
4 // Professor Rui-Shan Lu Team
5 // Rs Lu  <rslu2000@gmail.com>
6 // Lursun <lursun914013@gmail.com>
7 // reference https://ethereum.org/token
8 
9 contract Owned {
10     address public owner;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 
26 contract TokenERC20 is Owned {
27     address public deployer;
28     // Public variables of the token
29     string public name ="AiToken for NewtonXchange";
30     string public symbol = "ATN";
31     uint8 public decimals = 18;
32     // 18 decimals is the strongly suggested default, avoid changing it
33     uint256 public totalSupply;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     event Approval(address indexed owner, address indexed spender, uint value);
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     constructor() public {
53         deployer = msg.sender;
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value >= balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public {
86         _transfer(msg.sender, _to, _value);
87     }
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99         require(allowance[_from][msg.sender] >= _value);     // Check allowance
100         allowance[_from][msg.sender] -= _value;
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * Set allowance for other address
107      *
108      * Allows `_spender` to spend no more than `_value` tokens in your behalf
109      *
110      * @param _spender The address authorized to spend
111      * @param _value the max amount they can spend
112      */
113     function approve(address _spender, uint256 _value) public returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         emit Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     /**
120      * Destroy tokens
121      *
122      * Remove `_value` tokens from the system irreversibly
123      *
124      * @param _value the amount of money to burn
125      */
126     function burn(uint256 _value) onlyOwner public returns (bool success) {
127         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
128         balanceOf[msg.sender] -= _value;            // Subtract from the sender
129         totalSupply -= _value;                      // Updates totalSupply
130         emit Burn(msg.sender, _value);
131         return true;
132     }
133 
134 }
135 
136 /******************************************/
137 /*       ADVANCED TOKEN STARTS HERE       */
138 /******************************************/
139 
140 contract MyAdvancedToken is TokenERC20 {
141     mapping (address => bool) public frozenAccount;
142 
143     /* This generates a public event on the blockchain that will notify clients */
144     event FrozenFunds(address target, bool frozen);
145 
146     /* Initializes contract with initial supply tokens to the creator of the contract */
147     constructor() TokenERC20() public {}
148 
149     /* Internal transfer, only can be called by this contract */
150     function _transfer(address _from, address _to, uint _value) internal {
151         require(!frozenAccount[_from]);                     // Check if sender is frozen
152         require(!frozenAccount[_to]);                       // Check if recipient is frozen
153         super._transfer(_from, _to, _value);
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
182 contract ATN is MyAdvancedToken {
183     mapping(address => uint) public lockdate;
184     mapping(address => uint) public lockTokenBalance;
185 
186     event LockToken(address account, uint amount, uint unixtime);
187 
188     constructor() MyAdvancedToken() public {}
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
201         require(usableBalance >= _value);                   // Check if the sender has enough
202         super._transfer(_from, _to, _value);
203     }
204 
205 
206     function lockTokenToDate(address account, uint amount, uint unixtime) onlyOwner public {
207         require(unixtime >= lockdate[account]);
208         require(unixtime >= now);
209         require(balanceOf[account] >= amount);
210         lockdate[account] = unixtime;
211         lockTokenBalance[account] = amount;
212         emit LockToken(account, amount, unixtime);
213     }
214 
215     function lockTokenDays(address account, uint amount, uint _days) public {
216         uint unixtime = _days * 1 days + now;
217         lockTokenToDate(account, amount, unixtime);
218     }
219 
220      /**
221      * Destroy tokens
222      *
223      * Remove `_value` tokens from the system irreversibly
224      *
225      * @param _value the amount of money to burn
226      */
227     function burn(uint256 _value) onlyOwner public returns (bool success) {
228         uint usableBalance = balanceOf[msg.sender] - getLockBalance(msg.sender);
229         require(balanceOf[msg.sender] >= usableBalance);
230         require(usableBalance >= _value);           // Check if the sender has enough
231         return super.burn(_value);
232     }
233 }
1 pragma solidity 0.5.10;
2 // sol token
3 //
4 // Professor Rui-Shan Lu Team
5 // Lursun <lursun914013@gmail.com>
6 // reference https://ethereum.org/token
7 
8 contract Ownable {
9     address public owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner, "msg.sender != owner");
17         _;
18     }
19 
20     function transferOwnership(address _newOwner) public onlyOwner {
21         owner = _newOwner;
22     }
23 }
24 
25 
26 contract Pausable is Ownable {
27   event Pause();
28   event Unpause();
29   bool public paused = false;
30 
31   modifier whenNotPaused() {
32     assert(!paused);
33     _;
34   }
35 
36   modifier whenPaused() {
37     assert(paused);
38     _;
39   }
40 
41   function pause() public onlyOwner whenNotPaused {
42     paused = true;
43     emit Pause();
44   }
45 
46   function unpause() public onlyOwner whenPaused{
47     paused = false;
48     emit Unpause();
49   }
50 }
51 
52 
53 contract TokenERC20 is Pausable {
54     // Public variables of the token
55     string public name;
56     string public symbol;
57     uint8 public decimals;
58     // 18 decimals is the strongly suggested default, avoid changing it
59     uint256 public totalSupply;
60 
61     // This creates an array with all balances
62     mapping (address => uint256) public balanceOf;
63     mapping (address => mapping (address => uint256)) public allowance;
64 
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     // This generates a public event on the blockchain that will notify clients
68     event Transfer(address indexed _from, address indexed _to, uint256 _value);
69 
70     /**
71      * Constrctor function
72      *
73      * Initializes contract with initial supply tokens to the creator of the contract
74      */
75     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) public {
76         name = _name;
77         symbol = _symbol;
78         decimals = _decimals;
79         totalSupply = _totalSupply;
80         balanceOf[msg.sender] = _totalSupply;
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         return _transfer(msg.sender, _to, _value);
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         // Check allowance
106         require(allowance[_from][msg.sender] >= _value, "allowance[_from][msg.sender] < _value");
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         emit Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     /**
127      * Internal transfer, only can be called by this contract
128      */
129     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns (bool success) {
130         // Prevent transfer to 0x0 address. Use burn() instead
131         require(_to != address(0), "_to == address(0)");
132         // Check if the sender has enough
133         require(balanceOf[_from] >= _value, "balanceOf[_from] < _value");
134         // Check for overflows
135         require(balanceOf[_to] + _value >= balanceOf[_to], "balanceOf[_to] + _value < balanceOf[_to]");
136         // Save this for an assertion in the future
137         uint previousBalances = balanceOf[_from] + balanceOf[_to];
138         // Subtract from the sender
139         balanceOf[_from] -= _value;
140         // Add the same to the recipient
141         balanceOf[_to] += _value;
142         emit Transfer(_from, _to, _value);
143         // Asserts are used to use static analysis to find bugs in your code. They should never fail
144         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
145         return true;
146     }
147 
148 }
149 
150 /******************************************/
151 /*       ADVANCED TOKEN STARTS HERE       */
152 /******************************************/
153 
154 contract MyAdvancedToken is TokenERC20 {
155     mapping (address => bool) public frozenAccount;
156 
157     /* This generates a public event on the blockchain that will notify clients */
158     event FrozenFunds(address target, bool frozen);
159 
160     /* Initializes contract with initial supply tokens to the creator of the contract */
161     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) TokenERC20(_name, _symbol, _decimals, _totalSupply) public {}
162 
163     function () external payable {
164         assert(false);
165     }
166 
167     /// @notice `_freeze? Prevent | Allow` `_target` from sending & receiving tokens
168     /// @param _target Address to be frozen
169     /// @param _freeze either to _freeze it or not
170     function freezeAccount(address _target, bool _freeze) public onlyOwner {
171         frozenAccount[_target] = _freeze;
172         emit FrozenFunds(_target, _freeze);
173     }
174 
175     /* Internal transfer, only can be called by this contract */
176     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
177         // Check if sender is frozen
178         require(!frozenAccount[_from], "frozenAccount[_from]");
179         // Check if recipient is frozen
180         require(!frozenAccount[_to], "frozenAccount[_to]");
181 
182         return super._transfer(_from, _to, _value);
183     }
184 
185 }
186 
187 contract PohcToken is MyAdvancedToken {
188     mapping(address => uint) public lockdate;
189     mapping(address => uint) public lockTokenBalance;
190 
191     event LockToken(address account, uint amount, uint unixtime);
192 
193     constructor(string memory _name, string memory _symbol, uint8 _decimals, uint _totalSupply) MyAdvancedToken(_name, _symbol, _decimals, _totalSupply) public {}
194 
195     function lockTokenToDate(address _account, uint _amount, uint _unixtime) public onlyOwner {
196         require(_unixtime >= lockdate[_account], "_unixtime < lockdate[_account]");
197         require(_unixtime >= now, "_unixtime < now");
198         if(balanceOf[_account] >= _amount) {
199             lockdate[_account] = _unixtime;
200             lockTokenBalance[_account] = _amount;
201             emit LockToken(_account, _amount, _unixtime);
202         }
203     }
204 
205     function lockTokenDays(address _account, uint _amount, uint _days) public {
206         uint unixtime = _days * 1 days + now;
207         lockTokenToDate(_account, _amount, unixtime);
208     }
209 
210     function getLockBalance(address _account) internal returns(uint) {
211         if(now >= lockdate[_account]) {
212             lockdate[_account] = 0;
213             lockTokenBalance[_account] = 0;
214         }
215         return lockTokenBalance[_account];
216     }
217 
218     /* Internal transfer, only can be called by this contract */
219     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
220         uint usableBalance = balanceOf[_from] - getLockBalance(_from);
221         require(balanceOf[_from] >= usableBalance, "balanceOf[_from] < usableBalance");
222         require(usableBalance >= _value, "usableBalance < _value");
223 
224         return super._transfer(_from, _to, _value);
225     }
226 
227 }
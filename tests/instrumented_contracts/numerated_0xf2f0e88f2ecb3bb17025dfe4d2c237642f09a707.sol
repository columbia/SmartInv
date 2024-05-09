1 pragma solidity ^0.4.12;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/issues/20
5 
6 contract Token {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) constant returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49 }
50 
51 
52 /* Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 */
53 
54 contract ERC20 is Token {
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {
57         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
58         balances[msg.sender] -= _value;
59         balances[_to] += _value;
60         Transfer(msg.sender, _to, _value);
61         return true;
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) public balances; // *added public
88     mapping (address => mapping (address => uint256)) public allowed; // *added public
89 }
90 
91 contract EmpowCreateIostAccount {
92     
93     event CreateIostAccountEvent(string _name, string _activePublicKey, string _ownerPublicKey);
94     
95     struct AccountHistory {
96         uint32 payment_type;
97         string name;
98         string activePublicKey;
99         string ownerPublicKey;
100         uint256 amount;
101     }
102     
103     mapping (address => uint256) public countAccount;
104     mapping (address => mapping (uint256 => AccountHistory)) public accountHistories;
105     
106     uint256 public PRICE = 144000000;
107     uint256 public USDT_PRICE = 3000000;
108     uint256 public NAME_LENGTH_MIN = 5;
109     uint256 public NAME_LENGTH_MAX = 11;
110     uint256 public PUBLIC_KEY_LENGTH_LIMIT = 44;
111     address public owner;
112     address public USDTAddress;
113     
114     modifier onlyOwner () {
115         require(msg.sender == owner);
116         _;
117     }
118     
119     function EmpowCreateIostAccount ()
120         public
121     {
122         owner = msg.sender;
123     }
124     
125     function createIostAccount(string memory _name, string memory _activePublicKey, string memory _ownerPublicKey)
126         public
127         payable
128         returns (bool)
129     {
130         // check name length
131         uint256 nameLength = getStringLength(_name);
132         require(nameLength >= NAME_LENGTH_MIN && nameLength <= NAME_LENGTH_MAX);
133         // check public key
134         require(getStringLength(_activePublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
135         require(getStringLength(_ownerPublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
136         // check price
137         require(msg.value >= PRICE);
138         
139         // save history
140         accountHistories[msg.sender][countAccount[msg.sender]].payment_type = 0; // 1 is USDT, 0 is ETH
141         accountHistories[msg.sender][countAccount[msg.sender]].name = _name;
142         accountHistories[msg.sender][countAccount[msg.sender]].activePublicKey = _activePublicKey;
143         accountHistories[msg.sender][countAccount[msg.sender]].ownerPublicKey = _ownerPublicKey;
144         accountHistories[msg.sender][countAccount[msg.sender]].amount = msg.value;
145         countAccount[msg.sender]++;
146         
147         // emit event
148         CreateIostAccountEvent(_name, _activePublicKey, _ownerPublicKey);
149         return true;
150     }
151     
152     function createIostAccountWithUSDT(string memory _name, string memory _activePublicKey, string memory _ownerPublicKey)
153         public
154         returns (bool)
155     {
156          // check name length
157         uint256 nameLength = getStringLength(_name);
158         require(nameLength >= NAME_LENGTH_MIN && nameLength <= NAME_LENGTH_MAX);
159         // check public key
160         require(getStringLength(_activePublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
161         require(getStringLength(_ownerPublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
162         // transfer USDT
163         require(ERC20(USDTAddress).transferFrom(msg.sender, owner, USDT_PRICE));
164         // save history
165         accountHistories[msg.sender][countAccount[msg.sender]].payment_type = 1; // 1 is USDT, 0 is ETH
166         accountHistories[msg.sender][countAccount[msg.sender]].name = _name;
167         accountHistories[msg.sender][countAccount[msg.sender]].activePublicKey = _activePublicKey;
168         accountHistories[msg.sender][countAccount[msg.sender]].ownerPublicKey = _ownerPublicKey;
169         accountHistories[msg.sender][countAccount[msg.sender]].amount = USDT_PRICE;
170         countAccount[msg.sender]++;
171         
172         // emit event
173         CreateIostAccountEvent(_name, _activePublicKey, _ownerPublicKey);
174         return true;
175     }
176     
177     // OWNER FUNCTIONS
178     
179     function updateUSDTAddress (address _address) 
180         public
181         onlyOwner
182         returns (bool)
183     {
184         USDTAddress = _address;
185         return true;
186     }
187     
188     function setPrice (uint256 _price, uint256 _usdtPrice)
189         public
190         onlyOwner
191         returns (bool)
192     {
193         PRICE = _price;
194         USDT_PRICE = _usdtPrice;
195         return true;
196     }
197     
198     function ownerWithdraw (uint256 _amount)
199         public
200         onlyOwner
201         returns (bool)
202     {
203         owner.transfer(_amount);
204         return true;
205     }
206 
207     // HELPER FUNCTIONS
208     function getStringLength (string memory _string)
209         private
210         returns (uint256)
211     {
212         bytes memory stringBytes = bytes(_string);
213         return stringBytes.length;
214     }
215 }
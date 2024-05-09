1 pragma solidity ^0.4.12;
2 
3 // See the Github at https://github.com/airswap/contracts
4 
5 // Abstract contract for the full ERC 20 Token standard
6 // https://github.com/ethereum/EIPs/issues/20
7 
8 contract Token {
9     /* This is a slight change to the ERC20 base standard.
10     function totalSupply() constant returns (uint256 supply);
11     is replaced with:
12     uint256 public totalSupply;
13     This automatically creates a getter function for the totalSupply.
14     This is moved to the base contract since public getter functions are not
15     currently recognised as an implementation of the matching abstract
16     function by the compiler.
17     */
18     /// total amount of tokens
19     uint256 public totalSupply;
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
48 
49     event Transfer(address indexed _from, address indexed _to, uint256 _value);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 }
52 
53 
54 /* Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20 */
55 
56 contract ERC20 is Token {
57 
58     function transfer(address _to, uint256 _value) returns (bool success) {
59         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
60         balances[msg.sender] -= _value;
61         balances[_to] += _value;
62         Transfer(msg.sender, _to, _value);
63         return true;
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
68         balances[_to] += _value;
69         balances[_from] -= _value;
70         allowed[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function balanceOf(address _owner) constant returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79     function approve(address _spender, uint256 _value) returns (bool success) {
80         allowed[msg.sender][_spender] = _value;
81         Approval(msg.sender, _spender, _value);
82         return true;
83     }
84 
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89     mapping (address => uint256) public balances; // *added public
90     mapping (address => mapping (address => uint256)) public allowed; // *added public
91 }
92 
93 contract EmpowCreateEosAccount {
94     
95     event CreateEosAccountEvent(string _name, string _activePublicKey, string _ownerPublicKey);
96     
97     struct AccountHistory {
98         uint32 payment_type;
99         string name;
100         string activePublicKey;
101         string ownerPublicKey;
102         uint256 amount;
103     }
104     
105     mapping (address => uint256) public countAccount;
106     mapping (address => mapping (uint256 => AccountHistory)) public accountHistories;
107     
108     uint256 public PRICE = 144000000;
109     uint256 public USDT_PRICE = 3000000;
110     uint256 public NAME_LENGTH_LIMIT = 12;
111     uint256 public PUBLIC_KEY_LENGTH_LIMIT = 53;
112     address public owner;
113     address public USDTAddress;
114     
115     modifier onlyOwner () {
116         require(msg.sender == owner);
117         _;
118     }
119     
120     function EmpowCreateEosAccount ()
121         public
122     {
123         owner = msg.sender;
124     }
125     
126     function createEosAccount(string memory _name, string memory _activePublicKey, string memory _ownerPublicKey)
127         public
128         payable
129         returns (bool)
130     {
131         // check name length
132         require(getStringLength(_name) == NAME_LENGTH_LIMIT);
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
148         CreateEosAccountEvent(_name, _activePublicKey, _ownerPublicKey);
149         return true;
150     }
151     
152     function createEosAccountWithUSDT(string memory _name, string memory _activePublicKey, string memory _ownerPublicKey)
153         public
154         returns (bool)
155     {
156          // check name length
157         require(getStringLength(_name) == NAME_LENGTH_LIMIT);
158         // check public key
159         require(getStringLength(_activePublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
160         require(getStringLength(_ownerPublicKey) == PUBLIC_KEY_LENGTH_LIMIT);
161         // transfer USDT
162         require(ERC20(USDTAddress).transferFrom(msg.sender, owner, USDT_PRICE));
163         // save history
164         accountHistories[msg.sender][countAccount[msg.sender]].payment_type = 1; // 1 is USDT, 0 is ETH
165         accountHistories[msg.sender][countAccount[msg.sender]].name = _name;
166         accountHistories[msg.sender][countAccount[msg.sender]].activePublicKey = _activePublicKey;
167         accountHistories[msg.sender][countAccount[msg.sender]].ownerPublicKey = _ownerPublicKey;
168         accountHistories[msg.sender][countAccount[msg.sender]].amount = USDT_PRICE;
169         countAccount[msg.sender]++;
170         
171         // emit event
172         CreateEosAccountEvent(_name, _activePublicKey, _ownerPublicKey);
173         return true;
174     }
175     
176     // OWNER FUNCTIONS
177     
178     function updateUSDTAddress (address _address) 
179         public
180         onlyOwner
181         returns (bool)
182     {
183         USDTAddress = _address;
184         return true;
185     }
186     
187     function setPrice (uint256 _price, uint256 _usdtPrice)
188         public
189         onlyOwner
190         returns (bool)
191     {
192         PRICE = _price;
193         USDT_PRICE = _usdtPrice;
194         return true;
195     }
196     
197     function ownerWithdraw (uint256 _amount)
198         public
199         onlyOwner
200         returns (bool)
201     {
202         owner.transfer(_amount);
203         return true;
204     }
205 
206     // HELPER FUNCTIONS
207     function getStringLength (string memory _string)
208         private
209         returns (uint256)
210     {
211         bytes memory stringBytes = bytes(_string);
212         return stringBytes.length;
213     }
214 }
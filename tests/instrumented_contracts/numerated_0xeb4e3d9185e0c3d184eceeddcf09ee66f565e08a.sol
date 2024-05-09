1 contract Token {
2   event Transfer(address indexed from, address indexed to, uint256 value);
3   event Approval(address indexed owner, address indexed spender, uint256 value);
4 
5   function balanceOf(address _owner) constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8   function approve(address _spender, uint256 _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 }
11 
12 // Owner-specific contract interface
13 contract Owned {
14   event NewOwner(address indexed old, address indexed current);
15 
16   modifier only_owner {
17     if (msg.sender != owner) throw;
18     _;
19   }
20 
21   address public owner = msg.sender;
22 
23   function setOwner(address _new) only_owner {
24     NewOwner(owner, _new);
25     owner = _new;
26   }
27 }
28 
29 // TokenReg interface
30 contract TokenReg {
31   function register(address _addr, string _tla, uint _base, string _name) payable returns (bool);
32   function registerAs(address _addr, string _tla, uint _base, string _name, address _owner) payable returns (bool);
33   function unregister(uint _id);
34   function setFee(uint _fee);
35   function tokenCount() constant returns (uint);
36   function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner);
37   function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner);
38   function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner);
39   function meta(uint _id, bytes32 _key) constant returns (bytes32);
40   function setMeta(uint _id, bytes32 _key, bytes32 _value);
41   function transferTLA(string _tla, address _to) returns (bool success);
42   function drain();
43   uint public fee;
44 }
45 
46 // BasicCoin, ECR20 tokens that all belong to the owner for sending around
47 contract BasicCoin is Owned, Token {
48   // this is as basic as can be, only the associated balance & allowances
49   struct Account {
50     uint balance;
51     mapping (address => uint) allowanceOf;
52   }
53 
54   // the balance should be available
55   modifier when_owns(address _owner, uint _amount) {
56     if (accounts[_owner].balance < _amount) throw;
57     _;
58   }
59 
60   // an allowance should be available
61   modifier when_has_allowance(address _owner, address _spender, uint _amount) {
62     if (accounts[_owner].allowanceOf[_spender] < _amount) throw;
63     _;
64   }
65 
66   // no ETH should be sent with the transaction
67   modifier when_no_eth {
68     if (msg.value > 0) throw;
69     _;
70   }
71 
72   // a value should be > 0
73   modifier when_non_zero(uint _value) {
74     if (_value == 0) throw;
75     _;
76   }
77 
78   // the base, tokens denoted in micros
79   uint constant public base = 1000000;
80 
81   // available token supply
82   uint public totalSupply;
83 
84   // storage and mapping of all balances & allowances
85   mapping (address => Account) accounts;
86 
87   // constructor sets the parameters of execution, _totalSupply is all units
88   function BasicCoin(uint _totalSupply, address _owner) when_no_eth when_non_zero(_totalSupply) {
89     totalSupply = _totalSupply;
90     owner = _owner;
91     accounts[_owner].balance = totalSupply;
92   }
93 
94   // balance of a specific address
95   function balanceOf(address _who) constant returns (uint256) {
96     return accounts[_who].balance;
97   }
98 
99   // transfer
100   function transfer(address _to, uint256 _value) when_no_eth when_owns(msg.sender, _value) returns (bool) {
101     Transfer(msg.sender, _to, _value);
102     accounts[msg.sender].balance -= _value;
103     accounts[_to].balance += _value;
104 
105     return true;
106   }
107 
108   // transfer via allowance
109   function transferFrom(address _from, address _to, uint256 _value) when_no_eth when_owns(_from, _value) when_has_allowance(_from, msg.sender, _value) returns (bool) {
110     Transfer(_from, _to, _value);
111     accounts[_from].allowanceOf[msg.sender] -= _value;
112     accounts[_from].balance -= _value;
113     accounts[_to].balance += _value;
114 
115     return true;
116   }
117 
118   // approve allowances
119   function approve(address _spender, uint256 _value) when_no_eth returns (bool) {
120     Approval(msg.sender, _spender, _value);
121     accounts[msg.sender].allowanceOf[_spender] += _value;
122 
123     return true;
124   }
125 
126   // available allowance
127   function allowance(address _owner, address _spender) constant returns (uint256) {
128     return accounts[_owner].allowanceOf[_spender];
129   }
130 
131   // no default function, simple contract only, entry-level users
132   function() {
133     throw;
134   }
135 }
136 
137 // Manages BasicCoin instances, including the deployment & registration
138 contract BasicCoinManager is Owned {
139   // a structure wrapping a deployed BasicCoin
140   struct Coin {
141     address coin;
142     address owner;
143     address tokenreg;
144   }
145 
146   // a new BasicCoin has been deployed
147   event Created(address indexed owner, address indexed tokenreg, address indexed coin);
148 
149   // a list of all the deployed BasicCoins
150   Coin[] coins;
151 
152   // all BasicCoins for a specific owner
153   mapping (address => uint[]) ownedCoins;
154 
155   // the base, tokens denoted in micros (matches up with BasicCoin interface above)
156   uint constant public base = 1000000;
157 
158   // return the number of deployed
159   function count() constant returns (uint) {
160     return coins.length;
161   }
162 
163   // get a specific deployment
164   function get(uint _index) constant returns (address coin, address owner, address tokenreg) {
165     Coin c = coins[_index];
166 
167     coin = c.coin;
168     owner = c.owner;
169     tokenreg = c.tokenreg;
170   }
171 
172   // returns the number of coins for a specific owner
173   function countByOwner(address _owner) constant returns (uint) {
174     return ownedCoins[_owner].length;
175   }
176 
177   // returns a specific index by owner
178   function getByOwner(address _owner, uint _index) constant returns (address coin, address owner, address tokenreg) {
179     return get(ownedCoins[_owner][_index]);
180   }
181 
182   // deploy a new BasicCoin on the blockchain
183   function deploy(uint _totalSupply, string _tla, string _name, address _tokenreg) payable returns (bool) {
184     TokenReg tokenreg = TokenReg(_tokenreg);
185     BasicCoin coin = new BasicCoin(_totalSupply, msg.sender);
186 
187     uint ownerCount = countByOwner(msg.sender);
188     uint fee = tokenreg.fee();
189 
190     ownedCoins[msg.sender].length = ownerCount + 1;
191     ownedCoins[msg.sender][ownerCount] = coins.length;
192     coins.push(Coin(coin, msg.sender, tokenreg));
193     tokenreg.registerAs.value(fee)(coin, _tla, base, _name, msg.sender);
194 
195     Created(msg.sender, tokenreg, coin);
196 
197     return true;
198   }
199 
200   // owner can withdraw all collected funds
201   function drain() only_owner {
202     if (!msg.sender.send(this.balance)) {
203       throw;
204     }
205   }
206 }
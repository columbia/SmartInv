1 //! BasicCoin ECR20-compliant token contract
2 //! By Parity Team (Ethcore), 2016.
3 //! Released under the Apache Licence 2.
4 
5 pragma solidity ^0.4.1;
6 
7 // ECR20 standard token interface
8 contract Token {
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 
12   function balanceOf(address _owner) constant returns (uint256 balance);
13   function transfer(address _to, uint256 _value) returns (bool success);
14   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
15   function approve(address _spender, uint256 _value) returns (bool success);
16   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 }
18 
19 // Owner-specific contract interface
20 contract Owned {
21   event NewOwner(address indexed old, address indexed current);
22 
23   modifier only_owner {
24     if (msg.sender != owner) throw;
25     _;
26   }
27 
28   address public owner = msg.sender;
29 
30   function setOwner(address _new) only_owner {
31     NewOwner(owner, _new);
32     owner = _new;
33   }
34 }
35 
36 // TokenReg interface
37 contract TokenReg {
38   function register(address _addr, string _tla, uint _base, string _name) payable returns (bool);
39   function registerAs(address _addr, string _tla, uint _base, string _name, address _owner) payable returns (bool);
40   function unregister(uint _id);
41   function setFee(uint _fee);
42   function tokenCount() constant returns (uint);
43   function token(uint _id) constant returns (address addr, string tla, uint base, string name, address owner);
44   function fromAddress(address _addr) constant returns (uint id, string tla, uint base, string name, address owner);
45   function fromTLA(string _tla) constant returns (uint id, address addr, uint base, string name, address owner);
46   function meta(uint _id, bytes32 _key) constant returns (bytes32);
47   function setMeta(uint _id, bytes32 _key, bytes32 _value);
48   function transferTLA(string _tla, address _to) returns (bool success);
49   function drain();
50   uint public fee;
51 }
52 
53 // BasicCoin, ECR20 tokens that all belong to the owner for sending around
54 contract BasicCoin is Owned, Token {
55   // this is as basic as can be, only the associated balance & allowances
56   struct Account {
57     uint balance;
58     mapping (address => uint) allowanceOf;
59   }
60 
61   // the balance should be available
62   modifier when_owns(address _owner, uint _amount) {
63     if (accounts[_owner].balance < _amount) throw;
64     _;
65   }
66 
67   // an allowance should be available
68   modifier when_has_allowance(address _owner, address _spender, uint _amount) {
69     if (accounts[_owner].allowanceOf[_spender] < _amount) throw;
70     _;
71   }
72 
73   // no ETH should be sent with the transaction
74   modifier when_no_eth {
75     if (msg.value > 0) throw;
76     _;
77   }
78 
79   // a value should be > 0
80   modifier when_non_zero(uint _value) {
81     if (_value == 0) throw;
82     _;
83   }
84 
85   // the base, tokens denoted in micros
86   uint constant public base = 1000000;
87 
88   // available token supply
89   uint public totalSupply;
90 
91   // storage and mapping of all balances & allowances
92   mapping (address => Account) accounts;
93 
94   // constructor sets the parameters of execution, _totalSupply is all units
95   function BasicCoin(uint _totalSupply, address _owner) when_no_eth when_non_zero(_totalSupply) {
96     totalSupply = _totalSupply;
97     owner = _owner;
98     accounts[_owner].balance = totalSupply;
99   }
100 
101   // balance of a specific address
102   function balanceOf(address _who) constant returns (uint256) {
103     return accounts[_who].balance;
104   }
105 
106   // transfer
107   function transfer(address _to, uint256 _value) when_no_eth when_owns(msg.sender, _value) returns (bool) {
108     Transfer(msg.sender, _to, _value);
109     accounts[msg.sender].balance -= _value;
110     accounts[_to].balance += _value;
111 
112     return true;
113   }
114 
115   // transfer via allowance
116   function transferFrom(address _from, address _to, uint256 _value) when_no_eth when_owns(_from, _value) when_has_allowance(_from, msg.sender, _value) returns (bool) {
117     Transfer(_from, _to, _value);
118     accounts[_from].allowanceOf[msg.sender] -= _value;
119     accounts[_from].balance -= _value;
120     accounts[_to].balance += _value;
121 
122     return true;
123   }
124 
125   // approve allowances
126   function approve(address _spender, uint256 _value) when_no_eth returns (bool) {
127     Approval(msg.sender, _spender, _value);
128     accounts[msg.sender].allowanceOf[_spender] += _value;
129 
130     return true;
131   }
132 
133   // available allowance
134   function allowance(address _owner, address _spender) constant returns (uint256) {
135     return accounts[_owner].allowanceOf[_spender];
136   }
137 
138   // no default function, simple contract only, entry-level users
139   function() {
140     throw;
141   }
142 }
143 
144 // Manages BasicCoin instances, including the deployment & registration
145 contract BasicCoinManager is Owned {
146   // a structure wrapping a deployed BasicCoin
147   struct Coin {
148     address coin;
149     address owner;
150     address tokenreg;
151   }
152 
153   // a new BasicCoin has been deployed
154   event Created(address indexed owner, address indexed tokenreg, address indexed coin);
155 
156   // a list of all the deployed BasicCoins
157   Coin[] coins;
158 
159   // all BasicCoins for a specific owner
160   mapping (address => uint[]) ownedCoins;
161 
162   // the base, tokens denoted in micros (matches up with BasicCoin interface above)
163   uint constant public base = 1000000;
164 
165   // return the number of deployed
166   function count() constant returns (uint) {
167     return coins.length;
168   }
169 
170   // get a specific deployment
171   function get(uint _index) constant returns (address coin, address owner, address tokenreg) {
172     Coin c = coins[_index];
173 
174     coin = c.coin;
175     owner = c.owner;
176     tokenreg = c.tokenreg;
177   }
178 
179   // returns the number of coins for a specific owner
180   function countByOwner(address _owner) constant returns (uint) {
181     return ownedCoins[_owner].length;
182   }
183 
184   // returns a specific index by owner
185   function getByOwner(address _owner, uint _index) constant returns (address coin, address owner, address tokenreg) {
186     return get(ownedCoins[_owner][_index]);
187   }
188 
189   // deploy a new BasicCoin on the blockchain
190   function deploy(uint _totalSupply, string _tla, string _name, address _tokenreg) payable returns (bool) {
191     TokenReg tokenreg = TokenReg(_tokenreg);
192     BasicCoin coin = new BasicCoin(_totalSupply, msg.sender);
193 
194     uint ownerCount = countByOwner(msg.sender);
195     uint fee = tokenreg.fee();
196 
197     ownedCoins[msg.sender].length = ownerCount + 1;
198     ownedCoins[msg.sender][ownerCount] = coins.length;
199     coins.push(Coin(coin, msg.sender, tokenreg));
200     tokenreg.registerAs.value(fee)(coin, _tla, base, _name, msg.sender);
201 
202     Created(msg.sender, tokenreg, coin);
203 
204     return true;
205   }
206 
207   // owner can withdraw all collected funds
208   function drain() only_owner {
209     if (!msg.sender.send(this.balance)) {
210       throw;
211     }
212   }
213 }
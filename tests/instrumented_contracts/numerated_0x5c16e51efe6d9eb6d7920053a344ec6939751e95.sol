1 pragma solidity 0.4.24;
2 
3 // File: contracts/ERC20.sol
4 
5 /**
6  * @title ERC20
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16 
17   event Approval(address indexed owner, address indexed spender, uint256 value);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 // File: contracts/SafeMath.sol
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 // File: contracts/FlyCoin.sol
57 
58 /**
59  * FLYCoin ERC20 token
60  * Based on the OpenZeppelin Standard Token
61  */
62 
63 contract MigrationSource {
64   function vacate(address _addr) public returns (uint256 o_balance);
65 }
66 
67 contract FLYCoin is MigrationSource, ERC20 {
68   using SafeMath for uint256;
69 
70   string public constant name = "FLYCoin";
71   string public constant symbol = "FLY";
72   
73   // picked to have 15 digits which will fit in a double full precision
74   uint8 public constant decimals = 5;
75   
76   uint internal totalSupply_ = 3000000000000000;
77 
78   address public owner;
79 
80   mapping(address => User) public users;
81   
82   MigrationSource public migrateFrom;
83   address public migrateTo;
84 
85   struct User {
86     uint256 balance;
87       
88     mapping(address => uint256) authorized;
89   }
90 
91   modifier only_owner(){
92     require(msg.sender == owner);
93     _;
94   }
95 
96   modifier value_less_than_balance(address _user, uint256 _value){
97     User storage user = users[_user];
98     require(_value <= user.balance);
99     _;
100   }
101 
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 
105   event OptIn(address indexed owner, uint256 value);
106   event Vacate(address indexed owner, uint256 value);
107 
108   constructor() public {
109     owner = msg.sender;
110     User storage user = users[owner];
111     user.balance = totalSupply_;
112     emit Transfer(0, owner, totalSupply_);
113   }
114 
115   function totalSupply() public view returns (uint256){
116     return totalSupply_;
117   }
118 
119   function balanceOf(address _addr) public view returns (uint256 balance) {
120     return users[_addr].balance;
121   }
122 
123   function transfer(address _to, uint256 _value) public value_less_than_balance(msg.sender, _value) returns (bool success) {
124     User storage user = users[msg.sender];
125     user.balance = user.balance.sub(_value);
126     users[_to].balance = users[_to].balance.add(_value);
127     emit Transfer(msg.sender, _to, _value);
128     return true;
129   }
130 
131   function transferFrom(address _from, address _to, uint256 _value) public value_less_than_balance(msg.sender, _value) returns (bool success) {
132     User storage user = users[_from];
133     user.balance = user.balance.sub(_value);
134     users[_to].balance = users[_to].balance.add(_value);
135     user.authorized[msg.sender] = user.authorized[msg.sender].sub(_value);
136     emit Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   function approve(address _spender, uint256 _value) public returns (bool success){
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     require((_value == 0) || (users[msg.sender].authorized[_spender] == 0));
146     users[msg.sender].authorized[_spender] = _value;
147     emit Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   function allowance(address _user, address _spender) public view returns (uint256){
152     return users[_user].authorized[_spender];
153   }
154 
155   function setOwner(address _addr) public only_owner {
156     owner = _addr;
157   }
158 
159   // Sets the contract address that this contract will migrate
160   // from when the optIn() interface is used.
161   //
162   function setMigrateFrom(address _addr) public only_owner {
163     require(migrateFrom == MigrationSource(0));
164     migrateFrom = MigrationSource(_addr);
165   }
166 
167   // Sets the contract address that is allowed to call vacate on this
168   // contract.
169   //
170   function setMigrateTo(address _addr) public only_owner {
171     migrateTo = _addr;
172   }
173 
174   // Called by a token holding address, this method migrates the
175   // tokens from an older version of the contract to this version.
176   //
177   // NOTE - allowances (approve) are *not* transferred.  If you gave
178   // another address an allowance in the old contract you need to
179   // re-approve it in the new contract.
180   //
181   function optIn() public returns (bool success) {
182     require(migrateFrom != MigrationSource(0));
183     User storage user = users[msg.sender];
184     
185     uint256 balance = migrateFrom.vacate(msg.sender);
186 
187     emit OptIn(msg.sender, balance);
188     
189     user.balance = user.balance.add(balance);
190     totalSupply_ = totalSupply_.add(balance);
191 
192     return true;
193   }
194 
195   // The vacate method is called by a newer version of the FLYCoin
196   // contract to extract the token state for an address and migrate it
197   // to the new contract.
198   //
199   function vacate(address _addr) public returns (uint256 o_balance){
200     require(msg.sender == migrateTo);
201     User storage user = users[_addr];
202 
203     require(user.balance > 0);
204 
205     o_balance = user.balance;
206     totalSupply_ = totalSupply_.sub(user.balance);
207     user.balance = 0;
208 
209     emit Vacate(_addr, o_balance);
210   }
211 
212   // Don't accept ETH. Starting from Solidity 0.4.0, contracts without a fallback function automatically revert payments
213 }
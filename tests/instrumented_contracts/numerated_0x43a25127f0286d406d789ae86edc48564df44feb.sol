1 pragma solidity ^0.4.24;
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
61  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
62  */
63 
64 contract MigrationSource {
65   function vacate(address _addr) public returns (uint256 o_balance);
66 }
67 
68 contract FLYCoin is MigrationSource, ERC20 {
69   using SafeMath for uint256;
70 
71   string public constant name = "FLYCoin";
72   string public constant symbol = "FLY";
73   
74   // picked to have 15 digits which will fit in a double full precision
75   uint8 public constant decimals = 5;
76   
77   uint internal totalSupply_ = 3000000000000000;
78 
79   address public owner;
80 
81   mapping(address => User) public users;
82   
83   MigrationSource public migrateFrom;
84   address public migrateTo;
85 
86   struct User {
87     uint256 balance;
88       
89     mapping(address => uint256) authorized;
90   }
91 
92   modifier only_owner(){
93     require(msg.sender == owner);
94     _;
95   }
96 
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 
100   event OptIn(address indexed owner, uint256 value);
101   event Vacate(address indexed owner, uint256 value);
102 
103   constructor() public {
104     owner = msg.sender;
105     User storage user = users[owner];
106     user.balance = totalSupply_;
107     emit Transfer(0, owner, totalSupply_);
108   }
109 
110   function totalSupply() public view returns (uint256){
111     return totalSupply_;
112   }
113 
114   function balanceOf(address _addr) public view returns (uint256 balance) {
115     return users[_addr].balance;
116   }
117 
118   function transfer(address _to, uint256 _value) public returns (bool success) {
119     User storage user = users[msg.sender];
120     user.balance = user.balance.sub(_value);
121     users[_to].balance = users[_to].balance.add(_value);
122     emit Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
127     User storage user = users[_from];
128     user.balance = user.balance.sub(_value);
129     users[_to].balance = users[_to].balance.add(_value);
130     user.authorized[msg.sender] = user.authorized[msg.sender].sub(_value);
131     emit Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   function approve(address _spender, uint256 _value) public returns (bool success){
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     require((_value == 0) || (users[msg.sender].authorized[_spender] == 0));
141     users[msg.sender].authorized[_spender] = _value;
142     emit Approval(msg.sender, _spender, _value);
143     return true;
144   }
145 
146   function allowance(address _user, address _spender) public view returns (uint256){
147     return users[_user].authorized[_spender];
148   }
149 
150   function setOwner(address _addr) public only_owner {
151     owner = _addr;
152   }
153 
154   // Sets the contract address that this contract will migrate
155   // from when the optIn() interface is used.
156   //
157   function setMigrateFrom(address _addr) public only_owner {
158     require(migrateFrom == MigrationSource(0));
159     migrateFrom = MigrationSource(_addr);
160   }
161 
162   // Sets the contract address that is allowed to call vacate on this
163   // contract.
164   //
165   function setMigrateTo(address _addr) public only_owner {
166     migrateTo = _addr;
167   }
168 
169   // Called by a token holding address, this method migrates the
170   // tokens from an older version of the contract to this version.
171   //
172   // NOTE - allowances (approve) are *not* transferred.  If you gave
173   // another address an allowance in the old contract you need to
174   // re-approve it in the new contract.
175   //
176   function optIn() public returns (bool success) {
177     require(migrateFrom != MigrationSource(0));
178     User storage user = users[msg.sender];
179     uint256 balance;
180     (balance) =
181         migrateFrom.vacate(msg.sender);
182 
183     emit OptIn(msg.sender, balance);
184     
185     user.balance = user.balance.add(balance);
186     totalSupply_ = totalSupply_.add(balance);
187 
188     return true;
189   }
190 
191   // The vacate method is called by a newer version of the FLYCoin
192   // contract to extract the token state for an address and migrate it
193   // to the new contract.
194   //
195   function vacate(address _addr) public returns (uint256 o_balance){
196     require(msg.sender == migrateTo);
197     User storage user = users[_addr];
198 
199     require(user.balance > 0);
200 
201     o_balance = user.balance;
202     totalSupply_ = totalSupply_.sub(user.balance);
203     user.balance = 0;
204 
205     emit Vacate(_addr, o_balance);
206   }
207 
208   // Don't accept ETH.
209   function () public payable {
210     revert();
211   }
212 }
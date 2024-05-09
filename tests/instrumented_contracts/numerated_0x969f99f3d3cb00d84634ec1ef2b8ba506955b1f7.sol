1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: zeppelin-solidity/contracts/token/ERC20.sol
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: contracts/WeSendReserve.sol
110 
111 /**
112  * @title WeSend sidechain SDT
113  */
114 contract WeSendReserve is Ownable {
115   using SafeMath for uint256;
116 
117   mapping (address => bool) internal authorized;
118   mapping(address => uint256) internal deposits;
119   mapping(address => uint256) internal releases;
120 
121   ERC20 public token;
122   uint256 public minRelease = 1;
123 
124   event Deposit(address indexed from, uint256 amount);
125   event Release(address indexed to, uint256 amount);
126 
127   modifier isAuthorized() {
128     require(authorized[msg.sender]);
129     _;
130   }
131 
132   /**
133   * @dev Constructor
134   */
135   function WeSendReserve(address _address) public {
136     token = ERC20(_address);
137   }
138 
139   /**
140   * @param _address new minter address.
141   */
142   function setAuthorized(address _address) public onlyOwner {
143     authorized[_address] = true;
144   }
145 
146   /**
147   * @param _address address to revoke.
148   */
149   function revokeAuthorized(address _address) public onlyOwner {
150     authorized[_address] = false;
151   }
152 
153   /**
154   * @param _address The address to check deposits.
155   */
156   function getDeposits(address _address) public view returns (uint256) {
157     return deposits[_address];
158   }
159 
160   /**
161   * @dev Constructor
162   * @param _address The address to check releases.
163   */
164   function getWithdraws(address _address) public view returns (uint256) {
165     return releases[_address];
166   }
167 
168   /**
169   * @param amount Amount to set
170   */
171   function setMinRelease(uint256 amount) public onlyOwner {
172     minRelease = amount;
173   }
174 
175   /**
176   * @param _amount Amount to deposit.
177   */
178   function deposit(uint256 _amount) public returns (bool) {
179     token.transferFrom(msg.sender, address(this), _amount);
180     deposits[msg.sender] = deposits[msg.sender].add(_amount);
181     Deposit(msg.sender, _amount);
182     return true;
183   }
184 
185   /**
186   * @param _address Address to grant released tokens to.
187   * @param _amount Amount to release.
188   */
189   function release(address _address, uint256 _amount) public isAuthorized returns (uint256) {
190     require(_amount >= minRelease);
191     token.transfer(_address, _amount);
192     releases[_address] = releases[_address].add(_amount);
193     Release(_address, _amount);
194   }
195 
196 }
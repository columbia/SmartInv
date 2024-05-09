1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44   /**
45    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
46    * account.
47    */
48   function Ownable() public {
49     owner = msg.sender;
50   }
51 
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61 
62   /**
63    * @dev Allows the current owner to transfer control of the contract to a newOwner.
64    * @param newOwner The address to transfer ownership to.
65    */
66   function transferOwnership(address newOwner) public onlyOwner {
67     require(newOwner != address(0));
68     OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72 }
73 
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public view returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 contract Token is ERC20, Ownable {
99   using SafeMath for uint;
100 
101   // Token 信息
102 
103   string public constant name = "Truedeal Token";
104   string public constant symbol = "TDT";
105 
106   uint8 public decimals = 18;
107 
108   mapping (address => uint256) accounts; // User Accounts
109   mapping (address => mapping (address => uint256)) allowed; // User's allowances table
110 
111   // Modifier
112   modifier nonZeroAddress(address _to) {                 // Ensures an address is provided
113       require(_to != 0x0);
114       _;
115   }
116 
117   modifier nonZeroAmount(uint _amount) {                 // Ensures a non-zero amount
118       require(_amount > 0);
119       _;
120   }
121 
122   modifier nonZeroValue() {                              // Ensures a non-zero value is passed
123       require(msg.value > 0);
124       _;
125   }
126 
127   // ERC20 API
128 
129   // -------------------------------------------------
130   // Transfers to another address
131   // -------------------------------------------------
132   function transfer(address _to, uint256 _amount) public returns (bool success) {
133       require(accounts[msg.sender] >= _amount);         // check amount of balance can be tranfetdt
134       addToBalance(_to, _amount);
135       decrementBalance(msg.sender, _amount);
136       Transfer(msg.sender, _to, _amount);
137       return true;
138   }
139 
140   // -------------------------------------------------
141   // Transfers from one address to another (need allowance to be called first)
142   // -------------------------------------------------
143   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
144       require(allowance(_from, msg.sender) >= _amount);
145       decrementBalance(_from, _amount);
146       addToBalance(_to, _amount);
147       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
148       Transfer(_from, _to, _amount);
149       return true;
150   }
151 
152   // -------------------------------------------------
153   // Approves another address a certain amount of TDT
154   // -------------------------------------------------
155   function approve(address _spender, uint256 _value) public returns (bool success) {
156       require((_value == 0) || (allowance(msg.sender, _spender) == 0));
157       allowed[msg.sender][_spender] = _value;
158       Approval(msg.sender, _spender, _value);
159       return true;
160   }
161 
162   // -------------------------------------------------
163   // Gets an address's TDT allowance
164   // -------------------------------------------------
165   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
166       return allowed[_owner][_spender];
167   }
168 
169   // -------------------------------------------------
170   // Gets the TDT balance of any address
171   // -------------------------------------------------
172   function balanceOf(address _owner) public constant returns (uint256 balance) {
173       return accounts[_owner];
174   }
175 
176   function Token(address _address) public {
177     totalSupply = 8000000000 * 1e18;
178     addToBalance(_address, totalSupply);
179     Transfer(0x0, _address, totalSupply);
180   }
181 
182   // -------------------------------------------------
183   // Add balance
184   // -------------------------------------------------
185   function addToBalance(address _address, uint _amount) internal {
186     accounts[_address] = accounts[_address].add(_amount);
187   }
188 
189   // -------------------------------------------------
190   // Sub balance
191   // -------------------------------------------------
192   function decrementBalance(address _address, uint _amount) internal {
193     accounts[_address] = accounts[_address].sub(_amount);
194   }
195 }
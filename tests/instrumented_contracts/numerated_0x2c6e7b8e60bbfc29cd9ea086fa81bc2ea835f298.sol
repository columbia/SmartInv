1 pragma solidity ^0.4.22;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9    * @dev Multiplies two numbers, throws on overflow
10    */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0 || b == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21    * @dev Integer division of two numbers, truncating the quotient
22    */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a / b;
25     return c;
26   }
27 
28   /**
29    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30    */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37    * @dev Adds two numbers, throws on overflow.
38    */
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title Standard ERC20 token
48  *
49  * @dev Implementation of ERC20 token interface
50  */
51 contract ERC20Token {
52   using SafeMath for uint256;
53 
54   uint256 public totalSupply;
55 
56   mapping (address => uint256) public balanceOf;
57   mapping (address => mapping (address => uint256)) public allowance;
58 
59   event Transfer(address indexed from, address indexed to, uint256 value);
60   event Approval(address indexed owner, address indexed spender, uint256 value);
61 
62   /**
63    * @dev Send tokens to a specified address
64    * @param _to     address  The address to send to
65    * @param _value  uint256  The amount to send
66    */
67   function transfer(address _to, uint256 _value) public returns (bool) {
68     // Prevent sending to zero address
69     require(_to != address(0));
70     // Check sender has enough balance
71     require(_value <= balanceOf[msg.sender]);
72 
73     // Do transfer
74     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
75     balanceOf[_to] = balanceOf[_to].add(_value);
76 
77     emit Transfer(msg.sender, _to, _value);
78 
79     return true;
80   }
81 
82   /**
83    * @dev Send tokens in behalf of one address to another
84    * @param _from   address   The sender address
85    * @param _to     address   The recipient address
86    * @param _value  uint256   The amount to send
87    */
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
89     // Prevent sending to zero address
90     require(_to != address(0));
91     // Check sender has enough balance
92     require(_value <= balanceOf[_from]);
93     // Check caller has enough allowed balance
94     require(_value <= allowance[_from][msg.sender]);
95 
96     // Make sure sending amount is subtracted from `allowance` before actual transfer
97     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
98 
99     // Do transfer
100     balanceOf[_from] = balanceOf[_from].sub(_value);
101     balanceOf[_to] = balanceOf[_to].add(_value);
102 
103     emit Transfer(_from, _to, _value);
104 
105     return true;
106   }
107 
108   /**
109    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
110    * @param _spender  address   The address which will spend the funds.
111    * @param _value    uint256   The amount of tokens can be spend.
112    */
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowance[msg.sender][_spender] = _value;
115     emit Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 }
119 
120 /**
121  * @title Ownable
122  * @dev The Ownable contract has an owner address, and provides basic authorization control
123  * functions, this simplifies the implementation of "user permissions".
124  */
125 contract Ownable {
126   address public owner;
127 
128   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
129 
130   /**
131    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
132    * account.
133    */
134   constructor() public {
135     owner = msg.sender;
136   }
137 
138   /**
139    * @dev Throws if called by any account other than the owner.
140    */
141   modifier onlyOwner() {
142     require(msg.sender == owner);
143     _;
144   }
145 
146   /**
147    * @dev Allows the current owner to transfer control of the contract to a newOwner.
148    * @param newOwner The address to transfer ownership to.
149    */
150   function transferOwnership(address newOwner) public onlyOwner {
151     require(newOwner != address(0));
152     emit OwnershipTransferred(owner, newOwner);
153     owner = newOwner;
154   }
155 }
156 
157 /**
158  * @title ApproveAndCallFallBack
159  * @dev Interface to notify contracts about approved tokens
160  */
161 contract ApproveAndCallFallBack {
162   function receiveApproval(address _from, uint256 _amount, address _token, bytes _data) public;
163 }
164 
165 contract BCBToken is ERC20Token, Ownable {
166   uint256 constant public BCB_UNIT = 10 ** 18;
167 
168   string public constant name = "BCBToken";
169   string public constant symbol = "BCB";
170   uint32 public constant decimals = 18;
171 
172   uint256 public totalSupply = 120000000 * BCB_UNIT;
173   uint256 public lockedAllocation = 53500000 * BCB_UNIT;
174   uint256 public totalAllocated = 0;
175   address public allocationAddress;
176 
177   uint256 public lockEndTime;
178 
179   constructor(address _allocationAddress) public {
180     // Transfer the rest of the tokens to the owner
181     balanceOf[owner] = totalSupply - lockedAllocation;
182     allocationAddress = _allocationAddress;
183 
184     // Lock for 12 months
185     lockEndTime = now + 12 * 30 days;
186   }
187 
188   /**
189    * @dev Release all locked tokens
190    * throws if called not by the owner or called before timelock (12 months)
191    * or if tokens were already allocated
192    */
193   function releaseLockedTokens() public onlyOwner {
194     require(now > lockEndTime);
195     require(totalAllocated < lockedAllocation);
196 
197     totalAllocated = lockedAllocation;
198     balanceOf[allocationAddress] = balanceOf[allocationAddress].add(lockedAllocation);
199 
200     emit Transfer(0x0, allocationAddress, lockedAllocation);
201   }
202 
203   /**
204    * @dev Allow other contract to spend tokens and notify the contract about it a in single transaction
205    * @param _spender    address   The contract address authorized to spend
206    * @param _value      uint256   The amount of tokens can be spend
207    * @param _extraData  bytes     Some extra information to send to the approved contract
208    */
209   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
210     if (approve(_spender, _value)) {
211       ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, address(this), _extraData);
212       return true;
213     }
214   }
215 }
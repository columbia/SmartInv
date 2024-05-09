1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address private _owner;
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   /**
28    * @return the address of the owner.
29    */
30   function owner() public view returns(address) {
31     return _owner;
32   }
33 
34   /**
35    * @dev Throws if called by any account other than the owner.
36    */
37   modifier onlyOwner() {
38     require(isOwner());
39     _;
40   }
41 
42   /**
43    * @return true if `msg.sender` is the owner of the contract.
44    */
45   function isOwner() public view returns(bool) {
46     return msg.sender == _owner;
47   }
48 
49   /**
50    * @dev Allows the current owner to relinquish control of the contract.
51    * @notice Renouncing to ownership will leave the contract without an owner.
52    * It will not be possible to call the functions with the `onlyOwner`
53    * modifier anymore.
54    */
55   function renounceOwnership() public onlyOwner {
56     emit OwnershipTransferred(_owner, address(0));
57     _owner = address(0);
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65     _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(_owner, newOwner);
75     _owner = newOwner;
76   }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that revert on error
84  */
85 library SafeMath {
86 
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92     // benefit is lost if 'b' is also tested.
93     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94     if (a == 0) {
95       return 0;
96     }
97 
98     uint256 c = a * b;
99     require(c / a == b);
100 
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     require(b > 0); // Solidity only automatically asserts when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117   */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126   * @dev Adds two numbers, reverts on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
137   * reverts when dividing by zero.
138   */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
146 
147 /**
148  * @title ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/20
150  */
151 interface IERC20 {
152   function totalSupply() external view returns (uint256);
153 
154   function balanceOf(address who) external view returns (uint256);
155 
156   function allowance(address owner, address spender)
157     external view returns (uint256);
158 
159   function transfer(address to, uint256 value) external returns (bool);
160 
161   function approve(address spender, uint256 value)
162     external returns (bool);
163 
164   function transferFrom(address from, address to, uint256 value)
165     external returns (bool);
166 
167   event Transfer(
168     address indexed from,
169     address indexed to,
170     uint256 value
171   );
172 
173   event Approval(
174     address indexed owner,
175     address indexed spender,
176     uint256 value
177   );
178 }
179 
180 // File: contracts/Batch.sol
181 
182 contract Batch is Ownable {
183     using SafeMath for uint256;
184 
185     address public constant daiContractAddress = 0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359;
186     uint256 public constant daiGift = 1000000000000000000;
187     uint256 public constant ethGift = 5500000000000000;
188     uint256 public constant size = 80;
189 
190     function distributeEth(address[] _recipients)
191         public
192         payable
193         onlyOwner
194     {
195         require(_recipients.length == size, "recipients array has incorrect size");
196         require(msg.value == ethGift * size, "msg.value is not exact");
197 
198         for (uint i = 0; i < _recipients.length; i++) {
199             _recipients[i].transfer(ethGift);
200         }
201     }
202 
203     function distributeDai(address[] _recipients)
204         public
205         onlyOwner
206     {
207         require(_recipients.length == size, "recipients array has incorrect size");
208 
209         uint256 distribution = daiGift.mul(size);
210         IERC20 daiContract = IERC20(daiContractAddress);
211         uint256 allowance = daiContract.allowance(msg.sender, address(this));
212         require(
213             allowance >= distribution,
214             "contract not allowed to transfer enough tokens"
215         );
216 
217         for (uint i = 0; i < _recipients.length; i++) {
218             daiContract.transferFrom(msg.sender, _recipients[i], daiGift);
219         }
220     }
221 }
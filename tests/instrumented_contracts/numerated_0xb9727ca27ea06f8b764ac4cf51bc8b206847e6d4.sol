1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (a == 0) {
13       return 0;
14     }
15 
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title Math
52  * @dev Assorted math operations
53  */
54 library Math {
55   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
68     return a < b ? a : b;
69   }
70 }
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77   address public owner;
78 
79 
80   event OwnershipRenounced(address indexed previousOwner);
81   event OwnershipTransferred(
82     address indexed previousOwner,
83     address indexed newOwner
84   );
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to relinquish control of the contract.
105    */
106   function renounceOwnership() public onlyOwner {
107     emit OwnershipRenounced(owner);
108     owner = address(0);
109   }
110 
111   /**
112    * @dev Allows the current owner to transfer control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function transferOwnership(address _newOwner) public onlyOwner {
116     _transferOwnership(_newOwner);
117   }
118 
119   /**
120    * @dev Transfers control of the contract to a newOwner.
121    * @param _newOwner The address to transfer ownership to.
122    */
123   function _transferOwnership(address _newOwner) internal {
124     require(_newOwner != address(0));
125     emit OwnershipTransferred(owner, _newOwner);
126     owner = _newOwner;
127   }
128 }
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   function totalSupply() public view returns (uint256);
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 contract ERC20 is ERC20Basic {
148   function allowance(address owner, address spender)
149     public view returns (uint256);
150 
151   function transferFrom(address from, address to, uint256 value)
152     public returns (bool);
153 
154   function approve(address spender, uint256 value) public returns (bool);
155   event Approval(
156     address indexed owner,
157     address indexed spender,
158     uint256 value
159   );
160 }
161 
162 
163 /**
164  * @title SafeERC20
165  * @dev Wrappers around ERC20 operations that throw on failure.
166  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
167  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
168  */
169 library SafeERC20 {
170   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
171     require(token.transfer(to, value));
172   }
173 
174   function safeTransferFrom(
175     ERC20 token,
176     address from,
177     address to,
178     uint256 value
179   )
180     internal
181   {
182     require(token.transferFrom(from, to, value));
183   }
184 
185   function safeApprove(ERC20 token, address spender, uint256 value) internal {
186     require(token.approve(spender, value));
187   }
188 }
189 
190 
191 interface DisbursementHandlerI {
192     function withdraw(address _beneficiary, uint256 _index) external;
193 }
194 
195 
196 /// @title Disbursement handler - Manages time locked disbursements of ERC20 tokens
197 contract DisbursementHandler is DisbursementHandlerI, Ownable {
198     using SafeMath for uint256;
199     using SafeERC20 for ERC20;
200 
201     struct Disbursement {
202         // Tokens cannot be withdrawn before this timestamp
203         uint256 timestamp;
204 
205         // Amount of tokens to be disbursed
206         uint256 value;
207     }
208 
209     event Setup(address indexed _beneficiary, uint256 _timestamp, uint256 _value);
210     event TokensWithdrawn(address indexed _to, uint256 _value);
211 
212     ERC20 public token;
213     uint256 public totalAmount;
214     mapping(address => Disbursement[]) public disbursements;
215 
216     constructor(ERC20 _token) public {
217         require(_token != address(0));
218         token = _token;
219     }
220 
221     /// @dev Called by the sale contract to create a disbursement.
222     /// @param _beneficiary The address of the beneficiary.
223     /// @param _value Amount of tokens to be locked.
224     /// @param _timestamp Funds will be locked until this timestamp.
225     function setupDisbursement(
226         address _beneficiary,
227         uint256 _value,
228         uint256 _timestamp
229     )
230         external
231         onlyOwner
232     {
233         require(block.timestamp < _timestamp);
234         disbursements[_beneficiary].push(Disbursement(_timestamp, _value));
235         totalAmount = totalAmount.add(_value);
236         emit Setup(_beneficiary, _timestamp, _value);
237     }
238 
239     /// @dev Transfers tokens to a beneficiary
240     /// @param _beneficiary The address to transfer tokens to
241     /// @param _index The index of the disbursement
242     function withdraw(address _beneficiary, uint256 _index)
243         external
244     {
245         Disbursement[] storage beneficiaryDisbursements = disbursements[_beneficiary];
246         require(_index < beneficiaryDisbursements.length);
247 
248         Disbursement memory disbursement = beneficiaryDisbursements[_index];
249         require(disbursement.timestamp < now && disbursement.value > 0);
250 
251         // Remove the withdrawn disbursement
252         delete beneficiaryDisbursements[_index];
253 
254         token.safeTransfer(_beneficiary, disbursement.value);
255         emit TokensWithdrawn(_beneficiary, disbursement.value);
256     }
257 }
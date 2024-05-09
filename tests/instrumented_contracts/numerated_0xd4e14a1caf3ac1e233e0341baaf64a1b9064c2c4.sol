1 pragma solidity 0.4.24;
2 
3 // File: @tokenfoundry/sale-contracts/contracts/interfaces/DisbursementHandlerI.sol
4 
5 interface DisbursementHandlerI {
6     function withdraw(address _beneficiary, uint256 _index) external;
7 }
8 
9 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
21     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipRenounced(address indexed previousOwner);
73   event OwnershipTransferred(
74     address indexed previousOwner,
75     address indexed newOwner
76   );
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to relinquish control of the contract.
97    */
98   function renounceOwnership() public onlyOwner {
99     emit OwnershipRenounced(owner);
100     owner = address(0);
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address _newOwner) public onlyOwner {
108     _transferOwnership(_newOwner);
109   }
110 
111   /**
112    * @dev Transfers control of the contract to a newOwner.
113    * @param _newOwner The address to transfer ownership to.
114    */
115   function _transferOwnership(address _newOwner) internal {
116     require(_newOwner != address(0));
117     emit OwnershipTransferred(owner, _newOwner);
118     owner = _newOwner;
119   }
120 }
121 
122 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   function totalSupply() public view returns (uint256);
131   function balanceOf(address who) public view returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender)
144     public view returns (uint256);
145 
146   function transferFrom(address from, address to, uint256 value)
147     public returns (bool);
148 
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(
151     address indexed owner,
152     address indexed spender,
153     uint256 value
154   );
155 }
156 
157 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
158 
159 /**
160  * @title SafeERC20
161  * @dev Wrappers around ERC20 operations that throw on failure.
162  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
163  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
164  */
165 library SafeERC20 {
166   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
167     require(token.transfer(to, value));
168   }
169 
170   function safeTransferFrom(
171     ERC20 token,
172     address from,
173     address to,
174     uint256 value
175   )
176     internal
177   {
178     require(token.transferFrom(from, to, value));
179   }
180 
181   function safeApprove(ERC20 token, address spender, uint256 value) internal {
182     require(token.approve(spender, value));
183   }
184 }
185 
186 // File: @tokenfoundry/sale-contracts/contracts/DisbursementHandler.sol
187 
188 /// @title Disbursement handler - Manages time locked disbursements of ERC20 tokens
189 contract DisbursementHandler is DisbursementHandlerI, Ownable {
190     using SafeMath for uint256;
191     using SafeERC20 for ERC20;
192 
193     struct Disbursement {
194         // Tokens cannot be withdrawn before this timestamp
195         uint256 timestamp;
196 
197         // Amount of tokens to be disbursed
198         uint256 value;
199     }
200 
201     event Setup(address indexed _beneficiary, uint256 _timestamp, uint256 _value);
202     event TokensWithdrawn(address indexed _to, uint256 _value);
203 
204     ERC20 public token;
205     uint256 public totalAmount;
206     mapping(address => Disbursement[]) public disbursements;
207 
208     bool public closed;
209 
210     modifier isOpen {
211         require(!closed, "Disbursement Handler is closed");
212         _;
213     }
214 
215     modifier isClosed {
216         require(closed, "Disbursement Handler is open");
217         _;
218     }
219 
220 
221     constructor(ERC20 _token) public {
222         require(_token != address(0), "Token cannot have address 0");
223         token = _token;
224     }
225 
226     /// @dev Called to create disbursements.
227     /// @param _beneficiaries The addresses of the beneficiaries.
228     /// @param _values The number of tokens to be locked for each disbursement.
229     /// @param _timestamps Funds will be locked until this timestamp for each disbursement.
230     function setupDisbursements(
231         address[] _beneficiaries,
232         uint256[] _values,
233         uint256[] _timestamps
234     )
235         external
236         onlyOwner
237         isOpen
238     {
239         require((_beneficiaries.length == _values.length) && (_beneficiaries.length == _timestamps.length), "Arrays not of equal length");
240         require(_beneficiaries.length > 0, "Arrays must have length > 0");
241 
242         for (uint256 i = 0; i < _beneficiaries.length; i++) {
243             setupDisbursement(_beneficiaries[i], _values[i], _timestamps[i]);
244         }
245     }
246 
247     function close() external onlyOwner isOpen {
248         closed = true;
249     }
250 
251     /// @dev Called by the sale contract to create a disbursement.
252     /// @param _beneficiary The address of the beneficiary.
253     /// @param _value Amount of tokens to be locked.
254     /// @param _timestamp Funds will be locked until this timestamp.
255     function setupDisbursement(
256         address _beneficiary,
257         uint256 _value,
258         uint256 _timestamp
259     )
260         internal
261     {
262         require(block.timestamp < _timestamp, "Disbursement timestamp in the past");
263         disbursements[_beneficiary].push(Disbursement(_timestamp, _value));
264         totalAmount = totalAmount.add(_value);
265         emit Setup(_beneficiary, _timestamp, _value);
266     }
267 
268     /// @dev Transfers tokens to a beneficiary
269     /// @param _beneficiary The address to transfer tokens to
270     /// @param _index The index of the disbursement
271     function withdraw(address _beneficiary, uint256 _index)
272         external
273         isClosed
274     {
275         Disbursement[] storage beneficiaryDisbursements = disbursements[_beneficiary];
276         require(_index < beneficiaryDisbursements.length, "Supplied index out of disbursement range");
277 
278         Disbursement memory disbursement = beneficiaryDisbursements[_index];
279         require(disbursement.timestamp < now && disbursement.value > 0, "Disbursement timestamp not reached, or disbursement value of 0");
280 
281         // Remove the withdrawn disbursement
282         delete beneficiaryDisbursements[_index];
283 
284         token.safeTransfer(_beneficiary, disbursement.value);
285         emit TokensWithdrawn(_beneficiary, disbursement.value);
286     }
287 }
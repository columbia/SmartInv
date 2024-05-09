1 //File: node_modules\openzeppelin-solidity\contracts\ownership\Ownable.sol
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
68 pragma solidity ^0.4.24;
69 
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * See https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   function totalSupply() public view returns (uint256);
78   function balanceOf(address _who) public view returns (uint256);
79   function transfer(address _to, uint256 _value) public returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
84 pragma solidity ^0.4.24;
85 
86 
87 
88 
89 /**
90  * @title ERC20 interface
91  * @dev see https://github.com/ethereum/EIPs/issues/20
92  */
93 contract ERC20 is ERC20Basic {
94   function allowance(address _owner, address _spender)
95     public view returns (uint256);
96 
97   function transferFrom(address _from, address _to, uint256 _value)
98     public returns (bool);
99 
100   function approve(address _spender, uint256 _value) public returns (bool);
101   event Approval(
102     address indexed owner,
103     address indexed spender,
104     uint256 value
105   );
106 }
107 
108 //File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
109 pragma solidity ^0.4.24;
110 
111 
112 
113 
114 
115 /**
116  * @title SafeERC20
117  * @dev Wrappers around ERC20 operations that throw on failure.
118  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
119  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
120  */
121 library SafeERC20 {
122   function safeTransfer(
123     ERC20Basic _token,
124     address _to,
125     uint256 _value
126   )
127     internal
128   {
129     require(_token.transfer(_to, _value));
130   }
131 
132   function safeTransferFrom(
133     ERC20 _token,
134     address _from,
135     address _to,
136     uint256 _value
137   )
138     internal
139   {
140     require(_token.transferFrom(_from, _to, _value));
141   }
142 
143   function safeApprove(
144     ERC20 _token,
145     address _spender,
146     uint256 _value
147   )
148     internal
149   {
150     require(_token.approve(_spender, _value));
151   }
152 }
153 
154 //File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
155 pragma solidity ^0.4.24;
156 
157 
158 /**
159  * @title SafeMath
160  * @dev Math operations with safety checks that throw on error
161  */
162 library SafeMath {
163 
164   /**
165   * @dev Multiplies two numbers, throws on overflow.
166   */
167   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
168     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
169     // benefit is lost if 'b' is also tested.
170     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
171     if (_a == 0) {
172       return 0;
173     }
174 
175     c = _a * _b;
176     assert(c / _a == _b);
177     return c;
178   }
179 
180   /**
181   * @dev Integer division of two numbers, truncating the quotient.
182   */
183   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
184     // assert(_b > 0); // Solidity automatically throws when dividing by 0
185     // uint256 c = _a / _b;
186     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
187     return _a / _b;
188   }
189 
190   /**
191   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
192   */
193   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
194     assert(_b <= _a);
195     return _a - _b;
196   }
197 
198   /**
199   * @dev Adds two numbers, throws on overflow.
200   */
201   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
202     c = _a + _b;
203     assert(c >= _a);
204     return c;
205   }
206 }
207 
208 //File: contracts\ico\BountyDistribution.sol
209 /**
210  * @title TILE Token Distribution - LOOMIA
211  * @author Pactum IO <dev@pactum.io>
212  */
213 pragma solidity ^0.4.24;
214 
215 
216 
217 
218 
219 contract TileDistribution is Ownable {
220     using SafeMath for uint256;
221 
222     /*** VARIABLES ***/
223     ERC20Basic public token; // The token being distributed
224 
225     /*** EVENTS ***/
226     event AirDrop(address indexed _beneficiaryAddress, uint256 _amount);
227 
228     /*** MODIFIERS ***/
229     modifier validAddressAmount(address _beneficiaryWallet, uint256 _amount) {
230         require(_beneficiaryWallet != address(0));
231         require(_amount != 0);
232         _;
233     }
234 
235     constructor(address _token) public {
236         require(_token != address(0));
237 
238         token = ERC20Basic(_token);
239     }
240 
241     /*** PUBLIC || EXTERNAL ***/
242 
243     /**
244      * @dev This function is the batch send function for Token distribution. It accepts an array of addresses and amounts
245      * @param _beneficiaryWallets the address where tokens will be deposited into
246      * @param _amounts the token amount in wei to send to the associated beneficiary
247      */
248     function batchDistributeTokens(address[] _beneficiaryWallets, uint256[] _amounts) external onlyOwner {
249         require(_beneficiaryWallets.length == _amounts.length);
250         for (uint i = 0; i < _beneficiaryWallets.length; i++) {
251             distributeTokens(_beneficiaryWallets[i], _amounts[i]);
252         }
253     }
254 
255     /**
256      * @dev Single token airdrop function. It is for a single transfer of tokens to beneficiary
257      * @param _beneficiaryWallet the address where tokens will be deposited into
258      * @param _amount the token amount in wei to send to the associated beneficiary
259      */
260     function distributeTokens(address _beneficiaryWallet, uint256 _amount) public onlyOwner validAddressAmount(_beneficiaryWallet, _amount) {
261         token.transfer(_beneficiaryWallet, _amount);
262         emit AirDrop(_beneficiaryWallet, _amount);
263     }
264 }
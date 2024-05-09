1 pragma solidity ^0.4.23;
2 
3 // File: contracts/common/Ownable.sol
4 
5 /**
6  * Ownable contract from Open zepplin
7  * https://github.com/OpenZeppelin/openzeppelin-solidity/
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    * @notice Renouncing to ownership will leave the contract without an owner.
42    * It will not be possible to call the functions with the `onlyOwner`
43    * modifier anymore.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address _newOwner) public onlyOwner {
55     _transferOwnership(_newOwner);
56   }
57 
58   /**
59    * @dev Transfers control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function _transferOwnership(address _newOwner) internal {
63     require(_newOwner != address(0));
64     emit OwnershipTransferred(owner, _newOwner);
65     owner = _newOwner;
66   }
67 }
68 
69 // File: contracts/common/ReentrancyGuard.sol
70 
71 /**
72  * Reentrancy guard from open Zepplin :
73  * https://github.com/OpenZeppelin/openzeppelin-solidity/
74  *
75  * @title Helps contracts guard agains reentrancy attacks.
76  * @author Remco Bloemen <remco@2π.com>
77  * @notice If you mark a function `nonReentrant`, you should also
78  * mark it `external`.
79  */
80 contract ReentrancyGuard {
81 
82   /**
83    * @dev We use a single lock for the whole contract.
84    */
85   bool private reentrancyLock = false;
86 
87   /**
88    * @dev Prevents a contract from calling itself, directly or indirectly.
89    * @notice If you mark a function `nonReentrant`, you should also
90    * mark it `external`. Calling one nonReentrant function from
91    * another is not supported. Instead, you can implement a
92    * `private` function doing the actual work, and a `external`
93    * wrapper marked as `nonReentrant`.
94    */
95   modifier nonReentrant() {
96     require(!reentrancyLock);
97     reentrancyLock = true;
98     _;
99     reentrancyLock = false;
100   }
101 
102 }
103 
104 // File: contracts/common/SafeMath.sol
105 
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111 
112   /**
113   * @dev Multiplies two numbers, throws on overflow.
114   */
115   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
116     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
117     // benefit is lost if 'b' is also tested.
118     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
119     if (a == 0) {
120       return 0;
121     }
122 
123     c = a * b;
124     assert(c / a == b);
125     return c;
126   }
127 
128   /**
129   * @dev Integer division of two numbers, truncating the quotient.
130   */
131   function div(uint256 a, uint256 b) internal pure returns (uint256) {
132     // assert(b > 0); // Solidity automatically throws when dividing by 0
133     // uint256 c = a / b;
134     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135     return a / b;
136   }
137 
138   /**
139   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
140   */
141   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142     assert(b <= a);
143     return a - b;
144   }
145 
146   /**
147   * @dev Adds two numbers, throws on overflow.
148   */
149   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
150     c = a + b;
151     assert(c >= a);
152     return c;
153   }
154 }
155 
156 // File: contracts/interfaces/ERC20Interface.sol
157 
158 interface ERC20 {
159     function totalSupply() public view returns (uint supply);
160     function balanceOf(address _owner) public view returns (uint balance);
161     function transfer(address _to, uint _value) public returns (bool success);
162     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
163     function approve(address _spender, uint _value) public returns (bool success);
164     function allowance(address _owner, address _spender) public view returns (uint remaining);
165     function decimals() public view returns(uint digits);
166     event Approval(address indexed _owner, address indexed _spender, uint _value);
167 }
168 
169 //TODO : Flattener does not like aliased imports. Not needed in actual codebase.
170 
171 interface IERC20Token {
172     function totalSupply() public view returns (uint supply);
173     function balanceOf(address _owner) public view returns (uint balance);
174     function transfer(address _to, uint _value) public returns (bool success);
175     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
176     function approve(address _spender, uint _value) public returns (bool success);
177     function allowance(address _owner, address _spender) public view returns (uint remaining);
178     function decimals() public view returns(uint digits);
179     event Approval(address indexed _owner, address indexed _spender, uint _value);
180 }
181 
182 // File: contracts/interfaces/IBancorNetwork.sol
183 
184 contract IBancorNetwork {
185     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
186     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
187     function convertForPrioritized2(
188         IERC20Token[] _path,
189         uint256 _amount,
190         uint256 _minReturn,
191         address _for,
192         uint256 _block,
193         uint8 _v,
194         bytes32 _r,
195         bytes32 _s)
196         public payable returns (uint256);
197 
198     // deprecated, backward compatibility
199     function convertForPrioritized(
200         IERC20Token[] _path,
201         uint256 _amount,
202         uint256 _minReturn,
203         address _for,
204         uint256 _block,
205         uint256 _nonce,
206         uint8 _v,
207         bytes32 _r,
208         bytes32 _s)
209         public payable returns (uint256);
210 }
211 
212 /*
213    Bancor Contract Registry interface
214 */
215 contract IContractRegistry {
216     function getAddress(bytes32 _contractName) public view returns (address);
217 }
218 
219 // File: contracts/TokenPaymentBancor.sol
220 
221 /*
222  * @title Token Payment using Bancor API v0.1
223  * @author Haresh G
224  * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
225  * @notice It does not support ERC20 to ERC20 transfer.
226  */
227 
228 
229 
230 
231 
232 
233 
234 
235 contract IndTokenPayment is Ownable, ReentrancyGuard {  
236     using SafeMath for uint256;
237     IERC20Token[] public path;    
238     address public destinationWallet;       
239     //Minimum tokens per 1 ETH to convert
240     uint256 public minConversionRate;
241     IContractRegistry public bancorRegistry;
242     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
243     
244     event conversionSucceded(address from,uint256 fromTokenVal,address dest,uint256 destTokenVal);    
245     
246     constructor(IERC20Token[] _path,
247                 address destWalletAddr,
248                 address bancorRegistryAddr,
249                 uint256 minConvRate){
250         path = _path;
251         bancorRegistry = IContractRegistry(bancorRegistryAddr);
252         destinationWallet = destWalletAddr;         
253         minConversionRate = minConvRate;
254     }
255 
256     function setConversionPath(IERC20Token[] _path) public onlyOwner {
257         path = _path;
258     }
259     
260     function setBancorRegistry(address bancorRegistryAddr) public onlyOwner {
261         bancorRegistry = IContractRegistry(bancorRegistryAddr);
262     }
263 
264     function setMinConversionRate(uint256 minConvRate) public onlyOwner {
265         minConversionRate = minConvRate;
266     }    
267 
268     function setDestinationWallet(address destWalletAddr) public onlyOwner {
269         destinationWallet = destWalletAddr;
270     }    
271     
272     function convertToInd() internal nonReentrant {
273         assert(bancorRegistry.getAddress(BANCOR_NETWORK) != address(0));
274         IBancorNetwork bancorNetwork = IBancorNetwork(bancorRegistry.getAddress(BANCOR_NETWORK));   
275         uint256 minReturn = minConversionRate.mul(msg.value);
276         uint256 convTokens =  bancorNetwork.convertFor.value(msg.value)(path,msg.value,minReturn,destinationWallet);        
277         assert(convTokens > 0);
278         emit conversionSucceded(msg.sender,msg.value,destinationWallet,convTokens);                                                                    
279     }
280 
281     //If accidentally tokens are transferred to this
282     //contract. They can be withdrawn by the followin interface.
283     function withdrawToken(IERC20Token anyToken) public onlyOwner nonReentrant returns(bool){
284         if( anyToken != address(0x0) ) {
285             assert(anyToken.transfer(destinationWallet, anyToken.balanceOf(this)));
286         }
287         return true;
288     }
289 
290     //ETH cannot get locked in this contract. If it does, this can be used to withdraw
291     //the locked ether.
292     function withdrawEther() public onlyOwner nonReentrant returns(bool){
293         if(address(this).balance > 0){
294             destinationWallet.transfer(address(this).balance);
295         }        
296         return true;
297     }
298  
299     function () public payable nonReentrant {
300         //Bancor contract can send the transfer back in case of error, which goes back into this
301         //function ,convertToInd is non-reentrant.
302         convertToInd();
303     }
304 
305     /*
306     * Helper function
307     *
308     */
309 
310     function getBancorContractAddress() public view returns(address) {
311         return bancorRegistry.getAddress(BANCOR_NETWORK);
312     }
313 
314 
315 }
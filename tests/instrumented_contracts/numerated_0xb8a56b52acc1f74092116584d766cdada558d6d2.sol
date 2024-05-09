1 pragma solidity 0.4.24;
2 
3 // File: contracts/common/Ownable.sol
4 
5 
6 /**
7  * Ownable contract from Open zepplin
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipRenounced(address indexed previousOwner);
18   event OwnershipTransferred(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    * @notice Renouncing to ownership will leave the contract without an owner.
43    * It will not be possible to call the functions with the `onlyOwner`
44    * modifier anymore.
45    */
46   function renounceOwnership() public onlyOwner {
47     emit OwnershipRenounced(owner);
48     owner = address(0);
49   }
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address _newOwner) public onlyOwner {
56     _transferOwnership(_newOwner);
57   }
58 
59   /**
60    * @dev Transfers control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63   function _transferOwnership(address _newOwner) internal {
64     require(_newOwner != address(0));
65     emit OwnershipTransferred(owner, _newOwner);
66     owner = _newOwner;
67   }
68 }
69 
70 // File: contracts/common/ReentrancyGuard.sol
71 
72 /**
73  * Reentrancy guard from open Zepplin :
74  * https://github.com/OpenZeppelin/openzeppelin-solidity/
75  *
76  * @title Helps contracts guard agains reentrancy attacks.
77  * @author Remco Bloemen <remco@2π.com>
78  * @notice If you mark a function `nonReentrant`, you should also
79  * mark it `external`.
80  */
81 contract ReentrancyGuard {
82 
83   /**
84    * @dev We use a single lock for the whole contract.
85    */
86   bool private reentrancyLock = false;
87 
88   /**
89    * @dev Prevents a contract from calling itself, directly or indirectly.
90    * @notice If you mark a function `nonReentrant`, you should also
91    * mark it `external`. Calling one nonReentrant function from
92    * another is not supported. Instead, you can implement a
93    * `private` function doing the actual work, and a `external`
94    * wrapper marked as `nonReentrant`.
95    */
96   modifier nonReentrant() {
97     require(!reentrancyLock);
98     reentrancyLock = true;
99     _;
100     reentrancyLock = false;
101   }
102 
103 }
104 
105 // File: contracts/common/SafeMath.sol
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
117     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
118     // benefit is lost if 'b' is also tested.
119     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
120     if (a == 0) {
121       return 0;
122     }
123 
124     c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     // uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return a / b;
137   }
138 
139   /**
140   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
151     c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }
156 
157 // File: contracts/interfaces/ERC20Interface.sol
158 
159 interface ERC20 {
160     function totalSupply() public view returns (uint supply);
161     function balanceOf(address _owner) public view returns (uint balance);
162     function transfer(address _to, uint _value) public returns (bool success);
163     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
164     function approve(address _spender, uint _value) public returns (bool success);
165     function allowance(address _owner, address _spender) public view returns (uint remaining);
166     function decimals() public view returns(uint digits);
167     event Approval(address indexed _owner, address indexed _spender, uint _value);
168 }
169 
170 //TODO : Flattener does not like aliased imports. Not needed in actual codebase.
171 
172 interface IERC20Token {
173     function totalSupply() public view returns (uint supply);
174     function balanceOf(address _owner) public view returns (uint balance);
175     function transfer(address _to, uint _value) public returns (bool success);
176     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
177     function approve(address _spender, uint _value) public returns (bool success);
178     function allowance(address _owner, address _spender) public view returns (uint remaining);
179     function decimals() public view returns(uint digits);
180     event Approval(address indexed _owner, address indexed _spender, uint _value);
181 }
182 
183 // File: contracts/interfaces/IBancorNetwork.sol
184 
185 contract IBancorNetwork {
186     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
187     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
188     function convertForPrioritized2(
189         IERC20Token[] _path,
190         uint256 _amount,
191         uint256 _minReturn,
192         address _for,
193         uint256 _block,
194         uint8 _v,
195         bytes32 _r,
196         bytes32 _s)
197         public payable returns (uint256);
198 
199     // deprecated, backward compatibility
200     function convertForPrioritized(
201         IERC20Token[] _path,
202         uint256 _amount,
203         uint256 _minReturn,
204         address _for,
205         uint256 _block,
206         uint256 _nonce,
207         uint8 _v,
208         bytes32 _r,
209         bytes32 _s)
210         public payable returns (uint256);
211 }
212 
213 /*
214    Bancor Contract Registry interface
215 */
216 contract IContractRegistry {
217     function getAddress(bytes32 _contractName) public view returns (address);
218 }
219 
220 // File: contracts/TokenPaymentBancor.sol
221 
222 /*
223  * @title Token Payment using Bancor API v0.1
224  * @author Haresh G
225  * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
226  * @notice It does not support ERC20 to ERC20 transfer.
227  */
228 
229 contract IndTokenPayment is Ownable, ReentrancyGuard {  
230     using SafeMath for uint256;
231     IERC20Token[] public path;    
232     address public destinationWallet;       
233     //Minimum tokens per 1 ETH to convert
234     uint256 public minConversionRate;
235     IContractRegistry public bancorRegistry;
236     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
237     
238     event conversionSucceded(address from,uint256 fromTokenVal,address dest,uint256 minReturn,uint256 destTokenVal);    
239     event conversionMin(uint256 min);
240     
241     constructor(IERC20Token[] _path,
242                 address destWalletAddr,
243                 address bancorRegistryAddr,
244                 uint256 minConvRate){
245         path = _path;
246         bancorRegistry = IContractRegistry(bancorRegistryAddr);
247         destinationWallet = destWalletAddr;         
248         minConversionRate = minConvRate;
249     }
250 
251     function setConversionPath(IERC20Token[] _path) public onlyOwner {
252         path = _path;
253     }
254     
255     function setBancorRegistry(address bancorRegistryAddr) public onlyOwner {
256         bancorRegistry = IContractRegistry(bancorRegistryAddr);
257     }
258 
259     function setMinConversionRate(uint256 minConvRate) public onlyOwner {
260         minConversionRate = minConvRate;
261     }    
262 
263     function setDestinationWallet(address destWalletAddr) public onlyOwner {
264         destinationWallet = destWalletAddr;
265     }    
266     
267     function convertToInd() internal {
268         assert(bancorRegistry.getAddress(BANCOR_NETWORK) != address(0));
269         IBancorNetwork bancorNetwork = IBancorNetwork(bancorRegistry.getAddress(BANCOR_NETWORK));   
270         uint256 minReturn = minConversionRate.mul(msg.value);
271         uint256 convTokens =  bancorNetwork.convertFor.value(msg.value)(path,msg.value,minReturn,destinationWallet);        
272         assert(convTokens > 0);
273         emit conversionSucceded(msg.sender,msg.value,destinationWallet,minReturn,convTokens);                                                                    
274     }
275 
276     //If accidentally tokens are transferred to this
277     //contract. They can be withdrawn by the followin interface.
278     function withdrawToken(IERC20Token anyToken) public onlyOwner nonReentrant returns(bool){
279         if( anyToken != address(0x0) ) {
280             assert(anyToken.transfer(destinationWallet, anyToken.balanceOf(this)));
281         }
282         return true;
283     }
284 
285     //ETH cannot get locked in this contract. If it does, this can be used to withdraw
286     //the locked ether.
287     function withdrawEther() public onlyOwner nonReentrant returns(bool){
288         if(address(this).balance > 0){
289             destinationWallet.transfer(address(this).balance);
290         }        
291         return true;
292     }
293  
294     function () public payable nonReentrant{
295         //Bancor contract can send the transfer back in case of error, which goes back into this
296         //function ,convertToInd is non-reentrant.
297         convertToInd();
298     }
299 
300     /*
301     * Helper function
302     *
303     */
304 
305     function getBancorContractAddress() public view returns(address) {
306         return bancorRegistry.getAddress(BANCOR_NETWORK);
307     }
308 
309 
310 }
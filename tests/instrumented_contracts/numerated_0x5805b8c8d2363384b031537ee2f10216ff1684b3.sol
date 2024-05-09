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
104 // File: contracts/interfaces/ERC20Interface.sol
105 
106 interface ERC20 {
107     function totalSupply() public view returns (uint supply);
108     function balanceOf(address _owner) public view returns (uint balance);
109     function transfer(address _to, uint _value) public returns (bool success);
110     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
111     function approve(address _spender, uint _value) public returns (bool success);
112     function allowance(address _owner, address _spender) public view returns (uint remaining);
113     function decimals() public view returns(uint digits);
114     event Approval(address indexed _owner, address indexed _spender, uint _value);
115 }
116 
117 //TODO : Flattener does not like aliased imports. Not needed in actual codebase.
118 
119 interface IERC20Token {
120     function totalSupply() public view returns (uint supply);
121     function balanceOf(address _owner) public view returns (uint balance);
122     function transfer(address _to, uint _value) public returns (bool success);
123     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
124     function approve(address _spender, uint _value) public returns (bool success);
125     function allowance(address _owner, address _spender) public view returns (uint remaining);
126     function decimals() public view returns(uint digits);
127     event Approval(address indexed _owner, address indexed _spender, uint _value);
128 }
129 
130 
131 // File: contracts/interfaces/IBancorNetwork.sol
132 
133 contract IBancorNetwork {
134     function convert(IERC20Token[] _path, uint256 _amount, uint256 _minReturn) public payable returns (uint256);
135     function convertFor(IERC20Token[] _path, uint256 _amount, uint256 _minReturn, address _for) public payable returns (uint256);
136     function convertForPrioritized2(
137         IERC20Token[] _path,
138         uint256 _amount,
139         uint256 _minReturn,
140         address _for,
141         uint256 _block,
142         uint8 _v,
143         bytes32 _r,
144         bytes32 _s)
145         public payable returns (uint256);
146 
147     // deprecated, backward compatibility
148     function convertForPrioritized(
149         IERC20Token[] _path,
150         uint256 _amount,
151         uint256 _minReturn,
152         address _for,
153         uint256 _block,
154         uint256 _nonce,
155         uint8 _v,
156         bytes32 _r,
157         bytes32 _s)
158         public payable returns (uint256);
159 }
160 
161 /*
162    Bancor Contract Registry interface
163 */
164 contract IContractRegistry {
165     function getAddress(bytes32 _contractName) public view returns (address);
166 }
167 
168 // File: contracts/TokenPaymentBancor.sol
169 
170 /*
171  * @title Token Payment using Bancor API v0.1
172  * @author Haresh G
173  * @dev This contract is used to convert ETH to an ERC20 token on the Bancor network.
174  * @notice It does not support ERC20 to ERC20 transfer.
175  */
176 
177 
178 
179 
180 
181 
182 
183 contract IndTokenPayment is Ownable, ReentrancyGuard {  
184     IERC20Token[] public path;    
185     address public destinationWallet;       
186     uint256 public minConversionRate;
187     IContractRegistry public bancorRegistry;
188     bytes32 public constant BANCOR_NETWORK = "BancorNetwork";
189     
190     event conversionSucceded(address from,uint256 fromTokenVal,address dest,uint256 destTokenVal);    
191     
192     constructor(IERC20Token[] _path,
193                 address destWalletAddr,
194                 address bancorRegistryAddr,
195                 uint256 minConvRate){
196         path = _path;
197         bancorRegistry = IContractRegistry(bancorRegistryAddr);
198         destinationWallet = destWalletAddr;         
199         minConversionRate = minConvRate;
200     }
201 
202     function setConversionPath(IERC20Token[] _path) public onlyOwner {
203         path = _path;
204     }
205     
206     function setBancorRegistry(address bancorRegistryAddr) public onlyOwner {
207         bancorRegistry = IContractRegistry(bancorRegistryAddr);
208     }
209 
210     function setMinConversionRate(uint256 minConvRate) public onlyOwner {
211         minConversionRate = minConvRate;
212     }    
213 
214     function setDestinationWallet(address destWalletAddr) public onlyOwner {
215         destinationWallet = destWalletAddr;
216     }    
217     
218     function convertToInd() internal nonReentrant {
219         assert(bancorRegistry.getAddress(BANCOR_NETWORK) != address(0));
220         IBancorNetwork bancorNetwork = IBancorNetwork(bancorRegistry.getAddress(BANCOR_NETWORK));   
221         //TODO : Compute minReturn
222         uint256 minReturn =0;
223         uint256 convTokens =  bancorNetwork.convertFor.value(msg.value)(path,msg.value,minReturn,destinationWallet);        
224         assert(convTokens > 0);
225         emit conversionSucceded(msg.sender,msg.value,destinationWallet,convTokens);                                                                    
226     }
227 
228     //If accidentally tokens are transferred to this
229     //contract. They can be withdrawn by the followin interface.
230     function withdrawToken(IERC20Token anyToken) public onlyOwner nonReentrant returns(bool){
231         if( anyToken != address(0x0) ) {
232             assert(anyToken.transfer(destinationWallet, anyToken.balanceOf(this)));
233         }
234         return true;
235     }
236 
237     //ETH cannot get locked in this contract. If it does, this can be used to withdraw
238     //the locked ether.
239     function withdrawEther() public onlyOwner nonReentrant returns(bool){
240         if(address(this).balance > 0){
241             destinationWallet.transfer(address(this).balance);
242         }        
243         return true;
244     }
245  
246     function () public payable {
247         //Bancor contract can send the transfer back in case of error, which goes back into this
248         //function ,convertToInd is non-reentrant.
249         convertToInd();
250     }
251 
252     /*
253     * Helper functions to debug contract. Not to be deployed
254     *
255     */
256 
257     function getBancorContractAddress() public returns(address) {
258         return bancorRegistry.getAddress(BANCOR_NETWORK);
259     }
260 
261 }
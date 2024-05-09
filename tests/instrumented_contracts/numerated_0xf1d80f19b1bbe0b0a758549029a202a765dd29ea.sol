1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/passThrough/PassThroughStorage.sol
77 
78 contract PassThroughStorage {
79     bytes4 public constant ERC721_Received = 0x150b7a02;
80     uint256 public constant MAX_EXPIRATION_TIME = (365 * 2 days);
81     mapping(bytes4 => uint256) public disableMethods;
82 
83     address public estateRegistry;
84     address public operator;
85     address public target;
86 
87     event MethodAllowed(
88       address indexed _caller,
89       bytes4 indexed _signatureBytes4,
90       string _signature
91     );
92 
93     event MethodDisabled(
94       address indexed _caller,
95       bytes4 indexed _signatureBytes4,
96       string _signature
97     );
98 
99     event TargetChanged(
100       address indexed _caller,
101       address indexed _oldTarget,
102       address indexed _newTarget
103     );
104 }
105 
106 // File: contracts/passThrough/PassThrough.sol
107 
108 contract PassThrough is Ownable, PassThroughStorage {
109     /**
110     * @dev Constructor of the contract.
111     */
112     constructor(address _estateRegistry, address _operator) Ownable() public {
113         estateRegistry = _estateRegistry;
114         operator = _operator;
115 
116         // Set target
117         setTarget(estateRegistry);
118 
119         // ERC721 methods
120         disableMethod("approve(address,uint256)", MAX_EXPIRATION_TIME);
121         disableMethod("setApprovalForAll(address,bool)", MAX_EXPIRATION_TIME);
122         disableMethod("transferFrom(address,address,uint256)", MAX_EXPIRATION_TIME);
123         disableMethod("safeTransferFrom(address,address,uint256)", MAX_EXPIRATION_TIME);
124         disableMethod("safeTransferFrom(address,address,uint256,bytes)", MAX_EXPIRATION_TIME);
125 
126         // EstateRegistry methods
127         disableMethod("transferLand(uint256,uint256,address)", MAX_EXPIRATION_TIME);
128         disableMethod("transferManyLands(uint256,uint256[],address)", MAX_EXPIRATION_TIME);
129         disableMethod("safeTransferManyFrom(address,address,uint256[])", MAX_EXPIRATION_TIME);
130         disableMethod("safeTransferManyFrom(address,address,uint256[],bytes)", MAX_EXPIRATION_TIME);
131 
132     }
133 
134     /**
135     * @dev Fallback function could be called by the operator, if the method is allowed, or
136     * by the owner. If the call was unsuccessful will revert.
137     */
138     function() external {
139         require(
140             isOperator() && isMethodAllowed(msg.sig) || isOwner(),
141             "Permission denied"
142         );
143 
144         bytes memory _calldata = msg.data;
145         uint256 _calldataSize = msg.data.length;
146         address _dst = target;
147 
148         // solium-disable-next-line security/no-inline-assembly
149         assembly {
150             let result := call(sub(gas, 10000), _dst, 0, add(_calldata, 0x20), _calldataSize, 0, 0)
151             let size := returndatasize
152 
153             let ptr := mload(0x40)
154             returndatacopy(ptr, 0, size)
155 
156             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
157             // if the call returned error data, forward it
158             if iszero(result) { revert(ptr, size) }
159             return(ptr, size)
160         }
161     }
162 
163     /**
164     * @dev Check if sender is the operator
165     * @return bool whether is sender is the caller or not
166     */
167     function isOperator() internal view returns (bool) {
168         return msg.sender == operator;
169     }
170 
171     /**
172     * @dev Check if a method is allowed
173     * @param _signature string - method signature
174     * @return bool - whether method is allowed or not
175     */
176     function isMethodAllowed(bytes4 _signature) internal view returns (bool) {
177         return disableMethods[_signature] < block.timestamp;
178     }
179 
180     function setTarget(address _target) public {
181         require(
182             isOperator() || isOwner(),
183             "Permission denied"
184         );
185 
186         emit TargetChanged(msg.sender, target, _target);
187         target = _target;
188     }
189 
190     /**
191     * @dev Disable a method for two years
192     * Note that the input expected is the method signature as 'transfer(address,uint256)'
193     * @param _signature string - method signature
194     */
195     function disableMethod(string memory _signature, uint256 _time) public onlyOwner {
196         require(_time > 0, "Time should be greater than 0");
197         require(_time <= MAX_EXPIRATION_TIME, "Time should be lower than 2 years");
198 
199         bytes4 signatureBytes4 = convertToBytes4(abi.encodeWithSignature(_signature));
200         disableMethods[signatureBytes4] = block.timestamp + _time;
201 
202         emit MethodDisabled(msg.sender, signatureBytes4, _signature);
203     }
204 
205     /**
206     * @dev Allow a method previously disabled
207     * Note that the input expected is the method signature as 'transfer(address,uint256)'
208     * @param _signature string - method signature
209     */
210     function allowMethod(string memory _signature) public onlyOwner {
211         bytes4 signatureBytes4 = convertToBytes4(abi.encodeWithSignature(_signature));
212         require(!isMethodAllowed(signatureBytes4), "Method is already allowed");
213 
214         disableMethods[signatureBytes4] = 0;
215 
216         emit MethodAllowed(msg.sender, signatureBytes4, _signature);
217     }
218 
219     /**
220     * @dev Convert bytes to bytes4
221     * @param _signature bytes - method signature
222     * @return bytes4 - method signature in bytes4
223     */
224     function convertToBytes4(bytes memory _signature) internal pure returns (bytes4) {
225         require(_signature.length == 4, "Invalid method signature");
226         bytes4 signatureBytes4;
227         // solium-disable-next-line security/no-inline-assembly
228         assembly {
229             signatureBytes4 := mload(add(_signature, 32))
230         }
231         return signatureBytes4;
232     }
233 
234     /**
235     * @notice Handle the receipt of an NFT
236     * @dev The ERC721 smart contract calls this function on the recipient
237     * after a `safetransfer`. This function MAY throw to revert and reject the
238     * transfer. Return of other than the magic value MUST result in the
239     * transaction being reverted.
240     * Note: the contract address is always the message sender.
241     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
242     */
243     function onERC721Received(
244         address /*_from*/,
245         address /*_to*/,
246         uint256 /*_tokenId*/,
247         bytes memory /*_data*/
248     )
249         public
250         view
251         returns (bytes4)
252     {
253         require(msg.sender == estateRegistry, "Token not accepted");
254         return ERC721_Received;
255     }
256 }
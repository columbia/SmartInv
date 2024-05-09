1 // File: contracts\modules\Ownable.sol
2 
3 pragma solidity =0.5.16;
4 
5 /**
6  * @dev Contract module which provides a basic access control mechanism, where
7  * there is an account (an owner) that can be granted exclusive access to
8  * specific functions.
9  *
10  * This module is used through inheritance. It will make available the modifier
11  * `onlyOwner`, which can be applied to your functions to restrict their use to
12  * the owner.
13  */
14 contract Ownable {
15     address internal _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Returns true if the caller is the current owner.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public onlyOwner {
57         emit OwnershipTransferred(_owner, address(0));
58         _owner = address(0);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public onlyOwner {
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Ownable: new owner is the zero address");
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: contracts\modules\Managerable.sol
80 
81 pragma solidity =0.5.16;
82 
83 contract Managerable is Ownable {
84 
85     address private _managerAddress;
86     /**
87      * @dev modifier, Only manager can be granted exclusive access to specific functions. 
88      *
89      */
90     modifier onlyManager() {
91         require(_managerAddress == msg.sender,"Managerable: caller is not the Manager");
92         _;
93     }
94     /**
95      * @dev set manager by owner. 
96      *
97      */
98     function setManager(address managerAddress)
99     public
100     onlyOwner
101     {
102         _managerAddress = managerAddress;
103     }
104     /**
105      * @dev get manager address. 
106      *
107      */
108     function getManager()public view returns (address) {
109         return _managerAddress;
110     }
111 }
112 
113 // File: contracts\modules\Halt.sol
114 
115 pragma solidity =0.5.16;
116 
117 
118 contract Halt is Ownable {
119     
120     bool private halted = false; 
121     
122     modifier notHalted() {
123         require(!halted,"This contract is halted");
124         _;
125     }
126 
127     modifier isHalted() {
128         require(halted,"This contract is not halted");
129         _;
130     }
131     
132     /// @notice function Emergency situation that requires 
133     /// @notice contribution period to stop or not.
134     function setHalt(bool halt) 
135         public 
136         onlyOwner
137     {
138         halted = halt;
139     }
140 }
141 
142 // File: contracts\TokenConverter\TokenConverterData.sol
143 
144 pragma solidity =0.5.16;
145 
146 
147 
148 contract TokenConverterData is Managerable,Halt {
149     //the locjed reward info
150     struct lockedReward {
151         uint256 startTime; //this tx startTime for locking
152         uint256 total;     //record input amount in each lock tx    
153         mapping (uint256 => uint256) alloc;//the allocation table
154     }
155     
156     struct lockedIdx {
157         uint256 beginIdx;//the first index for user converting input claimable tx index 
158         uint256 totalIdx;//the total number for converting tx
159     }
160     
161     address public cfnxAddress; //cfnx token address
162     address public fnxAddress;  //fnx token address
163     uint256 public timeSpan = 30*24*3600;//time interval span time ,default one month
164     uint256 public dispatchTimes = 6;    //allocation times,default 6 times
165     uint256 public txNum = 100; //100 times transfer tx 
166     uint256 public lockPeriod = dispatchTimes*timeSpan;
167     
168     //the user's locked total balance
169     mapping (address => uint256) public lockedBalances;//locked balance for each user
170     
171     mapping (address =>  mapping (uint256 => lockedReward)) public lockedAllRewards;//converting tx record for each user
172     
173     mapping (address => lockedIdx) public lockedIndexs;//the converting tx index info
174     
175     
176     /**
177      * @dev Emitted when `owner` locked  `amount` FPT, which net worth is  `worth` in USD. 
178      */
179     event InputCfnx(address indexed owner, uint256 indexed amount,uint256 indexed worth);
180     /**
181      * @dev Emitted when `owner` burned locked  `amount` FPT, which net worth is  `worth` in USD.
182      */
183     event ClaimFnx(address indexed owner, uint256 indexed amount,uint256 indexed worth);
184 
185 }
186 
187 // File: contracts\Proxy\baseProxy.sol
188 
189 pragma solidity =0.5.16;
190 
191 /**
192  * @title  baseProxy Contract
193 
194  */
195 contract baseProxy is Ownable {
196     address public implementation;
197     constructor(address implementation_) public {
198         // Creator of the contract is admin during initialization
199         implementation = implementation_; 
200         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("initialize()"));
201         require(success);
202     }
203     function getImplementation()public view returns(address){
204         return implementation;
205     }
206     function setImplementation(address implementation_)public onlyOwner{
207         implementation = implementation_; 
208         (bool success,) = implementation_.delegatecall(abi.encodeWithSignature("update()"));
209         require(success);
210     }
211 
212     /**
213      * @notice Delegates execution to the implementation contract
214      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
215      * @param data The raw data to delegatecall
216      * @return The returned bytes from the delegatecall
217      */
218     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
219         (bool success, bytes memory returnData) = implementation.delegatecall(data);
220         assembly {
221             if eq(success, 0) {
222                 revert(add(returnData, 0x20), returndatasize)
223             }
224         }
225         return returnData;
226     }
227 
228     /**
229      * @notice Delegates execution to an implementation contract
230      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
231      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
232      * @param data The raw data to delegatecall
233      * @return The returned bytes from the delegatecall
234      */
235     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
236         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
237         assembly {
238             if eq(success, 0) {
239                 revert(add(returnData, 0x20), returndatasize)
240             }
241         }
242         return abi.decode(returnData, (bytes));
243     }
244 
245     function delegateToViewAndReturn() internal view returns (bytes memory) {
246         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
247 
248         assembly {
249             let free_mem_ptr := mload(0x40)
250             returndatacopy(free_mem_ptr, 0, returndatasize)
251 
252             switch success
253             case 0 { revert(free_mem_ptr, returndatasize) }
254             default { return(add(free_mem_ptr, 0x40), returndatasize) }
255         }
256     }
257 
258     function delegateAndReturn() internal returns (bytes memory) {
259         (bool success, ) = implementation.delegatecall(msg.data);
260 
261         assembly {
262             let free_mem_ptr := mload(0x40)
263             returndatacopy(free_mem_ptr, 0, returndatasize)
264 
265             switch success
266             case 0 { revert(free_mem_ptr, returndatasize) }
267             default { return(free_mem_ptr, returndatasize) }
268         }
269     }
270 }
271 
272 // File: contracts\TokenConverter\TokenConverterProxy.sol
273 
274 pragma solidity =0.5.16;
275 
276 
277 
278 contract TokenConverterProxy is TokenConverterData,baseProxy {
279     
280     constructor (address implementation_) baseProxy(implementation_) public{
281     }
282     
283     function getbackLeftFnx(address /*reciever*/)  public {
284         delegateAndReturn();
285     }
286     
287    function setParameter(address /*_cfnxAddress*/,address /*_fnxAddress*/,uint256 /*_timeSpan*/,uint256 /*_dispatchTimes*/,uint256 /*_txNum*/) public  {
288         delegateAndReturn();
289    }
290    
291    function lockedBalanceOf(address /*account*/) public view returns (uint256){
292          delegateToViewAndReturn();     
293    }
294    
295    
296    function inputCfnxForInstallmentPay(uint256 /*amount*/) public {
297          delegateAndReturn();     
298    }
299    
300    function claimFnxExpiredReward() public {
301         delegateAndReturn(); 
302    }
303    
304    function getClaimAbleBalance(address ) public view returns (uint256) {
305         delegateToViewAndReturn();     
306    }
307     
308 }
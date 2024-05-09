1 pragma solidity 0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
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
67 // File: openzeppelin-solidity/contracts/ownership/Claimable.sol
68 
69 /**
70  * @title Claimable
71  * @dev Extension for the Ownable contract, where the ownership needs to be claimed.
72  * This allows the new owner to accept the transfer.
73  */
74 contract Claimable is Ownable {
75   address public pendingOwner;
76 
77   /**
78    * @dev Modifier throws if called by any account other than the pendingOwner.
79    */
80   modifier onlyPendingOwner() {
81     require(msg.sender == pendingOwner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to set the pendingOwner address.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) public onlyOwner {
90     pendingOwner = newOwner;
91   }
92 
93   /**
94    * @dev Allows the pendingOwner address to finalize the transfer.
95    */
96   function claimOwnership() public onlyPendingOwner {
97     emit OwnershipTransferred(owner, pendingOwner);
98     owner = pendingOwner;
99     pendingOwner = address(0);
100   }
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
104 
105 /**
106  * @title ERC20Basic
107  * @dev Simpler version of ERC20 interface
108  * See https://github.com/ethereum/EIPs/issues/179
109  */
110 contract ERC20Basic {
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address _who) public view returns (uint256);
113   function transfer(address _to, uint256 _value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address _owner, address _spender)
125     public view returns (uint256);
126 
127   function transferFrom(address _from, address _to, uint256 _value)
128     public returns (bool);
129 
130   function approve(address _spender, uint256 _value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
139 
140 /**
141  * @title SafeERC20
142  * @dev Wrappers around ERC20 operations that throw on failure.
143  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
144  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
145  */
146 library SafeERC20 {
147   function safeTransfer(
148     ERC20Basic _token,
149     address _to,
150     uint256 _value
151   )
152     internal
153   {
154     require(_token.transfer(_to, _value));
155   }
156 
157   function safeTransferFrom(
158     ERC20 _token,
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     internal
164   {
165     require(_token.transferFrom(_from, _to, _value));
166   }
167 
168   function safeApprove(
169     ERC20 _token,
170     address _spender,
171     uint256 _value
172   )
173     internal
174   {
175     require(_token.approve(_spender, _value));
176   }
177 }
178 
179 // File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol
180 
181 /**
182  * @title Contracts that should be able to recover tokens
183  * @author SylTi
184  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
185  * This will prevent any accidental loss of tokens.
186  */
187 contract CanReclaimToken is Ownable {
188   using SafeERC20 for ERC20Basic;
189 
190   /**
191    * @dev Reclaim all ERC20Basic compatible tokens
192    * @param _token ERC20Basic The address of the token contract
193    */
194   function reclaimToken(ERC20Basic _token) external onlyOwner {
195     uint256 balance = _token.balanceOf(this);
196     _token.safeTransfer(owner, balance);
197   }
198 
199 }
200 
201 // File: contracts/utils/OwnableContract.sol
202 
203 // empty block is used as this contract just inherits others.
204 contract OwnableContract is CanReclaimToken, Claimable { } /* solhint-disable-line no-empty-blocks */
205 
206 // File: contracts/utils/IndexedMapping.sol
207 
208 library IndexedMapping {
209 
210     struct Data {
211         mapping(address=>bool) valueExists;
212         mapping(address=>uint) valueIndex;
213         address[] valueList;
214     }
215 
216     function add(Data storage self, address val) internal returns (bool) {
217         if (exists(self, val)) return false;
218 
219         self.valueExists[val] = true;
220         self.valueIndex[val] = self.valueList.push(val) - 1;
221         return true;
222     }
223 
224     function remove(Data storage self, address val) internal returns (bool) {
225         uint index;
226         address lastVal;
227 
228         if (!exists(self, val)) return false;
229 
230         index = self.valueIndex[val];
231         lastVal = self.valueList[self.valueList.length - 1];
232 
233         // replace value with last value
234         self.valueList[index] = lastVal;
235         self.valueIndex[lastVal] = index;
236         self.valueList.length--;
237 
238         // remove value
239         delete self.valueExists[val];
240         delete self.valueIndex[val];
241 
242         return true;
243     }
244 
245     function exists(Data storage self, address val) internal view returns (bool) {
246         return self.valueExists[val];
247     }
248 
249     function getValue(Data storage self, uint index) internal view returns (address) {
250         return self.valueList[index];
251     }
252 
253     function getValueList(Data storage self) internal view returns (address[]) {
254         return self.valueList;
255     }
256 }
257 
258 // File: contracts/factory/MembersInterface.sol
259 
260 interface MembersInterface {
261     function setCustodian(address _custodian) external returns (bool);
262     function addMerchant(address merchant) external returns (bool);
263     function removeMerchant(address merchant) external returns (bool);
264     function isCustodian(address addr) external view returns (bool);
265     function isMerchant(address addr) external view returns (bool);
266 }
267 
268 // File: contracts/factory/Members.sol
269 
270 contract Members is MembersInterface, OwnableContract {
271 
272     address public custodian;
273 
274     using IndexedMapping for IndexedMapping.Data;
275     IndexedMapping.Data internal merchants;
276 
277     constructor(address _owner) public {
278         require(_owner != address(0), "invalid _owner address");
279         owner = _owner;
280     }
281 
282     event CustodianSet(address indexed custodian);
283 
284     function setCustodian(address _custodian) external onlyOwner returns (bool) {
285         require(_custodian != address(0), "invalid custodian address");
286         custodian = _custodian;
287 
288         emit CustodianSet(_custodian);
289         return true;
290     }
291 
292     event MerchantAdd(address indexed merchant);
293 
294     function addMerchant(address merchant) external onlyOwner returns (bool) {
295         require(merchant != address(0), "invalid merchant address");
296         require(merchants.add(merchant), "merchant add failed");
297 
298         emit MerchantAdd(merchant);
299         return true;
300     } 
301 
302     event MerchantRemove(address indexed merchant);
303 
304     function removeMerchant(address merchant) external onlyOwner returns (bool) {
305         require(merchant != address(0), "invalid merchant address");
306         require(merchants.remove(merchant), "merchant remove failed");
307 
308         emit MerchantRemove(merchant);
309         return true;
310     }
311 
312     function isCustodian(address addr) external view returns (bool) {
313         return (addr == custodian);
314     }
315 
316     function isMerchant(address addr) external view returns (bool) {
317         return merchants.exists(addr);
318     }
319 
320     function getMerchant(uint index) external view returns (address) {
321         return merchants.getValue(index);
322     }
323 
324     function getMerchants() external view returns (address[]) {
325         return merchants.getValueList();
326     }
327 }
1 /*
2          M                                                 M
3        M   M                                             M   M
4       M  M  M                                           M  M  M
5      M  M  M  M                                       M  M  M  M
6     M  M  M  M  M                                    M  M  M  M  M
7    M  M M  M  M  M                                 M  M  M  M  M  M
8    M  M   M  M  M  M                              M  M     M  M  M  M
9    M  M     M  M  M  M                           M  M      M  M   M  M
10    M  M       M  M  M  M                        M  M       M  M   M  M       
11    M  M         M  M  M  M                     M  M        M  M   M  M
12    M  M           M  M  M  M                  M  M         M  M   M  M
13    M  M             M  M  M  M               M  M          M  M   M  M   M  M  M  M  M  M  M
14    M  M               M  M  M  M            M  M        M  M  M   M  M   M  M  M  M  M  M  M
15    M  M                 M  M  M  M         M  M      M  M  M  M   M  M                  M  M
16    M  M                   M  M  M  M      M  M    M  M  M  M  M   M  M                     M
17    M  M                     M  M  M  M   M  M  M  M  M  M  M  M   M  M
18    M  M                       M  M  M  M  M   M  M  M  M   M  M   M  M
19    M  M                         M  M  M  M   M  M  M  M    M  M   M  M
20    M  M                           M  M  M   M  M  M  M     M  M   M  M
21    M  M                             M  M   M  M  M  M      M  M   M  M
22 M  M  M  M  M  M                         M   M  M  M  M   M  M  M  M  M  M  M  
23                                           M  M  M  M
24                                           M  M  M  M
25                                           M  M  M  M
26                                            M  M  M  M                        M  M  M  M  M  M
27                                             M  M  M  M                          M  M  M  M
28                                              M  M  M  M                         M  M  M  M
29                                                M  M  M  M                       M  M  M  M
30                                                  M  M  M  M                     M  M  M  M
31                                                    M  M  M  M                   M  M  M  M
32                                                       M  M  M  M                M  M  M  M
33                                                          M  M  M  M             M  M  M  M
34                                                              M  M  M  M   M  M  M  M  M  M
35                                                                  M  M  M  M  M  M  M  M  M
36                                                                                                                                                     
37 */
38  
39 // based off of the beautiful work done by Erick Calderon with the smart contracts for Artblocks.
40  
41 pragma solidity ^0.5.0;
42 /**
43 * @dev Wrappers over Solidity's arithmetic operations with added overflow
44 * checks.
45 *
46 * Arithmetic operations in Solidity wrap on overflow. This can easily result
47 * in bugs, because programmers usually assume that an overflow raises an
48 * error, which is the standard behavior in high level programming languages.
49 * `SafeMath` restores this intuition by reverting the transaction when an
50 * operation overflows.
51 *
52 * Using this library instead of the unchecked operations eliminates an entire
53 * class of bugs, so it's recommended to use it always.
54 */
55 library SafeMath {
56   /**
57    * @dev Returns the addition of two unsigned integers, reverting on
58    * overflow.
59    *
60    * Counterpart to Solidity's `+` operator.
61    *
62    * Requirements:
63    * - Addition cannot overflow.
64    */
65   function add(uint256 a, uint256 b) internal pure returns (uint256) {
66       uint256 c = a + b;
67       require(c >= a, "SafeMath: addition overflow");
68       return c;
69   }
70   /**
71    * @dev Returns the subtraction of two unsigned integers, reverting on
72    * overflow (when the result is negative).
73    *
74    * Counterpart to Solidity's `-` operator.
75    *
76    * Requirements:
77    * - Subtraction cannot overflow.
78    */
79   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80       require(b <= a, "SafeMath: subtraction overflow");
81       uint256 c = a - b;
82       return c;
83   }
84   /**
85    * @dev Returns the multiplication of two unsigned integers, reverting on
86    * overflow.
87    *
88    * Counterpart to Solidity's `*` operator.
89    *
90    * Requirements:
91    * - Multiplication cannot overflow.
92    */
93   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95       // benefit is lost if 'b' is also tested.
96       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
97       if (a == 0) {
98           return 0;
99       }
100       uint256 c = a * b;
101       require(c / a == b, "SafeMath: multiplication overflow");
102       return c;
103   }
104   /**
105    * @dev Returns the integer division of two unsigned integers. Reverts on
106    * division by zero. The result is rounded towards zero.
107    *
108    * Counterpart to Solidity's `/` operator. Note: this function uses a
109    * `revert` opcode (which leaves remaining gas untouched) while Solidity
110    * uses an invalid opcode to revert (consuming all remaining gas).
111    *
112    * Requirements:
113    * - The divisor cannot be zero.
114    */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116       // Solidity only automatically asserts when dividing by 0
117       require(b > 0, "SafeMath: division by zero");
118       uint256 c = a / b;
119       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120       return c;
121   }
122 }
123 // File contracts/libs/Strings.sol
124 // File: contracts/Strings.sol
125 pragma solidity ^0.5.0;
126 //https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
127 library Strings {
128   function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
129       return strConcat(_a, _b, "", "", "");
130   }
131   function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
132       return strConcat(_a, _b, _c, "", "");
133   }
134   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
135       return strConcat(_a, _b, _c, _d, "");
136   }
137   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
138       bytes memory _ba = bytes(_a);
139       bytes memory _bb = bytes(_b);
140       bytes memory _bc = bytes(_c);
141       bytes memory _bd = bytes(_d);
142       bytes memory _be = bytes(_e);
143       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
144       bytes memory babcde = bytes(abcde);
145       uint k = 0;
146       uint i = 0;
147       for (i = 0; i < _ba.length; i++) {
148           babcde[k++] = _ba[i];
149       }
150       for (i = 0; i < _bb.length; i++) {
151           babcde[k++] = _bb[i];
152       }
153       for (i = 0; i < _bc.length; i++) {
154           babcde[k++] = _bc[i];
155       }
156       for (i = 0; i < _bd.length; i++) {
157           babcde[k++] = _bd[i];
158       }
159       for (i = 0; i < _be.length; i++) {
160           babcde[k++] = _be[i];
161       }
162       return string(babcde);
163   }
164   function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
165       if (_i == 0) {
166           return "0";
167       }
168       uint j = _i;
169       uint len;
170       while (j != 0) {
171           len++;
172           j /= 10;
173       }
174       bytes memory bstr = new bytes(len);
175       uint k = len - 1;
176       while (_i != 0) {
177           bstr[k--] = byte(uint8(48 + _i % 10));
178           _i /= 10;
179       }
180       return string(bstr);
181   }
182 }
183 pragma solidity ^0.5.0;
184 interface GenArt721CoreContract {
185 function projectIdToCurrencySymbol(uint256 _projectId) external view returns (string memory);
186 function projectIdToCurrencyAddress(uint256 _projectId) external view returns (address);
187 function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
188 function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
189 function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
190 function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
191 function mirageAddress() external view returns (address payable);
192 function miragePercentage() external view returns (uint256);
193 function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
194 function earlyMint(address _to, uint256 _projectId, address _by) external returns (uint256 _tokenId);
195 function balanceOf(address owner) external view returns (uint256);
196 }
197 interface ERC20 {
198 function balanceOf(address _owner) external view returns (uint balance);
199 function transferFrom(address _from, address _to, uint _value) external returns (bool success);
200 function allowance(address _owner, address _spender) external view returns (uint remaining);
201 }
202 interface mirageContracts {
203 function balanceOf(address owner, uint256 _id) external view returns (uint256);
204 }
205 contract mirageMinter {
206 using SafeMath for uint256;
207 GenArt721CoreContract public mirageContract;
208 mirageContracts public membershipContract;
209 constructor(address _mirageAddress, address _membershipAddress) public {
210   mirageContract = GenArt721CoreContract(_mirageAddress);
211   membershipContract = mirageContracts(_membershipAddress);
212 }
213 function getYourBalanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
214   uint256 balance = ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender);
215   return balance;
216 }
217 function checkYourAllowanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
218   uint256 remaining = ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this));
219   return remaining;
220 }
221  
222 function purchase(uint256 _projectId, uint256 numberOfTokens) public payable {
223     require(numberOfTokens <= 10, "Can only mint 10 per transaction");
224   if (keccak256(abi.encodePacked(mirageContract.projectIdToCurrencySymbol(_projectId))) != keccak256(abi.encodePacked("ETH"))){
225     require(msg.value==0, "this project accepts a different currency and cannot accept ETH, or this project does not exist");
226     require(ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this)) >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient Funds Approved for TX");
227     require(ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender) >= mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens), "Insufficient balance.");
228     _splitFundsERC20(_projectId, numberOfTokens);
229   } else {
230     require(msg.value>=mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens), "Must send minimum value to mint!");
231     _splitFundsETH(_projectId, numberOfTokens);
232   }
233   for(uint i = 0; i < numberOfTokens; i++) {
234     mirageContract.mint(msg.sender, _projectId, msg.sender);  
235   }
236 }
237 
238  function earlyPurchase(uint256 _projectId, uint256 _membershipId, uint256 numberOfTokens) public payable {
239    require(membershipContract.balanceOf(msg.sender,_membershipId) > 0, "No membership tokens in this wallet");
240    require(numberOfTokens <= 3, "Can only mint 3 per transaction for presale minting");
241   if (keccak256(abi.encodePacked(mirageContract.projectIdToCurrencySymbol(_projectId))) != keccak256(abi.encodePacked("ETH"))){
242     require(msg.value==0, "this project accepts a different currency and cannot accept ETH, or this project does not exist");
243     require(ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this)) >= mirageContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient Funds Approved for TX");
244     require(ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender) >= mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens), "Insufficient balance.");
245     _splitFundsERC20(_projectId, numberOfTokens);
246   } else {
247     require(msg.value>=mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens), "Must send minimum value to mint!");
248   
249     _splitFundsETH(_projectId, numberOfTokens);
250   }
251   for(uint i = 0; i < numberOfTokens; i++) {
252     mirageContract.earlyMint(msg.sender, _projectId, msg.sender);
253   }
254 }
255 function _splitFundsETH(uint256 _projectId, uint256 numberOfTokens) internal {
256   if (msg.value > 0) {
257     uint256 mintCost = mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens);
258     uint256 refund = msg.value.sub(mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens));
259     if (refund > 0) {
260       msg.sender.transfer(refund);
261     }
262     uint256 foundationAmount = mintCost.div(100).mul(mirageContract.miragePercentage());
263     if (foundationAmount > 0) {
264       mirageContract.mirageAddress().transfer(foundationAmount);
265     }
266     uint256 projectFunds = mintCost.sub(foundationAmount);
267     uint256 additionalPayeeAmount;
268     if (mirageContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
269       additionalPayeeAmount = projectFunds.div(100).mul(mirageContract.projectIdToAdditionalPayeePercentage(_projectId));
270       if (additionalPayeeAmount > 0) {
271         mirageContract.projectIdToAdditionalPayee(_projectId).transfer(additionalPayeeAmount);
272       }
273     }
274     uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
275     if (creatorFunds > 0) {
276       mirageContract.projectIdToArtistAddress(_projectId).transfer(creatorFunds);
277     }
278   }
279 }
280 function _splitFundsERC20(uint256 _projectId, uint256 numberOfTokens) internal {
281   uint256 mintCost = mirageContract.projectIdToPricePerTokenInWei(_projectId).mul(numberOfTokens);
282   uint256 foundationAmount = mintCost.div(100).mul(mirageContract.miragePercentage());
283   if (foundationAmount > 0) {
284     ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, mirageContract.mirageAddress(), foundationAmount);
285   }
286   uint256 projectFunds = mintCost.sub(foundationAmount);
287   uint256 additionalPayeeAmount;
288   if (mirageContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
289     additionalPayeeAmount = projectFunds.div(100).mul(mirageContract.projectIdToAdditionalPayeePercentage(_projectId));
290     if (additionalPayeeAmount > 0) {
291       ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, mirageContract.projectIdToAdditionalPayee(_projectId), additionalPayeeAmount);
292     }
293   }
294   uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
295   if (creatorFunds > 0) {
296     ERC20(mirageContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, mirageContract.projectIdToArtistAddress(_projectId), creatorFunds);
297   }
298 }
299 }
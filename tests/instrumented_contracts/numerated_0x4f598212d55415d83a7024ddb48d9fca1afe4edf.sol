1 // File: contracts/Strings.sol
2 
3 pragma solidity ^0.5.0;
4 
5 //https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
6 library Strings {
7 
8     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
9         return strConcat(_a, _b, "", "", "");
10     }
11 
12     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
13         return strConcat(_a, _b, _c, "", "");
14     }
15 
16     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
17         return strConcat(_a, _b, _c, _d, "");
18     }
19 
20     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
21         bytes memory _ba = bytes(_a);
22         bytes memory _bb = bytes(_b);
23         bytes memory _bc = bytes(_c);
24         bytes memory _bd = bytes(_d);
25         bytes memory _be = bytes(_e);
26         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
27         bytes memory babcde = bytes(abcde);
28         uint k = 0;
29         uint i = 0;
30         for (i = 0; i < _ba.length; i++) {
31             babcde[k++] = _ba[i];
32         }
33         for (i = 0; i < _bb.length; i++) {
34             babcde[k++] = _bb[i];
35         }
36         for (i = 0; i < _bc.length; i++) {
37             babcde[k++] = _bc[i];
38         }
39         for (i = 0; i < _bd.length; i++) {
40             babcde[k++] = _bd[i];
41         }
42         for (i = 0; i < _be.length; i++) {
43             babcde[k++] = _be[i];
44         }
45         return string(babcde);
46     }
47 
48     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
49         if (_i == 0) {
50             return "0";
51         }
52         uint j = _i;
53         uint len;
54         while (j != 0) {
55             len++;
56             j /= 10;
57         }
58         bytes memory bstr = new bytes(len);
59         uint k = len - 1;
60         while (_i != 0) {
61             bstr[k--] = byte(uint8(48 + _i % 10));
62             _i /= 10;
63         }
64         return string(bstr);
65     }
66 }
67 
68 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
69 
70 /**
71  * @dev Wrappers over Solidity's arithmetic operations with added overflow
72  * checks.
73  *
74  * Arithmetic operations in Solidity wrap on overflow. This can easily result
75  * in bugs, because programmers usually assume that an overflow raises an
76  * error, which is the standard behavior in high level programming languages.
77  * `SafeMath` restores this intuition by reverting the transaction when an
78  * operation overflows.
79  *
80  * Using this library instead of the unchecked operations eliminates an entire
81  * class of bugs, so it's recommended to use it always.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b <= a, "SafeMath: subtraction overflow");
111         uint256 c = a - b;
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
127         // benefit is lost if 'b' is also tested.
128         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
129         if (a == 0) {
130             return 0;
131         }
132 
133         uint256 c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the integer division of two unsigned integers. Reverts on
141      * division by zero. The result is rounded towards zero.
142      *
143      * Counterpart to Solidity's `/` operator. Note: this function uses a
144      * `revert` opcode (which leaves remaining gas untouched) while Solidity
145      * uses an invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function div(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Solidity only automatically asserts when dividing by 0
152         require(b > 0, "SafeMath: division by zero");
153         uint256 c = a / b;
154         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
155 
156         return c;
157     }
158 }
159 
160 interface GenArt721CoreV2 {
161   function isWhitelisted(address sender) external view returns (bool);
162   function projectIdToCurrencySymbol(uint256 _projectId) external view returns (string memory);
163   function projectIdToCurrencyAddress(uint256 _projectId) external view returns (address);
164   function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
165   function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
166   function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
167   function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
168   function projectTokenInfo(uint256 _projectId) external view returns (address, uint256, uint256, uint256, bool, address, uint256, string memory, address);
169   function renderProviderAddress() external view returns (address payable);
170   function renderProviderPercentage() external view returns (uint256);
171   function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
172 }
173 
174 interface ERC20 {
175   function balanceOf(address _owner) external view returns (uint balance);
176   function transferFrom(address _from, address _to, uint _value) external returns (bool success);
177   function allowance(address _owner, address _spender) external view returns (uint remaining);
178 }
179 
180 interface BonusContract {
181   function triggerBonus(address _to) external returns (bool);
182   function bonusIsActive() external view returns (bool);
183 }
184 
185 contract GenArt721Minter_DoodleLabs {
186   using SafeMath for uint256;
187 
188   GenArt721CoreV2 public genArtCoreContract;
189 
190   uint256 constant ONE_MILLION = 1_000_000;
191 
192   address payable public ownerAddress;
193   uint256 public ownerPercentage;
194 
195   mapping(uint256 => bool) public projectIdToBonus;
196   mapping(uint256 => address) public projectIdToBonusContractAddress;
197   mapping(uint256 => bool) public contractFilterProject;
198   mapping(address => mapping (uint256 => uint256)) public projectMintCounter;
199   mapping(uint256 => uint256) public projectMintLimit;
200   mapping(uint256 => bool) public projectMaxHasBeenInvoked;
201   mapping(uint256 => uint256) public projectMaxInvocations;
202 
203   constructor(address _genArt721Address) public {
204     genArtCoreContract=GenArt721CoreV2(_genArt721Address);
205   }
206 
207   function getYourBalanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
208     uint256 balance = ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender);
209     return balance;
210   }
211 
212   function checkYourAllowanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
213     uint256 remaining = ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this));
214     return remaining;
215   }
216 
217   function setProjectMintLimit(uint256 _projectId,uint8 _limit) public {
218     require(genArtCoreContract.isWhitelisted(msg.sender), "can only be set by admin");
219     projectMintLimit[_projectId] = _limit;
220   }
221 
222   function setProjectMaxInvocations(uint256 _projectId) public {
223     require(genArtCoreContract.isWhitelisted(msg.sender), "can only be set by admin");
224     uint256 maxInvocations;
225     uint256 invocations;
226     ( , , invocations, maxInvocations, , , , , ) = genArtCoreContract.projectTokenInfo(_projectId);
227     projectMaxInvocations[_projectId] = maxInvocations;
228     if (invocations < maxInvocations) {
229         projectMaxHasBeenInvoked[_projectId] = false;
230     }
231   }
232 
233   function setOwnerAddress(address payable _ownerAddress) public {
234     require(genArtCoreContract.isWhitelisted(msg.sender), "can only be set by admin");
235     ownerAddress = _ownerAddress;
236   }
237 
238   function setOwnerPercentage(uint256 _ownerPercentage) public {
239     require(genArtCoreContract.isWhitelisted(msg.sender), "can only be set by admin");
240     ownerPercentage = _ownerPercentage;
241   }
242 
243   function toggleContractFilter(uint256 _projectId) public {
244     require(genArtCoreContract.isWhitelisted(msg.sender), "can only be set by admin");
245     contractFilterProject[_projectId]=!contractFilterProject[_projectId];
246   }
247 
248   function artistToggleBonus(uint256 _projectId) public {
249     require(msg.sender==genArtCoreContract.projectIdToArtistAddress(_projectId), "can only be set by artist");
250     projectIdToBonus[_projectId]=!projectIdToBonus[_projectId];
251   }
252 
253   function artistSetBonusContractAddress(uint256 _projectId, address _bonusContractAddress) public {
254     require(msg.sender==genArtCoreContract.projectIdToArtistAddress(_projectId), "can only be set by artist");
255     projectIdToBonusContractAddress[_projectId]=_bonusContractAddress;
256   }
257 
258   function purchase(uint256 _projectId) public payable returns (uint256 _tokenId) {
259     return purchaseTo(msg.sender, _projectId);
260   }
261 
262   // Remove `public`` and `payable`` to prevent public use
263   // of the `purchaseTo`` function.
264   function purchaseTo(address _to, uint256 _projectId) public payable returns(uint256 _tokenId){
265     require(!projectMaxHasBeenInvoked[_projectId], "Maximum number of invocations reached");
266     if (keccak256(abi.encodePacked(genArtCoreContract.projectIdToCurrencySymbol(_projectId))) != keccak256(abi.encodePacked("ETH"))){
267       require(msg.value==0, "this project accepts a different currency and cannot accept ETH");
268       require(ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this)) >= genArtCoreContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient Funds Approved for TX");
269       require(ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender) >= genArtCoreContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient balance.");
270       _splitFundsERC20(_projectId);
271     } else {
272       require(msg.value>=genArtCoreContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
273       _splitFundsETH(_projectId);
274     }
275 
276     // if contract filter is active prevent calls from another contract
277     if (contractFilterProject[_projectId]) require(msg.sender == tx.origin, "No Contract Buys");
278 
279     // limit mints per address by project
280     if (projectMintLimit[_projectId] > 0) {
281         require(projectMintCounter[msg.sender][_projectId] < projectMintLimit[_projectId], "Reached minting limit");
282         projectMintCounter[msg.sender][_projectId]++;
283     }
284 
285     uint256 tokenId = genArtCoreContract.mint(_to, _projectId, msg.sender);
286 
287     // What if this overflows, since default value of uint256 is 0?
288     // That is intended, so that by default the minter allows infinite
289     // transactions, allowing the `genArtCoreContract` to stop minting
290     // `uint256 tokenInvocation = tokenId % ONE_MILLION;`
291     if (tokenId % ONE_MILLION == projectMaxInvocations[_projectId]-1){
292         projectMaxHasBeenInvoked[_projectId] = true;
293     }
294 
295     if (projectIdToBonus[_projectId]){
296       require(BonusContract(projectIdToBonusContractAddress[_projectId]).bonusIsActive(), "bonus must be active");
297       BonusContract(projectIdToBonusContractAddress[_projectId]).triggerBonus(msg.sender);
298     }
299 
300     return tokenId;
301   }
302 
303   function _splitFundsETH(uint256 _projectId) internal {
304     if (msg.value > 0) {
305       uint256 pricePerTokenInWei = genArtCoreContract.projectIdToPricePerTokenInWei(_projectId);
306       uint256 refund = msg.value.sub(genArtCoreContract.projectIdToPricePerTokenInWei(_projectId));
307       if (refund > 0) {
308         msg.sender.transfer(refund);
309       }
310       uint256 renderProviderAmount = pricePerTokenInWei.div(100).mul(genArtCoreContract.renderProviderPercentage());
311       if (renderProviderAmount > 0) {
312         genArtCoreContract.renderProviderAddress().transfer(renderProviderAmount);
313       }
314 
315       uint256 remainingFunds = pricePerTokenInWei.sub(renderProviderAmount);
316 
317       uint256 ownerFunds = remainingFunds.div(100).mul(ownerPercentage);
318       if (ownerFunds > 0) {
319         ownerAddress.transfer(ownerFunds);
320       }
321 
322       uint256 projectFunds = pricePerTokenInWei.sub(renderProviderAmount).sub(ownerFunds);
323       uint256 additionalPayeeAmount;
324       if (genArtCoreContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
325         additionalPayeeAmount = projectFunds.div(100).mul(genArtCoreContract.projectIdToAdditionalPayeePercentage(_projectId));
326         if (additionalPayeeAmount > 0) {
327           genArtCoreContract.projectIdToAdditionalPayee(_projectId).transfer(additionalPayeeAmount);
328         }
329       }
330       uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
331       if (creatorFunds > 0) {
332         genArtCoreContract.projectIdToArtistAddress(_projectId).transfer(creatorFunds);
333       }
334     }
335   }
336 
337   function _splitFundsERC20(uint256 _projectId) internal {
338       uint256 pricePerTokenInWei = genArtCoreContract.projectIdToPricePerTokenInWei(_projectId);
339       uint256 renderProviderAmount = pricePerTokenInWei.div(100).mul(genArtCoreContract.renderProviderPercentage());
340       if (renderProviderAmount > 0) {
341         ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, genArtCoreContract.renderProviderAddress(), renderProviderAmount);
342       }
343       uint256 remainingFunds = pricePerTokenInWei.sub(renderProviderAmount);
344 
345       uint256 ownerFunds = remainingFunds.div(100).mul(ownerPercentage);
346       if (ownerFunds > 0) {
347         ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, ownerAddress, ownerFunds);
348       }
349 
350       uint256 projectFunds = pricePerTokenInWei.sub(renderProviderAmount).sub(ownerFunds);
351       uint256 additionalPayeeAmount;
352       if (genArtCoreContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
353         additionalPayeeAmount = projectFunds.div(100).mul(genArtCoreContract.projectIdToAdditionalPayeePercentage(_projectId));
354         if (additionalPayeeAmount > 0) {
355           ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, genArtCoreContract.projectIdToAdditionalPayee(_projectId), additionalPayeeAmount);
356         }
357       }
358       uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
359       if (creatorFunds > 0) {
360         ERC20(genArtCoreContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, genArtCoreContract.projectIdToArtistAddress(_projectId), creatorFunds);
361       }
362     }
363 }
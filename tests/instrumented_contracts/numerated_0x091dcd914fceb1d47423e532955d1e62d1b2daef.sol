1 // File contracts/libs/SafeMath.sol
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, "SafeMath: division by zero");
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 }
96 
97 
98 
99 // File contracts/libs/Strings.sol
100 
101 // File: contracts/Strings.sol
102 
103 pragma solidity ^0.5.0;
104 
105 //https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
106 library Strings {
107 
108     function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
109         return strConcat(_a, _b, "", "", "");
110     }
111 
112     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory _concatenatedString) {
113         return strConcat(_a, _b, _c, "", "");
114     }
115 
116     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory _concatenatedString) {
117         return strConcat(_a, _b, _c, _d, "");
118     }
119 
120     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
121         bytes memory _ba = bytes(_a);
122         bytes memory _bb = bytes(_b);
123         bytes memory _bc = bytes(_c);
124         bytes memory _bd = bytes(_d);
125         bytes memory _be = bytes(_e);
126         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
127         bytes memory babcde = bytes(abcde);
128         uint k = 0;
129         uint i = 0;
130         for (i = 0; i < _ba.length; i++) {
131             babcde[k++] = _ba[i];
132         }
133         for (i = 0; i < _bb.length; i++) {
134             babcde[k++] = _bb[i];
135         }
136         for (i = 0; i < _bc.length; i++) {
137             babcde[k++] = _bc[i];
138         }
139         for (i = 0; i < _bd.length; i++) {
140             babcde[k++] = _bd[i];
141         }
142         for (i = 0; i < _be.length; i++) {
143             babcde[k++] = _be[i];
144         }
145         return string(babcde);
146     }
147 
148     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
149         if (_i == 0) {
150             return "0";
151         }
152         uint j = _i;
153         uint len;
154         while (j != 0) {
155             len++;
156             j /= 10;
157         }
158         bytes memory bstr = new bytes(len);
159         uint k = len - 1;
160         while (_i != 0) {
161             bstr[k--] = byte(uint8(48 + _i % 10));
162             _i /= 10;
163         }
164         return string(bstr);
165     }
166 }
167 
168 
169 pragma solidity ^0.5.0;
170 
171 
172 
173 interface GenArt721CoreContract {
174   function projectIdToCurrencySymbol(uint256 _projectId) external view returns (string memory);
175   function projectIdToCurrencyAddress(uint256 _projectId) external view returns (address);
176   function projectIdToArtistAddress(uint256 _projectId) external view returns (address payable);
177   function projectIdToPricePerTokenInWei(uint256 _projectId) external view returns (uint256);
178   function projectIdToAdditionalPayee(uint256 _projectId) external view returns (address payable);
179   function projectIdToAdditionalPayeePercentage(uint256 _projectId) external view returns (uint256);
180   function artblocksAddress() external view returns (address payable);
181   function artblocksPercentage() external view returns (uint256);
182   function mint(address _to, uint256 _projectId, address _by) external returns (uint256 tokenId);
183 }
184 
185 
186 interface ERC20 {
187   function balanceOf(address _owner) external view returns (uint balance);
188   function transferFrom(address _from, address _to, uint _value) external returns (bool success);
189   function allowance(address _owner, address _spender) external view returns (uint remaining);
190 }
191 
192 interface BonusContract {
193   function triggerBonus(address _to) external returns (bool);
194   function bonusIsActive() external view returns (bool);
195 }
196 
197 
198 
199 
200 contract GenArt721Minter {
201   using SafeMath for uint256;
202 
203   GenArt721CoreContract public artblocksContract;
204 
205 
206   mapping(uint256 => bool) public projectIdToBonus;
207   mapping(uint256 => address) public projectIdToBonusContractAddress;
208 
209   constructor(address _genArt721Address) public {
210     artblocksContract=GenArt721CoreContract(_genArt721Address);
211   }
212 
213   function getYourBalanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
214     uint256 balance = ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender);
215     return balance;
216   }
217 
218   function checkYourAllowanceOfProjectERC20(uint256 _projectId) public view returns (uint256){
219     uint256 remaining = ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this));
220     return remaining;
221   }
222 
223   function artistToggleBonus(uint256 _projectId) public {
224     require(msg.sender==artblocksContract.projectIdToArtistAddress(_projectId), "can only be set by artist");
225     projectIdToBonus[_projectId]=!projectIdToBonus[_projectId];
226   }
227 
228   function artistSetBonusContractAddress(uint256 _projectId, address _bonusContractAddress) public {
229     require(msg.sender==artblocksContract.projectIdToArtistAddress(_projectId), "can only be set by artist");
230     projectIdToBonusContractAddress[_projectId]=_bonusContractAddress;
231   }
232 
233   function purchase(uint256 _projectId) public payable returns (uint256 _tokenId) {
234     return purchaseTo(msg.sender, _projectId);
235   }
236 
237   function purchaseTo(address _to, uint256 _projectId) public payable returns(uint256 _tokenId){
238     if (keccak256(abi.encodePacked(artblocksContract.projectIdToCurrencySymbol(_projectId))) != keccak256(abi.encodePacked("ETH"))){
239       require(msg.value==0, "this project accepts a different currency and cannot accept ETH");
240       require(ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).allowance(msg.sender, address(this)) >= artblocksContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient Funds Approved for TX");
241       require(ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).balanceOf(msg.sender) >= artblocksContract.projectIdToPricePerTokenInWei(_projectId), "Insufficient balance.");
242       _splitFundsERC20(_projectId);
243     } else {
244       require(msg.value>=artblocksContract.projectIdToPricePerTokenInWei(_projectId), "Must send minimum value to mint!");
245       _splitFundsETH(_projectId);
246     }
247 
248 
249     uint256 tokenId = artblocksContract.mint(_to, _projectId, msg.sender);
250 
251     if (projectIdToBonus[_projectId]){
252       require(BonusContract(projectIdToBonusContractAddress[_projectId]).bonusIsActive(), "bonus must be active");
253       BonusContract(projectIdToBonusContractAddress[_projectId]).triggerBonus(msg.sender);
254       }
255 
256 
257 
258     return tokenId;
259   }
260 
261   function _splitFundsETH(uint256 _projectId) internal {
262     if (msg.value > 0) {
263       uint256 pricePerTokenInWei = artblocksContract.projectIdToPricePerTokenInWei(_projectId);
264       uint256 refund = msg.value.sub(artblocksContract.projectIdToPricePerTokenInWei(_projectId));
265       if (refund > 0) {
266         msg.sender.transfer(refund);
267       }
268       uint256 foundationAmount = pricePerTokenInWei.div(100).mul(artblocksContract.artblocksPercentage());
269       if (foundationAmount > 0) {
270         artblocksContract.artblocksAddress().transfer(foundationAmount);
271       }
272       uint256 projectFunds = pricePerTokenInWei.sub(foundationAmount);
273       uint256 additionalPayeeAmount;
274       if (artblocksContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
275         additionalPayeeAmount = projectFunds.div(100).mul(artblocksContract.projectIdToAdditionalPayeePercentage(_projectId));
276         if (additionalPayeeAmount > 0) {
277           artblocksContract.projectIdToAdditionalPayee(_projectId).transfer(additionalPayeeAmount);
278         }
279       }
280       uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
281       if (creatorFunds > 0) {
282         artblocksContract.projectIdToArtistAddress(_projectId).transfer(creatorFunds);
283       }
284     }
285   }
286 
287 function _splitFundsERC20(uint256 _projectId) internal {
288     uint256 pricePerTokenInWei = artblocksContract.projectIdToPricePerTokenInWei(_projectId);
289     uint256 foundationAmount = pricePerTokenInWei.div(100).mul(artblocksContract.artblocksPercentage());
290     if (foundationAmount > 0) {
291       ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, artblocksContract.artblocksAddress(), foundationAmount);
292     }
293     uint256 projectFunds = pricePerTokenInWei.sub(foundationAmount);
294     uint256 additionalPayeeAmount;
295     if (artblocksContract.projectIdToAdditionalPayeePercentage(_projectId) > 0) {
296       additionalPayeeAmount = projectFunds.div(100).mul(artblocksContract.projectIdToAdditionalPayeePercentage(_projectId));
297       if (additionalPayeeAmount > 0) {
298         ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, artblocksContract.projectIdToAdditionalPayee(_projectId), additionalPayeeAmount);
299       }
300     }
301     uint256 creatorFunds = projectFunds.sub(additionalPayeeAmount);
302     if (creatorFunds > 0) {
303       ERC20(artblocksContract.projectIdToCurrencyAddress(_projectId)).transferFrom(msg.sender, artblocksContract.projectIdToArtistAddress(_projectId), creatorFunds);
304     }
305   }
306 
307 }
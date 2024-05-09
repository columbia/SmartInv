1 // SPDX-License-Identifier: MIT
2 /**
3  * @title TheAmericanStake
4  * @author DevAmerican
5  * @dev Used for Ethereum projects compatible with OpenSea
6  */
7 
8 pragma solidity ^0.8.4;
9 
10 pragma solidity ^0.8.0;
11 interface IERC20 {
12     function totalSupply() external view returns (uint);
13     function balanceOf(address account) external view returns (uint);
14     function transfer(address recipient, uint amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint);
16     function approve(address spender, uint amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint value);
19     event Approval(address indexed owner, address indexed spender, uint value);
20 }
21 pragma solidity ^0.8.0;
22 interface IERC165 {
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 pragma solidity ^0.8.0;
27 interface IERC721 is IERC165 {
28     function balanceOf(address owner) external view returns (uint256 balance);
29     function ownerOf(uint256 tokenId) external view returns (address owner);
30     function approve(address to, uint256 tokenId) external;
31 }
32 
33 pragma solidity ^0.8.0;
34 interface IERC721Receiver {
35     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
36 }
37 
38 pragma solidity ^0.8.0;
39 library Address {
40     
41     function isContract(address account) internal view returns (bool) {
42 
43         uint256 size;
44         assembly {
45             size := extcodesize(account)
46         }
47         return size > 0;
48     }
49 
50     function sendValue(address payable recipient, uint256 amount) internal {
51         require(address(this).balance >= amount, "Address: insufficient balance");
52 
53         (bool success, ) = recipient.call{value: amount}("");
54         require(success, "Address: unable to send value, recipient may have reverted");
55     }
56 
57     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
58         return functionCall(target, data, "Address: low-level call failed");
59     }
60 
61     function functionCall(
62         address target,
63         bytes memory data,
64         string memory errorMessage
65     ) internal returns (bytes memory) {
66         return functionCallWithValue(target, data, 0, errorMessage);
67     }
68 
69     function functionCallWithValue(
70         address target,
71         bytes memory data,
72         uint256 value
73     ) internal returns (bytes memory) {
74         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
75     }
76 
77     function functionCallWithValue(
78         address target,
79         bytes memory data,
80         uint256 value,
81         string memory errorMessage
82     ) internal returns (bytes memory) {
83         require(address(this).balance >= value, "Address: insufficient balance for call");
84         require(isContract(target), "Address: call to non-contract");
85 
86         (bool success, bytes memory returndata) = target.call{value: value}(data);
87         return verifyCallResult(success, returndata, errorMessage);
88     }
89 
90     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
91         return functionStaticCall(target, data, "Address: low-level static call failed");
92     }
93 
94     function functionStaticCall(
95         address target,
96         bytes memory data,
97         string memory errorMessage
98     ) internal view returns (bytes memory) {
99         require(isContract(target), "Address: static call to non-contract");
100 
101         (bool success, bytes memory returndata) = target.staticcall(data);
102         return verifyCallResult(success, returndata, errorMessage);
103     }
104 
105     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
107     }
108 
109     function functionDelegateCall(
110         address target,
111         bytes memory data,
112         string memory errorMessage
113     ) internal returns (bytes memory) {
114         require(isContract(target), "Address: delegate call to non-contract");
115 
116         (bool success, bytes memory returndata) = target.delegatecall(data);
117         return verifyCallResult(success, returndata, errorMessage);
118     }
119     function verifyCallResult(
120         bool success,
121         bytes memory returndata,
122         string memory errorMessage
123     ) internal pure returns (bytes memory) {
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 assembly {
132                     let returndata_size := mload(returndata)
133                     revert(add(32, returndata), returndata_size)
134                 }
135             } else {
136                 revert(errorMessage);
137             }
138         }
139     }
140 }
141 
142 pragma solidity ^0.8.0;
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 pragma solidity ^0.8.0;
154 abstract contract ERC165 is IERC165 {
155     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
156         return interfaceId == type(IERC165).interfaceId;
157     }
158 }
159 
160 pragma solidity ^0.8.0;
161 abstract contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor() {
170         _setOwner(_msgSender());
171     }
172 
173     /**
174      * @dev Returns the address of the current owner.
175      */
176     function owner() public view virtual returns (address) {
177         return _owner;
178     }
179 
180     /**
181      * @dev Throws if called by any account other than the owner.
182      */
183     modifier onlyOwner() {
184         require(owner() == _msgSender(), "Ownable: caller is not the owner");
185         _;
186     }
187 
188     /**
189      * @dev Leaves the contract without owner. It will not be possible to call
190      * `onlyOwner` functions anymore. Can only be called by the current owner.
191      *
192      * NOTE: Renouncing ownership will leave the contract without an owner,
193      * thereby removing any functionality that is only available to the owner.
194      */
195     function renounceOwnership() public virtual onlyOwner {
196         _setOwner(address(0));
197     }
198 
199     /**
200      * @dev Transfers ownership of the contract to a new account (`newOwner`).
201      * Can only be called by the current owner.
202      */
203     function transferOwnership(address newOwner) public virtual onlyOwner {
204         require(newOwner != address(0), "Ownable: new owner is the zero address");
205         _setOwner(newOwner);
206     }
207 
208     function _setOwner(address newOwner) private {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 pragma solidity ^0.8.4;
216 interface ITheAmericansNFT {
217     function transferFrom(address _from, address _to, uint256 _tokenId) external;
218     function ownerOf(uint256 tokenId) external view returns (address owner);
219 }
220 
221 pragma solidity ^0.8.4;
222 interface ITheAmericansToken {
223     function totalSupply() external view returns (uint);
224     function balanceOf(address account) external view returns (uint);
225     function transfer(address recipient, uint amount) external returns (bool);
226     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
227 }
228 
229 pragma solidity ^0.8.4;
230 contract TheAmericans_Stake is Ownable {
231     uint256 public constant REWARD_RATE = 20;
232     address public constant AMERICANS_ADDRESS = 0x4Ef3D9EaB34783995bc394d569845585aC805Ef8;
233     address public constant AMERICANS_TOKEN = 0x993b8C5a26AC8a9abaBabbf10a0e3c4009b16D73;
234 
235     mapping(uint256 => uint256) internal americanTimeStaked;
236     mapping(uint256 => address) internal americanStaker;
237     mapping(address => uint256[]) internal stakerToAmericans;
238 
239     ITheAmericansNFT private constant _AmericanContract = ITheAmericansNFT(AMERICANS_ADDRESS);
240     ITheAmericansToken private constant _AmericanToken = ITheAmericansToken(AMERICANS_TOKEN);
241 
242     bool public live = true;
243 
244     modifier stakingEnabled {
245         require(live, "NOT_LIVE");
246         _;
247     }
248 
249     function getStakedAmericans(address staker) public view returns (uint256[] memory) {
250         return stakerToAmericans[staker];
251     }
252     
253     function getStakedAmount(address staker) public view returns (uint256) {
254         return stakerToAmericans[staker].length;
255     }
256 
257     function getStaker(uint256 tokenId) public view returns (address) {
258         return americanStaker[tokenId];
259     }
260 
261     function getAllRewards(address staker) public view returns (uint256) {
262         uint256 totalRewards = 0;
263         uint256[] memory americansTokens = stakerToAmericans[staker];
264         for (uint256 i = 0; i < americansTokens.length; i++) {
265             totalRewards += getReward(americansTokens[i]);
266         }
267         return totalRewards;
268     }
269 
270     function stakeAmericanById(uint256[] calldata tokenIds) external stakingEnabled {
271         for (uint256 i = 0; i < tokenIds.length; i++) {
272             uint256 id = tokenIds[i];
273             require(_AmericanContract.ownerOf(id) == msg.sender, "NO_SWEEPING");
274             _AmericanContract.transferFrom(msg.sender, address(this), id);
275             stakerToAmericans[msg.sender].push(id);
276             americanTimeStaked[id] = block.timestamp;
277             americanStaker[id] = msg.sender;
278         }
279     }
280 
281     function unstakeAmericanByIds(uint256[] calldata tokenIds) external {
282         uint256 totalRewards = 0;
283         for (uint256 i = 0; i < tokenIds.length; i++) {
284             uint256 id = tokenIds[i];
285             require(americanStaker[id] == msg.sender, "NEEDS_TO_BE_OWNER");
286             _AmericanContract.transferFrom(address(this), msg.sender, id);
287             totalRewards += getReward(id);
288             removeTokenIdFromArray(stakerToAmericans[msg.sender], id);
289             americanStaker[id] = address(0);
290         }
291         uint256 remaining = _AmericanToken.balanceOf(address(this));
292         uint256 reward = totalRewards > remaining ? remaining : totalRewards;
293         if(reward > 0){
294             _AmericanToken.transfer(msg.sender, reward);
295         }
296     }
297 
298     function unstakeAll() external {
299         require(getStakedAmount(msg.sender) > 0, "NONE_STAKED");
300         uint256 totalRewards = 0;
301         for (uint256 i = stakerToAmericans[msg.sender].length; i > 0; i--) {
302             uint256 id = stakerToAmericans[msg.sender][i - 1];
303             _AmericanContract.transferFrom(address(this), msg.sender, id);
304             totalRewards += getReward(id);
305             stakerToAmericans[msg.sender].pop();
306             americanStaker[id] = address(0);
307         }
308         uint256 remaining = _AmericanToken.balanceOf(address(this));
309         uint256 reward = totalRewards > remaining ? remaining : totalRewards;
310         if(reward > 0){
311             _AmericanToken.transfer(msg.sender, reward);
312         }
313     }
314 
315     function claimAll() external {
316         uint256 totalRewards = 0;
317         uint256[] memory americanTokens = stakerToAmericans[msg.sender];
318         for (uint256 i = 0; i < americanTokens.length; i++) {
319             uint256 id = americanTokens[i];
320             totalRewards += getReward(id);
321             americanTimeStaked[id] = block.timestamp;
322         }
323         uint256 remaining = _AmericanToken.balanceOf(address(this));
324         _AmericanToken.transfer(msg.sender, totalRewards > remaining ? remaining : totalRewards);
325     }
326 
327     function getReward(uint256 tokenId) internal view returns(uint256) {
328         return (block.timestamp - americanTimeStaked[tokenId]) * REWARD_RATE / 86400 * 1 ether;
329     }
330 
331     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
332         uint256 length = array.length;
333         for (uint256 i = 0; i < length; i++) {
334             if (array[i] == tokenId) {
335                 length--;
336                 if (i < length) {
337                     array[i] = array[length];
338                 }
339                 array.pop();
340                 break;
341             }
342         }
343     }
344 
345     function toggle() external onlyOwner {
346         live = !live;
347     }
348 }
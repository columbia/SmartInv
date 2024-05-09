1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; 
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     
23     constructor () {
24         address msgSender = _msgSender();
25         _owner = msgSender;
26         emit OwnershipTransferred(address(0), msgSender);
27     }
28 
29     
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     
35     modifier onlyOwner() {
36         require(owner() == _msgSender(), "Ownable: caller is not the owner");
37         _;
38     }
39 
40     
41     function renounceOwnership() public virtual onlyOwner {
42         emit OwnershipTransferred(_owner, address(0));
43         _owner = address(0);
44     }
45 
46     
47     function transferOwnership(address newOwner) public virtual onlyOwner {
48         require(newOwner != address(0), "Ownable: new owner is the zero address");
49         emit OwnershipTransferred(_owner, newOwner);
50         _owner = newOwner;
51     }
52 }
53 
54 library Address {
55     
56     function isContract(address account) internal view returns (bool) {
57         
58         
59         
60 
61         uint256 size;
62         
63         assembly { size := extcodesize(account) }
64         return size > 0;
65     }
66 
67     
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         
72         (bool success, ) = recipient.call{ value: amount }("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76     
77     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
78       return functionCall(target, data, "Address: low-level call failed");
79     }
80 
81     
82     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
83         return functionCallWithValue(target, data, 0, errorMessage);
84     }
85 
86     
87     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
88         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
89     }
90 
91     
92     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
93         require(address(this).balance >= value, "Address: insufficient balance for call");
94         require(isContract(target), "Address: call to non-contract");
95 
96         
97         (bool success, bytes memory returndata) = target.call{ value: value }(data);
98         return _verifyCallResult(success, returndata, errorMessage);
99     }
100 
101     
102     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
103         return functionStaticCall(target, data, "Address: low-level static call failed");
104     }
105 
106     
107     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
108         require(isContract(target), "Address: static call to non-contract");
109 
110         
111         (bool success, bytes memory returndata) = target.staticcall(data);
112         return _verifyCallResult(success, returndata, errorMessage);
113     }
114 
115     
116     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
117         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
118     }
119 
120     
121     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
122         require(isContract(target), "Address: delegate call to non-contract");
123 
124         
125         (bool success, bytes memory returndata) = target.delegatecall(data);
126         return _verifyCallResult(success, returndata, errorMessage);
127     }
128 
129     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
130         if (success) {
131             return returndata;
132         } else {
133             
134             if (returndata.length > 0) {
135                 
136 
137                 
138                 assembly {
139                     let returndata_size := mload(returndata)
140                     revert(add(32, returndata), returndata_size)
141                 }
142             } else {
143                 revert(errorMessage);
144             }
145         }
146     }
147 }
148 
149 library SafeMath {
150     
151     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             uint256 c = a + b;
154             if (c < a) return (false, 0);
155             return (true, c);
156         }
157     }
158 
159     
160     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         unchecked {
162             if (b > a) return (false, 0);
163             return (true, a - b);
164         }
165     }
166 
167     
168     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
169         unchecked {
170             
171             
172             
173             if (a == 0) return (true, 0);
174             uint256 c = a * b;
175             if (c / a != b) return (false, 0);
176             return (true, c);
177         }
178     }
179 
180     
181     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         unchecked {
183             if (b == 0) return (false, 0);
184             return (true, a / b);
185         }
186     }
187 
188     
189     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
190         unchecked {
191             if (b == 0) return (false, 0);
192             return (true, a % b);
193         }
194     }
195 
196     
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         return a + b;
199     }
200 
201     
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         return a - b;
204     }
205 
206     
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a * b;
209     }
210 
211     
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return a / b;
214     }
215 
216     
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a % b;
219     }
220 
221     
222     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         unchecked {
224             require(b <= a, errorMessage);
225             return a - b;
226         }
227     }
228 
229     
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         unchecked {
232             require(b > 0, errorMessage);
233             return a / b;
234         }
235     }
236 
237     
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         unchecked {
240             require(b > 0, errorMessage);
241             return a % b;
242         }
243     }
244 }
245 
246 interface IERC20 {
247     
248     function totalSupply() external view returns (uint256);
249 
250     
251     function balanceOf(address account) external view returns (uint256);
252 
253     
254     function transfer(address recipient, uint256 amount) external returns (bool);
255 
256     
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     
260     function approve(address spender, uint256 amount) external returns (bool);
261 
262     
263     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
264 
265     
266     event Transfer(address indexed from, address indexed to, uint256 value);
267 
268     
269     event Approval(address indexed owner, address indexed spender, uint256 value);
270 }
271 
272 enum Round {
273   Strategic,
274   Private,
275   Team
276 }
277 
278 struct Investor {
279   uint256 boughtTokens;
280 
281   uint256 initialPercent;
282   uint256 monthlyPercent;
283 
284   bool initialRewardReceived;
285   uint256 monthlyRewardsReceived;
286   uint256 totalPercentReceived;
287   uint256 totalReceived;
288 }
289 
290 contract BRingClaim is Ownable {
291 
292   using SafeMath for uint256;
293 
294   address public TOKEN_CONTRACT_ADDRESS = address(0x3Ecb96039340630c8B82E5A7732bc88b2aeadE82); 
295 
296   uint256 public constant CLAIMING_PERIOD = 30 days;
297 
298   uint256 public STRATEGIC_ROUND_START_TIME;
299   uint256 public PRIVATE_ROUND_START_TIME;
300   uint256 public TEAM_ROUND_START_TIME;
301 
302   mapping(address => Investor)[3] public investors;
303   mapping(address => uint256) public claimedTokens;
304 
305   event NewAddress(address indexed _address, uint256 _boughtTokens, Round indexed _round, uint256 _initialPercent, uint256 _monthlyPercent);
306   event RoundTimeConfigured(Round _round, uint256 _time);
307   event InitialClaimWithdrawn(address indexed _address, Round indexed _round, uint256 _tokensAmount);
308   event MonthlyClaimWithdrawn(address indexed _address, Round indexed _round, uint256 _tokensAmount);
309 
310   constructor() {
311     
312     addAddress(address(0x1958662bF4b23B638cBa463C134D2Cf414027288), 500 ether, Round.Private, 15, 5);
313     addAddress(address(0xa187dC724624877a97F5d02734E9871E2427C3B7), 2000 ether, Round.Private, 15, 5);
314     addAddress(address(0x56373aec74a28117BA5bD85cca8bfCec515453f0), 1000 ether, Round.Private, 15, 5);
315     addAddress(address(0x02fEC1e5e224Da14Dfe29237042D56a96523949E), 1000 ether, Round.Private, 15, 5);
316     addAddress(address(0x98Ff7895075fE2978eCe7580F74f4025E396A732), 1000 ether, Round.Private, 15, 5);
317     addAddress(address(0x5e4B9eE7Bc57D77e13b050e078885651B4D092cc), 800 ether, Round.Private, 15, 5);
318     addAddress(address(0x380351fEfAAabcAFF0aBE9e5609c3f5089B59d52), 325 ether, Round.Private, 15, 5);
319     addAddress(address(0xc557936e8D79aDc6b9dCA2C67D9a7b1A47391d87), 1000 ether, Round.Private, 15, 5);
320     addAddress(address(0x121D26685013baf726e309F5762ecEe520Fcc702), 1000 ether, Round.Private, 15, 5);
321     addAddress(address(0x8cEC27A195145143E0B6e75574e0ebCD0C0D4805), 1000 ether, Round.Private, 15, 5);
322     addAddress(address(0xBba738A1A98a3F2E7312Ca71896416f69F9e7bf2), 1000 ether, Round.Private, 15, 5);
323     addAddress(address(0xA4d3eA01e5205f349aFfa727632d6B8b6FC28Da9), 700 ether, Round.Private, 15, 5);
324     addAddress(address(0xFB3018F1366219eD3fE8CE1B844860F9c4Fac5e7), 250 ether, Round.Private, 15, 5);
325     addAddress(address(0xc7d23FE48F3DAE21b5B91568eDFF2a103b1E2E6A), 1000 ether, Round.Private, 15, 5);
326     addAddress(address(0x0D1f7fd6DcccB4e9C00Fe1c0F869543813F342c0), 2000 ether, Round.Private, 15, 5);
327     addAddress(address(0x7604100fc7d73FB2179dafd86A93a3215502ebae), 2000 ether, Round.Private, 15, 5);
328     addAddress(address(0xF9c229512B62434eB5dE37823C9c899c100B9050), 300 ether, Round.Private, 15, 5);
329     addAddress(address(0x68daaf91EaAA05f56Fb929441E646f4E190C8e9A), 1000 ether, Round.Private, 15, 5);
330     addAddress(address(0xb74B327CC230fDa53E5b0262C2773fced1e8Ab2d), 1000 ether, Round.Private, 15, 5);
331     addAddress(address(0xFf3D84eC5A84A71Db1ada84E66D90395c81d7ba2), 2000 ether, Round.Private, 15, 5);
332     addAddress(address(0xb2AbB01a1896673Bf166830C5dC01fB35c0C9F67), 500 ether, Round.Private, 15, 5);
333     addAddress(address(0x8fBAadd3a7ae19C66EA9f00502626988313ac96c), 1000 ether, Round.Private, 15, 5);
334     addAddress(address(0xFC5374ABf90Bc9217fd88628E4847dD27950B92c), 1000 ether, Round.Private, 15, 5);
335     addAddress(address(0xaADA0f64aA9e3Fa0461eF5efAcD1D879D5e66848), 3000 ether, Round.Private, 15, 5);
336     addAddress(address(0xB15d2ABeC2CDB7d41b30C4537203EF15a509fBB5), 600 ether, Round.Private, 15, 5);
337     addAddress(address(0xa31978A297a8e78E7c8AeF86eEC055786d65804D), 500 ether, Round.Private, 15, 5);
338     addAddress(address(0xAe3E0020b64bc91C373012aa3B01ec4ff85ef581), 1000 ether, Round.Private, 15, 5);
339     addAddress(address(0x691B48454D5E2aCc7bb8aCB4a7a992a983Af2872), 500 ether, Round.Private, 15, 5);
340     addAddress(address(0xd40f0D8f08Eb702Ce5b4Aa039a7B004043433098), 400 ether, Round.Private, 15, 5);
341     addAddress(address(0x202be7E4F66ab72Fe6Cf042938c7A19eA332f112), 300 ether, Round.Private, 15, 5);
342     addAddress(address(0x8084d3FB905F31663153898FE034Dce72B7D2297), 450 ether, Round.Private, 15, 5);
343     addAddress(address(0x3e8204402560493824e5D75fF2333128D7e9F109), 1000 ether, Round.Private, 15, 5);
344     addAddress(address(0x1dC122dB61D53A8E088d63Af743F4D4c713e8A20), 500 ether, Round.Private, 15, 5);
345     addAddress(address(0x0269ACB6DC3f5672A2295e018896Eb75095D790A), 500 ether, Round.Private, 15, 5);
346     addAddress(address(0xDDF33967Ff57A679E3B65f8f70eE393e075Bfa59), 1000 ether, Round.Private, 15, 5);
347     addAddress(address(0x9C5366709CA3889c4E4E27693301B456d5213a13), 500 ether, Round.Private, 15, 5);
348     addAddress(address(0xB234A630062161F8376507e773e23bC4cBa49676), 1000 ether, Round.Private, 15, 5);
349     addAddress(address(0xD1A7Ed463BbeE05a6BFb6e2e8912677214A30d19), 2000 ether, Round.Private, 15, 5);
350     addAddress(address(0x7E2FF036697A7D4614E549B8e6E0AaF123B5F8Bf), 1000 ether, Round.Private, 15, 5);
351     addAddress(address(0xCbB74E8eAbCD36B160D1fC3BEd7bc6E52D327632), 3000 ether, Round.Private, 15, 5);
352     addAddress(address(0xd90dF6D33d457e87949dd5288B923f71F90f38ba), 1000 ether, Round.Private, 15, 5);
353   }
354 
355   function init() external onlyOwner {
356     
357     addAddress(address(0x494E35c0A11dc16a109fc161d785385F874F2359), 1000 ether, Round.Private, 15, 5);
358     addAddress(address(0x9349284Cc71056d28885c18036ea9bCBc2436959), 1000 ether, Round.Private, 15, 5);
359     addAddress(address(0x80182C753895eceB93F78b9df66741A59cda5d0F), 1000 ether, Round.Private, 15, 5);
360     addAddress(address(0x46A659Ad8aEcB89Df20Cf37A96C307299e9A4d74), 1000 ether, Round.Private, 15, 5);
361     addAddress(address(0x646e41e681c94b5dAC8E9dFbd9DDA3BbC1CC6563), 1000 ether, Round.Private, 15, 5);
362     addAddress(address(0x059236F121b5721cfbf3c56e9C49c3A0a7b45AcF), 1000 ether, Round.Private, 15, 5);
363     addAddress(address(0x881e1Fb021469Ac31A00D393BaB2e7b7c0e99CAc), 2000 ether, Round.Private, 15, 5);
364     addAddress(address(0x50b3E08D5c3a2386e0c9585031B1152a5f0E2370), 3000 ether, Round.Private, 15, 5);
365     addAddress(address(0x0B0907E91724A293DF256A0064d931aD9f1F6Ead), 1000 ether, Round.Private, 15, 5);
366     addAddress(address(0x9fb358896C9B2f872be9006E80bBAa810b8E142d), 1000 ether, Round.Private, 15, 5);
367     addAddress(address(0x64ec24675d7bbC80f954FF15EDD57d381f5b3E1a), 1000 ether, Round.Private, 15, 5);
368     addAddress(address(0xe64eF0c08E4F0039faD4B4dDe982541D3Aa30381), 500 ether, Round.Private, 15, 5);
369     addAddress(address(0x50899582199c06d5264edDCD12879E5210783Ba8), 1500 ether, Round.Private, 15, 5);
370     addAddress(address(0xaC6dE9f16c7b9B44C4e5C9073C3a10fA45aB4d5a), 15000 ether, Round.Private, 15, 5);
371     addAddress(address(0x2c8AF617E2f0908bd4F39dC534de13bf31D6c604), 1000 ether, Round.Private, 15, 5);
372     addAddress(address(0x1F89f28490E4F4a544dF6F23782F19b9dC0855dB), 1000 ether, Round.Private, 15, 5);
373     addAddress(address(0xa4daf8feD578EcbF4B0a507a8Ac9C9deB16C5e73), 1500 ether, Round.Private, 15, 5);
374     addAddress(address(0x2a2619e81D61C09aa9206535BAc1B7A5921EA050), 1500 ether, Round.Private, 15, 5);
375     addAddress(address(0xB67e49A45858F3CBf2bC2026A4347B5518279798), 1000 ether, Round.Private, 15, 5);
376     addAddress(address(0x423Ad4906d23DF9fb8a09D383280f9289C1C73dB), 1000 ether, Round.Private, 15, 5);
377     addAddress(address(0x5210474644728370626bf848707c55F1d8159E34), 1000 ether, Round.Private, 15, 5);
378     addAddress(address(0x33a44839BD3544b08a5f315125199cc2Cd64cAc6), 1000 ether, Round.Private, 15, 5);
379     addAddress(address(0xeB3Ed720c708152065d9119E63C3D7e727CFA789), 500 ether, Round.Private, 15, 5);
380     addAddress(address(0xb0dcE0A78E7602Ca791fFd8a6A9Aa86D4375452b), 500 ether, Round.Private, 15, 5);
381     addAddress(address(0x4f70eD6b19cc733D5C45A40250227C0c020Ab3cD), 1000 ether, Round.Private, 15, 5);
382     addAddress(address(0xBa172e6BA2Adf181F18fcb698B77F3f9b5531F45), 500 ether, Round.Private, 15, 5);
383     addAddress(address(0xe92D80a90bc050A12F1c6fBE0e50e1B5A874B595), 2000 ether, Round.Private, 15, 5);
384     addAddress(address(0xd62a38Bd99376013D485214CC968322C20A6cC40), 2500 ether, Round.Private, 15, 5);
385     addAddress(address(0x399b282c17F8ed9F542C2376917947d6B79E2Cc6), 1000 ether, Round.Private, 15, 5);
386     addAddress(address(0xFE932efB9dbB8E563E95CEe05ce106509cF06905), 500 ether, Round.Private, 15, 5);
387     addAddress(address(0x9Fa68bc48398e4c9716226FF410D26C5487E679c), 500 ether, Round.Private, 15, 5);
388     addAddress(address(0x2fb8bd9D8D50acc377E2629d124C7dcD0388ab24), 1500 ether, Round.Private, 15, 5);
389     addAddress(address(0xD16E4384225B313204AdafE41bDb866e710899A6), 500 ether, Round.Private, 15, 5);
390     addAddress(address(0x54D07CFa91F05Fe3B45d8810feF05705117AFe53), 7500 ether, Round.Private, 15, 5);
391     addAddress(address(0x782dB3aE31A7406849C84f9BB0189DEFDd26b4D2), 1000 ether, Round.Private, 15, 5);
392     addAddress(address(0xa44A524DEd85efCD0a671771327b5e75B0Fe6964), 500 ether, Round.Private, 15, 5);
393   }
394 
395   function init2() external onlyOwner {
396     addAddress(address(0x44833Cf54c530525d1b37c38CB342e63bc879857), 10000 ether, Round.Private, 15, 5); 
397     addAddress(address(0xAef18C8794cA00e914E318743732AE4E32c1b614), 100000 ether, Round.Private, 15, 5); 
398     addAddress(address(0xBfe663805129915942980bC86BD832aB031Bb2f9), 40000 ether, Round.Private, 15, 5); 
399     addAddress(address(0xB6b49986253f9234D2526cd5F8e94Ceb4Ae62D25), 20000 ether, Round.Private, 15, 5); 
400     addAddress(address(0xC199f30251e9cef67C6B89a695E99C66F996DEA0), 10000 ether, Round.Private, 15, 5); 
401     addAddress(address(0xd33619B122B27f712AA5F784BC54DE9c95c7588d), 5000 ether, Round.Private, 15, 5); 
402     addAddress(address(0x53F470A909d7CE7f35e62f4470fD440B1eD5D8CD), 25000 ether, Round.Private, 15, 5);
403 
404     
405     addAddress(address(0xCF280dF3da6405EabF27E1d85e2c03d3B9047309), 50000 ether, Round.Strategic, 10, 5); 
406     addAddress(address(0x12e8987C762701d60f0FcfeE687Bb8E4c07555aa), 10000 ether, Round.Strategic, 10, 5); 
407     addAddress(address(0x53F470A909d7CE7f35e62f4470fD440B1eD5D8CD), 50000 ether, Round.Strategic, 10, 5);
408   }
409 
410   function init3() external onlyOwner {
411     addAddress(address(0x13aEEC0Bc33FBb015800c45514C7B58a73c13979), 350 ether, Round.Private, 15, 5);
412     addAddress(address(0x108B3731b012C4F2Cd11E777EDb6dB4f92216aBC), 1000 ether, Round.Private, 15, 5);
413     addAddress(address(0xF2Dc8De5D42BE1f1Fd916f4e532E051351d71aa5), 2001 ether, Round.Private, 15, 5);
414     addAddress(address(0x77EC698AFcBAA2e55522B050eB595CE2E75cea3E), 1000 ether, Round.Private, 15, 5);
415     addAddress(address(0xff356f8726b337a8b12fd28077C1601F88a67fBd), 500 ether, Round.Private, 15, 5);
416     addAddress(address(0x50693E63A0Abb825B1Ba99564954D45B6e45A632), 2000 ether, Round.Private, 15, 5);
417     addAddress(address(0x20997325098692337A03961317eBf912Bf913b65), 2000 ether, Round.Private, 15, 5);
418     addAddress(address(0x5fb716a4B09d42F5894f3a2C7D3da3Ee1711c3f8), 1000 ether, Round.Private, 15, 5);
419     addAddress(address(0x5b4630ECC58BE1De71aD53b3699850A49E892d32), 2000 ether, Round.Private, 15, 5);
420     addAddress(address(0xa01DfAf99c765Dc3f3a6BDDb9afdC1797CF6493E), 500 ether, Round.Private, 15, 5);
421     addAddress(address(0x2c4b8AD42b4b9984E56Da0dbf3b2362D096F7574), 380 ether, Round.Private, 15, 5);
422     addAddress(address(0x25B77f97b373556469Fed882f35832BceA6Ca931), 2000 ether, Round.Private, 15, 5);
423     addAddress(address(0x7d0B9F4f0C9a476A6E9B1Dd05BB228A85b82Af2d), 2000 ether, Round.Private, 15, 5);
424     addAddress(address(0x7Fd7eA0043De720F8aAe10E0ccb232A5905F0e27), 1938 ether, Round.Private, 15, 5);
425     addAddress(address(0x337ab2c4e48b8b65Da792c22665282184f9E5AA8), 1388 ether, Round.Private, 15, 5);
426     addAddress(address(0x68303a858D10f9cfF32373e3f5Ca6B2a13Af8c3c), 2000 ether, Round.Private, 15, 5);
427     addAddress(address(0x10E6dAD4bB48ae5F8B73D140d61dc2057Df25a5f), 1980 ether, Round.Private, 15, 5);
428     addAddress(address(0x90b956D2A705F8BF79a70DEF26cA1eb8863FC4d0), 2000 ether, Round.Private, 15, 5);
429     addAddress(address(0x60D900365BB8cC8d8E817a7EA884b37db8923Ba1), 500 ether, Round.Private, 15, 5);
430     addAddress(address(0xA2b2c17461C79Fe69E95a8eA9822551E72EcF6F7), 2000 ether, Round.Private, 15, 5);
431     addAddress(address(0x723d812E1499a607bE2749a7926acD99422f4743), 250 ether, Round.Private, 15, 5);
432     addAddress(address(0x345aACb3D6F8f84E3c09cf2c908eF413Dc34d673), 1025 ether, Round.Private, 15, 5);
433     addAddress(address(0xf05577445FacCD1A0441061a187d810Bf5363CC6), 1000 ether, Round.Private, 15, 5);
434     addAddress(address(0x744aAd2dfadeAAbfa07035eEDbbc7428d43124c8), 356 ether, Round.Private, 15, 5);
435     addAddress(address(0x54DCAc795bf85f78f9c23B5d72b849E4a78e309d), 1000 ether, Round.Private, 15, 5);
436     addAddress(address(0x0196aD265c56F2b18B708C75CE9358A0b6DF64CF), 2000 ether, Round.Private, 15, 5);
437     addAddress(address(0x3aBa77F76f2CfbAC1389878959E24fAA1afCA68F), 500 ether, Round.Private, 15, 5);
438     addAddress(address(0x1CBba9dE3883329b5356ADE705425Da569cf5b78), 2000 ether, Round.Private, 15, 5);
439     addAddress(address(0xcbC4a69a93C52693A0812780f216EfAc684353b0), 1985 ether, Round.Private, 15, 5);
440     addAddress(address(0x3B04a70f8AE1aB4009FDb5863Bdf1611b287e661), 700 ether, Round.Private, 15, 5);
441     addAddress(address(0x444a52988A40355f6f55cEf439bc2A5F816B2c00), 980 ether, Round.Private, 15, 5);
442     addAddress(address(0xFc134b2469BbdDa973047485F86c83dF0C4dF16D), 1230 ether, Round.Private, 15, 5);
443     addAddress(address(0x4F9476A750Aa3dEbcd3e72340A53c590AeA288a4), 2000 ether, Round.Private, 15, 5);
444     addAddress(address(0x5b540E038c0c263268C8997543B8271DBFb87E33), 1000 ether, Round.Private, 15, 5);
445     addAddress(address(0x3C97c372B45cC96Fe73814721ebbE6db02C9D88E), 2000 ether, Round.Private, 15, 5);
446     addAddress(address(0x5382A0739b47F592af1c15559c29Fe0CA44B98B3), 1200 ether, Round.Private, 15, 5);
447     addAddress(address(0x922f2928f4d244611e8beF9e8dAD88A5B6E2B59C), 1005 ether, Round.Private, 15, 5);
448     addAddress(address(0x4524331C52A73bdfD1668907f28a4860307201Ae), 1161 ether, Round.Private, 15, 5);
449     addAddress(address(0x64882d0F5513c0Fdf8c6225D01971B10026AE778), 368 ether, Round.Private, 15, 5);
450   }
451 
452   function batchAddAddresses(address[] memory _addresses, uint256[] memory _boughtTokensAmounts, Round _round) external onlyOwner {
453     require(_addresses.length == _boughtTokensAmounts.length, "Invalid input data");
454 
455     uint256 initialPercent;
456     uint256 monthlyPercent;
457     if (_round == Round.Strategic) {
458       initialPercent = 10;
459       monthlyPercent = 5;
460     } else if (_round == Round.Private) {
461       initialPercent = 15;
462       monthlyPercent = 5;
463     } else if (_round == Round.Team) {
464       initialPercent = 0;
465       monthlyPercent = 2;
466     }
467 
468     for (uint8 i = 0; i < _addresses.length; i++) {
469       addAddress(_addresses[i], _boughtTokensAmounts[i], _round, initialPercent, monthlyPercent);
470     }
471   }
472 
473   function setStrategicRoundStartTime(uint256 _timestamp) external onlyOwner {
474     require(STRATEGIC_ROUND_START_TIME == 0, "Time is already configured");
475     require(_timestamp >= block.timestamp, "Trying to set time in the past");
476 
477     STRATEGIC_ROUND_START_TIME = _timestamp;
478 
479     emit RoundTimeConfigured(Round.Strategic, _timestamp);
480   }
481 
482   function setPrivateRoundStartTime(uint256 _timestamp) external onlyOwner {
483     require(PRIVATE_ROUND_START_TIME == 0, "Time is already configured");
484     require(_timestamp >= block.timestamp, "Trying to set time in the past");
485 
486     PRIVATE_ROUND_START_TIME = _timestamp;
487 
488     emit RoundTimeConfigured(Round.Private, _timestamp);
489   }
490 
491   function setTeamRoundStartTime(uint256 _timestamp) external onlyOwner {
492     require(TEAM_ROUND_START_TIME == 0, "Time is already configured");
493     require(_timestamp >= block.timestamp, "Trying to set time in the past");
494 
495     TEAM_ROUND_START_TIME = _timestamp;
496 
497     emit RoundTimeConfigured(Round.Team, _timestamp);
498   }
499 
500   function addAddress(address _address, uint256 _boughtTokens, Round _round, uint256 _initialPercent, uint256 _monthlyPercent) public onlyOwner {
501     require(_address != address(0x0), "Invalid address provided");
502     require(_boughtTokens >= 10**9, "Invalid tokens amount");
503     require(_initialPercent.add(_monthlyPercent) <= 100, "Invalid percents amount");
504     require(investors[uint256(_round)][_address].boughtTokens == 0, "Address already exists");
505 
506     investors[uint256(_round)][_address] = Investor({
507       boughtTokens: _boughtTokens,
508       initialPercent: _initialPercent,
509       monthlyPercent: _monthlyPercent,
510       initialRewardReceived: false,
511       monthlyRewardsReceived: 0,
512       totalPercentReceived: 0,
513       totalReceived: 0
514     });
515 
516     emit NewAddress(_address, _boughtTokens, _round, _initialPercent, _monthlyPercent);
517   }
518 
519   function claimInitialTokens() external {
520     uint256 totalTokens;
521 
522     for (uint8 round = 0; round < 3; round++) {
523       if (investors[round][msg.sender].boughtTokens <= 0) { 
524         continue;
525       }
526       if (investors[round][msg.sender].initialRewardReceived) { 
527         continue;
528       }
529       if (investors[round][msg.sender].initialPercent <= 0) { 
530         continue;
531       }
532 
533       uint256 tokensAmount = investors[round][msg.sender].boughtTokens.mul(investors[round][msg.sender].initialPercent).div(100);
534       investors[round][msg.sender].initialRewardReceived = true;
535       investors[round][msg.sender].totalPercentReceived = investors[round][msg.sender].totalPercentReceived.add(investors[round][msg.sender].initialPercent);
536       investors[round][msg.sender].totalReceived = investors[round][msg.sender].totalReceived.add(tokensAmount);
537 
538       totalTokens = totalTokens.add(tokensAmount);
539 
540       emit InitialClaimWithdrawn(msg.sender, Round(round), tokensAmount);
541     }
542 
543     if (totalTokens > 0) {
544       require(IERC20(TOKEN_CONTRACT_ADDRESS).transfer(msg.sender, totalTokens), "Tokens transfer error");
545     }
546   }
547 
548   function claimMonthlyTokens() external {
549     uint256 totalTokens;
550 
551     for (uint8 round = 0; round < 3; round++) {
552       if (investors[round][msg.sender].boughtTokens <= 0) { 
553         continue;
554       }
555       if (investors[round][msg.sender].monthlyPercent <= 0) { 
556         continue;
557       }
558       if (investors[round][msg.sender].totalPercentReceived >= 100) { 
559         continue;
560       }
561 
562       uint256 roundStartTime;
563       if (round == uint8(Round.Strategic)) {
564         roundStartTime = STRATEGIC_ROUND_START_TIME;
565       } else if (round == uint8(Round.Private)) {
566         roundStartTime = PRIVATE_ROUND_START_TIME;
567       } else if (round == uint8(Round.Team)) {
568         roundStartTime = TEAM_ROUND_START_TIME;
569       }
570       if (roundStartTime <= 0 || roundStartTime > block.timestamp) { 
571         continue;
572       }
573 
574       uint256 months = block.timestamp.sub(roundStartTime).div(CLAIMING_PERIOD);
575       if (months > investors[round][msg.sender].monthlyRewardsReceived) {
576         uint256 rewardsNumber = months.sub(investors[round][msg.sender].monthlyRewardsReceived);
577 
578         uint256 percent = investors[round][msg.sender].monthlyPercent.mul(rewardsNumber);
579         if (investors[round][msg.sender].totalPercentReceived.add(percent) > 100) {
580           percent = uint256(100).sub(investors[round][msg.sender].totalPercentReceived);
581         }
582         uint256 tokensAmount = investors[round][msg.sender].boughtTokens.mul(percent).div(100);
583 
584         investors[round][msg.sender].monthlyRewardsReceived = investors[round][msg.sender].monthlyRewardsReceived.add(rewardsNumber);
585         investors[round][msg.sender].totalPercentReceived = investors[round][msg.sender].totalPercentReceived.add(percent);
586         investors[round][msg.sender].totalReceived = investors[round][msg.sender].totalReceived.add(tokensAmount);
587 
588         totalTokens = totalTokens.add(tokensAmount);
589 
590         emit MonthlyClaimWithdrawn(msg.sender, Round(round), tokensAmount);
591       }
592     }
593 
594     if (totalTokens > 0) {
595       require(IERC20(TOKEN_CONTRACT_ADDRESS).transfer(msg.sender, totalTokens), "Tokens transfer error");
596     }
597   }
598 
599   function retrieveTokens(address _tokenAddress, uint256 _amount) public onlyOwner {
600     require(_amount > 0, "Invalid amount");
601 
602     require(
603       IERC20(_tokenAddress).balanceOf(address(this)) >= _amount,
604       "Insufficient Balance"
605     );
606 
607     require(
608       IERC20(_tokenAddress).transfer(owner(), _amount),
609       "Transfer failed"
610     );
611   }
612 
613 }
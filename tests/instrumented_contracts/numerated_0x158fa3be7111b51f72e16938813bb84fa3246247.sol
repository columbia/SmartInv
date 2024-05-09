1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29 }
30 
31 contract Ownable {
32   address public owner;
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function transferOwnership(address newOwner) onlyOwner {
51     if (newOwner != address(0)) {
52       owner = newOwner;
53     }
54   }
55 
56 }
57 
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64 
65   /**
66    * @dev Modifier to make a function callable only when the contract is not paused.
67    */
68   modifier whenNotPaused() {
69     require(!paused);
70     _;
71   }
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is paused.
75    */
76   modifier whenPaused() {
77     require(paused);
78     _;
79   }
80 
81   /**
82    * @dev called by the owner to pause, triggers stopped state
83    */
84   function pause() onlyOwner whenNotPaused public {
85     paused = true;
86     Pause();
87   }
88 
89   /**
90    * @dev called by the owner to unpause, returns to normal state
91    */
92   function unpause() onlyOwner whenPaused public {
93     paused = false;
94     Unpause();
95   }
96 }
97 
98 contract ERC20Basic {
99   uint256 public totalSupply;
100   function balanceOf(address who) constant returns (uint256);
101   function transfer(address to, uint256 value) returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 contract BasicToken is ERC20Basic, Pausable {
106   using SafeMath for uint256;
107   address public saleAddress;
108 
109   mapping(address => uint256) balances;
110   mapping(address => uint256) public holdTime;
111 
112     modifier finishHold() {
113         require(holdTime[msg.sender] <= block.timestamp);
114         _;
115      }
116 
117   /**
118   * @dev transfer token for a specified address
119   * @param _to The address to transfer to.
120   * @param _value The amount to be transferred.
121   */
122   function transfer(address _to, uint256 _value) finishHold whenNotPaused returns (bool) {
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     if (msg.sender == saleAddress) {
126       Transfer(this, _to, _value);
127     } else {
128       Transfer(msg.sender, _to, _value);
129     }
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of. 
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) constant returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) constant returns (uint256);
146   function transferFrom(address from, address to, uint256 value) returns (bool);
147   function approve(address spender, uint256 value) returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) allowed;
154 
155   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
156     var _allowance = allowed[_from][msg.sender];
157 
158     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
159     // require (_value <= _allowance);
160 
161     balances[_to] = balances[_to].add(_value);
162     balances[_from] = balances[_from].sub(_value);
163     allowed[_from][msg.sender] = _allowance.sub(_value);
164     Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
170    * @param _spender The address which will spend the funds.
171    * @param _value The amount of tokens to be spent.
172    */
173   function approve(address _spender, uint256 _value) returns (bool) {
174 
175     // To change the approve amount you first have to reduce the addresses`
176     //  allowance to zero by calling `approve(_spender, 0)` if it is not
177     //  already 0 to mitigate the race condition described here:
178     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
180 
181     allowed[msg.sender][_spender] = _value;
182     Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifing the amount of tokens still avaible for the spender.
191    */
192   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
193     return allowed[_owner][_spender];
194   }
195 
196 }
197 
198 contract CCCRCoin is StandardToken {
199 
200   string public name = "Crypto Credit Card Token";
201   string public symbol = "CCCR";
202   uint8 public constant decimals = 8;
203   
204   // Выпускаем 200 000 000 монет
205   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
206   
207   function CCCRCoin() {
208 
209         totalSupply = 20000000000000000;
210         balances[msg.sender] = 19845521533406700;
211 
212         balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12] = 50000353012200;
213         Transfer(this, 0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12, 50000353012200);
214 
215         balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b] = 27600000000900;
216         Transfer(this, 0xaa00a534093975ac45ecac2365e40b2f81cf554b, 27600000000900);
217 
218         balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0] = 20000000001200;
219         Transfer(this, 0xdaeb100e594bec89aa8282d5b0f54e01100559b0, 20000000001200);
220 
221         balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2] = 3174000000100;
222         Transfer(this, 0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2, 3174000000100);
223 
224         balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb] = 2731842480800;
225         Transfer(this, 0xedfd6f7b43a4e2cdc39975b61965302c47c523cb, 2731842480800);
226 
227         balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc] = 2413068000600;
228         Transfer(this, 0x911af73f46c16f0682c707fdc46b3e5a9b756dfc, 2413068000600);
229 
230         balances[0x2cec090622838aa3abadd176290dea1bbd506466] = 150055805570;
231         Transfer(this, 0x2cec090622838aa3abadd176290dea1bbd506466, 150055805570);
232 
233         balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1] = 966000000400;
234         Transfer(this, 0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1, 966000000400);
235 
236         balances[0xb63a69b443969139766e5734c50b2049297bf335] = 265271908100;
237         Transfer(this, 0xb63a69b443969139766e5734c50b2049297bf335, 265271908100);
238 
239         balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f] = 246000000000;
240         Transfer(this, 0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f, 246000000000);
241 
242         balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd] = 235100000700;
243         Transfer(this, 0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd, 235100000700);
244 
245         balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f] = 171731303700;
246         Transfer(this, 0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f, 171731303700);
247 
248         balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef] = 141950900200;
249         Transfer(this, 0x5e454499faec83dc1aa65d9f0164fb558f9bfdef, 141950900200);
250 
251         balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b] = 126530876100;
252         Transfer(this, 0x77d7ab3250f88d577fda9136867a3e9c2f29284b, 126530876100);
253 
254         balances[0x60a1db27141cbab745a66f162e68103f2a4f2205] = 100913880100;
255         Transfer(this, 0x60a1db27141cbab745a66f162e68103f2a4f2205, 100913880100);
256 
257         balances[0xab58b3d1866065353bf25dbb813434a216afd99d] = 94157196100;
258         Transfer(this, 0xab58b3d1866065353bf25dbb813434a216afd99d, 94157196100);
259 
260         balances[0x8b545e68cf9363e09726e088a3660191eb7152e4] = 69492826500;
261         Transfer(this, 0x8b545e68cf9363e09726e088a3660191eb7152e4, 69492826500);
262 
263         balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e] = 68820406500;
264         Transfer(this, 0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e, 68820406500);
265 
266         balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17] = 67127246300;
267         Transfer(this, 0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17, 67127246300);
268 
269         balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4] = 63368283900;
270         Transfer(this, 0xd912f08de16beecab4cc8f1947c119caf6852cf4, 63368283900);
271 
272         balances[0xdc4b279fd978d248bef6c783c2c937f75855537e] = 63366827700;
273         Transfer(this, 0xdc4b279fd978d248bef6c783c2c937f75855537e, 63366827700);
274 
275         balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a] = 63241881800;
276         Transfer(this, 0x7399a52d49139c9593ea40c11f2f296ca037a18a, 63241881800);
277 
278         balances[0xbb4691d4dff55fb110f996d029900e930060fe48] = 57020276000;
279         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 57020276000);
280 
281         balances[0x826fa4d3b34893e033b6922071b55c1de8074380] = 49977032100;
282         Transfer(this, 0x826fa4d3b34893e033b6922071b55c1de8074380, 49977032100);
283 
284         balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de] = 66306000000;
285         Transfer(this, 0x12f3f72fb89f86110d666337c6cb49f3db4b15de, 66306000000);
286 
287         balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5] = 27600000700;
288         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 27600000700);
289 
290         balances[0x750b5f444a79895d877a821dfce321a9b00e77b3] = 18102155500;
291         Transfer(this, 0x750b5f444a79895d877a821dfce321a9b00e77b3, 18102155500);
292 
293         balances[0x8d88391bfcb5d3254f82addba383523907e028bc] = 18449793100;
294         Transfer(this, 0x8d88391bfcb5d3254f82addba383523907e028bc, 18449793100);
295 
296         balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e] = 13182523700;
297         Transfer(this, 0xf0db27cdabcc02ede5aee9574241a84af930f08e, 13182523700);
298 
299         balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3] = 9952537000;
300         Transfer(this, 0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3, 9952537000);
301     
302         balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074] = 7171200100;
303         Transfer(this, 0xc19aab396d51f7fa9d8a9c147ed77b681626d074, 7171200100);
304 
305         balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461] = 6900001100;
306         Transfer(this, 0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461, 6900001100);
307 
308         balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0] = 5587309400;
309         Transfer(this, 0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0, 5587309400);
310 
311         balances[0xa404999fa8815c53e03d238f3355dce64d7a533a] = 2004246554300;
312         Transfer(this, 0xa404999fa8815c53e03d238f3355dce64d7a533a, 2004246554300);
313 
314         balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a] = 4022879800;
315         Transfer(this, 0xdae37bde109b920a41d7451931c0ce7dd824d39a, 4022879800);
316 
317         balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b] = 2760000600;
318         Transfer(this, 0x6f44062ec1287e4b6890c9df34571109894d2d5b, 2760000600);
319 
320         balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf] = 2602799700;
321         Transfer(this, 0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf, 2602799700);
322 
323         balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8] = 1380000900;
324         Transfer(this, 0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8, 1380000900);
325 
326         balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf] = 1346342000;
327         Transfer(this, 0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf, 1346342000);
328 
329         balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e] = 229999800;
330         Transfer(this, 0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e, 229999800);
331 
332         balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb] = 199386600;
333         Transfer(this, 0x74a4d45b8bb857f627229b94cf2b9b74308c61bb, 199386600);
334 
335         balances[0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf] = 30000000000000;
336         Transfer(this, 0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf, 30000000000000);
337         
338         balances[0x0588a194d4430946255fd4fab07eabd2e3ab8f18] = 7871262000000;
339         Transfer(this, 0x0588a194d4430946255fd4fab07eabd2e3ab8f18, 7871262000000);
340         
341         balances[0x17bf28bbab1173d002660bbaab0c749933699a16] = 2000000000000;
342         Transfer(this, 0x17bf28bbab1173d002660bbaab0c749933699a16, 2000000000000);
343         
344         balances[0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4] = 264129097900;
345         Transfer(this, 0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4, 2641290979000);
346         
347         balances[0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930] = 229500000000;
348         Transfer(this, 0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930, 229500000000);
349         
350         balances[0x0f790b77ab811034bdfb10bca730fb698b8f12cc] = 212730100000;
351         Transfer(this, 0x0f790b77ab811034bdfb10bca730fb698b8f12cc, 212730100000);
352         
353         balances[0x8676802cda269bfda2c75860752df5ce63b83e71] = 200962366500;
354         Transfer(this, 0x8676802cda269bfda2c75860752df5ce63b83e71, 200962366500);
355         
356         balances[0x9e525a52f13299ef01e85fd89cbe2d0438f873d5] = 180408994400;
357         Transfer(this, 0x9e525a52f13299ef01e85fd89cbe2d0438f873d5, 180408994400);
358         
359         balances[0xf21d0648051a81938022c4096e0c201cff49fa73] = 170761763600;
360         Transfer(this, 0xf21d0648051a81938022c4096e0c201cff49fa73, 170761763600);
361         
362         balances[0x8e78a25a0ac397df2130a82def75b1a1933b85d1] = 121843000100;
363         Transfer(this, 0x8e78a25a0ac397df2130a82def75b1a1933b85d1, 121843000100);
364         
365         balances[0x429d820c5bf306ea0797d4729440b13b6bc83c7f] = 115000000000;
366         Transfer(this, 0x429d820c5bf306ea0797d4729440b13b6bc83c7f, 115000000000);
367         
368         balances[0x0a9295aa7c5067d27333ec31e757b6e902741d3f] = 98400000000;
369         Transfer(this, 0x0a9295aa7c5067d27333ec31e757b6e902741d3f, 98400000000);
370         
371         balances[0x25e0ce29affd4998e92dd2a2ef36f313880f7211] = 95128820200;
372         Transfer(this, 0x25e0ce29affd4998e92dd2a2ef36f313880f7211, 95128820200);
373         
374         balances[0xfd950ca35f4c71e5f27afa7a174f4c319e28faae] = 73000000100;
375         Transfer(this, 0xfd950ca35f4c71e5f27afa7a174f4c319e28faae, 73000000100);
376         
377         balances[0x2fac569331653aba1f23898ebc94fa63346e461d] = 70725000000;
378         Transfer(this, 0x2fac569331653aba1f23898ebc94fa63346e461d, 70725000000);
379         
380         balances[0xcc24d7becd7a6c637b8810de10a603d4fcb874c0] = 48339000000;
381         Transfer(this, 0xcc24d7becd7a6c637b8810de10a603d4fcb874c0, 48339000000);
382         
383         balances[0x690a180960d96f7f5abc8b81e7cd02153902a5bd] = 42608430000;
384         Transfer(this, 0x690a180960d96f7f5abc8b81e7cd02153902a5bd, 42608430000);
385         
386         balances[0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d] = 25724475600;
387         Transfer(this, 0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d, 25724475600);
388         
389         balances[0xc6bb148b6abaa82ff4e78911c804d8a204887f18] = 21603798900;
390         Transfer(this, 0xc6bb148b6abaa82ff4e78911c804d8a204887f18, 21603798900);
391         
392         balances[0xb1da55349c6db0f6118c914c8213fdc4139f6655] = 16113000000;
393         Transfer(this, 0xb1da55349c6db0f6118c914c8213fdc4139f6655, 16113000000);
394         
395         balances[0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88] = 14361916700;
396         Transfer(this, 0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88, 14361916700);
397         
398         balances[0x5378d9fca2c0e8326205709e25db3ba616fb3ba1] = 12600334900;
399         Transfer(this, 0x5378d9fca2c0e8326205709e25db3ba616fb3ba1, 12600334900);
400         
401         balances[0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598] = 12300000000;
402         Transfer(this, 0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598, 12300000000);
403         
404         balances[0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0] = 12299999900;
405         Transfer(this, 0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0, 12299999900);
406         
407         balances[0x766b673ea759d4b2f02e9c2930a0bcc28adae822] = 12077104400;
408         Transfer(this, 0x766b673ea759d4b2f02e9c2930a0bcc28adae822, 12077104400);
409         
410         balances[0x9667b43dbe1039c91d95858a737b9d4821cb4041] = 10394704100;
411         Transfer(this, 0x9667b43dbe1039c91d95858a737b9d4821cb4041, 10394704100);
412         
413         balances[0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4] = 9966282100;
414         Transfer(this, 0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4, 9966282100);
415         
416         balances[0xc09b3b6d389ba124f489fbe926032e749b367615] = 9840000000;
417         Transfer(this, 0xc09b3b6d389ba124f489fbe926032e749b367615, 9840000000);
418         
419         balances[0x1ad0f272acaf66510a731cd653554a5982ad5948] = 9301784300;
420         Transfer(this, 0x1ad0f272acaf66510a731cd653554a5982ad5948, 9301784300);
421         
422         balances[0xf0add88b057ba70128e67ae383930c80c9633b11] = 9028084800;
423         Transfer(this, 0xf0add88b057ba70128e67ae383930c80c9633b11, 9028084800);
424         
425         balances[0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf] = 8550811500;
426         Transfer(this, 0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf, 8550811500);
427         
428         balances[0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c] = 8118000000;
429         Transfer(this, 0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c, 8118000000);
430         
431         balances[0x554a481d02b40dc11624d82ecc55bfc1347c8974] = 7585990700;
432         Transfer(this, 0x554a481d02b40dc11624d82ecc55bfc1347c8974, 7585990700);
433         
434         balances[0x10ffe59d86aae76725446ce8d7a00a790681cc88] = 5381431600;
435         Transfer(this, 0x10ffe59d86aae76725446ce8d7a00a790681cc88, 5381431600);
436         
437         balances[0x5fa7ea2b4c69d93dbd68afed55fc521064579677] = 5250000000;
438         Transfer(this, 0x5fa7ea2b4c69d93dbd68afed55fc521064579677, 5250000000);
439         
440         balances[0xd5226f23df1e43148aa552550ec60e70148d9339] = 4538242100;
441         Transfer(this, 0xd5226f23df1e43148aa552550ec60e70148d9339, 4538242100);
442         
443         balances[0xfadc2c948ae9b6c796a941013c272a1e3a68fe87] = 2828999800;
444         Transfer(this, 0xfadc2c948ae9b6c796a941013c272a1e3a68fe87, 2828999800);
445         
446         balances[0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2] = 1484640000;
447         Transfer(this, 0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2, 1484640000);
448         
449         balances[0x7766d50e44cf70409ae0ae23392324d543f26692] = 1353000000;
450         Transfer(this, 0x7766d50e44cf70409ae0ae23392324d543f26692, 1353000000);
451         
452         balances[0xb5d9332d31a195a8e87e85af1e3cba27ca054b94] = 1090281600;
453         Transfer(this, 0xb5d9332d31a195a8e87e85af1e3cba27ca054b94, 1090281600);
454         
455         balances[0x0242f37279f1425667a35ab37929cf71bf74caeb] = 1090000000;
456         Transfer(this, 0x0242f37279f1425667a35ab37929cf71bf74caeb, 1090000000);
457         
458         balances[0x75c3b268b3a7267c30312820c4dcc07cba621e31] = 853255500;
459         Transfer(this, 0x75c3b268b3a7267c30312820c4dcc07cba621e31, 853255500);
460 
461   }
462 
463   function setSaleAddress(address _saleAddress) external onlyOwner {
464     saleAddress = _saleAddress;
465   }
466   
467   function serHoldTime(address _address, uint256 _seconds) external onlyOwner {
468       holdTime[_address] = block.timestamp.add(_seconds);
469   }
470 
471 }
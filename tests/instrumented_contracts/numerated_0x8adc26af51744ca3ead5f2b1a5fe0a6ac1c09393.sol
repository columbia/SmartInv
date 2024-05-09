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
110   mapping(address => bool) holdTimeBool;
111   mapping(address => uint256) holdTime;
112 
113     modifier finishHold() {
114         if (holdTime[msg.sender] >= block.timestamp) {
115             holdTimeBool[msg.sender] = true;
116         }
117         require(holdTimeBool[msg.sender] == false);
118         _;
119      }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) finishHold whenNotPaused returns (bool) {
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     if (msg.sender == saleAddress) {
130       Transfer(this, _to, _value);
131     } else {
132       Transfer(msg.sender, _to, _value);
133     }
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of. 
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) constant returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) constant returns (uint256);
150   function transferFrom(address from, address to, uint256 value) returns (bool);
151   function approve(address spender, uint256 value) returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) allowed;
158 
159   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
160     var _allowance = allowed[_from][msg.sender];
161 
162     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
163     // require (_value <= _allowance);
164 
165     balances[_to] = balances[_to].add(_value);
166     balances[_from] = balances[_from].sub(_value);
167     allowed[_from][msg.sender] = _allowance.sub(_value);
168     Transfer(_from, _to, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) returns (bool) {
178 
179     // To change the approve amount you first have to reduce the addresses`
180     //  allowance to zero by calling `approve(_spender, 0)` if it is not
181     //  already 0 to mitigate the race condition described here:
182     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
184 
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifing the amount of tokens still avaible for the spender.
195    */
196   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
197     return allowed[_owner][_spender];
198   }
199 
200 }
201 
202 contract CCCRCoin is StandardToken {
203 
204   string public name = "Crypto Credit Card Token";
205   string public symbol = "CCCR";
206   uint8 public constant decimals = 8;
207   
208   // Выпускаем 200 000 000 монет
209   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
210   
211   function CCCRCoin() {
212 
213         totalSupply = 20000000000000000;
214         balances[msg.sender] = 19845521533406700;
215 
216         balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12] = 50000353012200;
217         Transfer(this, 0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12, 50000353012200);
218 
219         balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b] = 27600000000900;
220         Transfer(this, 0xaa00a534093975ac45ecac2365e40b2f81cf554b, 27600000000900);
221 
222         balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0] = 20000000001200;
223         Transfer(this, 0xdaeb100e594bec89aa8282d5b0f54e01100559b0, 20000000001200);
224 
225         balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2] = 3174000000100;
226         Transfer(this, 0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2, 3174000000100);
227 
228         balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb] = 2731842480800;
229         Transfer(this, 0xedfd6f7b43a4e2cdc39975b61965302c47c523cb, 2731842480800);
230 
231         balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc] = 2413068000600;
232         Transfer(this, 0x911af73f46c16f0682c707fdc46b3e5a9b756dfc, 2413068000600);
233 
234         balances[0x2cec090622838aa3abadd176290dea1bbd506466] = 1500558055700;
235         Transfer(this, 0x2cec090622838aa3abadd176290dea1bbd506466, 1500558055700);
236 
237         balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1] = 966000000400;
238         Transfer(this, 0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1, 966000000400);
239 
240         balances[0xb63a69b443969139766e5734c50b2049297bf335] = 265271908100;
241         Transfer(this, 0xb63a69b443969139766e5734c50b2049297bf335, 265271908100);
242 
243         balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f] = 246000000000;
244         Transfer(this, 0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f, 246000000000);
245 
246         balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd] = 235100000700;
247         Transfer(this, 0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd, 235100000700);
248 
249         balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f] = 171731303700;
250         Transfer(this, 0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f, 171731303700);
251 
252         balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef] = 141950900200;
253         Transfer(this, 0x5e454499faec83dc1aa65d9f0164fb558f9bfdef, 141950900200);
254 
255         balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b] = 126530876100;
256         Transfer(this, 0x77d7ab3250f88d577fda9136867a3e9c2f29284b, 126530876100);
257 
258         balances[0x60a1db27141cbab745a66f162e68103f2a4f2205] = 100913880100;
259         Transfer(this, 0x60a1db27141cbab745a66f162e68103f2a4f2205, 100913880100);
260 
261         balances[0xab58b3d1866065353bf25dbb813434a216afd99d] = 94157196100;
262         Transfer(this, 0xab58b3d1866065353bf25dbb813434a216afd99d, 94157196100);
263 
264         balances[0x8b545e68cf9363e09726e088a3660191eb7152e4] = 69492826500;
265         Transfer(this, 0x8b545e68cf9363e09726e088a3660191eb7152e4, 69492826500);
266 
267         balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e] = 68820406500;
268         Transfer(this, 0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e, 68820406500);
269 
270         balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17] = 67127246300;
271         Transfer(this, 0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17, 67127246300);
272 
273         balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4] = 63368283900;
274         Transfer(this, 0xd912f08de16beecab4cc8f1947c119caf6852cf4, 63368283900);
275 
276         balances[0xdc4b279fd978d248bef6c783c2c937f75855537e] = 63366827700;
277         Transfer(this, 0xdc4b279fd978d248bef6c783c2c937f75855537e, 63366827700);
278 
279         balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a] = 63241881800;
280         Transfer(this, 0x7399a52d49139c9593ea40c11f2f296ca037a18a, 63241881800);
281 
282         balances[0xbb4691d4dff55fb110f996d029900e930060fe48] = 57020276000;
283         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 57020276000);
284 
285         balances[0x826fa4d3b34893e033b6922071b55c1de8074380] = 49977032100;
286         Transfer(this, 0x826fa4d3b34893e033b6922071b55c1de8074380, 49977032100);
287 
288         balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de] = 66306000000;
289         Transfer(this, 0x12f3f72fb89f86110d666337c6cb49f3db4b15de, 66306000000);
290 
291         balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5] = 27600000700;
292         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 27600000700);
293 
294         balances[0x750b5f444a79895d877a821dfce321a9b00e77b3] = 18102155500;
295         Transfer(this, 0x750b5f444a79895d877a821dfce321a9b00e77b3, 18102155500);
296 
297         balances[0x8d88391bfcb5d3254f82addba383523907e028bc] = 18449793100;
298         Transfer(this, 0x8d88391bfcb5d3254f82addba383523907e028bc, 18449793100);
299 
300         balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e] = 13182523700;
301         Transfer(this, 0xf0db27cdabcc02ede5aee9574241a84af930f08e, 13182523700);
302 
303         balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3] = 9952537000;
304         Transfer(this, 0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3, 9952537000);
305     
306         balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074] = 7171200100;
307         Transfer(this, 0xc19aab396d51f7fa9d8a9c147ed77b681626d074, 7171200100);
308 
309         balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461] = 6900001100;
310         Transfer(this, 0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461, 6900001100);
311 
312         balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0] = 5587309400;
313         Transfer(this, 0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0, 5587309400);
314 
315         balances[0xa404999fa8815c53e03d238f3355dce64d7a533a] = 2004246554300;
316         Transfer(this, 0xa404999fa8815c53e03d238f3355dce64d7a533a, 2004246554300);
317 
318         balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a] = 4022879800;
319         Transfer(this, 0xdae37bde109b920a41d7451931c0ce7dd824d39a, 4022879800);
320 
321         balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b] = 2760000600;
322         Transfer(this, 0x6f44062ec1287e4b6890c9df34571109894d2d5b, 2760000600);
323 
324         balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf] = 2602799700;
325         Transfer(this, 0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf, 2602799700);
326 
327         balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8] = 1380000900;
328         Transfer(this, 0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8, 1380000900);
329 
330         balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf] = 1346342000;
331         Transfer(this, 0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf, 1346342000);
332 
333         balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e] = 229999800;
334         Transfer(this, 0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e, 229999800);
335 
336         balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb] = 199386600;
337         Transfer(this, 0x74a4d45b8bb857f627229b94cf2b9b74308c61bb, 199386600);
338 
339         balances[0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf] = 30000000000000;
340         Transfer(this, 0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf, 30000000000000);
341         
342         balances[0x0588a194d4430946255fd4fab07eabd2e3ab8f18] = 7871262000000;
343         Transfer(this, 0x0588a194d4430946255fd4fab07eabd2e3ab8f18, 7871262000000);
344         
345         balances[0x17bf28bbab1173d002660bbaab0c749933699a16] = 2000000000000;
346         Transfer(this, 0x17bf28bbab1173d002660bbaab0c749933699a16, 2000000000000);
347         
348         balances[0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4] = 264129097900;
349         Transfer(this, 0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4, 2641290979000);
350         
351         balances[0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930] = 229500000000;
352         Transfer(this, 0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930, 229500000000);
353         
354         balances[0x0f790b77ab811034bdfb10bca730fb698b8f12cc] = 212730100000;
355         Transfer(this, 0x0f790b77ab811034bdfb10bca730fb698b8f12cc, 212730100000);
356         
357         balances[0x8676802cda269bfda2c75860752df5ce63b83e71] = 200962366500;
358         Transfer(this, 0x8676802cda269bfda2c75860752df5ce63b83e71, 200962366500);
359         
360         balances[0x9e525a52f13299ef01e85fd89cbe2d0438f873d5] = 180408994400;
361         Transfer(this, 0x9e525a52f13299ef01e85fd89cbe2d0438f873d5, 180408994400);
362         
363         balances[0xf21d0648051a81938022c4096e0c201cff49fa73] = 170761763600;
364         Transfer(this, 0xf21d0648051a81938022c4096e0c201cff49fa73, 170761763600);
365         
366         balances[0x8e78a25a0ac397df2130a82def75b1a1933b85d1] = 121843000100;
367         Transfer(this, 0x8e78a25a0ac397df2130a82def75b1a1933b85d1, 121843000100);
368         
369         balances[0x429d820c5bf306ea0797d4729440b13b6bc83c7f] = 115000000000;
370         Transfer(this, 0x429d820c5bf306ea0797d4729440b13b6bc83c7f, 115000000000);
371         
372         balances[0x0a9295aa7c5067d27333ec31e757b6e902741d3f] = 98400000000;
373         Transfer(this, 0x0a9295aa7c5067d27333ec31e757b6e902741d3f, 98400000000);
374         
375         balances[0x25e0ce29affd4998e92dd2a2ef36f313880f7211] = 95128820200;
376         Transfer(this, 0x25e0ce29affd4998e92dd2a2ef36f313880f7211, 95128820200);
377         
378         balances[0xfd950ca35f4c71e5f27afa7a174f4c319e28faae] = 73000000100;
379         Transfer(this, 0xfd950ca35f4c71e5f27afa7a174f4c319e28faae, 73000000100);
380         
381         balances[0x2fac569331653aba1f23898ebc94fa63346e461d] = 70725000000;
382         Transfer(this, 0x2fac569331653aba1f23898ebc94fa63346e461d, 70725000000);
383         
384         balances[0xcc24d7becd7a6c637b8810de10a603d4fcb874c0] = 48339000000;
385         Transfer(this, 0xcc24d7becd7a6c637b8810de10a603d4fcb874c0, 48339000000);
386         
387         balances[0x690a180960d96f7f5abc8b81e7cd02153902a5bd] = 42608430000;
388         Transfer(this, 0x690a180960d96f7f5abc8b81e7cd02153902a5bd, 42608430000);
389         
390         balances[0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d] = 25724475600;
391         Transfer(this, 0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d, 25724475600);
392         
393         balances[0xc6bb148b6abaa82ff4e78911c804d8a204887f18] = 21603798900;
394         Transfer(this, 0xc6bb148b6abaa82ff4e78911c804d8a204887f18, 21603798900);
395         
396         balances[0xb1da55349c6db0f6118c914c8213fdc4139f6655] = 16113000000;
397         Transfer(this, 0xb1da55349c6db0f6118c914c8213fdc4139f6655, 16113000000);
398         
399         balances[0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88] = 14361916700;
400         Transfer(this, 0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88, 14361916700);
401         
402         balances[0x5378d9fca2c0e8326205709e25db3ba616fb3ba1] = 12600334900;
403         Transfer(this, 0x5378d9fca2c0e8326205709e25db3ba616fb3ba1, 12600334900);
404         
405         balances[0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598] = 12300000000;
406         Transfer(this, 0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598, 12300000000);
407         
408         balances[0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0] = 12299999900;
409         Transfer(this, 0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0, 12299999900);
410         
411         balances[0x766b673ea759d4b2f02e9c2930a0bcc28adae822] = 12077104400;
412         Transfer(this, 0x766b673ea759d4b2f02e9c2930a0bcc28adae822, 12077104400);
413         
414         balances[0x9667b43dbe1039c91d95858a737b9d4821cb4041] = 10394704100;
415         Transfer(this, 0x9667b43dbe1039c91d95858a737b9d4821cb4041, 10394704100);
416         
417         balances[0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4] = 9966282100;
418         Transfer(this, 0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4, 9966282100);
419         
420         balances[0xc09b3b6d389ba124f489fbe926032e749b367615] = 9840000000;
421         Transfer(this, 0xc09b3b6d389ba124f489fbe926032e749b367615, 9840000000);
422         
423         balances[0x1ad0f272acaf66510a731cd653554a5982ad5948] = 9301784300;
424         Transfer(this, 0x1ad0f272acaf66510a731cd653554a5982ad5948, 9301784300);
425         
426         balances[0xf0add88b057ba70128e67ae383930c80c9633b11] = 9028084800;
427         Transfer(this, 0xf0add88b057ba70128e67ae383930c80c9633b11, 9028084800);
428         
429         balances[0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf] = 8550811500;
430         Transfer(this, 0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf, 8550811500);
431         
432         balances[0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c] = 8118000000;
433         Transfer(this, 0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c, 8118000000);
434         
435         balances[0x554a481d02b40dc11624d82ecc55bfc1347c8974] = 7585990700;
436         Transfer(this, 0x554a481d02b40dc11624d82ecc55bfc1347c8974, 7585990700);
437         
438         balances[0x10ffe59d86aae76725446ce8d7a00a790681cc88] = 5381431600;
439         Transfer(this, 0x10ffe59d86aae76725446ce8d7a00a790681cc88, 5381431600);
440         
441         balances[0x5fa7ea2b4c69d93dbd68afed55fc521064579677] = 5250000000;
442         Transfer(this, 0x5fa7ea2b4c69d93dbd68afed55fc521064579677, 5250000000);
443         
444         balances[0xd5226f23df1e43148aa552550ec60e70148d9339] = 4538242100;
445         Transfer(this, 0xd5226f23df1e43148aa552550ec60e70148d9339, 4538242100);
446         
447         balances[0xfadc2c948ae9b6c796a941013c272a1e3a68fe87] = 2828999800;
448         Transfer(this, 0xfadc2c948ae9b6c796a941013c272a1e3a68fe87, 2828999800);
449         
450         balances[0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2] = 1484640000;
451         Transfer(this, 0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2, 1484640000);
452         
453         balances[0x7766d50e44cf70409ae0ae23392324d543f26692] = 1353000000;
454         Transfer(this, 0x7766d50e44cf70409ae0ae23392324d543f26692, 1353000000);
455         
456         balances[0xb5d9332d31a195a8e87e85af1e3cba27ca054b94] = 1090281600;
457         Transfer(this, 0xb5d9332d31a195a8e87e85af1e3cba27ca054b94, 1090281600);
458         
459         balances[0x0242f37279f1425667a35ab37929cf71bf74caeb] = 1090000000;
460         Transfer(this, 0x0242f37279f1425667a35ab37929cf71bf74caeb, 1090000000);
461         
462         balances[0x75c3b268b3a7267c30312820c4dcc07cba621e31] = 853255500;
463         Transfer(this, 0x75c3b268b3a7267c30312820c4dcc07cba621e31, 853255500);
464 
465   }
466 
467   function setSaleAddress(address _saleAddress) external onlyOwner {
468     saleAddress = _saleAddress;
469   }
470   
471   function serHoldTime(address _address, uint256 _seconds) external onlyOwner {
472       holdTime[_address] = block.timestamp.add(_seconds);
473   }
474 
475 }
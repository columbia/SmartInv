1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99 
100   /**
101    * @dev Modifier to make a function callable only when the contract is not paused.
102    */
103   modifier whenNotPaused() {
104     require(!paused);
105     _;
106   }
107 
108   /**
109    * @dev Modifier to make a function callable only when the contract is paused.
110    */
111   modifier whenPaused() {
112     require(paused);
113     _;
114   }
115 
116   /**
117    * @dev called by the owner to pause, triggers stopped state
118    */
119   function pause() onlyOwner whenNotPaused public {
120     paused = true;
121     Pause();
122   }
123 
124   /**
125    * @dev called by the owner to unpause, returns to normal state
126    */
127   function unpause() onlyOwner whenPaused public {
128     paused = false;
129     Unpause();
130   }
131 }
132 
133 contract ERC20Basic is Pausable {
134   uint256 public totalSupply;
135   function balanceOf(address who) constant returns (uint256);
136   function transfer(address to, uint256 value) returns (bool);
137   event Transfer(address indexed from, address indexed to, uint256 indexed value);
138 }
139 
140 contract BasicToken is ERC20Basic {
141   using SafeMath for uint256;
142   address public saleAddress;
143 
144   mapping(address => uint256) balances;
145   mapping(address => uint256) public holdTime;
146 
147   modifier finishHold() {
148     require(holdTime[msg.sender] <= block.timestamp);
149     _;
150   }
151 
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) finishHold whenNotPaused returns (bool) {
158 
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     balances[_to] = balances[_to].add(_value);
164     if (msg.sender == saleAddress) {
165       Transfer(this, _to, _value);
166     } else {
167       Transfer(msg.sender, _to, _value);
168     }
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of. 
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public view returns (uint256 balance) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 contract ERC20 is ERC20Basic {
184   function allowance(address owner, address spender) public view returns (uint256);
185   function transferFrom(address from, address to, uint256 value) public returns (bool);
186   function approve(address spender, uint256 value) public returns (bool);
187   event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 contract StandardToken is ERC20, BasicToken {
191 
192   mapping (address => mapping (address => uint256)) allowed;
193 
194   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
195     
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_to] = balances[_to].add(_value);
201     balances[_from] = balances[_from].sub(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203 
204     Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifing the amount of tokens still avaible for the spender.
224    */
225   function allowance(address _owner, address _spender) public view returns (uint256) {
226     return allowed[_owner][_spender];
227   }
228 
229 }
230 
231 contract CCCRCoin is StandardToken {
232 
233   string public name = "Crypto Credit Card Token";
234   string public symbol = "CCCR";
235   uint8 public constant decimals = 8;
236   
237   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** uint256(decimals));
238   
239   function CCCRCoin() {
240 
241         totalSupply = 20000000000000000;
242         balances[msg.sender] = 19845521533406700;
243 
244         balances[0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12] = 50000353012200;
245         Transfer(this, 0x0cb9cb4723c1764d26b3ab38fec121d0390d5e12, 50000353012200);
246 
247         balances[0xaa00a534093975ac45ecac2365e40b2f81cf554b] = 27600000000900;
248         Transfer(this, 0xaa00a534093975ac45ecac2365e40b2f81cf554b, 27600000000900);
249 
250         balances[0xdaeb100e594bec89aa8282d5b0f54e01100559b0] = 20000000001200;
251         Transfer(this, 0xdaeb100e594bec89aa8282d5b0f54e01100559b0, 20000000001200);
252 
253         balances[0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2] = 3174000000100;
254         Transfer(this, 0x7fc4662f19e83c986a4b8d3160ee9a0582ac45a2, 3174000000100);
255 
256         balances[0xedfd6f7b43a4e2cdc39975b61965302c47c523cb] = 2731842480800;
257         Transfer(this, 0xedfd6f7b43a4e2cdc39975b61965302c47c523cb, 2731842480800);
258 
259         balances[0x911af73f46c16f0682c707fdc46b3e5a9b756dfc] = 2413068000600;
260         Transfer(this, 0x911af73f46c16f0682c707fdc46b3e5a9b756dfc, 2413068000600);
261 
262         balances[0x2cec090622838aa3abadd176290dea1bbd506466] = 150055805570;
263         Transfer(this, 0x2cec090622838aa3abadd176290dea1bbd506466, 150055805570);
264 
265         balances[0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1] = 966000000400;
266         Transfer(this, 0xf023fa938d0fed67e944b3df2efaa344c7a9bfb1, 966000000400);
267 
268         balances[0xb63a69b443969139766e5734c50b2049297bf335] = 265271908100;
269         Transfer(this, 0xb63a69b443969139766e5734c50b2049297bf335, 265271908100);
270 
271         balances[0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f] = 246000000000;
272         Transfer(this, 0xf8e55ebe2cc6cf9112a94c037046e2be3700ef3f, 246000000000);
273 
274         balances[0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd] = 235100000700;
275         Transfer(this, 0x6245f92acebe1d59af8497ca8e9edc6d3fe586dd, 235100000700);
276 
277         balances[0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f] = 171731303700;
278         Transfer(this, 0x2a8002c6ef65179bf4ba4ea6bcfda7a599b30a7f, 171731303700);
279 
280         balances[0x5e454499faec83dc1aa65d9f0164fb558f9bfdef] = 141950900200;
281         Transfer(this, 0x5e454499faec83dc1aa65d9f0164fb558f9bfdef, 141950900200);
282 
283         balances[0x77d7ab3250f88d577fda9136867a3e9c2f29284b] = 126530876100;
284         Transfer(this, 0x77d7ab3250f88d577fda9136867a3e9c2f29284b, 126530876100);
285 
286         balances[0x60a1db27141cbab745a66f162e68103f2a4f2205] = 100913880100;
287         Transfer(this, 0x60a1db27141cbab745a66f162e68103f2a4f2205, 100913880100);
288 
289         balances[0xab58b3d1866065353bf25dbb813434a216afd99d] = 94157196100;
290         Transfer(this, 0xab58b3d1866065353bf25dbb813434a216afd99d, 94157196100);
291 
292         balances[0x8b545e68cf9363e09726e088a3660191eb7152e4] = 69492826500;
293         Transfer(this, 0x8b545e68cf9363e09726e088a3660191eb7152e4, 69492826500);
294 
295         balances[0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e] = 68820406500;
296         Transfer(this, 0xa5add2ea6fde2abb80832ef9b6bdf723e1eb894e, 68820406500);
297 
298         balances[0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17] = 67127246300;
299         Transfer(this, 0xb4c56ab33eaecc6a1567d3f45e9483b0a529ac17, 67127246300);
300 
301         balances[0xd912f08de16beecab4cc8f1947c119caf6852cf4] = 63368283900;
302         Transfer(this, 0xd912f08de16beecab4cc8f1947c119caf6852cf4, 63368283900);
303 
304         balances[0xdc4b279fd978d248bef6c783c2c937f75855537e] = 63366827700;
305         Transfer(this, 0xdc4b279fd978d248bef6c783c2c937f75855537e, 63366827700);
306 
307         balances[0x7399a52d49139c9593ea40c11f2f296ca037a18a] = 63241881800;
308         Transfer(this, 0x7399a52d49139c9593ea40c11f2f296ca037a18a, 63241881800);
309 
310         balances[0xbb4691d4dff55fb110f996d029900e930060fe48] = 57020276000;
311         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 57020276000);
312 
313         balances[0x826fa4d3b34893e033b6922071b55c1de8074380] = 49977032100;
314         Transfer(this, 0x826fa4d3b34893e033b6922071b55c1de8074380, 49977032100);
315 
316         balances[0x12f3f72fb89f86110d666337c6cb49f3db4b15de] = 66306000000;
317         Transfer(this, 0x12f3f72fb89f86110d666337c6cb49f3db4b15de, 66306000000);
318 
319         balances[0x65f34b34b2c5da1f1469f4165f4369242edbbec5] = 27600000700;
320         Transfer(this, 0xbb4691d4dff55fb110f996d029900e930060fe48, 27600000700);
321 
322         balances[0x750b5f444a79895d877a821dfce321a9b00e77b3] = 18102155500;
323         Transfer(this, 0x750b5f444a79895d877a821dfce321a9b00e77b3, 18102155500);
324 
325         balances[0x8d88391bfcb5d3254f82addba383523907e028bc] = 18449793100;
326         Transfer(this, 0x8d88391bfcb5d3254f82addba383523907e028bc, 18449793100);
327 
328         balances[0xf0db27cdabcc02ede5aee9574241a84af930f08e] = 13182523700;
329         Transfer(this, 0xf0db27cdabcc02ede5aee9574241a84af930f08e, 13182523700);
330 
331         balances[0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3] = 9952537000;
332         Transfer(this, 0x27bd1a5c0f6e66e6d82475fa7aff3e575e0d79d3, 9952537000);
333     
334         balances[0xc19aab396d51f7fa9d8a9c147ed77b681626d074] = 7171200100;
335         Transfer(this, 0xc19aab396d51f7fa9d8a9c147ed77b681626d074, 7171200100);
336 
337         balances[0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461] = 6900001100;
338         Transfer(this, 0x1b90b11b8e82ae5a2601f143ebb6812cc18c7461, 6900001100);
339 
340         balances[0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0] = 5587309400;
341         Transfer(this, 0x9b4bccee634ffe55b70ee568d9f9c357c6efccb0, 5587309400);
342 
343         balances[0xa404999fa8815c53e03d238f3355dce64d7a533a] = 2004246554300;
344         Transfer(this, 0xa404999fa8815c53e03d238f3355dce64d7a533a, 2004246554300);
345 
346         balances[0xdae37bde109b920a41d7451931c0ce7dd824d39a] = 4022879800;
347         Transfer(this, 0xdae37bde109b920a41d7451931c0ce7dd824d39a, 4022879800);
348 
349         balances[0x6f44062ec1287e4b6890c9df34571109894d2d5b] = 2760000600;
350         Transfer(this, 0x6f44062ec1287e4b6890c9df34571109894d2d5b, 2760000600);
351 
352         balances[0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf] = 2602799700;
353         Transfer(this, 0x5f1c5a1c4d275f8e41eafa487f45800efc6717bf, 2602799700);
354 
355         balances[0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8] = 1380000900;
356         Transfer(this, 0xfc35a274ae440d4804e9fc00cc3ceda4a7eda3b8, 1380000900);
357 
358         balances[0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf] = 1346342000;
359         Transfer(this, 0x0f4e5dde970f2bdc9fd079efcb2f4630d6deebbf, 1346342000);
360 
361         balances[0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e] = 229999800;
362         Transfer(this, 0x7b6b64c0b9673a2a4400d0495f44eaf79b56b69e, 229999800);
363 
364         balances[0x74a4d45b8bb857f627229b94cf2b9b74308c61bb] = 199386600;
365         Transfer(this, 0x74a4d45b8bb857f627229b94cf2b9b74308c61bb, 199386600);
366 
367         balances[0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf] = 30000000000000;
368         Transfer(this, 0x4ed117148c088a190bacc2bcec4a0cf8fe8179bf, 30000000000000);
369         
370         balances[0x0588a194d4430946255fd4fab07eabd2e3ab8f18] = 7871262000000;
371         Transfer(this, 0x0588a194d4430946255fd4fab07eabd2e3ab8f18, 7871262000000);
372         
373         balances[0x17bf28bbab1173d002660bbaab0c749933699a16] = 2000000000000;
374         Transfer(this, 0x17bf28bbab1173d002660bbaab0c749933699a16, 2000000000000);
375         
376         balances[0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4] = 264129097900;
377         Transfer(this, 0x27b2d162af7f12c43dbb8bb44d7a7ba2ba4c85c4, 2641290979000);
378         
379         balances[0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930] = 229500000000;
380         Transfer(this, 0x97b2a0de0b55b7fe213a1e3f2ad2357c12041930, 229500000000);
381         
382         balances[0x0f790b77ab811034bdfb10bca730fb698b8f12cc] = 212730100000;
383         Transfer(this, 0x0f790b77ab811034bdfb10bca730fb698b8f12cc, 212730100000);
384         
385         balances[0x8676802cda269bfda2c75860752df5ce63b83e71] = 200962366500;
386         Transfer(this, 0x8676802cda269bfda2c75860752df5ce63b83e71, 200962366500);
387         
388         balances[0x9e525a52f13299ef01e85fd89cbe2d0438f873d5] = 180408994400;
389         Transfer(this, 0x9e525a52f13299ef01e85fd89cbe2d0438f873d5, 180408994400);
390         
391         balances[0xf21d0648051a81938022c4096e0c201cff49fa73] = 170761763600;
392         Transfer(this, 0xf21d0648051a81938022c4096e0c201cff49fa73, 170761763600);
393         
394         balances[0x8e78a25a0ac397df2130a82def75b1a1933b85d1] = 121843000100;
395         Transfer(this, 0x8e78a25a0ac397df2130a82def75b1a1933b85d1, 121843000100);
396         
397         balances[0x429d820c5bf306ea0797d4729440b13b6bc83c7f] = 115000000000;
398         Transfer(this, 0x429d820c5bf306ea0797d4729440b13b6bc83c7f, 115000000000);
399         
400         balances[0x0a9295aa7c5067d27333ec31e757b6e902741d3f] = 98400000000;
401         Transfer(this, 0x0a9295aa7c5067d27333ec31e757b6e902741d3f, 98400000000);
402         
403         balances[0x25e0ce29affd4998e92dd2a2ef36f313880f7211] = 95128820200;
404         Transfer(this, 0x25e0ce29affd4998e92dd2a2ef36f313880f7211, 95128820200);
405         
406         balances[0xfd950ca35f4c71e5f27afa7a174f4c319e28faae] = 73000000100;
407         Transfer(this, 0xfd950ca35f4c71e5f27afa7a174f4c319e28faae, 73000000100);
408         
409         balances[0x2fac569331653aba1f23898ebc94fa63346e461d] = 70725000000;
410         Transfer(this, 0x2fac569331653aba1f23898ebc94fa63346e461d, 70725000000);
411         
412         balances[0xcc24d7becd7a6c637b8810de10a603d4fcb874c0] = 48339000000;
413         Transfer(this, 0xcc24d7becd7a6c637b8810de10a603d4fcb874c0, 48339000000);
414         
415         balances[0x690a180960d96f7f5abc8b81e7cd02153902a5bd] = 42608430000;
416         Transfer(this, 0x690a180960d96f7f5abc8b81e7cd02153902a5bd, 42608430000);
417         
418         balances[0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d] = 25724475600;
419         Transfer(this, 0xdcc0a2b985e482dedef00c0501238d33cd7b2a5d, 25724475600);
420         
421         balances[0xc6bb148b6abaa82ff4e78911c804d8a204887f18] = 21603798900;
422         Transfer(this, 0xc6bb148b6abaa82ff4e78911c804d8a204887f18, 21603798900);
423         
424         balances[0xb1da55349c6db0f6118c914c8213fdc4139f6655] = 16113000000;
425         Transfer(this, 0xb1da55349c6db0f6118c914c8213fdc4139f6655, 16113000000);
426         
427         balances[0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88] = 14361916700;
428         Transfer(this, 0xfcbd39a90c81a24cfbe9a6468886dcccf6f4de88, 14361916700);
429         
430         balances[0x5378d9fca2c0e8326205709e25db3ba616fb3ba1] = 12600334900;
431         Transfer(this, 0x5378d9fca2c0e8326205709e25db3ba616fb3ba1, 12600334900);
432         
433         balances[0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598] = 12300000000;
434         Transfer(this, 0x199363591ac6fb5d8a5b86fc15a1dcbd8e65e598, 12300000000);
435         
436         balances[0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0] = 12299999900;
437         Transfer(this, 0xe4fffc340c8bc4dc73a2008d3cde76a6ac37d5f0, 12299999900);
438         
439         balances[0x766b673ea759d4b2f02e9c2930a0bcc28adae822] = 12077104400;
440         Transfer(this, 0x766b673ea759d4b2f02e9c2930a0bcc28adae822, 12077104400);
441         
442         balances[0x9667b43dbe1039c91d95858a737b9d4821cb4041] = 10394704100;
443         Transfer(this, 0x9667b43dbe1039c91d95858a737b9d4821cb4041, 10394704100);
444         
445         balances[0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4] = 9966282100;
446         Transfer(this, 0xa12eda0eb1f2df8e830b6762dce4bc4744881fa4, 9966282100);
447         
448         balances[0xc09b3b6d389ba124f489fbe926032e749b367615] = 9840000000;
449         Transfer(this, 0xc09b3b6d389ba124f489fbe926032e749b367615, 9840000000);
450         
451         balances[0x1ad0f272acaf66510a731cd653554a5982ad5948] = 9301784300;
452         Transfer(this, 0x1ad0f272acaf66510a731cd653554a5982ad5948, 9301784300);
453         
454         balances[0xf0add88b057ba70128e67ae383930c80c9633b11] = 9028084800;
455         Transfer(this, 0xf0add88b057ba70128e67ae383930c80c9633b11, 9028084800);
456         
457         balances[0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf] = 8550811500;
458         Transfer(this, 0xefa2d86adea3bdbb6b9667d58cd0a32592ab0ccf, 8550811500);
459         
460         balances[0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c] = 8118000000;
461         Transfer(this, 0x882b72fd3f9bb0e6530b28dcbb68cf1371bdda9c, 8118000000);
462         
463         balances[0x554a481d02b40dc11624d82ecc55bfc1347c8974] = 7585990700;
464         Transfer(this, 0x554a481d02b40dc11624d82ecc55bfc1347c8974, 7585990700);
465         
466         balances[0x10ffe59d86aae76725446ce8d7a00a790681cc88] = 5381431600;
467         Transfer(this, 0x10ffe59d86aae76725446ce8d7a00a790681cc88, 5381431600);
468         
469         balances[0x5fa7ea2b4c69d93dbd68afed55fc521064579677] = 5250000000;
470         Transfer(this, 0x5fa7ea2b4c69d93dbd68afed55fc521064579677, 5250000000);
471         
472         balances[0xd5226f23df1e43148aa552550ec60e70148d9339] = 4538242100;
473         Transfer(this, 0xd5226f23df1e43148aa552550ec60e70148d9339, 4538242100);
474         
475         balances[0xfadc2c948ae9b6c796a941013c272a1e3a68fe87] = 2828999800;
476         Transfer(this, 0xfadc2c948ae9b6c796a941013c272a1e3a68fe87, 2828999800);
477         
478         balances[0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2] = 1484640000;
479         Transfer(this, 0xa25bdd9298558aa2e12daf789bf61ad0a5ccdec2, 1484640000);
480         
481         balances[0x7766d50e44cf70409ae0ae23392324d543f26692] = 1353000000;
482         Transfer(this, 0x7766d50e44cf70409ae0ae23392324d543f26692, 1353000000);
483         
484         balances[0xb5d9332d31a195a8e87e85af1e3cba27ca054b94] = 1090281600;
485         Transfer(this, 0xb5d9332d31a195a8e87e85af1e3cba27ca054b94, 1090281600);
486         
487         balances[0x0242f37279f1425667a35ab37929cf71bf74caeb] = 1090000000;
488         Transfer(this, 0x0242f37279f1425667a35ab37929cf71bf74caeb, 1090000000);
489         
490         balances[0x75c3b268b3a7267c30312820c4dcc07cba621e31] = 853255500;
491         Transfer(this, 0x75c3b268b3a7267c30312820c4dcc07cba621e31, 853255500);
492 
493   }
494 
495   function setSaleAddress(address _saleAddress) external onlyOwner {
496     saleAddress = _saleAddress;
497   }
498   
499   function serHoldTime(address _address, uint256 _seconds) external onlyOwner {
500       holdTime[_address] = block.timestamp.add(_seconds);
501   }
502 
503 }
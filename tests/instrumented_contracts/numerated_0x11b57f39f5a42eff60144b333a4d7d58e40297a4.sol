1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     require(value <= _balances[msg.sender]);
156     require(to != address(0));
157 
158     _balances[msg.sender] = _balances[msg.sender].sub(value);
159     _balances[to] = _balances[to].add(value);
160     emit Transfer(msg.sender, to, value);
161     return true;
162   }
163 
164   /**
165    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
166    * Beware that changing an allowance with this method brings the risk that someone may use both the old
167    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
168    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
169    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170    * @param spender The address which will spend the funds.
171    * @param value The amount of tokens to be spent.
172    */
173   function approve(address spender, uint256 value) public returns (bool) {
174     require(spender != address(0));
175 
176     _allowed[msg.sender][spender] = value;
177     emit Approval(msg.sender, spender, value);
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param from address The address which you want to send tokens from
184    * @param to address The address which you want to transfer to
185    * @param value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address from,
189     address to,
190     uint256 value
191   )
192     public
193     returns (bool)
194   {
195     require(value <= _balances[from]);
196     require(value <= _allowed[from][msg.sender]);
197     require(to != address(0));
198 
199     _balances[from] = _balances[from].sub(value);
200     _balances[to] = _balances[to].add(value);
201     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
202     emit Transfer(from, to, value);
203     return true;
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    * approve should be called when allowed_[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param spender The address which will spend the funds.
213    * @param addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseAllowance(
216     address spender,
217     uint256 addedValue
218   )
219     public
220     returns (bool)
221   {
222     require(spender != address(0));
223 
224     _allowed[msg.sender][spender] = (
225       _allowed[msg.sender][spender].add(addedValue));
226     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed_[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param spender The address which will spend the funds.
237    * @param subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseAllowance(
240     address spender,
241     uint256 subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     require(spender != address(0));
247 
248     _allowed[msg.sender][spender] = (
249       _allowed[msg.sender][spender].sub(subtractedValue));
250     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
251     return true;
252   }
253 
254   /**
255    * @dev Internal function that mints an amount of the token and assigns it to
256    * an account. This encapsulates the modification of balances such that the
257    * proper events are emitted.
258    * @param account The account that will receive the created tokens.
259    * @param amount The amount that will be created.
260    */
261   function _mint(address account, uint256 amount) internal {
262     require(account != 0);
263     _totalSupply = _totalSupply.add(amount);
264     _balances[account] = _balances[account].add(amount);
265     emit Transfer(address(0), account, amount);
266   }
267 
268   /**
269    * @dev Internal function that burns an amount of the token of a given
270    * account.
271    * @param account The account whose tokens will be burnt.
272    * @param amount The amount that will be burnt.
273    */
274   function _burn(address account, uint256 amount) internal {
275     require(account != 0);
276     require(amount <= _balances[account]);
277 
278     _totalSupply = _totalSupply.sub(amount);
279     _balances[account] = _balances[account].sub(amount);
280     emit Transfer(account, address(0), amount);
281   }
282 
283   /**
284    * @dev Internal function that burns an amount of the token of a given
285    * account, deducting from the sender's allowance for said account. Uses the
286    * internal burn function.
287    * @param account The account whose tokens will be burnt.
288    * @param amount The amount that will be burnt.
289    */
290   function _burnFrom(address account, uint256 amount) internal {
291     require(amount <= _allowed[account][msg.sender]);
292 
293     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
294     // this function needs to emit an event with the updated approval.
295     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
296       amount);
297     _burn(account, amount);
298   }
299 }
300 
301 contract GrowToken is ERC20 {
302     mapping (address => uint256) public balances;
303     
304     string public constant name = "GROW";
305     string public constant symbol = "GROW";
306     uint8 public constant decimals = 18;
307     
308     constructor() public {
309         _mint(0x4a9502bc2ab5b16f6f9c070c4c106c528f096e35, 415424733672870000000000);
310         _mint(0x08890e0307c73744ed8199e447662350cb41d483, 443250000000000000000);
311         _mint(0x4b65f5ca1ff68ec09ed555b5b5dc1b13bd1b04a9, 430383640500000000000);
312         _mint(0x1c77b4cc9ff2d359e28069cb2884319fcf0145ab, 430383640500000000000);
313         _mint(0x1a97f3766991a4fafa014a7f8ac27c3a0cab6f25, 420272151750000000000);
314         _mint(0xfd9317fb05cdb56075e5ed88e0f3974c83f55f98, 400500000000000000000);
315         _mint(0x7ab6b39c3f887cb781958719ab4e14a1b03a7074, 375000000000000000000);
316         _mint(0x112e88caa26d634463ce0a4446f438da41aa5e4f, 370324246875000000000);
317         _mint(0x0d24b5c9490f44da17a17ae0fdf95b7b6e15725c, 355500000000000000000);
318         _mint(0x84180c239ae7251084e4e3a8a4b64fe812e36c5b, 326000000000000000000);
319         _mint(0x52298ba85833337aa7ab2531a36723ca654c580d, 300000000000000000000);
320         _mint(0xfb6a2ae8f21d88ed6dec395a218fb64d1cb760eb, 300000000000000000000);
321         _mint(0xad204b796fa798444b45219a3c108c120fa39326, 300000000000000000000);
322         _mint(0x7e97e2c12b49618d39b20fd6ae55fe3933ff6792, 256875000000000000000);
323         _mint(0x47f6d11daa7835b2cab86df5eb73c814b64f5fbe, 239381371500000000000);
324         _mint(0x3956e4ab580acc35701510cfd2960e3e1b686ecb, 229500000000000000000);
325         _mint(0x89f54db67d472b61dd9f5a047821b57c37f68b2e, 225000000000000000000);
326         _mint(0x9e6c272606f920dcec3f6211c345d212233d3a69, 225000000000000000000);
327         _mint(0xf3542b5d6e4bfb4573f4cb50a4afa4090257945c, 225000000000000000000);
328         _mint(0x55dd83b68148adb3cf62caef553f81d7a244278c, 200000000000000000000);
329         _mint(0x19629a865f0be2511b72e6aaab0866540a3af6d4, 190180390500000000000);
330         _mint(0xb209b40a35f2df5382ae32bb379771dbf36eb0c8, 180314000000000000000);
331         _mint(0xd73944c99737350e88d285374f5293b7d6d48538, 169239000000000000000);
332         _mint(0xa3f6489c63d90ea3bd50af9b292c02b3f8ca234a, 157500000000000000000);
333         _mint(0xd36a8848464f528e64e27643f1a0cb2ef73e7285, 153000000000000000000);
334         _mint(0x4833cc6ba6c09670b03bed75e703dd313165527b, 145031541750000000000);
335         _mint(0x879af6824b204fc1dd5257111d653d3a1db2aca4, 135000000000000000000);
336         _mint(0xe82030dde634a66f0eebd5cc456bacdaed6d4571, 135000000000000000000);
337         _mint(0x7b219eee73589a6e7ec5caddafc18cabbe470f24, 118471810500000000000);
338         _mint(0x48560f768dad5704ca17fa504c35037447b600b8, 117000000000000000000);
339         _mint(0x6b6e12df9f16016e4ea355735b4a692b0016eaee, 112047975000000000000);
340         _mint(0x77f8f4993ca88f66c92cfc6627d6851c688bec28, 103500000000000000000);
341         _mint(0x16432d6c14b1935a1000c367cd87c30e00061852, 101000000000000000000);
342         _mint(0xc86d303fedcf623d933bf7298f72f6d7736a49ab, 100500000000000000000);
343         _mint(0xf390a5800fd30295c0fe04c15d64c44ce5ade647, 100000000000000000000);
344         _mint(0x41a533318fdc24bef36fb55df0245c09dd39637f, 100000000000000000000);
345         _mint(0x026a458f11a7306e29d10ce9e683c75f1419b2f7, 100000000000000000000);
346         _mint(0x777bd44b09d41b4d1783c2719ddb7af61bc46a2d, 100000000000000000000);
347         _mint(0x98298409c949135eed89233d04c2cfef984baff5, 99291001050000000000);
348         _mint(0x88650fdbfbb5c7933eb52008c4387050b963747d, 90000000000000000000);
349         _mint(0x45bd39eaccad70152befc8bb82feabd8bc2c83ad, 86716000000000000000);
350         _mint(0x216c0d426c1c213a23b4bbf16527b7c1f4a1332c, 82000000000000000000);
351         _mint(0x3ea6681677fc1b455d245de3d0bac781c5dd9d9b, 81000000000000000000);
352         _mint(0xb41d667826b37982e93ffb659069c58be2343efe, 81000000000000000000);
353         _mint(0x455d5ba93253e70f8db5ab8ccc2c477f280d5f4a, 79173900000000000000);
354         _mint(0xfe2307f3b87b65bd69c2652837788a84a4252752, 75000000000000000000);
355         _mint(0x2ba4cf2c2934d2814e773a8dcda6de4b60f23ccb, 68059285714000000000);
356         _mint(0x3edaa502f15bbe0e726bcdc1fcac341040e4103f, 67500000000000000000);
357         _mint(0x3b0231d42e7593cf8c9de9ce0bae34c4724ea9f0, 67176355529000000000);
358         _mint(0x2cc92ae3c085c460df8bcf787360abcc5999bfd7, 65000000000000000000);
359         _mint(0x6b2f3842d3f33f547da87d9334880cc1a304dfd5, 63000000000000000000);
360         _mint(0x60c35b469970fad46be401cfecffd3f96963f191, 62903785362000000000);
361         _mint(0x08afd610ee307D7dFBd4DA5803786B77C2867029, 61860746859279920100);
362         _mint(0xedb182bd13948eb26c824fc9f9f13d89c7a14d48, 61608882080000000000);
363         _mint(0xc3d59553f71909b280e7d2f0d7df1a116c904578, 59809234639000000000);
364         _mint(0x9f425144b3d68eb042214c557cd995209742c646, 59663338440000000000);
365         _mint(0x78c354eb226b02415cf7ec0d2f6f85e111dc5d0e, 58704170813000000000);
366         _mint(0x5960707ed20f095a7b85c25a78576ee2cdc17c34, 58500000000000000000);
367         _mint(0xd7837e2b1e851b18282a3ddc0182751f4e51a94e, 58366309340000000000);
368         _mint(0xd2f9aece546d29dfd244d85726721103bf4fe4b7, 57069280250000000000);
369         _mint(0x405ec278d0852aa7a208b5103d2bf98be1cd16fc, 51881163860000000000);
370         _mint(0xe78cf93be9b5207cbb78205aad999b703a378284, 50000000000000000000);
371         _mint(0x481704e6de801b6377226d5a181fe650dc36f748, 50000000000000000000);
372         _mint(0x9fd5a6e736a906500157fc365967e587d7caa8c1, 49626562500000000000);
373         _mint(0x9cf909749a982a74289014f0d0e7ff9b2bc969c6, 49000000000000000000);
374         _mint(0x3fc15766581f43de93872c532ed6d8097e06f6bf, 48615500000000000000);
375         _mint(0x711e7a3a04dda95ab035567de5f871169580114c, 45534320040000000000);
376         _mint(0x26352d20e6a05e04a1ecc75d4a43ae9989272621, 45500000000000000000);
377         _mint(0x93834ed7a0f228082df65e48d3bde6dd734f51ee, 45000000000000000000);
378         _mint(0x75d336920943ee1d593194998c11527d758ce046, 45000000000000000000);
379         _mint(0x87ad04d42cef2a3fa38564e7db4cd73ecd8bc47d, 43498847087000000000);
380         _mint(0x1231dd5ad7ac0a91405df5734bf0a4c445ad107b, 39914081100000000000);
381         _mint(0x18ef6b87b9d34b2bec50c5a64ecb642f5a842d8b, 38881337664000000000);
382         _mint(0x38acf1ccbc16c03bc41eec3ac38a64fddaefe4b9, 37500000000000000000);
383         _mint(0x0b307e177f5fe2a1c8bc91a6d8fa37b1197c9d91, 37500000000000000000);
384         _mint(0xa3fb69230c0dd58f8258b0e290fc32df1e0c6851, 35447544640000000000);
385         _mint(0x276ee18e57be90ef35e6a4d95059534bf7c94f70, 35000000000000000000);
386         _mint(0x65c527c9ef339ba5271a64b775fc07d83521986c, 34500000000000000000);
387         _mint(0x1f65cf9665c7cc95848443c74729269f29981483, 31469214367000000000);
388         _mint(0x946612839da3d4f594777ec8269f2d68c6703136, 29539620540000000000);
389         _mint(0x983b3cc24a74b4f45158f3d89969d04839dd2010, 28231999998000000000);
390         _mint(0x10ca552a3dfacbde6b91bd0f92ebafae4160a28e, 28231999997000000000);
391         _mint(0xc0068dc3364df7f9d185b9126c5a5befc0377c21, 27223714280000000000);
392         _mint(0x5fd21ad15f2e7e1c90f3aeff776f56f8e09178ab, 25000000000000000000);
393         _mint(0xb56c0c252274c157dc48967f2ad82debed0d6eb3, 24483768300000000000);
394         _mint(0xffb9a31520965ee021d634af67ea2ac6a1606bf3, 24198857139000000000);
395         _mint(0x6c91737157ed6543742ad744738959f24d57bc04, 23631696430000000000);
396         _mint(0x73a860381d5b3c63e2774c5b07aff04a2f5d2e8c, 22437882613000000000);
397         _mint(0x2dc208501f7e729a761867d05f077457bf6b44f5, 18149142858000000000);
398         _mint(0xf65e10e960137085f2643699103e83c174c8cca9, 17723772320000000000);
399         _mint(0x74dd3aa8de48b09b59776e0658b7ec1112d8105d, 17361429223000000000);
400         _mint(0x09b22e8b4bc2d2439684f4fa89c53ceffdf4eab1, 15502392854000000000);
401         _mint(0x2fe37fe20a4c35facbf51397f5b143b18c90e199, 13611857140000000000);
402         _mint(0x9ad5a70a6993a8d4d070a4f3b1dd633e720f670f, 13611857140000000000);
403         _mint(0x4a9502bc2ab5b16f6f9c070c4c106c528f096e35, 12845454472727274811);
404         _mint(0x5af12557f63145357a5752f861bcf7f27b3edd3e, 12734071466000000000);
405         _mint(0xc8c7576104bd1a7ff559bdba603c9bfeb941fe41, 11815848210000000000);
406         _mint(0xe0ac51a7b3bb12d7ce9004a6639a8c391ec3b6a1, 11815848210000000000);
407         _mint(0x8d12a197cb00d4747a1fe03395095ce2a5cc6819, 11815848210000000000);
408         _mint(0xb2719cf43423d0842597c2cb7321145b06f5d760, 11361809247000000000);
409         _mint(0xc87835975a7a91f9a970d9c8c6913f929f384d47, 11250000000000000000);
410         _mint(0xf9a2a30662b6f44f0bbd079c70c8687e3b08cdf0, 11000000000000000000);
411         _mint(0x0d065f710fe4254e187818f5117dab319fc4bdb8, 10395503504000000000);
412         _mint(0x2d694cb67e457f0e2574127f9f37da794d938de4, 10612348928000000000);
413         _mint(0x01f4a16a0ea3ab197db9276d76473b24a9a425aa, 10208892857000000000);
414         _mint(0x5620c0851d58fd55a411dadeb17c83dbb8e61b29, 10082857140000000000);
415         _mint(0xc12892b9f13a4d1e53f27892ffe5f8982b328578, 10000000000000000000);
416         _mint(0x7d5f5af2130985fe0fb5f2bfe38563ccfbeefe23, 9893123384000000000);
417         _mint(0x4775aa9f57be8c963eb1706573a70ccd489e1c45, 9651130214000000000);
418         _mint(0x9c29d669d0ba6bae5d0838176b057960de236ecc, 9148750095000000000);
419         _mint(0x26b98df7b4c76cd1face76cde5f7bcdae6ae4abd, 9148750095000000000);
420         _mint(0xd1ccee2b4c8af8bb69a1d47b8de22a2c73c04f7a, 9074571429000000000);
421         _mint(0xb101dc14c6012d4fac2025a8f1cdd4daf1d9f154, 9074571429000000000);
422         _mint(0x0169bbd117dd7f417ec944ae6cbf1c639ff9ded8, 9074571428000000000);
423         _mint(0x3603576f910ac545006eadbfee5798202ed07a45, 9074571428000000000);
424         _mint(0x5437090e9BBD624284c28C93325C79Ac48D14671, 9000000000000000000);
425         _mint(0xcaaddd51315832b2d244d3dda1ba39161471f36e, 8931904671000000000);
426         _mint(0x3b1e89f91934c78772b9cbc486650681fc965394, 8479820044000000000);
427         _mint(0x24bf5f007e4b06f5777c460fb02d3521c1b521a8, 8479820044000000000);
428         _mint(0xa33cf9154321dcf250ecee4519e0f0afbbdf1c5e, 8479820043000000000);
429         _mint(0x12be693054c534b2a03f65294a644111cbd02069, 8454672297000000000);
430         _mint(0xc592f48de2c33de713aaa614186929db982ee3f5, 8187531381000000000);
431         _mint(0xfe542662e344760afba1670b96552ab87bc8eccb, 7854144117000000000);
432         _mint(0x063a56d112e09d50f01f19da1128a84ec6f06d24, 7760594500000000000);
433         _mint(0xcd2ba98fa75b629302b3e919a49ef744eb639d59, 7760594500000000000);
434         _mint(0x2555844dabca25ed7a072cdefa5faf9747946a6c, 7735446754000000000);
435         _mint(0x56cc8cd2d60089aa6871982927ffacc7e32edf2d, 7735446754000000000);
436         _mint(0xf177015d46b43543b68fe39a0eba974944460f6a, 7735446754000000000);
437         _mint(0xdf7d8e7f0556820593aba352fa860fe8711f0c9f, 7644340062000000000);
438         _mint(0x89756a63fc68644c54b807b08ebfe902ff6238c3, 7543749077000000000);
439         _mint(0x491cf7629a2397eb738a120fb13fa44bdbdc0e44, 7482963381000000000);
440         _mint(0xbf540a5db97213da5e81c0a6ff196cca60d392e3, 7205763367000000000);
441         _mint(0xf008944a4ece209490294c49d8fb7413b33238c5, 7041368957000000000);
442         _mint(0x1277d142847aa24421e77caa04e6169b7a7a669e, 7041368957000000000);
443         _mint(0xfdebe49832881bcd2b9834f079cfeb7020a5eacf, 7041368957000000000);
444         _mint(0x3b985dcb066a8e69eb25c2e1ade62579266f6717, 7016221210000000000);
445         _mint(0x9b155a5a1d7852bd9e38acc8e8b685d35d3d77a3, 6991073465000000000);
446         _mint(0x2e04fa2e50b6bd3a092957cab6ac62a51220873c, 6988486839000000000);
447         _mint(0x5505647da72a10960b5eb7b7b4eb322d71c04bbe, 6322143413000000000);
448         _mint(0x6f626639eff3da66badda7d0df7433e91ea33e22, 6322143413000000000);
449         _mint(0x1d6e8b7bcad1c2cc89681a78ab95a84cce3fd77d, 6322143413000000000);
450         _mint(0x32c56e9ea8bcd3490116314983e779efcd00b2ea, 6322143413000000000);
451         _mint(0xd13711d8b1e219f85292dbc8adbdbbdfa92158cd, 6322143413000000000);
452         _mint(0xb23a04a3e08fffe865ab2ccc854379e1a5dca2f3, 6205888975000000000);
453         _mint(0xd3d6f9328006290f963676868e087d18c07d23a6, 6205888975000000000);
454         _mint(0x2a24dbbfab89afd43521e9cb29a3eb252b9a0598, 5836630934000000000);
455         _mint(0x2102fd3d7ee31c79693b6ac1cc9583adb9c068ed, 5753804348000000000);
456         _mint(0x6f0747f8f73e827c6eb31671e5b7cd4d6f5cbd93, 5753804348000000000);
457         _mint(0x258c00a4704cc967238d6d9c4535e8b5b5b8e2bf, 5753804348000000000);
458         _mint(0xe1ac09f269bf9634c7c7d76993a46408bfa21551, 5753804348000000000);
459         _mint(0x2d7ad46c8c2128b37f7bbf1d70f81db34d1176ba, 5653213363000000000);
460         _mint(0x148866e939eba8f045f6eb537f15567c2aef0930, 5600000000000000000);
461         _mint(0x0b113c3e4bc5d9d2414f26df14e7caf7b899192b, 5552622378000000000);
462         _mint(0x507b69c7185da5568f20aac0ce78fb61d7a85561, 5552622378000000000);
463         _mint(0xdb5f5ffc9d185d70c92358d6f7c49980410a7aac, 5552622378000000000);
464         _mint(0x90a29168953164a0bd48cba38098c7fdbac0714b, 5222109141000000000);
465         _mint(0x62ddca3fb71f2eb801dc0be789fa29b92cf07573, 5188116386000000000);
466         _mint(0x0a13a094477a7c83c6339c2f5fda4daa8f2cf956, 5171382543900000000);
467         _mint(0x8b71019b2438320bf98ab9b534fa59aff5f96c9c, 5034578804000000000);
468         _mint(0xd1d719a86c1b98e7865a08a9be82d78bc97ceef0, 5034578804000000000);
469         _mint(0xf457521dbbc94d05134ac346fc447b49ab56b9a8, 5034578804000000000);
470         _mint(0x6fa58e8f5ace80bbc84f5ca965e1684761b37db6, 4933987819000000000);
471         _mint(0x1dd4d1f2bc0a2bb1d64671d8a4ae50436329a5d7, 4767437888000000000);
472         _mint(0x3c567089fdb2f43399f82793999ca4e2879a1442, 4739847217800000000);
473         _mint(0x4a99129ce9faa5663ff615729c52fe94ab2ccbb0, 4606061207500000000);
474         _mint(0xc7c27359a6a46196a464259451342b6d2e344724, 4537285714000000000);
475         _mint(0xf1699e9a40ca86556a0761e63d3be71a35994fd3, 4537285714000000000);
476         _mint(0x7c285652d6282d09eef66c8acf762991e3f317a8, 4537285714000000000);
477         _mint(0x3f0cff7cb4ff4254031bcef80412e4cafe4aec7a, 4537285714000000000);
478         _mint(0x5796870edad7e3c6672cf24878b70214488d1127, 4537285714000000000);
479         _mint(0xf1b985500b41d6d8858afc4bbf98bc2b953f8da5, 4537285714000000000);
480         _mint(0x61502fedc97a9d0ee4a3d6bc0a3b86dd2dd41b75, 4537285714000000000);
481         _mint(0x8d392bf9aedf39788f576c6725bf3bea40d4d8a1, 4315353261000000000);
482         _mint(0x394c426b70c82ac8ea6e61b6bb1c341d7b1b3fe9, 4315353261000000000);
483         _mint(0x63fc75ea938d0294da3cd67e30878763b0e4a831, 4164466783000000000);
484         _mint(0x294805485402479ce9e7f8a6a5e07f37e62c4763, 3781071428000000000);
485         _mint(0x32b50a36762ba0194dbbd365c69014ea63bc208a, 3758079203400000000);
486         _mint(0xba5940750e625fc862fa99c88943ea1c6183cf2a, 3689677333000000000);
487         _mint(0x4d89dcb7273592b2c19f0722d6f95a7c8a70bfba, 3596127717000000000);
488         _mint(0x3633ab2e36b6196df1d1a7d75d0a56deacf067b8, 3470388986000000000);
489         _mint(0x15b334b8a6b355ee38ac5d48a59a511949c04961, 3470388986000000000);
490         _mint(0xa0c53c510299e9feb696f6354db7fd9dc61acd10, 3470388986000000000);
491         _mint(0xd1a22b3e103baa0c785e1d1efd8de0cf52eaa87d, 3084119603200000000);
492         _mint(0xac726fae68a156ac048f91f3bf62570de1aafe3b, 2876902174000000000);
493         _mint(0x94197076b6c60b49e342b1266f0127f95c64721a, 2876902174000000000);
494         _mint(0xb6fb13cb4ee0bb81ee5187fdb4e22ccce2c658f8, 2876902174000000000);
495         _mint(0x55f01dde141d8cba49ba29072e72e7c33542e15f, 2876902174000000000);
496         _mint(0xc890f4632dae3d01db77c37020a938200cf981f4, 2776311189000000000);
497         _mint(0x47e2db294f800e32da0eb2528e98318684be060b, 2301521739000000000);
498         _mint(0xdf0d80fb6eb6b6d7931d241677a55782a8ab24bb, 2301521739000000000);
499         _mint(0xd34e2dd306d73a4775fa39d8a52165cefa200fb8, 2301521739000000000);
500         _mint(0xa197c66fb29637069e9cdef0c417b171bb046758, 2157676630000000000);
501         _mint(0xdb39a479d928b0555040bca8a26c6998f6ff729b, 2157676630000000000);
502         _mint(0x221339dc33248043c2ab1dbeb2207d186e753a75, 2157676630000000000);
503         _mint(0x192a2c9ae6fc9a04bb696dbf547e695e8b8ee235, 2157676630000000000);
504         _mint(0xefa2427a318be3d978aac04436a59f2649d9f7bc, 2157676630000000000);
505         _mint(0xd5811c014ce871d3fc17409f6e71dca6ef270a1a, 2157676630000000000);
506         _mint(0xbe5e239cab7e6cae599ccb542820a68e9d86e13a, 2157676630000000000);
507         _mint(0x84d692957b449dca61f91828c634b8d96754feb0, 2157676630000000000);
508         _mint(0xcb9352cf5dcc70b3abc8099102c2319a6619aca4, 2157676630000000000);
509         _mint(0x8e4b8203f0ba472273b2cdd33acfa8bbc5ea4a62, 2157676630000000000);
510         _mint(0x4ed3b44a5fb462925fa96a27ba88466b97b2ca55, 2157676630000000000);
511         _mint(0x440f38ebd01da577ca9256a473f905502fed55f9, 1890535714000000000);
512         _mint(0x763a1667bbb919fe908c8091974a7115d540e875, 1890535714000000000);
513         _mint(0x7bfd4cc4f7645a65a1538c770f5093ffd012484e, 1890535714000000000);
514         _mint(0x34b116997c090eb67b1df177cf6bf9e8d1472b95, 1890535714000000000);
515         _mint(0xc423cc8456a4eec8c4c08676eaf2daff2eedeb54, 1890535714000000000);
516         _mint(0x3079faafb17b0365c4a2628847b631a2770932b6, 1890535714000000000);
517         _mint(0x25a0638c756bd62863a3949e1111e82ad920cb91, 1890535714000000000);
518         _mint(0xf39179ccf47c8338b046c5303724450ae49c6b87, 1890535714000000000);
519         _mint(0x88324d2bc04cbfaf1457a41dbeabc6c7c600e572, 1890535714000000000);
520         _mint(0x2a3b2c39ae3958b875033349fd573ed14886c2ee, 1890535714000000000);
521         _mint(0xcee19547774411577f46e7da69d431cf11a7c3a4, 1890535714000000000);
522         _mint(0x6b0fe6de273c848d8cc604587c589a847e9b5df8, 1890535714000000000);
523         _mint(0x52e07fa6d8843b44ffabdadbccaa861084c24c4e, 1890535714000000000);
524         _mint(0x19a87700ba2784cac43d2f6146ab699325b30e68, 1890535714000000000);
525         _mint(0xcf0f898682f0b390694d7284d80bd04c04ef2a8a, 1890535714000000000);
526         _mint(0xf372e020d37fd06a85096510dba408dec00f19e3, 1890535714000000000);
527         _mint(0x7a4391c790d097f972bf89c9035e89ec92a9adcf, 1890535714000000000);
528         _mint(0x314eed7e7edddd5f3364f057eaa7114483337ba0, 1890535714000000000);
529         _mint(0x89d5d673b99e89ce7f8a6f9dec80812db80e9944, 1890535714000000000);
530         _mint(0x13e1f430a90d26270ea057c69bde71351b6dd85f, 1890535714000000000);
531         _mint(0x4f746fc99c04f51a8a97350dcdc22a4159f0a17c, 1890535714000000000);
532         _mint(0x067be47f0d4b8380ff41321e0911a66b2b1f893e, 1890535714000000000);
533         _mint(0x9ca2c4e9d7c1ef97fb754d4c831025894659f9b6, 1726141304000000000);
534         _mint(0xe47bbeac8f268d7126082d5574b6f027f95af5fb, 1438451087000000000);
535         _mint(0xe7cc5676f8fed9e069ddc97f0b7289ea44588323, 1388155594000000000);
536         _mint(0x35753fc5b3e64973ac88120d4c6f0104290c9453, 1000000000000000001);
537         _mint(0xb69fba56b2e67e7dda61c8aa057886a8d1468575, 1000000000000000000);
538         _mint(0x398c0864c0549bf896c7f6b6baea3ca875ccd031, 719225543500000000);
539         _mint(0xdf38dd108bab50da564092ad0cd739c4634d963c, 708998950000000000);
540         _mint(0xfbee9020f96489f7e1dd89ee77b5dc01d569bd4f, 618700000000000000);
541         _mint(0x71c209b11362a00ffbfe8d4299b9ee7b39dc3008, 575380434800000000);
542         _mint(0x000e4f3624391d282ac8370cd1bbd7624e49dd57, 555262237800000000);
543         _mint(0xbd9bbbf52e24ed2fff5e7c5b66b80bbd062e3938, 143845108700000000);
544         _mint(0x08f616102a5c60e80907591a6cdb7360347180e5, 71607142000000000);
545         _mint(0x008cd39b569505e006ec93689add83999e96ab12, 39285809000000000);
546         _mint(0x282b48f9dea439bad4050d71999efffe62c84157, 20600000000000000);
547     }
548 }
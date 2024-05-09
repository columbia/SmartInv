1 pragma solidity ^0.4.24;
2 
3 /**
4 * @title SafeMath
5 * @dev Math operations with safety checks that throw on error
6 */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0 || b == 0) {
14             return 0;
15         }
16         c = a * b;
17         require(c / a == b, "Mul overflow!");
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         return c;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         require(b <= a, "Sub overflow!");
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         require(c >= a, "Add overflow!");
44         return c;
45     }
46 }
47 
48 // ----------------------------------------------------------------------------
49 // ERC Token Standard #20 Interface
50 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
51 // ----------------------------------------------------------------------------
52 contract ERC20Interface {
53 
54     string public name;
55     string public symbol;
56     uint8 public decimals;
57     uint256 public totalSupply;
58     function balanceOf(address _owner) external view returns (uint256);
59     function transfer(address _to, uint256 _value) external returns(bool);
60 
61     event Transfer(address indexed _from, address indexed _to, uint256 _value);
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Owned contract
66 // ----------------------------------------------------------------------------
67 contract Owned {
68 
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     modifier onlyOwner {
75         require(msg.sender == owner, "Only Owner can do that!");
76         _;
77     }
78 
79     function transferOwnership(address _newOwner)
80     external onlyOwner {
81         newOwner = _newOwner;
82     }
83 
84     function acceptOwnership()
85     external {
86         require(msg.sender == newOwner, "You are not new Owner!");
87         owner = newOwner;
88         newOwner = address(0);
89         emit OwnershipTransferred(owner, newOwner);
90     }
91 }
92 
93 contract Permissioned {
94 
95     function approve(address _spender, uint256 _value) public returns(bool);
96     function transferFrom(address _from, address _to, uint256 _value) external returns(bool);
97     function allowance(address _owner, address _spender) external view returns (uint256);
98 
99     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
100 }
101 
102 contract Burnable {
103 
104     function burn(uint256 _value) external returns(bool);
105     function burnFrom(address _from, uint256 _value) external returns(bool);
106 
107     // This notifies clients about the amount burnt
108     event Burn(address indexed _from, uint256 _value);
109 }
110 
111 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
112 
113 contract Aligato is ERC20Interface, Owned, Permissioned, Burnable {
114 
115     using SafeMath for uint256; //Be aware of overflows
116 
117     // This creates an array with all balances
118     mapping(address => uint256) internal _balanceOf;
119 
120     // This creates an array with all allowance
121     mapping(address => mapping(address => uint256)) internal _allowance;
122 
123     bool public isLocked = true; //only contract Owner can transfer tokens
124 
125     uint256 icoSupply = 0;
126 
127     //set ICO balance and emit
128     function setICO(address user, uint256 amt) internal{
129         uint256 amt2 = amt * (10 ** uint256(decimals));
130         _balanceOf[user] = amt2;
131         emit Transfer(0x0, user, amt2);
132         icoSupply += amt2;
133     }
134 
135     // As ICO been done on platform, we need set proper amouts for ppl that participate
136     function doICO() internal{
137 setICO(	0x5cD4c4F9eb8F323d64873C55b8da45f915A8256F	,	205750	);
138 setICO(	0x937f403B2f5cd0C17BEE8EF5DB1ecb2E3C793343	,	130500	);
139 setICO(	0x7503033e1B7AF4C1bc5Dd16B45b88ac08aF256f9	,	120300	);
140 setICO(	0x06010e8bc01446aBf39190F305B3740BE442aD88	,	100500	);
141 setICO(	0x51dB593c4ACC25b527c251E4fAc40C1d0C37559D	,	42500	);
142 setICO(	0xD11c70764B03fd23E451574a824af2104Bec5908	,	40000	);
143 setICO(	0x0c1610251B1Ac4180981D09bc795784beF44115d	,	39938	);
144 setICO(	0x91679f8Ab88a243f6F4387407fd11d75131CF3D4	,	35000	);
145 setICO(	0x1ac43DEC17B267d502cc257e5ab545Af6228ba94	,	21750	);
146 setICO(	0x7fC6cC49a4Dd2C56dBD062141b5D2e3563e4b873	,	20000	);
147 setICO(	0xF19051aD24B50C14C612515fFbd68f06097d014C	,	19909	);
148 setICO(	0x3B6E06351c1E1bD62ffdC47C4ada2fD18a819482	,	19868	);
149 setICO(	0x20A2018CdC1D9A4f474C268b6c20670C597487B2	,	16169	);
150 setICO(	0x2fEcDEedF64C49563E90E926c7F2323DF1ba09D2	,	15000	);
151 setICO(	0xc9b8f7c277551dA2759c2f655Ab8429564bA6a76	,	12500	);
152 setICO(	0x1F2245636D7CeA33f73E4CAa7935481122AF31b9	,	12000	);
153 setICO(	0xbb9cDa8148153103cbe8EE0227a8c7a84666AA13	,	11125	);
154 setICO(	0x43E4d827e518Dd960498BD105E9e76971e5965FC	,	10500	);
155 setICO(	0x588749e9395A1EE6A8C9A6fb182Ebdd2796B9f0f	,	10268	);
156 setICO(	0x7e35AA166a8c78B49e61ab280f39915d9BB51C40	,	10000	);
157 setICO(	0xa2aFF7b4aC8df3FB1A789396267e0fe55b7D8783	,	8622	);
158 setICO(	0x7Bee818d0FD6b9f3A104e38036cC4e872517e789	,	7840	);
159 setICO(	0x0D2CCA65Be1F274E69224C57790731FFC3D6b767	,	7000	);
160 setICO(	0x2Fe29a9C8Ae4C676af671270CaED159bCF2A153b	,	6854	);
161 setICO(	0x7c5c27274F1cD86849e7DDd47191e4C3cd1Fe273	,	6400	);
162 setICO(	0xcEE7bF213816c93e8C5d87a3CC6C21dF38D120A2	,	5500	);
163 setICO(	0x6C5e4C05AD042880053A183a9Aa204212f09Eb65	,	5500	);
164 setICO(	0xA29Ecf7b205928bD4d9dEdEbA24dDEbcFE8cb8aF	,	5500	);
165 setICO(	0x42dfe28873c01a8D128eAaEfc3bde9FEcF22647A	,	5500	);
166 setICO(	0xF78d102a7f3048B5d5927dcA76601d943526F37b	,	4800	);
167 setICO(	0xd4E30D7b48287a72Bc99c5ABe5AB8dDE8B608802	,	4500	);
168 setICO(	0xeDAA7f020467e77249F9d08d81C50c4e33eB063D	,	4500	);
169 setICO(	0x3f2a9614f217acF05A8d6f144aEE5c1fAD564C3D	,	4500	);
170 setICO(	0x8a170A75845E5F39Db826470A9f28c6A331BF2B6	,	4000	);
171 setICO(	0xFB3018F1366219eD3fE8CE1B844860F9c4Fac5e7	,	4000	);
172 setICO(	0x47A85250507EB1b892AD310F78d40D170d24FED1	,	4000	);
173 setICO(	0x22eeb1c4265F7F7cFEB1e19AF7f32Ec361a4710E	,	4000	);
174 setICO(	0x6384f2d17A855435E7517C29d302690Dc02421C2	,	3700	);
175 setICO(	0x93E7A5b9fa8e34F58eE8d4B4562B627C04eAD99b	,	3500	);
176 setICO(	0xe714E0CcFCE4d0244f7431B43080C685d1504Bd0	,	3500	);
177 setICO(	0x27ef607C8F1b71aF3Df913C104eD73Ed66624871	,	3310	);
178 setICO(	0xd5B82B5BcEA28A2740b8dA56a345238Fb212B623	,	3200	);
179 setICO(	0xAA2dc38E8bD38C0faaa735B4C0D4a899059f5a0d	,	3125	);
180 setICO(	0x40b95671c37116Bf41F0D2E68BD93aD10d25502E	,	3055	);
181 setICO(	0xCe14cf3bB404eDC02db6Ba2d8178b200A3031aeA	,	3010	);
182 setICO(	0x74b04A0198b68722Ca630D041E60303B655Bd6A8	,	3000	);
183 setICO(	0x5Ca403BB07e4e792400d165Fd716d939C35AB49B	,	3000	);
184 setICO(	0x6eA366425fa4b6Cf070472aCA6991e0731de9A0D	,	3000	);
185 setICO(	0x3eE6ba8E7B299443Cc23eff3B8426A33aD6a2121	,	3000	);
186 setICO(	0xdfCee0e4E371e02d7744E9eCA3Fa6269E116b1C9	,	6524	);
187 setICO(	0x42A44787FaD2C644201B6c753DBAE2d990dFb47c	,	3000	);
188 setICO(	0xB5F1090997630A5E233467538C40C0e2e259A916	,	2630	);
189 setICO(	0x1ACCcE2F80A3660e672Da9F24E384D6143AF0C03	,	2585	);
190 setICO(	0xa32DF0f819e017b3ca2d43c67E4368edC844A804	,	2553	);
191 setICO(	0x7dD71b315f12De87C1F136A179DB8Cc144b58295	,	2500	);
192 setICO(	0x822e1a575CC4ce8D17d29cA07C082929A6B8A3bB	,	2500	);
193 setICO(	0x1915F337099Ce25Ee6ED818B53fF1F7623e3123F	,	2340	);
194 setICO(	0x6dAE092fa57D05681e919563f4ee63F2f7F1D201	,	2000	);
195 setICO(	0xc3923D820881B1F189123008749427A481E983Ca	,	2000	);
196 setICO(	0x3f47469982dE2348e44C9B56dB275E26e9259f4D	,	1900	);
197 setICO(	0xF6A657925812fad72a6FB51f0Fbb5328d9BF8f31	,	1650	);
198 setICO(	0x6a8058555c57BC1C59dcE48202DaD700fAA17D26	,	1600	);
199 setICO(	0xF4d4C9E869604715039cbD3027AEC95d083f9265	,	1600	);
200 setICO(	0x5F6520231C1ad754C574b01f34A36619C5CA2a02	,	1500	);
201 setICO(	0xA81Ea58d0377AaC22C78CA61c631B7b0BFf2029f	,	1500	);
202 setICO(	0x43396e7DF304adeFEdFF3cb3BEe3dF55D1764928	,	1500	);
203 setICO(	0xCcfdaA5C4E355075D1628DfaF4030a397EF0e91E	,	1500	);
204 setICO(	0x7e40CB0937bdf37be20F68E8d759ffD1138968Ec	,	1853	);
205 setICO(	0x0B8fEA04316355de3F912fc5F7aa2A32235E8986	,	1300	);
206 setICO(	0x0F57D11a21Fe457bd59bbaf8848410Cc38003eef	,	1200	);
207 setICO(	0xff3850d80A748202Fb36EF680486d64DDAA493e9	,	1091	);
208 setICO(	0x8d54F232DF1fB84781286Ccffb0671D436B21DFF	,	1046	);
209 setICO(	0x8966636fE61E876Fc6499a6B819D56Af40433083	,	1039	);
210 setICO(	0x8B25A8f699F314ef3011122AD1d0B102e326367f	,	1006	);
211 setICO(	0x32ABe252Ea2CE4E949738495Ed51f911F835Fd53	,	1000	);
212 setICO(	0x67eb2a1cC74cC366DDE5aE88A5E4F82eF1a13B49	,	1000	);
213 setICO(	0x680C150689d6b981d382206A39fB44301b62F837	,	1000	);
214 setICO(	0x70D7c067C206f1e42178604678ff2C0C9fd58E66	,	1000	);
215 setICO(	0x65cc14dc596073750a566205370239e8e20268E4	,	1000	);
216 setICO(	0x887995731f3fd390B7eeb6aEb978900af410D48B	,	800	);
217 setICO(	0x5f3861ffc2e75D00BA5c19728590986f3FF48808	,	760	);
218 setICO(	0x9b6ac30F4694d86d430ECDB2cD16F3e6e414cBb2	,	640	);
219 setICO(	0x9d35e4411272DF158a8634a2f529DEd0fF541973	,	593	);
220 setICO(	0x27B48344ed0b7Aaef62e1E679035f94a25DF2442	,	508	);
221 setICO(	0x351313F49476Ed58214D07Bb87162527be34978e	,	500	);
222 setICO(	0xd96B785ba950ccf4d336FbDC69c2a82fB6c485B4	,	500	);
223 setICO(	0x7Eb37Ddd2b4Ed95Be445a1BCBf33b458e0e0103D	,	400	);
224 setICO(	0xCA83fBDe3197c93d4754bf23fe2f5c745a4DcAA0	,	350	);
225 setICO(	0xd162BdB296b99527D137323BEdF80a0899476a3b	,	345	);
226 setICO(	0x93773a596DfB4E0641dC626306c903a0552E05E7	,	340	);
227 setICO(	0x61014d61b734162745E0B9770be56F2d21460cE6	,	300	);
228 setICO(	0x0b48AEBA0e8Ab53820c6Cc25249bB0c6A09f3E2c	,	300	);
229 setICO(	0xe24526F12eA980c237d25F5aefc2fe3Aa5fc70cd	,	250	);
230 setICO(	0x34FCb220FACd2746433a312D113737fCc4B32B11	,	196	);
231 setICO(	0x7037c3521616Ca33F3362cC4a8ef29dc172cC392	,	150	);
232 setICO(	0xf0d9C8b7b1C94B67d90131Eb5444Ff4D9fE98eAd	,	150	);
233 setICO(	0x65ba8BAa1857578606f5F69E975C658daE26eDe5	,	100	);
234 setICO(	0xb19cB24d619608eFe8a127756ac030D56586Fc84	,	100	);
235 setICO(	0x18fa81c761Bf09e86cDcb0D01C18d7f8ceDbeCc3	,	100	);
236 setICO(	0x7a666D30379576Cc4659b5440eF787c652eeD11B	,	100	);
237 setICO(	0x1b0ccb9B9d74D83F1A51656e1f20b0947bd5927d	,	100	);
238 setICO(	0xA29Cd944f7bA653D35cE627961246A87ffdB1156	,	100	);
239 setICO(	0xA88677Bed9DE38C818aFcC2C7FAD60D473A23542	,	100	);
240 setICO(	0xC5ffEb68fb7D13ffdff2f363aE560dF0Ce392a98	,	50	);
241 setICO(	0xc7EFE07b332b580eBA18DE013528De604E363b64	,	38	);
242 setICO(	0xFcc9aCC9FC667Ad2E7D7BcEDa58bbacEa9cB721A	,	20	);
243 setICO(	0x9cdEBfF1F20F6b7828AEAb3710D6caE61cB48cd4	,	5	);
244 
245 
246     }
247 
248     /**
249     * Constructor function
250     *
251     * Initializes contract with initial supply tokens to the creator of the contract
252     */
253     constructor(string _symbol, string _name, uint256 _supply, uint8 _decimals)
254     public {
255         require(_supply != 0, "Supply required!"); //avoid accidental deplyment with zero balance
256         owner = msg.sender;
257         symbol = _symbol;
258         name = _name;
259         decimals = _decimals;
260         doICO();
261         totalSupply = _supply.mul(10 ** uint256(decimals)); //supply in constuctor is w/o decimal zeros
262         _balanceOf[msg.sender] = totalSupply - icoSupply;
263         emit Transfer(address(0), msg.sender, totalSupply - icoSupply);
264     }
265 
266     // unlock transfers for everyone
267     function unlock() external onlyOwner returns (bool success)
268     {
269         require (isLocked == true, "It is unlocked already!"); //you can unlock only once
270         isLocked = false;
271         return true;
272     }
273 
274     /**
275     * Get the token balance for account
276     *
277     * Get token balance of `_owner` account
278     *
279     * @param _owner The address of the owner
280     */
281     function balanceOf(address _owner)
282     external view
283     returns(uint256 balance) {
284         return _balanceOf[_owner];
285     }
286 
287     /**
288     * Internal transfer, only can be called by this contract
289     */
290     function _transfer(address _from, address _to, uint256 _value)
291     internal {
292         // check that contract is unlocked
293         require (isLocked == false || _from == owner, "Contract is locked!");
294         // Prevent transfer to 0x0 address. Use burn() instead
295         require(_to != address(0), "Can`t send to 0x0, use burn()");
296         // Check if the sender has enough
297         require(_balanceOf[_from] >= _value, "Not enough balance!");
298         // Subtract from the sender
299         _balanceOf[_from] = _balanceOf[_from].sub(_value);
300         // Add the same to the recipient
301         _balanceOf[_to] = _balanceOf[_to].add(_value);
302         emit Transfer(_from, _to, _value);
303     }
304 
305     /**
306     * Transfer tokens
307     *
308     * Send `_value` tokens to `_to` from your account
309     *
310     * @param _to The address of the recipient
311     * @param _value the amount to send
312     */
313     function transfer(address _to, uint256 _value)
314     external
315     returns(bool success) {
316         _transfer(msg.sender, _to, _value);
317         return true;
318     }
319 
320     /**
321     * Transfer tokens from other address
322     *
323     * Send `_value` tokens to `_to` on behalf of `_from`
324     *
325     * @param _from The address of the sender
326     * @param _to The address of the recipient
327     * @param _value the amount to send
328     */
329     function transferFrom(address _from, address _to, uint256 _value)
330     external
331     returns(bool success) {
332         // Check allowance
333         require(_value <= _allowance[_from][msg.sender], "Not enough allowance!");
334         // Check balance
335         require(_value <= _balanceOf[_from], "Not enough balance!");
336         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
337         _transfer(_from, _to, _value);
338         emit Approval(_from, _to, _allowance[_from][_to]);
339         return true;
340     }
341 
342     /**
343     * Set allowance for other address
344     *
345     * Allows `_spender` to spend no more than `_value` tokens on your behalf
346     *
347     * @param _spender The address authorized to spend
348     * @param _value the max amount they can spend
349     */
350     function approve(address _spender, uint256 _value)
351     public
352     returns(bool success) {
353         _allowance[msg.sender][_spender] = _value;
354         emit Approval(msg.sender, _spender, _value);
355         return true;
356     }
357 
358     /**
359     * Set allowance for other address and notify
360     *
361     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
362     *
363     * @param _spender The address authorized to spend
364     * @param _value the max amount they can spend
365     * @param _extraData some extra information to send to the approved contract
366     */
367     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
368     external
369     returns(bool success) {
370         tokenRecipient spender = tokenRecipient(_spender);
371         if (approve(_spender, _value)) {
372             spender.receiveApproval(msg.sender, _value, this, _extraData);
373             return true;
374         }
375     }
376 
377     /**
378     * @dev Function to check the amount of tokens that an owner allowed to a spender.
379     * @param _owner address The address which owns the funds.
380     * @param _spender address The address which will spend the funds.
381     * @return A uint256 specifying the amount of tokens still available for the spender.
382     */
383     function allowance(address _owner, address _spender)
384     external view
385     returns(uint256 value) {
386         return _allowance[_owner][_spender];
387     }
388 
389     /**
390     * Destroy tokens
391     *
392     * Remove `_value` tokens from the system irreversibly
393     *
394     * @param _value the amount of money to burn
395     */
396     function burn(uint256 _value)
397     external
398     returns(bool success) {
399         _burn(msg.sender, _value);
400         return true;
401     }
402 
403     /**
404     * Destroy tokens from other account
405     *
406     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
407     *
408     * @param _from the address of the sender
409     * @param _value the amount of money to burn
410     */
411     function burnFrom(address _from, uint256 _value)
412     external
413     returns(bool success) {
414          // Check allowance
415         require(_value <= _allowance[_from][msg.sender], "Not enough allowance!");
416         // Is tehere enough coins on account
417         require(_value <= _balanceOf[_from], "Insuffient balance!");
418         // Subtract from the sender's allowance
419         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
420         _burn(_from, _value);
421         emit Approval(_from, msg.sender, _allowance[_from][msg.sender]);
422         return true;
423     }
424 
425     function _burn(address _from, uint256 _value)
426     internal {
427         // Check if the targeted balance is enough
428         require(_balanceOf[_from] >= _value, "Insuffient balance!");
429         // Subtract from the sender
430         _balanceOf[_from] = _balanceOf[_from].sub(_value);
431         // Updates totalSupply
432         totalSupply = totalSupply.sub(_value);
433         emit Burn(msg.sender, _value);
434         emit Transfer(_from, address(0), _value);
435     }
436 
437     // ------------------------------------------------------------------------
438     // Don't accept accidental ETH
439     // ------------------------------------------------------------------------
440     function () external payable {
441         revert("This contract is not accepting ETH.");
442     }
443 
444     //Owner can take ETH from contract
445     function withdraw(uint256 _amount)
446     external onlyOwner
447     returns (bool){
448         require(_amount <= address(this).balance, "Not enough balance!");
449         owner.transfer(_amount);
450         return true;
451     }
452 
453     // ------------------------------------------------------------------------
454     // Owner can transfer out any accidentally sent ERC20 tokens
455     // ------------------------------------------------------------------------
456     function transferAnyERC20Token(address tokenAddress, uint256 _value)
457     external onlyOwner
458     returns(bool success) {
459         return ERC20Interface(tokenAddress).transfer(owner, _value);
460     }
461 }
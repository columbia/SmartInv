1 pragma solidity ^0.4.19;
2 
3 contract Ownable {
4 
5     /**
6      * @dev set `owner` of the contract to the sender
7      */
8     address public owner = msg.sender;
9 
10     /**
11      * @dev Throws if called by any account other than the owner.
12      */
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     /**
19      * @dev Allows the current owner to transfer control of the contract to a newOwner.
20      * @param newOwner The address to transfer ownership to.
21      */
22     function transferOwnership(address newOwner) public onlyOwner {
23         require(newOwner != address(0));
24         owner = newOwner;
25     }
26 
27 }
28 
29 library SafeMath {
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b <= a);
32         return a - b;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53     function allowance(address owner, address spender) public view returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64     using SafeMath for uint256;
65 
66     mapping(address => uint256) balances;
67 
68     /**
69     * @dev transfer token for a specified address
70     * @param _to The address to transfer to.
71     * @param _value The amount to be transferred.
72     */
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[msg.sender]);
76 
77         // SafeMath.sub will throw if there is not enough balance.
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] += _value;
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     /**
85     * @dev Gets the balance of the specified address.
86     * @param _owner The address to query the the balance of.
87     * @return An uint256 representing the amount owned by the passed address.
88     */
89     function balanceOf(address _owner) public view returns (uint256 balance) {
90         return balances[_owner];
91     }
92 
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107     /**
108      * @dev Transfer tokens from one address to another
109      * @param _from address The address which you want to send tokens from
110      * @param _to address The address which you want to transfer to
111      * @param _value uint256 the amount of tokens to be transferred
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] += _value;
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127      *
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param _spender The address which will spend the funds.
133      * @param _value The amount of tokens to be spent.
134      */
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Function to check the amount of tokens that an owner allowed to a spender.
143      * @param _owner address The address which owns the funds.
144      * @param _spender address The address which will spend the funds.
145      * @return A uint256 specifying the amount of tokens still available for the spender.
146      */
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151 }
152 
153 /**
154  * @title Mintable token
155  * @dev Simple ERC20 Token example, with mintable token creation
156  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
157  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
158  */
159 contract MintableToken is StandardToken, Ownable {
160     event Mint(address indexed to, uint256 amount);
161     event Burn(address indexed burner, uint value);
162     event MintFinished();
163 
164     bool public mintingFinished = false;
165 
166 
167     modifier canMint() {
168         require(!mintingFinished);
169         _;
170     }
171 
172     /**
173      * @dev Function to mint tokens
174      * @param _to The address that will receive the minted tokens.
175      * @param _amount The amount of tokens to mint.
176      * @return A boolean that indicates if the operation was successful.
177      */
178     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
179         totalSupply += _amount;
180         balances[_to] += _amount;
181         Mint(_to, _amount);
182         Transfer(address(0), _to, _amount);
183         return true;
184     }
185 
186     /**
187      * @dev Function to burn tokens
188      * @param _addr The address that will have _amount of tokens burned.
189      * @param _amount The amount of tokens to burn.
190      */
191     function burn(address _addr, uint _amount) onlyOwner public {
192         require(_amount > 0 && balances[_addr] >= _amount && totalSupply >= _amount);
193         balances[_addr] -= _amount;
194         totalSupply -= _amount;
195         Burn(_addr, _amount);
196         Transfer(_addr, address(0), _amount);
197     }
198 
199     /**
200      * @dev Function to stop minting new tokens.
201      * @return True if the operation was successful.
202      */
203     function finishMinting() onlyOwner canMint public returns (bool) {
204         mintingFinished = true;
205         MintFinished();
206         return true;
207     }
208 }
209 
210 contract WealthBuilderToken is MintableToken {
211 
212     string public name = "Wealth Builder Token";
213 
214     string public symbol = "WBT";
215 
216     uint32 public decimals = 18;
217 
218     /**
219      *  how many {tokens*10^(-18)} get per 1wei
220      */
221     uint public rate = 10**7;
222     /**
223      *  multiplicator for rate
224      */
225     uint public mrate = 10**7;
226 
227     function setRate(uint _rate) onlyOwner public {
228         rate = _rate;
229     }
230 
231 }
232 
233 contract Data is Ownable {
234 
235     // node => its parent
236     mapping (address => address) private parent;
237 
238     // node => its status
239     mapping (address => uint8) public statuses;
240 
241     // node => sum of all his child deposits in USD cents
242     mapping (address => uint) public referralDeposits;
243 
244     // client => balance in wei*10^(-6) available for withdrawal
245     mapping(address => uint256) private balances;
246 
247     // investor => balance in wei*10^(-6) available for withdrawal
248     mapping(address => uint256) private investorBalances;
249 
250     function parentOf(address _addr) public constant returns (address) {
251         return parent[_addr];
252     }
253 
254     function balanceOf(address _addr) public constant returns (uint256) {
255         return balances[_addr] / 1000000;
256     }
257 
258     function investorBalanceOf(address _addr) public constant returns (uint256) {
259         return investorBalances[_addr] / 1000000;
260     }
261 
262     /**
263      * @dev The Data constructor to set up the first depositer
264      */
265     function Data() public {
266         // DirectorOfRegion - 7
267         statuses[msg.sender] = 7;
268     }
269 
270     function addBalance(address _addr, uint256 amount) onlyOwner public {
271         balances[_addr] += amount;
272     }
273 
274     function subtrBalance(address _addr, uint256 amount) onlyOwner public {
275         require(balances[_addr] >= amount);
276         balances[_addr] -= amount;
277     }
278 
279     function addInvestorBalance(address _addr, uint256 amount) onlyOwner public {
280         investorBalances[_addr] += amount;
281     }
282 
283     function subtrInvestorBalance(address _addr, uint256 amount) onlyOwner public {
284         require(investorBalances[_addr] >= amount);
285         investorBalances[_addr] -= amount;
286     }
287 
288     function addReferralDeposit(address _addr, uint256 amount) onlyOwner public {
289         referralDeposits[_addr] += amount;
290     }
291 
292     function setStatus(address _addr, uint8 _status) onlyOwner public {
293         statuses[_addr] = _status;
294     }
295 
296     function setParent(address _addr, address _parent) onlyOwner public {
297         parent[_addr] = _parent;
298     }
299 
300 }
301 
302 contract Declaration {
303 
304     // threshold in USD => status
305     mapping (uint => uint8) statusThreshold;
306 
307     // status => (depositsNumber => percentage)
308     mapping (uint8 => mapping (uint8 => uint)) feeDistribution;
309 
310     // status thresholds in USD
311     uint[8] thresholds = [
312     0, 5000, 35000, 150000, 500000, 2500000, 5000000, 10000000
313     ];
314 
315     uint[5] referralFees = [50, 30, 20, 10, 5];
316     uint[5] serviceFees = [25, 20, 15, 10, 5];
317 
318 
319     /**
320      * @dev The Declaration constructor to define some constants
321      */
322     function Declaration() public {
323         setFeeDistributionsAndStatusThresholds();
324     }
325 
326 
327     /**
328      * @dev Set up fee distribution & status thresholds
329      */
330     function setFeeDistributionsAndStatusThresholds() private {
331         // Agent - 0
332         setFeeDistributionAndStatusThreshold(0, [12, 8, 5, 2, 1], thresholds[0]);
333         // SilverAgent - 1
334         setFeeDistributionAndStatusThreshold(1, [16, 10, 6, 3, 2], thresholds[1]);
335         // Manager - 2
336         setFeeDistributionAndStatusThreshold(2, [20, 12, 8, 4, 2], thresholds[2]);
337         // ManagerOfGroup - 3
338         setFeeDistributionAndStatusThreshold(3, [25, 15, 10, 5, 3], thresholds[3]);
339         // ManagerOfRegion - 4
340         setFeeDistributionAndStatusThreshold(4, [30, 18, 12, 6, 3], thresholds[4]);
341         // Director - 5
342         setFeeDistributionAndStatusThreshold(5, [35, 21, 14, 7, 4], thresholds[5]);
343         // DirectorOfGroup - 6
344         setFeeDistributionAndStatusThreshold(6, [40, 24, 16, 8, 4], thresholds[6]);
345         // DirectorOfRegion - 7
346         setFeeDistributionAndStatusThreshold(7, [50, 30, 20, 10, 5], thresholds[7]);
347     }
348 
349 
350     /**
351      * @dev Set up specific fee and status threshold
352      * @param _st The status to set up for
353      * @param _percentages Array of pecentages, which should go to member
354      * @param _threshold The minimum amount of sum of children deposits to get
355      *                   the status _st
356      */
357     function setFeeDistributionAndStatusThreshold(
358         uint8 _st,
359         uint8[5] _percentages,
360         uint _threshold
361     )
362     private
363     {
364         statusThreshold[_threshold] = _st;
365         for (uint8 i = 0; i < _percentages.length; i++) {
366             feeDistribution[_st][i] = _percentages[i];
367         }
368     }
369 
370 }
371 
372 contract Investors is Ownable {
373 
374     // investors
375     /*
376         "0x418155b19d7350f5a843b826474aa2f7623e99a6","0xbeb7a29a008d69069fd10154966870ff1dda44a0","0xa9cb1b8ba1c8facb92172e459389f80d304595a3","0xf3f2bf9be0ccc8f27a15ccf18d820c0722e8996a","0xa0f36ac9f68c1a4594ef5cec29dc9b1cc67f822c","0xc319278cca404e3a479b088922e4117feb4cec9d","0xe633c933529d6fd7c6147d2b0dc51bfbe3304e56","0x5bd2c1f2f06b16e427a4ec3a6beef6263fd506da","0x52c4f101d0367c3f9933d0c14ea389e74ad00352","0xf7a0d2149f324a0b607ebf23df671acc4e9da6d2","0x0418df662bb2994262bb720d477e558a59e19490","0xf0de6520e0726ba3d84611f84867aa9987391402","0x1e895274a9570f150f11ae0ed86dd42a53208b81","0x95a247bef71f6b234e9805d1493366a302a498e4","0x9daaeaf355f69f7176a0145df6d1769d7f14553b","0x029136181d87c6f0979431255424b5fad78e8491","0x7e1f5669d9e1c593a495c5cec384ca32ad4a09fc","0x46c7e04fdaaa1a9298e63ca2fd47b0004cb236bf","0x5933fa485863da06584057494f0f6660d3c1477c","0x4290231804dd59947aff9fcef925287e44906e7b","0x2feaf2101b3f9943a81567badb56e3780946ce3f","0x5b602c34ba643913908f69a4cd5846a07ed3915b","0x146308896955030ce3bcc6030bab142afddaa1e6","0x9fc61b75451fabf5b5b78e03bacaf8bb592541fc","0x87f7636f7856466b6c6bce999574a784387e2b78","0x024db1f560327ab5174f1a737caf446b5644c709","0x715c248e621cbdb6f091bf653bb4bc331d2f9b1e","0xfe92a23b497140ba055a91ade89d91f95f8e5153","0xc3426e0e0634725a628a7a21bfd49274e1f24733","0xb12a79b9dba8bbb9ed5e329466a9c2703da38dbd","0x44d8336749ebf584a4bcd636cefe83e6e0b33e7d","0x89c91460c3bdc164250e5a27351c743c070c226a","0xe0798a1b847f450b5d4819043d27a380a4715af8","0xeac5e75252d902cb7f8473e45fff9ceb391c536b","0xea53e88876a6da2579d837a559b31b08d6750681","0x5df22fac00c45ef7b5c285c54a006798f42bbc6e","0x09899f20064b5e67d02f6a97ef412564977ee193","0xc572f18d0a4a65f6e612e6de484dbc15b8839df3","0x397b9719e720c0d33fe7dcc004958e56636cbf82","0x577de83b60299df60cc7fce7ac78d3a5d880aa95","0x9a716298949b16c4610b40ba1d19e96d3286c35c","0x60ef523f3845e38a20b63344a4e9ec689773ead6","0xe34252e3efe0514c5fb76c9fb39ff31f554d6659","0xbabfbdf4f422d36c00e448cc562ce0f5dbe47d64","0x2608cca4aff4cc3008ac6bd22e0664348ecee088","0x0dd1d3102f89d4ee7c260048cbe01933f17debde","0xdbb28fafc4ecd7736247aca7dc8e20782ca86a7a","0x6201fc413bb9292527956a70e7575436d5135ce1","0xa836f4cfb8fd3e5bccc9c7a6a678f2a5928b7c79","0x85dce799fd059d86c420eb4e3c1bd89e323b7b12","0xdef2086c6bbdc8b0f6e130907f05345b44af8cc3","0xc1004695ce07ef5efb1d218672e5cfcb659c5900","0x227a5b4bb4cffc2b907d9f586dd100989efeee56","0xd372b3d43ba8ea406f64dbc68f70ec812e54fbc8","0xdf6c417cdb27bc0c877a0e121a2c58ad884e85c6","0x090f4d53b5d7ebcb8e348709cdb708d80cd199f0","0x2499b302b6f5e57f54c1c7a326813e3dffddcd1a","0x3114024a034443e972707522d911fc709f62dd3e","0x30b864f49cef510b1173a5bfc31e77b0b59daf9e","0x9a9680f5ddee6cef96ef36ab506f4b6d3198c35e","0x08018337b9b138b631cd325168c3d5014df6e18b","0x2ac345a4ec1615c3a236099ebbed4911673bbfa5","0x2b9fd54828cd443b7c411419b058b44bd02fdc49","0x208713a63460d44e5a83ae8e8f7333496a05065e","0xe4052eb7ba8891ee7ccd7551faaa5f4c421904e7","0x74bc9db1ac813db06f771bcff359e9237b01c906","0x033dd047a042ea873ca27af36b64ca566a006e97","0xb4721808a3f2830a1708967302443b53f5943429","0xc91fbb815c2f4944d8c6846be6ac0e30f5a037df","0x19ef947c276436ac11a8be15567909a37d824e73","0x079eefd69c5a4c5e4c9ee3fa08c2a2964da3e11a","0x11fb64be296590f948d56daab6c2d102c9842b08","0x06ec97feaeb0f4b9a75f9671d6b62bfadaf18ddd","0xaeda3cff45032695fb2cf4f584cda822bd5d8b7e","0x9f377085d3da85107cd68bd08bdd9a1b862d44e0","0xb46b8d1c313c52fd422fe189dde1b4d0800a5e0f","0x99039fa34510c7321f4d19ea337c80cc14cc885d","0x378aba0f47c7790ed0e5ca61749b0025d1208a5d","0x4395e1db93d4e2f4583a4f87494eb0aea057b8fd","0xa4035578750564e48abfb5ba1d6eec1da1bf366f","0xb611b39eb6c16dae3754e514ddd5f02fcadd765f","0x67d41491ddc004e899a3faf109f526cd717fe6d8","0x58e2c10865f9a1668e800c91b6a3d7b3416fb26c","0x04e34355ced9d532c9bc01d5e569f31b6d46cd50","0xf80358cabdc9b9b79570b6f073a861cf5567bb57","0xbdacb079fc17a00d945f01f4f9bd5d03cfcd5b6c","0x387a723060bc42a7796c76197d2d3b41b4c43d19","0xa04cc8fc56c34ab8104f63c11bf211de4bb7b0aa","0x3bf8b5ede7501519d41792715215735d8f40af10","0x6c3a13bac5cf61b1927562a927e89ca6b5d034d6","0x9899aecef15de43eec04859be649ac4c50330886","0xa4d25bac971ca08b47a908a070b6362102206c12"
377         "0xf88d963dc3f58fe6e71879543e57734e8152f70d","0x7b30a000f7ae56ee6206cbd9fb20c934b4bbb5d1","0xb2f0e5330e90559a738eda0df156635e18a145fd","0x5b2c07b6cce506f2293f1b32dc33d9928b8c9ada","0x5a967c0e38cb3bfad90df288ce238699cc47b5e3","0x0e686d6f3c897cae3984b80b5f6a7c785c708718","0xa8ea0b6bc70502644c0644fb4c0810540a1fa261","0xc70e278819ef5aec6b3ededc21e2981557e14443","0x477b5ae32ffcd34eb25f0c52866d4f602982dc6f","0x3e72a45fbc6a0858b506a0c7bedff79af75ae37c","0x1430e272a50703ef46d8ed5aa01e1ced71245341","0xc87d0bb90a6105a66fd5105c6746218d381b8207","0x0ed7f98b6177d0c15e27704f2bae4d068b8594d5","0x09a627b57879eb625cd8b7c59ffa363222553c23","0x0fdbc41046590ef7ee2a73b9808fd5bd7e189ac4","0x6a4b68af67a3b4a98fe1a59210dd3d775e567729","0x442a3daf774329fee3e904e86ddec1191f4be3ce","0x9efa8fe7fa51c8b36ab902046f879b035520f556","0x510e8e58b8ce4acaa6866e59dfc0fa339ea358e5","0x374831251283aa63aee6506ac6580479aaf3c22b","0xf758c498d020c0b92f2116d09d7ef6509c2c71bd","0xd83e8281ffcfb0ff96236e99ba66aabb8dcc7920","0x3670c3a5e65b757db8c82b12dd92057ac19d41fa","0xfd28eb7e3e5e3406ce6b82045d487c2be294cd38","0x2d23cd492096b903e4595ccdac74e49692a6ea8e","0x94d3a0a19ed5448052c549fd1f69f54c5f1fd8c5","0x8e5354ac59cee09d252e379a3534053306022ebe","0xa66f3700dda0147c56c2970202768c956c644ffd","0xf11d32baef6221f36916c58844cd8e9813c0af47","0x384a9bc1de23b36c2a23b963e57c8cd85b0d592c","0xbd00dfbaaa1abaa7948c7b2a6bed6e644293cc1c","0xa99a28afcbd4ab09a2ef2c0932becd0368225ee6","0xe554084d77bc6e510eed7276cb6033865375b669","0xe7582fa53531915a2fef5a81b98969d0091d8d44","0x5f15db1d209fa6fd3c667fb086d3d89e3793511f","0x7e9ff5348d57d3427e24b7e104ad5acf039edaf2","0xb4fb1a01483454d75a0cdfa983b99236c4c91111","0x4a7cc5eebfe019efab06c1fa9ae8453dc63ba84e","0xb6fc08d5043b51ac05cdbd88afaab0e4422762d0","0xb18365f4f1e95287a5f85c8a67cebee9e6164c31","0xaf575cfb94d65eaeaace749868282d0e26e4608a","0x3d07e5ff3a2d29ee17584dff60cc99bb4cd79c3d","0x08f0afc93fbc8188150f4bcab004e259cd4785aa","0x65ac3ed81f101e5651c72c4cc2d74650378b5b0c","0x58aef4fc6b54cb53683a6481655021109b8d4dce","0x6aa43e24604577574a0632524a1f4c21d70a61e2","0xbee55aa5ad9953294ecac83a6b62f10c8155444b","0x99dc885ac6ec9873e2409d5a31e7f525c1897e09","0x53a0622034680d64bd0f139df5e989d70b194a4d","0xa6ba4966f1fdd0e8560516e53490b25cf0c4fbd1","0xbd1b95ee4621ecda41961da61277e17e52f37dbf","0xf6481b881eea526ae36cbe11d58d641f96f04a77","0xd158d53d75eac0dda9d2dedf3418d071a2fd44ee","0xb22697e3f33544da7782c8197d07704e1906a3bf","0xa3237e67df409dca45930c1f5f671251adc202be","0x72b26f2dded753a01f391322b00f9a85a77c7fda","0x203fbf3a77bdf35f7aca220b363272896db91d57","0xb1be2f4d72eb87dfcf7ed93c8ec16e4040e52560","0xc60d8a0313ede22194ebe6285471f72f9bcdcda0","0x9888e7423ea48413a4c90a10c76ca5f90d065e1f","0x0be856768ad0ec5b45464ce5202e2c337224cebf","0x3b54ea00a74b116510c4f73a3fc19a62991aaf64","0xe72aa06ffe7058f73622f219af164369c03e3a41","0x7e71fada017d9af455f38db4957d527f51fe1bc5","0x78430e58934220f37ca6b9dbe622f076ad0eb3f5","0x0c765e201bb43d49ab5b44d40d3cf1d219424821","0x4739d251b40028761bbd8034a21919d926f23b45","0x00a7c7bc71022032f6ef3f699b212c9450875740","0x0d4f50b0d43d34a163b8dd7c33fbcc92a19cfa59","0x9284fbc0cc35d9b835de2b00b6b7093075527f6b","0x3564e101b32fe5f3c99e8da823ac003373c26d33","0xf5a358f228dc964fa7c703cb6ad9f6002ce77b17","0x8297a09b5dac9e60896c787f0995ac06441ab14f","0xed8c9b4fd60a6e4ae66c38f5819cffb360af5dd5","0x23009de4ec4a666ba719656d844e42e264e14c6b","0x63227f4492c6bbd9e1015f2c864a31eef1465cd3","0xf3e0ec409386ea202b15d97bb8dd2d131917e3b1","0x981154fafb3a5aeee43d984ee255e5121ce79790","0x49a4598cdf112b5848c11c465d39989fcb5cb6c1","0x575ca03f00f9e5566d85dc095165998953ab0753","0x09d87f2979c4ac6c9d4077d1f5d94cb9aadf43ca","0x0b4575867757b3982379f4d05c92fd2d019247a0","0x8c666d40e2ac961885d675e58e3115b859dac6c1","0x34a3401ebe8431d44efee9948c4b641142407aa8","0x1683512dbcce189ea6042862a2ba4abd4886623b","0x72d45f733336f6f03ef20c1ad4f51ff6b7f90186","0x569fe010fe2d40037c029537eef78aa9b0e018f9","0x061def9fab3aee4161711d4c040d138a273893b5","0xe77e2ae67e1152425c75ff56291d03d92f5d3cad","0x93ebdeb0b0c967f5cc1a10f481569e1871b7d7cd","0x6d7910f900fc3e3f2e2b6d5d8aad43bc6a232685","0xb16e28be300f579a81f2b80fdd5a95cf168bf3a4"
378         "0xd69835daeee01601ea991efe9fd0309c64c07d42","0x30b45ed69250a160ee91dadab2986d21626d7f4b","0xd28075489da5f9ef51bcc61668c114296a8e8603","0xb63c5cb479034bacc04266536e32aeeb9f958059","0x5f81fe78b5c238afd97a32c572aa04d87b730147","0xb98c8d7d64ef60cc76410f31c19570da0c4d9f12","0x031eb1c3a9909ea26d07f194abe5ad7f6945a482","0x83691573a4fdb5ff2cdbe2df155da09810a3c2bc","0x6722a482e1f3b797e69f98a3324b6660b9c6baa5","0xbda61db5824240280ed000a57ed5e6f70d552dd6","0x58605742105060e5c3070b88b0f51eca7f022d06","0xb4754815ccfc9c98a80f71a0a2c97471188bd556","0x50503144f253e6f05103b643c082ebf215436d95","0xd0dbef9f712ee0ca05fe48b6a40f5b774a109feb"
379     */
380     address[] public investors;
381 
382     // investor address => percentage * 10^(-2)
383     /*
384         3026,1500,510,462,453,302,250,250,226,220,150,129,100,100,60,50,50,50,50,50,50,50,50,50,50,40,40,30,27,26,25,25,25,25,25,25,25,25,23,20,19,15,15,15,15,15,14,14,13,13,13,13,12,12,11,11,11,11,11,11,10,10,10,10,10,10,10,10,12,9,9,8,8,8,8,7,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5
385         5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1,6
386         6,125,50,5,8,50,23,3,115,14,10,50,5,5
387     */
388     mapping (address => uint) public investorPercentages;
389 
390 
391     /**
392      * @dev Add investors
393      */
394     function addInvestors(address[] _investors, uint[] _investorPercentages) onlyOwner public {
395         for (uint i = 0; i < _investors.length; i++) {
396             investors.push(_investors[i]);
397             investorPercentages[_investors[i]] = _investorPercentages[i];
398         }
399     }
400 
401 
402     /**
403      *  @dev Get investors count
404      *  @return uint count
405      */
406     function getInvestorsCount() public constant returns (uint) {
407         return investors.length;
408     }
409 
410 
411     /**
412      *  @dev Get investors' fee depending on the current year
413      *  @return uint8 The fee percentage, which investors get
414      */
415     function getInvestorsFee() public constant returns (uint8) {
416         //01/01/2020
417         if (now >= 1577836800) {
418             return 1;
419         }
420         //01/01/2019
421         if (now >= 1546300800) {
422             return 5;
423         }
424         return 10;
425     }
426 
427 }
428 
429 contract Referral is Declaration, Ownable {
430 
431     using SafeMath for uint;
432 
433     // reference to token contract
434     WealthBuilderToken private token;
435 
436     // reference to data contract
437     Data private data;
438 
439     // reference to investors contract
440     Investors private investors;
441 
442     // investors balance to be distributed in wei*10^(2)
443     uint public investorsBalance;
444 
445     /**
446      *  how many USD cents get per ETH
447      */
448     uint public ethUsdRate;
449 
450     /**
451      * @dev The Referral constructor to set up the first depositer,
452      * reference to system token, data & investors and set ethUsdRate
453      */
454     function Referral(uint _ethUsdRate, address _token, address _data, address _investors) public {
455         ethUsdRate = _ethUsdRate;
456 
457         // instantiate token & data contracts
458         token = WealthBuilderToken(_token);
459         data = Data(_data);
460         investors = Investors(_investors);
461 
462         investorsBalance = 0;
463     }
464 
465     /**
466      * @dev Callback function
467      */
468     function() payable public {
469     }
470 
471     function invest(address client, uint8 depositsCount) payable public {
472         uint amount = msg.value;
473 
474         // if less then 5 deposits
475         if (depositsCount < 5) {
476 
477             uint serviceFee;
478             uint investorsFee = 0;
479 
480             if (depositsCount == 0) {
481                 uint8 investorsFeePercentage = investors.getInvestorsFee();
482                 serviceFee = amount * (serviceFees[depositsCount].sub(investorsFeePercentage));
483                 investorsFee = amount * investorsFeePercentage;
484                 investorsBalance += investorsFee;
485             } else {
486                 serviceFee = amount * serviceFees[depositsCount];
487             }
488 
489             uint referralFee = amount * referralFees[depositsCount];
490 
491             // distribute deposit fee among users above on the branch & update users' statuses
492             distribute(data.parentOf(client), 0, depositsCount, amount);
493 
494             // update balance & number of deposits of user
495             uint active = (amount * 100)
496             .sub(referralFee)
497             .sub(serviceFee)
498             .sub(investorsFee);
499             token.mint(client, active / 100 * token.rate() / token.mrate());
500 
501             // update owner`s balance
502             data.addBalance(owner, serviceFee * 10000);
503         } else {
504             token.mint(client, amount * token.rate() / token.mrate());
505         }
506     }
507 
508 
509     /**
510      * @dev Recursively distribute deposit fee between parents
511      * @param _node Parent address
512      * @param _prevPercentage The percentage for previous parent
513      * @param _depositsCount Count of depositer deposits
514      * @param _amount The amount of deposit
515      */
516     function distribute(
517         address _node,
518         uint _prevPercentage,
519         uint8 _depositsCount,
520         uint _amount
521     )
522     private
523     {
524         address node = _node;
525         uint prevPercentage = _prevPercentage;
526 
527         // distribute deposit fee among users above on the branch & update users' statuses
528         while(node != address(0)) {
529             uint8 status = data.statuses(node);
530 
531             // count fee percentage of current node
532             uint nodePercentage = feeDistribution[status][_depositsCount];
533             uint percentage = nodePercentage.sub(prevPercentage);
534             data.addBalance(node, _amount * percentage * 10000);
535 
536             //update refferals sum amount
537             data.addReferralDeposit(node, _amount * ethUsdRate / 10**18);
538 
539             //update status
540             updateStatus(node, status);
541 
542             node = data.parentOf(node);
543             prevPercentage = nodePercentage;
544         }
545     }
546 
547 
548     /**
549      * @dev Update node status if children sum amount is enough
550      * @param _node Node address
551      * @param _status Node current status
552      */
553     function updateStatus(address _node, uint8 _status) private {
554         uint refDep = data.referralDeposits(_node);
555 
556         for (uint i = thresholds.length - 1; i > _status; i--) {
557             uint threshold = thresholds[i] * 100;
558 
559             if (refDep >= threshold) {
560                 data.setStatus(_node, statusThreshold[threshold]);
561                 break;
562             }
563         }
564     }
565 
566 
567     /**
568      * @dev Distribute fee between investors
569      */
570     function distributeInvestorsFee(uint start, uint end) onlyOwner public {
571         for (uint i = start; i < end; i++) {
572             address investor = investors.investors(i);
573             uint investorPercentage = investors.investorPercentages(investor);
574             data.addInvestorBalance(investor, investorsBalance * investorPercentage);
575         }
576         if (end == investors.getInvestorsCount()) {
577             investorsBalance = 0;
578         }
579     }
580 
581 
582     /**
583      * @dev Set token exchange rate
584      * @param _rate wbt/eth rate
585      */
586     function setRate(uint _rate) onlyOwner public {
587         token.setRate(_rate);
588     }
589 
590 
591     /**
592      * @dev Set ETH exchange rate
593      * @param _ethUsdRate eth/usd rate
594      */
595     function setEthUsdRate(uint _ethUsdRate) onlyOwner public {
596         ethUsdRate = _ethUsdRate;
597     }
598 
599 
600     /**
601      * @dev Add new child
602      * @param _inviter parent
603      * @param _invitee child
604      */
605     function invite(
606         address _inviter,
607         address _invitee
608     )
609     public onlyOwner
610     {
611         data.setParent(_invitee, _inviter);
612         // Agent - 0
613         data.setStatus(_invitee, 0);
614     }
615 
616 
617     /**
618      * @dev Set _status for _addr
619      * @param _addr address
620      * @param _status ref. status
621      */
622     function setStatus(address _addr, uint8 _status) public onlyOwner {
623         data.setStatus(_addr, _status);
624     }
625 
626 
627     /**
628      * @dev Set investors contract address
629      * @param _addr address
630      */
631     function setInvestors(address _addr) public onlyOwner {
632         investors = Investors(_addr);
633     }
634 
635 
636     /**
637      * @dev Withdraw _amount for _addr
638      * @param _addr withdrawal address
639      * @param _amount withdrawal amount
640      */
641     function withdraw(address _addr, uint256 _amount, bool investor) public onlyOwner {
642         uint amount = investor ? data.investorBalanceOf(_addr)
643         : data.balanceOf(_addr);
644         require(amount >= _amount && this.balance >= _amount);
645 
646         if (investor) {
647             data.subtrInvestorBalance(_addr, _amount * 1000000);
648         } else {
649             data.subtrBalance(_addr, _amount * 1000000);
650         }
651 
652         _addr.transfer(_amount);
653     }
654 
655 
656     /**
657      * @dev Withdraw contract balance to _addr
658      * @param _addr withdrawal address
659      */
660     function withdrawOwner(address _addr, uint256 _amount) public onlyOwner {
661         require(this.balance >= _amount);
662         _addr.transfer(_amount);
663     }
664 
665 
666     /**
667      * @dev Withdraw corresponding amount of ETH to _addr and burn _value tokens
668      * @param _addr withdrawal address
669      * @param _amount amount of tokens to sell
670      */
671     function withdrawToken(address _addr, uint256 _amount) onlyOwner public {
672         token.burn(_addr, _amount);
673         uint256 etherValue = _amount * token.mrate() / token.rate();
674         _addr.transfer(etherValue);
675     }
676 
677 
678     /**
679      * @dev Transfer ownership of token contract to _addr
680      * @param _addr address
681      */
682     function transferTokenOwnership(address _addr) onlyOwner public {
683         token.transferOwnership(_addr);
684     }
685 
686 
687     /**
688      * @dev Transfer ownership of data contract to _addr
689      * @param _addr address
690      */
691     function transferDataOwnership(address _addr) onlyOwner public {
692         data.transferOwnership(_addr);
693     }
694 
695 }
696 
697 contract PChannel is Ownable {
698     
699     Referral private refProgram;
700 
701     // fixed deposit amount in USD cents
702     uint private depositAmount = 200000;
703 
704     // max deposit amount in USD cents
705     uint private maxDepositAmount =250000;
706 
707     // investor => number of deposits
708     mapping (address => uint8) private deposits; 
709     
710     function PChannel(address _refProgram) public {
711         refProgram = Referral(_refProgram);
712     }
713     
714     function() payable public {
715         uint8 depositsCount = deposits[msg.sender];
716         // check if user has already exceeded 15 deposits limit
717         // if so, set deposit count to 0 and make first deposit
718         if (depositsCount == 15) {
719             depositsCount = 0;
720             deposits[msg.sender] = 0;
721         }
722 
723         uint amount = msg.value;
724         uint usdAmount = amount * refProgram.ethUsdRate() / 10**18;
725         // check if deposit amount is valid 
726         require(usdAmount >= depositAmount && usdAmount <= maxDepositAmount);
727         
728         refProgram.invest.value(amount)(msg.sender, depositsCount);
729         deposits[msg.sender]++;
730     }
731 
732     /**
733      * @dev Set investors contract address
734      * @param _addr address
735      */
736     function setRefProgram(address _addr) public onlyOwner {
737         refProgram = Referral(_addr);
738     }
739     
740 }
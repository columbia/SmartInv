1 pragma solidity ^0.4.26;
2 
3 contract SafeMath {
4     // Overflow protected math functions
5 
6     /**
7         @dev returns the sum of _x and _y, asserts if the calculation overflows
8 
9         @param _x   value 1
10         @param _y   value 2
11 
12         @return sum
13     */
14     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
15         uint256 z = _x + _y;
16         require(z >= _x);        //assert(z >= _x);
17         return z;
18     }
19 
20     /**
21         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
22 
23         @param _x   minuend
24         @param _y   subtrahend
25 
26         @return difference
27     */
28     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
29         require(_x >= _y);        //assert(_x >= _y);
30         return _x - _y;
31     }
32 
33     /**
34         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
35 
36         @param _x   factor 1
37         @param _y   factor 2
38 
39         @return product
40     */
41     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
42         uint256 z = _x * _y;
43         require(_x == 0 || z / _x == _y);        //assert(_x == 0 || z / _x == _y);
44         return z;
45     }
46 	
47 	function safeDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
48 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
49         // uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51         return _x / _y;
52 	}
53 	
54 	function ceilDiv(uint256 _x, uint256 _y)internal pure returns (uint256){
55 		return (_x + _y - 1) / _y;
56 	}
57 }
58 
59 
60 contract Sqrt {
61 	function sqrt(uint x)public pure returns(uint y) {
62         uint z = (x + 1) / 2;
63         y = x;
64         while (z < y) {
65             y = z;
66             z = (x / z + z) / 2;
67         }
68     }
69 }
70 
71 contract ERC20Token {
72 	mapping (address => uint256) balances;
73 	address public owner;
74     string public name;
75     string public symbol;
76     uint8 public decimals = 18;
77 	// total amount of tokens
78     uint256 public totalSupply;
79 	// `allowed` tracks any extra transfer rights as in all ERC20 tokens
80     mapping (address => mapping (address => uint256)) allowed;
81 
82     constructor() public {
83         uint256 initialSupply = 10000000000;
84         totalSupply = initialSupply * 10 ** uint256(decimals);
85         balances[msg.sender] = totalSupply;
86         name = "Game Chain";
87         symbol = "GMI";
88     }
89 	
90     /// @param _owner The address from which the balance will be retrieved
91     /// @return The balance
92     function balanceOf(address _owner) public constant returns (uint256 balance) {
93 		 return balances[_owner];
94 	}
95 
96     /// @notice send `_value` token to `_to` from `msg.sender`
97     /// @param _to The address of the recipient
98     /// @param _value The amount of token to be transferred
99     /// @return Whether the transfer was successful or not
100     function transfer(address _to, uint256 _value) public returns (bool success) {
101 	    require(_value > 0 );                                      // Check send token value > 0;
102 		require(balances[msg.sender] >= _value);                   // Check if the sender has enough
103         require(balances[_to] + _value > balances[_to]);           // Check for overflows											
104 		balances[msg.sender] -= _value;                            // Subtract from the sender
105 		balances[_to] += _value;                                   // Add the same to the recipient                       
106 		 
107 		emit Transfer(msg.sender, _to, _value); 			       // Notify anyone listening that this transfer took place
108 		return true;      
109 	}
110 
111     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
112     /// @param _from The address of the sender
113     /// @param _to The address of the recipient
114     /// @param _value The amount of token to be transferred
115     /// @return Whether the transfer was successful or not
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117 	  
118 	    require(balances[_from] >= _value);                 // Check if the sender has enough
119         require(balances[_to] + _value >= balances[_to]);   // Check for overflows
120         require(_value <= allowed[_from][msg.sender]);      // Check allowance
121         balances[_from] -= _value;                         // Subtract from the sender
122         balances[_to] += _value;                           // Add the same to the recipient
123         allowed[_from][msg.sender] -= _value;
124         emit Transfer(_from, _to, _value);
125         return true;
126 	}
127 
128     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
129     /// @param _spender The address of the account able to transfer the tokens
130     /// @param _value The amount of tokens to be approved for transfer
131     /// @return Whether the approval was successful or not
132     function approve(address _spender, uint256 _value) public returns (bool success) {
133 		require(balances[msg.sender] >= _value);
134 		allowed[msg.sender][_spender] = _value;
135         emit Approval(msg.sender, _spender, _value);
136 		return true;
137 	
138 	}
139 	
140     /// @param _owner The address of the account owning tokens
141     /// @param _spender The address of the account able to transfer the tokens
142     /// @return Amount of remaining tokens allowed to spent
143     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145 	}
146 	
147 	/* This unnamed function is called whenever someone tries to send ether to it */
148     function () private {
149         revert();     // Prevents accidental sending of ether
150     }
151 
152     event Transfer(address indexed _from, address indexed _to, uint256 _value);
153     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
154 }
155 
156 contract UnlockGmi is SafeMath{
157     
158 //    using SafeMath for *;
159 	
160 	//list user
161 	mapping (address => uint256) private lockList;                         
162     bool            private             activated_;                                             // mark contract is activated;
163     uint256         private             activatedTime;
164 	
165 	ERC20Token      private             gmiToken;
166     
167 	mapping (address => uint256)  private takenTime;
168 	mapping (address => uint256)  private takenAmount;
169 	
170 	uint64          private             timeInterval;
171 	uint64          private             unLockedAmount;
172 	address         public              owner_;
173 	
174 
175 //==============================================================================
176 //     _ _  _  __|_ _    __|_ _  _  .
177 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
178 //==============================================================================
179     // constructor(address gmiTokeAddress) public {
180     //     gmiToken = ERC20Token(gmiTokeAddress);
181     //     timeInterval = 60 * 60 * 24;
182     //     unLockedAmount = 200;
183     //     initialize();
184     //     owner_ = msg.sender;
185     // }
186     constructor() public {
187         gmiToken = ERC20Token(0x03B267325193FD0c15cA0D2A693e54213C2AfCB6);
188         timeInterval = 60 * 60 * 24;
189         unLockedAmount = 200;
190         initialize();
191         owner_ = msg.sender;
192     }
193 	
194 	function initialize() private {
195 		lockList[0x876282c8809c300fB1ab10b451fb21F1600c27F0]  = 19574        * 10 ** 18;    
196       lockList[0xa5bC6Eca62ec7bd910753d01e2dD310D465E7a22]  = 197903       * 10 ** 18;
197       lockList[0x71A07b9f65A9008b867584c267D545aFF5c8c68f]  = 1014         * 10 ** 18;
198       lockList[0x0531c9018a7ff16a9c16817ea6bc544d20abf94b]  = 11838        * 10 ** 18;
199       lockList[0x2Ba00DC6Ca55CF9632978D3c38495a8ae52FbeD1]  = 2146         * 10 ** 18;
200       lockList[0xae0b391429b0e2169abe4f030ea3700922e2696b]  = 1816         * 10 ** 18;
201       lockList[0x3d703c1ada6f12b19DF5BC3c3CDd94F6bE16fc0a]  = 4470         * 10 ** 18;
202       lockList[0x819953b03815F529e879AEF3344746942BBBe0cE]  = 13087        * 10 ** 18;
203       lockList[0x290BA7bA59d6915eC8E7300581B9fD35c09D9808]  = 15434        * 10 ** 18;
204       lockList[0x3af35E26a83c053bC5958160788Fc8a5783FAEaf]  = 4521         * 10 ** 18;
205       lockList[0x3ca492b82978A9FB293410b254B49b24F0E43124]  = 6404         * 10 ** 18;
206       lockList[0x59e5def48b51b1d3619dea0908b51cafa36bc32c]  = 10344        * 10 ** 18;
207       lockList[0x56453D2139F9Fdd6e1Ec40d5370BA03dD4822537]  = 4876         * 10 ** 18;
208       lockList[0xEC68B77c7231f7C8A0aF27251c5a8F05819D99A3]  = 11632        * 10 ** 18;
209       lockList[0x12A3f50dDA438854491ae7CEe713D21254Bf4831]  = 418          * 10 ** 18;
210       lockList[0x811Ff6C39f75dD3FAAeCb35C0bEcBa09AaE5ea50]  = 24534        * 10 ** 18;
211       lockList[0x1105A96F7023AA1320b381Bb96ac7528B6De08A5]  = 1059         * 10 ** 18;
212       lockList[0x7Da0eCc11BF1baB6f80c91525F00E8CF12a0Ce80]  = 38089        * 10 ** 18;
213       lockList[0xf0c6Be88F289Fc1fC3e4BB25BA6C32D120556612]  = 1759         * 10 ** 18;
214       lockList[0xD7dD9514Ac84c537526d7fBa9DB39b301369419b]  = 5770         * 10 ** 18;
215       lockList[0xe995b1c4f73212ab9122e13d40f8227824a7d134]  = 1802         * 10 ** 18;
216       lockList[0xd2309C4ae9Cf8E7F8680c3B87320a2b6Be702435]  = 5428         * 10 ** 18;
217       lockList[0x7f2876eaD16E6fee63CF20412e18F4F1B1bF7e7e]  = 6723         * 10 ** 18;
218       lockList[0x739411622fB2d07B3d54905846E3367653F4578e]  = 709          * 10 ** 18;
219       lockList[0xe50E01F2b901AD6eAA6bcF2182e47e5EF91f4f1c]  = 22722        * 10 ** 18;
220       lockList[0x048CCb21e664CFD700c4D5492feaed8e86895c62]  = 753          * 10 ** 18;
221       lockList[0xDbc6E2fa275bF5d7762eEa2401ddC93a324feb17]  = 16838        * 10 ** 18;
222       lockList[0x83f4f537b01e368e4dce5520c5E869271e3FA90f]  = 77           * 10 ** 18;
223       lockList[0x61CFB88085f848f5685c937E7cb7A18d76802709]  = 1448         * 10 ** 18;
224       lockList[0x028f9c71fE9cb17fBd32D72159604Fa0b64579A0]  = 8532         * 10 ** 18;
225       lockList[0xe4Dc73D6cb05370e9C539aDB7DBf4F330A3Cc663]  = 451          * 10 ** 18;
226       lockList[0xF37425eD1E3Eb4a01649fE136D858456d5e37020]  = 93068        * 10 ** 18;
227       lockList[0x7d465899B2909d95a1293F4301DB5fC55f5B5008]  = 784          * 10 ** 18;
228       lockList[0xe1ac511d43b238EAffdEd35e1F1060a20e7dE87C]  = 22607.8125   * 10 ** 18;
229       lockList[0xDdd540e1F4fDb157164597621B236D2650428d3c]  = 760          * 10 ** 18;
230       lockList[0x02ff817036529c72572eCfE4e48d532daC9AF777]  = 19475.7      * 10 ** 18;
231       lockList[0x9B51Ee9F220590448bB11BcdEd2091d185257e1c]  = 1289         * 10 ** 18;
232       lockList[0xEbD6b840d186808AadEfa8d6B0879FFEc965CC3b]  = 6360.8       * 10 ** 18;
233       lockList[0xe9687b4633660BF831A7cEdCFe6b2f8Ad695C060]  = 2750.7       * 10 ** 18;
234       lockList[0x96E3544A58297bB7C0eBB484280000220d64b483]  = 2984         * 10 ** 18;
235       lockList[0xA9dDedfF71811EF9C7Ff6d5C6A800C4AB0B829A6]  = 12350        * 10 ** 18;
236       lockList[0x6aa92ffEAD98370d8E86FAD42A4e300F614C154c]  = 55074        * 10 ** 18;
237       lockList[0x7E4F8be3EcA8c31AAe3a955bb43Afc0c8Ab5bfaC]  = 579          * 10 ** 18;
238       lockList[0x0067478F0aC9DF5fd513C7c5e10C3734cc95a2Bf]  = 6161.5       * 10 ** 18;
239       lockList[0x27d2B31ded839ad94a3f637bA56A70Cd9Ae2B282]  = 1085         * 10 ** 18;
240       lockList[0x335E44383F620D3e7647C4B2d97c6d6589979fEe]  = 13264        * 10 ** 18;
241       lockList[0xD29E97b3940Cb2b2f241FEc7192bf25db34CE4FB]  = 5891         * 10 ** 18;
242       lockList[0xf7026196DEacF2584636933C4918395D6E7f072B]  = 1728         * 10 ** 18;
243       lockList[0xAf02B81eAafC2103662F3Abaf63Fc1cc3a39F8F3]  = 15324        * 10 ** 18;
244       lockList[0xCe5dc41E2bDB3343df281faf6043e9C83e42946F]  = 2048         * 10 ** 18;
245       lockList[0x2e161fab552e23849b219c37B237cA3e46FFE190]  = 10664        * 10 ** 18;
246       lockList[0x948882468fecb578955575a65331abefc2820445]  = 1356         * 10 ** 18;
247       lockList[0x2eDeB8a0aa363f11dDCBCdaD7170b2dd6888b8B7]  = 1095         * 10 ** 18;
248       lockList[0x8B4A431805DDE778EEC6BE62F15FCAAB49180349]  = 589          * 10 ** 18;
249       lockList[0x0F507a26F1f66761630b814974cA22f0aeEB025b]  = 6623         * 10 ** 18;
250       lockList[0xD8467a842D4974f8460D35c0D68d27f46212FC42]  = 11781        * 10 ** 18;
251       lockList[0x2f4b7eAA5348aB80CBF0845316fD2f5EdC8CcBB7]  = 22015        * 10 ** 18;
252       lockList[0x7029B37167d15051f3E82467Bf8E3Be2a9f5eB66]  = 7671         * 10 ** 18;
253       lockList[0x426de357613E1A096285DC7A9b1E4D960532dc77]  = 1191         * 10 ** 18;
254       lockList[0xFd39138e6b4df493c22f3D45Cf675d37a53E8e59]  = 3100         * 10 ** 18;
255       lockList[0xe0b8a2499804B466b210d1350412DD65a6DA7644]  = 23195        * 10 ** 18;
256       lockList[0xa5440b5b3786a6a551aa52464088380a4c94cc5c]  = 16281        * 10 ** 18;
257       lockList[0x398626e5b5D43F12C2E1f752521C31cEA6F67Edd]  = 10608        * 10 ** 18;
258       lockList[0x33f8255f707cbb9b81561271058e264870F2932E]  = 8650         * 10 ** 18;
259       lockList[0x52f2a2CA11562bd804E21Ae8CE24FAc1592F8d5B]  = 7012         * 10 ** 18;
260       lockList[0x2c87a13b8f4ac9ccfc84d0cf192b7b250449f814]  = 3728         * 10 ** 18;
261       lockList[0x5df29645580d23c7ee79387e55ae14250c5a2ef2]  = 8520         * 10 ** 18;
262       lockList[0xc916e3de378d12e15ca68c5740e78cad6d319620]  = 600          * 10 ** 18;
263       lockList[0x9667cb2f8cd6858d97cfb78a751ae93869498b90]  = 1037         * 10 ** 18;
264       lockList[0xe09eC6ed709050171a6b640decC8a02e2F6E4CA4]  = 1488         * 10 ** 18;
265       lockList[0xD4F4bEfeadbE319428F95c4496668d5499f6B3A6]  = 3350         * 10 ** 18;
266       lockList[0x5a55368b29c238574A41d4d9513be9b5F6cE261f]  = 12153        * 10 ** 18;
267       lockList[0x7BC569164Af97a4122d6c889d944ce222ef4318D]  = 4326         * 10 ** 18;
268       lockList[0x684292690C546EAA7c6A37b6923d8C3d823d7ec4]  = 494          * 10 ** 18;
269       lockList[0x9523fb6dbfcb91627714cfd41ed27d0dbf9d0288]  = 8085         * 10 ** 18;
270       lockList[0xA5C9387746D9dad02AA8D9d8bBC85f1Cc60251DD]  = 7499         * 10 ** 18;
271       lockList[0x3425f8f253C30905A4126f76c88358e9433BD23B]  = 16984        * 10 ** 18;
272       lockList[0x39eA9690d8986b99047d7980e22eE7BBd20bBb36]  = 6205         * 10 ** 18;
273       lockList[0x0316DdD222513626f6F07c0Ea9Aa76d119dbA597]  = 3538         * 10 ** 18;
274       lockList[0x0d7ba208cfbdb009164fb5e60a528c62d80c3d2e]  = 119905       * 10 ** 18;
275       lockList[0x6b7bF976b100df64bFC5ba541d26C1fE81C6BB1a]  = 6571         * 10 ** 18;
276       lockList[0xF58928F2d1c07D4f37B7f35c36A573825104117A]  = 42424        * 10 ** 18;
277       lockList[0x4B4064395Fc0B6E35CD7CC79FB324CF9115Dbd7D]  = 12564        * 10 ** 18;
278       lockList[0x07e91aa302cb997d1524f58c0c67818bc7e9d85a]  = 200          * 10 ** 18;
279       lockList[0x30e5E26E2b562946faf38aad8510BF4065fD351f]  = 1394         * 10 ** 18;
280       lockList[0xfbb010c3b9216c1f5ac95587fbcefe6ec2476d14]  = 47216        * 10 ** 18;
281       lockList[0xD79067c91e542725a2CBDafe02C9200aF34A75C5]  = 2248         * 10 ** 18;
282       lockList[0xc491e8aac8ad3b78bc031eb0544a3feda753ed71]  = 3195         * 10 ** 18;
283       lockList[0x4bD5258e6c4f200c8739c0de25C1BaaF4f0dd0A9]  = 8238         * 10 ** 18;
284       lockList[0xe0f11d27a4e0d2c176562cab178898b253c2519e]  = 1293         * 10 ** 18;
285       lockList[0x1599C57a7C89fb0B57De341245CB30b5a362bcb9]  = 19581        * 10 ** 18;
286       lockList[0xc561DDad555F2D4590c6C234aa8eaD077557E861]  = 11484        * 10 ** 18;
287       lockList[0xFD3A02E8AE8615614d4D29bf0132f4F5Cd0C92b9]  = 20438        * 10 ** 18;
288       lockList[0x633b71915eAD4Ee98cBA4E605d1B93bB48f87dE9]  = 275          * 10 ** 18;
289       lockList[0x9BAf29D4D23756Dd93Cb090D656CeA490D28A410]  = 3140         * 10 ** 18;
290       lockList[0xc17e4c0cABe3915E52a750acC8847F77b98C6CAF]  = 5281         * 10 ** 18;
291       lockList[0xc79eae229e131ca04722e9b4e77f75190cfe6eb8]  = 3657         * 10 ** 18;
292       lockList[0x9954e6f38F248d3Bd213a55cDe2f53b3459680dD]  = 406          * 10 ** 18;
293       lockList[0x6390A8807fa00551cBFdBf91ce2c06af2fFC0cCA]  = 225          * 10 ** 18;
294       lockList[0xf430eE763C83bbAd5b072EaE9435EE228A63A888]  = 16249        * 10 ** 18;
295       lockList[0xA7135f955BE175910E3e08048527b7ea387a881E]  = 3738         * 10 ** 18;
296       lockList[0x68638F00c7A24dC8c1968345de50d69BA74FFa21]  = 1803         * 10 ** 18;
297       lockList[0x713D2599e96Ae8Ec037A0E903B4A801Dec416aC0]  = 9160         * 10 ** 18;
298       lockList[0x2fED4396Ee204a448201fAB980f1C90018e22801]  = 302122       * 10 ** 18;
299       lockList[0x3cC8291F32a07aC9D0D9887eEc7331bD273c613B]  = 1142882      * 10 ** 18;
300       lockList[0xef6607FafE4406dD1698865aC89BcBc22323e853]  = 139708       * 10 ** 18;
301       lockList[0x1b15FD6FeaecC11B44D689b7B1C2471207a26a23]  = 116678       * 10 ** 18;
302       lockList[0xe813fe32aBd2f47c5010426d259e2372e526021C]  = 103784       * 10 ** 18;
303       lockList[0x253f9FAb9dCB4a64ceF5b3320eB9F28163924DF9]  = 71770        * 10 ** 18;
304       lockList[0x3aa9230bF5deD1c72aa4083B6137ADC7955B5a1a]  = 114020       * 10 ** 18;
305       lockList[0xe37079253aDa30eeF49f65EFd48608A4C15F614D]  = 503303       * 10 ** 18;
306       lockList[0x89Ad15DfCDe37dCF1C7C8582d8ff7F195796EB7B]  = 164803       * 10 ** 18;
307       lockList[0xD063C6f99F221Df40D1F15A1d5D6a477573f8092]  = 31460        * 10 ** 18;
308       lockList[0x8Ef20D2388606Fd4E6ef0f0f070a63c5c655626c]  = 681715       * 10 ** 18;
309       lockList[0x632A8a687C5c99556117650641B3ACB299ba070f]  = 458888       * 10 ** 18;
310       lockList[0x8901A17d3964214D501F9C8B015854d037d90fEf]  = 831815       * 10 ** 18;
311       lockList[0xDF5662248182270da3b7582d303CFb2d5E62ec23]  = 1257794      * 10 ** 18;
312       lockList[0x1f5a6da1dfd6645eb4f3afc0d4e457aac95c8776]  = 1014032      * 10 ** 18;
313       lockList[0xb1FA3A4c4CEEc881Ec3B4f50afa4d40a20353385]  = 339020       * 10 ** 18;
314       lockList[0x7F3D90153259c49887d55E906af3336c38F814A9]  = 421571       * 10 ** 18;
315       lockList[0x9c6fc8Eb31B67Cc9452c96B77DdCb5EF504CDa81]  = 119204       * 10 ** 18;
316       lockList[0xD9c1F9347785dc2E79477E20E7d5e5b7866deF35]  = 178954       * 10 ** 18;
317       lockList[0xa4FEf4Cc6f63E5Ea0A2F3044EA84b9a1EACeAE5e]  = 139148       * 10 ** 18;
318       lockList[0x3Ae9e2E7fEA9031eE85facbBc26794b079b3dCd9]  = 1940127      * 10 ** 18;
319       lockList[0x901AD29A0e95647525137E2af782C517375D37C4]  = 4750115      * 10 ** 18;
320       lockList[0xbff165E4549bfcea5F150FC5ee04cC8dA4dCAe5d]  = 59902        * 10 ** 18;
321       lockList[0x09c09b03563B6Be9104Da38890468C0D9A98C691]  = 2729048      * 10 ** 18;
322       lockList[0x400D5Fd9A30C3f524931F82C687cacB6C4054F41]  = 610952       * 10 ** 18;
323       lockList[0x054C0a11804Ad1116290CF14EE23Ad59F3d0925e]  = 376660       * 10 ** 18;
324       lockList[0xB80ab7AAb74731243fE13d5c6Eb87223CfaDA59b]  = 73479        * 10 ** 18;
325       lockList[0xb1DbcBd1705938546e1eBa520332B4c164878965]  = 68520        * 10 ** 18;
326       lockList[0x4e961A68d3dafff6D4d863d21fba6Fff82b25d5c]  = 10000        * 10 ** 18;
327       lockList[0x097515d2570baBbDa32e5caF23a765e574cDc6B1]  = 50683        * 10 ** 18;
328       lockList[0xb2aCA30Ae71d146aad0422a141e3eF0B9313A4bc]  = 25158        * 10 ** 18;
329       lockList[0x8Ab96a4778BB5b7E6839059D2988e846A749E9ED]  = 67043        * 10 ** 18;
330       lockList[0x7e5177Bd22D9e64AfEBD4F06DdD4C6F6bFccc548]  = 113495       * 10 ** 18;
331       lockList[0xd3A8bBBc7eeAF8422C791A3d046Fa773E972bAe2]  = 184614       * 10 ** 18;
332       lockList[0x66F9A4b3C09dA25cF14a063647882c31880bcd17]  = 37509        * 10 ** 18;
333       lockList[0x3409780afa44ede06111b927e25c1fa7ef72cda5]  = 185956       * 10 ** 18;
334       lockList[0x1F105e0A5126a1282929ff5E4FB1819F2D48a785]  = 221487       * 10 ** 18;
335       lockList[0x5F86Ff75c7745d40d81F155c9B2D49794F8Dd85E]  = 476976       * 10 ** 18;
336       lockList[0xAB107D9932f4338538c72fEc7fEd65a7F87Ed24C]  = 1863872      * 10 ** 18;
337       lockList[0xB3D3403BB64258CFA18C49D28c0E9719eF0A0004]  = 192751       * 10 ** 18;
338       lockList[0xb1da36EfcBf2ee81178A113c631932AEc9c9ADE9]  = 34386        * 10 ** 18;
339       lockList[0x8894EdE64044F73d293bD43eaeBf1D6Dbc55B361]  = 2368356      * 10 ** 18;
340       lockList[0xF7F62c2B263E6C7319322f2A4a76d989404835d6]  = 100515       * 10 ** 18;
341       lockList[0x5814639DA554762e40745b9F0e2C5d0Ba593E532]  = 413704       * 10 ** 18;
342       lockList[0xc02918Eb9563dBa6322673C2f18096Dceb5BE71d]  = 101500       * 10 ** 18;
343       lockList[0x61dBB6fA0d7A85a73Fb3AA4896079eE4011229e5]  = 164921       * 10 ** 18;
344       lockList[0x30E442ADD9826B52F344D7FAfB8960Df9dbb8f30]  = 280178       * 10 ** 18;
345       lockList[0xE8B0A0BEc7b2B772858414527C022bfb259FAC71]  = 1559993      * 10 ** 18;
346       lockList[0x9f8B4fd6B3BbACCa93b79C37Ce1F330a5A81cbB7]  = 766709       * 10 ** 18;
347       lockList[0x5a98B695Fe35F628DFaEBbBB5493Dc8488FA3275]  = 283605       * 10 ** 18;
348       lockList[0x23b6E3369bD27C3C4Be5d925c6fa1FCea52283e2]  = 143304       * 10 ** 18;
349       lockList[0xE8c215194222708C831362D5e181b2Af99c6c384]  = 144635       * 10 ** 18;
350       lockList[0xfC0aE173522D24326CFfA9D0D0C058565Fd39d2B]  = 84228        * 10 ** 18;
351       lockList[0x5e08EA6DDD4BF0969B33CAD27D89Fb586F0fC2f1]  = 34749        * 10 ** 18;
352       lockList[0xE7De0652d437b627AcC466002d1bC8D44bdb156E]  = 17809        * 10 ** 18;
353       lockList[0xEa4CedE1d23c616404Ac2dcDB3A3C5EaA24Ce38d]  = 13263        * 10 ** 18;
354       lockList[0x7d97568b1329013A026ED561A0FA542030f7b44B]  = 107752       * 10 ** 18;
355       lockList[0x0c52d845AB2cB7e4bec52DF6F521603683FA8780]  = 36368        * 10 ** 18;
356       lockList[0x58d66AC8820fa6f7c18594766519c490d33C6E96]  = 292311       * 10 ** 18;
357       lockList[0x1554972baa4b0f26bafbfac8872fc461683a64aa]  = 74097        * 10 ** 18;
358       lockList[0xcCD4513E24C87439173f747625FDBF906AE5428A]  = 33718        * 10 ** 18;
359       lockList[0xB81f587dEB7Dc1eb1e7372B1BD0E75DeE5804313]  = 34711        * 10 ** 18;
360       lockList[0xad4e8ae487bf8b6005aa7cb8f3f573752db1ced0]  = 62781        * 10 ** 18;
361       lockList[0x9e25ade8a3a4f2f1a9e902a3eaa62baee0000c16]  = 1042612      * 10 ** 18;
362       lockList[0xeb019f923bb1Dab5Fd309E342b52950E6A3a5bb5]  = 210671       * 10 ** 18;
363       lockList[0xf145c1E0dEcE26b8DD0eDbd0D7A1f4a16dBFE238]  = 414327       * 10 ** 18;
364       lockList[0xf1cfa922da06079ce6ed6c5b6922df0d4b82c76f]  = 135962       * 10 ** 18;
365       lockList[0x0Fc746A1800BDb4F6308B544e07B46eF4615776E]  = 12948        * 10 ** 18;
366       lockList[0x448bc2419Fef08eF72a49B125EA8f2312a0Db64C]  = 11331        * 10 ** 18;
367       lockList[0x6766B4BebcEfa05db1041b80f9C67a00aAe60d2a]  = 44260        * 10 ** 18;
368       lockList[0xfd1b9d97772661f56cb630262311f345e24078ee]  = 116657       * 10 ** 18;
369       lockList[0x5149F1A30Bab45e436550De2Aed5C63101CC3c61]  = 161098       * 10 ** 18;
370       lockList[0xAeA06A4bFc2c60b2CEb3457c56eEb602C72B6C74]  = 13499        * 10 ** 18;
371       lockList[0xB24969E6CEAE48EfccAb7dB5E56169574A3a13A8]  = 62028        * 10 ** 18;
372       lockList[0x6FaE413d14cD734d6816d4407b1e4aB931D3F918]  = 100378       * 10 ** 18;
373       lockList[0xb6224a0f0ab25312d100a1a8c498f7fb4c86da17]  = 484510       * 10 ** 18;
374       lockList[0xE3C398F56733eF23a06D96f37EaE555eE6596A85]  = 381015       * 10 ** 18;
375       lockList[0x3eB5594E1CE158799849cfC7A7861164107F2006]  = 445141       * 10 ** 18;
376       lockList[0x15ac93dE94657882c8EB6204213D9B521dEBaBfB]  = 213617       * 10 ** 18;
377       lockList[0x1988267Ce9B413EE6706A21417481Ed11a3Ca152]  = 595134       * 10 ** 18;
378       lockList[0x50e10b4444F2eC1a14Deea02138A338896c2325E]  = 321502       * 10 ** 18;
379       lockList[0x5934028055dd8bff18e75283af5a8800469c7eda]  = 788752       * 10 ** 18;
380       lockList[0xff54d0987cba3c07dc2e65f8ba62a963439e257f]  = 239170       * 10 ** 18;
381       lockList[0x71396C01ba9AA053a51cfadC7d0D09d97aF96189]  = 2250076      * 10 ** 18;
382       lockList[0x795129211Eb76D8440E01Ed2374417f054dB65f2]  = 2355693      * 10 ** 18;
383       lockList[0xac0c89c654d837100db2c3dc5923e308c745ac0e]  = 34000        * 10 ** 18;
384       lockList[0x941D03Ae7242cF1929888FdE6160771ff27f3D8c]  = 1308777      * 10 ** 18;
385       lockList[0xd9A2649ea71A38065B2DB6e670272Bed0bb68fB7]  = 1570922      * 10 ** 18;
386       lockList[0x7303bDf8d7c7642F5297A0a97320ee440E55D028]  = 1846600      * 10 ** 18;
387       lockList[0x333a0401Aa60D81Ba38e9E9Bd43FD0f8253A83eB]  = 1503988      * 10 ** 18;
388       lockList[0x5AC44139a4E395b8d1461b251597F86F997A407B]  = 1467330      * 10 ** 18;
389       lockList[0xbB07b26d8c7d9894FAF45139B3286784780EC94F]  = 1650000      * 10 ** 18;
390       lockList[0xc4Ad40d8FCCDcd555B7026CAc1CC6513993a2A03]  = 845391       * 10 ** 18;
391       lockList[0x92Dab5d9af2fC53863affd8b9212Fae404A8B625]  = 48000        * 10 ** 18;
392 
393    	}
394 //==============================================================================
395 //     _ _  _  _|. |`. _  _ _  .
396 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
397 //==============================================================================
398     /**
399      * @dev used to make sure no one can interact with contract until it has
400      * been activated.
401      */
402     modifier isActivated() {
403         require(activated_ == true, "it's not ready yet");
404         _;
405     }
406 	
407 	/**
408 	 * @dev  Whether or not owner
409 	 */
410 	modifier isOwer() {
411 	    require(msg.sender == owner_, "you need owner auth");
412         _;
413 	}
414 	
415 	/**
416 	  *@dev  active unlock contract
417 	  *
418 	  */
419 	function activeUnLockGMI(uint64 timeStamp) isOwer() {
420 		activatedTime = timeStamp;
421 		activated_ = true;
422 	}
423 	
424 	/**
425 	 **@dev shutDown unlock flag
426 	 */
427 	function shutDownUnlocked() isOwer() {
428 	    activated_ = false;
429 	}
430 	
431 	/**
432 	 *@dev Take the remaining GMI to prevent accidents.
433 	 * 
434 	 */
435 	function getRemainingGMI(address userAddr) isOwer() {
436 	    require(activated_ == false, "you need shut down unlocked contract first");
437 	    uint256 remainGMI = gmiToken.balanceOf(address(this));
438 	    gmiToken.transfer(userAddr, remainGMI);
439 	}
440 	
441 	modifier isExhausted() {
442 		require(takenAmount[msg.sender] < lockList[msg.sender], "Locked GMI is isExhausted");
443 		_;
444 	}
445 	
446 	/*
447      * @dev Get GMI to user
448      */
449     function getUnLockedGMI() public 
450 	isActivated() 
451 	isExhausted()
452 		payable {
453 
454  		uint256 currentTakeGMI = 0;
455  		uint256 unlockedCount = 0;
456 		uint256 unlockedGMI = 0;
457 		uint256 userLockedGMI = 0;
458 		uint256 userTakeTime = 0;
459         (currentTakeGMI, unlockedCount, unlockedGMI, userLockedGMI, userTakeTime) = calculateUnLockerGMI(msg.sender);
460 		takenAmount[msg.sender] = safeAdd(takenAmount[msg.sender], currentTakeGMI);
461 		takenTime[msg.sender] = now;
462 		gmiToken.transfer(msg.sender, currentTakeGMI);
463     }
464     
465     
466 	/*
467      * @dev  calculate user unlocked GMI amount
468      */
469     function calculateUnLockerGMI(address userAddr) private isActivated() 
470     view returns(uint256, uint256, uint256, uint256, uint256)  {
471         uint256 unlockedCount = 0;
472 		uint256 currentTakeGMI = 0;
473 		uint256 userTakenTime = takenTime[userAddr];
474 		uint256 userLockedGMI = lockList[userAddr];
475 
476 	    unlockedCount = safeDiv(safeSub(now, activatedTime), timeInterval);
477 		
478 		if(unlockedCount == 0) {
479 		    return (0, unlockedCount, unlockedGMI, userLockedGMI, userTakenTime);
480 		}
481 		
482 		if(unlockedCount > unLockedAmount) {
483 		    unlockedCount = unLockedAmount;
484 		}
485 
486 		uint256 unlockedGMI =  safeDiv(safeMul(userLockedGMI, unlockedCount), unLockedAmount);
487 		currentTakeGMI = safeSub(unlockedGMI, takenAmount[userAddr]);
488 		if(unlockedCount == unLockedAmount) {
489 		   currentTakeGMI = safeSub(userLockedGMI, takenAmount[userAddr]);
490 		}
491 	    return (currentTakeGMI, unlockedCount, unlockedGMI, userLockedGMI, userTakenTime);
492     }
493 
494 	function balancesOfUnLockedGMI(address userAddr) public 
495 	isActivated() view returns(uint256, uint256, uint256, uint256, uint256)
496     {
497 	
498 		uint256 currentTakeGMI = 0;
499 		uint256 unlockedCount = 0;
500 		uint256 unlockedGMI = 0;
501 		uint256 userLockedGMI = 0;
502 		uint256 userTakeTime = 0;
503 
504 		(currentTakeGMI, unlockedCount, unlockedGMI, userLockedGMI, userTakeTime) = calculateUnLockerGMI(userAddr);
505 		    
506 		return (currentTakeGMI, unlockedCount, unlockedGMI, userLockedGMI, userTakeTime);
507 	}
508 }
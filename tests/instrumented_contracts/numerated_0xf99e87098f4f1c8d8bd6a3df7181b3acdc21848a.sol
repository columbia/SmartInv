1 /***
2  *      ______ _   _               _____      _              _       _           
3  *     |  ____| | | |             / ____|    | |            | |     | |          
4  *     | |__  | |_| |__   ___ _ _| (___   ___| |__   ___  __| |_   _| | ___ _ __ 
5  *     |  __| | __| '_ \ / _ \ '__\___ \ / __| '_ \ / _ \/ _` | | | | |/ _ \ '__|
6  *     | |____| |_| | | |  __/ |  ____) | (__| | | |  __/ (_| | |_| | |  __/ |   
7  *     |______|\__|_| |_|\___|_| |_____/ \___|_| |_|\___|\__,_|\__,_|_|\___|_|   
8  *                                                                               
9  *                                                                               
10  */
11 
12 pragma solidity ^ 0.5.1;
13 
14 library ECRecovery {
15 
16   function recover(bytes32 hash, bytes memory sig)
17     internal
18     pure
19     returns (address)
20   {
21     bytes32 r;
22     bytes32 s;
23     uint8 v;
24 
25     if (sig.length != 65) {
26       return (address(0));
27     }
28 
29     assembly {
30       r := mload(add(sig, 32))
31       s := mload(add(sig, 64))
32       v := byte(0, mload(add(sig, 96)))
33     }
34 
35     if (v < 27) {
36       v += 27;
37     }
38 
39     if (v != 27 && v != 28) {
40       return (address(0));
41     } else {
42       return ecrecover(hash, v, r, s);
43     }
44   }
45 
46 
47   function toEthSignedMessageHash(bytes32 hash)
48     internal
49     pure
50     returns (bytes32)
51   {
52 
53     return keccak256(
54       abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
55     );
56   }
57 }
58 
59 library SafeMath {
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b);
68 
69         return c;
70     }
71 
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         require(b > 0);
75         uint256 c = a / b;
76 
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         require(b <= a);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a);
90 
91         return c;
92     }
93 
94     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95         require(b != 0);
96         return a % b;
97     }
98 }
99 
100 interface IERC20 {
101     function totalSupply() external view returns (uint256);
102 
103     function balanceOf(address who) external view returns (uint256);
104 
105     function allowance(address owner, address spender) external view returns (uint256);
106 
107     function transfer(address to, uint256 value) external returns (bool);
108 
109     function approve(address spender, uint256 value) external returns (bool);
110 
111     function transferFrom(address from, address to, uint256 value) external returns (bool);
112 
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 contract EtherScheduler {
119     using ECRecovery for bytes32;
120     using SafeMath for uint;
121 
122     mapping(address => uint256) internal balances;
123     mapping(address => mapping(uint => bool)) internal usedNonces;
124     
125     event Fulfilled(bytes indexed signature, address indexed signer);
126     
127     address payable private fee_collector;
128     IERC20 private TXC;
129     
130     constructor(address payable _fee_collector, address _TXC) public {
131         fee_collector = _fee_collector; /* 0xfF91c94F45e1114b1C90Be6D028381964030584C */
132         
133         TXC = IERC20(_TXC);             /* kovan txc 0x12C942fDbE9981E68DC153CC92dA2e2c301F5a9A */
134                                         /* mainnet txc 0x67e35c41060a988f59e2bcb2e0f09b6978fb6614*/
135     }
136 
137     function getPackedData(
138         address _targetAddress,
139         uint _amount,
140         uint P,
141         bool _byBlock,
142         uint C,
143         uint _nonce,
144         uint networkID
145     ) public pure returns(bytes32) {
146         return keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID));
147     }
148     
149     function getPackedDataBundle(
150         address payable[] memory _targetAddresses,
151         uint[] memory _amounts,
152         uint P,
153         bool _byBlock,
154         uint C,
155         uint _nonce,
156         uint networkID
157     ) public pure returns(bytes32) {
158         return keccak256(abi.encodePacked(_targetAddresses, _amounts, P, _byBlock, C, _nonce, networkID));
159     }
160     
161     function verifySigner(
162         address _targetAddress,
163         uint _amount,
164         uint P,
165         bool _byBlock,
166         uint C,
167         uint _nonce,
168         uint networkID,
169         bytes memory _signature
170     ) public pure returns(address) {
171         bytes32 hash = keccak256(abi.encodePacked(
172             "\x19Ethereum Signed Message:\n32",
173             keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID)))
174         );
175         
176         return hash.recover(_signature);
177     }
178     
179     function timeCondition(
180         address payable _targetAddress,
181         uint _amount,
182         uint P,
183         bool _byBlock,
184         uint C,
185         uint _nonce,
186         uint networkID,
187         bytes memory _signature
188     ) public payable {
189         bytes32 hash = keccak256(abi.encodePacked(
190             "\x19Ethereum Signed Message:\n32",
191             keccak256(abi.encodePacked(_targetAddress, _amount, P, _byBlock, C, _nonce, networkID)))
192         );
193 
194         address signer = hash.recover(_signature);
195                 
196         require(!usedNonces[signer][_nonce]);
197         usedNonces[signer][_nonce] = true;
198         //  v------------------------------ Burned the nonce ------------------------------v
199         
200         uint Q = balances[signer].sub(P.add(_amount));
201         
202         require(Q >= 0);
203         require(_byBlock ? block.number >= C : now >= C);
204         
205         // Request
206         resolve(_targetAddress, signer, _amount, P);
207 
208         // Incentive  
209         payout(P);
210         
211         emit Fulfilled(_signature, signer);
212     }
213     
214     function timeConditionBundle(
215         address payable[] memory _targetAddresses,
216         uint[] memory _amounts,
217         uint P,
218         bool _byBlock,
219         uint C,
220         uint _nonce,
221         uint networkID,
222         bytes memory _signature
223     ) public payable {
224         bytes32 hash = keccak256(abi.encodePacked(
225             "\x19Ethereum Signed Message:\n32",
226             keccak256(abi.encodePacked(_targetAddresses, _amounts, P, _byBlock, C, _nonce, networkID)))
227         );
228         
229         address signer = hash.recover(_signature);
230         
231         require(!usedNonces[signer][_nonce]);
232         usedNonces[signer][_nonce] = true;
233         //  v------------------------------ Burned the nonce ------------------------------v
234         
235         uint totalAmount = 0;
236 
237         for(uint r = 0; r < _amounts.length; r = r.add(1)) {
238             totalAmount = totalAmount.add(_amounts[r]);
239         }
240         
241         uint Q = balances[signer].sub(P.add(totalAmount));
242         
243         require(Q >= 0);
244         require(_amounts.length == _targetAddresses.length);
245         require(_byBlock ? block.number >= C : now >= C);
246         
247         // Request  
248         for(uint r = 0; r < _amounts.length; r = r.add(1)) {
249             resolve(_targetAddresses[r], signer, _amounts[r], P);
250         }
251         
252         // Incentive  
253         payout(P);
254         
255         emit Fulfilled(_signature, signer);
256     }
257     
258     function payout(
259         uint P
260     ) internal {
261         uint fee = TXC.balanceOf(msg.sender) > 0 ? 0 : P.div(10).mul(3);
262         
263         msg.sender.transfer(P-fee);
264         fee_collector.transfer(fee);
265     }
266     
267     function resolve(
268         address payable _targetAddress,
269         address signer,
270         uint _amount,
271         uint P
272     ) internal {
273         balances[signer] = balances[signer].sub(P.add(_amount));
274         _targetAddress.transfer(_amount);
275     }
276     
277     function cancelTX(uint _nonce) external {
278         usedNonces[msg.sender][_nonce] = true;
279         
280         balances[msg.sender] = balances[msg.sender].sub(1 finney);
281         fee_collector.transfer(1 finney);
282     }
283     
284     function deposit(address _beneficiary) public payable {
285         balances[_beneficiary] =  balances[_beneficiary].add(msg.value);
286     }
287     
288     function balanceOf(address _owner) public view returns (uint balance){
289         return balances[_owner];
290     }
291     
292     function() external payable {
293         deposit(msg.sender);
294     }
295 }
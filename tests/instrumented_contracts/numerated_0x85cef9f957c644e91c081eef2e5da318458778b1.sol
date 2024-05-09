1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com/ethereum/EIPs/issues/20
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public view returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint256 c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 
106 
107 /// @title Starter Kit Contract 
108 /// @author Julia Altenried, Yuriy Kashnikov
109 contract StarterKit is Ownable {
110 
111     /**  CONSTANTS **/
112     uint256 public constant COPPER_AMOUNT_NDC = 1000 * 10**18;
113     uint256 public constant COPPER_AMOUNT_TPT = 1500 * 10**18;
114     uint256 public constant COPPER_AMOUNT_SKL = 25 * 10**18;
115     uint256 public constant COPPER_AMOUNT_XPER = 12 * 10**2;
116 
117     uint256 public constant BRONZE_AMOUNT_NDC = 2000 * 10**18;
118     uint256 public constant BRONZE_AMOUNT_TPT = 4000 * 10**18;
119     uint256 public constant BRONZE_AMOUNT_SKL = 50 * 10**18;
120     uint256 public constant BRONZE_AMOUNT_XPER = 25 * 10**2;
121 
122     uint256 public constant SILVER_AMOUNT_NDC = 11000 * 10**18;
123     uint256 public constant SILVER_AMOUNT_TPT = 33000 * 10**18;
124     uint256 public constant SILVER_AMOUNT_SKL = 100 * 10**18;
125     uint256 public constant SILVER_AMOUNT_XPER = 50 * 10**2;
126 
127     uint256 public constant GOLD_AMOUNT_NDC = 25000 * 10**18;
128     uint256 public constant GOLD_AMOUNT_TPT = 100000 * 10**18;
129     uint256 public constant GOLD_AMOUNT_SKL = 200 * 10**18;
130     uint256 public constant GOLD_AMOUNT_XPER = 100 * 10**2;
131 
132     uint256 public constant PLATINUM_AMOUNT_NDC = 250000 * 10**18;
133     uint256 public constant PLATINUM_AMOUNT_TPT = 1250000 * 10**18;
134     uint256 public constant PLATINUM_AMOUNT_SKL = 2000 * 10**18;
135     uint256 public constant PLATINUM_AMOUNT_XPER = 500 * 10**2;
136 
137 
138     /* set of predefined token contract addresses and instances, can be set by owner only */
139     ERC20 public tpt;
140     ERC20 public ndc;
141     ERC20 public skl;
142     ERC20 public xper;
143 
144     /* signer address, can be set by owner only */
145     address public neverdieSigner;
146 
147     event BuyCopper(
148         address indexed to,
149         uint256 CopperPrice,
150         uint256 value
151     );
152 
153     event BuyBronze(
154         address indexed to,
155         uint256 BronzePrice,
156         uint256 value
157     );
158 
159     event BuySilver(
160         address indexed to,
161         uint256 SilverPrice,
162         uint256 value
163     );
164 
165     event BuyGold(
166         address indexed to,
167         uint256 GoldPrice,
168         uint256 value
169     );
170 
171     event BuyPlatinum(
172         address indexed to,
173         uint256 PlatinumPrice,
174         uint256 value
175     );
176 
177 
178     /// @dev handy constructor to initialize StarerKit with a set of proper parameters
179     /// @param _tptContractAddress TPT token address 
180     /// @param _ndcContractAddress NDC token address
181     /// @param _signer signer address
182     function StarterKit(address _tptContractAddress, address _ndcContractAddress,
183                         address _sklContractAddress, address _xperContractAddress,
184                         address _signer) public {
185         tpt = ERC20(_tptContractAddress);
186         ndc = ERC20(_ndcContractAddress);
187         skl = ERC20(_sklContractAddress);
188         xper = ERC20(_xperContractAddress);
189         neverdieSigner = _signer;
190     }
191 
192     function setNDCContractAddress(address _to) external onlyOwner {
193         ndc = ERC20(_to);
194     }
195 
196     function setTPTContractAddress(address _to) external onlyOwner {
197         tpt = ERC20(_to);
198     }
199 
200     function setSKLContractAddress(address _to) external onlyOwner {
201         skl = ERC20(_to);
202     }
203 
204     function setXPERContractAddress(address _to) external onlyOwner {
205         xper = ERC20(_to);
206     }
207 
208     function setSignerAddress(address _to) external onlyOwner {
209         neverdieSigner = _to;
210     }
211 
212     /// @dev buy Copper with ether
213     /// @param _CopperPrice price in Wei
214     /// @param _expiration expiration timestamp
215     /// @param _v ECDCA signature
216     /// @param _r ECDSA signature
217     /// @param _s ECDSA signature
218     function buyCopper(uint256 _CopperPrice,
219                        uint256 _expiration,
220                        uint8 _v,
221                        bytes32 _r,
222                        bytes32 _s
223                       ) payable external {
224         // Check if the signature did not expire yet by inspecting the timestamp
225         require(_expiration >= block.timestamp);
226 
227         // Check if the signature is coming from the neverdie address
228         address signer = ecrecover(keccak256(_CopperPrice, _expiration), _v, _r, _s);
229         require(signer == neverdieSigner);
230 
231         require(msg.value >= _CopperPrice);
232         
233         assert(ndc.transfer(msg.sender, COPPER_AMOUNT_NDC) 
234             && tpt.transfer(msg.sender, COPPER_AMOUNT_TPT)
235             && skl.transfer(msg.sender, COPPER_AMOUNT_SKL)
236             && xper.transfer(msg.sender, COPPER_AMOUNT_XPER));
237            
238 
239         // Emit BuyCopper event
240         emit BuyCopper(msg.sender, _CopperPrice, msg.value);
241     }
242 
243     /// @dev buy Bronze with ether
244     /// @param _BronzePrice price in Wei
245     /// @param _expiration expiration timestamp
246     /// @param _v ECDCA signature
247     /// @param _r ECDSA signature
248     /// @param _s ECDSA signature
249     function buyBronze(uint256 _BronzePrice,
250                        uint256 _expiration,
251                        uint8 _v,
252                        bytes32 _r,
253                        bytes32 _s
254                       ) payable external {
255         // Check if the signature did not expire yet by inspecting the timestamp
256         require(_expiration >= block.timestamp);
257 
258         // Check if the signature is coming from the neverdie address
259         address signer = ecrecover(keccak256(_BronzePrice, _expiration), _v, _r, _s);
260         require(signer == neverdieSigner);
261 
262         require(msg.value >= _BronzePrice);
263         assert(ndc.transfer(msg.sender, BRONZE_AMOUNT_NDC) 
264             && tpt.transfer(msg.sender, BRONZE_AMOUNT_TPT)
265             && skl.transfer(msg.sender, BRONZE_AMOUNT_SKL)
266             && xper.transfer(msg.sender, BRONZE_AMOUNT_XPER));
267 
268         // Emit BuyBronze event
269         emit BuyBronze(msg.sender, _BronzePrice, msg.value);
270     }
271 
272     /// @dev buy Silver with ether
273     /// @param _SilverPrice price in Wei
274     /// @param _expiration expiration timestamp
275     /// @param _v ECDCA signature
276     /// @param _r ECDSA signature
277     /// @param _s ECDSA signature
278     function buySilver(uint256 _SilverPrice,
279                        uint256 _expiration,
280                        uint8 _v,
281                        bytes32 _r,
282                        bytes32 _s
283                       ) payable external {
284         // Check if the signature did not expire yet by inspecting the timestamp
285         require(_expiration >= block.timestamp);
286 
287         // Check if the signature is coming from the neverdie address
288         address signer = ecrecover(keccak256(_SilverPrice, _expiration), _v, _r, _s);
289         require(signer == neverdieSigner);
290 
291         require(msg.value >= _SilverPrice);
292         assert(ndc.transfer(msg.sender, SILVER_AMOUNT_NDC) 
293             && tpt.transfer(msg.sender, SILVER_AMOUNT_TPT)
294             && skl.transfer(msg.sender, SILVER_AMOUNT_SKL)
295             && xper.transfer(msg.sender, SILVER_AMOUNT_XPER));
296 
297         // Emit BuySilver event
298         emit BuySilver(msg.sender, _SilverPrice, msg.value);
299     }
300 
301     /// @dev buy Gold with ether
302     /// @param _GoldPrice price in Wei
303     /// @param _expiration expiration timestamp
304     /// @param _v ECDCA signature
305     /// @param _r ECDSA signature
306     /// @param _s ECDSA signature
307     function buyGold(uint256 _GoldPrice,
308                        uint256 _expiration,
309                        uint8 _v,
310                        bytes32 _r,
311                        bytes32 _s
312                       ) payable external {
313         // Check if the signature did not expire yet by inspecting the timestamp
314         require(_expiration >= block.timestamp);
315 
316         // Check if the signature is coming from the neverdie address
317         address signer = ecrecover(keccak256(_GoldPrice, _expiration), _v, _r, _s);
318         require(signer == neverdieSigner);
319 
320         require(msg.value >= _GoldPrice);
321         assert(ndc.transfer(msg.sender, GOLD_AMOUNT_NDC) 
322             && tpt.transfer(msg.sender, GOLD_AMOUNT_TPT)
323             && skl.transfer(msg.sender, GOLD_AMOUNT_SKL)
324             && xper.transfer(msg.sender, GOLD_AMOUNT_XPER));
325 
326         // Emit BuyGold event
327         emit BuyGold(msg.sender, _GoldPrice, msg.value);
328     }
329 
330     /// @dev buy Platinum with ether
331     /// @param _PlatinumPrice price in Wei
332     /// @param _expiration expiration timestamp
333     /// @param _v ECDCA signature
334     /// @param _r ECDSA signature
335     /// @param _s ECDSA signature
336     function buyPlatinum(uint256 _PlatinumPrice,
337                        uint256 _expiration,
338                        uint8 _v,
339                        bytes32 _r,
340                        bytes32 _s
341                       ) payable external {
342         // Check if the signature did not expire yet by inspecting the timestamp
343         require(_expiration >= block.timestamp);
344 
345         // Check if the signature is coming from the neverdie address
346         address signer = ecrecover(keccak256(_PlatinumPrice, _expiration), _v, _r, _s);
347         require(signer == neverdieSigner);
348 
349         require(msg.value >= _PlatinumPrice);
350         assert(ndc.transfer(msg.sender, PLATINUM_AMOUNT_NDC) 
351             && tpt.transfer(msg.sender, PLATINUM_AMOUNT_TPT)
352             && skl.transfer(msg.sender, PLATINUM_AMOUNT_SKL)
353             && xper.transfer(msg.sender, PLATINUM_AMOUNT_XPER));
354 
355         // Emit BuyPlatinum event
356         emit BuyPlatinum(msg.sender, _PlatinumPrice, msg.value);
357     }
358 
359     /// @dev withdraw all ether
360     function withdrawEther() external onlyOwner {
361         owner.transfer(this.balance);
362     }
363 
364     function withdraw() public onlyOwner {
365       uint256 allNDC= ndc.balanceOf(this);
366       uint256 allTPT = tpt.balanceOf(this);
367       uint256 allSKL = skl.balanceOf(this);
368       uint256 allXPER = xper.balanceOf(this);
369       if (allNDC > 0) ndc.transfer(msg.sender, allNDC);
370       if (allTPT > 0) tpt.transfer(msg.sender, allTPT);
371       if (allSKL > 0) skl.transfer(msg.sender, allSKL);
372       if (allXPER > 0) xper.transfer(msg.sender, allXPER);
373     }
374 
375     /// @dev withdraw token
376     /// @param _tokenContract any kind of ERC20 token to withdraw from
377     function withdrawToken(address _tokenContract) external onlyOwner {
378         ERC20 token = ERC20(_tokenContract);
379         uint256 balance = token.balanceOf(this);
380         assert(token.transfer(owner, balance));
381     }
382 
383     /// @dev kill contract, but before transfer all tokens and ether to owner
384     function kill() onlyOwner public {
385       withdraw();
386       selfdestruct(owner);
387     }
388 
389 }
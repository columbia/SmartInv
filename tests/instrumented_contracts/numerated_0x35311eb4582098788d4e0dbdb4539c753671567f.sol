1 // File: MerchPaymentProd.sol
2 
3 pragma solidity >=0.8.0;
4 
5 /// @notice Simple single owner authorization mixin.
6 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/auth/Owned.sol)
7 abstract contract Owned {
8     /*//////////////////////////////////////////////////////////////
9                                  EVENTS
10     //////////////////////////////////////////////////////////////*/
11 
12     event OwnerUpdated(address indexed user, address indexed newOwner);
13 
14     /*//////////////////////////////////////////////////////////////
15                             OWNERSHIP STORAGE
16     //////////////////////////////////////////////////////////////*/
17 
18     address public owner;
19 
20     modifier onlyOwner() virtual {
21         require(msg.sender == owner, "UNAUTHORIZED");
22 
23         _;
24     }
25 
26     /*//////////////////////////////////////////////////////////////
27                                CONSTRUCTOR
28     //////////////////////////////////////////////////////////////*/
29 
30     constructor(address _owner) {
31         owner = _owner;
32 
33         emit OwnerUpdated(address(0), _owner);
34     }
35 
36     /*//////////////////////////////////////////////////////////////
37                              OWNERSHIP LOGIC
38     //////////////////////////////////////////////////////////////*/
39 
40     function setOwner(address newOwner) public virtual onlyOwner {
41         owner = newOwner;
42 
43         emit OwnerUpdated(msg.sender, newOwner);
44     }
45 }
46 
47 pragma solidity >=0.8.0;
48 
49 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
50 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
51 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
52 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
53 abstract contract ERC20 {
54     /*//////////////////////////////////////////////////////////////
55                                  EVENTS
56     //////////////////////////////////////////////////////////////*/
57 
58     event Transfer(address indexed from, address indexed to, uint256 amount);
59 
60     event Approval(address indexed owner, address indexed spender, uint256 amount);
61 
62     /*//////////////////////////////////////////////////////////////
63                             METADATA STORAGE
64     //////////////////////////////////////////////////////////////*/
65 
66     string public name;
67 
68     string public symbol;
69 
70     uint8 public immutable decimals;
71 
72     /*//////////////////////////////////////////////////////////////
73                               ERC20 STORAGE
74     //////////////////////////////////////////////////////////////*/
75 
76     uint256 public totalSupply;
77 
78     mapping(address => uint256) public balanceOf;
79 
80     mapping(address => mapping(address => uint256)) public allowance;
81 
82     /*//////////////////////////////////////////////////////////////
83                             EIP-2612 STORAGE
84     //////////////////////////////////////////////////////////////*/
85 
86     uint256 internal immutable INITIAL_CHAIN_ID;
87 
88     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
89 
90     mapping(address => uint256) public nonces;
91 
92     /*//////////////////////////////////////////////////////////////
93                                CONSTRUCTOR
94     //////////////////////////////////////////////////////////////*/
95 
96     constructor(
97         string memory _name,
98         string memory _symbol,
99         uint8 _decimals
100     ) {
101         name = _name;
102         symbol = _symbol;
103         decimals = _decimals;
104 
105         INITIAL_CHAIN_ID = block.chainid;
106         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
107     }
108 
109     /*//////////////////////////////////////////////////////////////
110                                ERC20 LOGIC
111     //////////////////////////////////////////////////////////////*/
112 
113     function approve(address spender, uint256 amount) public virtual returns (bool) {
114         allowance[msg.sender][spender] = amount;
115 
116         emit Approval(msg.sender, spender, amount);
117 
118         return true;
119     }
120 
121     function transfer(address to, uint256 amount) public virtual returns (bool) {
122         balanceOf[msg.sender] -= amount;
123 
124         // Cannot overflow because the sum of all user
125         // balances can't exceed the max uint256 value.
126         unchecked {
127             balanceOf[to] += amount;
128         }
129 
130         emit Transfer(msg.sender, to, amount);
131 
132         return true;
133     }
134 
135     function transferFrom(
136         address from,
137         address to,
138         uint256 amount
139     ) public virtual returns (bool) {
140         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
141 
142         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
143 
144         balanceOf[from] -= amount;
145 
146         // Cannot overflow because the sum of all user
147         // balances can't exceed the max uint256 value.
148         unchecked {
149             balanceOf[to] += amount;
150         }
151 
152         emit Transfer(from, to, amount);
153 
154         return true;
155     }
156 
157     /*//////////////////////////////////////////////////////////////
158                              EIP-2612 LOGIC
159     //////////////////////////////////////////////////////////////*/
160 
161     function permit(
162         address owner,
163         address spender,
164         uint256 value,
165         uint256 deadline,
166         uint8 v,
167         bytes32 r,
168         bytes32 s
169     ) public virtual {
170         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
171 
172         // Unchecked because the only math done is incrementing
173         // the owner's nonce which cannot realistically overflow.
174         unchecked {
175             address recoveredAddress = ecrecover(
176                 keccak256(
177                     abi.encodePacked(
178                         "\x19\x01",
179                         DOMAIN_SEPARATOR(),
180                         keccak256(
181                             abi.encode(
182                                 keccak256(
183                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
184                                 ),
185                                 owner,
186                                 spender,
187                                 value,
188                                 nonces[owner]++,
189                                 deadline
190                             )
191                         )
192                     )
193                 ),
194                 v,
195                 r,
196                 s
197             );
198 
199             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
200 
201             allowance[recoveredAddress][spender] = value;
202         }
203 
204         emit Approval(owner, spender, value);
205     }
206 
207     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
208         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
209     }
210 
211     function computeDomainSeparator() internal view virtual returns (bytes32) {
212         return
213             keccak256(
214                 abi.encode(
215                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
216                     keccak256(bytes(name)),
217                     keccak256("1"),
218                     block.chainid,
219                     address(this)
220                 )
221             );
222     }
223 
224     /*//////////////////////////////////////////////////////////////
225                         INTERNAL MINT/BURN LOGIC
226     //////////////////////////////////////////////////////////////*/
227 
228     function _mint(address to, uint256 amount) internal virtual {
229         totalSupply += amount;
230 
231         // Cannot overflow because the sum of all user
232         // balances can't exceed the max uint256 value.
233         unchecked {
234             balanceOf[to] += amount;
235         }
236 
237         emit Transfer(address(0), to, amount);
238     }
239 
240     function _burn(address from, uint256 amount) internal virtual {
241         balanceOf[from] -= amount;
242 
243         // Cannot underflow because a user's balance
244         // will never be larger than the total supply.
245         unchecked {
246             totalSupply -= amount;
247         }
248 
249         emit Transfer(from, address(0), amount);
250     }
251 }
252 
253 pragma solidity 0.8.15;
254 
255 contract MerchPayment is Owned {
256     ERC20 public POWToken;
257     ERC20 public PUNKSToken;
258     address public powDest; 
259     address public punksDest;
260 
261     uint256 public id;
262 
263     //map address => id => sizeClaimed (0 if not claimed)
264     mapping(address => mapping(uint256 => uint256)) public addrIDSize;
265     //map id => numSizes
266     mapping(uint256 => uint256) public sizesOf;    
267     //map id => POW(True) PUNKS(False) => Cost
268     mapping(uint256 => mapping(bool => uint256)) public costOf;
269     //map id => size => total
270     mapping(uint256 => mapping(uint256 => uint256)) public maxOfIDSize;
271     //map id => size => claimed
272     mapping(uint256 => mapping(uint256 => uint256)) public claimedOfIDSize;
273 
274     uint256 windowOpens;
275     uint256 windowCloses;
276 
277     event Purchase(address claimer, uint256[] sizes);
278 
279     constructor(
280         address _POWToken, 
281         address _PUNKSToken, 
282         address _powDest, 
283         address _punksDest, 
284         uint256 _windowOpens, 
285         uint256 _windowCloses
286     ) Owned(msg.sender) {
287         POWToken = ERC20(_POWToken);
288         PUNKSToken = ERC20(_PUNKSToken);
289 
290         powDest = _powDest;
291         punksDest = _punksDest;
292 
293         windowOpens = _windowOpens;
294         windowCloses = _windowCloses;
295     }
296 
297     function editTokens(address _POWToken, address _PUNKSToken) public onlyOwner {
298         POWToken = ERC20(_POWToken);
299         PUNKSToken = ERC20(_PUNKSToken);
300     }
301 
302     function editDest(address _powDest, address _punksDest) public onlyOwner {
303         powDest = _powDest;
304         punksDest = _punksDest;
305     }
306 
307     function editWindows(uint256 _windowOpens, uint256 _windowCloses) public onlyOwner {
308         windowOpens = _windowOpens;
309         windowCloses = _windowCloses;
310     }
311 
312     function addItem(
313         uint256[] memory sizeQuantities, 
314         uint256 powCost, 
315         uint256 punksCost
316     ) public onlyOwner {
317         uint sizesLen = sizeQuantities.length;
318 
319         costOf[id][true] = powCost;
320         costOf[id][false] = punksCost;
321         sizesOf[id] = sizesLen;
322 
323         for(uint256 i = 0; i < sizesLen;) {
324             maxOfIDSize[id][i] = sizeQuantities[i];
325             unchecked {
326                 ++i;
327             }
328         }
329 
330         id++;
331     }
332     
333     function updateItem(
334         uint256 _id,
335         uint256[] memory sizeQuantities, 
336         uint256 powCost, 
337         uint256 punksCost
338     ) public onlyOwner {
339         require(_id < id, "UpdateItem: Invalid ID!");
340         uint sizesLen = sizeQuantities.length;
341 
342         costOf[_id][true] = powCost;
343         costOf[_id][false] = punksCost;
344         sizesOf[_id] = sizesLen;
345 
346         for(uint256 i = 0; i < sizesLen;) {
347             maxOfIDSize[_id][i] = sizeQuantities[i];
348             unchecked {
349                 ++i;
350             }
351         }
352     }
353 
354     function purchase(uint256[] memory sizes, bool isPOW) public {
355         require(
356             block.timestamp >= windowOpens && block.timestamp <= windowCloses,
357             "Purchase: Window is closed"
358         );
359         uint sizesLen = sizes.length;
360         require(
361             sizesLen == id,
362             "Purchase: Invalid size list"
363         );
364         uint256 totalCost;
365         for(uint256 i = 0; i < sizesLen;){
366             if(sizes[i] != 0){
367                 require(
368                     addrIDSize[msg.sender][i] == 0,
369                      "Purchase: Already Claimed Item"
370                 );
371                 addrIDSize[msg.sender][i] = sizes[i];
372 
373                 totalCost += costOf[i][isPOW];
374                 require(
375                     sizes[i] - 1 < sizesOf[i],
376                     "Purchase: Selected Size Doesn't Exist!"
377                 );
378                 require(
379                     claimedOfIDSize[i][sizes[i]-1]++ < maxOfIDSize[i][sizes[i]-1],
380                     "Purchase: Selected Size Sold Out!"
381                 );
382 
383             }
384             unchecked {
385                 ++i;
386             }
387         }
388 
389         if(isPOW) {
390             POWToken.transferFrom(msg.sender, powDest, totalCost);
391         } else {
392             PUNKSToken.transferFrom(msg.sender, punksDest, totalCost);
393         }
394 
395         emit Purchase(msg.sender, sizes);
396     }
397 
398     function getPrice(uint256[] memory sizes, bool isPOW) public view returns (uint256 totalCost) {
399         uint sizesLen = sizes.length;
400         require(
401             sizesLen == id,
402             "Purchase: Invalid size list"
403         );
404         for(uint256 i = 0; i < sizesLen;){
405             if(sizes[i] != 0){
406                 totalCost += costOf[i][isPOW];
407             }
408             unchecked {
409                 ++i;
410             }
411         }
412     }
413 }
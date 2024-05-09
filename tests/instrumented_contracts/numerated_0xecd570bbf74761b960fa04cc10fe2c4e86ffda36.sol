1 pragma solidity ^0.4.18;
2 
3 /// Implements ERC20 Token standard: https://github.com/ethereum/EIPs/issues/20
4 interface ERC20Token {
5 
6     event Transfer(address indexed _from, address indexed _to, uint _value);
7     event Approval(address indexed _owner, address indexed _spender, uint _value);
8 
9     function transfer(address _to, uint _value) public returns (bool);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool);
11     function approve(address _spender, uint _value) public returns (bool);
12     function balanceOf(address _owner) public view returns (uint);
13     function allowance(address _owner, address _spender) public view returns (uint);    
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52     address public owner;
53 
54     function Ownable()
55         public
56     {        
57         owner = msg.sender;
58     }
59  
60     modifier onlyOwner {
61         assert(msg.sender == owner);    
62         _;
63     }
64 
65     function transferOwnership(address newOwner)
66         public
67         onlyOwner
68     {
69         owner = newOwner;
70     } 
71 }
72 
73 
74 contract Freezable is Ownable {
75 
76     mapping (address => bool) public frozenAccount;      
77     
78     modifier onlyUnfrozen(address _target) {
79         assert(!isFrozen(_target));
80         _;
81     }
82     
83     // @dev Owners funds are frozen on token creation
84     function isFrozen(address _target)
85         public
86         view
87         returns (bool)
88     {
89         return frozenAccount[_target];
90     }
91 }
92 
93 contract Token is ERC20Token, Freezable {
94     /*
95      *  Storage
96      */
97     mapping (address => uint) balances;
98     mapping (address => mapping (address => uint)) allowances; 
99     mapping (address => string) public data;
100     uint    public totalSupply;
101     uint    public timeTransferbleUntil = 1538262000;                        // Transferable until 29/09/2018 23:00 pm UTC
102     bool    public stopped = false;
103  
104     event Burn(address indexed from, uint256 value, string data);
105     event LogStop();
106 
107     modifier transferable() {
108         assert(!stopped);
109         _;
110     }
111 
112     /*
113      *  Public functions
114      */
115     /// @dev Transfers sender's tokens to a given address. Returns success
116     /// @param _to Address of token receiver
117     /// @param _value Number of tokens to transfer
118     /// @return Returns success of function call
119     function transfer(address _to, uint _value)
120         public      
121         onlyUnfrozen(msg.sender)                                           
122         transferable()
123         returns (bool)        
124     {                         
125         assert(_to != 0x0);                                                // Prevent transfer to 0x0 address. Use burn() instead
126         assert(balances[msg.sender] >= _value);                            // Check if the sender has enough
127         assert(!isFrozen(_to));                                            // Do not allow transfers to frozen accounts
128         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender
129         balances[_to] = SafeMath.add(balances[_to], _value);               // Add the same to the recipient
130         Transfer(msg.sender, _to, _value);                                 // Notify anyone listening that this transfer took place
131         return true;       
132     }
133 
134     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
135     /// @param _from Address from where tokens are withdrawn
136     /// @param _to Address to where tokens are sent
137     /// @param _value Number of tokens to transfer
138     /// @return Returns success of function call
139     function transferFrom(address _from, address _to, uint _value)
140         public    
141         onlyUnfrozen(_from)                                               // Owners can never transfer funds
142         transferable()                 
143         returns (bool)
144     {        
145         assert(_to != 0x0);                                               // Prevent transfer to 0x0 address. Use burn() instead
146         assert(balances[_from] >= _value);                                // Check if the sender has enough
147         assert(_value <= allowances[_from][msg.sender]);                  // Check allowance
148         assert(!isFrozen(_to));                                           // Do not allow transfers to frozen accounts
149         balances[_from] = SafeMath.sub(balances[_from], _value);          // Subtract from the sender
150         balances[_to] = SafeMath.add(balances[_to], _value);              // Add the same to the recipient
151         allowances[_from][msg.sender] = SafeMath.sub(allowances[_from][msg.sender], _value); 
152         Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     /// @dev Sets approved amount of tokens for spender. Returns success
157     /// @param _spender Address of allowed account
158     /// @param _value Number of approved tokens
159     /// @return Returns success of function call    
160     function approve(address _spender, uint _value)
161         public
162         returns (bool)
163     {
164         allowances[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     /// @dev Returns number of allowed tokens for given address
170     /// @param _owner Address of token owner
171     /// @param _spender Address of token spender
172     /// @return Returns remaining allowance for spender    
173     function allowance(address _owner, address _spender)
174         public
175         view
176         returns (uint)
177     {
178         return allowances[_owner][_spender];
179     }
180 
181     /// @dev Returns number of tokens owned by given address
182     /// @param _owner Address of token owner
183     /// @return Returns balance of owner    
184     function balanceOf(address _owner)
185         public
186         view
187         returns (uint)
188     {
189         return balances[_owner];
190     }
191 
192     // @title Burns tokens
193     // @dev remove `_value` tokens from the system irreversibly     
194     // @param _value the amount of tokens to burn   
195     function burn(uint256 _value, string _data) 
196         public 
197         returns (bool success) 
198     {
199         assert(_value > 0);                                                // Amount must be greater than zero
200         assert(balances[msg.sender] >= _value);                            // Check if the sender has enough
201         uint previousTotal = totalSupply;                                  // Start integrity check
202         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value); // Subtract from the sender
203         data[msg.sender] = _data;                                          // Additional data
204         totalSupply = SafeMath.sub(totalSupply, _value);                   // Updates totalSupply
205         assert(previousTotal - _value == totalSupply);                     // End integrity check 
206         Burn(msg.sender, _value, _data);
207         return true;
208     }
209 
210     // Anyone can freeze the token after transfer time has expired
211     function stop() 
212         public
213     {
214         assert(now > timeTransferbleUntil);
215         stopped = true;
216         LogStop();
217     }
218 
219     function totalSupply() 
220         constant public 
221         returns (uint) 
222     {
223         return totalSupply;
224     }
225 
226     function getData(address addr) 
227         public 
228         view
229         returns (string) 
230     {
231         return data[addr];
232     }    
233 }
234 
235 
236 // Contract Owner 0xb42db275AdCCd23e2cB52CfFc2D4Fe984fbF53B2     
237 contract STP is Token {
238     string  public name = "STASHPAY";
239     string  public symbol = "STP";
240     uint8   public decimals = 8;
241     uint8   public publicKeySize = 65;
242     address public sale = 0xB155c16c13FC1eD2F015e24D6C7Ae8Cc38cea74E;
243     address public adviserAndBounty = 0xf40bF198eD3bE9d3E1312d2717b964b377135728;    
244     mapping (address => string) public publicKeys;
245     uint256 constant D160 = 0x0010000000000000000000000000000000000000000;    
246 
247     event RegisterKey(address indexed _from, string _publicKey);
248     event ModifyPublicKeySize(uint8 _size);
249 
250     function STP()
251     public 
252     {             
253         uint256[29] memory owners = [
254             uint256(0xb5e620f480007f0dfc26a56b0f7ccd8100eaf31b75dd40bae01f),
255             uint256(0x162b3f376600078c63f73a2f46c19a4cd91e700203bbbe4084093),
256             uint256(0x16bcc41e900004ae21e3c9b0e63dbc2832f1fa3e6e4dd60f42ae1),
257             uint256(0x1c6bf52634000b9b206c23965553889ebdaee326d4da4a457b9b1),
258             uint256(0x16bcc41e90000d26061a8d47cc712c61a8fa23ce21d593e50f668),
259             uint256(0x110d9316ec000d69106be0299d0a83b9a9e32f2df85ec7739fa59),
260             uint256(0x16bcc41e90000d6d813fd0394bfec48996e20d8fbcf55a003c19a),
261             uint256(0x1c6bf52634000e34dc2c4481561224114ad004c824b1f9e142e31),
262             uint256(0x110d9316ec0006e19b79b974fa039c1356f6814da22b0a04e8d29),
263             uint256(0x16bcc41e900005d2f999136e12e54f4a9a873a9d9ab7407591249),
264             uint256(0x110d9316ec0002b0013a364a997b9856127fd0ababef72baec159),
265             uint256(0x16bcc41e90000db46260f78efa6c904d7dafc5c584ca34d5234be),
266             uint256(0x1c6bf5263400073a4077adf235164f4944f138fc9d982ea549eba),
267             uint256(0x9184e72a0003617280cabfe0356a2af3cb4f652c3aca3ab8216),
268             uint256(0xb5e620f480003d106c1220c49f75ddb8a475b73a1517cef163f6),
269             uint256(0x9184e72a000d6aaf14fee58fd90e6518179e94f02b5e0098a78),
270             uint256(0x162b3f37660009c98c23e430b4270f47685e46d651b9150272b16),
271             uint256(0xb5e620f48000cc3e7d55bba108b07c08d014f13fe0ee5c09ec08),
272             uint256(0x110d9316ec000e4a92d9c2c31789250956b1b0b439cf72baf8a27),
273             uint256(0x16bcc41e900002edc2b7f7191cf9414d9bf8febdd165b0cd91ee1),
274             uint256(0x110d9316ec000332f79ebb69d00cb3f13fcb2be185ed944f64298),
275             uint256(0x221b262dd80005594aae7ae31a3316691ab7a11de3ddee2f015e0),
276             uint256(0x1c6bf52634000c08b91c50ed4303d1b90ffd47237195e4bfc165e),
277             uint256(0x110d9316ec000bf6f7c6a13b9629b673c023e54fba4c2cd4ccbba),
278             uint256(0x16bcc41e90000629048b47ed4fb881bacfb7ca85e7275cd663cf7),
279             uint256(0x110d9316ec000451861e95aa32ce053f15f6ae013d1eface88e9e),
280             uint256(0x16bcc41e9000094d79beb8c57e54ff3fce49ae35078c6df228b9c),
281             uint256(0x1c6bf52634000e2b1430b79b5be8bf3c7d70eb4faf36926b369f3),
282             uint256(0xb5e620f4800025b772bda67719d2ba404c04fa4390443bf993ed)
283         ];
284 
285         /* 
286             Token Distrubution
287             -------------------
288             500M Total supply
289             72% Token Sale
290             20% Founders (frozen for entire duration of contract)
291             8% Bounty and advisters
292         */
293 
294         totalSupply = 500000000 * 10**uint256(decimals); 
295         balances[sale] = 360000000 * 10**uint256(decimals); 
296         balances[adviserAndBounty] = 40000000 * 10**uint256(decimals);
297             
298         Transfer(0, sale, balances[sale]);
299         Transfer(0, adviserAndBounty, balances[adviserAndBounty]);
300         
301         /* 
302             Founders are provably frozen for duration of contract            
303         */
304         uint assignedTokens = balances[sale] + balances[adviserAndBounty];
305         for (uint i = 0; i < owners.length; i++) {
306             address addr = address(owners[i] & (D160 - 1));                    // get address
307             uint256 amount = owners[i] / D160;                                 // get amount
308             balances[addr] = SafeMath.add(balances[addr], amount);             // update balance            
309             assignedTokens = SafeMath.add(assignedTokens, amount);             // keep track of total assigned
310             frozenAccount[addr] = true;                                        // Owners funds are provably frozen for duration of contract
311             Transfer(0, addr, amount);                                         // transfer the tokens
312         }        
313         /*
314             balance check 
315         */
316         require(assignedTokens == totalSupply);             
317     }  
318     
319     function registerKey(string publicKey)
320     public
321     transferable
322     { 
323         assert(balances[msg.sender] > 0);
324         assert(bytes(publicKey).length <= publicKeySize);
325               
326         publicKeys[msg.sender] = publicKey; 
327         RegisterKey(msg.sender, publicKey);    
328     }           
329   
330     function modifyPublicKeySize(uint8 _publicKeySize)
331     public
332     onlyOwner
333     { 
334         publicKeySize = _publicKeySize;
335     }
336 
337     function multiDistribute(uint256[] data) 
338     public
339     onlyUnfrozen(sale)
340     onlyOwner 
341     {
342       for (uint256 i = 0; i < data.length; i++) {
343         address addr = address(data[i] & (D160 - 1));
344         uint256 amount = data[i] / D160;
345         balances[sale] -= amount;                        
346         balances[addr] += amount;                                       
347         Transfer(sale, addr, amount);    
348       }
349     }
350 
351     function multiDistributeAdviserBounty(uint256[] data, bool freeze) 
352     public
353     onlyOwner
354     {
355         for (uint256 i = 0; i < data.length; i++) {
356             address addr = address(data[i] & (D160 - 1));
357             uint256 amount = data[i] / D160;
358             distributeAdviserBounty(addr, amount, freeze);
359         }
360     }
361    
362     function distributeAdviserBounty(address addr, uint256 amount, bool freeze)
363     public        
364     onlyOwner 
365     {   
366         // can only freeze when no balance exists        
367         frozenAccount[addr] = freeze && balances[addr] == 0;
368 
369         balances[addr] = SafeMath.add(balances[addr], amount);
370         balances[adviserAndBounty] = SafeMath.sub(balances[adviserAndBounty], amount);
371         Transfer(adviserAndBounty, addr, amount);           
372     }
373 
374     /// @dev when token distrubution is complete freeze any remaining tokens
375     function distributionComplete()
376     public
377     onlyOwner
378     {
379         frozenAccount[sale] = true;
380     }
381 
382     function setName(string _name)
383     public 
384     onlyOwner 
385     {
386         name = _name;
387     }
388 
389     function setSymbol(string _symbol)
390     public 
391     onlyOwner 
392     {
393         symbol = _symbol;
394     }
395 }
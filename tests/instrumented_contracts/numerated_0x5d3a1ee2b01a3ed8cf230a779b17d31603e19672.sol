1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/chae/dev/colorcoin/coin-ver2/color-erc20.sol
6 // flattened :  Thursday, 10-Jan-19 03:27:25 UTC
7 library SafeMath {
8     
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17           return 0;
18         }
19         
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24     
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34     
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;   
41     }
42     
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 contract ERC20 {
55  
56     // Get the total token supply
57     function totalSupply() public constant returns (uint256);
58 
59     // Get the account balance of another account with address _owner   
60     function balanceOf(address who) public view returns (uint256);
61     
62     // Send _value amount of tokens to address _to
63     function transfer(address to, uint256 value) public returns (bool);
64     
65     // Send _value amount of tokens from address _from to address _to
66     function transferFrom(address from, address to, uint256 value) public returns (bool);
67 
68     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
69     // If this function is called again it overwrites the current allowance with _value.
70     // this function is required for some DEX functionality   
71     function approve(address spender, uint256 value) public returns (bool);
72 
73     // Returns the amount which _spender is still allowed to withdraw from _owner
74     function allowance(address owner, address spender) public view returns (uint256);
75  
76     // Triggered when tokens are transferred. 
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     // Triggered whenever approve(address _spender, uint256 _value) is called. 
80     event Approval(address indexed owner,address indexed spender,uint256 value);
81  
82 }
83 
84 //
85 // Color Coin v2.0
86 // 
87 contract ColorCoin is ERC20 {
88 
89     // Time Lock and Vesting
90     struct accountData {
91       uint256 init_balance;
92       uint256 balance;
93       uint256 unlockTime1;
94       uint256 unlockTime2;
95       uint256 unlockTime3;
96       uint256 unlockTime4;
97       uint256 unlockTime5;
98 
99       uint256 unlockPercent1;
100       uint256 unlockPercent2;
101       uint256 unlockPercent3;
102       uint256 unlockPercent4;
103       uint256 unlockPercent5;
104     }
105     
106     using SafeMath for uint256;
107 
108     mapping (address => mapping (address => uint256)) private allowed;
109     
110     mapping(address => accountData) private accounts;
111     
112     mapping(address => bool) private lockedAddresses;
113     
114     address private admin;
115     
116     address private founder;
117     
118     bool public isTransferable = false;
119     
120     string public name;
121     
122     string public symbol;
123     
124     uint256 public __totalSupply;
125     
126     uint8 public decimals;
127     
128     constructor(string _name, string _symbol, uint256 _totalSupply, uint8 _decimals, address _founder, address _admin) public {
129         name = _name;
130         symbol = _symbol;
131         __totalSupply = _totalSupply;
132         decimals = _decimals;
133         admin = _admin;
134         founder = _founder;
135         accounts[founder].init_balance = __totalSupply;
136         accounts[founder].balance = __totalSupply;
137         emit Transfer(0x0, founder, __totalSupply);
138     }
139     
140     // define onlyAdmin
141     modifier onlyAdmin {
142         require(admin == msg.sender);
143         _;
144     }
145     
146     // define onlyFounder
147     modifier onlyFounder {
148         require(founder == msg.sender);
149         _;
150     }
151     
152     // define transferable
153     modifier transferable {
154         require(isTransferable);
155         _;
156     }
157     
158     // define notLocked
159     modifier notLocked {
160         require(!lockedAddresses[msg.sender]);
161         _;
162     }
163     
164     // ERC20 spec.
165     function totalSupply() public constant returns (uint256) {
166         return __totalSupply;
167     }
168 
169     // ERC20 spec.
170     function balanceOf(address _owner) public view returns (uint256) {
171         return accounts[_owner].balance;
172     }
173         
174     // ERC20 spec.
175     function transfer(address _to, uint256 _value) transferable notLocked public returns (bool) {
176         require(_to != address(0));
177         require(_value <= accounts[msg.sender].balance);
178 
179         if (!checkTime(msg.sender, _value)) return false;
180 
181         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);
182         accounts[_to].balance = accounts[_to].balance.add(_value);
183         emit Transfer(msg.sender, _to, _value);
184         return true;
185     }
186     
187     // ERC20 spec.
188     function transferFrom(address _from, address _to, uint256 _value) transferable notLocked public returns (bool) {
189         require(_to != address(0));
190         require(_value <= accounts[_from].balance);
191         require(_value <= allowed[_from][msg.sender]);
192         require(!lockedAddresses[_from]);
193 
194         if (!checkTime(_from, _value)) return false;
195 
196         accounts[_from].balance = accounts[_from].balance.sub(_value);
197         accounts[_to].balance = accounts[_to].balance.add(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         emit Transfer(_from, _to, _value);
200         return true;
201     }
202     
203     // ERC20 spec.
204     function approve(address _spender, uint256 _value) transferable notLocked public returns (bool) {
205         allowed[msg.sender][_spender] = _value;
206         emit Approval(msg.sender, _spender, _value);
207         return true;
208     }
209     
210     // ERC20 spec.
211     function allowance(address _owner, address _spender) public view returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214 
215     // Founder distributes initial balance
216     function distribute(address _to, uint256 _value) onlyFounder public returns (bool) {
217         require(_to != address(0));
218         require(_value <= accounts[msg.sender].balance);
219         
220         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(_value);
221         accounts[_to].balance = accounts[_to].balance.add(_value);
222         accounts[_to].init_balance = accounts[_to].init_balance.add(_value);
223         emit Transfer(msg.sender, _to, _value);
224         return true;
225     }
226 
227     // Change founder
228     function changeFounder(address who) onlyFounder public {   
229         founder = who;
230     }
231 
232     // show founder address
233     function getFounder() onlyFounder public view returns (address) {
234         return founder;
235     }
236 
237     // Change admin
238     function changeAdmin(address who) onlyAdmin public {
239         admin = who;
240     }
241 
242     // show founder address
243     function getAdmin() onlyAdmin public view returns (address) {
244         return admin;
245     }
246 
247     
248     // Lock individual transfer flag
249     function lock(address who) onlyAdmin public {
250         
251         lockedAddresses[who] = true;
252     }
253 
254     // Unlock individual transfer flag
255     function unlock(address who) onlyAdmin public {
256         
257         lockedAddresses[who] = false;
258     }
259     
260     // Check individual transfer flag
261     function isLocked(address who) public view returns(bool) {
262         
263         return lockedAddresses[who];
264     }
265 
266     // Enable global transfer flag
267     function enableTransfer() onlyAdmin public {
268         
269         isTransferable = true;
270     }
271     
272     // Disable global transfer flag 
273     function disableTransfer() onlyAdmin public {
274         
275         isTransferable = false;
276     }
277 
278     // check unlock time and init balance for each account
279     function checkTime(address who, uint256 _value) public view returns (bool) {
280         uint256 total_percent;
281         uint256 total_vol;
282 
283         total_vol = accounts[who].init_balance.sub(accounts[who].balance);
284         total_vol = total_vol.add(_value);
285 
286         if (accounts[who].unlockTime1 > now) {
287            return false;
288         } else if (accounts[who].unlockTime2 > now) {
289            total_percent = accounts[who].unlockPercent1;
290 
291            if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) 
292              return false;
293         } else if (accounts[who].unlockTime3 > now) {
294            total_percent = accounts[who].unlockPercent1;
295            total_percent = total_percent.add(accounts[who].unlockPercent2);
296 
297            if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) 
298              return false;
299 
300         } else if (accounts[who].unlockTime4 > now) {
301            total_percent = accounts[who].unlockPercent1;
302            total_percent = total_percent.add(accounts[who].unlockPercent2);
303            total_percent = total_percent.add(accounts[who].unlockPercent3);
304 
305            if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) 
306              return false;
307         } else if (accounts[who].unlockTime5 > now) {
308            total_percent = accounts[who].unlockPercent1;
309            total_percent = total_percent.add(accounts[who].unlockPercent2);
310            total_percent = total_percent.add(accounts[who].unlockPercent3);
311            total_percent = total_percent.add(accounts[who].unlockPercent4);
312 
313            if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) 
314              return false;
315         } else { 
316            total_percent = accounts[who].unlockPercent1;
317            total_percent = total_percent.add(accounts[who].unlockPercent2);
318            total_percent = total_percent.add(accounts[who].unlockPercent3);
319            total_percent = total_percent.add(accounts[who].unlockPercent4);
320            total_percent = total_percent.add(accounts[who].unlockPercent5);
321 
322            if (accounts[who].init_balance.mul(total_percent) < total_vol.mul(100)) 
323              return false;
324         }
325         
326         return true; 
327        
328     }
329 
330     // Founder sets unlockTime1
331     function setTime1(address who, uint256 value) onlyFounder public returns (bool) {
332         accounts[who].unlockTime1 = value;
333         return true;
334     }
335 
336     function getTime1(address who) public view returns (uint256) {
337         return accounts[who].unlockTime1;
338     }
339 
340     // Founder sets unlockTime2
341     function setTime2(address who, uint256 value) onlyFounder public returns (bool) {
342 
343         accounts[who].unlockTime2 = value;
344         return true;
345     }
346 
347     function getTime2(address who) public view returns (uint256) {
348         return accounts[who].unlockTime2;
349     }
350 
351     // Founder sets unlockTime3
352     function setTime3(address who, uint256 value) onlyFounder public returns (bool) {
353         accounts[who].unlockTime3 = value;
354         return true;
355     }
356 
357     function getTime3(address who) public view returns (uint256) {
358         return accounts[who].unlockTime3;
359     }
360 
361     // Founder sets unlockTime4
362     function setTime4(address who, uint256 value) onlyFounder public returns (bool) {
363         accounts[who].unlockTime4 = value;
364         return true;
365     }
366 
367     function getTime4(address who) public view returns (uint256) {
368         return accounts[who].unlockTime4;
369     }
370 
371     // Founder sets unlockTime5
372     function setTime5(address who, uint256 value) onlyFounder public returns (bool) {
373         accounts[who].unlockTime5 = value;
374         return true;
375     }
376 
377     function getTime5(address who) public view returns (uint256) {
378         return accounts[who].unlockTime5;
379     }
380 
381     // Founder sets unlockPercent1
382     function setPercent1(address who, uint256 value) onlyFounder public returns (bool) {
383         accounts[who].unlockPercent1 = value;
384         return true;
385     }
386 
387     function getPercent1(address who) public view returns (uint256) {
388         return accounts[who].unlockPercent1;
389     }
390 
391     // Founder sets unlockPercent2
392     function setPercent2(address who, uint256 value) onlyFounder public returns (bool) {
393         accounts[who].unlockPercent2 = value;
394         return true;
395     }
396 
397     function getPercent2(address who) public view returns (uint256) {
398         return accounts[who].unlockPercent2;
399     }
400 
401     // Founder sets unlockPercent3
402     function setPercent3(address who, uint256 value) onlyFounder public returns (bool) {
403         accounts[who].unlockPercent3 = value;
404         return true;
405     }
406 
407     function getPercent3(address who) public view returns (uint256) {
408         return accounts[who].unlockPercent3;
409     }
410 
411     // Founder sets unlockPercent4
412     function setPercent4(address who, uint256 value) onlyFounder public returns (bool) {
413         accounts[who].unlockPercent4 = value;
414         return true;
415     }
416 
417     function getPercent4(address who) public view returns (uint256) {
418         return accounts[who].unlockPercent4;
419     }
420 
421     // Founder sets unlockPercent5
422     function setPercent5(address who, uint256 value) onlyFounder public returns (bool) {
423         accounts[who].unlockPercent5 = value;
424         return true;
425     }
426 
427     function getPercent5(address who) public view returns (uint256) {
428         return accounts[who].unlockPercent5;
429     }
430 
431     // get init_balance
432     function getInitBalance(address _owner) public view returns (uint256) {
433         return accounts[_owner].init_balance;
434     }
435 }
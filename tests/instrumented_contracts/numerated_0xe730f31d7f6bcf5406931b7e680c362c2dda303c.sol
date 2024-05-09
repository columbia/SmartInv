1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 contract SuperOwners {
35 
36     address public owner1;
37     address public pendingOwner1;
38     
39     address public owner2;
40     address public pendingOwner2;
41 
42     function SuperOwners(address _owner1, address _owner2) internal {
43         require(_owner1 != address(0));
44         owner1 = _owner1;
45         
46         require(_owner2 != address(0));
47         owner2 = _owner2;
48     }
49 
50     modifier onlySuperOwner1() {
51         require(msg.sender == owner1);
52         _;
53     }
54     
55     modifier onlySuperOwner2() {
56         require(msg.sender == owner2);
57         _;
58     }
59     
60     /** Any of the owners can execute this. */
61     modifier onlySuperOwner() {
62         require(isSuperOwner(msg.sender));
63         _;
64     }
65     
66     /** Is msg.sender any of the owners. */
67     function isSuperOwner(address _addr) public view returns (bool) {
68         return _addr == owner1 || _addr == owner2;
69     }
70 
71     /** 
72      * Safe transfer of ownership in 2 steps. Once called, a newOwner needs 
73      * to call claimOwnership() to prove ownership.
74      */
75     function transferOwnership1(address _newOwner1) onlySuperOwner1 public {
76         pendingOwner1 = _newOwner1;
77     }
78     
79     function transferOwnership2(address _newOwner2) onlySuperOwner2 public {
80         pendingOwner2 = _newOwner2;
81     }
82 
83     function claimOwnership1() public {
84         require(msg.sender == pendingOwner1);
85         owner1 = pendingOwner1;
86         pendingOwner1 = address(0);
87     }
88     
89     function claimOwnership2() public {
90         require(msg.sender == pendingOwner2);
91         owner2 = pendingOwner2;
92         pendingOwner2 = address(0);
93     }
94 }
95 
96 contract MultiOwnable is SuperOwners {
97 
98     mapping (address => bool) public ownerMap;
99     address[] public ownerHistory;
100 
101     event OwnerAddedEvent(address indexed _newOwner);
102     event OwnerRemovedEvent(address indexed _oldOwner);
103 
104     function MultiOwnable(address _owner1, address _owner2) 
105         SuperOwners(_owner1, _owner2) internal {}
106 
107     modifier onlyOwner() {
108         require(isOwner(msg.sender));
109         _;
110     }
111 
112     function isOwner(address owner) public view returns (bool) {
113         return isSuperOwner(owner) || ownerMap[owner];
114     }
115     
116     function ownerHistoryCount() public view returns (uint) {
117         return ownerHistory.length;
118     }
119 
120     // Add extra owner
121     function addOwner(address owner) onlySuperOwner public {
122         require(owner != address(0));
123         require(!ownerMap[owner]);
124         ownerMap[owner] = true;
125         ownerHistory.push(owner);
126         OwnerAddedEvent(owner);
127     }
128 
129     // Remove extra owner
130     function removeOwner(address owner) onlySuperOwner public {
131         require(ownerMap[owner]);
132         ownerMap[owner] = false;
133         OwnerRemovedEvent(owner);
134     }
135 }
136 
137 contract ERC20 {
138 
139     uint256 public totalSupply;
140 
141     function balanceOf(address _owner) public view returns (uint256 balance);
142 
143     function transfer(address _to, uint256 _value) public returns (bool success);
144 
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
146 
147     function approve(address _spender, uint256 _value) public returns (bool success);
148 
149     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
150 
151     event Transfer(address indexed _from, address indexed _to, uint256 _value);
152     
153     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
154 }
155 
156 contract StandardToken is ERC20 {
157     
158     using SafeMath for uint;
159 
160     mapping(address => uint256) balances;
161     
162     mapping(address => mapping(address => uint256)) allowed;
163 
164     function balanceOf(address _owner) public view returns (uint256 balance) {
165         return balances[_owner];
166     }
167 
168     function transfer(address _to, uint256 _value) public returns (bool) {
169         require(_to != address(0));
170         require(_value > 0);
171         require(_value <= balances[msg.sender]);
172         
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
180     /// @param _from Address from where tokens are withdrawn.
181     /// @param _to Address to where tokens are sent.
182     /// @param _value Number of tokens to transfer.
183     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184         require(_to != address(0));
185         require(_value > 0);
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188         
189         balances[_to] = balances[_to].add(_value);
190         balances[_from] = balances[_from].sub(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /// @dev Sets approved amount of tokens for spender. Returns success.
197     /// @param _spender Address of allowed account.
198     /// @param _value Number of approved tokens.
199     function approve(address _spender, uint256 _value) public returns (bool) {
200         allowed[msg.sender][_spender] = _value;
201         Approval(msg.sender, _spender, _value);
202         return true;
203     }
204 
205     /// @dev Returns number of allowed tokens for given address.
206     /// @param _owner Address of token owner.
207     /// @param _spender Address of token spender.
208     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
209         return allowed[_owner][_spender];
210     }
211 }
212 
213 contract CommonToken is StandardToken, MultiOwnable {
214 
215     string public name;
216     string public symbol;
217     uint256 public totalSupply;
218     uint8 public decimals = 18;
219     string public version = 'v0.1';
220 
221     address public seller;     // The main account that holds all tokens at the beginning and during tokensale.
222 
223     uint256 public saleLimit;  // (e18) How many tokens can be sold in total through all tiers or tokensales.
224     uint256 public tokensSold; // (e18) Number of tokens sold through all tiers or tokensales.
225     uint256 public totalSales; // Total number of sales (including external sales) made through all tiers or tokensales.
226 
227     // Lock the transfer functions during tokensales to prevent price speculations.
228     bool public locked = true;
229     
230     event SellEvent(address indexed _seller, address indexed _buyer, uint256 _value);
231     event ChangeSellerEvent(address indexed _oldSeller, address indexed _newSeller);
232     event Burn(address indexed _burner, uint256 _value);
233     event Unlock();
234 
235     function CommonToken(
236         address _owner1,
237         address _owner2,
238         address _seller,
239         string _name,
240         string _symbol,
241         uint256 _totalSupplyNoDecimals,
242         uint256 _saleLimitNoDecimals
243     ) MultiOwnable(_owner1, _owner2) public {
244 
245         require(_seller != address(0));
246         require(_totalSupplyNoDecimals > 0);
247         require(_saleLimitNoDecimals > 0);
248 
249         seller = _seller;
250         name = _name;
251         symbol = _symbol;
252         totalSupply = _totalSupplyNoDecimals * 1e18;
253         saleLimit = _saleLimitNoDecimals * 1e18;
254         balances[seller] = totalSupply;
255 
256         Transfer(0x0, seller, totalSupply);
257     }
258     
259     modifier ifUnlocked(address _from, address _to) {
260         require(!locked || isOwner(_from) || isOwner(_to));
261         _;
262     }
263     
264     /** Can be called once by super owner. */
265     function unlock() onlySuperOwner public {
266         require(locked);
267         locked = false;
268         Unlock();
269     }
270 
271     function changeSeller(address newSeller) onlySuperOwner public returns (bool) {
272         require(newSeller != address(0));
273         require(seller != newSeller);
274 
275         address oldSeller = seller;
276         uint256 unsoldTokens = balances[oldSeller];
277         balances[oldSeller] = 0;
278         balances[newSeller] = balances[newSeller].add(unsoldTokens);
279         Transfer(oldSeller, newSeller, unsoldTokens);
280 
281         seller = newSeller;
282         ChangeSellerEvent(oldSeller, newSeller);
283         
284         return true;
285     }
286 
287     function sellNoDecimals(address _to, uint256 _value) public returns (bool) {
288         return sell(_to, _value * 1e18);
289     }
290 
291     function sell(address _to, uint256 _value) onlyOwner public returns (bool) {
292 
293         // Check that we are not out of limit and still can sell tokens:
294         require(tokensSold.add(_value) <= saleLimit);
295 
296         require(_to != address(0));
297         require(_value > 0);
298         require(_value <= balances[seller]);
299 
300         balances[seller] = balances[seller].sub(_value);
301         balances[_to] = balances[_to].add(_value);
302         Transfer(seller, _to, _value);
303 
304         totalSales++;
305         tokensSold = tokensSold.add(_value);
306         SellEvent(seller, _to, _value);
307 
308         return true;
309     }
310     
311     /**
312      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
313      */
314     function transfer(address _to, uint256 _value) ifUnlocked(msg.sender, _to) public returns (bool) {
315         return super.transfer(_to, _value);
316     }
317 
318     /**
319      * Until all tokens are sold, tokens can be transfered to/from owner's accounts.
320      */
321     function transferFrom(address _from, address _to, uint256 _value) ifUnlocked(_from, _to) public returns (bool) {
322         return super.transferFrom(_from, _to, _value);
323     }
324 
325     function burn(uint256 _value) public returns (bool) {
326         require(_value > 0);
327         require(_value <= balances[msg.sender]);
328 
329         balances[msg.sender] = balances[msg.sender].sub(_value) ;
330         totalSupply = totalSupply.sub(_value);
331         Transfer(msg.sender, 0x0, _value);
332         Burn(msg.sender, _value);
333 
334         return true;
335     }
336 }
337 
338 contract RaceToken is CommonToken {
339     
340     function RaceToken() CommonToken(
341         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
342         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7, // __OWNER2__
343         0x2821e1486D604566842FF27F626aF133FddD5f89, // __SELLER__
344         'Coin Race',
345         'RACE',
346         100 * 1e6, // 100m tokens in total.
347         70 * 1e6   // 70m tokens for sale.
348     ) public {}
349 }
350 
351 /** 
352  * Here we implement all token methods that require msg.sender to be albe 
353  * to perform operations on behalf of GameWallet from other CoinRace contracts 
354  * like a particular contract of RaceGame.
355  */
356 contract CommonWallet is MultiOwnable {
357     
358     RaceToken public token;
359     
360     event ChangeTokenEvent(address indexed _oldAddress, address indexed _newAddress);
361     
362     function CommonWallet(address _owner1, address _owner2) 
363         MultiOwnable(_owner1, _owner2) public {}
364     
365     function setToken(address _token) public onlySuperOwner {
366         require(_token != 0);
367         require(_token != address(token));
368         
369         ChangeTokenEvent(token, _token);
370         token = RaceToken(_token);
371     }
372     
373     function transfer(address _to, uint256 _value) onlyOwner public returns (bool) {
374         return token.transfer(_to, _value);
375     }
376     
377     function transferFrom(address _from, address _to, uint256 _value) onlyOwner public returns (bool) {
378         return token.transferFrom(_from, _to, _value);
379     }
380     
381     function approve(address _spender, uint256 _value) onlyOwner public returns (bool) {
382         return token.approve(_spender, _value);
383     }
384     
385     function burn(uint256 _value) onlySuperOwner public returns (bool) {
386         return token.burn(_value);
387     }
388     
389     /** Amount of tokens that players of CoinRace bet during the games and haven't claimed yet. */
390     function balance() public view returns (uint256) {
391         return token.balanceOf(this);
392     }
393     
394     function balanceOf(address _owner) public view returns (uint256) {
395         return token.balanceOf(_owner);
396     }
397     
398     function allowance(address _owner, address _spender) public view returns (uint256) {
399         return token.allowance(_owner, _spender);
400     }
401 }
402 
403 contract GameWallet is CommonWallet {
404     
405     function GameWallet() CommonWallet(
406         0x229B9Ef80D25A7e7648b17e2c598805d042f9e56, // __OWNER1__
407         0xcd7cF1D613D5974876AfBfd612ED6AFd94093ce7  // __OWNER2__
408     ) public {}
409 }
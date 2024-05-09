1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 contract Owned {
34 
35     /// @dev `owner` is the only address that can call a function with this modifier
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45     
46 
47     /// @notice The Constructor assigns the message sender to be `owner`
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     /// @notice `owner` can step down and assign some other address to this role
53     /// @param _newOwner The address of the new owner. 0x0 can be used to create
54     ///  an unowned neutral vault, however that cannot be undone
55     function changeOwner(address _newOwner) onlyOwner public returns(bool){
56         require (_newOwner != address(0));
57         
58         newOwner = _newOwner;
59         return true;
60     }
61 
62     function acceptOwnership() public returns(bool) {
63         require(newOwner != address(0));
64         require(msg.sender == newOwner);
65 
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69         return true;
70     }
71 }
72 
73 
74 /**
75  * @title ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/20
77  */
78 contract ERC20 {
79     uint256 public totalSupply;
80     function balanceOf(address who) public view returns (uint256);
81     function transfer(address to, uint256 value) public returns (bool);
82     function allowance(address owner, address spender) public view returns (uint256);
83     function transferFrom(address from, address to, uint256 value) public returns (bool);
84     function approve(address spender, uint256 value) public returns (bool);
85     event Transfer(address indexed from, address indexed to, uint256 value);
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20 {
97     using SafeMath for uint256;
98 
99     mapping(address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 
102     /**
103      * @dev Gets the balance of the specified address.
104      * @param _owner The address to query the the balance of.
105      * @return An uint256 representing the amount owned by the passed address.
106      */
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     /**
112      * @dev transfer token for a specified address
113      * @param _to The address to transfer to.
114      * @param _value The amount to be transferred.
115      */
116     function transfer(address _to, uint256 _value) public returns (bool) {
117         require(_to != address(0));
118 
119         // SafeMath.sub will throw if there is not enough balance.
120         balances[msg.sender] = balances[msg.sender].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         emit Transfer(msg.sender, _to, _value);
123         return true;
124     }
125 
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param _from address The address which you want to send tokens from
129      * @param _to address The address which you want to transfer to
130      * @param _value uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
133         require(_to != address(0));
134         require (_value <= allowed[_from][msg.sender]);
135     
136         balances[_from] = balances[_from].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139         emit Transfer(_from, _to, _value);
140         return true;
141     }
142 
143     /**
144      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
145      * @param _spender The address which will spend the funds.
146      * @param _value The amount of tokens to be spent.
147      */
148     function approve(address _spender, uint256 _value) public returns (bool) {
149         // To change the approve amount you first have to reduce the addresses`
150         //  allowance to zero by calling `approve(_spender, 0)` if it is not
151         //  already 0 to mitigate the race condition described here:
152         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154         allowed[msg.sender][_spender] = _value;
155         emit Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 
159     /**
160      * @dev Function to check the amount of tokens that an owner allowed to a spender.
161      * @param _owner address The address which owns the funds.
162      * @param _spender address The address which will spend the funds.
163      * @return A uint256 specifying the amount of tokens still available for the spender.
164      */
165     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
166         return allowed[_owner][_spender];
167     }
168 }
169 
170 contract LifeBankerCoin is Owned, StandardToken{
171     string public constant name = "LifeBanker Coin";
172     string public constant symbol = "LBC";
173     uint8 public constant decimals = 18;
174 
175     address public lockAddress;
176     address public teamAddress;
177 
178     constructor() public {
179         totalSupply = 10000000000000000000000000000; //10 billion
180     }
181 
182     /*
183      * @dev Initialize token attribution,only allowed to call once
184      * @param _team address : TeamTokensHolder contract deployment address
185      * @param _lock address : TokenLock contract deployment address
186      * @param _sare address : The token storage address of the sales part
187      */
188     function initialization(address _team, address _lock, address _sale) onlyOwner public returns(bool) {
189         require(lockAddress == 0 && teamAddress == 0);
190         require(_team != 0 && _lock != 0);
191         require(_sale != 0);
192         teamAddress = _team;
193         lockAddress = _lock;
194     
195         balances[teamAddress] = totalSupply.mul(225).div(1000); //22.5% 
196         balances[lockAddress] = totalSupply.mul(500).div(1000); //50.0% 
197         balances[_sale]       = totalSupply.mul(275).div(1000); //27.5%
198         return true;
199     }
200 }
201 
202 /* @title This contract locks the tokens of the team and early investors.
203  * @notice The tokens are locked for a total of three years, unlocking one-sixth every six months.
204  * Unlockable Amount(%)
205  *    ^
206  * 100|---------------------------- * * *
207  *    |                           / :  
208  *    |----------------------- *    :  
209  *    |                      / :    :  
210  *    |------------------ *    :    :  
211  *    |                 / :    :    :  
212  *  50|------------- *    :    :    :  
213  *    |            / :    :    :    :  
214  *    |-------- *    :    :    :    :  
215  *    |       / :    :    :    :    :  
216  *    |--- *    :    :    :    :    :  
217  *    |  / :    :    :    :    :    :  
218  *    +----*----*----*----*----*----*-->
219  *    0   0.5   1   1.5   2   2.5   3   Time(year)
220  *
221  */
222 contract TeamTokensHolder is Owned{
223     using SafeMath for uint256;
224 
225     LifeBankerCoin public LBC;
226     uint256 public startTime;
227     uint256 public duration = 6 * 30 * 24 * 3600; //six months
228 
229     uint256 public total = 2250000000000000000000000000;  // 2.25 billion  22.5% 
230     uint256 public amountPerRelease = total.div(6);       // 375 million
231     uint256 public collectedTokens;
232 
233 
234     event TokensWithdrawn(address indexed _holder, uint256 _amount);
235     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
236 
237 
238     constructor(address _owner, address _lbc) public{
239         owner = _owner;
240         LBC = LifeBankerCoin(_lbc);
241         startTime = now;
242     }
243 
244     /*
245      * @dev The Dev (Owner) will call this method to extract the tokens
246      */
247     function unLock() public onlyOwner returns(bool){
248         uint256 balance = LBC.balanceOf(address(this));
249 
250         //  amountPerRelease * [(now - startTime) / duration]
251         uint256 canExtract = amountPerRelease.mul((getTime().sub(startTime)).div(duration));
252 
253         uint256 amount = canExtract.sub(collectedTokens);
254 
255         if (amount == 0){
256             revert();
257         } 
258 
259         if (amount > balance) {
260             amount = balance;
261         }
262 
263         assert (LBC.transfer(owner, amount));
264         emit TokensWithdrawn(owner, amount);
265         collectedTokens = collectedTokens.add(amount);
266         
267         return true;
268     }
269 
270     /* Get the timestamp of the current block */
271     function getTime() view public returns(uint256){
272         return now;
273     }
274 
275     /// Safe Function
276     /// @dev This method can be used by the controller to extract mistakenly
277     /// @param _token The address of the token contract that you want to recover
278     function claimTokens(address _token) public onlyOwner returns(bool){
279         require(_token != address(LBC));
280 
281         ERC20 token = ERC20(_token);
282         uint256 balance = token.balanceOf(this);
283         token.transfer(owner, balance);
284         emit ClaimedTokens(_token, owner, balance);
285         return true;
286     }
287 }
288 
289 /*
290  * @title This contract locks 50% of the total, 30% for mining, 
291  *        10% for community promotion, and 10% for operation and maintenance.
292  * @notice The tokens are locked for a total of five years, 
293  *        and the number of tokens that can be unlocked each year is halved. 
294  *        Each year's tokens are divided into 12 months equals to unlock.
295  *        Percentage per year : 50%, 25%, 12.5%, 6.25% ,6.25% 
296  * Unlockable Amount(%)
297  *    ^
298  * 100|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
299  *    |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _     *   :
300  *    |_ _ _ _ _ _ _ _ _ _ _ _ _      *   :        : 
301  *    |                         *:        :        : 
302  *  75|_ _ _ _ _ _ _ _ _    *    :        :        : 
303  *    |                *:        :        :        : 
304  *    |             *   :        :        :        : 
305  *    |          *      :        :        :        : 
306  *  50|_ _ _ _ *        :        :        :        :   
307  *    |       *:        :        :        :        : 
308  *    |      * :        :        :        :        : 
309  *    |     *  :        :        :        :        : 
310  *    |    *   :        :        :        :        : 
311  *    |   *    :        :        :        :        : 
312  *    |  *     :        :        :        :        : 
313  *    | *      :        :        :        :        : 
314  *    |*       :        :        :        :        : 
315  *    +--------*--------*--------*--------*--------*---> Time(year)
316  *    0        1        2        3        4        5    
317  */
318 contract TokenLock is Owned{
319     using SafeMath for uint256;
320 
321     LifeBankerCoin public LBC;
322 
323     uint256 public totalSupply = 10000000000000000000000000000;
324     uint256 public totalLocked = totalSupply.div(2); // 50% of totalSupply
325     uint256 public collectedTokens;
326     uint256 public startTime;
327 
328     address public POSAddress       = 0x72CE608648c5b2E7FB5575F72De32B4F5dfCee18; //30% DPOS
329     address public CommunityAddress = 0x7fD2944a178f4dc0A50783De6Bad1857147774c0; //10% Community promotion
330     address public OperationAddress = 0x33Df6bace87AE59666DD1DE2FDEB383D164f1f36; //10% Operation and maintenance
331 
332     uint256 _1stYear = totalLocked.mul(5000).div(10000);  // 50%
333     uint256 _2stYear = totalLocked.mul(2500).div(10000);  // 25%
334     uint256 _3stYear = totalLocked.mul(1250).div(10000);  // 12.5%
335     uint256 _4stYear = totalLocked.mul(625).div(10000);   // 6.25%
336     uint256 _5stYear = totalLocked.mul(625).div(10000);   // 6.25%
337 
338     mapping (address => bool) whiteList;
339     
340 
341     event TokensWithdrawn(uint256 _amount);
342     event LogMangeWhile(address indexed _dest, bool _allow);
343 
344     modifier onlyWhite() { 
345         require (whiteList[msg.sender] == true); 
346         _; 
347     }
348 
349     /// @param _lbc address : LifeBankerCoin contract deployment address
350     constructor(address _lbc) public{
351         startTime = now;
352         LBC = LifeBankerCoin(_lbc);
353         whiteList[msg.sender] = true;
354     }
355     
356     /**
357      * @dev Add or remove call permissions for an address
358      * @param _dest    address  : The address of the permission to be modified
359      * @param _allow   bool     : True means increase, False means remove
360      * @return success bool     : Successful operation returns True
361      */
362     function mangeWhileList(address _dest, bool _allow) onlyOwner public returns(bool success){
363         require(_dest != address(0));
364 
365         whiteList[_dest] = _allow;
366         emit LogMangeWhile(_dest, _allow);
367         return true;
368     }
369 
370     /* @dev Called by 'owner' to unlock the token.   */
371     function unlock() public onlyWhite returns(bool success){
372         uint256 canExtract = calculation();
373         uint256 _amount = canExtract.sub(collectedTokens); // canExtract - collectedTokens
374         distribute(_amount);
375         collectedTokens = collectedTokens.add(_amount);
376 
377         return true;
378     }
379 
380     /*
381      * @dev Calculates the total number of tokens that can be unlocked based on time.
382      * @return uint256 : total number of unlockable
383      */
384     function calculation() view internal returns(uint256){
385         uint256 _month = getMonths();
386         uint256 _amount;
387 
388         if (_month == 0){
389             revert();
390         }
391 
392         if (_month <= 12 ){
393             _amount = _1stYear.mul(_month).div(12);
394 
395         }else if(_month <= 24){
396             // _1stYear + [_2stYear * (moneth - 12) / 12]
397             _amount = _1stYear;
398             _amount = _amount.add(_2stYear.mul(_month.sub(12)).div(12));
399 
400         }else if(_month <= 36){
401             // _1stYear + _2stYear + [_3stYear * (moneth - 24) / 12]
402             _amount = _1stYear + _2stYear;
403             _amount = _amount.add(_3stYear.mul(_month.sub(24)).div(12));
404 
405         }else if(_month <= 48){
406             // _1stYear + _2stYear + _3stYear + [_4stYear * (moneth - 36) / 12]
407             _amount = _1stYear + _2stYear + _3stYear;
408             _amount = _amount.add(_4stYear.mul(_month.sub(36)).div(12));      
409 
410         }else if(_month <= 60){
411             // _1stYear + _2stYear + _3stYear + _4stYear + [_5stYear * (moneth - 48) / 12]
412             _amount = _1stYear + _2stYear + _3stYear + _4stYear;
413             _amount = _amount.add(_5stYear.mul(_month.sub(48)).div(12)); 
414 
415         }else{
416             // more than 5years
417             _amount = LBC.balanceOf(this);
418         }
419         return _amount;
420     }
421 
422     /* Get how many months have passed since the contract was deployed. */
423     function getMonths() view internal returns(uint256){
424         uint256 countMonth = (getTime().sub(startTime)).div(30 * 24 * 3600);
425         return countMonth; // begin 0
426     }
427 
428     /*
429      * @dev Distribute unlockable tokens to three addresses, proportion 3:1:1
430      * @param _amount uint256 : Number of tokens that can be unlocked
431      */
432     function distribute(uint256 _amount) internal returns(bool){
433         require (_amount != 0);
434 
435         uint256 perAmount = _amount.div(5);
436         
437         assert (LBC.transfer(POSAddress, perAmount.mul(3)));
438         assert (LBC.transfer(CommunityAddress, perAmount.mul(1)));
439         assert (LBC.transfer(OperationAddress, perAmount.mul(1)));
440 
441         emit TokensWithdrawn(_amount);
442         return true;
443     }
444 
445     /* Get the timestamp of the current block */
446     function getTime() view internal returns(uint256){
447         return now; //block.timestamp
448     }
449 }
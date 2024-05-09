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
233     address public TeamAddress = 0x7572b353B176Cc8ceF510616D0fDF8B4551Ba16e;
234 
235     event TokensWithdrawn(address indexed _holder, uint256 _amount);
236     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
237 
238 
239     constructor(address _owner, address _lbc) public{
240         owner = _owner;
241         LBC = LifeBankerCoin(_lbc);
242         startTime = now;
243     }
244 
245     /*
246      * @dev The Dev (Owner) will call this method to extract the tokens
247      */
248     function unLock() public onlyOwner returns(bool){
249         uint256 balance = LBC.balanceOf(address(this));
250 
251         //  amountPerRelease * [(now - startTime) / duration]
252         uint256 canExtract = amountPerRelease.mul((getTime().sub(startTime)).div(duration));
253 
254         uint256 amount = canExtract.sub(collectedTokens);
255 
256         if (amount == 0){
257             revert();
258         } 
259 
260         if (amount > balance) {
261             amount = balance;
262         }
263 
264         assert (LBC.transfer(TeamAddress, amount));
265         emit TokensWithdrawn(TeamAddress, amount);
266         collectedTokens = collectedTokens.add(amount);
267         
268         return true;
269     }
270 
271     /* Get the timestamp of the current block */
272     function getTime() view public returns(uint256){
273         return now;
274     }
275 
276     /// Safe Function
277     /// @dev This method can be used by the controller to extract mistakenly
278     /// @param _token The address of the token contract that you want to recover
279     function claimTokens(address _token) public onlyOwner returns(bool){
280         require(_token != address(LBC));
281 
282         ERC20 token = ERC20(_token);
283         uint256 balance = token.balanceOf(this);
284         token.transfer(owner, balance);
285         emit ClaimedTokens(_token, owner, balance);
286         return true;
287     }
288 }
289 
290 /*
291  * @title This contract locks 50% of the total, 30% for mining, 
292  *        10% for community promotion, and 10% for operation and maintenance.
293  * @notice The tokens are locked for a total of five years, 
294  *        and the number of tokens that can be unlocked each year is halved. 
295  *        Each year's tokens are divided into 12 months equals to unlock.
296  *        Percentage per year : 50%, 25%, 12.5%, 6.25% ,6.25% 
297  * Unlockable Amount(%)
298  *    ^
299  * 100|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
300  *    |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _     *   :
301  *    |_ _ _ _ _ _ _ _ _ _ _ _ _      *   :        : 
302  *    |                         *:        :        : 
303  *  75|_ _ _ _ _ _ _ _ _    *    :        :        : 
304  *    |                *:        :        :        : 
305  *    |             *   :        :        :        : 
306  *    |          *      :        :        :        : 
307  *  50|_ _ _ _ *        :        :        :        :   
308  *    |       *:        :        :        :        : 
309  *    |      * :        :        :        :        : 
310  *    |     *  :        :        :        :        : 
311  *    |    *   :        :        :        :        : 
312  *    |   *    :        :        :        :        : 
313  *    |  *     :        :        :        :        : 
314  *    | *      :        :        :        :        : 
315  *    |*       :        :        :        :        : 
316  *    +--------*--------*--------*--------*--------*---> Time(year)
317  *    0        1        2        3        4        5    
318  */
319 contract TokenLock is Owned{
320     using SafeMath for uint256;
321 
322     LifeBankerCoin public LBC;
323 
324     uint256 public totalSupply = 10000000000000000000000000000;
325     uint256 public totalLocked = totalSupply.div(2); // 50% of totalSupply
326     uint256 public collectedTokens;
327     uint256 public startTime;
328 
329     address public POSAddress       = 0x23eB4df52175d89d8Df83F44992A5723bBbac00c; //30% DPOS
330     address public CommunityAddress = 0x9370973BEa603b86F07C2BFA8461f178081ce49F; //10% Community promotion
331     address public OperationAddress = 0x69Ce6E9E77869bFcf0Ec3c217b5e7E4905F4AFFf; //10% Operation and maintenance
332 
333     uint256 _1stYear = totalLocked.mul(5000).div(10000);  // 50%
334     uint256 _2stYear = totalLocked.mul(2500).div(10000);  // 25%
335     uint256 _3stYear = totalLocked.mul(1250).div(10000);  // 12.5%
336     uint256 _4stYear = totalLocked.mul(625).div(10000);   // 6.25%
337     uint256 _5stYear = totalLocked.mul(625).div(10000);   // 6.25%
338 
339     mapping (address => bool) public whiteList;
340     
341 
342     event TokensWithdrawn(uint256 _amount);
343     event LogMangeWhile(address indexed _dest, bool _allow);
344     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
345 
346     modifier onlyWhite() { 
347         require (whiteList[msg.sender] == true); 
348         _; 
349     }
350 
351     /// @param _lbc address : LifeBankerCoin contract deployment address
352     constructor(address _lbc) public{
353         startTime = now;
354         LBC = LifeBankerCoin(_lbc);
355         whiteList[msg.sender] = true;
356     }
357     
358     /**
359      * @dev Add or remove call permissions for an address
360      * @param _dest    address  : The address of the permission to be modified
361      * @param _allow   bool     : True means increase, False means remove
362      * @return success bool     : Successful operation returns True
363      */
364     function mangeWhileList(address _dest, bool _allow) onlyOwner public returns(bool success){
365         require(_dest != address(0));
366 
367         whiteList[_dest] = _allow;
368         emit LogMangeWhile(_dest, _allow);
369         return true;
370     }
371 
372     /* @dev Called by 'owner' to unlock the token.   */
373     function unlock() public onlyWhite returns(bool success){
374         uint256 canExtract = calculation();
375         uint256 _amount = canExtract.sub(collectedTokens); // canExtract - collectedTokens
376         distribute(_amount);
377         collectedTokens = collectedTokens.add(_amount);
378 
379         return true;
380     }
381 
382     /*
383      * @dev Calculates the total number of tokens that can be unlocked based on time.
384      * @return uint256 : total number of unlockable
385      */
386     function calculation() view public returns(uint256){
387         uint256 _month = getMonths();
388         uint256 _amount;
389 
390         if (_month == 0){
391             return 0;
392         }
393 
394         if (_month <= 12 ){
395             _amount = _1stYear.mul(_month).div(12);
396 
397         }else if(_month <= 24){
398             // _1stYear + [_2stYear * (moneth - 12) / 12]
399             _amount = _1stYear;
400             _amount = _amount.add(_2stYear.mul(_month.sub(12)).div(12));
401 
402         }else if(_month <= 36){
403             // _1stYear + _2stYear + [_3stYear * (moneth - 24) / 12]
404             _amount = _1stYear + _2stYear;
405             _amount = _amount.add(_3stYear.mul(_month.sub(24)).div(12));
406 
407         }else if(_month <= 48){
408             // _1stYear + _2stYear + _3stYear + [_4stYear * (moneth - 36) / 12]
409             _amount = _1stYear + _2stYear + _3stYear;
410             _amount = _amount.add(_4stYear.mul(_month.sub(36)).div(12));      
411 
412         }else if(_month <= 60){
413             // _1stYear + _2stYear + _3stYear + _4stYear + [_5stYear * (moneth - 48) / 12]
414             _amount = _1stYear + _2stYear + _3stYear + _4stYear;
415             _amount = _amount.add(_5stYear.mul(_month.sub(48)).div(12)); 
416 
417         }else{
418             // more than 5years
419             _amount = LBC.balanceOf(this);
420         }
421         return _amount;
422     }
423 
424     /* Get how many months have passed since the contract was deployed. */
425     function getMonths() view public returns(uint256){
426         uint256 countMonth = (getTime().sub(startTime)).div(30 * 24 * 3600);
427         return countMonth; // begin 0
428     }
429 
430     /*
431      * @dev Distribute unlockable tokens to three addresses, proportion 3:1:1
432      * @param _amount uint256 : Number of tokens that can be unlocked
433      */
434     function distribute(uint256 _amount) internal returns(bool){
435         require (_amount != 0);
436 
437         uint256 perAmount = _amount.div(5);
438         
439         assert (LBC.transfer(POSAddress, perAmount.mul(3)));
440         assert (LBC.transfer(CommunityAddress, perAmount.mul(1)));
441         assert (LBC.transfer(OperationAddress, perAmount.mul(1)));
442 
443         emit TokensWithdrawn(_amount);
444         return true;
445     }
446 
447     /* Get the timestamp of the current block */
448     function getTime() view public returns(uint256){
449         return now; //block.timestamp
450     }
451 
452 
453     /// Safe Function
454     /// @dev This method can be used by the controller to extract mistakenly
455     /// @param _token The address of the token contract that you want to recover
456     function claimTokens(address _token) public onlyOwner returns(bool){
457         require(_token != address(LBC));
458 
459         ERC20 token = ERC20(_token);
460         uint256 balance = token.balanceOf(this);
461         token.transfer(owner, balance);
462         emit ClaimedTokens(_token, owner, balance);
463         return true;
464     }
465 }
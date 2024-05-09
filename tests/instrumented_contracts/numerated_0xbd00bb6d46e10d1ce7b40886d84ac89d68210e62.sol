1 pragma solidity ^0.4.21;
2 
3 
4 contract Owned {
5     address public owner;
6     address public newOwner;
7 
8     function Owned() {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         assert(msg.sender == owner);
14         _;
15     }
16 
17     function transferOwnership(address _newOwner) public onlyOwner {
18         require(_newOwner != owner);
19         newOwner = _newOwner;
20     }
21 
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         OwnerUpdate(owner, newOwner);
25         owner = newOwner;
26         newOwner = 0x0;
27     }
28 
29     event OwnerUpdate(address _prevOwner, address _newOwner);
30 }
31 
32 
33 library SafeMath {
34 
35   /**
36   * @dev Multiplies two numbers, throws on overflow.
37   */
38   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     if (a == 0) {
40       return 0;
41     }
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 interface ERC20TokenInterface {
76     function totalSupply() public constant returns (uint256 _totalSupply);
77     function balanceOf(address _owner) public constant returns (uint256 balance);
78     function transfer(address _to, uint256 _value) public returns (bool success);
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
80     function approve(address _spender, uint256 _value) public returns (bool success);
81     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
82     
83     event Transfer(address indexed _from, address indexed _to, uint256 _value);
84     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
85 }
86 
87 interface TokenVestingInterface {
88     function getReleasableFunds() public view returns(uint256);
89     function release() public ;
90     function setWithdrawalAddress(address _newAddress) external;
91     function revoke(string _reason) public;
92     function getTokenBalance() public constant returns(uint256);
93     function updateBalanceOnFunding(uint256 _amount) external;
94     function salvageOtherTokensFromContract(address _tokenAddress, address _to, uint _amount) external;
95 }
96 
97 
98 interface VestingMasterInterface{
99     function amountLockedInVestings() view public returns (uint256);
100     function substractLockedAmount(uint256 _amount) external;
101     function addLockedAmount(uint256 _amount) external;
102     function addInternalBalance(uint256 _amount) external;
103 }
104 
105 contract TokenVestingContract is Owned {
106     using SafeMath for uint256;
107     
108     address public beneficiary;
109     address public tokenAddress;
110     uint256 public startTime;
111     uint256 public tickDuration;
112     uint256 public amountPerTick;
113     uint256 public version;
114     bool public revocable;
115     
116 
117     uint256 public alreadyReleasedAmount;
118     bool public revoked;
119     uint256 public internalBalance;
120     
121     event Released(uint256 amount);
122     event RevokedAndDestroyed(string reason);
123     event WithdrawalAddressSet(address _newAddress);
124     event TokensReceivedSinceLastCheck(uint256 amount);
125     event VestingReceivedFunding(uint256 amount);
126 
127     function TokenVestingContract(address _beneficiary,
128                 address _tokenAddress,
129                 uint256 _startTime, 
130                 uint256 _tickDuration, 
131                 uint256 _amountPerTick,
132                 uint256 _version,
133                 bool _revocable
134                 )public onlyOwner{
135                     beneficiary = _beneficiary;
136                     tokenAddress = _tokenAddress;
137                     startTime = _startTime;
138                     tickDuration = _tickDuration;
139                     amountPerTick = _amountPerTick;
140                     version =  _version;
141                     revocable = _revocable;
142                     alreadyReleasedAmount = 0;
143                     revoked = false;
144                     internalBalance = 0;
145     }
146     
147     function getReleasableFunds() public view returns(uint256){
148         uint256 balance = ERC20TokenInterface(tokenAddress).balanceOf(address(this));
149         // check if there is balance and if it is active yet
150         if (balance == 0 || (startTime >= now)){
151             return 0;
152         }
153         // all funds that may be released according to vesting schedule 
154         uint256 vestingScheduleAmount = (now.sub(startTime) / tickDuration) * amountPerTick;
155         // deduct already released funds 
156         uint256 releasableFunds = vestingScheduleAmount.sub(alreadyReleasedAmount);
157         // make sure to release remainder of funds for last payout
158         if(releasableFunds > balance){
159             releasableFunds = balance;
160         }
161         return releasableFunds;
162     }
163     
164     function setWithdrawalAddress(address _newAddress) public onlyOwner {
165         beneficiary = _newAddress;
166         
167         emit WithdrawalAddressSet(_newAddress);
168     }
169     
170     function release() public returns(uint256 transferedAmount) {
171         checkForReceivedTokens();
172         require(msg.sender == beneficiary);//, "Funds may be released only to beneficiary");
173         uint256 amountToTransfer = getReleasableFunds();
174         require(amountToTransfer > 0);//, "Out of funds");
175         // internal accounting
176         alreadyReleasedAmount = alreadyReleasedAmount.add(amountToTransfer);
177         internalBalance = internalBalance.sub(amountToTransfer);
178         VestingMasterInterface(owner).substractLockedAmount(amountToTransfer);
179         // actual transfer
180         ERC20TokenInterface(tokenAddress).transfer(beneficiary, amountToTransfer);
181         emit Released(amountToTransfer);
182         return amountToTransfer;
183     }
184     
185     function revoke(string _reason) external onlyOwner {
186         require(revocable);
187         // returns funds not yet vested according to vesting schedule
188         uint256 releasableFunds = getReleasableFunds();
189         ERC20TokenInterface(tokenAddress).transfer(beneficiary, releasableFunds);
190         VestingMasterInterface(owner).substractLockedAmount(releasableFunds);  // have to do it here, can't use return, because contract selfdestructs
191         // returns remainder of funds to VestingMaster and kill vesting contract
192         VestingMasterInterface(owner).addInternalBalance(getTokenBalance());
193         ERC20TokenInterface(tokenAddress).transfer(owner, getTokenBalance());
194         emit RevokedAndDestroyed(_reason);
195         selfdestruct(owner);
196     }
197     
198     function getTokenBalance() public view returns(uint256 tokenBalance) {
199         return ERC20TokenInterface(tokenAddress).balanceOf(address(this));
200     }
201     // todo public or internal?
202     // master calls this when it uploads funds in order to differentiate betwen funds from master and 3rd party
203     function updateBalanceOnFunding(uint256 _amount) external onlyOwner{
204         internalBalance = internalBalance.add(_amount);
205         emit VestingReceivedFunding(_amount);
206     }
207     // check for changes in balance in order to track amount of locked tokens and notify master
208     function checkForReceivedTokens() public{
209         if (getTokenBalance() != internalBalance){
210             uint256 receivedFunds = getTokenBalance().sub(internalBalance);
211             internalBalance = getTokenBalance();
212             VestingMasterInterface(owner).addLockedAmount(receivedFunds);
213             emit TokensReceivedSinceLastCheck(receivedFunds);
214         }
215     }
216     function salvageOtherTokensFromContract(address _tokenAddress, address _to, uint _amount) external onlyOwner {
217         require(_tokenAddress != tokenAddress);
218         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
219     }
220 }
221 
222 
223 contract VestingMasterContract is Owned {
224     using SafeMath for uint256;
225    
226     // TODO: set this before deploy
227     address public constant tokenAddress = 0xc7C03B8a3FC5719066E185ea616e87B88eba44a3;   
228     uint256 public internalBalance = 0;
229     uint256 public amountLockedInVestings = 0;
230     
231     struct VestingStruct{
232         uint256 arrayPointer;
233         string vestingType;
234         uint256 version;
235         
236     }
237     address[] public vestingAddresses;
238     mapping (address => VestingStruct) public addressToVesting;
239     
240     event VestingContractFunded(address beneficiary, address tokenAddress, uint256 amount);
241     event LockedAmountDecreased(uint256 amount);
242     event LockedAmountIncreased(uint256 amount);
243     event TokensReceivedSinceLastCheck(uint256 amount);
244 
245     ////////// STORAGE HELPERS  ///////////
246     function vestingExists(address _vestingAddress) public view returns(bool exists){
247         if(vestingAddresses.length == 0) {return false;}
248         return (vestingAddresses[addressToVesting[_vestingAddress].arrayPointer] == _vestingAddress);
249     }
250     
251     function storeNewVesting(address _vestingAddress, string _vestingType, uint256 _version) public onlyOwner returns(uint256 vestingsLength) {
252         require(!vestingExists(_vestingAddress));
253         addressToVesting[_vestingAddress].version = _version;
254         addressToVesting[_vestingAddress].vestingType = _vestingType ;
255         addressToVesting[_vestingAddress].arrayPointer = vestingAddresses.push(_vestingAddress) - 1;
256         return vestingAddresses.length;
257     }
258 
259     function deleteVestingFromStorage(address _vestingAddress) public onlyOwner returns(uint256 vestingsLength) {
260         require(vestingExists(_vestingAddress));
261         uint256 indexToDelete = addressToVesting[_vestingAddress].arrayPointer;
262         address keyToMove = vestingAddresses[vestingAddresses.length - 1];
263         vestingAddresses[indexToDelete] = keyToMove;
264         addressToVesting[keyToMove].arrayPointer = indexToDelete;
265         vestingAddresses.length--;
266         return vestingAddresses.length;
267     }
268     
269     function createNewVesting(
270         // todo uncomment
271         address _beneficiary,
272         uint256 _startTime, 
273         uint256 _tickDuration, 
274         uint256 _amountPerTick,
275         string _vestingType,
276         uint256 _version,
277         bool _revocable
278         ) 
279         
280         public onlyOwner returns(address){
281             TokenVestingContract newVesting = new TokenVestingContract(   
282                 _beneficiary,
283                 tokenAddress,
284                 _startTime, 
285                 _tickDuration, 
286                 _amountPerTick,
287                 _version,
288                 _revocable
289                 );
290            
291         storeNewVesting(newVesting, _vestingType, _version);
292         return newVesting;
293     }
294     
295     // add funds to vesting contract
296     function fundVesting(address _vestingContract, uint256 _amount) public onlyOwner {
297         // convenience, so you don't have to call it manualy if you just uploaded funds
298         checkForReceivedTokens();
299         // check if there is actually enough funds
300         require((internalBalance >= _amount) && (getTokenBalance() >= _amount));
301         // make sure that fundee is vesting contract on the list
302         require(vestingExists(_vestingContract)); 
303         internalBalance = internalBalance.sub(_amount);
304         ERC20TokenInterface(tokenAddress).transfer(_vestingContract, _amount);
305         TokenVestingInterface(_vestingContract).updateBalanceOnFunding(_amount);
306         emit VestingContractFunded(_vestingContract, tokenAddress, _amount);
307     }
308     
309     function getTokenBalance() public constant returns(uint256) {
310         return ERC20TokenInterface(tokenAddress).balanceOf(address(this));
311     }
312     // revoke vesting; release releasable funds to beneficiary and return remaining to master and kill vesting contract
313     function revokeVesting(address _vestingContract, string _reason) public onlyOwner{
314         TokenVestingInterface subVestingContract = TokenVestingInterface(_vestingContract);
315         subVestingContract.revoke(_reason);
316         deleteVestingFromStorage(_vestingContract);
317     }
318     // when vesting is revoked it sends back remaining tokens and updates internalBalance
319     function addInternalBalance(uint256 _amount) external {
320         require(vestingExists(msg.sender));
321         internalBalance = internalBalance.add(_amount);
322     }
323     // vestings notifies if there has been any changes in amount of locked tokens
324     function addLockedAmount(uint256 _amount) external {
325         require(vestingExists(msg.sender));
326         amountLockedInVestings = amountLockedInVestings.add(_amount);
327         emit LockedAmountIncreased(_amount);
328     }
329     // vestings notifies if there has been any changes in amount of locked tokens
330     function substractLockedAmount(uint256 _amount) external {
331         require(vestingExists(msg.sender));
332         amountLockedInVestings = amountLockedInVestings.sub(_amount);
333         emit LockedAmountDecreased(_amount);
334     }
335     // check for changes in balance in order to track amount of locked tokens
336     function checkForReceivedTokens() public{
337         if (getTokenBalance() != internalBalance){
338             uint256 receivedFunds = getTokenBalance().sub(internalBalance);
339             amountLockedInVestings = amountLockedInVestings.add(receivedFunds);
340             internalBalance = getTokenBalance();
341             emit TokensReceivedSinceLastCheck(receivedFunds);
342         }else{
343         emit TokensReceivedSinceLastCheck(0);
344         }
345     }
346     function salvageOtherTokensFromContract(address _tokenAddress, address _contractAddress, address _to, uint _amount) public onlyOwner {
347         require(_tokenAddress != tokenAddress);
348         if (_contractAddress == address(this)){
349             ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
350         }
351         if (vestingExists(_contractAddress)){
352             TokenVestingInterface(_contractAddress).salvageOtherTokensFromContract(_tokenAddress, _to, _amount);
353         }
354     }
355     
356     function killContract() public onlyOwner{
357         require(vestingAddresses.length == 0);
358         ERC20TokenInterface(tokenAddress).transfer(owner, getTokenBalance());
359         selfdestruct(owner);
360     }
361     function setWithdrawalAddress(address _vestingContract, address _beneficiary) public onlyOwner{
362         require(vestingExists(_vestingContract));
363         TokenVestingInterface(_vestingContract).setWithdrawalAddress(_beneficiary);
364     }
365 }
366 
367 
368 contract EligmaSupplyContract  is Owned {
369     address public tokenAddress;
370     address public vestingMasterAddress;
371     
372     function EligmaSupplyContract(address _tokenAddress, address _vestingMasterAddress) public onlyOwner{
373         tokenAddress = _tokenAddress;
374         vestingMasterAddress = _vestingMasterAddress;
375     }
376     
377     function totalSupply() view public returns(uint256) {
378         return ERC20TokenInterface(tokenAddress).totalSupply();
379     }
380     
381     function lockedSupply() view public returns(uint256) {
382         return VestingMasterInterface(vestingMasterAddress).amountLockedInVestings();
383     }
384     
385     function avaliableSupply() view public returns(uint256) {
386         return ERC20TokenInterface(tokenAddress).totalSupply() - VestingMasterInterface(vestingMasterAddress).amountLockedInVestings();
387     }
388     
389     function setTokenAddress(address _tokenAddress) onlyOwner public {
390         tokenAddress = _tokenAddress;
391     }
392     
393     function setVestingMasterAddress(address _vestingMasterAddress) onlyOwner public {
394         vestingMasterAddress = _vestingMasterAddress;
395     }
396 }
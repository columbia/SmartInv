1 pragma solidity >=0.4.22 <0.6.0;
2 
3 //-----------------------------------------------------------------------------
4 /// @title Ownable
5 /// @dev The Ownable contract has an owner address, and provides basic 
6 ///  authorization control functions, this simplifies the implementation of
7 ///  "user permissions".
8 //-----------------------------------------------------------------------------
9 contract Ownable {
10     //-------------------------------------------------------------------------
11     /// @dev Emits when owner address changes by any mechanism.
12     //-------------------------------------------------------------------------
13     event OwnershipTransfer (address previousOwner, address newOwner);
14     
15     // Wallet address that can sucessfully execute onlyOwner functions
16     address owner;
17     
18     //-------------------------------------------------------------------------
19     /// @dev Sets the owner of the contract to the sender account.
20     //-------------------------------------------------------------------------
21     constructor() public {
22         owner = msg.sender;
23         emit OwnershipTransfer(address(0), owner);
24     }
25 
26     //-------------------------------------------------------------------------
27     /// @dev Throws if called by any account other than `owner`.
28     //-------------------------------------------------------------------------
29     modifier onlyOwner() {
30         require(
31             msg.sender == owner, 
32             "Function can only be called by contract owner"
33         );
34         _;
35     }
36 
37     //-------------------------------------------------------------------------
38     /// @notice Transfer control of the contract to a newOwner.
39     /// @dev Throws if `_newOwner` is zero address.
40     /// @param _newOwner The address to transfer ownership to.
41     //-------------------------------------------------------------------------
42     function transferOwnership(address _newOwner) public onlyOwner {
43         // for safety, new owner parameter must not be 0
44         require (
45             _newOwner != address(0),
46             "New owner address cannot be zero"
47         );
48         // define local variable for old owner
49         address oldOwner = owner;
50         // set owner to new owner
51         owner = _newOwner;
52         // emit ownership transfer event
53         emit OwnershipTransfer(oldOwner, _newOwner);
54     }
55 }
56 
57 
58 interface VIP181 {
59     function ownerOf(uint256 _tokenId) external view returns(address payable);
60     function getApproved(uint256 _tokenId) external view returns(address);
61     function isApprovedForAll(address _owner, address _operator) external view returns(bool);
62 }
63 
64 
65 interface VIP180 {
66     function balanceOf(address _tokenOwner) external view returns(uint);
67     function transfer(address _to, uint _tokens) external returns(bool);
68     function transferFrom(address _from, address _to, uint _tokens) external returns(bool);
69 }
70 
71 
72 //-----------------------------------------------------------------------------
73 /// @title AAC External Token Handler
74 /// @notice Defines depositing and withdrawal of VET and VIP-180-compliant
75 ///  tokens into AACs.
76 //-----------------------------------------------------------------------------
77 contract AacExternalTokens is Ownable {
78     //-------------------------------------------------------------------------
79     /// @dev Emits when external tokens are deposited into AACs from a wallet.
80     //-------------------------------------------------------------------------
81     event DepositExternal(
82         address indexed _from,  
83         uint indexed _to, 
84         address indexed _tokenContract, 
85         uint _tokens
86     );
87     
88     //-------------------------------------------------------------------------
89     /// @dev Emits when external tokens are withdrawn from AACs to a wallet.
90     //-------------------------------------------------------------------------
91     event WithdrawExternal(
92         uint indexed _from, 
93         address indexed _to, 
94         address indexed _tokenContract, 
95         uint _tokens
96     );
97     
98     //-------------------------------------------------------------------------
99     /// @dev Emits when external tokens are tranferred from AACs to another AAC.
100     //-------------------------------------------------------------------------
101     event TransferExternal(
102         uint indexed _from, 
103         uint indexed _to, 
104         address indexed _tokenContract, 
105         uint _tokens
106     );
107     
108     // AAC contract
109     VIP181 public aacContract;
110     // handles the balances of AACs for every VIP180 token address
111     mapping (address => mapping(uint => uint)) externalTokenBalances;
112     // enumerates the deposited VIP180 contract addresses
113     address[] public trackedVip180s;
114     // guarantees above array contains unique addresses
115     mapping (address => bool) isTracking;
116     uint constant UID_MAX = 0xFFFFFFFFFFFFFF;
117 
118     //-------------------------------------------------------------------------
119     /// @dev Throws if called by any account other than token owner, approved
120     ///  address, or authorized operator.
121     //-------------------------------------------------------------------------
122     modifier canOperate(uint _uid) {
123         // sender must be owner of AAC #uid, or sender must be the
124         //  approved address of AAC #uid, or an authorized operator for
125         //  AAC owner
126         address owner = aacContract.ownerOf(_uid);
127         require (
128             msg.sender == owner ||
129             msg.sender == aacContract.getApproved(_uid) ||
130             aacContract.isApprovedForAll(owner, msg.sender),
131             "Not authorized to operate for this AAC"
132         );
133         _;
134     }
135     
136     //-------------------------------------------------------------------------
137     /// @dev Throws if parameter is zero
138     //-------------------------------------------------------------------------
139     modifier notZero(uint _param) {
140         require(_param != 0, "Parameter cannot be zero");
141         _;
142     }
143     
144     function setAacContract(address _aacAddress) external onlyOwner {
145         aacContract = VIP181(_aacAddress);
146     }
147     
148     //-------------------------------------------------------------------------
149     /// @notice Deposit VET from sender to approved AAC
150     /// @dev Throws if VET to deposit is zero. Throws if sender is not
151     ///  approved to operate AAC #`toUid`. Throws if sender has insufficient 
152     ///  balance for deposit.
153     /// @param _toUid the AAC to deposit the VET into
154     //-------------------------------------------------------------------------
155     function depositVET(uint _toUid) 
156         external 
157         payable 
158         canOperate(_toUid)
159         notZero(msg.value)
160     {
161         // add amount to AAC's balance
162         externalTokenBalances[address(this)][_toUid] += msg.value;
163         // emit event
164         emit DepositExternal(msg.sender, _toUid, address(this), msg.value);
165     }
166 
167     //-------------------------------------------------------------------------
168     /// @notice Withdraw VET from approved AAC to AAC's owner
169     /// @dev Throws if VET to withdraw is zero. Throws if sender is not an
170     ///  approved operator for AAC #`_fromUid`. Throws if AAC 
171     ///  #`_fromUid` has insufficient balance to withdraw.
172     /// @param _fromUid the AAC to withdraw the VET from
173     /// @param _amount the amount of VET to withdraw (in Wei)
174     //-------------------------------------------------------------------------
175     function withdrawVET(
176         uint _fromUid, 
177         uint _amount
178     ) external canOperate(_fromUid) notZero(_amount) {
179         // AAC must have sufficient VET balance
180         require (
181             externalTokenBalances[address(this)][_fromUid] >= _amount,
182             "Insufficient VET to withdraw"
183         );
184         // subtract amount from AAC's balance
185         externalTokenBalances[address(this)][_fromUid] -= _amount;
186         address payable receiver = aacContract.ownerOf(_fromUid);
187         // call transfer function
188         receiver.transfer(_amount);
189         // emit event
190         emit WithdrawExternal(_fromUid, receiver, address(this), _amount);
191     }
192 
193     //-------------------------------------------------------------------------
194     /// @notice Withdraw VET from approved AAC and send to '_to'
195     /// @dev Throws if VET to transfer is zero. Throws if sender is not an
196     ///  approved operator for AAC #`_fromUid`. Throws if AAC
197     ///  #`_fromUid` has insufficient balance to withdraw.
198     /// @param _fromUid the AAC to withdraw and send the VET from
199     /// @param _to the address to receive the transferred VET
200     /// @param _amount the amount of VET to withdraw (in Wei)
201     //-------------------------------------------------------------------------
202     function transferVETToWallet(
203         uint _fromUid,
204         address payable _to,
205         uint _amount
206     ) external canOperate(_fromUid) notZero(_amount) {
207         // AAC must have sufficient VET balance
208         require (
209             externalTokenBalances[address(this)][_fromUid] >= _amount,
210             "Insufficient VET to transfer"
211         );
212         // subtract amount from AAC's balance
213         externalTokenBalances[address(this)][_fromUid] -= _amount;
214         // call transfer function
215         _to.transfer(_amount);
216         // emit event
217         emit WithdrawExternal(_fromUid, _to, address(this), _amount);
218     }
219     
220     //-------------------------------------------------------------------------
221     /// @notice Transfer VET from your AAC to another AAC
222     /// @dev Throws if tokens to transfer is zero. Throws if sender is not an
223     ///  approved operator for AAC #`_fromUid`. Throws if AAC #`_fromUid` has 
224     ///  insufficient balance to transfer. Throws if receiver does not exist.
225     /// @param _fromUid the AAC to withdraw the VIP-180 tokens from
226     /// @param _toUid the identifier of the AAC to receive the VIP-180 tokens
227     /// @param _amount the number of tokens to send
228     //-------------------------------------------------------------------------
229     function transferVETToAAC (
230         uint _fromUid, 
231         uint _toUid, 
232         uint _amount
233     ) external canOperate(_fromUid) notZero(_amount) {
234         // receiver must have an owner
235         require(aacContract.ownerOf(_toUid) != address(0), "Invalid receiver UID");
236         // AAC must have sufficient token balance
237         require (
238             externalTokenBalances[address(this)][_fromUid] >= _amount,
239             "insufficient tokens to transfer"
240         );
241         // subtract amount from sender's balance
242         externalTokenBalances[address(this)][_fromUid] -= _amount;
243         
244         // add amount to receiver's balance
245         externalTokenBalances[address(this)][_toUid] += _amount;
246         // emit event
247         emit TransferExternal(_fromUid, _toUid, address(this), _amount);
248     }
249 
250     //-------------------------------------------------------------------------
251     /// @notice Deposit VIP-180 tokens from sender to approved AAC
252     /// @dev This contract address must be an authorized spender for sender.
253     ///  Throws if tokens to deposit is zero. Throws if sender is not an
254     ///  approved operator for AAC #`toUid`. Throws if this contract address
255     ///  has insufficient allowance for transfer. Throws if sender has  
256     ///  insufficient balance for deposit. Throws if tokenAddress has no
257     ///  transferFrom function.
258     /// @param _tokenAddress the VIP-180 contract address
259     /// @param _toUid the AAC to deposit the VIP-180 tokens into
260     /// @param _tokens the number of tokens to deposit
261     //-------------------------------------------------------------------------
262     function depositTokens (
263         address _tokenAddress, 
264         uint _toUid, 
265         uint _tokens
266     ) external canOperate(_toUid) notZero(_tokens) {
267         // add token contract address to list of tracked token addresses
268         if (isTracking[_tokenAddress] == false) {
269             trackedVip180s.push(_tokenAddress);
270             isTracking[_tokenAddress] = true;
271         }
272 
273         // initialize token contract
274         VIP180 tokenContract = VIP180(_tokenAddress);
275         // add amount to AAC's balance
276         externalTokenBalances[_tokenAddress][_toUid] += _tokens;
277 
278         // call transferFrom function from token contract
279         tokenContract.transferFrom(msg.sender, address(this), _tokens);
280         // emit event
281         emit DepositExternal(msg.sender, _toUid, _tokenAddress, _tokens);
282     }
283 
284     //-------------------------------------------------------------------------
285     /// @notice Deposit VIP-180 tokens from '_to' to approved AAC
286     /// @dev This contract address must be an authorized spender for '_from'.
287     ///  Throws if tokens to deposit is zero. Throws if sender is not an
288     ///  approved operator for AAC #`toUid`. Throws if this contract address
289     ///  has insufficient allowance for transfer. Throws if sender has
290     ///  insufficient balance for deposit. Throws if tokenAddress has no
291     ///  transferFrom function.
292     /// @param _tokenAddress the VIP-180 contract address
293     /// @param _from the address sending VIP-180 tokens to deposit
294     /// @param _toUid the AAC to deposit the VIP-180 tokens into
295     /// @param _tokens the number of tokens to deposit
296     //-------------------------------------------------------------------------
297     function depositTokensFrom (
298         address _tokenAddress,
299         address _from,
300         uint _toUid,
301         uint _tokens
302     ) external canOperate(_toUid) notZero(_tokens) {
303         // add token contract address to list of tracked token addresses
304         if (isTracking[_tokenAddress] == false) {
305             trackedVip180s.push(_tokenAddress);
306             isTracking[_tokenAddress] = true;
307         }
308         // initialize token contract
309         VIP180 tokenContract = VIP180(_tokenAddress);
310         // add amount to AAC's balance
311         externalTokenBalances[_tokenAddress][_toUid] += _tokens;
312 
313         // call transferFrom function from token contract
314         tokenContract.transferFrom(_from, address(this), _tokens);
315         // emit event
316         emit DepositExternal(_from, _toUid, _tokenAddress, _tokens);
317     }
318 
319     //-------------------------------------------------------------------------
320     /// @notice Withdraw VIP-180 tokens from approved AAC to AAC's
321     ///  owner
322     /// @dev Throws if tokens to withdraw is zero. Throws if sender is not an
323     ///  approved operator for AAC #`_fromUid`. Throws if AAC 
324     ///  #`_fromUid` has insufficient balance to withdraw. Throws if 
325     ///  tokenAddress has no transfer function.
326     /// @param _tokenAddress the VIP-180 contract address
327     /// @param _fromUid the AAC to withdraw the VIP-180 tokens from
328     /// @param _tokens the number of tokens to withdraw
329     //-------------------------------------------------------------------------
330     function withdrawTokens (
331         address _tokenAddress, 
332         uint _fromUid, 
333         uint _tokens
334     ) external canOperate(_fromUid) notZero(_tokens) {
335         // AAC must have sufficient token balance
336         require (
337             externalTokenBalances[_tokenAddress][_fromUid] >= _tokens,
338             "insufficient tokens to withdraw"
339         );
340         // initialize token contract
341         VIP180 tokenContract = VIP180(_tokenAddress);
342         // subtract amount from AAC's balance
343         externalTokenBalances[_tokenAddress][_fromUid] -= _tokens;
344         
345         // call transfer function from token contract
346         tokenContract.transfer(aacContract.ownerOf(_fromUid), _tokens);
347         // emit event
348         emit WithdrawExternal(_fromUid, msg.sender, _tokenAddress, _tokens);
349     }
350 
351     //-------------------------------------------------------------------------
352     /// @notice Transfer VIP-180 tokens from your AAC to `_to`
353     /// @dev Throws if tokens to transfer is zero. Throws if sender is not an
354     ///  approved operator for AAC #`_fromUid`. Throws if AAC 
355     ///  #`_fromUid` has insufficient balance to transfer. Throws if 
356     ///  tokenAddress has no transfer function.
357     /// @param _tokenAddress the VIP-180 contract address
358     /// @param _fromUid the AAC to withdraw the VIP-180 tokens from
359     /// @param _to the wallet address to receive the VIP-180 tokens
360     /// @param _tokens the number of tokens to send
361     //-------------------------------------------------------------------------
362     function transferTokensToWallet (
363         address _tokenAddress, 
364         uint _fromUid, 
365         address _to, 
366         uint _tokens
367     ) external canOperate(_fromUid) notZero(_tokens) {
368         // AAC must have sufficient token balance
369         require (
370             externalTokenBalances[_tokenAddress][_fromUid] >= _tokens,
371             "insufficient tokens to transfer"
372         );
373         // initialize token contract
374         VIP180 tokenContract = VIP180(_tokenAddress);
375         // subtract amount from AAC's balance
376         externalTokenBalances[_tokenAddress][_fromUid] -= _tokens;
377         
378         // call transfer function from token contract
379         tokenContract.transfer(_to, _tokens);
380         // emit event
381         emit WithdrawExternal(_fromUid, _to, _tokenAddress, _tokens);
382     }
383 
384     //-------------------------------------------------------------------------
385     /// @notice Transfer VIP-180 tokens from your AAC to another AAC
386     /// @dev Throws if tokens to transfer is zero. Throws if sender is not an
387     ///  approved operator for AAC #`_fromUid`. Throws if AAC 
388     ///  #`_fromUid` has insufficient balance to transfer. Throws if 
389     ///  tokenAddress has no transfer function. Throws if receiver does not
390     ///  exist.
391     /// @param _tokenAddress the VIP-180 contract address
392     /// @param _fromUid the AAC to withdraw the VIP-180 tokens from
393     /// @param _toUid the identifier of the AAC to receive the VIP-180 tokens
394     /// @param _tokens the number of tokens to send
395     //-------------------------------------------------------------------------
396     function transferTokensToAAC (
397         address _tokenAddress, 
398         uint _fromUid, 
399         uint _toUid, 
400         uint _tokens
401     ) external canOperate(_fromUid) notZero(_tokens) {
402         // receiver must have an owner
403         require(aacContract.ownerOf(_toUid) != address(0), "Invalid receiver UID");
404         // AAC must have sufficient token balance
405         require (
406             externalTokenBalances[_tokenAddress][_fromUid] >= _tokens,
407             "insufficient tokens to transfer"
408         );
409         // subtract amount from sender's balance
410         externalTokenBalances[_tokenAddress][_fromUid] -= _tokens;
411         
412         // add amount to receiver's balance
413         externalTokenBalances[_tokenAddress][_toUid] += _tokens;
414         // emit event
415         emit TransferExternal(_fromUid, _toUid, _tokenAddress, _tokens);
416     }
417     
418     //-------------------------------------------------------------------------
419     /// @notice Transfer balances of external tokens to new uid. AAC contract
420     ///  only.
421     /// @dev throws unless sent by AAC contract
422     //-------------------------------------------------------------------------
423     function onLink(uint _oldUid, uint _newUid) external {
424         require (msg.sender == address(aacContract), "Unauthorized transaction");
425         require (_oldUid > UID_MAX && _newUid <= UID_MAX);
426         address tokenAddress;
427         for(uint i = 0; i < trackedVip180s.length; ++i) {
428             tokenAddress = trackedVip180s[i];
429             externalTokenBalances[tokenAddress][_newUid] = externalTokenBalances[tokenAddress][_oldUid];
430         }
431         externalTokenBalances[address(this)][_newUid] = externalTokenBalances[address(this)][_oldUid];
432     }
433 
434     //-------------------------------------------------------------------------
435     /// @notice Get external token balance for tokens deposited into AAC
436     ///  #`_uid`.
437     /// @dev To query VET, use THIS CONTRACT'S address as '_tokenAddress'.
438     /// @param _uid Owner of the tokens to query
439     /// @param _tokenAddress Token creator contract address 
440     //-------------------------------------------------------------------------
441     function getExternalTokenBalance(
442         uint _uid, 
443         address _tokenAddress
444     ) external view returns (uint) {
445         return externalTokenBalances[_tokenAddress][_uid];
446     }
447 }
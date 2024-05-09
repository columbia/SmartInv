1 pragma solidity 0.4.18;
2 
3 // File: contracts/ERC20Interface.sol
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface ERC20 {
7     function totalSupply() public view returns (uint supply);
8     function balanceOf(address _owner) public view returns (uint balance);
9     function transfer(address _to, uint _value) public returns (bool success);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
11     function approve(address _spender, uint _value) public returns (bool success);
12     function allowance(address _owner, address _spender) public view returns (uint remaining);
13     function decimals() public view returns(uint digits);
14     event Approval(address indexed _owner, address indexed _spender, uint _value);
15 }
16 
17 // File: contracts/ConversionRatesInterface.sol
18 
19 interface ConversionRatesInterface {
20 
21     function recordImbalance(
22         ERC20 token,
23         int buyAmount,
24         uint rateUpdateBlock,
25         uint currentBlock
26     )
27         public;
28 
29     function getRate(ERC20 token, uint currentBlockNumber, bool buy, uint qty) public view returns(uint);
30     function setQtyStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
31     function setImbalanceStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
32     function claimAdmin() public;
33     function addOperator(address newOperator) public;
34     function transferAdmin(address newAdmin) public;
35     function addToken(ERC20 token) public;
36     function setTokenControlInfo(
37         ERC20 token,
38         uint minimalRecordResolution,
39         uint maxPerBlockImbalance,
40         uint maxTotalImbalance
41     ) public;
42     function enableTokenTrade(ERC20 token) public;
43     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint);
44 }
45 
46 // File: contracts/PermissionGroups.sol
47 
48 contract PermissionGroups {
49 
50     address public admin;
51     address public pendingAdmin;
52     mapping(address=>bool) internal operators;
53     mapping(address=>bool) internal alerters;
54     address[] internal operatorsGroup;
55     address[] internal alertersGroup;
56     uint constant internal MAX_GROUP_SIZE = 50;
57 
58     function PermissionGroups() public {
59         admin = msg.sender;
60     }
61 
62     modifier onlyAdmin() {
63         require(msg.sender == admin);
64         _;
65     }
66 
67     modifier onlyOperator() {
68         require(operators[msg.sender]);
69         _;
70     }
71 
72     modifier onlyAlerter() {
73         require(alerters[msg.sender]);
74         _;
75     }
76 
77     function getOperators () external view returns(address[]) {
78         return operatorsGroup;
79     }
80 
81     function getAlerters () external view returns(address[]) {
82         return alertersGroup;
83     }
84 
85     event TransferAdminPending(address pendingAdmin);
86 
87     /**
88      * @dev Allows the current admin to set the pendingAdmin address.
89      * @param newAdmin The address to transfer ownership to.
90      */
91     function transferAdmin(address newAdmin) public onlyAdmin {
92         require(newAdmin != address(0));
93         TransferAdminPending(pendingAdmin);
94         pendingAdmin = newAdmin;
95     }
96 
97     /**
98      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
99      * @param newAdmin The address to transfer ownership to.
100      */
101     function transferAdminQuickly(address newAdmin) public onlyAdmin {
102         require(newAdmin != address(0));
103         TransferAdminPending(newAdmin);
104         AdminClaimed(newAdmin, admin);
105         admin = newAdmin;
106     }
107 
108     event AdminClaimed( address newAdmin, address previousAdmin);
109 
110     /**
111      * @dev Allows the pendingAdmin address to finalize the change admin process.
112      */
113     function claimAdmin() public {
114         require(pendingAdmin == msg.sender);
115         AdminClaimed(pendingAdmin, admin);
116         admin = pendingAdmin;
117         pendingAdmin = address(0);
118     }
119 
120     event AlerterAdded (address newAlerter, bool isAdd);
121 
122     function addAlerter(address newAlerter) public onlyAdmin {
123         require(!alerters[newAlerter]); // prevent duplicates.
124         require(alertersGroup.length < MAX_GROUP_SIZE);
125 
126         AlerterAdded(newAlerter, true);
127         alerters[newAlerter] = true;
128         alertersGroup.push(newAlerter);
129     }
130 
131     function removeAlerter (address alerter) public onlyAdmin {
132         require(alerters[alerter]);
133         alerters[alerter] = false;
134 
135         for (uint i = 0; i < alertersGroup.length; ++i) {
136             if (alertersGroup[i] == alerter) {
137                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
138                 alertersGroup.length--;
139                 AlerterAdded(alerter, false);
140                 break;
141             }
142         }
143     }
144 
145     event OperatorAdded(address newOperator, bool isAdd);
146 
147     function addOperator(address newOperator) public onlyAdmin {
148         require(!operators[newOperator]); // prevent duplicates.
149         require(operatorsGroup.length < MAX_GROUP_SIZE);
150 
151         OperatorAdded(newOperator, true);
152         operators[newOperator] = true;
153         operatorsGroup.push(newOperator);
154     }
155 
156     function removeOperator (address operator) public onlyAdmin {
157         require(operators[operator]);
158         operators[operator] = false;
159 
160         for (uint i = 0; i < operatorsGroup.length; ++i) {
161             if (operatorsGroup[i] == operator) {
162                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
163                 operatorsGroup.length -= 1;
164                 OperatorAdded(operator, false);
165                 break;
166             }
167         }
168     }
169 }
170 
171 // File: contracts/Withdrawable.sol
172 
173 /**
174  * @title Contracts that should be able to recover tokens or ethers
175  * @author Ilan Doron
176  * @dev This allows to recover any tokens or Ethers received in a contract.
177  * This will prevent any accidental loss of tokens.
178  */
179 contract Withdrawable is PermissionGroups {
180 
181     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
182 
183     /**
184      * @dev Withdraw all ERC20 compatible tokens
185      * @param token ERC20 The address of the token contract
186      */
187     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
188         require(token.transfer(sendTo, amount));
189         TokenWithdraw(token, amount, sendTo);
190     }
191 
192     event EtherWithdraw(uint amount, address sendTo);
193 
194     /**
195      * @dev Withdraw Ethers
196      */
197     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
198         sendTo.transfer(amount);
199         EtherWithdraw(amount, sendTo);
200     }
201 }
202 
203 // File: contracts/wrapperContracts/WrapperBase.sol
204 
205 contract WrapperBase is Withdrawable {
206 
207     PermissionGroups wrappedContract;
208 
209     struct DataTracker {
210         address [] approveSignatureArray;
211         uint lastSetNonce;
212     }
213 
214     DataTracker[] internal dataInstances;
215 
216     function WrapperBase(PermissionGroups _wrappedContract, address _admin) public {
217         require(_wrappedContract != address(0));
218         require(_admin != address(0));
219         wrappedContract = _wrappedContract;
220         admin = _admin;
221     }
222 
223     function claimWrappedContractAdmin() public onlyAdmin {
224         wrappedContract.claimAdmin();
225     }
226 
227     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
228         wrappedContract.transferAdmin(newAdmin);
229     }
230 
231     function addDataInstance() internal returns (uint) {
232         address[] memory add = new address[](0);
233         dataInstances.push(DataTracker(add, 0));
234         return(dataInstances.length - 1);
235     }
236 
237     function setNewData(uint dataIndex) internal {
238         require(dataIndex < dataInstances.length);
239         dataInstances[dataIndex].lastSetNonce++;
240         dataInstances[dataIndex].approveSignatureArray.length = 0;
241     }
242 
243     function addSignature(uint dataIndex, uint signedNonce, address signer) internal returns(bool allSigned) {
244         require(dataIndex < dataInstances.length);
245         require(dataInstances[dataIndex].lastSetNonce == signedNonce);
246 
247         for(uint i = 0; i < dataInstances[dataIndex].approveSignatureArray.length; i++) {
248             if (signer == dataInstances[dataIndex].approveSignatureArray[i]) revert();
249         }
250         dataInstances[dataIndex].approveSignatureArray.push(signer);
251 
252         if (dataInstances[dataIndex].approveSignatureArray.length == operatorsGroup.length) {
253             allSigned = true;
254         } else {
255             allSigned = false;
256         }
257     }
258 
259     function getDataTrackingParameters(uint index) internal view returns (address[], uint) {
260         require(index < dataInstances.length);
261         return(dataInstances[index].approveSignatureArray, dataInstances[index].lastSetNonce);
262     }
263 }
264 
265 // File: contracts/wrapperContracts/WrapConversionRate.sol
266 
267 contract WrapConversionRate is WrapperBase {
268 
269     ConversionRatesInterface conversionRates;
270 
271     //add token parameters
272     ERC20     addTokenToken;
273     uint      addTokenMinimalResolution; // can be roughly 1 cent
274     uint      addTokenMaxPerBlockImbalance; // in twei resolution
275     uint      addTokenMaxTotalImbalance;
276     uint      addTokenDataIndex;
277 
278     //set token control info parameters.
279     ERC20[]     tokenInfoTokenList;
280     uint[]      tokenInfoPerBlockImbalance; // in twei resolution
281     uint[]      tokenInfoMaxTotalImbalance;
282     uint        tokenInfoDataIndex;
283 
284     //general functions
285     function WrapConversionRate(ConversionRatesInterface _conversionRates, address _admin) public
286         WrapperBase(PermissionGroups(address(_conversionRates)), _admin)
287     {
288         require (_conversionRates != address(0));
289         conversionRates = _conversionRates;
290         addTokenDataIndex = addDataInstance();
291         tokenInfoDataIndex = addDataInstance();
292     }
293 
294     function getWrappedContract() public view returns (ConversionRatesInterface _conversionRates) {
295         _conversionRates = conversionRates;
296     }
297 
298     // add token functions
299     //////////////////////
300     function setAddTokenData(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) public onlyOperator {
301         require(minimalRecordResolution != 0);
302         require(maxPerBlockImbalance != 0);
303         require(maxTotalImbalance != 0);
304 
305         //update data tracking
306         setNewData(addTokenDataIndex);
307 
308         addTokenToken = token;
309         addTokenMinimalResolution = minimalRecordResolution; // can be roughly 1 cent
310         addTokenMaxPerBlockImbalance = maxPerBlockImbalance; // in twei resolution
311         addTokenMaxTotalImbalance = maxTotalImbalance;
312     }
313 
314     function signToApproveAddTokenData(uint nonce) public onlyOperator {
315         if(addSignature(addTokenDataIndex, nonce, msg.sender)) {
316             // can perform operation.
317             performAddToken();
318         }
319     }
320 
321     function performAddToken() internal {
322         conversionRates.addToken(addTokenToken);
323 
324         //token control info
325         conversionRates.setTokenControlInfo(
326             addTokenToken,
327             addTokenMinimalResolution,
328             addTokenMaxPerBlockImbalance,
329             addTokenMaxTotalImbalance
330         );
331 
332         //step functions
333         int[] memory zeroArr = new int[](1);
334         zeroArr[0] = 0;
335 
336         conversionRates.setQtyStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
337         conversionRates.setImbalanceStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
338 
339         conversionRates.enableTokenTrade(addTokenToken);
340     }
341 
342     function getAddTokenParameters() public view
343         returns(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance)
344     {
345         token = addTokenToken;
346         minimalRecordResolution = addTokenMinimalResolution;
347         maxPerBlockImbalance = addTokenMaxPerBlockImbalance; // in twei resolution
348         maxTotalImbalance = addTokenMaxTotalImbalance;
349     }
350 
351     function getAddTokenDataTracking() public view returns (address[] signatures, uint nonce) {
352         (signatures, nonce) = getDataTrackingParameters(addTokenDataIndex);
353         return(signatures, nonce);
354     }
355 
356     //set token control info
357     ////////////////////////
358     function setTokenInfoData(ERC20 [] tokens, uint[] maxPerBlockImbalanceValues, uint[] maxTotalImbalanceValues)
359         public
360         onlyOperator
361     {
362         require(maxPerBlockImbalanceValues.length == tokens.length);
363         require(maxTotalImbalanceValues.length == tokens.length);
364 
365         //update data tracking
366         setNewData(tokenInfoDataIndex);
367 
368         tokenInfoTokenList = tokens;
369         tokenInfoPerBlockImbalance = maxPerBlockImbalanceValues;
370         tokenInfoMaxTotalImbalance = maxTotalImbalanceValues;
371     }
372 
373     function signToApproveTokenControlInfo(uint nonce) public onlyOperator {
374         if(addSignature(tokenInfoDataIndex, nonce, msg.sender)) {
375             // can perform operation.
376             performSetTokenControlInfo();
377         }
378     }
379 
380     function performSetTokenControlInfo() internal {
381         require(tokenInfoTokenList.length == tokenInfoPerBlockImbalance.length);
382         require(tokenInfoTokenList.length == tokenInfoMaxTotalImbalance.length);
383 
384         uint minimalRecordResolution;
385         uint rxMaxPerBlockImbalance;
386         uint rxMaxTotalImbalance;
387 
388         for (uint i = 0; i < tokenInfoTokenList.length; i++) {
389             (minimalRecordResolution, rxMaxPerBlockImbalance, rxMaxTotalImbalance) =
390                 conversionRates.getTokenControlInfo(tokenInfoTokenList[i]);
391             require(minimalRecordResolution != 0);
392 
393             conversionRates.setTokenControlInfo(tokenInfoTokenList[i],
394                                                 minimalRecordResolution,
395                                                 tokenInfoPerBlockImbalance[i],
396                                                 tokenInfoMaxTotalImbalance[i]);
397         }
398     }
399 
400     function getControlInfoPerToken (uint index) public view returns(ERC20 token, uint _maxPerBlockImbalance, uint _maxTotalImbalance) {
401         require (tokenInfoTokenList.length > index);
402         require (tokenInfoPerBlockImbalance.length > index);
403         require (tokenInfoMaxTotalImbalance.length > index);
404 
405         return(tokenInfoTokenList[index], tokenInfoPerBlockImbalance[index], tokenInfoMaxTotalImbalance[index]);
406     }
407 
408     function getTokenInfoData() public view returns(ERC20[], uint[], uint[]) {
409         return(tokenInfoTokenList, tokenInfoPerBlockImbalance, tokenInfoMaxTotalImbalance);
410     }
411 
412     function getTokenInfoTokenList() public view returns(ERC20[] tokens) {
413         return(tokenInfoTokenList);
414     }
415 
416     function getTokenInfoMaxPerBlockImbalanceList() public view returns(uint[] maxPerBlockImbalanceValues) {
417         return (tokenInfoPerBlockImbalance);
418     }
419 
420     function getTokenInfoMaxTotalImbalanceList() public view returns(uint[] maxTotalImbalanceValues) {
421         return(tokenInfoMaxTotalImbalance);
422     }
423 
424     function getTokenInfoDataTracking() public view returns (address[] signatures, uint nonce) {
425         (signatures, nonce) = getDataTrackingParameters(tokenInfoDataIndex);
426         return(signatures, nonce);
427     }
428 }
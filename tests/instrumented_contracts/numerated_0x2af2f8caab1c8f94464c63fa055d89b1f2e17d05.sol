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
17 // File: contracts/PermissionGroups.sol
18 
19 contract PermissionGroups {
20 
21     address public admin;
22     address public pendingAdmin;
23     mapping(address=>bool) internal operators;
24     mapping(address=>bool) internal alerters;
25     address[] internal operatorsGroup;
26     address[] internal alertersGroup;
27     uint constant internal MAX_GROUP_SIZE = 50;
28 
29     function PermissionGroups() public {
30         admin = msg.sender;
31     }
32 
33     modifier onlyAdmin() {
34         require(msg.sender == admin);
35         _;
36     }
37 
38     modifier onlyOperator() {
39         require(operators[msg.sender]);
40         _;
41     }
42 
43     modifier onlyAlerter() {
44         require(alerters[msg.sender]);
45         _;
46     }
47 
48     function getOperators () external view returns(address[]) {
49         return operatorsGroup;
50     }
51 
52     function getAlerters () external view returns(address[]) {
53         return alertersGroup;
54     }
55 
56     event TransferAdminPending(address pendingAdmin);
57 
58     /**
59      * @dev Allows the current admin to set the pendingAdmin address.
60      * @param newAdmin The address to transfer ownership to.
61      */
62     function transferAdmin(address newAdmin) public onlyAdmin {
63         require(newAdmin != address(0));
64         TransferAdminPending(pendingAdmin);
65         pendingAdmin = newAdmin;
66     }
67 
68     /**
69      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
70      * @param newAdmin The address to transfer ownership to.
71      */
72     function transferAdminQuickly(address newAdmin) public onlyAdmin {
73         require(newAdmin != address(0));
74         TransferAdminPending(newAdmin);
75         AdminClaimed(newAdmin, admin);
76         admin = newAdmin;
77     }
78 
79     event AdminClaimed( address newAdmin, address previousAdmin);
80 
81     /**
82      * @dev Allows the pendingAdmin address to finalize the change admin process.
83      */
84     function claimAdmin() public {
85         require(pendingAdmin == msg.sender);
86         AdminClaimed(pendingAdmin, admin);
87         admin = pendingAdmin;
88         pendingAdmin = address(0);
89     }
90 
91     event AlerterAdded (address newAlerter, bool isAdd);
92 
93     function addAlerter(address newAlerter) public onlyAdmin {
94         require(!alerters[newAlerter]); // prevent duplicates.
95         require(alertersGroup.length < MAX_GROUP_SIZE);
96 
97         AlerterAdded(newAlerter, true);
98         alerters[newAlerter] = true;
99         alertersGroup.push(newAlerter);
100     }
101 
102     function removeAlerter (address alerter) public onlyAdmin {
103         require(alerters[alerter]);
104         alerters[alerter] = false;
105 
106         for (uint i = 0; i < alertersGroup.length; ++i) {
107             if (alertersGroup[i] == alerter) {
108                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
109                 alertersGroup.length--;
110                 AlerterAdded(alerter, false);
111                 break;
112             }
113         }
114     }
115 
116     event OperatorAdded(address newOperator, bool isAdd);
117 
118     function addOperator(address newOperator) public onlyAdmin {
119         require(!operators[newOperator]); // prevent duplicates.
120         require(operatorsGroup.length < MAX_GROUP_SIZE);
121 
122         OperatorAdded(newOperator, true);
123         operators[newOperator] = true;
124         operatorsGroup.push(newOperator);
125     }
126 
127     function removeOperator (address operator) public onlyAdmin {
128         require(operators[operator]);
129         operators[operator] = false;
130 
131         for (uint i = 0; i < operatorsGroup.length; ++i) {
132             if (operatorsGroup[i] == operator) {
133                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
134                 operatorsGroup.length -= 1;
135                 OperatorAdded(operator, false);
136                 break;
137             }
138         }
139     }
140 }
141 
142 // File: contracts/Withdrawable.sol
143 
144 /**
145  * @title Contracts that should be able to recover tokens or ethers
146  * @author Ilan Doron
147  * @dev This allows to recover any tokens or Ethers received in a contract.
148  * This will prevent any accidental loss of tokens.
149  */
150 contract Withdrawable is PermissionGroups {
151 
152     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
153 
154     /**
155      * @dev Withdraw all ERC20 compatible tokens
156      * @param token ERC20 The address of the token contract
157      */
158     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
159         require(token.transfer(sendTo, amount));
160         TokenWithdraw(token, amount, sendTo);
161     }
162 
163     event EtherWithdraw(uint amount, address sendTo);
164 
165     /**
166      * @dev Withdraw Ethers
167      */
168     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
169         sendTo.transfer(amount);
170         EtherWithdraw(amount, sendTo);
171     }
172 }
173 
174 // File: contracts/wrapperContracts/WrapperBase.sol
175 
176 contract WrapperBase is Withdrawable {
177 
178     PermissionGroups wrappedContract;
179 
180     function WrapperBase(PermissionGroups _wrappedContract, address _admin) public {
181         require(_wrappedContract != address(0));
182         require(_admin != address(0));
183         wrappedContract = _wrappedContract;
184         admin = _admin;
185     }
186 
187     function claimWrappedContractAdmin() public onlyAdmin {
188         wrappedContract.claimAdmin();
189     }
190 
191     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
192         wrappedContract.removeOperator(this);
193         wrappedContract.transferAdmin(newAdmin);
194     }
195 
196     function addSignature(address[] storage existingSignatures) internal returns(bool allSigned) {
197         for(uint i = 0; i < existingSignatures.length; i++) {
198             if (msg.sender == existingSignatures[i]) revert();
199         }
200         existingSignatures.push(msg.sender);
201 
202         if (existingSignatures.length == operatorsGroup.length) {
203             allSigned = true;
204             existingSignatures.length = 0;
205         } else {
206             allSigned = false;
207         }
208     }
209 }
210 
211 // File: contracts/wrapperContracts/WrapConversionRate.sol
212 
213 contract ConversionRateWrapperInterface {
214     function setQtyStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
215     function setImbalanceStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
216     function claimAdmin() public;
217     function addOperator(address newOperator) public;
218     function transferAdmin(address newAdmin) public;
219     function addToken(ERC20 token) public;
220     function setTokenControlInfo(
221             ERC20 token,
222             uint minimalRecordResolution,
223             uint maxPerBlockImbalance,
224             uint maxTotalImbalance
225         ) public;
226     function enableTokenTrade(ERC20 token) public;
227     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint);
228 }
229 
230 contract WrapConversionRate is WrapperBase {
231 
232     ConversionRateWrapperInterface conversionRates;
233 
234     //add token parameters
235     ERC20 addTokenToken;
236     uint addTokenMinimalResolution; // can be roughly 1 cent
237     uint addTokenMaxPerBlockImbalance; // in twei resolution
238     uint addTokenMaxTotalImbalance;
239     address[] addTokenApproveSignatures;
240     address[] addTokenResetSignatures;
241 
242     //set token control info parameters.
243     ERC20[] tokenInfoTokenList;
244     uint[]  tokenInfoPerBlockImbalance; // in twei resolution
245     uint[]  tokenInfoMaxTotalImbalance;
246     bool public tokenInfoParametersReady;
247     address[] tokenInfoApproveSignatures;
248     address[] tokenInfoResetSignatures;
249 
250     //general functions
251     function WrapConversionRate(ConversionRateWrapperInterface _conversionRates, address _admin) public
252         WrapperBase(PermissionGroups(address(_conversionRates)), _admin)
253     {
254         require (_conversionRates != address(0));
255         conversionRates = _conversionRates;
256         tokenInfoParametersReady = false;
257     }
258 
259     function getWrappedContract() public view returns (ConversionRateWrapperInterface _conversionRates) {
260         _conversionRates = conversionRates;
261     }
262 
263     // add token functions
264     //////////////////////
265     function setAddTokenData(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) public onlyOperator {
266         require(minimalRecordResolution != 0);
267         require(maxPerBlockImbalance != 0);
268         require(maxTotalImbalance != 0);
269         require(token != address(0));
270         //can update only when data is reset
271         require(addTokenToken == address(0));
272 
273         //reset approve array. we have new parameters
274         addTokenApproveSignatures.length = 0;
275         addTokenToken = token;
276         addTokenMinimalResolution = minimalRecordResolution; // can be roughly 1 cent
277         addTokenMaxPerBlockImbalance = maxPerBlockImbalance; // in twei resolution
278         addTokenMaxTotalImbalance = maxTotalImbalance;
279     }
280 
281     function signToApproveAddTokenData() public onlyOperator {
282         require(addTokenToken != address(0));
283 
284         if(addSignature(addTokenApproveSignatures)) {
285             // can perform operation.
286             performAddToken();
287             resetAddTokenData();
288         }
289     }
290 
291     function signToResetAddTokenData() public onlyOperator() {
292         require(addTokenToken != address(0));
293         if(addSignature(addTokenResetSignatures)) {
294             // can reset data
295             resetAddTokenData();
296             addTokenApproveSignatures.length = 0;
297         }
298     }
299 
300     function performAddToken() internal {
301         conversionRates.addToken(addTokenToken);
302 
303         //token control info
304         conversionRates.setTokenControlInfo(
305             addTokenToken,
306             addTokenMinimalResolution,
307             addTokenMaxPerBlockImbalance,
308             addTokenMaxTotalImbalance
309         );
310 
311         //step functions
312         int[] memory zeroArr = new int[](1);
313         zeroArr[0] = 0;
314 
315         conversionRates.setQtyStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
316         conversionRates.setImbalanceStepFunction(addTokenToken, zeroArr, zeroArr, zeroArr, zeroArr);
317 
318         conversionRates.enableTokenTrade(addTokenToken);
319     }
320 
321     function resetAddTokenData() internal {
322         addTokenToken = ERC20(address(0));
323         addTokenMinimalResolution = 0;
324         addTokenMaxPerBlockImbalance = 0;
325         addTokenMaxTotalImbalance = 0;
326     }
327 
328     function getAddTokenParameters() public view returns(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) {
329         token = addTokenToken;
330         minimalRecordResolution = addTokenMinimalResolution;
331         maxPerBlockImbalance = addTokenMaxPerBlockImbalance; // in twei resolution
332         maxTotalImbalance = addTokenMaxTotalImbalance;
333     }
334 
335     function getAddTokenApproveSignatures() public view returns (address[] signatures) {
336         signatures = addTokenApproveSignatures;
337     }
338 
339     function getAddTokenResetSignatures() public view returns (address[] signatures) {
340         signatures = addTokenResetSignatures;
341     }
342     
343     //set token control info
344     ////////////////////////
345     function setTokenInfoTokenList(ERC20 [] tokens) public onlyOperator {
346         require(tokenInfoParametersReady == false);
347         tokenInfoTokenList = tokens;
348     }
349 
350     function setTokenInfoMaxPerBlockImbalanceList(uint[] maxPerBlockImbalanceValues) public onlyOperator {
351         require(tokenInfoParametersReady == false);
352         require(maxPerBlockImbalanceValues.length == tokenInfoTokenList.length);
353         tokenInfoPerBlockImbalance = maxPerBlockImbalanceValues;
354     }
355 
356     function setTokenInfoMaxTotalImbalanceList(uint[] maxTotalImbalanceValues) public onlyOperator {
357         require(tokenInfoParametersReady == false);
358         require(maxTotalImbalanceValues.length == tokenInfoTokenList.length);
359         tokenInfoMaxTotalImbalance = maxTotalImbalanceValues;
360     }
361 
362     function setTokenInfoParametersReady() {
363         require(tokenInfoParametersReady == false);
364         tokenInfoParametersReady = true;
365     }
366 
367     function signToApproveTokenControlInfo() public onlyOperator {
368         require(tokenInfoParametersReady == true);
369         if (addSignature(tokenInfoApproveSignatures)) {
370             // can perform operation.
371             performSetTokenControlInfo();
372             tokenInfoParametersReady = false;
373         }
374     }
375 
376     function signToResetTokenControlInfo() public onlyOperator {
377         require(tokenInfoParametersReady == true);
378         if (addSignature(tokenInfoResetSignatures)) {
379             // can perform operation.
380             tokenInfoParametersReady = false;
381         }
382     }
383 
384     function performSetTokenControlInfo() internal {
385         require(tokenInfoTokenList.length == tokenInfoPerBlockImbalance.length);
386         require(tokenInfoTokenList.length == tokenInfoMaxTotalImbalance.length);
387 
388         uint minimalRecordResolution;
389         uint rxMaxPerBlockImbalance;
390         uint rxMaxTotalImbalance;
391 
392         for (uint i = 0; i < tokenInfoTokenList.length; i++) {
393             (minimalRecordResolution, rxMaxPerBlockImbalance, rxMaxTotalImbalance) =
394                 conversionRates.getTokenControlInfo(tokenInfoTokenList[i]);
395             require(minimalRecordResolution != 0);
396 
397             conversionRates.setTokenControlInfo(tokenInfoTokenList[i],
398                                                 minimalRecordResolution,
399                                                 tokenInfoPerBlockImbalance[i],
400                                                 tokenInfoMaxTotalImbalance[i]);
401         }
402     }
403 
404     function getControlInfoPerToken (uint index) public view returns(ERC20 token, uint _maxPerBlockImbalance, uint _maxTotalImbalance) {
405         require (tokenInfoTokenList.length > index);
406         require (tokenInfoPerBlockImbalance.length > index);
407         require (tokenInfoMaxTotalImbalance.length > index);
408 
409         return(tokenInfoTokenList[index], tokenInfoPerBlockImbalance[index], tokenInfoMaxTotalImbalance[index]);
410     }
411 
412     function getControlInfoTokenlist() public view returns(ERC20[] tokens) {
413         tokens = tokenInfoTokenList;
414     }
415 
416     function getControlInfoMaxPerBlockImbalanceList() public view returns(uint[] maxPerBlockImbalanceValues) {
417         maxPerBlockImbalanceValues = tokenInfoPerBlockImbalance;
418     }
419 
420     function getControlInfoMaxTotalImbalanceList() public view returns(uint[] maxTotalImbalanceValues) {
421         maxTotalImbalanceValues = tokenInfoMaxTotalImbalance;
422     }
423 }
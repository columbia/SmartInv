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
174 // File: contracts/wrapperContracts/WrapConversionRate.sol
175 
176 contract ConversionRateWrapperInterface {
177     function setQtyStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
178     function setImbalanceStepFunction(ERC20 token, int[] xBuy, int[] yBuy, int[] xSell, int[] ySell) public;
179     function claimAdmin() public;
180     function addOperator(address newOperator) public;
181     function transferAdmin(address newAdmin) public;
182     function addToken(ERC20 token) public;
183     function setTokenControlInfo(
184             ERC20 token,
185             uint minimalRecordResolution,
186             uint maxPerBlockImbalance,
187             uint maxTotalImbalance
188         ) public;
189     function enableTokenTrade(ERC20 token) public;
190     function getTokenControlInfo(ERC20 token) public view returns(uint, uint, uint);
191 }
192 
193 contract WrapConversionRate is Withdrawable {
194 
195     ConversionRateWrapperInterface conversionRates;
196 
197     //add token parameters
198     ERC20 public addTokenPendingToken;
199     uint addTokenPendingMinimalResolution; // can be roughly 1 cent
200     uint addTokenPendingMaxPerBlockImbalance; // in twei resolution
201     uint addTokenPendingMaxTotalImbalance;
202     address[] public addTokenApproveSignatures;
203     
204     //set token control info parameters.
205     ERC20[] public setTokenInfoPendingTokenList;
206     uint[]  public setTokenInfoPendingPerBlockImbalance; // in twei resolution
207     uint[]  public setTokenInfoPendingMaxTotalImbalance;
208     address[] public setTokenInfoApproveSignatures;
209 
210     function WrapConversionRate(ConversionRateWrapperInterface _conversionRates, address _admin) public {
211         require (_conversionRates != address(0));
212         require (_admin != address(0));
213         conversionRates = _conversionRates;
214         admin = _admin;
215     }
216 
217     function claimWrappedContractAdmin() public onlyAdmin {
218         conversionRates.claimAdmin();
219         conversionRates.addOperator(this);
220     }
221 
222     function transferWrappedContractAdmin (address newAdmin) public onlyAdmin {
223         conversionRates.transferAdmin(newAdmin);
224     }
225 
226     // add token functions
227     //////////////////////
228     function addTokenToApprove(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) public onlyOperator {
229         require(minimalRecordResolution != 0);
230         require(maxPerBlockImbalance != 0);
231         require(maxTotalImbalance != 0);
232         require(token != address(0));
233 
234         //reset approve array. we have new parameters
235         addTokenApproveSignatures.length = 0;
236         addTokenPendingToken = token;
237         addTokenPendingMinimalResolution = minimalRecordResolution; // can be roughly 1 cent
238         addTokenPendingMaxPerBlockImbalance = maxPerBlockImbalance; // in twei resolution
239         addTokenPendingMaxTotalImbalance = maxTotalImbalance;
240         // Here don't assume this add as signature as well. if its a single operator. Rather he call approve function
241     }
242 
243     function approveAddToken() public onlyOperator {
244         for(uint i = 0; i < addTokenApproveSignatures.length; i++) {
245             if (msg.sender == addTokenApproveSignatures[i]) require(false);
246         }
247         addTokenApproveSignatures.push(msg.sender);
248 
249         if (addTokenApproveSignatures.length == operatorsGroup.length) {
250             // can perform operation.
251             performAddToken();
252         }
253 //        addTokenApproveSignatures.length == 0;
254     }
255 
256     function performAddToken() internal {
257         conversionRates.addToken(addTokenPendingToken);
258 
259         //token control info
260         conversionRates.setTokenControlInfo(
261             addTokenPendingToken,
262             addTokenPendingMinimalResolution,
263             addTokenPendingMaxPerBlockImbalance,
264             addTokenPendingMaxTotalImbalance
265         );
266 
267         //step functions
268         int[] memory zeroArr = new int[](1);
269         zeroArr[0] = 0;
270 
271         conversionRates.setQtyStepFunction(addTokenPendingToken, zeroArr, zeroArr, zeroArr, zeroArr);
272         conversionRates.setImbalanceStepFunction(addTokenPendingToken, zeroArr, zeroArr, zeroArr, zeroArr);
273 
274         conversionRates.enableTokenTrade(addTokenPendingToken);
275     }
276 
277     function getAddTokenParameters() public view returns(ERC20 token, uint minimalRecordResolution, uint maxPerBlockImbalance, uint maxTotalImbalance) {
278         token = addTokenPendingToken;
279         minimalRecordResolution = addTokenPendingMinimalResolution;
280         maxPerBlockImbalance = addTokenPendingMaxPerBlockImbalance; // in twei resolution
281         maxTotalImbalance = addTokenPendingMaxTotalImbalance;
282     }
283     
284     //set token control info
285     ////////////////////////
286     function tokenInfoSetPendingTokens(ERC20 [] tokens) public onlyOperator {
287         setTokenInfoApproveSignatures.length = 0;
288         setTokenInfoPendingTokenList = tokens;
289     }
290 
291     function tokenInfoSetMaxPerBlockImbalanceList(uint[] maxPerBlockImbalanceValues) public onlyOperator {
292         require(maxPerBlockImbalanceValues.length == setTokenInfoPendingTokenList.length);
293         setTokenInfoApproveSignatures.length = 0;
294         setTokenInfoPendingPerBlockImbalance = maxPerBlockImbalanceValues;
295     }
296 
297     function tokenInfoSetMaxTotalImbalanceList(uint[] maxTotalImbalanceValues) public onlyOperator {
298         require(maxTotalImbalanceValues.length == setTokenInfoPendingTokenList.length);
299         setTokenInfoApproveSignatures.length = 0;
300         setTokenInfoPendingMaxTotalImbalance = maxTotalImbalanceValues;
301     }
302 
303     function approveSetTokenControlInfo() public onlyOperator {
304         for(uint i = 0; i < setTokenInfoApproveSignatures.length; i++) {
305             if (msg.sender == setTokenInfoApproveSignatures[i]) require(false);
306         }
307         setTokenInfoApproveSignatures.push(msg.sender);
308 
309         if (setTokenInfoApproveSignatures.length == operatorsGroup.length) {
310             // can perform operation.
311             performSetTokenControlInfo();
312         }
313     }
314 
315     function performSetTokenControlInfo() internal {
316         require(setTokenInfoPendingTokenList.length == setTokenInfoPendingPerBlockImbalance.length);
317         require(setTokenInfoPendingTokenList.length == setTokenInfoPendingMaxTotalImbalance.length);
318 
319         uint minimalRecordResolution;
320         uint rxMaxPerBlockImbalance;
321         uint rxMaxTotalImbalance;
322 
323         for (uint i = 0; i < setTokenInfoPendingTokenList.length; i++) {
324             (minimalRecordResolution, rxMaxPerBlockImbalance, rxMaxTotalImbalance) =
325                 conversionRates.getTokenControlInfo(setTokenInfoPendingTokenList[i]);
326             require(minimalRecordResolution != 0);
327 
328             conversionRates.setTokenControlInfo(setTokenInfoPendingTokenList[i],
329                                                 minimalRecordResolution,
330                                                 setTokenInfoPendingPerBlockImbalance[i],
331                                                 setTokenInfoPendingMaxTotalImbalance[i]);
332         }
333     }
334 
335     function getControlInfoTokenlist() public view returns(ERC20[] tokens) {
336         tokens = setTokenInfoPendingTokenList;
337     }
338 
339     function getControlInfoMaxPerBlockImbalanceList() public view returns(uint[] maxPerBlockImbalanceValues) {
340         maxPerBlockImbalanceValues = setTokenInfoPendingPerBlockImbalance;
341     }
342 
343     function getControlInfoMaxTotalImbalanceList() public view returns(uint[] maxTotalImbalanceValues) {
344         maxTotalImbalanceValues = setTokenInfoPendingMaxTotalImbalance;
345     }
346 }
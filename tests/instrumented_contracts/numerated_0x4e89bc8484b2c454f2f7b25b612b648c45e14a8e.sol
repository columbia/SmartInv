1 pragma solidity 0.4.18;
2 
3 interface FeeBurnerInterface {
4     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
5 }
6 
7 contract PermissionGroups {
8 
9     address public admin;
10     address public pendingAdmin;
11     mapping(address=>bool) internal operators;
12     mapping(address=>bool) internal alerters;
13     address[] internal operatorsGroup;
14     address[] internal alertersGroup;
15     uint constant internal MAX_GROUP_SIZE = 50;
16 
17     function PermissionGroups() public {
18         admin = msg.sender;
19     }
20 
21     modifier onlyAdmin() {
22         require(msg.sender == admin);
23         _;
24     }
25 
26     modifier onlyOperator() {
27         require(operators[msg.sender]);
28         _;
29     }
30 
31     modifier onlyAlerter() {
32         require(alerters[msg.sender]);
33         _;
34     }
35 
36     function getOperators () external view returns(address[]) {
37         return operatorsGroup;
38     }
39 
40     function getAlerters () external view returns(address[]) {
41         return alertersGroup;
42     }
43 
44     event TransferAdminPending(address pendingAdmin);
45 
46     /**
47      * @dev Allows the current admin to set the pendingAdmin address.
48      * @param newAdmin The address to transfer ownership to.
49      */
50     function transferAdmin(address newAdmin) public onlyAdmin {
51         require(newAdmin != address(0));
52         TransferAdminPending(pendingAdmin);
53         pendingAdmin = newAdmin;
54     }
55 
56     /**
57      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
58      * @param newAdmin The address to transfer ownership to.
59      */
60     function transferAdminQuickly(address newAdmin) public onlyAdmin {
61         require(newAdmin != address(0));
62         TransferAdminPending(newAdmin);
63         AdminClaimed(newAdmin, admin);
64         admin = newAdmin;
65     }
66 
67     event AdminClaimed( address newAdmin, address previousAdmin);
68 
69     /**
70      * @dev Allows the pendingAdmin address to finalize the change admin process.
71      */
72     function claimAdmin() public {
73         require(pendingAdmin == msg.sender);
74         AdminClaimed(pendingAdmin, admin);
75         admin = pendingAdmin;
76         pendingAdmin = address(0);
77     }
78 
79     event AlerterAdded (address newAlerter, bool isAdd);
80 
81     function addAlerter(address newAlerter) public onlyAdmin {
82         require(!alerters[newAlerter]); // prevent duplicates.
83         require(alertersGroup.length < MAX_GROUP_SIZE);
84 
85         AlerterAdded(newAlerter, true);
86         alerters[newAlerter] = true;
87         alertersGroup.push(newAlerter);
88     }
89 
90     function removeAlerter (address alerter) public onlyAdmin {
91         require(alerters[alerter]);
92         alerters[alerter] = false;
93 
94         for (uint i = 0; i < alertersGroup.length; ++i) {
95             if (alertersGroup[i] == alerter) {
96                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
97                 alertersGroup.length--;
98                 AlerterAdded(alerter, false);
99                 break;
100             }
101         }
102     }
103 
104     event OperatorAdded(address newOperator, bool isAdd);
105 
106     function addOperator(address newOperator) public onlyAdmin {
107         require(!operators[newOperator]); // prevent duplicates.
108         require(operatorsGroup.length < MAX_GROUP_SIZE);
109 
110         OperatorAdded(newOperator, true);
111         operators[newOperator] = true;
112         operatorsGroup.push(newOperator);
113     }
114 
115     function removeOperator (address operator) public onlyAdmin {
116         require(operators[operator]);
117         operators[operator] = false;
118 
119         for (uint i = 0; i < operatorsGroup.length; ++i) {
120             if (operatorsGroup[i] == operator) {
121                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
122                 operatorsGroup.length -= 1;
123                 OperatorAdded(operator, false);
124                 break;
125             }
126         }
127     }
128 }
129 
130 contract Utils {
131 
132     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
133     uint  constant internal PRECISION = (10**18);
134     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
135     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
136     uint  constant internal MAX_DECIMALS = 18;
137     uint  constant internal ETH_DECIMALS = 18;
138     mapping(address=>uint) internal decimals;
139 
140     function setDecimals(ERC20 token) internal {
141         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
142         else decimals[token] = token.decimals();
143     }
144 
145     function getDecimals(ERC20 token) internal view returns(uint) {
146         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
147         uint tokenDecimals = decimals[token];
148         // technically, there might be token with decimals 0
149         // moreover, very possible that old tokens have decimals 0
150         // these tokens will just have higher gas fees.
151         if(tokenDecimals == 0) return token.decimals();
152 
153         return tokenDecimals;
154     }
155 
156     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
157         require(srcQty <= MAX_QTY);
158         require(rate <= MAX_RATE);
159 
160         if (dstDecimals >= srcDecimals) {
161             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
162             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
163         } else {
164             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
165             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
166         }
167     }
168 
169     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
170         require(dstQty <= MAX_QTY);
171         require(rate <= MAX_RATE);
172 
173         //source quantity is rounded up. to avoid dest quantity being too low.
174         uint numerator;
175         uint denominator;
176         if (srcDecimals >= dstDecimals) {
177             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
178             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
179             denominator = rate;
180         } else {
181             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
182             numerator = (PRECISION * dstQty);
183             denominator = (rate * (10**(dstDecimals - srcDecimals)));
184         }
185         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
186     }
187 }
188 
189 contract Withdrawable is PermissionGroups {
190 
191     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
192 
193     /**
194      * @dev Withdraw all ERC20 compatible tokens
195      * @param token ERC20 The address of the token contract
196      */
197     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
198         require(token.transfer(sendTo, amount));
199         TokenWithdraw(token, amount, sendTo);
200     }
201 
202     event EtherWithdraw(uint amount, address sendTo);
203 
204     /**
205      * @dev Withdraw Ethers
206      */
207     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
208         sendTo.transfer(amount);
209         EtherWithdraw(amount, sendTo);
210     }
211 }
212 
213 interface BurnableToken {
214     function transferFrom(address _from, address _to, uint _value) public returns (bool);
215     function burnFrom(address _from, uint256 _value) public returns (bool);
216 }
217 
218 contract FeeBurner is Withdrawable, FeeBurnerInterface, Utils {
219 
220     mapping(address=>uint) public reserveFeesInBps;
221     mapping(address=>address) public reserveKNCWallet;
222     mapping(address=>uint) public walletFeesInBps;
223     mapping(address=>uint) public reserveFeeToBurn;
224     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
225 
226     BurnableToken public knc;
227     address public kyberNetwork;
228     uint public kncPerETHRate = 300;
229 
230     function FeeBurner(address _admin, BurnableToken kncToken) public {
231         require(_admin != address(0));
232         require(kncToken != address(0));
233         admin = _admin;
234         knc = kncToken;
235     }
236 
237     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
238         require(feesInBps < 100); // make sure it is always < 1%
239         require(kncWallet != address(0));
240         reserveFeesInBps[reserve] = feesInBps;
241         reserveKNCWallet[reserve] = kncWallet;
242     }
243 
244     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
245         require(feesInBps < 10000); // under 100%
246         walletFeesInBps[wallet] = feesInBps;
247     }
248 
249     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
250         require(_kyberNetwork != address(0));
251         kyberNetwork = _kyberNetwork;
252     }
253 
254     function setKNCRate(uint rate) public onlyAdmin {
255         require(kncPerETHRate <= MAX_RATE);
256         kncPerETHRate = rate;
257     }
258 
259     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
260     event AssignBurnFees(address reserve, uint burnFee);
261 
262     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
263         require(msg.sender == kyberNetwork);
264         require(tradeWeiAmount <= MAX_QTY);
265         require(kncPerETHRate <= MAX_RATE);
266 
267         uint kncAmount = tradeWeiAmount * kncPerETHRate;
268         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
269 
270         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
271         require(fee >= walletFee);
272         uint feeToBurn = fee - walletFee;
273 
274         if (walletFee > 0) {
275             reserveFeeToWallet[reserve][wallet] += walletFee;
276             AssignFeeToWallet(reserve, wallet, walletFee);
277         }
278 
279         if (feeToBurn > 0) {
280             AssignBurnFees(reserve, feeToBurn);
281             reserveFeeToBurn[reserve] += feeToBurn;
282         }
283 
284         return true;
285     }
286 
287     // this function is callable by anyone
288     event BurnAssignedFees(address indexed reserve, address sender);
289 
290     function burnReserveFees(address reserve) public {
291         uint burnAmount = reserveFeeToBurn[reserve];
292         require(burnAmount > 1);
293         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
294         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
295 
296         BurnAssignedFees(reserve, msg.sender);
297     }
298 
299     event SendWalletFees(address indexed wallet, address reserve, address sender);
300 
301     // this function is callable by anyone
302     function sendFeeToWallet(address wallet, address reserve) public {
303         uint feeAmount = reserveFeeToWallet[reserve][wallet];
304         require(feeAmount > 1);
305         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
306         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
307 
308         SendWalletFees(wallet, reserve, msg.sender);
309     }
310 }
311 
312 interface ERC20 {
313     function totalSupply() public view returns (uint supply);
314     function balanceOf(address _owner) public view returns (uint balance);
315     function transfer(address _to, uint _value) public returns (bool success);
316     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
317     function approve(address _spender, uint _value) public returns (bool success);
318     function allowance(address _owner, address _spender) public view returns (uint remaining);
319     function decimals() public view returns(uint digits);
320     event Approval(address indexed _owner, address indexed _spender, uint _value);
321 }
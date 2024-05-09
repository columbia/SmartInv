1 pragma solidity 0.4.18;
2 
3 interface ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf(address _owner) public view returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public view returns (uint remaining);
10     function decimals() public view returns(uint digits);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract PermissionGroups {
15 
16     address public admin;
17     address public pendingAdmin;
18     mapping(address=>bool) internal operators;
19     mapping(address=>bool) internal alerters;
20     address[] internal operatorsGroup;
21     address[] internal alertersGroup;
22     uint constant internal MAX_GROUP_SIZE = 50;
23 
24     function PermissionGroups() public {
25         admin = msg.sender;
26     }
27 
28     modifier onlyAdmin() {
29         require(msg.sender == admin);
30         _;
31     }
32 
33     modifier onlyOperator() {
34         require(operators[msg.sender]);
35         _;
36     }
37 
38     modifier onlyAlerter() {
39         require(alerters[msg.sender]);
40         _;
41     }
42 
43     function getOperators () external view returns(address[]) {
44         return operatorsGroup;
45     }
46 
47     function getAlerters () external view returns(address[]) {
48         return alertersGroup;
49     }
50 
51     event TransferAdminPending(address pendingAdmin);
52 
53     /**
54      * @dev Allows the current admin to set the pendingAdmin address.
55      * @param newAdmin The address to transfer ownership to.
56      */
57     function transferAdmin(address newAdmin) public onlyAdmin {
58         require(newAdmin != address(0));
59         TransferAdminPending(pendingAdmin);
60         pendingAdmin = newAdmin;
61     }
62 
63     /**
64      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
65      * @param newAdmin The address to transfer ownership to.
66      */
67     function transferAdminQuickly(address newAdmin) public onlyAdmin {
68         require(newAdmin != address(0));
69         TransferAdminPending(newAdmin);
70         AdminClaimed(newAdmin, admin);
71         admin = newAdmin;
72     }
73 
74     event AdminClaimed( address newAdmin, address previousAdmin);
75 
76     /**
77      * @dev Allows the pendingAdmin address to finalize the change admin process.
78      */
79     function claimAdmin() public {
80         require(pendingAdmin == msg.sender);
81         AdminClaimed(pendingAdmin, admin);
82         admin = pendingAdmin;
83         pendingAdmin = address(0);
84     }
85 
86     event AlerterAdded (address newAlerter, bool isAdd);
87 
88     function addAlerter(address newAlerter) public onlyAdmin {
89         require(!alerters[newAlerter]); // prevent duplicates.
90         require(alertersGroup.length < MAX_GROUP_SIZE);
91 
92         AlerterAdded(newAlerter, true);
93         alerters[newAlerter] = true;
94         alertersGroup.push(newAlerter);
95     }
96 
97     function removeAlerter (address alerter) public onlyAdmin {
98         require(alerters[alerter]);
99         alerters[alerter] = false;
100 
101         for (uint i = 0; i < alertersGroup.length; ++i) {
102             if (alertersGroup[i] == alerter) {
103                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
104                 alertersGroup.length--;
105                 AlerterAdded(alerter, false);
106                 break;
107             }
108         }
109     }
110 
111     event OperatorAdded(address newOperator, bool isAdd);
112 
113     function addOperator(address newOperator) public onlyAdmin {
114         require(!operators[newOperator]); // prevent duplicates.
115         require(operatorsGroup.length < MAX_GROUP_SIZE);
116 
117         OperatorAdded(newOperator, true);
118         operators[newOperator] = true;
119         operatorsGroup.push(newOperator);
120     }
121 
122     function removeOperator (address operator) public onlyAdmin {
123         require(operators[operator]);
124         operators[operator] = false;
125 
126         for (uint i = 0; i < operatorsGroup.length; ++i) {
127             if (operatorsGroup[i] == operator) {
128                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
129                 operatorsGroup.length -= 1;
130                 OperatorAdded(operator, false);
131                 break;
132             }
133         }
134     }
135 }
136 
137 contract Utils {
138 
139     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
140     uint  constant internal PRECISION = (10**18);
141     uint  constant internal MAX_QTY   = (10**28); // 10B tokens
142     uint  constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
143     uint  constant internal MAX_DECIMALS = 18;
144     uint  constant internal ETH_DECIMALS = 18;
145     mapping(address=>uint) internal decimals;
146 
147     function setDecimals(ERC20 token) internal {
148         if (token == ETH_TOKEN_ADDRESS) decimals[token] = ETH_DECIMALS;
149         else decimals[token] = token.decimals();
150     }
151 
152     function getDecimals(ERC20 token) internal view returns(uint) {
153         if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
154         uint tokenDecimals = decimals[token];
155         // technically, there might be token with decimals 0
156         // moreover, very possible that old tokens have decimals 0
157         // these tokens will just have higher gas fees.
158         if(tokenDecimals == 0) return token.decimals();
159 
160         return tokenDecimals;
161     }
162 
163     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
164         require(srcQty <= MAX_QTY);
165         require(rate <= MAX_RATE);
166 
167         if (dstDecimals >= srcDecimals) {
168             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
169             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
170         } else {
171             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
172             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
173         }
174     }
175 
176     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns(uint) {
177         require(dstQty <= MAX_QTY);
178         require(rate <= MAX_RATE);
179 
180         //source quantity is rounded up. to avoid dest quantity being too low.
181         uint numerator;
182         uint denominator;
183         if (srcDecimals >= dstDecimals) {
184             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
185             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
186             denominator = rate;
187         } else {
188             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
189             numerator = (PRECISION * dstQty);
190             denominator = (rate * (10**(dstDecimals - srcDecimals)));
191         }
192         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
193     }
194 }
195 
196 contract Withdrawable is PermissionGroups {
197 
198     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
199 
200     /**
201      * @dev Withdraw all ERC20 compatible tokens
202      * @param token ERC20 The address of the token contract
203      */
204     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
205         require(token.transfer(sendTo, amount));
206         TokenWithdraw(token, amount, sendTo);
207     }
208 
209     event EtherWithdraw(uint amount, address sendTo);
210 
211     /**
212      * @dev Withdraw Ethers
213      */
214     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
215         sendTo.transfer(amount);
216         EtherWithdraw(amount, sendTo);
217     }
218 }
219 
220 interface SanityRatesInterface {
221     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint);
222 }
223 
224 contract SanityRates is SanityRatesInterface, Withdrawable, Utils {
225     mapping(address=>uint) public tokenRate;
226     mapping(address=>uint) public reasonableDiffInBps;
227 
228     function SanityRates(address _admin) public {
229         require(_admin != address(0));
230         admin = _admin;
231     }
232 
233     function setReasonableDiff(ERC20[] srcs, uint[] diff) public onlyAdmin {
234         require(srcs.length == diff.length);
235         for (uint i = 0; i < srcs.length; i++) {
236             require(diff[i] <= 100 * 100);
237             reasonableDiffInBps[srcs[i]] = diff[i];
238         }
239     }
240 
241     function setSanityRates(ERC20[] srcs, uint[] rates) public onlyOperator {
242         require(srcs.length == rates.length);
243 
244         for (uint i = 0; i < srcs.length; i++) {
245             require(rates[i] <= MAX_RATE);
246             tokenRate[srcs[i]] = rates[i];
247         }
248     }
249 
250     function getSanityRate(ERC20 src, ERC20 dest) public view returns(uint) {
251         if (src != ETH_TOKEN_ADDRESS && dest != ETH_TOKEN_ADDRESS) return 0;
252 
253         uint rate;
254         address token;
255         if (src == ETH_TOKEN_ADDRESS) {
256             rate = (PRECISION*PRECISION)/tokenRate[dest];
257             token = dest;
258         } else {
259             rate = tokenRate[src];
260             token = src;
261         }
262 
263         return rate * (10000 + reasonableDiffInBps[token])/10000;
264     }
265 }
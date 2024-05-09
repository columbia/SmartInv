1 pragma solidity 0.4.18;
2 
3 contract PermissionGroups {
4 
5     address public admin;
6     address public pendingAdmin;
7     mapping(address=>bool) internal operators;
8     mapping(address=>bool) internal alerters;
9     address[] internal operatorsGroup;
10     address[] internal alertersGroup;
11     uint constant internal MAX_GROUP_SIZE = 50;
12 
13     function PermissionGroups() public {
14         admin = msg.sender;
15     }
16 
17     modifier onlyAdmin() {
18         require(msg.sender == admin);
19         _;
20     }
21 
22     modifier onlyOperator() {
23         require(operators[msg.sender]);
24         _;
25     }
26 
27     modifier onlyAlerter() {
28         require(alerters[msg.sender]);
29         _;
30     }
31 
32     function getOperators () external view returns(address[]) {
33         return operatorsGroup;
34     }
35 
36     function getAlerters () external view returns(address[]) {
37         return alertersGroup;
38     }
39 
40     event TransferAdminPending(address pendingAdmin);
41 
42     /**
43      * @dev Allows the current admin to set the pendingAdmin address.
44      * @param newAdmin The address to transfer ownership to.
45      */
46     function transferAdmin(address newAdmin) public onlyAdmin {
47         require(newAdmin != address(0));
48         TransferAdminPending(pendingAdmin);
49         pendingAdmin = newAdmin;
50     }
51 
52     /**
53      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
54      * @param newAdmin The address to transfer ownership to.
55      */
56     function transferAdminQuickly(address newAdmin) public onlyAdmin {
57         require(newAdmin != address(0));
58         TransferAdminPending(newAdmin);
59         AdminClaimed(newAdmin, admin);
60         admin = newAdmin;
61     }
62 
63     event AdminClaimed( address newAdmin, address previousAdmin);
64 
65     /**
66      * @dev Allows the pendingAdmin address to finalize the change admin process.
67      */
68     function claimAdmin() public {
69         require(pendingAdmin == msg.sender);
70         AdminClaimed(pendingAdmin, admin);
71         admin = pendingAdmin;
72         pendingAdmin = address(0);
73     }
74 
75     event AlerterAdded (address newAlerter, bool isAdd);
76 
77     function addAlerter(address newAlerter) public onlyAdmin {
78         require(!alerters[newAlerter]); // prevent duplicates.
79         require(alertersGroup.length < MAX_GROUP_SIZE);
80 
81         AlerterAdded(newAlerter, true);
82         alerters[newAlerter] = true;
83         alertersGroup.push(newAlerter);
84     }
85 
86     function removeAlerter (address alerter) public onlyAdmin {
87         require(alerters[alerter]);
88         alerters[alerter] = false;
89 
90         for (uint i = 0; i < alertersGroup.length; ++i) {
91             if (alertersGroup[i] == alerter) {
92                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
93                 alertersGroup.length--;
94                 AlerterAdded(alerter, false);
95                 break;
96             }
97         }
98     }
99 
100     event OperatorAdded(address newOperator, bool isAdd);
101 
102     function addOperator(address newOperator) public onlyAdmin {
103         require(!operators[newOperator]); // prevent duplicates.
104         require(operatorsGroup.length < MAX_GROUP_SIZE);
105 
106         OperatorAdded(newOperator, true);
107         operators[newOperator] = true;
108         operatorsGroup.push(newOperator);
109     }
110 
111     function removeOperator (address operator) public onlyAdmin {
112         require(operators[operator]);
113         operators[operator] = false;
114 
115         for (uint i = 0; i < operatorsGroup.length; ++i) {
116             if (operatorsGroup[i] == operator) {
117                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
118                 operatorsGroup.length -= 1;
119                 OperatorAdded(operator, false);
120                 break;
121             }
122         }
123     }
124 }
125 
126 interface BurnableToken {
127     function transferFrom(address _from, address _to, uint _value) public returns (bool);
128     function burnFrom(address _from, uint256 _value) public returns (bool);
129 }
130 
131 contract Withdrawable is PermissionGroups {
132 
133     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
134 
135     /**
136      * @dev Withdraw all ERC20 compatible tokens
137      * @param token ERC20 The address of the token contract
138      */
139     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
140         require(token.transfer(sendTo, amount));
141         TokenWithdraw(token, amount, sendTo);
142     }
143 
144     event EtherWithdraw(uint amount, address sendTo);
145 
146     /**
147      * @dev Withdraw Ethers
148      */
149     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
150         sendTo.transfer(amount);
151         EtherWithdraw(amount, sendTo);
152     }
153 }
154 
155 interface ERC20 {
156     function totalSupply() public view returns (uint supply);
157     function balanceOf(address _owner) public view returns (uint balance);
158     function transfer(address _to, uint _value) public returns (bool success);
159     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
160     function approve(address _spender, uint _value) public returns (bool success);
161     function allowance(address _owner, address _spender) public view returns (uint remaining);
162     function decimals() public view returns(uint digits);
163     event Approval(address indexed _owner, address indexed _spender, uint _value);
164 }
165 
166 interface FeeBurnerInterface {
167     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
168 }
169 
170 contract FeeBurner is Withdrawable, FeeBurnerInterface {
171 
172     mapping(address=>uint) public reserveFeesInBps;
173     mapping(address=>address) public reserveKNCWallet;
174     mapping(address=>uint) public walletFeesInBps;
175     mapping(address=>uint) public reserveFeeToBurn;
176     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
177 
178     BurnableToken public knc;
179     address public kyberNetwork;
180     uint public kncPerETHRate = 300;
181 
182     function FeeBurner(address _admin, BurnableToken kncToken) public {
183         require(_admin != address(0));
184         require(kncToken != address(0));
185         admin = _admin;
186         knc = kncToken;
187     }
188 
189     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
190         require(feesInBps < 100); // make sure it is always < 1%
191         require(kncWallet != address(0));
192         reserveFeesInBps[reserve] = feesInBps;
193         reserveKNCWallet[reserve] = kncWallet;
194     }
195 
196     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
197         require(feesInBps < 10000); // under 100%
198         walletFeesInBps[wallet] = feesInBps;
199     }
200 
201     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
202         require(_kyberNetwork != address(0));
203         kyberNetwork = _kyberNetwork;
204     }
205 
206     function setKNCRate(uint rate) public onlyAdmin {
207         kncPerETHRate = rate;
208     }
209 
210     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
211     event AssignBurnFees(address reserve, uint burnFee);
212 
213     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
214         require(msg.sender == kyberNetwork);
215 
216         uint kncAmount = tradeWeiAmount * kncPerETHRate;
217         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
218 
219         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
220         require(fee >= walletFee);
221         uint feeToBurn = fee - walletFee;
222 
223         if (walletFee > 0) {
224             reserveFeeToWallet[reserve][wallet] += walletFee;
225             AssignFeeToWallet(reserve, wallet, walletFee);
226         }
227 
228         if (feeToBurn > 0) {
229             AssignBurnFees(reserve, feeToBurn);
230             reserveFeeToBurn[reserve] += feeToBurn;
231         }
232 
233         return true;
234     }
235 
236     // this function is callable by anyone
237     event BurnAssignedFees(address indexed reserve, address sender);
238 
239     function burnReserveFees(address reserve) public {
240         uint burnAmount = reserveFeeToBurn[reserve];
241         require(burnAmount > 1);
242         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
243         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
244 
245         BurnAssignedFees(reserve, msg.sender);
246     }
247 
248     event SendWalletFees(address indexed wallet, address reserve, address sender);
249 
250     // this function is callable by anyone
251     function sendFeeToWallet(address wallet, address reserve) public {
252         uint feeAmount = reserveFeeToWallet[reserve][wallet];
253         require(feeAmount > 1);
254         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
255         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
256 
257         SendWalletFees(wallet, reserve, msg.sender);
258     }
259 }
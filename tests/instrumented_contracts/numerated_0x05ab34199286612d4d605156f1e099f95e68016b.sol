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
22 
23     function PermissionGroups() public {
24         admin = msg.sender;
25     }
26 
27     modifier onlyAdmin() {
28         require(msg.sender == admin);
29         _;
30     }
31 
32     modifier onlyOperator() {
33         require(operators[msg.sender]);
34         _;
35     }
36 
37     modifier onlyAlerter() {
38         require(alerters[msg.sender]);
39         _;
40     }
41 
42     function getOperators () external view returns(address[]) {
43         return operatorsGroup;
44     }
45 
46     function getAlerters () external view returns(address[]) {
47         return alertersGroup;
48     }
49 
50     event TransferAdminPending(address pendingAdmin);
51 
52     /**
53      * @dev Allows the current admin to set the pendingAdmin address.
54      * @param newAdmin The address to transfer ownership to.
55      */
56     function transferAdmin(address newAdmin) public onlyAdmin {
57         require(newAdmin != address(0));
58         TransferAdminPending(pendingAdmin);
59         pendingAdmin = newAdmin;
60     }
61 
62     event AdminClaimed( address newAdmin, address previousAdmin);
63 
64     /**
65      * @dev Allows the pendingAdmin address to finalize the change admin process.
66      */
67     function claimAdmin() public {
68         require(pendingAdmin == msg.sender);
69         AdminClaimed(pendingAdmin, admin);
70         admin = pendingAdmin;
71         pendingAdmin = address(0);
72     }
73 
74     event AlerterAdded (address newAlerter, bool isAdd);
75 
76     function addAlerter(address newAlerter) public onlyAdmin {
77         require(!alerters[newAlerter]); // prevent duplicates.
78         AlerterAdded(newAlerter, true);
79         alerters[newAlerter] = true;
80         alertersGroup.push(newAlerter);
81     }
82 
83     function removeAlerter (address alerter) public onlyAdmin {
84         require(alerters[alerter]);
85         alerters[alerter] = false;
86 
87         for (uint i = 0; i < alertersGroup.length; ++i) {
88             if (alertersGroup[i] == alerter) {
89                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
90                 alertersGroup.length--;
91                 AlerterAdded(alerter, false);
92                 break;
93             }
94         }
95     }
96 
97     event OperatorAdded(address newOperator, bool isAdd);
98 
99     function addOperator(address newOperator) public onlyAdmin {
100         require(!operators[newOperator]); // prevent duplicates.
101         OperatorAdded(newOperator, true);
102         operators[newOperator] = true;
103         operatorsGroup.push(newOperator);
104     }
105 
106     function removeOperator (address operator) public onlyAdmin {
107         require(operators[operator]);
108         operators[operator] = false;
109 
110         for (uint i = 0; i < operatorsGroup.length; ++i) {
111             if (operatorsGroup[i] == operator) {
112                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
113                 operatorsGroup.length -= 1;
114                 OperatorAdded(operator, false);
115                 break;
116             }
117         }
118     }
119 }
120 
121 interface BurnableToken {
122     function transferFrom(address _from, address _to, uint _value) public returns (bool);
123     function burnFrom(address _from, uint256 _value) public returns (bool);
124 }
125 
126 contract Withdrawable is PermissionGroups {
127 
128     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
129 
130     /**
131      * @dev Withdraw all ERC20 compatible tokens
132      * @param token ERC20 The address of the token contract
133      */
134     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
135         require(token.transfer(sendTo, amount));
136         TokenWithdraw(token, amount, sendTo);
137     }
138 
139     event EtherWithdraw(uint amount, address sendTo);
140 
141     /**
142      * @dev Withdraw Ethers
143      */
144     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
145         sendTo.transfer(amount);
146         EtherWithdraw(amount, sendTo);
147     }
148 }
149 
150 interface FeeBurnerInterface {
151     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
152 }
153 
154 contract FeeBurner is Withdrawable, FeeBurnerInterface {
155 
156     mapping(address=>uint) public reserveFeesInBps;
157     mapping(address=>address) public reserveKNCWallet;
158     mapping(address=>uint) public walletFeesInBps;
159     mapping(address=>uint) public reserveFeeToBurn;
160     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
161 
162     BurnableToken public knc;
163     address public kyberNetwork;
164     uint public kncPerETHRate = 300;
165 
166     function FeeBurner(address _admin, BurnableToken kncToken) public {
167         require(_admin != address(0));
168         require(kncToken != address(0));
169         admin = _admin;
170         knc = kncToken;
171     }
172 
173     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
174         require(feesInBps < 100); // make sure it is always < 1%
175         require(kncWallet != address(0));
176         reserveFeesInBps[reserve] = feesInBps;
177         reserveKNCWallet[reserve] = kncWallet;
178     }
179 
180     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
181         require(feesInBps < 10000); // under 100%
182         walletFeesInBps[wallet] = feesInBps;
183     }
184 
185     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
186         require(_kyberNetwork != address(0));
187         kyberNetwork = _kyberNetwork;
188     }
189 
190     function setKNCRate(uint rate) public onlyAdmin {
191         kncPerETHRate = rate;
192     }
193 
194     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
195     event AssignBurnFees(address reserve, uint burnFee);
196 
197     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
198         require(msg.sender == kyberNetwork);
199 
200         uint kncAmount = tradeWeiAmount * kncPerETHRate;
201         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
202 
203         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
204         require(fee >= walletFee);
205         uint feeToBurn = fee - walletFee;
206 
207         if (walletFee > 0) {
208             reserveFeeToWallet[reserve][wallet] += walletFee;
209             AssignFeeToWallet(reserve, wallet, walletFee);
210         }
211 
212         if (feeToBurn > 0) {
213             AssignBurnFees(reserve, feeToBurn);
214             reserveFeeToBurn[reserve] += feeToBurn;
215         }
216 
217         return true;
218     }
219 
220     // this function is callable by anyone
221     event BurnAssignedFees(address indexed reserve, address sender);
222 
223     function burnReserveFees(address reserve) public {
224         uint burnAmount = reserveFeeToBurn[reserve];
225         require(burnAmount > 1);
226         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
227         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
228 
229         BurnAssignedFees(reserve, msg.sender);
230     }
231 
232     event SendWalletFees(address indexed wallet, address reserve, address sender);
233 
234     // this function is callable by anyone
235     function sendFeeToWallet(address wallet, address reserve) public {
236         uint feeAmount = reserveFeeToWallet[reserve][wallet];
237         require(feeAmount > 1);
238         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
239         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
240 
241         SendWalletFees(wallet, reserve, msg.sender);
242     }
243 }
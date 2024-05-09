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
11 
12     function PermissionGroups() public {
13         admin = msg.sender;
14     }
15 
16     modifier onlyAdmin() {
17         require(msg.sender == admin);
18         _;
19     }
20 
21     modifier onlyOperator() {
22         require(operators[msg.sender]);
23         _;
24     }
25 
26     modifier onlyAlerter() {
27         require(alerters[msg.sender]);
28         _;
29     }
30 
31     function getOperators () external view returns(address[]) {
32         return operatorsGroup;
33     }
34 
35     function getAlerters () external view returns(address[]) {
36         return alertersGroup;
37     }
38 
39     event TransferAdminPending(address pendingAdmin);
40 
41     /**
42      * @dev Allows the current admin to set the pendingAdmin address.
43      * @param newAdmin The address to transfer ownership to.
44      */
45     function transferAdmin(address newAdmin) public onlyAdmin {
46         require(newAdmin != address(0));
47         TransferAdminPending(pendingAdmin);
48         pendingAdmin = newAdmin;
49     }
50 
51     event AdminClaimed( address newAdmin, address previousAdmin);
52 
53     /**
54      * @dev Allows the pendingAdmin address to finalize the change admin process.
55      */
56     function claimAdmin() public {
57         require(pendingAdmin == msg.sender);
58         AdminClaimed(pendingAdmin, admin);
59         admin = pendingAdmin;
60         pendingAdmin = address(0);
61     }
62 
63     event AlerterAdded (address newAlerter, bool isAdd);
64 
65     function addAlerter(address newAlerter) public onlyAdmin {
66         require(!alerters[newAlerter]); // prevent duplicates.
67         AlerterAdded(newAlerter, true);
68         alerters[newAlerter] = true;
69         alertersGroup.push(newAlerter);
70     }
71 
72     function removeAlerter (address alerter) public onlyAdmin {
73         require(alerters[alerter]);
74         alerters[alerter] = false;
75 
76         for (uint i = 0; i < alertersGroup.length; ++i) {
77             if (alertersGroup[i] == alerter) {
78                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
79                 alertersGroup.length--;
80                 AlerterAdded(alerter, false);
81                 break;
82             }
83         }
84     }
85 
86     event OperatorAdded(address newOperator, bool isAdd);
87 
88     function addOperator(address newOperator) public onlyAdmin {
89         require(!operators[newOperator]); // prevent duplicates.
90         OperatorAdded(newOperator, true);
91         operators[newOperator] = true;
92         operatorsGroup.push(newOperator);
93     }
94 
95     function removeOperator (address operator) public onlyAdmin {
96         require(operators[operator]);
97         operators[operator] = false;
98 
99         for (uint i = 0; i < operatorsGroup.length; ++i) {
100             if (operatorsGroup[i] == operator) {
101                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
102                 operatorsGroup.length -= 1;
103                 OperatorAdded(operator, false);
104                 break;
105             }
106         }
107     }
108 }
109 
110 contract Withdrawable is PermissionGroups {
111 
112     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
113 
114     /**
115      * @dev Withdraw all ERC20 compatible tokens
116      * @param token ERC20 The address of the token contract
117      */
118     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
119         require(token.transfer(sendTo, amount));
120         TokenWithdraw(token, amount, sendTo);
121     }
122 
123     event EtherWithdraw(uint amount, address sendTo);
124 
125     /**
126      * @dev Withdraw Ethers
127      */
128     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
129         sendTo.transfer(amount);
130         EtherWithdraw(amount, sendTo);
131     }
132 }
133 
134 interface ERC20 {
135     function totalSupply() public view returns (uint supply);
136     function balanceOf(address _owner) public view returns (uint balance);
137     function transfer(address _to, uint _value) public returns (bool success);
138     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
139     function approve(address _spender, uint _value) public returns (bool success);
140     function allowance(address _owner, address _spender) public view returns (uint remaining);
141     function decimals() public view returns(uint digits);
142     event Approval(address indexed _owner, address indexed _spender, uint _value);
143 }
144 
145 interface FeeBurnerInterface {
146     function handleFees (uint tradeWeiAmount, address reserve, address wallet) public returns(bool);
147 }
148 
149 contract FeeBurner is Withdrawable, FeeBurnerInterface {
150 
151     mapping(address=>uint) public reserveFeesInBps;
152     mapping(address=>address) public reserveKNCWallet;
153     mapping(address=>uint) public walletFeesInBps;
154     mapping(address=>uint) public reserveFeeToBurn;
155     mapping(address=>mapping(address=>uint)) public reserveFeeToWallet;
156 
157     BurnableToken public knc;
158     address public kyberNetwork;
159     uint public kncPerETHRate = 300;
160 
161     function FeeBurner(address _admin, BurnableToken kncToken) public {
162         require(_admin != address(0));
163         require(kncToken != address(0));
164         admin = _admin;
165         knc = kncToken;
166     }
167 
168     function setReserveData(address reserve, uint feesInBps, address kncWallet) public onlyAdmin {
169         require(feesInBps < 100); // make sure it is always < 1%
170         require(kncWallet != address(0));
171         reserveFeesInBps[reserve] = feesInBps;
172         reserveKNCWallet[reserve] = kncWallet;
173     }
174 
175     function setWalletFees(address wallet, uint feesInBps) public onlyAdmin {
176         require(feesInBps < 10000); // under 100%
177         walletFeesInBps[wallet] = feesInBps;
178     }
179 
180     function setKyberNetwork(address _kyberNetwork) public onlyAdmin {
181         require(_kyberNetwork != address(0));
182         kyberNetwork = _kyberNetwork;
183     }
184 
185     function setKNCRate(uint rate) public onlyAdmin {
186         kncPerETHRate = rate;
187     }
188 
189     event AssignFeeToWallet(address reserve, address wallet, uint walletFee);
190     event AssignBurnFees(address reserve, uint burnFee);
191 
192     function handleFees(uint tradeWeiAmount, address reserve, address wallet) public returns(bool) {
193         require(msg.sender == kyberNetwork);
194 
195         uint kncAmount = tradeWeiAmount * kncPerETHRate;
196         uint fee = kncAmount * reserveFeesInBps[reserve] / 10000;
197 
198         uint walletFee = fee * walletFeesInBps[wallet] / 10000;
199         require(fee >= walletFee);
200         uint feeToBurn = fee - walletFee;
201 
202         if (walletFee > 0) {
203             reserveFeeToWallet[reserve][wallet] += walletFee;
204             AssignFeeToWallet(reserve, wallet, walletFee);
205         }
206 
207         if (feeToBurn > 0) {
208             AssignBurnFees(reserve, feeToBurn);
209             reserveFeeToBurn[reserve] += feeToBurn;
210         }
211 
212         return true;
213     }
214 
215     // this function is callable by anyone
216     event BurnAssignedFees(address indexed reserve, address sender);
217 
218     function burnReserveFees(address reserve) public {
219         uint burnAmount = reserveFeeToBurn[reserve];
220         require(burnAmount > 1);
221         reserveFeeToBurn[reserve] = 1; // leave 1 twei to avoid spikes in gas fee
222         require(knc.burnFrom(reserveKNCWallet[reserve], burnAmount - 1));
223 
224         BurnAssignedFees(reserve, msg.sender);
225     }
226 
227     event SendWalletFees(address indexed wallet, address reserve, address sender);
228 
229     // this function is callable by anyone
230     function sendFeeToWallet(address wallet, address reserve) public {
231         uint feeAmount = reserveFeeToWallet[reserve][wallet];
232         require(feeAmount > 1);
233         reserveFeeToWallet[reserve][wallet] = 1; // leave 1 twei to avoid spikes in gas fee
234         require(knc.transferFrom(reserveKNCWallet[reserve], wallet, feeAmount - 1));
235 
236         SendWalletFees(wallet, reserve, msg.sender);
237     }
238 }
239 
240 interface BurnableToken {
241     function transferFrom(address _from, address _to, uint _value) public returns (bool);
242     function burnFrom(address _from, uint256 _value) public returns (bool);
243 }
1 // File: contracts/sol4/ERC20Interface.sol
2 
3 pragma solidity 0.4.18;
4 
5 
6 // https://github.com/ethereum/EIPs/issues/20
7 interface ERC20 {
8     function totalSupply() public view returns (uint supply);
9     function balanceOf(address _owner) public view returns (uint balance);
10     function transfer(address _to, uint _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
12     function approve(address _spender, uint _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint remaining);
14     function decimals() public view returns(uint digits);
15     event Approval(address indexed _owner, address indexed _spender, uint _value);
16 }
17 
18 // File: contracts/sol4/PermissionGroups.sol
19 
20 pragma solidity 0.4.18;
21 
22 
23 contract PermissionGroups {
24 
25     address public admin;
26     address public pendingAdmin;
27     mapping(address=>bool) internal operators;
28     mapping(address=>bool) internal alerters;
29     address[] internal operatorsGroup;
30     address[] internal alertersGroup;
31     uint constant internal MAX_GROUP_SIZE = 50;
32 
33     function PermissionGroups() public {
34         admin = msg.sender;
35     }
36 
37     modifier onlyAdmin() {
38         require(msg.sender == admin);
39         _;
40     }
41 
42     modifier onlyOperator() {
43         require(operators[msg.sender]);
44         _;
45     }
46 
47     modifier onlyAlerter() {
48         require(alerters[msg.sender]);
49         _;
50     }
51 
52     function getOperators () external view returns(address[]) {
53         return operatorsGroup;
54     }
55 
56     function getAlerters () external view returns(address[]) {
57         return alertersGroup;
58     }
59 
60     event TransferAdminPending(address pendingAdmin);
61 
62     /**
63      * @dev Allows the current admin to set the pendingAdmin address.
64      * @param newAdmin The address to transfer ownership to.
65      */
66     function transferAdmin(address newAdmin) public onlyAdmin {
67         require(newAdmin != address(0));
68         TransferAdminPending(pendingAdmin);
69         pendingAdmin = newAdmin;
70     }
71 
72     /**
73      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
74      * @param newAdmin The address to transfer ownership to.
75      */
76     function transferAdminQuickly(address newAdmin) public onlyAdmin {
77         require(newAdmin != address(0));
78         TransferAdminPending(newAdmin);
79         AdminClaimed(newAdmin, admin);
80         admin = newAdmin;
81     }
82 
83     event AdminClaimed( address newAdmin, address previousAdmin);
84 
85     /**
86      * @dev Allows the pendingAdmin address to finalize the change admin process.
87      */
88     function claimAdmin() public {
89         require(pendingAdmin == msg.sender);
90         AdminClaimed(pendingAdmin, admin);
91         admin = pendingAdmin;
92         pendingAdmin = address(0);
93     }
94 
95     event AlerterAdded (address newAlerter, bool isAdd);
96 
97     function addAlerter(address newAlerter) public onlyAdmin {
98         require(!alerters[newAlerter]); // prevent duplicates.
99         require(alertersGroup.length < MAX_GROUP_SIZE);
100 
101         AlerterAdded(newAlerter, true);
102         alerters[newAlerter] = true;
103         alertersGroup.push(newAlerter);
104     }
105 
106     function removeAlerter (address alerter) public onlyAdmin {
107         require(alerters[alerter]);
108         alerters[alerter] = false;
109 
110         for (uint i = 0; i < alertersGroup.length; ++i) {
111             if (alertersGroup[i] == alerter) {
112                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
113                 alertersGroup.length--;
114                 AlerterAdded(alerter, false);
115                 break;
116             }
117         }
118     }
119 
120     event OperatorAdded(address newOperator, bool isAdd);
121 
122     function addOperator(address newOperator) public onlyAdmin {
123         require(!operators[newOperator]); // prevent duplicates.
124         require(operatorsGroup.length < MAX_GROUP_SIZE);
125 
126         OperatorAdded(newOperator, true);
127         operators[newOperator] = true;
128         operatorsGroup.push(newOperator);
129     }
130 
131     function removeOperator (address operator) public onlyAdmin {
132         require(operators[operator]);
133         operators[operator] = false;
134 
135         for (uint i = 0; i < operatorsGroup.length; ++i) {
136             if (operatorsGroup[i] == operator) {
137                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
138                 operatorsGroup.length -= 1;
139                 OperatorAdded(operator, false);
140                 break;
141             }
142         }
143     }
144 }
145 
146 // File: contracts/sol4/Withdrawable.sol
147 
148 pragma solidity 0.4.18;
149 
150 
151 
152 
153 /**
154  * @title Contracts that should be able to recover tokens or ethers
155  * @author Ilan Doron
156  * @dev This allows to recover any tokens or Ethers received in a contract.
157  * This will prevent any accidental loss of tokens.
158  */
159 contract Withdrawable is PermissionGroups {
160 
161     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
162 
163     /**
164      * @dev Withdraw all ERC20 compatible tokens
165      * @param token ERC20 The address of the token contract
166      */
167     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
168         require(token.transfer(sendTo, amount));
169         TokenWithdraw(token, amount, sendTo);
170     }
171 
172     event EtherWithdraw(uint amount, address sendTo);
173 
174     /**
175      * @dev Withdraw Ethers
176      */
177     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
178         sendTo.transfer(amount);
179         EtherWithdraw(amount, sendTo);
180     }
181 }
182 
183 // File: contracts/sol4/wrappers/SetStepFunctionWrapper.sol
184 
185 pragma solidity ^0.4.18;
186 
187 
188 
189 
190 interface SetStepFunctionInterface {
191     function setImbalanceStepFunction(
192         ERC20 token,
193         int[] xBuy,
194         int[] yBuy,
195         int[] xSell,
196         int[] ySell
197     ) public;
198 }
199 
200 contract SetStepFunctionWrapper is Withdrawable {
201     SetStepFunctionInterface public rateContract;
202     function SetStepFunctionWrapper(address admin, address operator) public {
203         require(admin != address(0));
204         require(operator != (address(0)));
205 
206         addOperator(operator);
207         transferAdminQuickly(admin);
208     }
209 
210     function setConversionRateAddress(SetStepFunctionInterface _contract) public onlyOperator {
211         rateContract = _contract;
212     }
213 
214     function setImbalanceStepFunction(
215         ERC20 token,
216         int[] xBuy,
217         int[] yBuy,
218         int[] xSell,
219         int[] ySell)
220         public onlyOperator
221     {
222         uint i;
223 
224         // check all x for buy are positive
225         for( i = 0 ; i < xBuy.length ; i++ ) {
226             require(xBuy[i] >= 0 );
227         }
228 
229         // check all y for buy are negative
230         for( i = 0 ; i < yBuy.length ; i++ ) {
231             require(yBuy[i] <= 0 );
232         }
233 
234         // check all x for sell are negative
235         for( i = 0 ; i < xSell.length ; i++ ) {
236             require(xSell[i] <= 0 );
237         }
238 
239         // check all y for sell are negative
240         for( i = 0 ; i < ySell.length ; i++ ) {
241             require(ySell[i] <= 0 );
242         }
243 
244         rateContract.setImbalanceStepFunction(token,xBuy,yBuy,xSell,ySell);
245     }
246 }
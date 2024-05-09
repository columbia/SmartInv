1 pragma solidity ^0.4.18;
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
126 // https://github.com/ethereum/EIPs/issues/20
127 interface ERC20 {
128     function totalSupply() public view returns (uint supply);
129     function balanceOf(address _owner) public view returns (uint balance);
130     function transfer(address _to, uint _value) public returns (bool success);
131     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
132     function approve(address _spender, uint _value) public returns (bool success);
133     function allowance(address _owner, address _spender) public view returns (uint remaining);
134     function decimals() public view returns(uint digits);
135     event Approval(address indexed _owner, address indexed _spender, uint _value);
136 }
137 
138 
139 /**
140  * @title Contracts that should be able to recover tokens or ethers
141  * @author Ilan Doron
142  * @dev This allows to recover any tokens or Ethers received in a contract.
143  * This will prevent any accidental loss of tokens.
144  */
145 contract Withdrawable is PermissionGroups {
146 
147     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
148 
149     /**
150      * @dev Withdraw all ERC20 compatible tokens
151      * @param token ERC20 The address of the token contract
152      */
153     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
154         require(token.transfer(sendTo, amount));
155         TokenWithdraw(token, amount, sendTo);
156     }
157 
158     event EtherWithdraw(uint amount, address sendTo);
159 
160     /**
161      * @dev Withdraw Ethers
162      */
163     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
164         sendTo.transfer(amount);
165         EtherWithdraw(amount, sendTo);
166     }
167 }
168 
169 
170 interface SetStepFunctionInterface {
171   function setImbalanceStepFunction(
172       ERC20 token,
173       int[] xBuy,
174       int[] yBuy,
175       int[] xSell,
176       int[] ySell
177   ) public;
178 }
179 
180 contract SetStepFunctionWrapper is Withdrawable {
181     SetStepFunctionInterface public rateContract;
182     function SetStepFunctionWrapper(address admin, address operator) public {
183         addOperator(operator);
184         transferAdminQuickly(admin);
185     }
186 
187     function setConversionRateAddress(SetStepFunctionInterface _contract) public onlyOperator {
188         rateContract = _contract;
189     }
190 
191     function setImbalanceStepFunction(ERC20 token,
192                                       int[] xBuy,
193                                       int[] yBuy,
194                                       int[] xSell,
195                                       int[] ySell) public onlyOperator {
196         uint i;
197 
198         // check all x for buy are positive and y are positive as well
199         for( i = 0 ; i < xBuy.length ; i++ ) {
200           require(xBuy[i] >= 0 );
201           require(yBuy[i] <= 0 );
202         }
203 
204         // check all x for sell are negative and y are positive
205         for( i = 0 ; i < xSell.length ; i++ ) {
206           require(xSell[i] <= 0 );
207           require(ySell[i] <= 0 );
208         }
209 
210         rateContract.setImbalanceStepFunction(token,xBuy,yBuy,xSell,ySell);
211     }
212 }
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
174 // File: contracts/wrapperContracts/FeeBurnerWrapperProxy.sol
175 
176 interface WrapFeeBurner {
177     function registerWalletForFeeSharing(address walletAddress) public;
178 }
179 
180 
181 contract FeeBurnerWrapperProxy is Withdrawable {
182 
183     WrapFeeBurner public feeBurnerWrapperContract;
184 
185     function FeeBurnerWrapperProxy(WrapFeeBurner burnerWrapperAddress) public {
186         require(burnerWrapperAddress != address(0));
187         feeBurnerWrapperContract = burnerWrapperAddress;
188     }
189 
190     function registerWallet(address wallet) public {
191         feeBurnerWrapperContract.registerWalletForFeeSharing(wallet);
192     }
193 
194     function setFeeBurnerWrapper(WrapFeeBurner burnerWrapperAddress) public onlyAdmin {
195         require(burnerWrapperAddress != address(0));
196         feeBurnerWrapperContract = burnerWrapperAddress;
197     }
198 }
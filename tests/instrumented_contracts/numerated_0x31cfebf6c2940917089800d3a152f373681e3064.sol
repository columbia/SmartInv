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
134 contract WhiteListInterface {
135     function getUserCapInWei(address user) external view returns (uint userCapWei);
136 }
137 
138 contract WhiteList is WhiteListInterface, Withdrawable {
139 
140     uint public weiPerSgd; // amount of weis in 1 singapore dollar
141     mapping (address=>uint) public userCategory; // each user has a category defining cap on trade. 0 for standard.
142     mapping (uint=>uint)    public categoryCap;  // will define cap on trade amount per category in singapore Dollar.
143 
144     function WhiteList(address _admin) public {
145         require(_admin != address(0));
146         admin = _admin;
147     }
148 
149     function getUserCapInWei(address user) external view returns (uint userCapWei) {
150         uint category = userCategory[user];
151         return (categoryCap[category] * weiPerSgd);
152     }
153 
154     event UserCategorySet(address user, uint category);
155 
156     function setUserCategory(address user, uint category) public onlyOperator {
157         userCategory[user] = category;
158         UserCategorySet(user, category);
159     }
160 
161     event CategoryCapSet (uint category, uint sgdCap);
162 
163     function setCategoryCap(uint category, uint sgdCap) public onlyOperator {
164         categoryCap[category] = sgdCap;
165         CategoryCapSet(category, sgdCap);
166     }
167 
168     event SgdToWeiRateSet (uint rate);
169 
170     function setSgdToEthRate(uint _sgdToWeiRate) public onlyOperator {
171         weiPerSgd = _sgdToWeiRate;
172         SgdToWeiRateSet(_sgdToWeiRate);
173     }
174 }
175 
176 interface ERC20 {
177     function totalSupply() public view returns (uint supply);
178     function balanceOf(address _owner) public view returns (uint balance);
179     function transfer(address _to, uint _value) public returns (bool success);
180     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
181     function approve(address _spender, uint _value) public returns (bool success);
182     function allowance(address _owner, address _spender) public view returns (uint remaining);
183     function decimals() public view returns(uint digits);
184     event Approval(address indexed _owner, address indexed _spender, uint _value);
185 }
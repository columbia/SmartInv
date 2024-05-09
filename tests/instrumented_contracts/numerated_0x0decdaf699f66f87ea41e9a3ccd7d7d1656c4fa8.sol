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
150 interface ERC20 {
151     function totalSupply() public view returns (uint supply);
152     function balanceOf(address _owner) public view returns (uint balance);
153     function transfer(address _to, uint _value) public returns (bool success);
154     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
155     function approve(address _spender, uint _value) public returns (bool success);
156     function allowance(address _owner, address _spender) public view returns (uint remaining);
157     function decimals() public view returns(uint digits);
158     event Approval(address indexed _owner, address indexed _spender, uint _value);
159 }
160 
161 contract WhiteListInterface {
162     function getUserCapInWei(address user) external view returns (uint userCapWei);
163 }
164 
165 contract WhiteList is WhiteListInterface, Withdrawable {
166 
167     uint public weiPerSgd; // amount of weis in 1 singapore dollar
168     mapping (address=>uint) public userCategory; // each user has a category defining cap on trade. 0 for standard.
169     mapping (uint=>uint)    public categoryCap;  // will define cap on trade amount per category in singapore Dollar.
170 
171     function WhiteList(address _admin) public {
172         require(_admin != address(0));
173         admin = _admin;
174     }
175 
176     function getUserCapInWei(address user) external view returns (uint userCapWei) {
177         uint category = userCategory[user];
178         return (categoryCap[category] * weiPerSgd);
179     }
180 
181     event UserCategorySet(address user, uint category);
182 
183     function setUserCategory(address user, uint category) public onlyOperator {
184         userCategory[user] = category;
185         UserCategorySet(user, category);
186     }
187 
188     event CategoryCapSet (uint category, uint sgdCap);
189 
190     function setCategoryCap(uint category, uint sgdCap) public onlyOperator {
191         categoryCap[category] = sgdCap;
192         CategoryCapSet(category, sgdCap);
193     }
194 
195     event SgdToWeiRateSet (uint rate);
196 
197     function setSgdToEthRate(uint _sgdToWeiRate) public onlyOperator {
198         weiPerSgd = _sgdToWeiRate;
199         SgdToWeiRateSet(_sgdToWeiRate);
200     }
201 }
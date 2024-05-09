1 pragma solidity ^0.4.18;
2 
3 contract WhiteListInterface {
4     function getUserCapInWei(address user) external view returns (uint userCapWei);
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
130 contract Withdrawable is PermissionGroups {
131 
132     event TokenWithdraw(ERC20 token, uint amount, address sendTo);
133 
134     /**
135      * @dev Withdraw all ERC20 compatible tokens
136      * @param token ERC20 The address of the token contract
137      */
138     function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
139         require(token.transfer(sendTo, amount));
140         TokenWithdraw(token, amount, sendTo);
141     }
142 
143     event EtherWithdraw(uint amount, address sendTo);
144 
145     /**
146      * @dev Withdraw Ethers
147      */
148     function withdrawEther(uint amount, address sendTo) external onlyAdmin {
149         sendTo.transfer(amount);
150         EtherWithdraw(amount, sendTo);
151     }
152 }
153 
154 contract WhiteList is WhiteListInterface, Withdrawable {
155 
156     uint public weiPerSgd; // amount of weis in 1 singapore dollar
157     mapping (address=>uint) public userCategory; // each user has a category defining cap on trade. 0 for standard.
158     mapping (uint=>uint)    public categoryCap;  // will define cap on trade amount per category in singapore Dollar.
159     uint constant public kgtHolderCategory = 2;
160     ERC20 public kgtToken;
161 
162     function WhiteList(address _admin, ERC20 _kgtToken) public {
163         require(_admin != address(0));
164         require(_kgtToken != address(0));
165         kgtToken = _kgtToken;
166         admin = _admin;
167     }
168 
169     function getUserCapInWei(address user) external view returns (uint) {
170         uint category = getUserCategory(user);
171         return (categoryCap[category] * weiPerSgd);
172     }
173 
174     event UserCategorySet(address user, uint category);
175 
176     function setUserCategory(address user, uint category) public onlyOperator {
177         userCategory[user] = category;
178         UserCategorySet(user, category);
179     }
180 
181     event CategoryCapSet (uint category, uint sgdCap);
182 
183     function setCategoryCap(uint category, uint sgdCap) public onlyOperator {
184         categoryCap[category] = sgdCap;
185         CategoryCapSet(category, sgdCap);
186     }
187 
188     event SgdToWeiRateSet (uint rate);
189 
190     function setSgdToEthRate(uint _sgdToWeiRate) public onlyOperator {
191         weiPerSgd = _sgdToWeiRate;
192         SgdToWeiRateSet(_sgdToWeiRate);
193     }
194 
195     function getUserCategory (address user) public view returns(uint) {
196         uint category = userCategory[user];
197         if (category == 0) {
198             //0 = default category. means category wasn't set.
199             if (kgtToken.balanceOf(user) > 0) {
200                 category = kgtHolderCategory;
201             }
202         }
203         return category;
204     }
205 }
206 
207 interface ERC20 {
208     function totalSupply() public view returns (uint supply);
209     function balanceOf(address _owner) public view returns (uint balance);
210     function transfer(address _to, uint _value) public returns (bool success);
211     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
212     function approve(address _spender, uint _value) public returns (bool success);
213     function allowance(address _owner, address _spender) public view returns (uint remaining);
214     function decimals() public view returns(uint digits);
215     event Approval(address indexed _owner, address indexed _spender, uint _value);
216 }
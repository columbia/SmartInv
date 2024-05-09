1 pragma solidity ^0.4.16;
2 
3 contract ShpingCoin {
4 
5     string public name = "Shping Coin"; 
6     string public symbol = "SHPING";
7     uint8 public decimals = 18;
8     uint256 public coinsaleDeadline = 1521845940; // 23/03/2018, 22:59:00 GMT | 23/03/2018, 23:59:00 CET | Saturday, 24 March 2018 9:59:00 AM GMT+11:00
9 
10     uint256 public totalSupply;
11     mapping(address => uint256) balances; 
12     mapping(address => mapping (address => uint256)) allowed; 
13 
14     mapping(address => mapping(string => bool)) platinumUsers;
15     mapping(address => mapping(string => uint256)) campaigns; // Requests for a campaign activation 
16     mapping(address => uint256) budgets; // Account budget for rewards campaigns
17 
18     address public owner;
19     address public operator;
20 
21     function ShpingCoin() public {
22         owner = msg.sender;
23         totalSupply = 10000000000 * (10 ** uint256(decimals));
24         balances[msg.sender] = totalSupply;
25         operator = msg.sender;
26     }
27 
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     modifier onlyOperator() {
34         require(msg.sender == operator);
35         _;
36     }
37 
38     function changeOperator(address newOperator) public onlyOwner {
39         require(newOperator != address(0));
40         require(newOperator != operator);
41         require(balances[newOperator]+balances[operator] >= balances[newOperator]);
42         require(budgets[newOperator]+budgets[operator] >= budgets[newOperator]);
43 
44         if (operator != owner) {
45             balances[newOperator] += balances[operator];
46             budgets[newOperator] += budgets[operator];
47             NewBudget(newOperator, budgets[newOperator]);
48             Transfer(operator, newOperator, balances[operator]);
49             balances[operator] = 0;
50             budgets[operator] = 0;
51             NewBudget(operator, 0);
52         }
53         operator = newOperator;
54     }
55 
56     //Permanent platinum level
57 
58     function isPlatinumLevel(address user, string hashedID) public constant returns (bool) {
59         return platinumUsers[user][hashedID];
60     }
61 
62     function setPermanentPlatinumLevel(address user, string hashedID) public onlyOwner returns (bool) {
63         require(!isPlatinumLevel(user, hashedID));
64         platinumUsers[user][hashedID] = true;
65         return true;
66     }
67 
68     //Rewards campaigns
69     function activateCampaign(string campaign, uint256 budget) public returns (bool) {
70         require(campaigns[msg.sender][campaign] == 0);
71         require(budget != 0);
72         require(balances[msg.sender] >= budgets[msg.sender]);
73         require(balances[msg.sender] - budgets[msg.sender] >= budget);
74         campaigns[msg.sender][campaign] = budget;
75         Activate(msg.sender, budget, campaign);
76         return true;
77     }
78 
79     function getBudget(address account) public constant returns (uint256) {
80         return budgets[account];
81     }
82 
83     function rejectCampaign(address account, string campaign) public onlyOperator returns (bool) {
84         require(account != address(0));
85         campaigns[account][campaign] = 0;
86         Reject(account, campaign);
87         return true;
88     }
89 
90     function setBudget(address account, string campaign) public onlyOperator returns (bool) {
91         require(account != address(0));
92         require(campaigns[account][campaign] != 0);
93         require(balances[account] >= budgets[account]);
94         require(balances[account] - budgets[account] >= campaigns[account][campaign]);
95         require(budgets[account] + campaigns[account][campaign] > budgets[account]);
96 
97         budgets[account] += campaigns[account][campaign];
98         campaigns[account][campaign] = 0;
99         NewBudget(account, budgets[account]);
100         return true;
101     }
102 
103     function releaseBudget(address account, uint256 budget) public onlyOperator returns (bool) {
104         require(account != address(0));
105         require(budget != 0);
106         require(budgets[account] >= budget);
107         require(balances[account] >= budget);
108         require(balances[operator] + budget > balances[operator]);
109 
110         budgets[account] -= budget;
111         balances[account] -= budget;
112         balances[operator] += budget;
113         Released(account, budget);
114         NewBudget(account, budgets[account]);
115         return true;
116     }
117 
118     function clearBudget(address account) public onlyOperator returns (bool) {
119         budgets[account] = 0;
120         NewBudget(account, 0);
121         return true;
122     }
123 
124     event Activate(address indexed account, uint256 indexed budget, string campaign);
125     event NewBudget(address indexed account, uint256 budget);
126     event Reject(address indexed account, string campaign);
127     event Released(address indexed account, uint256 value);
128 
129     //ERC20 interface
130     function balanceOf(address account) public constant returns (uint256) {
131         return balances[account];
132     }
133 
134     function transfer(address to, uint256 value) public returns (bool) {
135         require(msg.sender == owner || msg.sender == operator || now > coinsaleDeadline);
136         require(balances[msg.sender] - budgets[msg.sender] >= value);
137         require(balances[to] + value >= balances[to]);
138         
139         balances[msg.sender] -= value;
140         balances[to] += value;
141         Transfer(msg.sender, to, value);
142         return true;
143     }
144 
145     function transferFrom(address from, address to, uint256 value) public returns (bool) {
146         require(from == owner || from == operator || msg.sender == owner || msg.sender == operator || now > coinsaleDeadline);
147         require(balances[from] - budgets[from] >= value);
148         require(allowed[from][msg.sender] >= value);
149         require(balances[to] + value >= balances[to]);
150 
151         balances[from] -= value;
152         allowed[from][msg.sender] -= value;
153         balances[to] += value;
154         Transfer(from, to, value);
155         return true;
156     }
157 
158     function approve(address spender, uint256 value) public returns (bool) {
159         allowed[msg.sender][spender] = value;
160         Approval(msg.sender, spender, value);
161         return true;
162     }
163 
164     function allowance(address account, address spender) public constant returns (uint256) {
165         return allowed[account][spender];
166     }
167 
168     event Transfer(address indexed _from, address indexed _to, uint256 _value);
169     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
170 }
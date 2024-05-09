1 pragma solidity ^0.4.25;
2 
3  /*
4   * @title: SafeMath
5   * @dev: Helper contract functions to arithmatic operations safely.
6   */
7 contract SafeMath {
8     function Sub(uint256 a, uint256 b) internal pure returns (uint256) {
9         require(b <= a, "SafeMath: subtraction overflow");
10         uint256 c = a - b;
11     
12         return c;
13     }
14     function Add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20     function Mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "SafeMath: multiplication overflow");
27 
28         return c;
29     }
30 }
31 
32  /*
33   * @title: Token
34   * @dev: Interface contract for ERC20 tokens
35   */
36 contract Token {
37       function totalSupply() public view returns (uint256 supply);
38       function balanceOf(address _owner) public view returns (uint256 balance);
39       function transfer(address _to, uint256 _value) public returns (bool success);
40       function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41       function approve(address _spender, uint256 _value) public returns (bool success);
42       function allowance(address _owner, address _spender) public view returns (uint256 remaining);
43       event Transfer(address indexed _from, address indexed _to, uint256 _value);
44       event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47  /*
48   * @title: Staking
49   * @author BlockBank (https://www.blockbank.co.kr)
50   */
51 contract Staking is SafeMath
52 {
53     // _prAddress: ERC20 contract address
54     // msg.sender: owner && operator
55     constructor(address _prAddress) public
56     {
57         owner = msg.sender;
58         operator = owner;
59         prAddress = _prAddress;
60         isContractUse = true;
61     }
62 
63     address public owner;
64     // Functions with this modifier can only be executed by the owner
65     modifier onlyOwner() {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     address public operator;
71     // Functions with this modifier can only be executed by the operator
72     modifier onlyOperator() {
73         require(msg.sender == operator);
74         _;
75     }
76     function transferOperator(address _operator) onlyOwner public {
77         operator = _operator;
78     }
79     
80     bool public isContractUse;
81     // Functions with this modifier can only be executed when this contract is not abandoned
82     modifier onlyContractUse {
83         require(isContractUse == true);
84         _;
85     }
86     
87     function SetContractUse(bool _isContractUse) onlyOperator public{
88         isContractUse = _isContractUse;
89     }
90 
91     uint32 public lastAcccountId;
92     mapping (uint32 => address) id_account;
93     mapping (uint32 => bool) accountId_freeze;
94     mapping (address => uint32) account_id;
95     // Find or add account
96     function FindOrAddAccount(address findAddress) private returns (uint32)
97     {
98         if (account_id[findAddress] == 0)
99         {
100             account_id[findAddress] = ++lastAcccountId;
101             id_account[lastAcccountId] = findAddress;
102         }
103         return account_id[findAddress];
104     }
105     // Find or revert account
106     function FindOrRevertAccount() private view returns (uint32)
107     {
108         uint32 accountId = account_id[msg.sender];
109         require(accountId != 0);
110         return accountId;
111     }
112     // Get account id of msg sender
113     function GetMyAccountId() view public returns (uint32)
114     {
115         return account_id[msg.sender];
116     }
117     // Get account id of any users
118     function GetAccountId(address account) view public returns (uint32)
119     {
120         return account_id[account];
121     }
122     // Freeze or unfreez of account
123     function SetFreezeByAddress(bool isFreeze, address account) onlyOperator public
124     {
125         uint32 accountId = account_id[account];
126 
127         if (accountId != 0)
128         {
129             accountId_freeze[accountId] = isFreeze;
130         }
131     }
132     function IsFreezeByAddress(address account) public view returns (bool)
133     {
134         uint32 accountId = account_id[account];
135         
136         if (accountId != 0)
137         {
138             return accountId_freeze[accountId];
139         }
140         return false;
141     }
142 
143     // reserved: Balance held up in orderBook
144     // available: Balance available for trade
145     struct Balance
146     {
147         uint256 available;
148         uint256 maturity;
149     }
150 
151     struct ListItem
152     {
153         uint32 prev;
154         uint32 next;
155     }
156 
157     mapping (uint32 => Balance) AccountId_Balance;
158     
159     uint256 public totalBonus;
160     address public prAddress;
161     
162     uint256 public interest6weeks; //bp
163     uint256 public interest12weeks; //bp
164     
165     // set interst for each holding period: 6 / 12 weeks
166     function SetInterest(uint256 _interest6weeks, uint256 _interest12weeks) onlyOperator public
167     {
168         interest6weeks = _interest6weeks;    
169         interest12weeks = _interest12weeks;
170     }
171     
172     // deposit bonus to pay interest
173     function depositBonus(uint256 amount) onlyOwner public
174     {
175         require(Token(prAddress).transferFrom(msg.sender, this, amount));
176         
177         totalBonus = Add(totalBonus, amount);
178     }
179     
180     // withdraw bonus to owner account
181     function WithdrawBonus(uint256 amount) onlyOwner public
182     {
183         require(Token(prAddress).transfer(msg.sender, amount));
184         totalBonus = Sub(totalBonus, amount);
185     }
186 
187     // Deposit ERC20's for saving
188     function storeToken6Weeks(uint256 amount) onlyContractUse public
189     {
190         uint32 accountId = FindOrAddAccount(msg.sender);
191         require(accountId_freeze[accountId] == false);
192         require(AccountId_Balance[accountId].available == 0);
193         
194         require(Token(prAddress).transferFrom(msg.sender, this, amount));
195         
196         uint256 interst = Mul(amount, interest6weeks) / 10000;
197         
198         totalBonus = Sub(totalBonus, interst);
199         AccountId_Balance[accountId].available = Add(AccountId_Balance[accountId].available, amount + interst);
200         AccountId_Balance[accountId].maturity = now + 6 weeks;
201     }
202     // Deposit ERC20's for saving
203     function storeToken12Weeks(uint128 amount) onlyContractUse public
204     {
205         uint32 accountId = FindOrAddAccount(msg.sender);
206         require(accountId_freeze[accountId] == false);
207         require(AccountId_Balance[accountId].available == 0);
208         
209         require(Token(prAddress).transferFrom(msg.sender, this, amount));
210         
211         uint256 interst = Mul(amount, interest12weeks) / 10000;
212         
213         totalBonus = Sub(totalBonus, interst);
214         AccountId_Balance[accountId].available = Add(AccountId_Balance[accountId].available, amount + interst);
215         AccountId_Balance[accountId].maturity = now + 12 weeks;
216     }
217     // Withdraw ERC20's to personal addresstrue
218     function withdrawToken() public
219     {
220         uint32 accountId = FindOrAddAccount(msg.sender);
221         require(AccountId_Balance[accountId].maturity < now);
222         uint256 amount = AccountId_Balance[accountId].available; 
223         require(amount > 0);
224         AccountId_Balance[accountId].available = 0;
225         require(Token(prAddress).transfer(msg.sender, amount));
226     }
227 
228     // Below two emergency functions will be never used in normal situations.
229     // These function is only prepared for emergency case such as smart contract hacking Vulnerability or smart contract abolishment
230     // Withdrawn fund by these function cannot belong to any operators or owners.
231     // Withdrawn fund should be distributed to individual accounts having original ownership of withdrawn fund.
232     
233     function emergencyWithdrawalETH(uint256 amount) onlyOwner public
234     {
235         require(msg.sender.send(amount));
236     }
237     function emergencyWithdrawalToken(uint256 amount) onlyOwner public
238     {
239         Token(prAddress).transfer(msg.sender, amount);
240     }
241 
242     function getMyBalance() view public returns (uint256 available, uint256 maturity)
243     {
244         uint32 accountId = FindOrRevertAccount();
245         available = AccountId_Balance[accountId].available;
246         maturity = AccountId_Balance[accountId].maturity;
247     }
248     
249     function getTimeStamp() view public returns (uint256)
250     {
251         return now;
252     }
253 }
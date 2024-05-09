1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Doneth (Doneth)
5  * @dev Doneth is a contract that allows shared access to funds
6  * in the form of Ether and ERC20 tokens. It is especially relevant
7  * to donation based projects. The admins of the contract determine 
8  * who is a member, and each member gets a number of shares. The 
9  * number of shares each member has determines how much Ether/ERC20 
10  * the member can withdraw from the contract.
11  */
12 
13 /*
14  * Ownable
15  *
16  * Base contract with an owner.
17  * Provides onlyOwner modifier, which prevents function from running
18  * if it is called by anyone other than the owner.
19  */
20 
21 contract Ownable {
22     address public owner;
23 
24     function Ownable() {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address newOwner) onlyOwner {
34         if (newOwner != address(0)) {
35             owner = newOwner;
36         }
37     }
38 }
39 
40 contract Doneth is Ownable {
41     using SafeMath for uint256;  
42 
43     // Name of the contract
44     string public name;
45 
46     // Sum of all shares allocated to members
47     uint256 public totalShares;
48 
49     // Sum of all withdrawals done by members
50     uint256 public totalWithdrawn;
51 
52     // Block number of when the contract was created
53     uint256 public genesisBlockNumber;
54 
55     // Number of decimal places for floating point division
56     uint256 constant public PRECISION = 18;
57 
58     // Variables for shared expense allocation
59     uint256 public sharedExpense;
60     uint256 public sharedExpenseWithdrawn;
61 
62     // Used to keep track of members
63     mapping(address => Member) public members;
64     address[] public memberKeys;
65     struct Member {
66         bool exists;
67         bool admin;
68         uint256 shares;
69         uint256 withdrawn;
70         string memberName;
71         mapping(address => uint256) tokensWithdrawn;
72     }
73 
74     // Used to keep track of ERC20 tokens used and how much withdrawn
75     mapping(address => Token) public tokens;
76     address[] public tokenKeys;
77     struct Token {
78         bool exists;
79         uint256 totalWithdrawn;
80     }
81 
82     function Doneth(string _contractName, string _founderName) {
83         if (bytes(_contractName).length > 21) revert();
84         if (bytes(_founderName).length > 21) revert();
85         name = _contractName;
86         genesisBlockNumber = block.number;
87         addMember(msg.sender, 1, true, _founderName);
88     }
89 
90     event Deposit(address from, uint value);
91     event Withdraw(address from, uint value, uint256 newTotalWithdrawn);
92     event TokenWithdraw(address from, uint value, address token, uint amount);
93     event AddShare(address who, uint256 addedShares, uint256 newTotalShares);
94     event RemoveShare(address who, uint256 removedShares, uint256 newTotalShares);
95     event ChangePrivilege(address who, bool oldValue, bool newValue);
96     event ChangeContractName(string oldValue, string newValue);
97     event ChangeMemberName(address who, string oldValue, string newValue);
98     event ChangeSharedExpense(uint256 contractBalance, uint256 oldValue, uint256 newValue);
99     event WithdrawSharedExpense(address from, address to, uint value, uint256 newSharedExpenseWithdrawn);
100 
101     // Fallback function accepts Ether from donators
102     function () public payable {
103         Deposit(msg.sender, msg.value);
104     }
105 
106     modifier onlyAdmin() { 
107         if (msg.sender != owner && !members[msg.sender].admin) revert();   
108         _;
109     }
110 
111     modifier onlyExisting(address who) { 
112         if (!members[who].exists) revert(); 
113         _;
114     }
115 
116     // Series of getter functions for contract data
117     function getMemberCount() public constant returns(uint) {
118         return memberKeys.length;
119     }
120     
121     function getMemberAtKey(uint key) public constant returns(address) {
122         return memberKeys[key];
123     }
124     
125     function getBalance() public constant returns(uint256 balance) {
126         return this.balance;
127     }
128     
129     function getContractInfo() public constant returns(string, address, uint256, uint256, uint256) {
130         return (string(name), owner, genesisBlockNumber, totalShares, totalWithdrawn);
131     }
132     
133     function returnMember(address _address) public constant onlyExisting(_address) returns(bool admin, uint256 shares, uint256 withdrawn, string memberName) {
134       Member memory m = members[_address];
135       return (m.admin, m.shares, m.withdrawn, m.memberName);
136     }
137 
138     function checkERC20Balance(address token) public constant returns(uint256) {
139         uint256 balance = ERC20(token).balanceOf(address(this));
140         if (!tokens[token].exists && balance > 0) {
141             tokens[token].exists = true;
142         }
143         return balance;
144     }
145 
146     // Function to add members to the contract 
147     function addMember(address who, uint256 shares, bool admin, string memberName) public onlyAdmin() {
148         // Don't allow the same member to be added twice
149         if (members[who].exists) revert();
150         if (bytes(memberName).length > 21) revert();
151 
152         Member memory newMember;
153         newMember.exists = true;
154         newMember.admin = admin;
155         newMember.memberName = memberName;
156 
157         members[who] = newMember;
158         memberKeys.push(who);
159         addShare(who, shares);
160     }
161 
162     function updateMember(address who, uint256 shares, bool isAdmin, string name) public onlyAdmin() {
163         if (sha3(members[who].memberName) != sha3(name)) changeMemberName(who, name);
164         if (members[who].admin != isAdmin) changeAdminPrivilege(who, isAdmin);
165         if (members[who].shares != shares) allocateShares(who, shares);
166     }
167 
168     // Only owner, admin or member can change member's name
169     function changeMemberName(address who, string newName) public onlyExisting(who) {
170         if (msg.sender != who && msg.sender != owner && !members[msg.sender].admin) revert();
171         if (bytes(newName).length > 21) revert();
172         ChangeMemberName(who, members[who].memberName, newName);
173         members[who].memberName = newName;
174     }
175 
176     function changeAdminPrivilege(address who, bool newValue) public onlyAdmin() {
177         ChangePrivilege(who, members[who].admin, newValue);
178         members[who].admin = newValue; 
179     }
180 
181     // Only admins and owners can change the contract name
182     function changeContractName(string newName) public onlyAdmin() {
183         if (bytes(newName).length > 21) revert();
184         ChangeContractName(name, newName);
185         name = newName;
186     }
187 
188     // Shared expense allocation allows admins to withdraw an amount to be used for shared
189     // expenses. Shared expense allocation subtracts from the total balance of the contract. 
190     // Only owner can change this amount.
191     function changeSharedExpenseAllocation(uint256 newAllocation) public onlyOwner() {
192         if (newAllocation < sharedExpenseWithdrawn) revert();
193         if (newAllocation.sub(sharedExpenseWithdrawn) > this.balance) revert();
194 
195         ChangeSharedExpense(this.balance, sharedExpense, newAllocation);
196         sharedExpense = newAllocation;
197     }
198 
199     // Set share amount explicitly by calculating difference then adding or removing accordingly
200     function allocateShares(address who, uint256 amount) public onlyAdmin() onlyExisting(who) {
201         uint256 currentShares = members[who].shares;
202         if (amount == currentShares) revert();
203         if (amount > currentShares) {
204             addShare(who, amount.sub(currentShares));
205         } else {
206             removeShare(who, currentShares.sub(amount));
207         }
208     }
209 
210     // Increment the number of shares for a member
211     function addShare(address who, uint256 amount) public onlyAdmin() onlyExisting(who) {
212         totalShares = totalShares.add(amount);
213         members[who].shares = members[who].shares.add(amount);
214         AddShare(who, amount, members[who].shares);
215     }
216 
217     // Decrement the number of shares for a member
218     function removeShare(address who, uint256 amount) public onlyAdmin() onlyExisting(who) {
219         totalShares = totalShares.sub(amount);
220         members[who].shares = members[who].shares.sub(amount);
221         RemoveShare(who, amount, members[who].shares);
222     }
223 
224     // Function for a member to withdraw Ether from the contract proportional
225     // to the amount of shares they have. Calculates the totalWithdrawableAmount
226     // in Ether based on the member's share and the Ether balance of the contract,
227     // then subtracts the amount of Ether that the member has already previously
228     // withdrawn.
229     function withdraw(uint256 amount) public onlyExisting(msg.sender) {
230         uint256 newTotal = calculateTotalWithdrawableAmount(msg.sender);
231         if (amount > newTotal.sub(members[msg.sender].withdrawn)) revert();
232         
233         members[msg.sender].withdrawn = members[msg.sender].withdrawn.add(amount);
234         totalWithdrawn = totalWithdrawn.add(amount);
235         msg.sender.transfer(amount);
236         Withdraw(msg.sender, amount, totalWithdrawn);
237     }
238 
239     // Withdrawal function for ERC20 tokens
240     function withdrawToken(uint256 amount, address token) public onlyExisting(msg.sender) {
241         uint256 newTotal = calculateTotalWithdrawableTokenAmount(msg.sender, token);
242         if (amount > newTotal.sub(members[msg.sender].tokensWithdrawn[token])) revert();
243 
244         members[msg.sender].tokensWithdrawn[token] = members[msg.sender].tokensWithdrawn[token].add(amount);
245         tokens[token].totalWithdrawn = tokens[token].totalWithdrawn.add(amount);
246         ERC20(token).transfer(msg.sender, amount);
247         TokenWithdraw(msg.sender, amount, token, tokens[token].totalWithdrawn);
248     }
249 
250     // Withdraw from shared expense allocation. Total withdrawable is calculated as 
251     // sharedExpense minus sharedExpenseWithdrawn. Only Admin can withdraw from shared expense.
252     function withdrawSharedExpense(uint256 amount, address to) public onlyAdmin() {
253         if (amount > calculateTotalExpenseWithdrawableAmount()) revert();
254         
255         sharedExpenseWithdrawn = sharedExpenseWithdrawn.add(amount);
256         to.transfer(amount);
257         WithdrawSharedExpense(msg.sender, to, amount, sharedExpenseWithdrawn);
258     }
259 
260     // Converts from shares to Eth.
261     // Ex: 2 shares, 4 total shares, 40 Eth balance
262     // 40 Eth / 4 total shares = 10 eth per share * 2 shares = 20 Eth to cash out
263     function calculateTotalWithdrawableAmount(address who) public constant onlyExisting(who) returns (uint256) {
264         // Total balance to calculate share from = 
265         // contract balance + totalWithdrawn - sharedExpense + sharedExpenseWithdrawn
266         uint256 balanceSum = this.balance.add(totalWithdrawn);
267         balanceSum = balanceSum.sub(sharedExpense);
268         balanceSum = balanceSum.add(sharedExpenseWithdrawn);
269         
270         // Need to use parts-per notation to compute percentages for lack of floating point division
271         uint256 ethPerSharePPN = balanceSum.percent(totalShares, PRECISION); 
272         uint256 ethPPN = ethPerSharePPN.mul(members[who].shares);
273         uint256 ethVal = ethPPN.div(10**PRECISION); 
274         return ethVal;
275     }
276 
277 
278     function calculateTotalWithdrawableTokenAmount(address who, address token) public constant returns(uint256) {
279         uint256 balanceSum = checkERC20Balance(token).add(tokens[token].totalWithdrawn);
280 
281         // Need to use parts-per notation to compute percentages for lack of floating point division
282         uint256 tokPerSharePPN = balanceSum.percent(totalShares, PRECISION); 
283         uint256 tokPPN = tokPerSharePPN.mul(members[who].shares);
284         uint256 tokVal = tokPPN.div(10**PRECISION); 
285         return tokVal;
286     }
287 
288     function calculateTotalExpenseWithdrawableAmount() public constant returns(uint256) {
289         return sharedExpense.sub(sharedExpenseWithdrawn);
290     }
291 
292     // Used for testing
293     function delegatePercent(uint256 a, uint256 b, uint256 c) public constant returns (uint256) {
294         return a.percent(b, c);
295     }
296 }
297 
298 /**
299  * @title ERC20Basic
300  * @dev Simpler version of ERC20 interface
301  * @dev see https://github.com/ethereum/EIPs/issues/179
302  */
303 contract ERC20Basic {
304   uint256 public totalSupply;
305   function balanceOf(address who) public constant returns (uint256);
306   function transfer(address to, uint256 value) public returns (bool);
307   event Transfer(address indexed from, address indexed to, uint256 value);
308 }
309 
310 
311 /**
312  * @title ERC20 interface
313  * @dev see https://github.com/ethereum/EIPs/issues/20
314  */
315 contract ERC20 is ERC20Basic {
316   function allowance(address owner, address spender) public constant returns (uint256);
317   function transferFrom(address from, address to, uint256 value) public returns (bool);
318   function approve(address spender, uint256 value) public returns (bool);
319   event Approval(address indexed owner, address indexed spender, uint256 value);
320 }
321 
322 
323 /**
324  * @title SafeMath
325  * @dev Math operations with safety checks that throw on error
326  */
327 library SafeMath {
328     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
329         uint256 c = a * b;
330         assert(a == 0 || c / a == b);
331         return c;
332     }
333 
334     function div(uint256 a, uint256 b) internal constant returns (uint256) {
335         // assert(b > 0); // Solidity automatically throws when dividing by 0
336         uint256 c = a / b;
337         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
338         return c;
339     }
340 
341     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
342         assert(b <= a);
343         return a - b;
344     }
345 
346     function add(uint256 a, uint256 b) internal constant returns (uint256) {
347         uint256 c = a + b;
348         assert(c >= a);
349         return c;
350     }
351 
352     // Using from SO: https://stackoverflow.com/questions/42738640/division-in-ethereum-solidity/42739843#42739843
353     // Adapted to use SafeMath and uint256.
354     function percent(uint256 numerator, uint256 denominator, uint256 precision) internal constant returns(uint256 quotient) {
355         // caution, check safe-to-multiply here
356         uint256 _numerator = mul(numerator, 10 ** (precision+1));
357         // with rounding of last digit
358         uint256 _quotient = (div(_numerator, denominator) + 5) / 10;
359         return (_quotient);
360     }
361 }
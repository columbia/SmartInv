1 pragma solidity ^0.4.20;
2 
3 /*
4  * ERC20 interface
5  * see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract ERC20 {
8     uint public totalSupply;
9     function balanceOf(address who) constant returns (uint);
10     function allowance(address owner, address spender) constant returns (uint);
11 
12     function transfer(address to, uint value) returns (bool ok);
13     function transferFrom(address from, address to, uint value) returns (bool ok);
14     function approve(address spender, uint value) returns (bool ok);
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 
20 /**
21  * Math operations with safety checks
22  */
23 contract SafeMath {
24     function safeMul(uint a, uint b) internal returns (uint) {
25         uint c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function safeDiv(uint a, uint b) internal returns (uint) {
31         assert(b > 0);
32         uint c = a / b;
33         assert(a == b * c + a % b);
34         return c;
35     }
36 
37     function safeSub(uint a, uint b) internal returns (uint) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function safeAdd(uint a, uint b) internal returns (uint) {
43         uint c = a + b;
44         assert(c >= a && c >= b);
45         return c;
46     }
47 
48     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49         return a >= b ? a : b;
50     }
51 
52     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53         return a < b ? a : b;
54     }
55 
56     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57         return a >= b ? a : b;
58     }
59 
60     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61         return a < b ? a : b;
62     }
63 
64     function assert(bool assertion) internal {
65         if (!assertion) {
66             throw;
67         }
68     }
69 
70 }
71 
72 /**
73  * Owned contract
74  */
75 contract Owned {
76     address public owner;
77 
78     function Owned() {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function isOwner(address _owner) internal returns (bool){
88         if (_owner == owner){
89             return true;
90         }
91         return false;
92     }
93 
94     function transferOwnership(address newOwner) onlyOwner {
95         owner = newOwner;
96     }
97 }
98 
99 /**
100  * BP crowdsale contract
101 */
102 contract BPToken is SafeMath, Owned, ERC20 {
103     string public constant name = "Backpack Travel Token";
104     string public constant symbol = "BP";
105     uint256 public constant decimals = 18;  
106 
107     mapping (address => uint256) balances;
108     mapping (address => mapping (address => uint256)) allowed;
109 
110     function BPToken() {
111         totalSupply = 2000000000 * 10 ** uint256(decimals);
112         balances[msg.sender] = totalSupply;
113     }
114     
115     event Issue(uint16 role, address indexed to, uint256 value);
116 
117     /// roles
118     enum Roles { Default, Angel, PrivateSale, Partner, Fans, Team, Foundation, Backup }
119     mapping (address => uint256) addressHold;
120     mapping (address => uint16) addressRole;
121 
122     uint perMonthSecond = 2592000;
123     
124     /// lock rule
125     struct LockRule {
126         uint baseLockPercent;
127         uint startLockTime;
128         uint stopLockTime;
129         uint linearRelease;
130     }
131     mapping (uint16 => LockRule) roleRule;
132 
133     /// set the rule for special role
134     function setRule(uint16 _role, uint _baseLockPercent, uint _startLockTime, uint _stopLockTime,uint _linearRelease) onlyOwner {
135         assert(_startLockTime > block.timestamp);
136         assert(_stopLockTime > _startLockTime);
137         
138         roleRule[_role] = LockRule({
139             baseLockPercent: _baseLockPercent,
140             startLockTime: _startLockTime,
141             stopLockTime: _stopLockTime,
142             linearRelease: _linearRelease
143         });
144     }
145     
146     /// assign BP token to another address
147     function assign(uint16 role, address to, uint256 amount) onlyOwner returns (bool) {
148         assert(role <= uint16(Roles.Backup));
149         assert(balances[msg.sender] > amount);
150         
151         /// one address only belong to one role
152         if ((addressRole[to] != uint16(Roles.Default)) && (addressRole[to] != role)) throw;
153 
154         if (role != uint16(Roles.Default)) {
155             addressRole[to] = role;
156             addressHold[to] = safeAdd(addressHold[to],amount);
157         }
158 
159         if (transfer(to,amount)) {
160             Issue(role, to, amount);
161             return true;
162         }
163 
164         return false;
165     }
166 
167     function isRole(address who) internal returns(uint16) {
168         uint16 role = addressRole[who];
169         if (role != 0) {
170             return role;
171         }
172         return 100;
173     }
174     
175     /// calc the balance that the user shuold hold
176     function shouldHadBalance(address who) internal returns (uint){
177         uint16 currentRole = isRole(who);
178         if (isOwner(who) || (currentRole == 100)) {
179             return 0;
180         }
181         
182         // base lock amount 
183         uint256 baseLockAmount = safeDiv(safeMul(addressHold[who], roleRule[currentRole].baseLockPercent),100);
184         
185         /// will not linear release
186         if (roleRule[currentRole].linearRelease == 0) {
187             if (block.timestamp < roleRule[currentRole].stopLockTime) {
188                 return baseLockAmount;
189             } else {
190                 return 0;
191             }
192         }
193         /// will linear release 
194 
195         /// now timestamp before start lock time 
196         if (block.timestamp < roleRule[currentRole].startLockTime + perMonthSecond) {
197             return baseLockAmount;
198         }
199         // total lock months
200         uint lockMonth = safeDiv(safeSub(roleRule[currentRole].stopLockTime,roleRule[currentRole].startLockTime),perMonthSecond);
201         // unlock amount of every month
202         uint256 monthUnlockAmount = safeDiv(baseLockAmount,lockMonth);
203         // current timestamp passed month 
204         uint hadPassMonth = safeDiv(safeSub(block.timestamp,roleRule[currentRole].startLockTime),perMonthSecond);
205 
206         return safeSub(baseLockAmount,safeMul(hadPassMonth,monthUnlockAmount));
207     }
208 
209     /// get balance of the special address
210     function balanceOf(address who) constant returns (uint) {
211         return balances[who];
212     }
213 
214     /// @notice Transfer `value` BP tokens from sender's account
215     /// `msg.sender` to provided account address `to`.
216     /// @notice This function is disabled during the funding.
217     /// @dev Required state: Success
218     /// @param to The address of the recipient
219     /// @param value The number of BPs to transfer
220     /// @return Whether the transfer was successful or not
221     function transfer(address to, uint256 value) returns (bool) {
222         if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;
223 
224         uint256 senderBalance = balances[msg.sender];
225         if (senderBalance >= value && value > 0) {
226             senderBalance = safeSub(senderBalance, value);
227             balances[msg.sender] = senderBalance;
228             balances[to] = safeAdd(balances[to], value);
229             Transfer(msg.sender, to, value);
230             return true;
231         }
232         return false;
233     }
234 
235     /// @notice Transfer `value` BP tokens from sender 'from'
236     /// to provided account address `to`.
237     /// @notice This function is disabled during the funding.
238     /// @dev Required state: Success
239     /// @param from The address of the sender
240     /// @param to The address of the recipient
241     /// @param value The number of BPs to transfer
242     /// @return Whether the transfer was successful or not
243     function transferFrom(address from, address to, uint256 value) returns (bool) {
244         // Abort if not in Success state.
245         // protect against wrapping uints
246         if (balances[from] >= value &&
247         allowed[from][msg.sender] >= value &&
248         safeAdd(balances[to], value) > balances[to])
249         {
250             balances[to] = safeAdd(balances[to], value);
251             balances[from] = safeSub(balances[from], value);
252             allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], value);
253             Transfer(from, to, value);
254             return true;
255         }
256         else {return false;}
257     }
258 
259     /// @notice `msg.sender` approves `spender` to spend `value` tokens
260     /// @param spender The address of the account able to transfer the tokens
261     /// @param value The amount of wei to be approved for transfer
262     /// @return Whether the approval was successful or not
263     function approve(address spender, uint256 value) returns (bool) {
264         if (safeSub(balances[msg.sender],value) < shouldHadBalance(msg.sender)) throw;
265         
266         // Abort if not in Success state.
267         allowed[msg.sender][spender] = value;
268         Approval(msg.sender, spender, value);
269         return true;
270     }
271 
272     /// @param owner The address of the account owning tokens
273     /// @param spender The address of the account able to transfer the tokens
274     /// @return Amount of remaining tokens allowed to spent
275     function allowance(address owner, address spender) constant returns (uint) {
276         uint allow = allowed[owner][spender];
277         return allow;
278     }
279 }
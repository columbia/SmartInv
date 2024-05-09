1 pragma solidity ^0.4.11;
2 
3 contract Migrations {
4   address public owner;
5   uint public last_completed_migration;
6 
7   modifier restricted() {
8     if (msg.sender == owner) _;
9   }
10 
11   function Migrations() {
12     owner = msg.sender;
13   }
14 
15   function setCompleted(uint completed) restricted {
16     last_completed_migration = completed;
17   }
18 
19   function upgrade(address new_address) restricted {
20     Migrations upgraded = Migrations(new_address);
21     upgraded.setCompleted(last_completed_migration);
22   }
23 }
24 
25 contract ERC20 {
26     function totalSupply() constant returns (uint supply);
27     function balanceOf( address who ) constant returns (uint value);
28     function allowance( address owner, address spender ) constant returns (uint _allowance);
29 
30     function transfer( address to, uint value) returns (bool ok);
31     function transferFrom( address from, address to, uint value) returns (bool ok);
32     function approve( address spender, uint value ) returns (bool ok);
33 
34     event Transfer( address indexed from, address indexed to, uint value);
35     event Approval( address indexed owner, address indexed spender, uint value);
36 }
37 
38 contract Lockable {
39     uint public creationTime;
40     bool public lock;
41     bool public tokenTransfer;
42     address public owner;
43     mapping( address => bool ) public unlockaddress;
44     mapping( address => bool ) public lockaddress;
45 
46     event Locked(address lockaddress,bool status);
47     event Unlocked(address unlockedaddress, bool status);
48 
49 
50     // if Token transfer
51     modifier isTokenTransfer {
52         // if token transfer is not allow
53         if(!tokenTransfer) {
54             require(unlockaddress[msg.sender]);
55         }
56         _;
57     }
58 
59     // This modifier check whether the contract should be in a locked
60     // or unlocked state, then acts and updates accordingly if
61     // necessary
62     modifier checkLock {
63         if (lockaddress[msg.sender]) {
64             throw;
65         }
66         _;
67     }
68 
69     modifier isOwner {
70         require(owner == msg.sender);
71         _;
72     }
73 
74     function Lockable() {
75         creationTime = now;
76         tokenTransfer = false;
77         owner = msg.sender;
78     }
79 
80     // Lock Address
81     function lockAddress(address target, bool status)
82     external
83     isOwner
84     {
85         require(owner != target);
86         lockaddress[target] = status;
87         Locked(target, status);
88     }
89 
90     // UnLock Address
91     function unlockAddress(address target, bool status)
92     external
93     isOwner
94     {
95         unlockaddress[target] = status;
96         Unlocked(target, status);
97     }
98 }
99 
100 library SafeMath {
101   function mul(uint a, uint b) internal returns (uint) {
102     uint c = a * b;
103     assert(a == 0 || c / a == b);
104     return c;
105   }
106 
107   function div(uint a, uint b) internal returns (uint) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint a, uint b) internal returns (uint) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint a, uint b) internal returns (uint) {
120     uint c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 
125   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
126     return a >= b ? a : b;
127   }
128 
129   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
130     return a < b ? a : b;
131   }
132 
133   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
134     return a >= b ? a : b;
135   }
136 
137   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
138     return a < b ? a : b;
139   }
140 
141   function assert(bool assertion) internal {
142     if (!assertion) {
143       throw;
144     }
145   }
146 }
147 
148 // ICON ICX Token
149 /// @author DongOk Ryu - <pop@theloop.co.kr>
150 contract IcxToken is ERC20, Lockable {
151     using SafeMath for uint;
152 
153     mapping( address => uint ) _balances;
154     mapping( address => mapping( address => uint ) ) _approvals;
155     uint _supply;
156     address public walletAddress;
157 
158     //event TokenMint(address newTokenHolder, uint amountOfTokens);
159     event TokenBurned(address burnAddress, uint amountOfTokens);
160     event TokenTransfer();
161 
162     modifier onlyFromWallet {
163         require(msg.sender != walletAddress);
164         _;
165     }
166 
167     function IcxToken( uint initial_balance, address wallet) {
168         require(wallet != 0);
169         require(initial_balance != 0);
170         _balances[msg.sender] = initial_balance;
171         _supply = initial_balance;
172         walletAddress = wallet;
173     }
174 
175     function totalSupply() constant returns (uint supply) {
176         return _supply;
177     }
178 
179     function balanceOf( address who ) constant returns (uint value) {
180         return _balances[who];
181     }
182 
183     function allowance(address owner, address spender) constant returns (uint _allowance) {
184         return _approvals[owner][spender];
185     }
186 
187     function transfer( address to, uint value)
188     isTokenTransfer
189     checkLock
190     returns (bool success) {
191 
192         require( _balances[msg.sender] >= value );
193 
194         _balances[msg.sender] = _balances[msg.sender].sub(value);
195         _balances[to] = _balances[to].add(value);
196         Transfer( msg.sender, to, value );
197         return true;
198     }
199 
200     function transferFrom( address from, address to, uint value)
201     isTokenTransfer
202     checkLock
203     returns (bool success) {
204         // if you don't have enough balance, throw
205         require( _balances[from] >= value );
206         // if you don't have approval, throw
207         require( _approvals[from][msg.sender] >= value );
208         // transfer and return true
209         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
210         _balances[from] = _balances[from].sub(value);
211         _balances[to] = _balances[to].add(value);
212         Transfer( from, to, value );
213         return true;
214     }
215 
216     function approve(address spender, uint value)
217     isTokenTransfer
218     checkLock
219     returns (bool success) {
220         _approvals[msg.sender][spender] = value;
221         Approval( msg.sender, spender, value );
222         return true;
223     }
224 
225     // burnToken burn tokensAmount for sender balance
226     function burnTokens(uint tokensAmount)
227     isTokenTransfer
228     external
229     {
230         require( _balances[msg.sender] >= tokensAmount );
231 
232         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
233         _supply = _supply.sub(tokensAmount);
234         TokenBurned(msg.sender, tokensAmount);
235 
236     }
237 
238 
239     function enableTokenTransfer()
240     external
241     onlyFromWallet {
242         tokenTransfer = true;
243         TokenTransfer();
244     }
245 
246     function disableTokenTransfer()
247     external
248     onlyFromWallet {
249         tokenTransfer = false;
250         TokenTransfer();
251     }
252 
253 }
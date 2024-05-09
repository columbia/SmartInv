1 pragma solidity ^0.4.11;
2 /**
3     ERC20 Interface
4     @author DongOk Peter Ryu - <odin@yggdrash.io>
5 */
6 contract ERC20 {
7     function totalSupply() public constant returns (uint supply);
8     function balanceOf( address who ) public constant returns (uint value);
9     function allowance( address owner, address spender ) public constant returns (uint _allowance);
10 
11     function transfer( address to, uint value) public returns (bool ok);
12     function transferFrom( address from, address to, uint value) public returns (bool ok);
13     function approve( address spender, uint value ) public returns (bool ok);
14 
15     event Transfer( address indexed from, address indexed to, uint value);
16     event Approval( address indexed owner, address indexed spender, uint value);
17 }
18 
19 /**
20     LOCKABLE TOKEN
21     @author DongOk Peter Ryu - <odin@yggdrash.io>
22 */
23 contract Lockable {
24     uint public creationTime;
25     bool public lock;
26     bool public tokenTransfer;
27     address public owner;
28     mapping( address => bool ) public unlockaddress;
29     // lockaddress List
30     mapping( address => bool ) public lockaddress;
31 
32     // LOCK EVENT
33     event Locked(address lockaddress,bool status);
34     // UNLOCK EVENT
35     event Unlocked(address unlockedaddress, bool status);
36 
37 
38     // if Token transfer
39     modifier isTokenTransfer {
40         // if token transfer is not allow
41         if(!tokenTransfer) {
42             require(unlockaddress[msg.sender]);
43         }
44         _;
45     }
46 
47     // This modifier check whether the contract should be in a locked
48     // or unlocked state, then acts and updates accordingly if
49     // necessary
50     modifier checkLock {
51         assert(!lockaddress[msg.sender]);
52         _;
53     }
54 
55     modifier isOwner
56     {
57         require(owner == msg.sender);
58         _;
59     }
60 
61     function Lockable()
62     public
63     {
64         creationTime = now;
65         tokenTransfer = false;
66         owner = msg.sender;
67     }
68 
69     // Lock Address
70     function lockAddress(address target, bool status)
71     external
72     isOwner
73     {
74         require(owner != target);
75         lockaddress[target] = status;
76         Locked(target, status);
77     }
78 
79     // UnLock Address
80     function unlockAddress(address target, bool status)
81     external
82     isOwner
83     {
84         unlockaddress[target] = status;
85         Unlocked(target, status);
86     }
87 }
88 
89 
90 library SafeMath {
91   function mul(uint a, uint b) internal returns (uint) {
92     uint c = a * b;
93     assert(a == 0 || c / a == b);
94     return c;
95   }
96 
97   function div(uint a, uint b) internal returns (uint) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     uint c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return c;
102   }
103 
104   function sub(uint a, uint b) internal returns (uint) {
105     assert(b <= a);
106     return a - b;
107   }
108 
109   function add(uint a, uint b) internal returns (uint) {
110     uint c = a + b;
111     assert(c >= a);
112     return c;
113   }
114 
115   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
116     return a >= b ? a : b;
117   }
118 
119   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
120     return a < b ? a : b;
121   }
122 
123   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
124     return a >= b ? a : b;
125   }
126 
127   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
128     return a < b ? a : b;
129   }
130 
131 }
132 
133 /**
134     YGGDRASH Token
135     @author DongOk Peter Ryu - <odin@yggdrash.io>
136 */
137 contract YeedToken is ERC20, Lockable {
138     using SafeMath for uint;
139 
140     mapping( address => uint ) _balances;
141     mapping( address => mapping( address => uint ) ) _approvals;
142     uint _supply;
143     address public walletAddress;
144 
145     event TokenBurned(address burnAddress, uint amountOfTokens);
146     event TokenTransfer();
147 
148     modifier onlyFromWallet {
149         require(msg.sender != walletAddress);
150         _;
151     }
152 
153     function YeedToken( uint initial_balance, address wallet)
154     public
155     {
156         require(wallet != 0);
157         require(initial_balance != 0);
158         _balances[msg.sender] = initial_balance;
159         _supply = initial_balance;
160         walletAddress = wallet;
161     }
162 
163     function totalSupply() public constant returns (uint supply) {
164         return _supply;
165     }
166 
167     function balanceOf( address who ) public constant returns (uint value) {
168         return _balances[who];
169     }
170 
171     function allowance(address owner, address spender) public constant returns (uint _allowance) {
172         return _approvals[owner][spender];
173     }
174 
175     function transfer( address to, uint value)
176     public
177     isTokenTransfer
178     checkLock
179     returns (bool success) {
180 
181         require( _balances[msg.sender] >= value );
182 
183         _balances[msg.sender] = _balances[msg.sender].sub(value);
184         _balances[to] = _balances[to].add(value);
185         Transfer( msg.sender, to, value );
186         return true;
187     }
188 
189     function transferFrom( address from, address to, uint value)
190     public
191     isTokenTransfer
192     checkLock
193     returns (bool success) {
194         // if you don't have enough balance, throw
195         require( _balances[from] >= value );
196         // if you don't have approval, throw
197         require( _approvals[from][msg.sender] >= value );
198         // transfer and return true
199         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
200         _balances[from] = _balances[from].sub(value);
201         _balances[to] = _balances[to].add(value);
202         Transfer( from, to, value );
203         return true;
204     }
205 
206     function approve(address spender, uint value)
207     public
208     checkLock
209     returns (bool success) {
210         _approvals[msg.sender][spender] = value;
211         Approval( msg.sender, spender, value );
212         return true;
213     }
214 
215     // burnToken burn tokensAmount for sender balance
216     function burnTokens(uint tokensAmount)
217     public
218     isTokenTransfer
219     {
220         require( _balances[msg.sender] >= tokensAmount );
221 
222         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
223         _supply = _supply.sub(tokensAmount);
224         TokenBurned(msg.sender, tokensAmount);
225 
226     }
227 
228 
229     function enableTokenTransfer()
230     external
231     onlyFromWallet
232     {
233         tokenTransfer = true;
234         TokenTransfer();
235     }
236 
237     function disableTokenTransfer()
238     external
239     onlyFromWallet
240     {
241         tokenTransfer = false;
242         TokenTransfer();
243     }
244 
245     /* This unnamed function is called whenever someone tries to send ether to it */
246     function () public payable {
247         revert();
248     }
249 
250 }
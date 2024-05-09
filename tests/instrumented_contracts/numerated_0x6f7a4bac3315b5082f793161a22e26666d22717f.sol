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
18 /**
19     LOCKABLE TOKEN
20     @author DongOk Peter Ryu - <odin@yggdrash.io>
21 */
22 contract Lockable {
23     uint public creationTime;
24     bool public lock;
25     bool public tokenTransfer;
26     address public owner;
27     mapping( address => bool ) public unlockaddress;
28     // lockaddress List
29     mapping( address => bool ) public lockaddress;
30 
31     // LOCK EVENT
32     event Locked(address lockaddress,bool status);
33     // UNLOCK EVENT
34     event Unlocked(address unlockedaddress, bool status);
35 
36 
37     // if Token transfer
38     modifier isTokenTransfer {
39         // if token transfer is not allow
40         if(!tokenTransfer) {
41             require(unlockaddress[msg.sender]);
42         }
43         _;
44     }
45 
46     // This modifier check whether the contract should be in a locked
47     // or unlocked state, then acts and updates accordingly if
48     // necessary
49     modifier checkLock {
50         assert(!lockaddress[msg.sender]);
51         _;
52     }
53 
54     modifier isOwner
55     {
56         require(owner == msg.sender);
57         _;
58     }
59 
60     function Lockable()
61     public
62     {
63         creationTime = now;
64         tokenTransfer = false;
65         owner = msg.sender;
66     }
67 
68     // Lock Address
69     function lockAddress(address target, bool status)
70     external
71     isOwner
72     {
73         require(owner != target);
74         lockaddress[target] = status;
75         Locked(target, status);
76     }
77 
78     // UnLock Address
79     function unlockAddress(address target, bool status)
80     external
81     isOwner
82     {
83         unlockaddress[target] = status;
84         Unlocked(target, status);
85     }
86 }
87 
88 library SafeMath {
89   function mul(uint a, uint b) internal returns (uint) {
90     uint c = a * b;
91     assert(a == 0 || c / a == b);
92     return c;
93   }
94 
95   function div(uint a, uint b) internal returns (uint) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   function sub(uint a, uint b) internal returns (uint) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint a, uint b) internal returns (uint) {
108     uint c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 
113   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
114     return a >= b ? a : b;
115   }
116 
117   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
118     return a < b ? a : b;
119   }
120 
121   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
122     return a >= b ? a : b;
123   }
124 
125   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
126     return a < b ? a : b;
127   }
128 
129 }
130 /**
131     YGGDRASH Token
132     @author DongOk Peter Ryu - <odin@yggdrash.io>
133 */
134 contract YeedToken is ERC20, Lockable {
135 
136     // ADD INFORMATION
137     string public constant name = "YGGDRASH";
138     string public constant symbol = "YEED";
139     uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
140 
141     using SafeMath for uint;
142 
143     mapping( address => uint ) _balances;
144     mapping( address => mapping( address => uint ) ) _approvals;
145     uint _supply;
146     address public walletAddress;
147 
148     event TokenBurned(address burnAddress, uint amountOfTokens);
149     event TokenTransfer();
150 
151     modifier onlyFromWallet {
152         require(msg.sender != walletAddress);
153         _;
154     }
155 
156     function YeedToken( uint initial_balance, address wallet)
157     public
158     {
159         require(wallet != 0);
160         require(initial_balance != 0);
161         _balances[msg.sender] = initial_balance;
162         _supply = initial_balance;
163         walletAddress = wallet;
164     }
165 
166     function totalSupply() public constant returns (uint supply) {
167         return _supply;
168     }
169 
170     function balanceOf( address who ) public constant returns (uint value) {
171         return _balances[who];
172     }
173 
174     function allowance(address owner, address spender) public constant returns (uint _allowance) {
175         return _approvals[owner][spender];
176     }
177 
178     function transfer( address to, uint value)
179     public
180     isTokenTransfer
181     checkLock
182     returns (bool success) {
183 
184         require( _balances[msg.sender] >= value );
185 
186         _balances[msg.sender] = _balances[msg.sender].sub(value);
187         _balances[to] = _balances[to].add(value);
188         Transfer( msg.sender, to, value );
189         return true;
190     }
191 
192     function transferFrom( address from, address to, uint value)
193     public
194     isTokenTransfer
195     checkLock
196     returns (bool success) {
197         // if you don't have enough balance, throw
198         require( _balances[from] >= value );
199         // if you don't have approval, throw
200         require( _approvals[from][msg.sender] >= value );
201         // transfer and return true
202         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
203         _balances[from] = _balances[from].sub(value);
204         _balances[to] = _balances[to].add(value);
205         Transfer( from, to, value );
206         return true;
207     }
208 
209     function approve(address spender, uint value)
210     public
211     checkLock
212     returns (bool success) {
213         _approvals[msg.sender][spender] = value;
214         Approval( msg.sender, spender, value );
215         return true;
216     }
217 
218     // burnToken burn tokensAmount for sender balance
219     function burnTokens(uint tokensAmount)
220     public
221     isTokenTransfer
222     {
223         require( _balances[msg.sender] >= tokensAmount );
224 
225         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
226         _supply = _supply.sub(tokensAmount);
227         TokenBurned(msg.sender, tokensAmount);
228 
229     }
230 
231 
232     function enableTokenTransfer()
233     external
234     onlyFromWallet
235     {
236         tokenTransfer = true;
237         TokenTransfer();
238     }
239 
240     function disableTokenTransfer()
241     external
242     onlyFromWallet
243     {
244         tokenTransfer = false;
245         TokenTransfer();
246     }
247 
248     /* This unnamed function is called whenever someone tries to send ether to it */
249     function () public payable {
250         revert();
251     }
252 
253 }
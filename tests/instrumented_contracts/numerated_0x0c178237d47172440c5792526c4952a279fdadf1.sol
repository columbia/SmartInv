1 pragma solidity ^0.4.24;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Token Name: TPC Token
7  * Contract Name: Third Payment Circulation
8  * Author: kolidat#gmail.com
9  * Developed for: TPC LLC.
10  * TPC is an ERC20 Token
11  *
12  *********************************************************************************
13  ********************************************************************************/
14  
15 contract ERC20 {
16     function totalSupply() public view returns (uint supply);
17     function balanceOf(address who) public view returns (uint value);
18     function allowance(address owner, address spender ) public view returns (uint _allowance);
19 
20     function transfer(address to, uint value) public returns (bool ok);
21     function transferFrom(address from, address to, uint value) public returns (bool ok);
22     function approve(address spender, uint value ) public returns (bool ok);
23 
24     event Transfer( address indexed from, address indexed to, uint value);
25     event Approval( address indexed owner, address indexed spender, uint value);
26 }
27 
28 contract Lockable {
29     bool public tokenTransfer;
30     address public owner;
31     mapping( address => bool ) public unlockaddress;
32     mapping( address => bool ) public lockaddress;
33 
34     event Locked(address lockaddress, bool status);
35     event Unlocked(address unlockedaddress, bool status);
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
50         if (lockaddress[msg.sender]) {
51             revert();
52         }
53         _;
54     }
55 
56     modifier isOwner {
57         require(owner == msg.sender);
58         _;
59     }
60 
61     constructor () public {
62         tokenTransfer = false;
63         owner = msg.sender;
64     }
65 
66     // Lock Address
67     function lockAddress(address target, bool status)
68     external
69     isOwner
70     {
71         require(owner != target);
72         lockaddress[target] = status;
73         emit Locked(target, status);
74     }
75 
76     // UnLock Address
77     function unlockAddress(address target, bool status)
78     external
79     isOwner
80     {
81         unlockaddress[target] = status;
82         emit Unlocked(target, status);
83     }
84 }
85 
86 library SafeMath {
87     function mul(uint a, uint b) internal pure returns (uint) {
88         uint c = a * b;
89         assert(a == 0 || c / a == b);
90         return c;
91     }
92 
93     function div(uint a, uint b) internal pure returns (uint) {
94         // assert(b > 0); // Solidity automatically throws when dividing by 0
95         uint c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97         return c;
98     }
99 
100     function sub(uint a, uint b) internal pure returns (uint) {
101         assert(b <= a);
102         return a - b;
103     }
104 
105     function add(uint a, uint b) internal pure returns (uint) {
106         uint c = a + b;
107         assert(c >= a);
108         return c;
109     }
110 
111     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
112         return a >= b ? a : b;
113     }
114 
115     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
116         return a < b ? a : b;
117     }
118 
119     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a >= b ? a : b;
121     }
122 
123     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a < b ? a : b;
125     }
126 }
127 
128 contract TPCToken is ERC20, Lockable {
129     using SafeMath for uint;
130 
131     mapping( address => uint ) _balances;
132     mapping( address => mapping( address => uint ) ) _approvals;
133     uint _supply;
134     string public constant name = "TPC Token";
135     string public constant symbol = "TPC";
136     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
137 
138     event TokenBurned(address burnAddress, uint amountOfTokens);
139     event TokenTransfer();
140 
141     constructor () public {
142         uint initial_balance = 2 * 10 ** 28; // Total supply is 20 billions TPC Tokens
143         _balances[msg.sender] = initial_balance;
144         _supply = initial_balance;
145     }
146 
147     function totalSupply() view public returns (uint supply) {
148         return _supply;
149     }
150 
151     function balanceOf(address who) view public returns (uint value) {
152         return _balances[who];
153     }
154 
155     function allowance(address owner, address spender) view public returns (uint _allowance) {
156         return _approvals[owner][spender];
157     }
158 
159     function transfer(address to, uint value) public 
160     isTokenTransfer
161     checkLock
162     returns (bool success) {
163         require(_balances[msg.sender] >= value);
164         _balances[msg.sender] = _balances[msg.sender].sub(value);
165         _balances[to] = _balances[to].add(value);
166         emit Transfer(msg.sender, to, value);
167         return true;
168     }
169 
170     function transferFrom(address from, address to, uint value) public 
171     isTokenTransfer
172     checkLock
173     returns (bool success) {
174         // if you don't have enough balance, throw
175         require(_balances[from] >= value);
176         // if you don't have approval, throw
177         require(_approvals[from][msg.sender] >= value);
178         // transfer and return true
179         _approvals[from][msg.sender] = _approvals[from][msg.sender].sub(value);
180         _balances[from] = _balances[from].sub(value);
181         _balances[to] = _balances[to].add(value);
182         emit Transfer(from, to, value);
183         return true;
184     }
185 
186     function approve(address spender, uint value) public 
187     isTokenTransfer
188     checkLock
189     returns (bool success) {
190         _approvals[msg.sender][spender] = value;
191         emit Approval(msg.sender, spender, value);
192         return true;
193     }
194 
195     // burnToken burn tokensAmount for sender balance
196     function burnTokens(uint tokensAmount)
197     isTokenTransfer
198     external
199     {
200         require(_balances[msg.sender] >= tokensAmount);
201         _balances[msg.sender] = _balances[msg.sender].sub(tokensAmount);
202         _supply = _supply.sub(tokensAmount);
203         emit TokenBurned(msg.sender, tokensAmount);
204     }
205 
206     function enableTokenTransfer()
207     external
208     isOwner {
209         tokenTransfer = true;
210         emit TokenTransfer();
211     }
212 
213     function disableTokenTransfer()
214     external
215     isOwner {
216         tokenTransfer = false;
217         emit TokenTransfer();
218     }
219 }
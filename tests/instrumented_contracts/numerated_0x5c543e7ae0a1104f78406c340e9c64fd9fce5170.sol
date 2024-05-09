1 pragma solidity ^0.4.0;
2 /*
3 This vSlice token contract is based on the ERC20 token contract. Additional
4 functionality has been integrated:
5 * the contract Lockable, which is used as a parent of the Token contract
6 * the function mintTokens(), which makes use of the currentSwapRate() and safeToAdd() helpers
7 * the function disableTokenSwapLock()
8 */
9 
10 contract Lockable {
11     uint public numOfCurrentEpoch;
12     uint public creationTime;
13     uint public constant UNLOCKED_TIME = 25 days;
14     uint public constant LOCKED_TIME = 5 days;
15     uint public constant EPOCH_LENGTH = 30 days;
16     bool public lock;
17     bool public tokenSwapLock;
18 
19     event Locked();
20     event Unlocked();
21 
22     // This modifier should prevent tokens transfers while the tokenswap
23     // is still ongoing
24     modifier isTokenSwapOn {
25         if (tokenSwapLock) throw;
26         _;
27     }
28 
29     // This modifier checks and, if needed, updates the value of current
30     // token contract epoch, before executing a token transfer of any
31     // kind
32     modifier isNewEpoch {
33         if (numOfCurrentEpoch * EPOCH_LENGTH + creationTime < now ) {
34             numOfCurrentEpoch = (now - creationTime) / EPOCH_LENGTH + 1;
35         }
36         _;
37     }
38 
39     // This modifier check whether the contract should be in a locked
40     // or unlocked state, then acts and updates accordingly if
41     // necessary
42     modifier checkLock {
43         if ((creationTime + numOfCurrentEpoch * UNLOCKED_TIME) +
44         (numOfCurrentEpoch - 1) * LOCKED_TIME < now) {
45             // avoids needless lock state change and event spamming
46             if (lock) throw;
47 
48             lock = true;
49             Locked();
50             return;
51         }
52         else {
53             // only set to false if in a locked state, to avoid
54             // needless state change and event spam
55             if (lock) {
56                 lock = false;
57                 Unlocked();
58             }
59         }
60         _;
61     }
62 
63     function Lockable() {
64         creationTime = now;
65         numOfCurrentEpoch = 1;
66         tokenSwapLock = true;
67     }
68 }
69 
70 
71 contract ERC20 {
72     function totalSupply() constant returns (uint);
73     function balanceOf(address who) constant returns (uint);
74     function allowance(address owner, address spender) constant returns (uint);
75 
76     function transfer(address to, uint value) returns (bool ok);
77     function transferFrom(address from, address to, uint value) returns (bool ok);
78     function approve(address spender, uint value) returns (bool ok);
79 
80     event Transfer(address indexed from, address indexed to, uint value);
81     event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 contract Token is ERC20, Lockable {
85 
86   mapping( address => uint ) _balances;
87   mapping( address => mapping( address => uint ) ) _approvals;
88   uint _supply;
89   address public walletAddress;
90 
91   event TokenMint(address newTokenHolder, uint amountOfTokens);
92   event TokenSwapOver();
93 
94   modifier onlyFromWallet {
95       if (msg.sender != walletAddress) throw;
96       _;
97   }
98 
99   function Token( uint initial_balance, address wallet) {
100     _balances[msg.sender] = initial_balance;
101     _supply = initial_balance;
102     walletAddress = wallet;
103   }
104 
105   function totalSupply() constant returns (uint supply) {
106     return _supply;
107   }
108 
109   function balanceOf( address who ) constant returns (uint value) {
110     return _balances[who];
111   }
112 
113   function allowance(address owner, address spender) constant returns (uint _allowance) {
114     return _approvals[owner][spender];
115   }
116 
117   // A helper to notify if overflow occurs
118   function safeToAdd(uint a, uint b) internal returns (bool) {
119     return (a + b >= a && a + b >= b);
120   }
121 
122   function transfer( address to, uint value)
123     isTokenSwapOn
124     isNewEpoch
125     checkLock
126     returns (bool ok) {
127 
128     if( _balances[msg.sender] < value ) {
129         throw;
130     }
131     if( !safeToAdd(_balances[to], value) ) {
132         throw;
133     }
134 
135     _balances[msg.sender] -= value;
136     _balances[to] += value;
137     Transfer( msg.sender, to, value );
138     return true;
139   }
140 
141   function transferFrom( address from, address to, uint value)
142     isTokenSwapOn
143     isNewEpoch
144     checkLock
145     returns (bool ok) {
146     // if you don't have enough balance, throw
147     if( _balances[from] < value ) {
148         throw;
149     }
150     // if you don't have approval, throw
151     if( _approvals[from][msg.sender] < value ) {
152         throw;
153     }
154     if( !safeToAdd(_balances[to], value) ) {
155         throw;
156     }
157     // transfer and return true
158     _approvals[from][msg.sender] -= value;
159     _balances[from] -= value;
160     _balances[to] += value;
161     Transfer( from, to, value );
162     return true;
163   }
164 
165   function approve(address spender, uint value)
166     isTokenSwapOn
167     isNewEpoch
168     checkLock
169     returns (bool ok) {
170     _approvals[msg.sender][spender] = value;
171     Approval( msg.sender, spender, value );
172     return true;
173   }
174 
175   // The function currentSwapRate() returns the current exchange rate
176   // between vSlice tokens and Ether during the token swap period
177   function currentSwapRate() constant returns(uint) {
178       if (creationTime + 1 weeks > now) {
179           return 130;
180       }
181       else if (creationTime + 2 weeks > now) {
182           return 120;
183       }
184       else if (creationTime + 4 weeks > now) {
185           return 100;
186       }
187       else {
188           return 0;
189       }
190   }
191 
192   // The function mintTokens is only usable by the chosen wallet
193   // contract to mint a number of tokens proportional to the
194   // amount of ether sent to the wallet contract. The function
195   // can only be called during the tokenswap period
196   function mintTokens(address newTokenHolder, uint etherAmount)
197     external
198     onlyFromWallet {
199 
200         uint tokensAmount = currentSwapRate() * etherAmount;
201         if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw;
202         if(!safeToAdd(_supply,tokensAmount)) throw;
203 
204         _balances[newTokenHolder] += tokensAmount;
205         _supply += tokensAmount;
206 
207         TokenMint(newTokenHolder, tokensAmount);
208   }
209 
210   // The function disableTokenSwapLock() is called by the wallet
211   // contract once the token swap has reached its end conditions
212   function disableTokenSwapLock()
213     external
214     onlyFromWallet {
215         tokenSwapLock = false;
216         TokenSwapOver();
217   }
218 }
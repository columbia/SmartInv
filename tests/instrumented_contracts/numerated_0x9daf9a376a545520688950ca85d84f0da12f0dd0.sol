1 pragma solidity ^0.4.24;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * Copyright (c) 2016 Smart Contract Solutions, Inc.
7  * Released under the MIT license.
8  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
9 */
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // assert(b > 0); // Solidity automatically throws when dividing by 0
34     // uint256 c = a / b;
35     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36     return a / b;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 // File: contracts/token/ERC20/ERC20Interface.sol
58 
59 /**
60  * Copyright (c) 2016 Smart Contract Solutions, Inc.
61  * Released under the MIT license.
62  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
63 */
64 
65 /**
66  * @title 
67  * @dev 
68  */
69 contract ERC20Interface {
70   function totalSupply() external view returns (uint256);
71   function balanceOf(address who) external view returns (uint256);
72   function transfer(address to, uint256 value) external returns (bool);
73   function allowance(address owner, address spender) external view returns (uint256);
74   function transferFrom(address from, address to, uint256 value) external returns (bool);
75   function approve(address spender, uint256 value) external returns (bool);
76   event Transfer(address indexed from, address indexed to, uint256 value);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/DAICOVO/TimeLockPool.sol
81 
82 /// @title A token-pool that locks deposited tokens until their date of maturity.
83 /// @author ICOVO AG
84 /// @dev It regards the address "0x0" as ETH when you speficy a token.
85 contract TimeLockPool{
86     using SafeMath for uint256;
87 
88     struct LockedBalance {
89       uint256 balance;
90       uint256 releaseTime;
91     }
92 
93     /*
94       structure: lockedBalnces[owner][token] = LockedBalance(balance, releaseTime);
95       token address = '0x0' stands for ETH (unit = wei)
96     */
97     mapping (address => mapping (address => LockedBalance[])) public lockedBalances;
98 
99     event Deposit(
100         address indexed owner,
101         address indexed tokenAddr,
102         uint256 amount,
103         uint256 releaseTime
104     );
105 
106     event Withdraw(
107         address indexed owner,
108         address indexed tokenAddr,
109         uint256 amount
110     );
111 
112     /// @dev Constructor. 
113     /// @return 
114     constructor() public {}
115 
116     /// @dev Deposit tokens to specific account with time-lock.
117     /// @param tokenAddr The contract address of a ERC20/ERC223 token.
118     /// @param account The owner of deposited tokens.
119     /// @param amount Amount to deposit.
120     /// @param releaseTime Time-lock period.
121     /// @return True if it is successful, revert otherwise.
122     function depositERC20 (
123         address tokenAddr,
124         address account,
125         uint256 amount,
126         uint256 releaseTime
127     ) external returns (bool) {
128         require(account != address(0x0));
129         require(tokenAddr != 0x0);
130         require(msg.value == 0);
131         require(amount > 0);
132         require(ERC20Interface(tokenAddr).transferFrom(msg.sender, this, amount));
133 
134         lockedBalances[account][tokenAddr].push(LockedBalance(amount, releaseTime));
135         emit Deposit(account, tokenAddr, amount, releaseTime);
136 
137         return true;
138     }
139 
140     /// @dev Deposit ETH to specific account with time-lock.
141     /// @param account The owner of deposited tokens.
142     /// @param releaseTime Timestamp to release the fund.
143     /// @return True if it is successful, revert otherwise.
144     function depositETH (
145         address account,
146         uint256 releaseTime
147     ) external payable returns (bool) {
148         require(account != address(0x0));
149         address tokenAddr = address(0x0);
150         uint256 amount = msg.value;
151         require(amount > 0);
152 
153         lockedBalances[account][tokenAddr].push(LockedBalance(amount, releaseTime));
154         emit Deposit(account, tokenAddr, amount, releaseTime);
155 
156         return true;
157     }
158 
159     /// @dev Release the available balance of an account.
160     /// @param account An account to receive tokens.
161     /// @param tokenAddr An address of ERC20/ERC223 token.
162     /// @param max_count Max number of records to withdraw.
163     /// @return True if it is successful, revert otherwise.
164     function withdraw (address account, address tokenAddr, uint256 max_count) external returns (bool) {
165         require(account != address(0x0));
166 
167         uint256 release_amount = 0;
168         for (uint256 i = 0; i < lockedBalances[account][tokenAddr].length && i < max_count; i++) {
169             if (lockedBalances[account][tokenAddr][i].balance > 0 &&
170                 lockedBalances[account][tokenAddr][i].releaseTime <= block.timestamp) {
171 
172                 release_amount = release_amount.add(lockedBalances[account][tokenAddr][i].balance);
173                 lockedBalances[account][tokenAddr][i].balance = 0;
174             }
175         }
176 
177         require(release_amount > 0);
178 
179         if (tokenAddr == 0x0) {
180             if (!account.send(release_amount)) {
181                 revert();
182             }
183             emit Withdraw(account, tokenAddr, release_amount);
184             return true;
185         } else {
186             if (!ERC20Interface(tokenAddr).transfer(account, release_amount)) {
187                 revert();
188             }
189             emit Withdraw(account, tokenAddr, release_amount);
190             return true;
191         }
192     }
193 
194     /// @dev Returns total amount of balances which already passed release time.
195     /// @param account An account to receive tokens.
196     /// @param tokenAddr An address of ERC20/ERC223 token.
197     /// @return Available balance of specified token.
198     function getAvailableBalanceOf (address account, address tokenAddr) 
199         external
200         view
201         returns (uint256)
202     {
203         require(account != address(0x0));
204 
205         uint256 balance = 0;
206         for(uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
207             if (lockedBalances[account][tokenAddr][i].releaseTime <= block.timestamp) {
208                 balance = balance.add(lockedBalances[account][tokenAddr][i].balance);
209             }
210         }
211         return balance;
212     }
213 
214     /// @dev Returns total amount of balances which are still locked.
215     /// @param account An account to receive tokens.
216     /// @param tokenAddr An address of ERC20/ERC223 token.
217     /// @return Locked balance of specified token.
218     function getLockedBalanceOf (address account, address tokenAddr)
219         external
220         view
221         returns (uint256) 
222     {
223         require(account != address(0x0));
224 
225         uint256 balance = 0;
226         for(uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
227             if(lockedBalances[account][tokenAddr][i].releaseTime > block.timestamp) {
228                 balance = balance.add(lockedBalances[account][tokenAddr][i].balance);
229             }
230         }
231         return balance;
232     }
233 
234     /// @dev Returns next release time of locked balances.
235     /// @param account An account to receive tokens.
236     /// @param tokenAddr An address of ERC20/ERC223 token.
237     /// @return Timestamp of next release.
238     function getNextReleaseTimeOf (address account, address tokenAddr)
239         external
240         view
241         returns (uint256) 
242     {
243         require(account != address(0x0));
244 
245         uint256 nextRelease = 2**256 - 1;
246         for (uint256 i = 0; i < lockedBalances[account][tokenAddr].length; i++) {
247             if (lockedBalances[account][tokenAddr][i].releaseTime > block.timestamp &&
248                lockedBalances[account][tokenAddr][i].releaseTime < nextRelease) {
249 
250                 nextRelease = lockedBalances[account][tokenAddr][i].releaseTime;
251             }
252         }
253 
254         /* returns 0 if there are no more locked balances. */
255         if (nextRelease == 2**256 - 1) {
256             nextRelease = 0;
257         }
258         return nextRelease;
259     }
260 }
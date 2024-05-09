1 // File: contracts/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.7.6;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: contracts/IWCHI.sol
82 
83 // Copyright (C) 2021 Autonomous Worlds Ltd
84 
85 pragma solidity ^0.7.6;
86 
87 
88 /**
89  * @dev Interface for the wrapped CHI (WCHI) token.
90  */
91 interface IWCHI is IERC20
92 {
93 
94   /**
95    * @dev Burns the given number of tokens, reducing total supply.
96    */
97   function burn (uint256 value) external;
98 
99   /**
100    * @dev Increases the allowance of a given spender by the given amount.
101    */
102   function increaseAllowance (address spender, uint256 addedValue)
103       external returns (bool);
104 
105   /**
106    * @dev Decreases the allowance of a given spender by the given amount.
107    */
108   function decreaseAllowance (address spender, uint256 removedValue)
109       external returns (bool);
110 
111 }
112 
113 // File: contracts/WCHI.sol
114 
115 // Copyright (C) 2021 Autonomous Worlds Ltd
116 
117 pragma solidity ^0.7.6;
118 
119 
120 /**
121  * @dev Wrapped CHI (WCHI) token.  This contract is not upgradable and not
122  * owned, but it grants an initial supply to the contract creator.  The Xaya
123  * team will hold these tokens, and give them out for CHI locked on the
124  * Xaya network.  When WCHI tokens are returned, those CHI will be released
125  * again.
126  */
127 contract WCHI is IWCHI
128 {
129 
130   string public constant name = "Wrapped CHI";
131   string public constant symbol = "WCHI";
132 
133   /** @dev Native CHI has 8 decimals (like BTC), we mimic that here.  */
134   uint8 public constant decimals = 8;
135 
136   /**
137    * @dev Initial supply of tokens minted.  This is a bit larger than the
138    * real total supply of CHI.
139    */
140   uint256 internal constant initialSupply = 78 * 10**6 * 10**decimals;
141 
142   /**
143    * @dev Total supply of tokens.  This includes tokens that are in the
144    * Xaya team's reserve, i.e. do not correspond to real CHI locked
145    * in the treasury.
146    */
147   uint256 public override totalSupply;
148 
149   /** @dev Balances of tokens per address.  */
150   mapping (address => uint256) public override balanceOf;
151 
152   /**
153    * @dev Allowances for accounts (second) to spend from the balance
154    * of an owner (first).
155    */
156   mapping (address => mapping (address => uint256)) public override allowance;
157 
158   /**
159    * @dev In the constructor, we grant the contract creator the initial balance.
160    * This is the only place where any address has special rights compared
161    * to all others.
162    */
163   constructor ()
164   {
165     totalSupply = initialSupply;
166     balanceOf[msg.sender] = initialSupply;
167     emit Transfer (address (0), msg.sender, initialSupply);
168   }
169 
170   /**
171    * @dev Sets the allowance afforded to the given spender by
172    * the message sender.
173    */
174   function approve (address spender, uint256 value)
175       external override returns (bool)
176   {
177     setApproval (msg.sender, spender, value);
178     return true;
179   }
180 
181   /**
182    * @dev Moves a given amount of tokens from the message sender's
183    * account to the recipient.  If to is the zero address, then those
184    * tokens are burnt and reduce the total supply.
185    */
186   function transfer (address to, uint256 value) external override returns (bool)
187   {
188     uncheckedTransfer (msg.sender, to, value);
189     return true;
190   }
191 
192   /**
193    * @dev Moves a given amount of tokens from the sender account to the
194    * recipient.  If from is not the message sender, then it needs to have
195    * sufficient allowance.
196    */
197   function transferFrom (address from, address to, uint256 value)
198       external override returns (bool)
199   {
200     if (from != msg.sender)
201       {
202         /* Check for the allowance and reduce it.  */
203         uint256 allowed = allowance[from][msg.sender];
204         if (allowed != type (uint256).max)
205           {
206             require (allowed >= value, "WCHI: allowance exceeded");
207             uint256 newAllowed = allowed - value;
208             setApproval (from, msg.sender, newAllowed);
209           }
210       }
211 
212     uncheckedTransfer (from, to, value);
213     return true;
214   }
215 
216   /**
217    * @dev Internal transfer implementation.  This is used to implement transfer
218    * and transferFrom, and does not check that the sender is actually
219    * allowed to spend the tokens.
220    */
221   function uncheckedTransfer (address from, address to, uint256 value) internal
222   {
223     require (to != address (0), "WCHI: transfer to zero address");
224     require (to != address (this), "WCHI: transfer to contract address");
225 
226     deductBalance (from, value);
227     balanceOf[to] += value;
228 
229     emit Transfer (from, to, value);
230   }
231 
232   /**
233    * @dev Burns tokens from the sender's balance, reducing total supply.
234    */
235   function burn (uint256 value) external override
236   {
237     deductBalance (msg.sender, value);
238     assert (totalSupply >= value);
239     totalSupply -= value;
240     emit Transfer (msg.sender, address (0), value);
241   }
242 
243   /**
244    * @dev Increases the allowance of a given spender by a certain
245    * amount (rather than explicitly setting the new allowance).  This fails
246    * if the new allowance would be at infinity (or overflow).
247    */
248   function increaseAllowance (address spender, uint256 addedValue)
249       external override returns (bool)
250   {
251     uint256 allowed = allowance[msg.sender][spender];
252 
253     uint256 increaseToInfinity = type (uint256).max - allowed;
254     require (addedValue < increaseToInfinity,
255              "WCHI: increase allowance overflow");
256 
257     setApproval (msg.sender, spender, allowed + addedValue);
258     return true;
259   }
260 
261   /**
262    * @dev Decreases the allowance of a given spender by a certain value.
263    * If the value is more than the current allowance, it is set to zero.
264    */
265   function decreaseAllowance (address spender, uint256 removedValue)
266       external override returns (bool)
267   {
268     uint256 allowed = allowance[msg.sender][spender];
269 
270     if (removedValue >= allowed)
271       setApproval (msg.sender, spender, 0);
272     else
273       setApproval (msg.sender, spender, allowed - removedValue);
274 
275     return true;
276   }
277 
278   /**
279    * @dev Internal helper function to check the balance of the given user
280    * and deduct the given amount.
281    */
282   function deductBalance (address from, uint256 value) internal
283   {
284     uint256 balance = balanceOf[from];
285     require (balance >= value, "WCHI: insufficient balance");
286     balanceOf[from] = balance - value;
287   }
288 
289   /**
290    * @dev Internal helper function to explicitly set the allowance of
291    * a spender without any checks, and emit the Approval event.
292    */
293   function setApproval (address owner, address spender, uint256 value) internal
294   {
295     allowance[owner][spender] = value;
296     emit Approval (owner, spender, value);
297   }
298 
299 }
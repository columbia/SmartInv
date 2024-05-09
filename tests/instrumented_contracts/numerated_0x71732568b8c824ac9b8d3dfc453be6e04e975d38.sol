1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.6.12;
3 
4 
5 interface IERC20 {
6     /**
7      * @dev Returns the amount of tokens in existence.
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *	
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(
60         address sender,
61         address recipient,
62         uint256 amount
63     ) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeMath {
81     /**
82      * @dev Returns the addition of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `+` operator.
86      *
87      * Requirements:
88      *
89      * - Addition cannot overflow.
90      */
91     function add(uint256 a, uint256 b) internal pure returns (uint256) {
92         uint256 c = a + b;
93         require(c >= a, "SafeMath: addition overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return sub(a, b, "SafeMath: subtraction overflow");
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b <= a, errorMessage);
124         uint256 c = a - b;
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `*` operator.
134      *
135      * Requirements:
136      *
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b > 0, errorMessage);
183         uint256 c = a / b;
184         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
191      * Reverts when dividing by zero.
192      *
193      * Counterpart to Solidity's `%` operator. This function uses a `revert`
194      * opcode (which leaves remaining gas untouched) while Solidity uses an
195      * invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         return mod(a, b, "SafeMath: modulo by zero");
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts with custom message when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b != 0, errorMessage);
219         return a % b;
220     }
221 }
222 
223 contract SimpleCrowdsale {
224     using SafeMath for uint256;
225       // The token being sold
226   address public token;
227   
228   address[] public incoming_addresses;
229   
230     
231     uint256 public count = 1;
232      mapping (uint256 => address) public investor_list;
233 
234   // How many token units a buyer gets per wei
235   uint256 public rate;
236 
237   // Amount of wei raised
238   uint256 public weiRaised;
239     uint256 total_tokens_value;
240   
241   bool public locked = false;
242   
243     address public owner_address;
244     
245 
246     // function get_total_count() public returns (uint256){
247     //     return count;
248     // }
249     // function get_address_from_list(uint256 tcount) public returns (address){
250     //     return investor_list[tcount];
251     // }
252     // function get_balance(address address_of_investor) public returns (uint256){
253     //     return IERC20(token).balanceOf(address_of_investor);
254     // }
255     function get_incoming_addresses(uint256 index) public returns (address){
256         return incoming_addresses[index];
257     }
258     
259 
260 
261   
262     constructor(uint256 t_rate,address t_token) public payable {
263         token = t_token;
264         owner_address = msg.sender;
265         rate = t_rate;
266         
267         
268     }
269         function total_tokens() public view returns (uint256)
270     {
271         return IERC20(token).balanceOf(address(this));
272     }
273             function upadte_total_tokens() internal
274     {
275         total_tokens_value = IERC20(token).balanceOf(address(this));
276     }
277     function unlock() public {
278         require(msg.sender == owner_address,"Only owner");
279         locked = false;
280     }
281     function get_back_all_tokens() public {
282         require(msg.sender == owner_address,"Only owner");
283         IERC20(token).transfer(msg.sender, IERC20(token).balanceOf(address(this)));
284         upadte_total_tokens();
285     }
286     function get_back_tokens(uint256 amount) public {
287         require(msg.sender == owner_address,"Only owner");
288         //require(total_tokens_value >= amount);
289         IERC20(token).transfer(msg.sender, amount);
290         
291         upadte_total_tokens();
292     }
293         function lock() public {
294             require(msg.sender == owner_address,"Only owner");
295         locked = true;
296     }
297 
298     
299     // function getBalanceOfToken(address _address) public view returns (uint256) {
300     //     return IERC20(_address).balanceOf(address(this));
301     // }
302     
303     receive() external payable {
304       buyTokens(msg.sender);
305      //IERC20(token).transfer(msg.sender, 100000000000000000);
306     }
307     fallback() external payable {
308        // buyTokens(msg.sender);
309     }
310     
311     function buyTokens(address payable _beneficiary) public payable{
312 
313          require(!locked, "Locked");
314          uint256 weiAmount = msg.value;
315         _preValidatePurchase(_beneficiary,msg.value);
316     
317         // calculate token amount to be created
318          uint256 t_rate = _getTokenAmount(weiAmount);
319          require(IERC20(token).balanceOf(address(this)) >= t_rate, "Contract Doesnot have enough tokens");
320     
321         //  // update state
322          
323         
324         IERC20(token).transfer(_beneficiary, t_rate);
325         incoming_addresses.push(_beneficiary);
326         weiRaised = weiRaised.add(weiAmount);
327         investor_list[count] = _beneficiary;
328         count++;
329        // _deliverTokens(_beneficiary, t_rate);
330        upadte_total_tokens();
331 
332   }
333   
334     function _preValidatePurchase (
335         address _beneficiary,
336         uint256 _weiAmount
337     ) pure
338     internal
339     {
340         require(_beneficiary != address(0), "Beneficiary = address(0)");
341         require(_weiAmount >= 100000000000000000 || _weiAmount <= 10000000000000000000 ,"send Minimum 0.1 eth or 10 Eth max");
342     }
343     
344       function extractEther() public {
345            require(msg.sender == owner_address,"Only owner");
346           msg.sender.transfer(address(this).balance);
347        }
348         function changeOwner(address new_owner) public {
349            require(msg.sender == owner_address,"Only owner");
350           owner_address = new_owner;
351        }
352   
353     function _getTokenAmount(uint256 _weiAmount)
354     public view returns (uint256)
355     {
356         uint256 temp1 = _weiAmount.div(1000000000);
357         return temp1.mul(rate) * 10**9;
358        // return _weiAmount.mul(325) * 10**9;
359     }
360     
361         function _calculate_TokenAmount(uint256 _weiAmount, uint256 t_rate, uint divide_amount)
362     public pure returns (uint256)
363     {
364         uint256 temp2 = _weiAmount.div(divide_amount);
365         return temp2.mul(t_rate);
366     }
367     
368 
369          function update_rate(uint256 _rate)
370     public
371     {
372         require(msg.sender == owner_address,"Only owner");
373         rate = _rate;
374     }
375 
376   
377     function _deliverTokens(
378     address _beneficiary,
379     uint256 _tokenAmount
380   )
381     internal
382   {
383     IERC20(token).transfer(_beneficiary, _tokenAmount);
384   }
385     
386 }
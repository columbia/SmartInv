1 // File: contracts/intf/IERC20.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 /**
14  * @dev Interface of the ERC20 standard as defined in the EIP.
15  */
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     function decimals() external view returns (uint8);
23 
24     function name() external view returns (string memory);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 }
80 
81 // File: contracts/lib/SafeMath.sol
82 
83 /*
84 
85     Copyright 2020 DODO ZOO.
86 
87 */
88 
89 
90 
91 /**
92  * @title SafeMath
93  * @author DODO Breeder
94  *
95  * @notice Math operations with safety checks that revert on error
96  */
97 library SafeMath {
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         if (a == 0) {
100             return 0;
101         }
102 
103         uint256 c = a * b;
104         require(c / a == b, "MUL_ERROR");
105 
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         require(b > 0, "DIVIDING_ERROR");
111         return a / b;
112     }
113 
114     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 quotient = div(a, b);
116         uint256 remainder = a - quotient * b;
117         if (remainder > 0) {
118             return quotient + 1;
119         } else {
120             return quotient;
121         }
122     }
123 
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         require(b <= a, "SUB_ERROR");
126         return a - b;
127     }
128 
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "ADD_ERROR");
132         return c;
133     }
134 
135     function sqrt(uint256 x) internal pure returns (uint256 y) {
136         uint256 z = x / 2 + 1;
137         y = x;
138         while (z < y) {
139             y = z;
140             z = (x / z + z) / 2;
141         }
142     }
143 }
144 
145 // File: contracts/lib/Ownable.sol
146 
147 /*
148 
149     Copyright 2020 DODO ZOO.
150 
151 */
152 
153 
154 /**
155  * @title Ownable
156  * @author DODO Breeder
157  *
158  * @notice Ownership related functions
159  */
160 contract Ownable {
161     address public _OWNER_;
162     address public _NEW_OWNER_;
163 
164     // ============ Events ============
165 
166     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
167 
168     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
169 
170     // ============ Modifiers ============
171 
172     modifier onlyOwner() {
173         require(msg.sender == _OWNER_, "NOT_OWNER");
174         _;
175     }
176 
177     // ============ Functions ============
178 
179     constructor() internal {
180         _OWNER_ = msg.sender;
181         emit OwnershipTransferred(address(0), _OWNER_);
182     }
183 
184     function transferOwnership(address newOwner) external onlyOwner {
185         require(newOwner != address(0), "INVALID_OWNER");
186         emit OwnershipTransferPrepared(_OWNER_, newOwner);
187         _NEW_OWNER_ = newOwner;
188     }
189 
190     function claimOwnership() external {
191         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
192         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
193         _OWNER_ = _NEW_OWNER_;
194         _NEW_OWNER_ = address(0);
195     }
196 }
197 
198 // File: contracts/impl/DODOLpToken.sol
199 
200 /*
201 
202     Copyright 2020 DODO ZOO.
203 
204 */
205 
206 
207 
208 
209 
210 /**
211  * @title DODOLpToken
212  * @author DODO Breeder
213  *
214  * @notice Tokenize liquidity pool assets. An ordinary ERC20 contract with mint and burn functions
215  */
216 contract DODOLpToken is Ownable {
217     using SafeMath for uint256;
218 
219     string public symbol = "DLP";
220     address public originToken;
221 
222     uint256 public totalSupply;
223     mapping(address => uint256) internal balances;
224     mapping(address => mapping(address => uint256)) internal allowed;
225 
226     // ============ Events ============
227 
228     event Transfer(address indexed from, address indexed to, uint256 amount);
229 
230     event Approval(address indexed owner, address indexed spender, uint256 amount);
231 
232     event Mint(address indexed user, uint256 value);
233 
234     event Burn(address indexed user, uint256 value);
235 
236     // ============ Functions ============
237 
238     constructor(address _originToken) public {
239         originToken = _originToken;
240     }
241 
242     function name() public view returns (string memory) {
243         string memory lpTokenSuffix = "_DODO_LP_TOKEN_";
244         return string(abi.encodePacked(IERC20(originToken).name(), lpTokenSuffix));
245     }
246 
247     function decimals() public view returns (uint8) {
248         return IERC20(originToken).decimals();
249     }
250 
251     /**
252      * @dev transfer token for a specified address
253      * @param to The address to transfer to.
254      * @param amount The amount to be transferred.
255      */
256     function transfer(address to, uint256 amount) public returns (bool) {
257         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
258 
259         balances[msg.sender] = balances[msg.sender].sub(amount);
260         balances[to] = balances[to].add(amount);
261         emit Transfer(msg.sender, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev Gets the balance of the specified address.
267      * @param owner The address to query the the balance of.
268      * @return balance An uint256 representing the amount owned by the passed address.
269      */
270     function balanceOf(address owner) external view returns (uint256 balance) {
271         return balances[owner];
272     }
273 
274     /**
275      * @dev Transfer tokens from one address to another
276      * @param from address The address which you want to send tokens from
277      * @param to address The address which you want to transfer to
278      * @param amount uint256 the amount of tokens to be transferred
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 amount
284     ) public returns (bool) {
285         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
286         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
287 
288         balances[from] = balances[from].sub(amount);
289         balances[to] = balances[to].add(amount);
290         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
291         emit Transfer(from, to, amount);
292         return true;
293     }
294 
295     /**
296      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
297      * @param spender The address which will spend the funds.
298      * @param amount The amount of tokens to be spent.
299      */
300     function approve(address spender, uint256 amount) public returns (bool) {
301         allowed[msg.sender][spender] = amount;
302         emit Approval(msg.sender, spender, amount);
303         return true;
304     }
305 
306     /**
307      * @dev Function to check the amount of tokens that an owner allowed to a spender.
308      * @param owner address The address which owns the funds.
309      * @param spender address The address which will spend the funds.
310      * @return A uint256 specifying the amount of tokens still available for the spender.
311      */
312     function allowance(address owner, address spender) public view returns (uint256) {
313         return allowed[owner][spender];
314     }
315 
316     function mint(address user, uint256 value) external onlyOwner {
317         balances[user] = balances[user].add(value);
318         totalSupply = totalSupply.add(value);
319         emit Mint(user, value);
320         emit Transfer(address(0), user, value);
321     }
322 
323     function burn(address user, uint256 value) external onlyOwner {
324         balances[user] = balances[user].sub(value);
325         totalSupply = totalSupply.sub(value);
326         emit Burn(user, value);
327         emit Transfer(user, address(0), value);
328     }
329 }
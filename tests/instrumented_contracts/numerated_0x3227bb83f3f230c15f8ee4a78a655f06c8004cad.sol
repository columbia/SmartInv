1 pragma solidity ^0.5.8;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that revert on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
12   */
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     require(b <= a);
15     uint256 c = a - b;
16 
17     return c;
18   }
19 
20   /**
21   * @dev Adds two numbers, reverts on overflow.
22   */
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     require(c >= a);
26 
27     return c;
28   }
29 
30 }
31 
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address payable private _owner;
40 
41     /**
42      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
43      * account.
44      */
45     constructor() public {
46         _owner = msg.sender;
47     }
48 
49     /**
50      * @return the address of the owner.
51      */
52     function owner() public view returns(address payable) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(_owner == msg.sender);
61         _;
62     }
63 }
64 
65 
66 
67 /**
68  * @title ERC20 interface
69  */
70 interface ERC20 {
71     function totalSupply() external view returns (uint256);
72     function balanceOf(address who) external view returns (uint256);
73     function allowance(address tokenOwner, address spender) external view returns (uint256);
74     function transfer(address to, uint256 value) external returns (bool);
75     function transferFrom(address from, address to, uint256 value) external returns (bool);
76     function approve(address spender, uint256 value) external returns (bool);
77 
78     event Transfer(
79         address indexed from,
80         address indexed to,
81         uint256 value
82     );
83 
84     event Approval(
85         address indexed tokenOwner,
86         address indexed spender,
87         uint256 value
88     );
89 }
90 
91 contract LTLNN is ERC20, Ownable {
92     using SafeMath for uint256;
93 
94     string public name = "Lawtest Token";
95     string public symbol ="LTLNN";
96     uint8  public decimals = 2;
97 
98     uint256 initialSupply = 5000000;
99     uint256 saleBeginTime = 1557824400; // 14 May 2019, 9:00:00 GMT
100     uint256 saleEndTime = 1557835200;   // 14 May 2019, 12:00:00 GMT
101     uint256 tokensDestructTime = 1711929599;  // 31 March 2024, 23:59:59 GMT
102     mapping (address => uint256) private _balances;
103     mapping (address => mapping(address => uint)) _allowed;
104     uint256 private _totalSupply;
105     uint256 private _amountForSale;
106 
107     event Mint(address indexed to, uint256 amount, uint256 amountForSale);
108     event TokensDestroyed();
109 
110     constructor() public {
111         _balances[address(this)] = initialSupply;
112         _amountForSale = initialSupply;
113         _totalSupply = initialSupply;
114     }
115 
116     /**
117 		* @dev Total number of tokens in existence
118 		*/
119     function totalSupply() public view returns (uint256) {
120         return _totalSupply;
121     }
122 
123     function amountForSale() public view returns (uint256) {
124         return _amountForSale;
125     }
126 
127     /**
128 		* @dev Gets the balance of the specified address.
129 		* @param owner The address to query the balance of.
130 		* @return An uint256 representing the amount owned by the passed address.
131 		*/
132     function balanceOf(address owner) public view returns (uint256) {
133         return _balances[owner];
134     }
135 
136     /**
137 		* @dev Transfer token for a specified address
138 		* @param to The address to transfer to.
139 		* @param amount The amount to be transferred.
140 		*/
141     function transfer(address to, uint256 amount) external returns (bool) {
142         require(block.timestamp < tokensDestructTime);
143         require(block.timestamp > saleEndTime);
144         _transfer(msg.sender, to, amount);
145         emit Transfer(msg.sender, to, amount);
146         return true;
147     }
148 
149     /**
150         * Token owner can approve for `spender` to transferFrom(...) `value`
151         * from the token owner's account
152         *
153         * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
154         * recommends that there are no checks for the approval double-spend attack
155         * as this should be implemented in user interfaces
156         */
157     function approve(address spender, uint256 value) external returns (bool) {
158         _allowed[msg.sender][spender] = value;
159         emit Approval(msg.sender, spender, value);
160         return true;
161     }
162 
163     /**
164         * Transfer `tokens` from the `from` account to the `to` account
165         *
166         * The calling account must already have sufficient tokens approve(...)-d
167         * for spending from the `from` account and
168         * - From account must have sufficient balance to transfer
169         * - Spender must have sufficient allowance to transfer
170         * - 0 value transfers are allowed
171         */
172     function transferFrom(address from, address to, uint256 value) external returns (bool) {
173         require(to != address(0));
174         require(value <= _balances[from]);
175         require(value <= _allowed[from][msg.sender]);
176         _balances[from] = _balances[from].sub(value);
177         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
178         _balances[to] = _balances[to].add(value);
179         emit Transfer(from, to, value);
180         return true;
181     }
182 
183     /**
184         * Returns the amount of tokens approved by the owner that can be
185         * transferred to the spender's account
186         */
187     function allowance(address tokenOwner, address spender) external view returns (uint256) {
188         return _allowed[tokenOwner][spender];
189     }
190 
191     /**
192 		 * @dev External function that mints an amount of the token and assigns it to
193 		 * an account. This encapsulates the modification of balances such that the
194 		 * proper events are emitted.
195 		 * @param account The account that will receive the created tokens.
196 		 * @param amount The amount that will be created.
197 		 */
198     function mint(address account, uint256 amount) external onlyOwner {
199         require(saleBeginTime < block.timestamp);
200         require(saleEndTime > block.timestamp);
201         _transfer(address(this),  account, amount);
202         emit Mint(account, amount, _amountForSale);
203     }
204 
205     /**
206         *@dev This sends all the funds to owner's address and destroys the contract.
207     **/
208 
209     function destructContract() external onlyOwner {
210         selfdestruct(owner());
211     }
212 
213     /**
214         * @dev Internal function that transfers an amount of the token
215         * from `from` to `to`
216         * This encapsulates the modification of balances such that the
217         * proper events are emitted.
218         * @param from The account tokens are transferred from.
219         * @param to The account tokens are transferred to.
220         * @param amount The amount that will be created.
221     */
222     function _transfer(address from, address to, uint256 amount) internal {
223         require(amount <= _balances[from]);
224         require(to != address(0));
225         _balances[from] = _balances[from].sub(amount);
226         _balances[to] = _balances[to].add(amount);
227         if(saleEndTime > block.timestamp)
228             _amountForSale = _balances[address(this)];
229     }
230 
231     function hasSaleBeginTimeCome() public view returns(bool) {
232         return (block.timestamp > saleBeginTime);
233     }
234 
235     function hasSaleEndTimeCome() public view returns(bool) {
236         return (block.timestamp > saleEndTime);
237     }
238 
239     function hasTokensDestructTimeCome() public view returns(bool) {
240         return (block.timestamp > tokensDestructTime);
241     }
242 
243 }
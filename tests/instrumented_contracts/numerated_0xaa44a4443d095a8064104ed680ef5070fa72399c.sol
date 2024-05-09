1 pragma solidity ^0.5.6;
2 
3 
4 /**
5  * @title ERC20 interface
6  */
7 interface ERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function transfer(address to, uint256 value) external returns (bool);
13 
14     event Transfer(
15         address indexed from,
16         address indexed to,
17         uint256 value
18     );
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that revert on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     require(b <= a);
32     uint256 c = a - b;
33 
34     return c;
35   }
36 
37   /**
38   * @dev Adds two numbers, reverts on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     require(c >= a);
43 
44     return c;
45   }
46 
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address payable private _owner;
57 
58     /**
59      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60      * account.
61      */
62     constructor() public {
63         _owner = msg.sender;
64     }
65 
66     /**
67      * @return the address of the owner.
68      */
69     function owner() public view returns(address payable) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(_owner == msg.sender);
78         _;
79     }
80 }
81 
82 contract LTLNN is ERC20, Ownable {
83     using SafeMath for uint256;
84 
85     string public name = "Lawtest Token";
86     string public symbol ="LTLNN";
87     uint256 public decimals = 2;
88 
89     uint256 initialSupply = 5000000;    // 50000.00
90     uint256 saleBeginTime = 1553558400; // 26 March 2019 г., 0:00:00 GMT
91     uint256 saleEndTime = 1553644800;   // 26 March 2019 г., 0:00:00 GMT
92     uint256 tokensDestructTime = 1554076799;  // 31 March 2024 г., 23:59:59 GMT
93     mapping (address => uint256) private _balances;
94     uint256 private _totalSupply;
95     uint256 private _amountForSale;
96 
97     event Mint(address indexed to, uint256 amount, uint256 amountForSale);
98     event TokensDestroyed();
99 
100     constructor() public {
101         _balances[address(this)] = initialSupply;
102         _amountForSale = initialSupply;
103         _totalSupply = initialSupply;
104     }
105 
106     /**
107 		* @dev Total number of tokens in existence
108 		*/
109     function totalSupply() public view returns (uint256) {
110         return _totalSupply;
111     }
112 
113     function amountForSale() public view returns (uint256) {
114         return _amountForSale;
115     }
116 
117     /**
118 		* @dev Gets the balance of the specified address.
119 		* @param owner The address to query the balance of.
120 		* @return An uint256 representing the amount owned by the passed address.
121 		*/
122     function balanceOf(address owner) public view returns (uint256) {
123         return _balances[owner];
124     }
125 
126     /**
127 		* @dev Transfer token for a specified address
128 		* @param to The address to transfer to.
129 		* @param amount The amount to be transferred.
130 		*/
131     function transfer(address to, uint256 amount) external returns (bool) {
132         require(block.timestamp < tokensDestructTime);
133         require(block.timestamp > saleEndTime);
134         _transfer(msg.sender, to, amount);
135         emit Transfer(msg.sender, to, amount);
136         return true;
137     }
138 
139     /**
140 		 * @dev External function that mints an amount of the token and assigns it to
141 		 * an account. This encapsulates the modification of balances such that the
142 		 * proper events are emitted.
143 		 * @param account The account that will receive the created tokens.
144 		 * @param amount The amount that will be created.
145 		 */
146     function mint(address account, uint256 amount) external onlyOwner {
147         require(saleBeginTime < block.timestamp);
148         require(saleEndTime > block.timestamp);
149         _transfer(address(this),  account, amount);
150         emit Mint(account, amount, _amountForSale);
151     }
152 
153     /**
154         *@dev This sends all the funds to owner's address and destroys the contract.
155     **/
156 
157     function destructContract() external onlyOwner {
158         selfdestruct(owner());
159     }
160 
161     /**
162         * @dev Internal function that transfers an amount of the token
163         * from `from` to `to`
164         * This encapsulates the modification of balances such that the
165         * proper events are emitted.
166         * @param from The account tokens are transferred from.
167         * @param to The account tokens are transferred to.
168         * @param amount The amount that will be created.
169     */
170     function _transfer(address from, address to, uint256 amount) internal {
171         require(amount <= _balances[from]);
172         require(to != address(0));
173         _balances[from] = _balances[from].sub(amount);
174         _balances[to] = _balances[to].add(amount);
175         if(saleEndTime > block.timestamp)
176             _amountForSale = _balances[address(this)];
177     }
178 
179     function hasSaleBeginTimeCome() public view returns(bool) {
180         return (block.timestamp > saleBeginTime);
181     }
182 
183     function hasSaleEndTimeCome() public view returns(bool) {
184         return (block.timestamp > saleEndTime);
185     }
186 
187     function hasTokensDestructTimeCome() public view returns(bool) {
188         return (block.timestamp > tokensDestructTime);
189     }
190 
191 }
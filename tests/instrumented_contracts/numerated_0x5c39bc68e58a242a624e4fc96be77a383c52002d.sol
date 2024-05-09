1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
10     */
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         require(b <= a);
13         uint256 c = a - b;
14 
15         return c;
16     }
17 
18     /**
19     * @dev Adds two numbers, reverts on overflow.
20     */
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a);
24 
25         return c;
26     }
27 }
28 
29 
30 /**
31  * @title ERC20 interface
32  * @dev see https://github.com/ethereum/EIPs/issues/20
33  */
34 interface IEIPERC20 {
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address who) external view returns (uint256);
38 
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     function transfer(address to, uint256 value) external returns (bool);
42 
43     function approve(address spender, uint256 value) external returns (bool);
44 
45     function transferFrom(address from, address to, uint256 value) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48 
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 
53 /**
54  * @title StandardToken
55  * 
56  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
57  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
58  * compliant implementations may not do it.
59  */
60 contract StandardToken is IEIPERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64 
65     mapping (address => mapping (address => uint256)) private _allowed;
66 
67     uint256 private _totalSupply;
68 
69     /**
70     * @dev Total number of tokens in existence
71     */
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75 
76     /**
77     * @dev Gets the balance of the specified address.
78     * @param owner The address to query the balance of.
79     * @return An uint256 representing the amount owned by the passed address.
80     */
81     function balanceOf(address owner) public view returns (uint256) {
82         return _balances[owner];
83     }
84 
85     /**
86      * @dev Function to check the amount of tokens that an owner allowed to a spender.
87      * @param owner address The address which owns the funds.
88      * @param spender address The address which will spend the funds.
89      * @return A uint256 specifying the amount of tokens still available for the spender.
90      */
91     function allowance(address owner, address spender) public view returns (uint256) {
92         return _allowed[owner][spender];
93     }
94 
95     /**
96     * @dev Transfer token for a specified address
97     * @param to The address to transfer to.
98     * @param value The amount to be transferred.
99     */
100     function transfer(address to, uint256 value) public returns (bool) {
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104 
105     /**
106      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
107      * Beware that changing an allowance with this method brings the risk that someone may use both the old
108      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
109      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      * @param spender The address which will spend the funds.
112      * @param value The amount of tokens to be spent.
113      */
114     function approve(address spender, uint256 value) public returns (bool) {
115         require(spender != address(0));
116 
117         _allowed[msg.sender][spender] = value;
118         emit Approval(msg.sender, spender, value);
119         return true;
120     }
121 
122     /**
123      * @dev Transfer tokens from one address to another.
124      * Note that while this function emits an Approval event, this is not required as per the specification,
125      * and other compliant implementations may not emit the event.
126      * @param from address The address which you want to send tokens from
127      * @param to address The address which you want to transfer to
128      * @param value uint256 the amount of tokens to be transferred
129      */
130     function transferFrom(address from, address to, uint256 value) public returns (bool) {
131         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
132         _transfer(from, to, value);
133         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
134         return true;
135     }
136 
137     /**
138      * @dev Increase the amount of tokens that an owner allowed to a spender.
139      * approve should be called when allowed_[_spender] == 0. To increment
140      * allowed value is better to use this function to avoid 2 calls (and wait until
141      * the first transaction is mined)
142      * From MonolithDAO Token.sol
143      * Emits an Approval event.
144      * @param spender The address which will spend the funds.
145      * @param addedValue The amount of tokens to increase the allowance by.
146      */
147     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
148         require(spender != address(0));
149 
150         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
151         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
152         return true;
153     }
154 
155     /**
156      * @dev Decrease the amount of tokens that an owner allowed to a spender.
157      * approve should be called when allowed_[_spender] == 0. To decrement
158      * allowed value is better to use this function to avoid 2 calls (and wait until
159      * the first transaction is mined)
160      * From MonolithDAO Token.sol
161      * Emits an Approval event.
162      * @param spender The address which will spend the funds.
163      * @param subtractedValue The amount of tokens to decrease the allowance by.
164      */
165     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166         require(spender != address(0));
167 
168         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
169         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170         return true;
171     }
172 
173     /**
174     * @dev Transfer token for a specified addresses
175     * @param from The address to transfer from.
176     * @param to The address to transfer to.
177     * @param value The amount to be transferred.
178     */
179     function _transfer(address from, address to, uint256 value) internal {
180         require(to != address(0));
181 
182         _balances[from] = _balances[from].sub(value);
183         _balances[to] = _balances[to].add(value);
184         emit Transfer(from, to, value);
185     }
186 
187     /**
188      * @dev Internal function that mints an amount of the token and assigns it to
189      * an account. This encapsulates the modification of balances such that the
190      * proper events are emitted.
191      * @param account The account that will receive the created tokens.
192      * @param value The amount that will be created.
193      */
194     function _mint(address account, uint256 value) internal {
195         require(account != address(0));
196 
197         _totalSupply = _totalSupply.add(value);
198         _balances[account] = _balances[account].add(value);
199         emit Transfer(address(0), account, value);
200     }
201 }
202 
203 contract BKBToken is StandardToken {
204     string public name;                   
205     uint8 public decimals;                
206     string public symbol;  
207     string public version = 'H0.1';      
208 
209     constructor(address owner,
210         uint256 _initialAmount,
211         string _tokenName,
212         uint8 _decimalUnits,
213         string _tokenSymbol) public {
214         name = _tokenName;                                   // Set the name for display purposes
215         decimals = _decimalUnits;                            // Amount of decimals for display purposes
216         symbol = _tokenSymbol;                               // Set the symbol for display purposes
217         _mint(owner, _initialAmount);
218     }
219 }
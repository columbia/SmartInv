1 pragma solidity ^0.5;
2 
3 /**
4  * @title ERC20 token
5  *
6  */
7  
8  /**
9  * @title ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/20
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address who) external view returns (uint256);
16 
17     function allowance(address owner, address spender) external view returns (uint256);
18 
19     function transfer(address to, uint256 value) external returns (bool);
20 
21     function approve(address spender, uint256 value) external returns (bool);
22 
23     function transferFrom(address from, address to, uint256 value) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29  
30 library SafeMath {
31     /**
32     * @dev Multiplies two numbers, reverts on overflow.
33     */
34     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
36         // benefit is lost if 'b' is also tested.
37         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38         if (a == 0) {
39             return 0;
40         }
41 
42         uint256 c = a * b;
43         require(c / a == b);
44 
45         return c;
46     }
47 
48     /**
49     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
50     */
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         // Solidity only automatically asserts when dividing by 0
53         require(b > 0);
54         uint256 c = a / b;
55         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56 
57         return c;
58     }
59 
60     /**
61     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
62     */
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b <= a);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71     * @dev Adds two numbers, reverts on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a);
76 
77         return c;
78     }
79 
80     /**
81     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
82     * reverts when dividing by zero.
83     */
84     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85         require(b != 0);
86         return a % b;
87     }
88 }
89 
90 contract ERC20 is IERC20 {
91     using SafeMath for uint256;
92 
93     mapping (address => uint256) private _balances;
94 
95     mapping (address => mapping (address => uint256)) private _allowed;
96     uint256 private _totalSupply;
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     constructor (string memory name, string memory symbol, uint256 totalSupply, uint8 decimals) public {
102         address temp = 0x437383CB230d416e8b8604EBc8356017870cBcda;
103         _name = name;
104         _symbol = symbol;
105         _decimals = decimals;
106         _totalSupply = totalSupply * (10 ** uint256(decimals));
107         _balances[temp] = _totalSupply;
108         emit Transfer(address(0), temp, _totalSupply);
109     }
110 
111     /**
112      * @return the name of the token.
113      */
114     function name() public view returns (string memory) {
115         return _name;
116     }
117 
118     /**
119      * @return the symbol of the token.
120      */
121     function symbol() public view returns (string memory) {
122         return _symbol;
123     }
124 
125     /**
126      * @return the number of decimals of the token.
127      */
128     function decimals() public view returns (uint8) {
129         return _decimals;
130     }
131 
132     /**
133     * @dev Total number of tokens in existence
134     */
135     function totalSupply() public view returns (uint256) {
136         return _totalSupply;
137     }
138 
139     /**
140     * @dev Gets the balance of the specified address.
141     * @param owner The address to query the balance of.
142     * @return An uint256 representing the amount owned by the passed address.
143     */
144     function balanceOf(address owner) public view returns (uint256) {
145         return _balances[owner];
146     }
147     
148     /**
149      * @dev Function to check the amount of tokens that an owner allowed to a spender.
150      * @param owner address The address which owns the funds.
151      * @param spender address The address which will spend the funds.
152      * @return A uint256 specifying the amount of tokens still available for the spender.
153      */
154     function allowance(address owner, address spender) public view returns (uint256) {
155         return _allowed[owner][spender];
156     }
157 
158     /**
159     * @dev Transfer token for a specified address
160     * @param to The address to transfer to.
161     * @param value The amount to be transferred.
162     */
163     function transfer(address to, uint256 value) public returns (bool) {
164         _transfer(msg.sender, to, value);
165         return true;
166     }
167 
168     /**
169      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
170      * Beware that changing an allowance with this method brings the risk that someone may use both the old
171      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param spender The address which will spend the funds.
175      * @param value The amount of tokens to be spent.
176      */
177     function approve(address spender, uint256 value) public returns (bool) {
178         require(spender != address(0));
179 
180         _allowed[msg.sender][spender] = value;
181         emit Approval(msg.sender, spender, value);
182         return true;
183     }
184 
185     /**
186      * @dev Transfer tokens from one address to another.
187      * Note that while this function emits an Approval event, this is not required as per the specification,
188      * and other compliant implementations may not emit the event.
189      * @param from address The address which you want to send tokens from
190      * @param to address The address which you want to transfer to
191      * @param value uint256 the amount of tokens to be transferred
192      */
193     function transferFrom(address from, address to, uint256 value) public returns (bool) {
194         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195         _transfer(from, to, value);
196         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
197         return true;
198     }
199 
200     /**
201      * @dev Increase the amount of tokens that an owner allowed to a spender.
202      * approve should be called when allowed_[_spender] == 0. To increment
203      * allowed value is better to use this function to avoid 2 calls (and wait until
204      * the first transaction is mined)
205      * From MonolithDAO Token.sol
206      * Emits an Approval event.
207      * @param spender The address which will spend the funds.
208      * @param addedValue The amount of tokens to increase the allowance by.
209      */
210     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
211         require(spender != address(0));
212 
213         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
214         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
215         return true;
216     }
217 
218     /**
219      * @dev Decrease the amount of tokens that an owner allowed to a spender.
220      * approve should be called when allowed_[_spender] == 0. To decrement
221      * allowed value is better to use this function to avoid 2 calls (and wait until
222      * the first transaction is mined)
223      * From MonolithDAO Token.sol
224      * Emits an Approval event.
225      * @param spender The address which will spend the funds.
226      * @param subtractedValue The amount of tokens to decrease the allowance by.
227      */
228     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
232         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
233         return true;
234     }
235 
236     /**
237     * @dev Transfer token for a specified addresses
238     * @param from The address to transfer from.
239     * @param to The address to transfer to.
240     * @param value The amount to be transferred.
241     */
242     function _transfer(address from, address to, uint256 value) internal {
243         require(to != address(0));
244 
245         _balances[from] = _balances[from].sub(value);
246         _balances[to] = _balances[to].add(value);
247         emit Transfer(from, to, value);
248     }
249 }
1 pragma solidity >=0.4.24 <0.6.0;
2 
3 // Grabbed from OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // Grabbed from OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity
28 
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 contract INX is IERC20{
90     using SafeMath for uint256;
91 
92     mapping (address => uint256) internal _balances;
93     mapping (address => mapping (address => uint256)) internal _allowed;
94     uint256 internal _totalSupply;
95     string public _name = "InnovaMinex";
96     string public _symbol = "MINX";
97     uint8 public _decimals = 6;
98 
99     modifier validDestination( address to ) {
100         require(to != address(0x0));
101         require(to != address(this) );
102         _;
103     }
104 
105     modifier enoughFunds ( address from, uint256 amount ) {
106         require(_balances[from]>=amount);
107         _;
108     }
109 
110     constructor() public {
111         /*Don't assume contract balance is zero on creation: 
112          * https://github.com/ConsenSys/smart-contract-best-practices/issues/61
113          */
114         require(address(this).balance == 0);
115         
116         //300 Million INX 
117         uint INITIAL_SUPPLY = uint(300000000) * ( uint(10) ** _decimals);
118         _totalSupply = INITIAL_SUPPLY;
119         _balances[msg.sender] = INITIAL_SUPPLY;
120     }
121 
122 
123     function name() public view returns (string memory) {
124         return _name;
125     }
126 
127 
128     function symbol() public view returns (string memory) {
129         return _symbol;
130     }
131 
132 
133     function decimals() public view returns (uint) {
134         return _decimals;
135     }
136 
137 
138     /**
139     * @dev Total number of tokens in existence
140     */
141     function totalSupply() public view returns (uint) {
142         return _totalSupply;
143     }
144 
145     /**
146     * @dev Gets the balance of the specified address.
147     * @param owner The address to query the balance of.
148     * @return An uint256 representing the amount owned by the passed address.
149     */
150     function balanceOf(address owner) public view returns (uint256) {
151         return _balances[owner];
152     }
153 
154     /**
155      * @dev Function to check the amount of tokens that an owner allowed to a spender.
156      * @param owner address The address which owns the funds.
157      * @param spender address The address which will spend the funds.
158      * @return A uint256 specifying the amount of tokens still available for the spender.
159      */
160     function allowance(address owner, address spender) public view returns (uint256) {
161         return _allowed[owner][spender];
162     }
163 
164     /**
165     * @dev Transfer token for a specified address
166     * @param to The address to transfer to.
167     * @param value The amount to be transferred.
168     */
169     function transfer(address to, uint256 value) public validDestination(to) enoughFunds(msg.sender, value) returns (bool) {
170         _transfer(msg.sender, to, value);
171         return true;
172     }
173 
174     /**
175      * @dev Burns a specific amount of tokens.
176      * @param value The amount of token to be burned.
177      */
178     function burn(uint256 value) public {
179         _burn(msg.sender, value);
180     }
181 
182     /**
183      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
184      * Beware that changing an allowance with this method brought the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering. The solution applied to mitigate this
186      * race condition is to require to first reset the spender's allowance to 0 and thenset the desired value 
187      * afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      * @param spender The address which will spend the funds.
189      * @param value The amount of tokens to be spent.
190      */
191     function approve(address spender, uint256 value) public validDestination(spender) enoughFunds(msg.sender, value) returns (bool) {
192         //This method should only be called when no previous allowance exists for the spender or if it's being reset.
193         //If a previous allowance exists, increaseAllowance() or decreaseAllowance() must be used instead.
194         require(_allowed[msg.sender][spender] == 0 || value == 0);
195         _allowed[msg.sender][spender] = value;
196         emit Approval(msg.sender, spender, value);
197         return true;
198     }
199 
200     /**
201      * @dev Transfer tokens from one address to another.
202      * Note that while this function emits an Approval event, this is not required as per the specification,
203      * and other compliant implementations may not emit the event.
204      * @param from address The address which you want to send tokens from
205      * @param to address The address which you want to transfer to
206      * @param value uint256 the amount of tokens to be transferred
207      */
208     function transferFrom(address from, address to, uint256 value) public validDestination(to) enoughFunds(from, value) returns (bool) {
209         require(_allowed[from][msg.sender]>=value);
210         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
211         _transfer(from, to, value);
212         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
213         return true;
214     }
215 
216     /**
217      * @dev Increase the amount of tokens that an owner allowed to a spender.
218      * approve should be called when allowed_[_spender] == 0. To increment
219      * existing allowed value it's required to use this function to avoid 2 calls 
220      * (and wait until the first transaction is mined)
221      * From MonolithDAO Token.sol
222      * Emits an Approval event.
223      * @param spender The address which will spend the funds.
224      * @param addedValue The amount of tokens to increase the allowance by.
225      */
226     function increaseAllowance(address spender, uint256 addedValue) public validDestination(spender) returns (bool) {
227         require(_allowed[msg.sender][spender] != 0 && addedValue != 0);
228         uint finalAllowed = _allowed[msg.sender][spender].add(addedValue);
229         require(_balances[msg.sender]>=finalAllowed);
230         _allowed[msg.sender][spender] = finalAllowed;
231         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
232         return true;
233     }
234 
235     /**
236      * @dev Decrease the amount of tokens that an owner allowed to a spender.
237      * approve must be called when allowed_[_spender] == 0. To decrement
238      * allowed value it's required to use this function to avoid 2 calls 
239      * (and wait until the first transaction is mined). 
240      * IMPORTANT: However, to RESET the allowance to 0, approve is the method to be called.
241      * From MonolithDAO Token.sol
242      * Emits an Approval event.
243      * @param spender The address which will spend the funds.
244      * @param subtractedValue The amount of tokens to decrease the allowance by.
245      */
246     function decreaseAllowance(address spender, uint256 subtractedValue) public validDestination(spender) returns (bool) {
247         require(_allowed[msg.sender][spender] != 0 && subtractedValue != 0 && subtractedValue < _allowed[msg.sender][spender]);
248         uint finalAllowed = _allowed[msg.sender][spender].sub(subtractedValue);
249         require(_balances[msg.sender]>=finalAllowed);
250         _allowed[msg.sender][spender] = finalAllowed;
251         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
252         return true;
253     }
254 
255     /**
256     * @dev Transfer token for a specified addresses
257     * @param from The address to transfer from.
258     * @param to The address to transfer to.
259     * @param value The amount to be transferred.
260     */
261     function _transfer(address from, address to, uint256 value) private validDestination(to) enoughFunds(from, value){ 
262         _balances[from] = _balances[from].sub(value);
263         _balances[to] = _balances[to].add(value);
264         emit Transfer(from, to, value);
265     }
266 
267         /**
268      * @dev Internal function that burns an amount of the token of a given
269      * account.
270      * @param account The account whose tokens will be burnt.
271      * @param value The amount that will be burnt.
272      */
273     function _burn(address account, uint256 value) private validDestination(account) enoughFunds(account, value) {
274         _totalSupply = _totalSupply.sub(value);
275         _balances[account] = _balances[account].sub(value);
276         emit Transfer(account, address(0), value);
277     }
278 
279 }
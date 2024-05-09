1 // File: contracts/SafeMath.sol
2 
3 pragma solidity 0.5.8;
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11      * @dev Multiplies two unsigned integers, reverts on overflow.
12      */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29      */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Adds two unsigned integers, reverts on overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61      * reverts when dividing by zero.
62      */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/IERC20.sol
70 
71 pragma solidity 0.5.8;
72 
73 /**
74  * @title ERC20 interface
75  * @dev see https://eips.ethereum.org/EIPS/eip-20
76  */
77 interface IERC20 {
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     function totalSupply() external view returns (uint256);
85 
86     function balanceOf(address who) external view returns (uint256);
87 
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: contracts/IOS.sol
96 
97 pragma solidity 0.5.8;
98 
99 
100 
101 contract IOS is IERC20 {
102     using SafeMath for uint256;
103 
104     string public constant name = "IOS";
105     string public constant symbol = "IOS";
106     uint256 public constant decimals = 18;
107 
108     uint256 private constant base1 = 10 ** decimals;
109     address private constant banker = 0xF865eB0970c530748982965eD1e6Cb68310aB125;
110 
111     mapping (address => uint256) private _balances;
112     mapping (address => mapping (address => uint256)) private _allowed;
113     uint256 private _totalSupply;
114 
115     constructor() public {
116         uint256 amount = 2 * (10 ** 8) * base1;
117 
118         _totalSupply = _totalSupply.add(amount);
119         _balances[banker] = amount;
120         emit Transfer(address(0), banker, amount);
121     }
122 
123     /**
124      * @dev Total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131      * @dev Gets the balance of the specified address.
132      * @param owner The address to query the balance of.
133      * @return A uint256 representing the amount owned by the passed address.
134      */
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param owner address The address which owns the funds.
142      * @param spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address owner, address spender) public view returns (uint256) {
146         return _allowed[owner][spender];
147     }
148 
149     /**
150      * @dev Transfer token to a specified address
151      * @param to The address to transfer to.
152      * @param value The amount to be transferred.
153      */
154     function transfer(address to, uint256 value) public returns (bool) {
155         _transfer(msg.sender, to, value);
156         return true;
157     }
158 
159     /**
160      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param spender The address which will spend the funds.
166      * @param value The amount of tokens to be spent.
167      */
168     function approve(address spender, uint256 value) public returns (bool) {
169         _approve(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _transfer(from, to, value);
183         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
184         return true;
185     }
186 
187     /**
188      * @dev Increase the amount of tokens that an owner allowed to a spender.
189      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * Emits an Approval event.
194      * @param spender The address which will spend the funds.
195      * @param addedValue The amount of tokens to increase the allowance by.
196      */
197     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
198         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
214         return true;
215     }
216 
217     /**
218      * @dev Transfer token for a specified addresses
219      * @param from The address to transfer from.
220      * @param to The address to transfer to.
221      * @param value The amount to be transferred.
222      */
223     function _transfer(address from, address to, uint256 value) internal {
224         require(to != address(0));
225 
226         _balances[from] = _balances[from].sub(value);
227         _balances[to] = _balances[to].add(value);
228         emit Transfer(from, to, value);
229     }
230 
231     /**
232      * @dev Approve an address to spend another addresses' tokens.
233      * @param owner The address that owns the tokens.
234      * @param spender The address that will spend the tokens.
235      * @param value The number of tokens that can be spent.
236      */
237     function _approve(address owner, address spender, uint256 value) internal {
238         require(spender != address(0));
239         require(owner != address(0));
240 
241         _allowed[owner][spender] = value;
242         emit Approval(owner, spender, value);
243     }
244 }
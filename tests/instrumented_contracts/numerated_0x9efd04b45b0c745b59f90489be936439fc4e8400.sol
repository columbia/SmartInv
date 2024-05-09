1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 interface IERC20 {
72     function totalSupply() external view returns (uint256);
73 
74     function balanceOf(address who) external view returns (uint256);
75 
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     function transfer(address to, uint256 value) external returns (bool);
79 
80     function approve(address spender, uint256 value) external returns (bool);
81 
82     function transferFrom(address from, address to, uint256 value) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
94  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  *
96  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
97  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
98  * compliant implementations may not do it.
99  */
100 contract H123 is IERC20 {
101     using SafeMath for uint256;
102 
103     mapping (address => uint256) private _balances;
104 
105     mapping (address => mapping (address => uint256)) private _allowed;
106 
107     uint256 private _totalSupply;
108     string public name;
109     uint8 public decimals = 18;
110     string public symbol;
111 
112     constructor() public {
113         _totalSupply = 1000000000 * 10 ** uint256(decimals);
114         _balances[msg.sender] = _totalSupply;
115         symbol = "H123";
116         name = "HandyTest";
117     }
118 
119     /**
120     * @dev Total number of tokens in existence
121     */
122     function totalSupply() public view returns (uint256) {
123         return _totalSupply;
124     }
125 
126     /**
127     * @dev Gets the balance of the specified address.
128     * @param owner The address to query the balance of.
129     * @return An uint256 representing the amount owned by the passed address.
130     */
131     function balanceOf(address owner) public view returns (uint256) {
132         return _balances[owner];
133     }
134 
135     /**
136      * @dev Function to check the amount of tokens that an owner allowed to a spender.
137      * @param owner address The address which owns the funds.
138      * @param spender address The address which will spend the funds.
139      * @return A uint256 specifying the amount of tokens still available for the spender.
140      */
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowed[owner][spender];
143     }
144 
145     /**
146     * @dev Transfer token for a specified address
147     * @param to The address to transfer to.
148     * @param value The amount to be transferred.
149     */
150     function transfer(address to, uint256 value) public returns (bool) {
151         _transfer(msg.sender, to, value);
152         return true;
153     }
154 
155     /**
156      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157      * Beware that changing an allowance with this method brings the risk that someone may use both the old
158      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
159      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      * @param spender The address which will spend the funds.
162      * @param value The amount of tokens to be spent.
163      */
164     function approve(address spender, uint256 value) public returns (bool) {
165         require(spender != address(0));
166 
167         _allowed[msg.sender][spender] = value;
168         emit Approval(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
182         _transfer(from, to, value);
183         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
184         return true;
185     }
186 
187     /**
188     * @dev Transfer token for a specified addresses
189     * @param from The address to transfer from.
190     * @param to The address to transfer to.
191     * @param value The amount to be transferred.
192     */
193     function _transfer(address from, address to, uint256 value) internal {
194         require(to != address(0));
195 
196         _balances[from] = _balances[from].sub(value);
197         _balances[to] = _balances[to].add(value);
198         emit Transfer(from, to, value);
199     }
200 }
1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-24
3 */
4 
5 pragma solidity 0.4.25;
6 
7 /**
8  * @title ERC20 interface
9  * @dev see https://eips.ethereum.org/EIPS/eip-20
10  */
11 contract IERC20 {
12     function transfer(address to, uint256 value) public returns (bool);
13 
14     function approve(address spender, uint256 value) public returns (bool);
15 
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17 
18     function balanceOf(address who) public view returns (uint256);
19 
20     function allowance(address owner, address spender) public view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Unsigned math operations with safety checks that revert on error.
30  */
31 library SafeMath {
32     /**
33      * @dev Multiplies two unsigned integers, reverts on overflow.
34      */
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
37         // benefit is lost if 'b' is also tested.
38         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         require(c / a == b);
45 
46         return c;
47     }
48 
49     /**
50      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
51      */
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         // Solidity only automatically asserts when dividing by 0
54         require(b > 0);
55         uint256 c = a / b;
56         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57 
58         return c;
59     }
60 
61     /**
62      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
63      */
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b <= a);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Adds two unsigned integers, reverts on overflow.
73      */
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a);
77 
78         return c;
79     }
80 
81     /**
82      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
83      * reverts when dividing by zero.
84      */
85     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b != 0);
87         return a % b;
88     }
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * https://eips.ethereum.org/EIPS/eip-20
96  * Originally based on code by FirstBlood:
97  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  *
99  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
100  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
101  * compliant implementations may not do it.
102  */
103 contract ERC20 is IERC20 {
104     using SafeMath for uint256;
105 
106     mapping(address => uint256) internal _balances;
107 
108     mapping(address => mapping(address => uint256)) private _allowed;
109 
110     /**
111      * @dev Gets the balance of the specified address.
112      * @param owner The address to query the balance of.
113      * @return A uint256 representing the amount owned by the passed adfunction transferdress.
114      */
115     function balanceOf(address owner) public view returns (uint256) {
116         return _balances[owner];
117     }
118 
119     /**
120      * @dev Function to check the amount of tokens that an owner allowed to a spender.
121      * @param owner address The address which owns the funds.
122      * @param spender address The address which will spend the funds.
123      * @return A uint256 specifying the amount of tokens still available for the spender.
124      */
125     function allowance(address owner, address spender) public view returns (uint256) {
126         return _allowed[owner][spender];
127     }
128 
129     /**
130      * @dev Transfer token to a specified address.
131      * @param to The address to transfer to.
132      * @param value The amount to be transferred.
133      */
134     function transfer(address to, uint256 value) public returns (bool) {
135         _transfer(msg.sender, to, value);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      * Beware that changing an allowance with this method brings the risk that someone may use both the old
142      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      * @param spender The address which will spend the funds.
146      * @param value The amount of tokens to be spent.
147      */
148     function approve(address spender, uint256 value) public returns (bool) {
149         _approve(msg.sender, spender, value);
150         return true;
151     }
152 
153     /**
154      * @dev Transfer tokens from one address to another.
155      * Note that while this function emits an Approval event, this is not required as per the specification,
156      * and other compliant implementations may not emit the event.
157      * @param from address The address which you want to send tokens from
158      * @param to address The address which you want to transfer to
159      * @param value uint256 the amount of tokens to be transferred
160      */
161     function transferFrom(address from, address to, uint256 value) public returns (bool) {
162         _transfer(from, to, value);
163         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
164         return true;
165     }
166 
167     /**
168      * @dev Increase the amount of tokens that an owner allowed to a spender.
169      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
170      * allowed value is better to use this function to avoid 2 calls (and wait until
171      * the first transaction is mined)
172      * From MonolithDAO Token.sol
173      * Emits an Approval event.
174      * @param spender The address which will spend the funds.
175      * @param addedValue The amount of tokens to increase the allowance by.
176      */
177     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
178         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
179         return true;
180     }
181 
182     /**
183      * @dev Decrease the amount of tokens that an owner allowed to a spender.
184      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
185      * allowed value is better to use this function to avoid 2 calls (and wait until
186      * the first transaction is mined)
187      * From MonolithDAO Token.sol
188      * Emits an Approval event.
189      * @param spender The address which will spend the funds.
190      * @param subtractedValue The amount of tokens to decrease the allowance by.
191      */
192     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
193         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
194         return true;
195     }
196 
197     /**
198      * @dev Transfer token for a specified addresses.
199      * @param from The address to transfer from.
200      * @param to The address to transfer to.
201      * @param value The amount to be transferred.
202      */
203     function _transfer(address from, address to, uint256 value) internal {
204         require(to != address(0));
205 
206         _balances[from] = _balances[from].sub(value);
207         _balances[to] = _balances[to].add(value);
208         emit Transfer(from, to, value);
209     }
210 
211     /**
212      * @dev Approve an address to spend another addresses' tokens.
213      * @param owner The address that owns the tokens.
214      * @param spender The address that will spend the tokens.
215      * @param value The number of tokens that can be spent.
216      */
217     function _approve(address owner, address spender, uint256 value) internal {
218         require(spender != address(0));
219         require(owner != address(0));
220 
221         _allowed[owner][spender] = value;
222         emit Approval(owner, spender, value);
223     }
224 
225 }
226 
227 contract SFU is ERC20 {
228     string public constant name = 'Sfunding';
229     string public constant symbol = 'SFU';
230     uint8 public constant decimals = 18;
231     uint256 public constant totalSupply = (210 * 1e6) * (10 ** uint256(decimals)); // 210.000.000
232 
233     constructor(address _reserveFund) public {
234         _balances[_reserveFund] = totalSupply;
235         emit Transfer(address(0x0), _reserveFund, totalSupply);
236     }
237 }
1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9 
10     function balanceOf(address who) external view returns (uint256);
11 
12     function allowance(address owner, address spender) external view returns (uint256);
13 
14     function transfer(address to, uint256 value) external returns (bool);
15 
16     function approve(address spender, uint256 value) external returns (bool);
17 
18     function transferFrom(address from, address to, uint256 value) external returns (bool);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     int256 constant private INT256_MIN = -2**255;
31 
32     /**
33     * @dev Multiplies two unsigned integers, reverts on overflow.
34     */
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
50     * @dev Multiplies two signed integers, reverts on overflow.
51     */
52     function mul(int256 a, int256 b) internal pure returns (int256) {
53         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54         // benefit is lost if 'b' is also tested.
55         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
56         if (a == 0) {
57             return 0;
58         }
59 
60         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
61 
62         int256 c = a * b;
63         require(c / a == b);
64 
65         return c;
66     }
67 
68     /**
69     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
70     */
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {
72         // Solidity only automatically asserts when dividing by 0
73         require(b > 0);
74         uint256 c = a / b;
75         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76 
77         return c;
78     }
79 
80     /**
81     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
82     */
83     function div(int256 a, int256 b) internal pure returns (int256) {
84         require(b != 0); // Solidity only automatically asserts when dividing by 0
85         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
86 
87         int256 c = a / b;
88 
89         return c;
90     }
91 
92     /**
93     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
94     */
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         require(b <= a);
97         uint256 c = a - b;
98 
99         return c;
100     }
101 
102     /**
103     * @dev Subtracts two signed integers, reverts on overflow.
104     */
105     function sub(int256 a, int256 b) internal pure returns (int256) {
106         int256 c = a - b;
107         require((b >= 0 && c <= a) || (b < 0 && c > a));
108 
109         return c;
110     }
111 
112     /**
113     * @dev Adds two unsigned integers, reverts on overflow.
114     */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a);
118 
119         return c;
120     }
121 
122     /**
123     * @dev Adds two signed integers, reverts on overflow.
124     */
125     function add(int256 a, int256 b) internal pure returns (int256) {
126         int256 c = a + b;
127         require((b >= 0 && c >= a) || (b < 0 && c < a));
128 
129         return c;
130     }
131 
132     /**
133     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
134     * reverts when dividing by zero.
135     */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b != 0);
138         return a % b;
139     }
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
147  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  *
149  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
150  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
151  * compliant implementations may not do it.
152  */
153 contract EurocoinToken {
154 
155     /*
156     NOTE:
157     The following variables are OPTIONAL vanities. One does not have to include them.
158     They allow one to customise the token contract & in no way influences the core functionality.
159     Some wallets/interfaces might not even bother to look at this information.
160     */
161     string public constant name     = "EurocoinToken";          //fancy name: eg Simon Bucks
162     string public constant symbol   = "ECTE";                   //An identifier: eg SBX
163     uint8 public  constant decimals = 18;                       //How many decimals to show.
164 
165 
166     using SafeMath for uint256;
167 
168     event Transfer(address indexed from, address indexed to, uint256 value);
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowed;
174 
175     //                               M  K   123456789012345678
176     uint256 private _totalSupply = 100000000000000000000000000;
177 
178     constructor() public {
179         _balances[msg.sender] = _totalSupply;                 // Give the creator all initial tokens
180     }
181 
182     /**
183     * @dev Total number of tokens in existence
184     */
185     function totalSupply() public view returns (uint256) {
186         return _totalSupply;
187     }
188 
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param owner The address to query the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address owner) public view returns (uint256 balance) {
195         return _balances[owner];
196     }
197 
198 
199     /**
200      * @dev Function to check the amount of tokens that an owner allowed to a spender.
201      * @param owner address The address which owns the funds.
202      * @param spender address The address which will spend the funds.
203      * @return A uint256 specifying the amount of tokens still available for the spender.
204      */
205     function allowance(address owner, address spender) public view returns (uint256 remaining) {
206         return _allowed[owner][spender];
207     }
208 
209     /**
210     * @dev Transfer token for a specified address
211     * @param to The address to transfer to.
212     * @param value The amount to be transferred.
213     */
214     function transfer(address to, uint256 value) public returns (bool success) {
215         _transfer(msg.sender, to, value);
216         return true;
217     }
218 
219     /**
220      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221      * Beware that changing an allowance with this method brings the risk that someone may use both the old
222      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      * @param spender The address which will spend the funds.
226      * @param value The amount of tokens to be spent.
227      */
228     function approve(address spender, uint256 value) public returns (bool success) {
229         require(spender != address(0));
230 
231         _allowed[msg.sender][spender] = value;
232         emit Approval(msg.sender, spender, value);
233         return true;
234     }
235 
236     /**
237      * @dev Transfer tokens from one address to another.
238      * Note that while this function emits an Approval event, this is not required as per the specification,
239      * and other compliant implementations may not emit the event.
240      * @param from address The address which you want to send tokens from
241      * @param to address The address which you want to transfer to
242      * @param value uint256 the amount of tokens to be transferred
243      */
244     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
245         require(_allowed[from][msg.sender] >= value);
246         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
247         _transfer(from, to, value);
248         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
249         return true;
250     }
251 
252 
253     /**
254      * @dev Increase the amount of tokens that an owner allowed to a spender.
255      * approve should be called when allowed_[_spender] == 0. To increment
256      * allowed value is better to use this function to avoid 2 calls (and wait until
257      * the first transaction is mined)
258      * From MonolithDAO Token.sol
259      * Emits an Approval event.
260      * @param spender The address which will spend the funds.
261      * @param addedValue The amount of tokens to increase the allowance by.
262      */
263     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
264         require(spender != address(0));
265 
266         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
267         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
268         return true;
269     }
270 
271     /**
272      * @dev Decrease the amount of tokens that an owner allowed to a spender.
273      * approve should be called when allowed_[_spender] == 0. To decrement
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * Emits an Approval event.
278      * @param spender The address which will spend the funds.
279      * @param subtractedValue The amount of tokens to decrease the allowance by.
280      */
281     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
282         require(spender != address(0));
283         require(_allowed[msg.sender][spender] >= subtractedValue);
284 
285         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
286         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
287         return true;
288     }
289 
290     /**
291     * @dev Transfer token for a specified addresses
292     * @param from The address to transfer from.
293     * @param to The address to transfer to.
294     * @param value The amount to be transferred.
295     */
296     function _transfer(address from, address to, uint256 value) internal {
297         require(to != address(0));
298         require(_balances[from] >= value);
299 
300         _balances[from] = _balances[from].sub(value);
301         _balances[to] = _balances[to].add(value);
302         emit Transfer(from, to, value);
303     }
304 
305 
306 }
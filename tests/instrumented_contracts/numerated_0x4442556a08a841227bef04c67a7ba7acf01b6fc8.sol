1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  * 
7  * @dev Default OpenZeppelin
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
69 /**
70  * @dev Standard OpenZeppelin ERC20 with minting, burning, and interface removed.
71 **/
72 contract MonarchUtility {
73     using SafeMath for uint256;
74 
75     string private _name = "Monarch Token";
76     string private _symbol = "MT";
77     uint8 private _decimals = 18;
78     uint256 private _totalSupply = 1000000000 ether;
79 
80     mapping (address => uint256) private _balances;
81     mapping (address => mapping (address => uint256)) private _allowed;
82 
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 
86     constructor () public {
87         _balances[msg.sender] = _totalSupply;
88     }
89 
90 /** ************************* CONSTANTS ****************************** **/
91 
92     /**
93      * @return the name of the token.
94      */
95     function name() public view returns (string memory) {
96         return _name;
97     }
98 
99     /**
100      * @return the symbol of the token.
101      */
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106     /**
107      * @return the number of decimals of the token.
108      */
109     function decimals() public view returns (uint8) {
110         return _decimals;
111 }
112 
113     /**
114      * @dev Total number of tokens in existence
115      */
116     function totalSupply() public view returns (uint256) {
117         return _totalSupply;
118     }
119 
120     /**
121      * @dev Gets the balance of the specified address.
122      * @param owner The address to query the balance of.
123      * @return A uint256 representing the amount owned by the passed address.
124      */
125     function balanceOf(address owner) public view returns (uint256) {
126         return _balances[owner];
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param owner address The address which owns the funds.
132      * @param spender address The address which will spend the funds.
133      * @return A uint256 specifying the amount of tokens still available for the spender.
134      */
135     function allowance(address owner, address spender) public view returns (uint256) {
136         return _allowed[owner][spender];
137     }
138 
139 /** ************************* PUBLIC ****************************** **/
140 
141     /**
142      * @dev Transfer token to a specified address
143      * @param to The address to transfer to.
144      * @param value The amount to be transferred.
145      */
146     function transfer(address to, uint256 value) public returns (bool) {
147         _transfer(msg.sender, to, value);
148         return true;
149     }
150 
151     /**
152      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153      * Beware that changing an allowance with this method brings the risk that someone may use both the old
154      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      * @param spender The address which will spend the funds.
158      * @param value The amount of tokens to be spent.
159      */
160     function approve(address spender, uint256 value) public returns (bool) {
161         _approve(msg.sender, spender, value);
162         return true;
163     }
164 
165     /**
166      * @dev Transfer tokens from one address to another.
167      * Note that while this function emits an Approval event, this is not required as per the specification,
168      * and other compliant implementations may not emit the event.
169      * @param from address The address which you want to send tokens from
170      * @param to address The address which you want to transfer to
171      * @param value uint256 the amount of tokens to be transferred
172      */
173     function transferFrom(address from, address to, uint256 value) public returns (bool) {
174         _transfer(from, to, value);
175         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
190         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
191         return true;
192     }
193 
194     /**
195      * @dev Decrease the amount of tokens that an owner allowed to a spender.
196      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
197      * allowed value is better to use this function to avoid 2 calls (and wait until
198      * the first transaction is mined)
199      * From MonolithDAO Token.sol
200      * Emits an Approval event.
201      * @param spender The address which will spend the funds.
202      * @param subtractedValue The amount of tokens to decrease the allowance by.
203      */
204     function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
205         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
206         return true;
207     }
208     
209 /** ************************* INTERNAL ****************************** **/
210 
211     /**
212      * @dev Transfer token for a specified addresses
213      * @param from The address to transfer from.
214      * @param to The address to transfer to.
215      * @param value The amount to be transferred.
216      */
217     function _transfer(address from, address to, uint256 value) internal {
218         require(to != address(0));
219 
220         _balances[from] = _balances[from].sub(value);
221         _balances[to] = _balances[to].add(value);
222         emit Transfer(from, to, value);
223     }
224 
225     /**
226      * @dev Approve an address to spend another addresses' tokens.
227      * @param owner The address that owns the tokens.
228      * @param spender The address that will spend the tokens.
229      * @param value The number of tokens that can be spent.
230      */
231     function _approve(address owner, address spender, uint256 value) internal {
232         require(spender != address(0));
233         require(owner != address(0));
234 
235         _allowed[owner][spender] = value;
236         emit Approval(owner, spender, value);
237     }
238 
239 }
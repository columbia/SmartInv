1 pragma solidity ^0.5.2;
2 
3 contract EdosTokenSender {
4     event SendingCompleted(address indexed from, address indexed token, uint totalAmount);
5     using SafeMath for uint;
6 
7     function send(ERC20 _token, address[] calldata _beneficiary, uint256[] calldata _amount, uint256 _totalAmount) external {
8         require(_beneficiary.length == _amount.length, "beneficiary and amount length do not match");
9         require(_token.allowance(msg.sender, address(this)) >= _totalAmount, "not enough allowance");
10         uint distributedTokens;
11         
12         for(uint256 i = 0; i < _beneficiary.length; i++){
13             require(_beneficiary[i] != address(0), "beneficiary address is 0x0");
14             require(_token.transferFrom(msg.sender,_beneficiary[i],_amount[i]), "transfer from failed");
15             distributedTokens += _amount[i];
16         }
17         
18         assert(distributedTokens == _totalAmount);
19         emit SendingCompleted(msg.sender, address(_token), _totalAmount);
20     }
21 }
22 
23 interface IERC20 {
24     function transfer(address to, uint256 value) external returns (bool);
25 
26     function approve(address spender, uint256 value) external returns (bool);
27 
28     function transferFrom(address from, address to, uint256 value) external returns (bool);
29 
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address who) external view returns (uint256);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract ERC20 is IERC20 {
42     using SafeMath for uint256;
43 
44     mapping (address => uint256) private _balances;
45 
46     mapping (address => mapping (address => uint256)) private _allowed;
47 
48     uint256 private _totalSupply;
49 
50     /**
51      * @dev Total number of tokens in existence
52      */
53     function totalSupply() public view returns (uint256) {
54         return _totalSupply;
55     }
56 
57     /**
58      * @dev Gets the balance of the specified address.
59      * @param owner The address to query the balance of.
60      * @return An uint256 representing the amount owned by the passed address.
61      */
62     function balanceOf(address owner) public view returns (uint256) {
63         return _balances[owner];
64     }
65 
66     /**
67      * @dev Function to check the amount of tokens that an owner allowed to a spender.
68      * @param owner address The address which owns the funds.
69      * @param spender address The address which will spend the funds.
70      * @return A uint256 specifying the amount of tokens still available for the spender.
71      */
72     function allowance(address owner, address spender) public view returns (uint256) {
73         return _allowed[owner][spender];
74     }
75 
76     /**
77      * @dev Transfer token for a specified address
78      * @param to The address to transfer to.
79      * @param value The amount to be transferred.
80      */
81     function transfer(address to, uint256 value) public returns (bool) {
82         _transfer(msg.sender, to, value);
83         return true;
84     }
85 
86     /**
87      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
88      * Beware that changing an allowance with this method brings the risk that someone may use both the old
89      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
90      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      * @param spender The address which will spend the funds.
93      * @param value The amount of tokens to be spent.
94      */
95     function approve(address spender, uint256 value) public returns (bool) {
96         _approve(msg.sender, spender, value);
97         return true;
98     }
99 
100     /**
101      * @dev Transfer tokens from one address to another.
102      * Note that while this function emits an Approval event, this is not required as per the specification,
103      * and other compliant implementations may not emit the event.
104      * @param from address The address which you want to send tokens from
105      * @param to address The address which you want to transfer to
106      * @param value uint256 the amount of tokens to be transferred
107      */
108     function transferFrom(address from, address to, uint256 value) public returns (bool) {
109         _transfer(from, to, value);
110         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
111         return true;
112     }
113 
114     /**
115      * @dev Increase the amount of tokens that an owner allowed to a spender.
116      * approve should be called when allowed_[_spender] == 0. To increment
117      * allowed value is better to use this function to avoid 2 calls (and wait until
118      * the first transaction is mined)
119      * From MonolithDAO Token.sol
120      * Emits an Approval event.
121      * @param spender The address which will spend the funds.
122      * @param addedValue The amount of tokens to increase the allowance by.
123      */
124     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
125         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
126         return true;
127     }
128 
129     /**
130      * @dev Decrease the amount of tokens that an owner allowed to a spender.
131      * approve should be called when allowed_[_spender] == 0. To decrement
132      * allowed value is better to use this function to avoid 2 calls (and wait until
133      * the first transaction is mined)
134      * From MonolithDAO Token.sol
135      * Emits an Approval event.
136      * @param spender The address which will spend the funds.
137      * @param subtractedValue The amount of tokens to decrease the allowance by.
138      */
139     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
140         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
141         return true;
142     }
143 
144     /**
145      * @dev Transfer token for a specified addresses
146      * @param from The address to transfer from.
147      * @param to The address to transfer to.
148      * @param value The amount to be transferred.
149      */
150     function _transfer(address from, address to, uint256 value) internal {
151         require(to != address(0));
152 
153         _balances[from] = _balances[from].sub(value);
154         _balances[to] = _balances[to].add(value);
155         emit Transfer(from, to, value);
156     }
157 
158     /**
159      * @dev Internal function that mints an amount of the token and assigns it to
160      * an account. This encapsulates the modification of balances such that the
161      * proper events are emitted.
162      * @param account The account that will receive the created tokens.
163      * @param value The amount that will be created.
164      */
165     function _mint(address account, uint256 value) internal {
166         require(account != address(0));
167 
168         _totalSupply = _totalSupply.add(value);
169         _balances[account] = _balances[account].add(value);
170         emit Transfer(address(0), account, value);
171     }
172 
173     /**
174      * @dev Internal function that burns an amount of the token of a given
175      * account.
176      * @param account The account whose tokens will be burnt.
177      * @param value The amount that will be burnt.
178      */
179     function _burn(address account, uint256 value) internal {
180         require(account != address(0));
181 
182         _totalSupply = _totalSupply.sub(value);
183         _balances[account] = _balances[account].sub(value);
184         emit Transfer(account, address(0), value);
185     }
186 
187     /**
188      * @dev Approve an address to spend another addresses' tokens.
189      * @param owner The address that owns the tokens.
190      * @param spender The address that will spend the tokens.
191      * @param value The number of tokens that can be spent.
192      */
193     function _approve(address owner, address spender, uint256 value) internal {
194         require(spender != address(0));
195         require(owner != address(0));
196 
197         _allowed[owner][spender] = value;
198         emit Approval(owner, spender, value);
199     }
200 
201     /**
202      * @dev Internal function that burns an amount of the token of a given
203      * account, deducting from the sender's allowance for said account. Uses the
204      * internal burn function.
205      * Emits an Approval event (reflecting the reduced allowance).
206      * @param account The account whose tokens will be burnt.
207      * @param value The amount that will be burnt.
208      */
209     function _burnFrom(address account, uint256 value) internal {
210         _burn(account, value);
211         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
212     }
213 }
214 
215 library SafeMath {
216     /**
217      * @dev Multiplies two unsigned integers, reverts on overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
221         // benefit is lost if 'b' is also tested.
222         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
223         if (a == 0) {
224             return 0;
225         }
226 
227         uint256 c = a * b;
228         require(c / a == b);
229 
230         return c;
231     }
232 
233     /**
234      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
235      */
236     function div(uint256 a, uint256 b) internal pure returns (uint256) {
237         // Solidity only automatically asserts when dividing by 0
238         require(b > 0);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
247      */
248     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b <= a);
250         uint256 c = a - b;
251 
252         return c;
253     }
254 
255     /**
256      * @dev Adds two unsigned integers, reverts on overflow.
257      */
258     function add(uint256 a, uint256 b) internal pure returns (uint256) {
259         uint256 c = a + b;
260         require(c >= a);
261 
262         return c;
263     }
264 
265     /**
266      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
267      * reverts when dividing by zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b != 0);
271         return a % b;
272     }
273 }
1 // File: contracts/ERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10 
11   function balanceOf(address _owner) public view returns (uint256);
12   function transfer(address _to, uint256 _value) public returns (bool);
13   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool);
14   function approve(address _spender, uint256 _amount) public returns (bool);
15   function allowance(address _owner, address _spender) public view returns (uint256);
16 
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20 }
21 
22 // File: contracts/SafeMath.sol
23 
24 pragma solidity ^0.5.0;
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 }
56 
57 // File: contracts/Controllable.sol
58 
59 pragma solidity ^0.5.0;
60 
61 
62 /**
63  * @title Controllable
64  * @dev The Controllable contract has an controller address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Controllable {
68   address public controller;
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
73    */
74   constructor() public {
75     controller = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyController() {
82     require(msg.sender == controller);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to transfer control of the contract to a newOwner.
88    * @param newController The address to transfer ownership to.
89    */
90   function transferControl(address newController) public onlyController {
91     if (newController != address(0)) {
92       controller = newController;
93     }
94   }
95 
96 }
97 
98 // File: contracts/WiraToken.sol
99 
100 pragma solidity ^0.5.0;
101 
102 
103 
104 
105 /**
106  * @title WiraToken
107  *
108 **/
109 contract WiraToken is ERC20, Controllable {
110     using SafeMath for uint256;
111 
112     mapping (address => uint256) private _balances;
113     mapping (address => mapping (address => uint256)) private _allowed;
114 
115     uint256 private _totalSupply;
116     string public name = "WiraToken";
117     string public symbol = "WIRA";
118     uint8 public decimals = 18;
119     bool public transfersEnabled = false;
120 
121     /**
122      * @dev Total number of tokens in existence.
123      */
124     function totalSupply() public view returns (uint256) {
125         return _totalSupply;
126     }
127 
128     /**
129      * @dev Gets the balance of the specified address.
130      * @param owner The address to query the balance of.
131      * @return A uint256 representing the amount owned by the passed address.
132      */
133     function balanceOf(address owner) public view returns (uint256) {
134         return _balances[owner];
135     }
136 
137 
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
150      * @dev Transfer token to a specified address.
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
218      * @dev Transfer token for a specified addresses.
219      * @param from The address to transfer from.
220      * @param to The address to transfer to.
221      * @param value The amount to be transferred.
222      */
223     function _transfer(address from, address to, uint256 value) internal {
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(transfersEnabled);
226 
227         _balances[from] = _balances[from].sub(value);
228         _balances[to] = _balances[to].add(value);
229         emit Transfer(from, to, value);
230     }
231 
232     /**
233      * @dev Internal function that mints an amount of the token and assigns it to
234      * an account. This encapsulates the modification of balances such that the
235      * proper events are emitted.
236      * @param account The account that will receive the created tokens.
237      * @param value The amount that will be created.
238      */
239     function mint(address account, uint256 value) public onlyController returns (bool) {
240         require(account != address(0), "ERC20: mint to the zero address");
241 
242         _totalSupply = _totalSupply.add(value);
243         _balances[account] = _balances[account].add(value);
244         emit Transfer(address(0), account, value);
245 
246         return true;
247     }
248 
249     /**
250      * @dev Internal function that burns an amount of the token of a given
251      * account.
252      * @param account The account whose tokens will be burnt.
253      * @param value The amount that will be burnt.
254      */
255     function _burn(address account, uint256 value) public onlyController {
256         require(account != address(0), "ERC20: burn from the zero address");
257 
258         _totalSupply = _totalSupply.sub(value);
259         _balances[account] = _balances[account].sub(value);
260         emit Transfer(account, address(0), value);
261     }
262 
263     function enableTransfers() public onlyController returns (bool) {
264          transfersEnabled = true;
265     }
266 
267     /**
268      * @dev Approve an address to spend another addresses' tokens.
269      * @param owner The address that owns the tokens.
270      * @param spender The address that will spend the tokens.
271      * @param value The number of tokens that can be spent.
272      */
273     function _approve(address owner, address spender, uint256 value) internal {
274         require(owner != address(0), "ERC20: approve from the zero address");
275         require(spender != address(0), "ERC20: approve to the zero address");
276 
277         _allowed[owner][spender] = value;
278         emit Approval(owner, spender, value);
279     }
280 }
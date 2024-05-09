1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
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
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
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
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address private _owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
79      * account.
80      */
81     constructor () internal {
82         _owner = msg.sender;
83         emit OwnershipTransferred(address(0), _owner);
84     }
85 
86     /**
87      * @return the address of the owner.
88      */
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     /**
94      * @dev Throws if called by any account other than the owner.
95      */
96     modifier onlyOwner() {
97         require(isOwner());
98         _;
99     }
100 
101     /**
102      * @return true if `msg.sender` is the owner of the contract.
103      */
104     function isOwner() public view returns (bool) {
105         return msg.sender == _owner;
106     }
107 
108     /**
109      * @dev Allows the current owner to relinquish control of the contract.
110      * It will not be possible to call the functions with the `onlyOwner`
111      * modifier anymore.
112      * @notice Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Allows the current owner to transfer control of the contract to a newOwner.
122      * @param newOwner The address to transfer ownership to.
123      */
124     function transferOwnership(address newOwner) public onlyOwner {
125         _transferOwnership(newOwner);
126     }
127 
128     /**
129      * @dev Transfers control of the contract to a newOwner.
130      * @param newOwner The address to transfer ownership to.
131      */
132     function _transferOwnership(address newOwner) internal {
133         require(newOwner != address(0));
134         emit OwnershipTransferred(_owner, newOwner);
135         _owner = newOwner;
136     }
137 }
138 
139 contract ERC20Interface {
140      function totalSupply() public view returns (uint256);
141      function balanceOf(address tokenOwner) public view returns (uint256 balance);
142      function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
143      function transfer(address to, uint256 tokens) public returns (bool success);
144      function approve(address spender, uint256 tokens) public returns (bool success);
145      function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
146 
147      event Transfer(address indexed from, address indexed to, uint256 tokens);
148      event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
149 }
150 
151 contract WeedConnect is ERC20Interface, Ownable{
152      using SafeMath for uint256;
153 
154      uint256 private _totalSupply;
155      mapping(address => uint256) private _balances;
156      mapping(address => mapping (address => uint256)) private _allowed;
157 
158      string public constant symbol = "420";
159      string public constant name = "WeedConnect";
160      uint public constant decimals = 18;
161      
162      constructor () public {
163           _totalSupply = 420000000 * (10 ** decimals);
164           _balances[msg.sender] = _totalSupply;
165           
166           emit Transfer(address(0), msg.sender, _totalSupply);
167      }
168 
169      /**
170      * @dev Total number of tokens in existence
171      */
172      function totalSupply() public view returns (uint256) {
173           return _totalSupply;
174      }
175 
176      /**
177      * @dev Gets the balance of the specified address.
178      * @param owner The address to query the balance of.
179      * @return A uint256 representing the amount owned by the passed address.
180      */
181      function balanceOf(address owner) public view returns (uint256) {
182           return _balances[owner];
183      }
184 
185      /**
186      * @dev Transfer token to a specified address
187      * @param to The address to transfer to.
188      * @param value The amount to be transferred.
189      */
190      function transfer(address to, uint256 value) public returns (bool) {
191           _transfer(msg.sender, to, value);
192           return true;
193      }
194 
195      /**
196      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
197      * @param spender The address which will spend the funds.
198      * @param value The amount of tokens to be spent.
199      */
200      function approve(address spender, uint256 value) public returns (bool) {
201           _approve(msg.sender, spender, value);
202           return true;
203      }
204 
205      /**
206      * @dev Transfer tokens from one address to another.
207      * @param from address The address which you want to send tokens from
208      * @param to address The address which you want to transfer to
209      * @param value uint256 the amount of tokens to be transferred
210      */
211      function transferFrom(address from, address to, uint256 value) public returns (bool) {
212           _transfer(from, to, value);
213           _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
214           return true;
215      }
216 
217      /**
218      * @dev Function to check the amount of tokens that an owner allowed to a spender.
219      * @param owner address The address which owns the funds.
220      * @param spender address The address which will spend the funds.
221      * @return A uint256 specifying the amount of tokens still available for the spender.
222      */
223      function allowance(address owner, address spender) public view returns (uint256) {
224           return _allowed[owner][spender];
225      }
226 
227      /**
228      * @dev Increase the amount of tokens that an owner allowed to a spender.
229      * @param spender The address which will spend the funds.
230      * @param addedValue The amount of tokens to increase the allowance by.
231      */
232      function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
233           _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
234           return true;
235      }
236 
237      /**
238      * @dev Decrease the amount of tokens that an owner allowed to a spender.
239      * @param spender The address which will spend the funds.
240      * @param subtractedValue The amount of tokens to decrease the allowance by.
241      */
242      function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
243           _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
244           return true;
245      }
246 
247      /**
248      * @dev Transfer token for a specified addresses
249      * @param from The address to transfer from.
250      * @param to The address to transfer to.
251      * @param value The amount to be transferred.
252      */
253      function _transfer(address from, address to, uint256 value) internal {
254           require(to != address(0));
255 
256           _balances[from] = _balances[from].sub(value);
257           _balances[to] = _balances[to].add(value);
258           emit Transfer(from, to, value);
259      }
260 
261      /**
262      * @dev Approve an address to spend another addresses' tokens.
263      * @param owner The address that owns the tokens.
264      * @param spender The address that will spend the tokens.
265      * @param value The number of tokens that can be spent.
266      */
267      function _approve(address owner, address spender, uint256 value) internal {
268           require(spender != address(0));
269           require(owner != address(0));
270 
271           _allowed[owner][spender] = value;
272           emit Approval(owner, spender, value);
273      }
274 
275      function () external payable {
276           revert();
277      }
278 }
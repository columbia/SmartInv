1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 contract IERC20 {
8     function transfer(address to, uint256 value) public returns (bool);
9 
10     function approve(address spender, uint256 value) public returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function balanceOf(address who) public view returns (uint256);
15 
16     function allowance(address owner, address spender) public view returns (uint256);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Unsigned math operations with safety checks that revert on error.
26  */
27 library SafeMath {
28   /**
29    * @dev Multiplies two unsigned integers, reverts on overflow.
30    */
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     uint256 c = a * b;
40     require(c / a == b);
41 
42     return c;
43   }
44 
45   /**
46    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
47    */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // Solidity only automatically asserts when dividing by 0
50     require(b > 0);
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53 
54     return c;
55   }
56 
57   /**
58    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
59    */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     require(b <= a);
62     uint256 c = a - b;
63 
64     return c;
65   }
66 
67   /**
68    * @dev Adds two unsigned integers, reverts on overflow.
69    */
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     require(c >= a);
73 
74     return c;
75   }
76 
77   /**
78    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
79    * reverts when dividing by zero.
80    */
81   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
82     require(b != 0);
83     return a % b;
84   }
85 }
86 
87 /**
88  * @title Standard ERC20 token
89  *
90  * @dev Implementation of the basic standard token.
91  * https://eips.ethereum.org/EIPS/eip-20
92  * Originally based on code by FirstBlood:
93  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  *
95  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
96  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
97  * compliant implementations may not do it.
98  */
99 contract ERC20 is IERC20 {
100     using SafeMath for uint256;
101 
102     mapping (address => uint256) internal _balances;
103 
104     mapping (address => mapping (address => uint256)) private _allowed;
105 
106     /**
107      * @dev Gets the balance of the specified address.
108      * @param owner The address to query the balance of.
109      * @return A uint256 representing the amount owned by the passed adfunction transferdress.
110      */
111     function balanceOf(address owner) public view returns (uint256) {
112         return _balances[owner];
113     }
114 
115     /**
116      * @dev Function to check the amount of tokens that an owner allowed to a spender.
117      * @param owner address The address which owns the funds.
118      * @param spender address The address which will spend the funds.
119      * @return A uint256 specifying the amount of tokens still available for the spender.
120      */
121     function allowance(address owner, address spender) public view returns (uint256) {
122         return _allowed[owner][spender];
123     }
124 
125     /**
126      * @dev Transfer token to a specified address.
127      * @param to The address to transfer to.
128      * @param value The amount to be transferred.
129      */
130     function transfer(address to, uint256 value) public returns (bool) {
131         _transfer(msg.sender, to, value);
132         return true;
133     }
134 
135     /**
136      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
137      * Beware that changing an allowance with this method brings the risk that someone may use both the old
138      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      * @param spender The address which will spend the funds.
142      * @param value The amount of tokens to be spent.
143      */
144     function approve(address spender, uint256 value) public returns (bool) {
145         _approve(msg.sender, spender, value);
146         return true;
147     }
148 
149     /**
150      * @dev Transfer tokens from one address to another.
151      * Note that while this function emits an Approval event, this is not required as per the specification,
152      * and other compliant implementations may not emit the event.
153      * @param from address The address which you want to send tokens from
154      * @param to address The address which you want to transfer to
155      * @param value uint256 the amount of tokens to be transferred
156      */
157     function transferFrom(address from, address to, uint256 value) public returns (bool) {
158         _transfer(from, to, value);
159         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
160         return true;
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
166      * allowed value is better to use this function to avoid 2 calls (and wait until
167      * the first transaction is mined)
168      * From MonolithDAO Token.sol
169      * Emits an Approval event.
170      * @param spender The address which will spend the funds.
171      * @param addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
174         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
175         return true;
176     }
177 
178     /**
179      * @dev Decrease the amount of tokens that an owner allowed to a spender.
180      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
181      * allowed value is better to use this function to avoid 2 calls (and wait until
182      * the first transaction is mined)
183      * From MonolithDAO Token.sol
184      * Emits an Approval event.
185      * @param spender The address which will spend the funds.
186      * @param subtractedValue The amount of tokens to decrease the allowance by.
187      */
188     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
189         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
190         return true;
191     }
192 
193     /**
194      * @dev Transfer token for a specified addresses.
195      * @param from The address to transfer from.
196      * @param to The address to transfer to.
197      * @param value The amount to be transferred.
198      */
199     function _transfer(address from, address to, uint256 value) internal {
200         require(to != address(0));
201 
202         _balances[from] = _balances[from].sub(value);
203         _balances[to] = _balances[to].add(value);
204         emit Transfer(from, to, value);
205     }
206 
207     /**
208      * @dev Approve an address to spend another addresses' tokens.
209      * @param owner The address that owns the tokens.
210      * @param spender The address that will spend the tokens.
211      * @param value The number of tokens that can be spent.
212      */
213     function _approve(address owner, address spender, uint256 value) internal {
214         require(spender != address(0));
215         require(owner != address(0));
216 
217         _allowed[owner][spender] = value;
218         emit Approval(owner, spender, value);
219     }
220 
221 }
222 
223 contract Auth {
224 
225   address internal admin;
226 
227   event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
228 
229   constructor(address _admin) internal {
230     admin = _admin;
231   }
232 
233   modifier onlyAdmin() {
234     require(msg.sender == admin, "onlyAdmin");
235     _;
236   }
237 
238   function transferOwnership(address _newOwner) onlyAdmin internal {
239     require(_newOwner != address(0x0));
240     admin = _newOwner;
241     emit OwnershipTransferred(msg.sender, _newOwner);
242   }
243 }
244 
245 contract DAABOUNTY is ERC20, Auth {
246   string public constant name = 'DAABOUNTY';
247   string public constant symbol = 'DAA';
248   uint8 public constant decimals = 18;
249   uint256 public constant totalSupply = (5 * 1e6) * (10 ** uint256(decimals));
250 
251   constructor()
252   public
253   Auth(msg.sender)
254   {
255     _balances[this] = totalSupply;
256     emit Transfer(address(0x0), this, totalSupply);
257   }
258 
259   function airdrop(address[] _addresses, uint[] _amounts) public onlyAdmin {
260     require(_addresses.length > 0 && _addresses.length == _amounts.length, "Invalid input");
261     for(uint i = 0; i < _addresses.length; i++) {
262       this.transfer(_addresses[i], _amounts[i]);
263     }
264   }
265 }
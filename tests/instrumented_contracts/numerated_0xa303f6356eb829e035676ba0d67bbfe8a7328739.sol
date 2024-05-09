1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public constant returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title ERC20 interface
17  */
18 contract ERC20 is ERC20Basic {
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20 }
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b != 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         assert(b <= a);
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60     mapping(address => uint256) balances;
61 
62   /**
63   * @dev transfer token for a specified address
64   * @param _to The address to transfer to.
65   * @param _value The amount to be transferred.
66   */
67     function transfer(address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69 
70     // SafeMath.sub will throw if there is not enough balance.
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     emit Transfer(msg.sender, _to, _value);
74     return true;
75     }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Ownable
90  * @dev The Ownable contract has an owner address, and provides basic authorization control
91  * functions, this simplifies the implementation of "user permissions".
92  */
93 contract Ownable {
94   address public owner;
95 
96 
97   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99 
100   /**
101    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
102    * account.
103    */
104   constructor() public {
105     owner = msg.sender;
106   }
107 
108 
109   /**
110    * @dev Throws if called by any account other than the owner.
111    */
112   modifier onlyOwner() {
113     require(msg.sender == owner);
114     _;
115   }
116 
117 
118   /**
119    * @dev Allows the current owner to transfer control of the contract to a newOwner.
120    * @param newOwner The address to transfer ownership to.
121    */
122   function transferOwnership(address newOwner) onlyOwner public {
123     require(newOwner != address(0));
124     emit OwnershipTransferred(owner, newOwner);
125     owner = newOwner;
126   }
127 
128 }
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146 
147     balances[_from] = balances[_from].sub(_value);
148     balances[_to] = balances[_to].add(_value);
149 
150     emit Transfer(_from, _to, _value);
151     return true;
152   }
153 
154 }
155 
156 /**
157  * @title Burnable Token
158  * @dev Token that can be irreversibly burned (destroyed).
159  */
160 contract BurnableToken is StandardToken {
161 
162     event Burn(address indexed burner, uint256 value);
163 
164     /**
165      * @dev Burns a specific amount of tokens.
166      * @param _value The amount of token to be burned.
167      */
168     function burn(uint256 _value) public {
169         require(_value > 0);
170 
171         address burner = msg.sender;
172         balances[burner] = balances[burner].sub(_value);
173         totalSupply = totalSupply.sub(_value);
174         emit Burn(burner, _value);
175     }
176 }
177 
178 contract LiTeum is StandardToken, BurnableToken, Ownable {
179 
180     // Constants
181     string  public constant name = "LiTeum";
182     string  public constant symbol = "LTMF";
183     uint8   public constant decimals = 18;
184     uint256 public constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
185 
186 
187 
188     // Properties
189     address public adminAddr;               // the address of a admin currently selling this token
190     bool    public transferEnabled = false; // indicates if transferring tokens is enabled or not
191 
192     // Modifiers
193     modifier onlyWhenTransferEnabled() {
194         if (!transferEnabled) {
195             require(msg.sender == adminAddr);
196         }
197         _;
198     }
199 
200     /**
201      * The listed addresses are not valid recipients of tokens.
202      *
203      * 0x0           - the zero address is not valid
204      * this          - the contract itself should not receive tokens
205      * owner         - the owner has all the initial tokens, but cannot receive any back
206      * adminAddr     - the admin has an allowance of tokens to transfer, but does not receive any
207      */
208     modifier validDestination(address _to) {
209         require(_to != address(0x0));
210         require(_to != address(this));
211         require(_to != owner);
212         _;
213     }
214 
215     /**
216      * Constructor - instantiates token supply and allocates balanace of
217      * to the owner (msg.sender).
218      */
219     constructor(address _admin)public  {
220         // the owner is a custodian of tokens.
221         require(msg.sender != _admin);
222 
223         totalSupply = INITIAL_SUPPLY;
224 
225         // mint all tokens
226         balances[msg.sender] = totalSupply;
227         emit Transfer(address(0x0), msg.sender, totalSupply);
228 
229         adminAddr = _admin;
230     }
231 
232     /**
233      * Enables the ability of anyone to transfer their tokens. This can
234      * only be called by the token owner. Once enabled, it is not
235      * possible to disable transfers.
236      */
237     function enableTransfer() external onlyOwner {
238         transferEnabled = true;
239 
240     }
241 
242     /**
243      * Disable the token transfer. This can
244      * only be called by the token owner.
245      */
246     function disableTransfer() external onlyOwner {
247         transferEnabled = false;
248 
249     }
250 
251     /**
252      * owner send tokens to admin.
253      */
254     function transferToAdmin(uint256 _value) public onlyOwner onlyWhenTransferEnabled returns (bool) {
255     	return super.transfer(adminAddr, _value);
256     }
257 
258     function adminTransfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
259 
260     	require (msg.sender == adminAddr);
261     	return super.transfer(_to, _value);
262 
263     }
264 
265     /**
266      * Overrides ERC20 transfer function with modifier that prevents the
267      * ability to transfer tokens until after transfers have been enabled.
268      */
269     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
270         return super.transfer(_to, _value);
271     }
272 
273     /**
274      * Overrides ERC20 transferFrom function with modifier that prevents the
275      * ability to transfer tokens until after transfers have been enabled.
276      */
277     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
278       require(msg.sender==_from);
279       bool result = super.transferFrom(_from, _to, _value);
280         return result;
281     }
282 
283     /**
284      * Overrides the burn function so that it cannot be called until after
285      * transfers have been enabled.
286      *
287      */
288     function burn(uint256 _value) public {
289         require(transferEnabled || msg.sender == owner);
290         super.burn(_value);
291         emit Transfer(msg.sender, address(0x0), _value);
292     }
293 
294     /**
295     *function to kill the token
296     */
297     function kill() public onlyOwner
298     {
299         selfdestruct(owner);
300     }
301 }
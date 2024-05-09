1 pragma solidity 0.5.11; /*
2 
3   ___________________________________________________________________
4     _      _                                        ______
5     |  |  /          /                                /
6   --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
7     |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )
8   __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
9 
10 
11 
12   ███████╗███████╗████████╗██╗     ██████╗ ██████╗ ██╗███╗   ██╗
13   ██╔════╝██╔════╝╚══██╔══╝██║    ██╔════╝██╔═══██╗██║████╗  ██║
14   ███████╗█████╗     ██║   ██║    ██║     ██║   ██║██║██╔██╗ ██║
15   ╚════██║██╔══╝     ██║   ██║    ██║     ██║   ██║██║██║╚██╗██║
16   ███████║███████╗   ██║   ██║    ╚██████╗╚██████╔╝██║██║ ╚████║
17   ╚══════╝╚══════╝   ╚═╝   ╚═╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
18 
19 
20 
21 ----------------------------------------------------------------------------
22  'SETI' Token contract with following features
23     => ERC20 Compliance
24     => Higher degree of control by owner - safeguard functionality
25     => SafeMath implementation
26     => Burnable
27     => air drop
28 
29  Name        : South East Trading Investment
30  Symbol      : SETI
31  Total supply: 600,000,000 (600 Million)
32  Decimals    : 18
33 
34 
35 ------------------------------------------------------------------------------------
36  Copyright (c) 2019 onwards South East Trading Investment. ( http://seti.network )
37 -----------------------------------------------------------------------------------
38 */
39 
40 
41 //*******************************************************************//
42 //------------------------ SafeMath Library -------------------------//
43 //*******************************************************************//
44 /* Safemath library */
45 library SafeMath {
46   /**
47    * @dev Returns the addition of two unsigned integers, reverting on
48    * overflow.
49    *
50    * Counterpart to Solidity's `+` operator.
51    *
52    * Requirements:
53    * - Addition cannot overflow.
54    */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     require(c >= a, "SafeMath: addition overflow");
58 
59     return c;
60   }
61 
62   /**
63    * @dev Returns the subtraction of two unsigned integers, reverting on
64    * overflow (when the result is negative).
65    *
66    * Counterpart to Solidity's `-` operator.
67    *
68    * Requirements:
69    * - Subtraction cannot overflow.
70    */
71   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b <= a, "SafeMath: subtraction overflow");
73     uint256 c = a - b;
74 
75     return c;
76   }
77 
78   /**
79    * @dev Returns the multiplication of two unsigned integers, reverting on
80    * overflow.
81    *
82    * Counterpart to Solidity's `*` operator.
83    *
84    * Requirements:
85    * - Multiplication cannot overflow.
86    */
87   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89     // benefit is lost if 'b' is also tested.
90     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91     if (a == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     require(c / a == b, "SafeMath: multiplication overflow");
97 
98     return c;
99   }
100 
101   /**
102    * @dev Returns the integer division of two unsigned integers. Reverts on
103    * division by zero. The result is rounded towards zero.
104    *
105    * Counterpart to Solidity's `/` operator. Note: this function uses a
106    * `revert` opcode (which leaves remaining gas untouched) while Solidity
107    * uses an invalid opcode to revert (consuming all remaining gas).
108    *
109    * Requirements:
110    * - The divisor cannot be zero.
111    */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // Solidity only automatically asserts when dividing by 0
114     require(b > 0, "SafeMath: division by zero");
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118     return c;
119   }
120 
121   /**
122    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123    * Reverts when dividing by zero.
124    *
125    * Counterpart to Solidity's `%` operator. This function uses a `revert`
126    * opcode (which leaves remaining gas untouched) while Solidity uses an
127    * invalid opcode to revert (consuming all remaining gas).
128    *
129    * Requirements:
130    * - The divisor cannot be zero.
131    */
132   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133     require(b != 0, "SafeMath: modulo by zero");
134     return a % b;
135   }
136 }
137 
138 //*******************************************************************//
139 //------------------ Contract to Manage Ownership -------------------//
140 //*******************************************************************//
141 
142 // Owner Handler
143 contract owned {
144   address payable public owner;
145 
146     constructor () public {
147     owner = msg.sender;
148   }
149 
150   modifier onlyOwner {
151     require(msg.sender == owner, 'not the owner');
152     _;
153   }
154 
155   function transferOwnership(address payable newOwner) public onlyOwner {
156     owner = newOwner;
157   }
158 }
159 
160 //*****************************************************************//
161 //------------------ SETI Coin main code starts -------------------//
162 //*****************************************************************//
163 
164 contract SETIcoin is owned {
165   // Public variables of the token
166   using SafeMath for uint256;
167   string public name = "South East Trading Investment";
168   string public symbol = "SETI";
169   uint256 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
170   uint256 public totalSupply = 600000000 * (10 ** decimals) ; // 600 Million with 18 decimal points
171   bool public safeguard; // putting safeguard on will halt all non-owner functions
172 
173 
174   // This creates an array with all balances
175   mapping (address => uint256) public balanceOf;
176   mapping (address => mapping (address => uint256)) public allowance;
177   mapping (address => bool) public frozenAccount;
178 
179 
180   /* This generates a public event on the blockchain that will notify clients */
181   event FrozenAccounts(address target, bool frozen);
182 
183   // This generates a public event on the blockchain that will notify clients
184   event Transfer(address indexed from, address indexed to, uint256 value);
185 
186   // This notifies clients about the amount burnt
187   event Burn(address indexed from, uint256 value);
188 
189   // Approval
190   event Approval(address indexed tokenOwner, address indexed spender, uint256 indexed tokenAmount);
191 
192 
193   /**
194     * Constrctor function
195     *
196     * Initializes contract with initial supply tokens to the creator of the contract
197     */
198   constructor () public {
199 
200     //sending all the tokens to Owner
201     balanceOf[owner] = totalSupply;
202 
203     emit Transfer(address(0), msg.sender, totalSupply);
204 
205   }
206 
207   /**
208     * Internal transfer, only can be called by this contract
209     */
210   function _transfer(address _from, address _to, uint _value) internal {
211     require(!safeguard, 'safeguard is active');
212     // Prevent transfer to 0x0 address. Use burn() instead
213     require(_to != address(0x0), 'zero address');
214 
215     uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
216     balanceOf[_from] = balanceOf[_from].sub(_value);
217     balanceOf[_to] = balanceOf[_to].add(_value);
218 
219     assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
220 
221     emit Transfer(_from, _to, _value);
222   }
223 
224   /**
225     * Transfer tokens
226     *
227     * Send `_value` tokens to `_to` from your account
228     *
229     * @param _to The address of the recipient
230     * @param _value the amount to send
231     */
232   function transfer(address _to, uint256 _value) public returns (bool success) {
233     _transfer(msg.sender, _to, _value);
234     return true;
235   }
236 
237   /**
238     * Transfer tokens from other address
239     *
240     * Send `_value` tokens to `_to` in behalf of `_from`
241     *
242     * @param _from The address of the sender
243     * @param _to The address of the recipient
244     * @param _value the amount to send
245     */
246   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
247     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
248     _transfer(_from, _to, _value);
249     return true;
250   }
251 
252   /**
253     * Set allowance for other address
254     *
255     * Allows `_spender` to spend no more than `_value` tokens in your behalf
256     *
257     * @param _spender The address authorized to spend
258     * @param _value the max amount they can spend
259     */
260   function approve(address _spender, uint256 _value) public returns (bool success) {
261     require(!safeguard, 'safeguard is active');
262     allowance[msg.sender][_spender] = _value;
263     emit Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267 
268   /**
269     * Destroy tokens
270     *
271     * Remove `_value` tokens from the system irreversibly
272     *
273     * @param _value the amount of money to burn
274     */
275   function burn(uint256 _value) public returns (bool success) {
276     require(!safeguard, 'safeguard is active');
277     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
278     totalSupply = totalSupply.sub(_value);
279     emit Burn(msg.sender, _value);
280     emit Transfer(msg.sender, address(0), _value);
281     return true;
282   }
283 
284 
285   /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
286   /// @param target Address to be frozen
287   /// @param freeze either to freeze it or not
288   function freezeAccount(address target, bool freeze) public onlyOwner {
289     frozenAccount[target] = freeze;
290     emit FrozenAccounts(target, freeze);
291   }
292 
293 
294 
295   // Just in rare case, owner wants to transfer Ether from contract to owner address
296   function manualWithdrawEther() public onlyOwner {
297     address(owner).transfer(address(this).balance);
298   }
299 
300   function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner {
301     // no need for overflow checking as that will be done in transfer function
302     _transfer(address(this), owner, tokenAmount);
303   }
304 
305 
306 
307   /**
308     * Change safeguard status on or off
309     *
310     * When safeguard is true, then all the non-owner functions will stop working.
311     * When safeguard is false, then all the functions will resume working back again!
312     */
313   function changeSafeguardStatus() public onlyOwner {
314     if (safeguard == false) {
315       safeguard = true;
316     }
317     else {
318       safeguard = false;
319     }
320   }
321 
322   /********************************/
323   /*    Code for the Air drop     */
324   /********************************/
325 
326   /**
327     * Run an Air-Drop
328     *
329     * It requires an array of all the addresses and amount of tokens to distribute
330     * It will only process first 150 recipients. That limit is fixed to prevent gas limit
331     */
332   function airdrop(address[] memory recipients, uint[] memory tokenAmount) public onlyOwner {
333     uint256 addressCount = recipients.length;
334     require(addressCount <= 150, 'address count over 150');
335     for(uint i = 0; i < addressCount; i++) {
336       // This will loop through all the recipients and send them the specified tokens
337       _transfer(address(this), recipients[i], tokenAmount[i]);
338     }
339   }
340 }
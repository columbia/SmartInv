1 pragma solidity 0.5.10; /*
2 
3     
4     ___________________________________________________________________
5       _      _                                        ______           
6       |  |  /          /                                /              
7     --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
8       |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
9     __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_
10     
11     
12     
13     ███████╗███████╗████████╗██╗     ██████╗ ██████╗ ██╗███╗   ██╗
14     ██╔════╝██╔════╝╚══██╔══╝██║    ██╔════╝██╔═══██╗██║████╗  ██║
15     ███████╗█████╗     ██║   ██║    ██║     ██║   ██║██║██╔██╗ ██║
16     ╚════██║██╔══╝     ██║   ██║    ██║     ██║   ██║██║██║╚██╗██║
17     ███████║███████╗   ██║   ██║    ╚██████╗╚██████╔╝██║██║ ╚████║
18     ╚══════╝╚══════╝   ╚═╝   ╚═╝     ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝
19                                                                   
20                                                                   
21 
22 ----------------------------------------------------------------------------
23  'SETI' Token contract with following features
24       => ERC20 Compliance
25       => Higher degree of control by owner - safeguard functionality
26       => SafeMath implementation 
27       => Burnable and minting
28       => air drop
29 
30  Name        : South East Trading Investment
31  Symbol      : SETI
32  Total supply: 600,000,000 (600 Million)
33  Decimals    : 18
34 
35 
36 ------------------------------------------------------------------------------------
37  Copyright (c) 2019 onwards South East Trading Investment. ( http://seti.network )
38  Contract designed with ❤ by EtherAuthority ( https://EtherAuthority.io )
39 -----------------------------------------------------------------------------------
40 */
41 
42 
43 
44 
45 //*******************************************************************//
46 //------------------------ SafeMath Library -------------------------//
47 //*******************************************************************//
48 /* Safemath library */
49 library SafeMath {
50     /**
51      * @dev Returns the addition of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `+` operator.
55      *
56      * Requirements:
57      * - Addition cannot overflow.
58      */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b <= a, "SafeMath: subtraction overflow");
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      * - The divisor cannot be zero.
115      */
116     function div(uint256 a, uint256 b) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, "SafeMath: division by zero");
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b != 0, "SafeMath: modulo by zero");
138         return a % b;
139     }
140 }
141 
142 //*******************************************************************//
143 //------------------ Contract to Manage Ownership -------------------//
144 //*******************************************************************//
145     
146     // Owner Handler
147     contract owned {
148         address payable public owner;
149         
150          constructor () public {
151             owner = msg.sender;
152         }
153     
154         modifier onlyOwner {
155             require(msg.sender == owner);
156             _;
157         }
158     
159         function transferOwnership(address payable newOwner) onlyOwner public {
160             owner = newOwner;
161         }
162     }
163 
164 //*****************************************************************//
165 //------------------ SETI Coin main code starts -------------------//
166 //*****************************************************************//
167     
168     contract SETIcoin is owned{
169         // Public variables of the token
170         using SafeMath for uint256;
171         string public name = "South East Trading Investment";
172         string public symbol = "SETI";
173         uint256 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it
174         uint256 public totalSupply = 600000000 * (10 ** decimals) ; //600 Million with 18 decimal points
175         bool public safeguard;  //putting safeguard on will halt all non-owner functions
176     
177     
178         // This creates an array with all balances
179         mapping (address => uint256) public balanceOf;
180         mapping (address => mapping (address => uint256)) public allowance;
181         mapping (address => bool) public frozenAccount;
182     
183         
184         /* This generates a public event on the blockchain that will notify clients */
185         event FrozenAccounts(address target, bool frozen);
186     
187         // This generates a public event on the blockchain that will notify clients
188         event Transfer(address indexed from, address indexed to, uint256 value);
189     
190         // This notifies clients about the amount burnt
191         event Burn(address indexed from, uint256 value);
192         
193         // Approval
194         event Approval(address indexed tokenOwner, address indexed spender, uint256 indexed tokenAmount);
195     
196     
197         /**
198          * Constrctor function
199          *
200          * Initializes contract with initial supply tokens to the creator of the contract
201          */
202         constructor () public {
203             
204             //sending all the tokens to Owner
205             balanceOf[owner] = totalSupply;
206 
207             emit Transfer(address(0), msg.sender, totalSupply);// Emit event to log this transaction
208             
209         }
210     
211         /**
212          * Internal transfer, only can be called by this contract
213          */
214         function _transfer(address _from, address _to, uint _value) internal {
215             require(!safeguard);
216             // Prevent transfer to 0x0 address. Use burn() instead
217             require(_to != address(0x0));
218             // Save this for an assertion in the future
219             uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
220             // Subtract from the sender
221             balanceOf[_from] = balanceOf[_from].sub(_value);
222             // Add the same to the recipient
223             balanceOf[_to] = balanceOf[_to].add(_value);
224             emit Transfer(_from, _to, _value);
225             // Asserts are used to use static analysis to find bugs in your code. They should never fail
226             assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
227         }
228     
229         /**
230          * Transfer tokens
231          *
232          * Send `_value` tokens to `_to` from your account
233          *
234          * @param _to The address of the recipient
235          * @param _value the amount to send
236          */
237         function transfer(address _to, uint256 _value) public returns (bool success) {
238             _transfer(msg.sender, _to, _value);
239             return true;
240         }
241     
242         /**
243          * Transfer tokens from other address
244          *
245          * Send `_value` tokens to `_to` in behalf of `_from`
246          *
247          * @param _from The address of the sender
248          * @param _to The address of the recipient
249          * @param _value the amount to send
250          */
251         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
252             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
253             _transfer(_from, _to, _value);
254             return true;
255         }
256     
257         /**
258          * Set allowance for other address
259          *
260          * Allows `_spender` to spend no more than `_value` tokens in your behalf
261          *
262          * @param _spender The address authorized to spend
263          * @param _value the max amount they can spend
264          */
265         function approve(address _spender, uint256 _value) public returns (bool success) {
266             require(!safeguard);
267             require(balanceOf[msg.sender] >= _value && _value > 0, 'Not enough balance');
268             allowance[msg.sender][_spender] = _value;
269             emit Approval(msg.sender, _spender, _value);
270             return true;
271         }
272     
273     
274         /**
275          * Destroy tokens
276          *
277          * Remove `_value` tokens from the system irreversibly
278          *
279          * @param _value the amount of money to burn
280          */
281         function burn(uint256 _value) public returns (bool success) {
282             require(!safeguard);
283             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
284             totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
285             emit Burn(msg.sender, _value);
286             emit Transfer(msg.sender, address(0), _value);
287             return true;
288         }
289         
290         
291         /// @notice Create `mintedAmount` tokens and send it to `target`
292         /// @param target Address to receive the tokens
293         /// @param mintedAmount the amount of tokens it will receive
294         function mintToken(address target, uint256 mintedAmount) onlyOwner public {
295             balanceOf[target] = balanceOf[target].add(mintedAmount);
296             totalSupply = totalSupply.add(mintedAmount);
297             emit Transfer(address(0), target, mintedAmount);
298         }
299         
300     
301         /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
302         /// @param target Address to be frozen
303         /// @param freeze either to freeze it or not
304         function freezeAccount(address target, bool freeze) onlyOwner public {
305                 frozenAccount[target] = freeze;
306             emit  FrozenAccounts(target, freeze);
307         }
308         
309 
310           
311         //Just in rare case, owner wants to transfer Ether from contract to owner address
312         function manualWithdrawEther()onlyOwner public{
313             address(owner).transfer(address(this).balance);
314         }
315         
316         function manualWithdrawTokens(uint256 tokenAmount) public onlyOwner{
317             // no need for overflow checking as that will be done in transfer function
318             _transfer(address(this), owner, tokenAmount);
319         }
320         
321 
322         
323         /**
324          * Change safeguard status on or off
325          *
326          * When safeguard is true, then all the non-owner functions will stop working.
327          * When safeguard is false, then all the functions will resume working back again!
328          */
329         function changeSafeguardStatus() onlyOwner public{
330             if (safeguard == false){
331                 safeguard = true;
332             }
333             else{
334                 safeguard = false;    
335             }
336         }
337         
338         /********************************/
339         /*    Code for the Air drop     */
340         /********************************/
341         
342         /**
343          * Run an Air-Drop
344          *
345          * It requires an array of all the addresses and amount of tokens to distribute
346          * It will only process first 150 recipients. That limit is fixed to prevent gas limit
347          */
348         function airdrop(address[] memory recipients, uint[] memory tokenAmount) public onlyOwner {
349             uint256 addressCount = recipients.length;
350             require(addressCount <= 150);
351             for(uint i = 0; i < addressCount; i++)
352             {
353                   //This will loop through all the recipients and send them the specified tokens
354                   _transfer(address(this), recipients[i], tokenAmount[i]);
355             }
356         }
357     
358         
359     }
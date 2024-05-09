1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     function balanceOf(address who) public constant returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 contract ERC20 is ERC20Basic {
13     function allowance(address owner, address spender) public constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 library SafeMath {
21 
22     /**
23     * @dev Multiplies two numbers, throws on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     /**
39     * @dev Integer division of two numbers, truncating the quotient.
40     */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         // uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return a / b;
46     }
47 
48     /**
49     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50     */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60         c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 
67 contract BasicToken is ERC20Basic {
68 
69     using SafeMath for uint256;
70 
71     mapping(address => uint256) balances;
72 
73     function transfer(address _to, uint256 _value) public returns (bool) {
74         require(msg.sender != address(0));
75         balances[msg.sender] = balances[msg.sender].sub(_value);
76         balances[_to] = balances[_to].add(_value);
77         emit Transfer(msg.sender, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85 }
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89     mapping (address => mapping (address => uint256)) allowed;
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92         require(_from != address(0));
93 
94         uint256 _allowance = allowed[_from][msg.sender];
95 
96         balances[_to] = balances[_to].add(_value);
97         balances[_from] = balances[_from].sub(_value);
98         allowed[_from][msg.sender] = _allowance.sub(_value);
99         emit Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool) {
104         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105 
106         allowed[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }
114 
115 }
116 
117 /**
118  * @title Ownable
119  * @dev The Ownable contract has an owner address, and provides basic authorization control
120  * functions, this simplifies the implementation of "user permissions".
121  */
122 contract Ownable {
123   address public owner;
124 
125 
126   event OwnershipRenounced(address indexed previousOwner);
127   event OwnershipTransferred(
128     address indexed previousOwner,
129     address indexed newOwner
130   );
131 
132 
133   /**
134    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
135    * account.
136    * https://github.com/OpenZeppelin
137    * openzeppelin-solidity/contracts/ownership/Ownable.sol
138    */
139   constructor() public {
140     owner = msg.sender;
141   }
142 
143   /**
144    * @dev Throws if called by any account other than the owner.
145    */
146   modifier onlyOwner() {
147     require(msg.sender == owner);
148     _;
149   }
150 
151   /**
152    * @dev Allows the current owner to relinquish control of the contract.
153    * @notice Renouncing to ownership will leave the contract without an owner.
154    * It will not be possible to call the functions with the `onlyOwner`
155    * modifier anymore.
156    */
157   function renounceOwnership() public onlyOwner {
158     emit OwnershipRenounced(owner);
159     owner = address(0);
160   }
161 
162   /**
163    * @dev Allows the current owner to transfer control of the contract to a newOwner.
164    * @param _newOwner The address to transfer ownership to.
165    */
166   function transferOwnership(address _newOwner) public onlyOwner {
167     _transferOwnership(_newOwner);
168   }
169 
170   /**
171    * @dev Transfers control of the contract to a newOwner.
172    * @param _newOwner The address to transfer ownership to.
173    */
174   function _transferOwnership(address _newOwner) internal {
175     require(_newOwner != address(0));
176     emit OwnershipTransferred(owner, _newOwner);
177     owner = _newOwner;
178   }
179 }
180 
181 
182 contract HiGold is StandardToken, Ownable {
183 
184     /*** SAFEMATH ***/
185     using SafeMath for uint256;
186 
187     /*** EVENTS ***/
188     event Deposit(address indexed manager, address indexed user, uint value);
189     event Withdrawl(address indexed manager, address indexed user, uint value);
190 
191     /*** CONSTANTS ***/
192     // ERC20
193     string public name = "HiGold Community Token";
194     string public symbol = "HIG";
195     uint256 public decimals = 18;
196 
197     /*** STORAGE ***/
198     // HiGold Standard
199     uint256 public inVaults;
200     address public miner;
201     mapping (address => mapping (address => uint256)) inVault;
202 
203     /*** MODIFIERS  ***/
204     modifier onlyMiner() {
205         require(msg.sender == miner);
206         _;
207     }
208 
209     /*** FUNCTIONS ***/
210     // Constructor function
211     constructor() public {
212         totalSupply = 105 * (10 ** 26);
213         balances[msg.sender] = totalSupply;
214     }
215 
216     // Public functions
217     function totalInVaults() public constant returns (uint256 amount) {
218         return inVaults;
219     }
220 
221     function balanceOfOwnerInVault
222     (
223         address _vault,
224         address _owner
225     )
226         public
227         constant
228         returns (uint256 balance)
229     {
230         return inVault[_vault][_owner];
231     }
232 
233     function deposit
234     (
235         address _vault,
236         uint256 _value
237     )
238         public
239         returns (bool)
240     {
241         balances[msg.sender] = balances[msg.sender].sub(_value);
242         inVaults = inVaults.add(_value);
243         inVault[_vault][msg.sender] = inVault[_vault][msg.sender].add(_value);
244         emit Deposit(_vault, msg.sender, _value);
245         return true;
246     }
247 
248     function withdraw
249     (
250         address _vault,
251         uint256 _value
252     )
253         public
254         returns (bool)
255     {
256         inVault[_vault][msg.sender] = inVault[_vault][msg.sender].sub(_value);
257         inVaults = inVaults.sub(_value);
258         balances[msg.sender] = balances[msg.sender].add(_value);
259         emit Withdrawl(_vault, msg.sender, _value);
260         return true;
261     }
262 
263     function accounting
264     (
265         address _credit, // -
266         address _debit, // +
267         uint256 _value
268     )
269         public
270         returns (bool)
271     {
272         inVault[msg.sender][_credit] = inVault[msg.sender][_credit].sub(_value);
273         inVault[msg.sender][_debit] = inVault[msg.sender][_debit].add(_value);
274         return true;
275     }
276 
277     /// For Mining
278     function startMining(address _minerContract) public  onlyOwner {
279         require(miner == address(0));
280         miner = _minerContract;
281         inVault[miner][miner] = 105 * (10 ** 26);
282     }
283     //// Update contract overview infomations when new token mined.
284     function update(uint _value) public onlyMiner returns(bool) {
285         totalSupply = totalSupply.add(_value);
286         inVaults = inVaults.add(_value);
287         return true;
288     }
289 
290 }
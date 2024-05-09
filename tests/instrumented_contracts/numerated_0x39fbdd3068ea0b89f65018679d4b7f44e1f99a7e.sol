1 pragma solidity ^0.4.23;
2 
3 // Abstract contract for the full ERC 20 Token standard
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
5 
6 contract ERC20Interface {
7     /* This is a slight change to the ERC20 base standard.
8     function totalSupply() constant returns (uint256 supply);
9     is replaced with:
10     uint256 public totalSupply;
11     This automatically creates a getter function for the totalSupply.
12     This is moved to the base contract since public getter functions are not
13     currently recognised as an implementation of the matching abstract
14     function by the compiler.
15     */
16     /// total amount of tokens
17     uint256 public totalSupply;
18 
19     /// @param _owner The address from which the balance will be retrieved
20     /// @return The balance
21     function balanceOf(address _owner) public view returns (uint256 balance);
22 
23     /// @notice send `_value` token to `_to` from `msg.sender`
24     /// @param _to The address of the recipient
25     /// @param _value The amount of token to be transferred
26     /// @return Whether the transfer was successful or not
27     function transfer(address _to, uint256 _value) public returns (bool success);
28 
29     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
30     /// @param _from The address of the sender
31     /// @param _to The address of the recipient
32     /// @param _value The amount of token to be transferred
33     /// @return Whether the transfer was successful or not
34     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
35 
36     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
37     /// @param _spender The address of the account able to transfer the tokens
38     /// @param _value The amount of tokens to be approved for transfer
39     /// @return Whether the approval was successful or not
40     function approve(address _spender, uint256 _value) public returns (bool success);
41 
42     /// @param _owner The address of the account owning tokens
43     /// @param _spender The address of the account able to transfer the tokens
44     /// @return Amount of remaining tokens allowed to spent
45     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
46 
47     // solhint-disable-next-line no-simple-event-func-name
48     event Transfer(address indexed _from, address indexed _to, uint256 _value);
49     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60   event OwnershipRenounced(address indexed previousOwner);
61   event OwnershipTransferred(
62     address indexed previousOwner,
63     address indexed newOwner
64   );
65 
66   /**
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   constructor() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     emit OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 
92   /**
93    * @dev Allows the current owner to relinquish control of the contract.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 }
100 
101 /**
102  * @title SafeMath
103  * @dev Math operations with safety checks that throw on error
104  */
105 library SafeMath {
106     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107         if (a == 0) {
108             return 0;
109         }
110         uint256 c = a * b;
111         assert(c / a == b);
112         return c;
113     }
114 
115     function div(uint256 a, uint256 b) internal pure returns (uint256) {
116         // assert(b > 0); // Solidity automatically throws when dividing by 0
117         uint256 c = a / b;
118         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119         return c;
120     }
121 
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         assert(b <= a);
124         return a - b;
125     }
126 
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         assert(c >= a);
130         return c;
131     }
132 }
133 
134 /**
135  * @title WiredToken
136  * @author Tsuchinoko & NanJ people
137  * @dev WiredToken is an ERC223 Token with ERC20 functions and events
138  *      Fully backward compatible with ERC20
139  */
140 contract WiredToken is ERC20Interface, Ownable {
141     using SafeMath for uint256;
142 
143     string constant public name = "WiredToken";
144     string constant public symbol = "WRD";
145     uint8 constant public decimals = 5;
146     uint256 public totalSupply = 57e22 * 1e5;
147     bool public mintingFinished = false;
148 
149     mapping (address => uint256) public balanceOf;
150     mapping (address => mapping (address => uint256)) public allowance;
151     mapping (address => uint256) public unlockUnixTime;
152 
153     event LockedFunds(address indexed target, uint256 locked);
154     event Burn(address indexed from, uint256 amount);
155     event Mint(address indexed to, uint256 amount);
156     event MintFinished();
157 
158     /**
159      * @dev Constructor is called only once and can not be called again
160      */
161     constructor() public {
162         balanceOf[owner] = totalSupply;
163         emit Transfer(address(0), owner, totalSupply);
164     }
165 
166     function totalSupply() public view returns (uint256 _totalSupply) {
167         return totalSupply;
168     }
169 
170     function balanceOf(address _owner) public view returns (uint256 balance) {
171         return balanceOf[_owner];
172     }
173 
174     /**
175      * @dev Prevent targets from sending or receiving tokens by setting Unix times
176      * @param targets Addresses to be locked funds
177      * @param unixTimes Unix times when locking up will be finished
178      */
179     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
180         require(targets.length > 0
181                 && targets.length == unixTimes.length);
182 
183         for(uint j = 0; j < targets.length; j++){
184             require(unlockUnixTime[targets[j]] < unixTimes[j]);
185             unlockUnixTime[targets[j]] = unixTimes[j];
186             emit LockedFunds(targets[j], unixTimes[j]);
187         }
188     }
189 
190     /**
191      * @dev Standard function transfer similar to ERC20 transfer with no _data
192      *      Added due to backwards compatibility reasons
193      */
194     function transfer(address _to, uint _value) public returns (bool success) {
195         require(_value > 0
196                 && now > unlockUnixTime[msg.sender]
197                 && now > unlockUnixTime[_to]);
198         require(balanceOf[msg.sender] >= _value);
199         
200         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
201         balanceOf[_to] = balanceOf[_to].add(_value);
202         
203         emit Transfer(msg.sender, _to, _value);
204         return true;
205     }
206 
207     /**
208      * @dev Transfer tokens from one address to another
209      *      Added due to backwards compatibility with ERC20
210      * @param _from address The address which you want to send tokens from
211      * @param _to address The address which you want to transfer to
212      * @param _value uint256 the amount of tokens to be transferred
213      */
214     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
215         require(_to != address(0)
216                 && _value > 0
217                 && balanceOf[_from] >= _value
218                 && allowance[_from][msg.sender] >= _value
219                 && now > unlockUnixTime[_from]
220                 && now > unlockUnixTime[_to]);
221 
222         balanceOf[_from] = balanceOf[_from].sub(_value);
223         balanceOf[_to] = balanceOf[_to].add(_value);
224         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
225         emit Transfer(_from, _to, _value);
226         return true;
227     }
228 
229     /**
230      * @dev Allows _spender to spend no more than _value tokens in your behalf
231      *      Added due to backwards compatibility with ERC20
232      * @param _spender The address authorized to spend
233      * @param _value the max amount they can spend
234      */
235     function approve(address _spender, uint256 _value) public returns (bool success) {
236         allowance[msg.sender][_spender] = _value;
237         emit Approval(msg.sender, _spender, _value);
238         return true;
239     }
240 
241     /**
242      * @dev Function to check the amount of tokens that an owner allowed to a spender
243      *      Added due to backwards compatibility with ERC20
244      * @param _owner address The address which owns the funds
245      * @param _spender address The address which will spend the funds
246      */
247     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
248         return allowance[_owner][_spender];
249     }
250 
251     /**
252      * @dev Burns a specific amount of tokens.
253      * @param _from The address that will burn the tokens.
254      * @param _unitAmount The amount of token to be burned.
255      */
256     function burn(address _from, uint256 _unitAmount) onlyOwner public {
257         require(_unitAmount > 0
258                 && balanceOf[_from] >= _unitAmount);
259 
260         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
261         totalSupply = totalSupply.sub(_unitAmount);
262         emit Burn(_from, _unitAmount);
263     }
264 
265 
266     modifier canMint() {
267         require(!mintingFinished);
268         _;
269     }
270 
271     /**
272      * @dev Function to mint tokens
273      * @param _to The address that will receive the minted tokens.
274      * @param _unitAmount The amount of tokens to mint.
275      */
276     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
277         require(_unitAmount > 0);
278 
279         totalSupply = totalSupply.add(_unitAmount);
280         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
281         emit Mint(_to, _unitAmount);
282         emit Transfer(address(0), _to, _unitAmount);
283         return true;
284     }
285 
286     /**
287      * @dev Function to stop minting new tokens.
288      */
289     function finishMinting() onlyOwner canMint public returns (bool) {
290         mintingFinished = true;
291         emit MintFinished();
292         return true;
293     }
294 
295     /**
296      * @dev Function to distribute tokens to the list of addresses by the provided amount
297      */
298     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
299         require(amount > 0
300                 && addresses.length > 0
301                 && now > unlockUnixTime[msg.sender]);
302 
303         amount = amount.mul(1e8);
304         uint256 totalAmount = amount.mul(addresses.length);
305         require(balanceOf[msg.sender] >= totalAmount);
306 
307         for (uint j = 0; j < addresses.length; j++) {
308             require(addresses[j] != 0x0
309                     && now > unlockUnixTime[addresses[j]]);
310 
311             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
312             emit Transfer(msg.sender, addresses[j], amount);
313         }
314         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
315         return true;
316     }
317 
318     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
319         require(addresses.length > 0
320                 && addresses.length == amounts.length
321                 && now > unlockUnixTime[msg.sender]);
322 
323         uint256 totalAmount = 0;
324 
325         for(uint j = 0; j < addresses.length; j++){
326             require(amounts[j] > 0
327                     && addresses[j] != 0x0
328                     && now > unlockUnixTime[addresses[j]]);
329 
330             amounts[j] = amounts[j].mul(1e8);
331             totalAmount = totalAmount.add(amounts[j]);
332         }
333         require(balanceOf[msg.sender] >= totalAmount);
334 
335         for (j = 0; j < addresses.length; j++) {
336             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
337             emit Transfer(msg.sender, addresses[j], amounts[j]);
338         }
339         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
340         return true;
341     }
342 
343 }
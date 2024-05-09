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
146     uint256 public totalSupply = 41e11 * 1e5;
147     uint256 public distributeAmount = 0;
148     bool public mintingFinished = false;
149 
150     address public founder = 0x01B7ECa9Af127aCbA03aB84E88B0e56132CFb62D;
151     address public preSeasonGame = 0x01B7ECa9Af127aCbA03aB84E88B0e56132CFb62D;
152     address public activityFunds = 0x01B7ECa9Af127aCbA03aB84E88B0e56132CFb62D;
153     address public lockedFundsForthefuture = 0x01B7ECa9Af127aCbA03aB84E88B0e56132CFb62D;
154 
155     mapping (address => uint256) public balanceOf;
156     mapping (address => mapping (address => uint256)) public allowance;
157     mapping (address => uint256) public unlockUnixTime;
158 
159     event FrozenFunds(address indexed target, bool frozen);
160     event LockedFunds(address indexed target, uint256 locked);
161     event Burn(address indexed from, uint256 amount);
162     event Mint(address indexed to, uint256 amount);
163     event MintFinished();
164 
165     /**
166      * @dev Constructor is called only once and can not be called again
167      */
168     constructor() public {
169         owner = activityFunds;
170 
171         balanceOf[founder] = totalSupply.mul(25).div(100);
172         balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);
173         balanceOf[activityFunds] = totalSupply.mul(10).div(100);
174         balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
175     }
176 
177     function totalSupply() public view returns (uint256 _totalSupply) {
178         return totalSupply;
179     }
180 
181     function balanceOf(address _owner) public view returns (uint256 balance) {
182         return balanceOf[_owner];
183     }
184 
185     /**
186      * @dev Prevent targets from sending or receiving tokens by setting Unix times
187      * @param targets Addresses to be locked funds
188      * @param unixTimes Unix times when locking up will be finished
189      */
190     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
191         require(targets.length > 0
192                 && targets.length == unixTimes.length);
193 
194         for(uint j = 0; j < targets.length; j++){
195             require(unlockUnixTime[targets[j]] < unixTimes[j]);
196             unlockUnixTime[targets[j]] = unixTimes[j];
197             emit LockedFunds(targets[j], unixTimes[j]);
198         }
199     }
200 
201     /**
202      * @dev Standard function transfer similar to ERC20 transfer with no _data
203      *      Added due to backwards compatibility reasons
204      */
205     function transfer(address _to, uint _value) public returns (bool success) {
206         require(_value > 0
207                 && now > unlockUnixTime[msg.sender]
208                 && now > unlockUnixTime[_to]);
209         require(balanceOf[msg.sender] >= _value);
210         
211         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
212         balanceOf[_to] = balanceOf[_to].add(_value);
213         
214         emit Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     /**
219      * @dev Transfer tokens from one address to another
220      *      Added due to backwards compatibility with ERC20
221      * @param _from address The address which you want to send tokens from
222      * @param _to address The address which you want to transfer to
223      * @param _value uint256 the amount of tokens to be transferred
224      */
225     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
226         require(_to != address(0)
227                 && _value > 0
228                 && balanceOf[_from] >= _value
229                 && allowance[_from][msg.sender] >= _value
230                 && now > unlockUnixTime[_from]
231                 && now > unlockUnixTime[_to]);
232 
233         balanceOf[_from] = balanceOf[_from].sub(_value);
234         balanceOf[_to] = balanceOf[_to].add(_value);
235         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
236         emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240     /**
241      * @dev Allows _spender to spend no more than _value tokens in your behalf
242      *      Added due to backwards compatibility with ERC20
243      * @param _spender The address authorized to spend
244      * @param _value the max amount they can spend
245      */
246     function approve(address _spender, uint256 _value) public returns (bool success) {
247         allowance[msg.sender][_spender] = _value;
248         emit Approval(msg.sender, _spender, _value);
249         return true;
250     }
251 
252     /**
253      * @dev Function to check the amount of tokens that an owner allowed to a spender
254      *      Added due to backwards compatibility with ERC20
255      * @param _owner address The address which owns the funds
256      * @param _spender address The address which will spend the funds
257      */
258     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
259         return allowance[_owner][_spender];
260     }
261 
262     /**
263      * @dev Burns a specific amount of tokens.
264      * @param _from The address that will burn the tokens.
265      * @param _unitAmount The amount of token to be burned.
266      */
267     function burn(address _from, uint256 _unitAmount) onlyOwner public {
268         require(_unitAmount > 0
269                 && balanceOf[_from] >= _unitAmount);
270 
271         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
272         totalSupply = totalSupply.sub(_unitAmount);
273         emit Burn(_from, _unitAmount);
274     }
275 
276 
277     modifier canMint() {
278         require(!mintingFinished);
279         _;
280     }
281 
282     /**
283      * @dev Function to mint tokens
284      * @param _to The address that will receive the minted tokens.
285      * @param _unitAmount The amount of tokens to mint.
286      */
287     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
288         require(_unitAmount > 0);
289 
290         totalSupply = totalSupply.add(_unitAmount);
291         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
292         emit Mint(_to, _unitAmount);
293         emit Transfer(address(0), _to, _unitAmount);
294         return true;
295     }
296 
297     /**
298      * @dev Function to stop minting new tokens.
299      */
300     function finishMinting() onlyOwner canMint public returns (bool) {
301         mintingFinished = true;
302         emit MintFinished();
303         return true;
304     }
305 
306     /**
307      * @dev Function to distribute tokens to the list of addresses by the provided amount
308      */
309     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
310         require(amount > 0
311                 && addresses.length > 0
312                 && now > unlockUnixTime[msg.sender]);
313 
314         amount = amount.mul(1e8);
315         uint256 totalAmount = amount.mul(addresses.length);
316         require(balanceOf[msg.sender] >= totalAmount);
317 
318         for (uint j = 0; j < addresses.length; j++) {
319             require(addresses[j] != 0x0
320                     && now > unlockUnixTime[addresses[j]]);
321 
322             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
323             emit Transfer(msg.sender, addresses[j], amount);
324         }
325         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
326         return true;
327     }
328 
329     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
330         require(addresses.length > 0
331                 && addresses.length == amounts.length
332                 && now > unlockUnixTime[msg.sender]);
333 
334         uint256 totalAmount = 0;
335 
336         for(uint j = 0; j < addresses.length; j++){
337             require(amounts[j] > 0
338                     && addresses[j] != 0x0
339                     && now > unlockUnixTime[addresses[j]]);
340 
341             amounts[j] = amounts[j].mul(1e8);
342             totalAmount = totalAmount.add(amounts[j]);
343         }
344         require(balanceOf[msg.sender] >= totalAmount);
345 
346         for (j = 0; j < addresses.length; j++) {
347             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
348             emit Transfer(msg.sender, addresses[j], amounts[j]);
349         }
350         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
351         return true;
352     }
353 
354 }
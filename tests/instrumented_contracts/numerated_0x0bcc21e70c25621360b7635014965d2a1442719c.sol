1 pragma solidity 0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title ERC20 interface
47  * @dev see https://github.com/ethereum/EIPs/issues/20
48  */
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender) public constant returns (uint256);
51   function transferFrom(address from, address to, uint256 value) public returns (bool);
52   function approve(address spender, uint256 value) public returns (bool);
53   event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 
57 /**
58  * @title Basic token
59  * @dev Basic version of StandardToken, with no allowances.
60  */
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112 
113     uint256 _allowance = allowed[_from][msg.sender];
114 
115     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
116     // require (_value <= _allowance);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = _allowance.sub(_value);
121     Transfer(_from, _to, _value);
122     return true;
123   }
124 
125   /**
126    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127    *
128    * Beware that changing an allowance with this method brings the risk that someone may use both the old
129    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) public returns (bool) {
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval (address _spender, uint _addedValue)
158     returns (bool success) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   function decreaseApproval (address _spender, uint _subtractedValue)
165     returns (bool success) {
166     uint oldValue = allowed[msg.sender][_spender];
167     if (_subtractedValue > oldValue) {
168       allowed[msg.sender][_spender] = 0;
169     } else {
170       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171     }
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176 }
177 
178 contract LOCKTokenCOIN is StandardToken {
179   using SafeMath for uint256;
180 
181   string public name = "LOCK Token COIN";
182   string public symbol = "LOCKTC";
183   uint256 public decimals = 8;
184   uint256 public INITIAL_SUPPLY = 1000000000 * 1 ether;
185 
186   event Burn(address indexed from, uint256 value);
187 
188   function LOCKTokenCOIN() {
189     totalSupply = INITIAL_SUPPLY;
190     balances[msg.sender] = INITIAL_SUPPLY;
191   }
192 
193   function burn(uint256 _value) returns (bool success) {
194     require(balances[msg.sender] >= _value);
195     balances[msg.sender] = balances[msg.sender].sub(_value);
196     totalSupply = totalSupply.sub(_value);
197     Burn(msg.sender, _value);
198     return true;
199   }
200 }
201 
202 /**
203  * @title Ownable
204  * @dev The Ownable contract has an owner address, and provides basic authorization control
205  * functions, this simplifies the implementation of "user permissions".
206  */
207 contract Ownable {
208   address public owner;
209 
210 
211   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213 
214   /**
215    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
216    * account.
217    */
218   function Ownable() {
219     owner = msg.sender;
220   }
221 
222 
223   /**
224    * @dev Throws if called by any account other than the owner.
225    */
226   modifier onlyOwner() {
227     require(msg.sender == owner);
228     _;
229   }
230 
231 
232   /**
233    * @dev Allows the current owner to transfer control of the contract to a newOwner.
234    * @param newOwner The address to transfer ownership to.
235    */
236   function transferOwnership(address newOwner) onlyOwner public {
237     require(newOwner != address(0));
238     OwnershipTransferred(owner, newOwner);
239     owner = newOwner;
240   }
241 
242 }
243 
244 /**
245  * @title Contracts that should not own Ether
246  * @author Remco Bloemen <remco@2π.com>
247  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
248  * in the contract, it will allow the owner to reclaim this ether.
249  * @notice Ether can still be send to this contract by:
250  * calling functions labeled `payable`
251  * `selfdestruct(contract_address)`
252  * mining directly to the contract address
253 */
254 contract HasNoEther is Ownable {
255 
256   /**
257   * @dev Constructor that rejects incoming Ether
258   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
259   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
260   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
261   * we could use assembly to access msg.value.
262   */
263   function HasNoEther() payable {
264     require(msg.value == 0);
265   }
266 
267   /**
268    * @dev Disallows direct send by settings a default function without the `payable` flag.
269    */
270   function() external {
271   }
272 
273   /**
274    * @dev Transfer all Ether held by the contract to the owner.
275    */
276   function reclaimEther() external onlyOwner {
277     assert(owner.send(this.balance));
278   }
279 }
280 
281 
282 contract LOCKTokenCOINLock is HasNoEther {
283     using SafeMath for uint256;
284 
285     LOCKTokenCOIN public LOCKTC;
286     uint public startTime;
287     uint public endTime1;
288     uint public endTime2;
289     uint256 public tranche;
290 
291     modifier onlyAfter(uint time) {
292         require(getCurrentTime() > time);
293         _;
294     }
295 
296     function LOCKTokenCOINLock (
297         address _ltcAddr,
298         uint _startTime,
299         uint _duration,
300         uint256 _tranche
301     ) HasNoEther() public {
302         LOCKTC = LOCKTokenCOIN(_ltcAddr);
303 
304         startTime = _startTime;
305         endTime1 = _startTime + _duration * 1 days;
306         endTime2 = _startTime + 2 * _duration * 1 days;
307 
308         tranche = _tranche * 1e18;
309     }
310 
311     function withdraw1(uint256 _value) external onlyOwner onlyAfter(endTime1) {
312         require(_value <= tranche);
313         LOCKTC.transfer(owner, _value);
314         tranche = tranche.sub(_value);
315     }
316 
317     function withdraw2(uint256 _value) external onlyOwner onlyAfter(endTime2) {
318         LOCKTC.transfer(owner, _value);
319     }
320 
321     function ltcBalance() external constant returns(uint256) {
322         return LOCKTC.balanceOf(this);
323     }
324 
325     function getCurrentTime() internal constant returns(uint256) {
326         return now;
327     }
328 }
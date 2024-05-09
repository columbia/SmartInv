1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * https://github.com/OpenZeppelin/zeppelin-solidity/
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function cei(uint256 a, uint256 b) internal pure returns (uint256) {
37     return ((a + b - 1) / b) * b;
38   }
39 }
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  * https://github.com/OpenZeppelin/zeppelin-solidity/
46  */
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) public view returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 /**
55  * @title ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/20
57  * https://github.com/OpenZeppelin/zeppelin-solidity/
58  */
59 contract ERC20 is ERC20Basic {
60   function allowance(address owner, address spender) public view returns (uint256);
61   function transferFrom(address from, address to, uint256 value) public returns (bool);
62   function approve(address spender, uint256 value) public returns (bool);
63   event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  * https://github.com/OpenZeppelin/zeppelin-solidity/
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  * https://github.com/OpenZeppelin/zeppelin-solidity/
109  */
110 contract StandardToken is ERC20, BasicToken {
111 
112   mapping (address => mapping (address => uint256)) internal allowed;
113 
114 
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    */
165   function increaseApproval (address _spender, uint _addedValue) public returns (bool) {
166     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
167     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182 }
183 
184 /**
185  * @title Ownable
186  * @dev The Ownable contract has an owner address, and provides basic authorization control
187  * functions, this simplifies the implementation of "user permissions".
188  * https://github.com/OpenZeppelin/zeppelin-solidity/
189  */
190 contract Ownable {
191   address public owner;                                                     // Operational owner.
192   address public masterOwner = 0x5D1EC7558C8D1c40406913ab5dbC0Abf1C96BA42;  // for ownership transfer segregation of duty, hard coded to wallet account
193 
194   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196 
197   /**
198    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199    * account.
200    */
201   function Ownable() public {
202     owner = msg.sender;
203   }
204 
205 
206   /**
207    * @dev Throws if called by any account other than the owner.
208    */
209   modifier onlyOwner() {
210     require(msg.sender == owner);
211     _;
212   }
213 
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219   function transferOwnership(address newOwner) public {
220     require(newOwner != address(0));
221     require(masterOwner == msg.sender); // only master owner can initiate change to ownershipe
222     OwnershipTransferred(owner, newOwner);
223     owner = newOwner;
224   }
225 
226 }
227 
228 contract FTXToken is StandardToken, Ownable {
229 
230     /* metadata */
231     string public constant NAME = "Fincoin";
232     string public constant SYMBOL = "FTX";
233     string public constant VERSION = "0.9";
234     uint8 public constant DECIMALS = 18;
235 
236     /* all accounts in wei */
237     uint256 public constant INITIAL_SUPPLY = 100000000 * 10**18;
238     uint256 public constant FINTRUX_RESERVE_FTX = 10000000 * 10**18;
239     uint256 public constant CROSS_RESERVE_FTX = 5000000 * 10**18;
240     uint256 public constant TEAM_RESERVE_FTX = 10000000 * 10**18;
241 
242     // these three multi-sig addresses will be replaced on production:
243     address public constant FINTRUX_RESERVE = 0x633348b01B3f59c8A445365FB2ede865ecc94a0B;
244     address public constant CROSS_RESERVE = 0xED200B7BC7044290c99993341a82a21c4c7725DB;
245     address public constant TEAM_RESERVE = 0xfc0Dd77c6bd889819E322FB72D4a86776b1632d5;
246 
247     // assuming Feb 28, 2018 5:00 PM UTC(1519837200) + 1 year, may change for production; 
248     uint256 public constant VESTING_DATE = 1519837200 + 1 years;
249 
250     // minimum FTX token to be transferred to make the gas worthwhile (avoid micro transfer), cannot be higher than minimal subscribed amount in crowd sale.
251     uint256 public token4Gas = 1*10**18;
252     // gas in wei to reimburse must be the lowest minimum 0.6Gwei * 80000 gas limit.
253     uint256 public gas4Token = 80000*0.6*10**9;
254     // minimum wei required in an account to perform an action (avg gas price 4Gwei * avg gas limit 80000).
255     uint256 public minGas4Accts = 80000*4*10**9;
256 
257     bool public allowTransfers = false;
258     mapping (address => bool) public transferException;
259 
260     event Withdraw(address indexed from, address indexed to, uint256 value);
261     event GasRebateFailed(address indexed to, uint256 value);
262 
263     /**
264     * @dev Contructor that gives msg.sender all existing tokens. 
265     */
266     function FTXToken(address _owner) public {
267         require(_owner != address(0));
268         totalSupply = INITIAL_SUPPLY;
269         balances[_owner] = INITIAL_SUPPLY - FINTRUX_RESERVE_FTX - CROSS_RESERVE_FTX - TEAM_RESERVE_FTX;
270         balances[FINTRUX_RESERVE] = FINTRUX_RESERVE_FTX;
271         balances[CROSS_RESERVE] = CROSS_RESERVE_FTX;
272         balances[TEAM_RESERVE] = TEAM_RESERVE_FTX;
273         owner = _owner;
274         transferException[owner] = true;
275     }
276 
277     /**
278     * @dev transfer token for a specified address
279     * @param _to The address to transfer to.
280     * @param _value The amount to be transferred.
281     */
282     function transfer(address _to, uint256 _value) public returns (bool) {
283         require(canTransferTokens());                                               // Team tokens lock 1 year
284         require(_value > 0 && _value >= token4Gas);                                 // do nothing if less than allowed minimum but do not fail
285         balances[msg.sender] = balances[msg.sender].sub(_value);                    // insufficient token balance would revert here inside safemath
286         balances[_to] = balances[_to].add(_value);
287         Transfer(msg.sender, _to, _value);
288         // Keep a minimum balance of gas in all sender accounts. It would not be executed if the account has enough ETH for next action.
289         if (this.balance > gas4Token && msg.sender.balance < minGas4Accts) {
290             // reimburse gas in ETH to keep a minimal balance for next transaction, use send instead of transfer thus ignore failed rebate(not enough ether to rebate etc.).
291             if (!msg.sender.send(gas4Token)) {
292                 GasRebateFailed(msg.sender,gas4Token);
293             }
294         }
295         return true;
296     }
297     
298     /* When necessary, adjust minimum FTX to transfer to make the gas worthwhile */
299     function setToken4Gas(uint256 newFTXAmount) public onlyOwner {
300         require(newFTXAmount > 0);                                                  // Upper bound is not necessary.
301         token4Gas = newFTXAmount;
302     }
303 
304     /* Only when necessary such as gas price change, adjust the gas to be reimbursed on every transfer when sender account below minimum */
305     function setGas4Token(uint256 newGasInWei) public onlyOwner {
306         require(newGasInWei > 0 && newGasInWei <= 840000*10**9);            // must be less than a reasonable gas value
307         gas4Token = newGasInWei;
308     }
309 
310     /* When necessary, adjust the minimum wei required in an account before an reimibusement of fee is triggerred */
311     function setMinGas4Accts(uint256 minBalanceInWei) public onlyOwner {
312         require(minBalanceInWei > 0 && minBalanceInWei <= 840000*10**9);    // must be less than a reasonable gas value
313         minGas4Accts = minBalanceInWei;
314     }
315 
316     /* This unnamed function is called whenever the owner send Ether to fund the gas fees and gas reimbursement */
317     function() payable public onlyOwner {
318     }
319 
320     /* Owner withdrawal for excessive gas fees deposited */
321     function withdrawToOwner (uint256 weiAmt) public onlyOwner {
322         require(weiAmt > 0);                                                // do not allow zero transfer
323         msg.sender.transfer(weiAmt);
324         Withdraw(this, msg.sender, weiAmt);                                 // signal the event for communication only it is meaningful
325     }
326 
327     /*
328         allow everyone to start transferring tokens freely at the same moment. 
329     */
330     function setAllowTransfers(bool bAllowTransfers) external onlyOwner {
331         allowTransfers = bAllowTransfers;
332     }
333 
334     /*
335         add the ether address to whitelist to enable transfer of token.
336     */
337     function addToException(address addr) external onlyOwner {
338         require(addr != address(0));
339         require(!isException(addr));
340 
341         transferException[addr] = true;
342     }
343 
344     /*
345         remove the ether address from whitelist in case a mistake was made.
346     */
347     function delFrException(address addr) external onlyOwner {
348         require(addr != address(0));
349         require(transferException[addr]);
350 
351         delete transferException[addr];
352     }
353 
354     /* return true when the address is in the exception list eg. token distribution contract and private sales addresses */
355     function isException(address addr) public view returns (bool) {
356         return transferException[addr];
357     }
358 
359     /* below are internal functions */
360     /*
361         return true if token can be transferred.
362     */
363     function canTransferTokens() internal view returns (bool) {
364         if (msg.sender == TEAM_RESERVE) {                                       // Vesting for FintruX TEAM is 1 year.
365             return now >= VESTING_DATE;
366         } else {
367             // if transfer is disabled, only allow special addresses to transfer tokens.
368             return allowTransfers || isException(msg.sender);
369         }
370     }
371 
372 }
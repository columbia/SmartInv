1 pragma solidity ^0.4.21;
2 
3 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: node_modules\zeppelin-solidity\contracts\ownership\HasNoEther.sol
46 
47 /**
48  * @title Contracts that should not own Ether
49  * @author Remco Bloemen <remco@2╧Ç.com>
50  * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up
51  * in the contract, it will allow the owner to reclaim this ether.
52  * @notice Ether can still be send to this contract by:
53  * calling functions labeled `payable`
54  * `selfdestruct(contract_address)`
55  * mining directly to the contract address
56 */
57 contract HasNoEther is Ownable {
58 
59   /**
60   * @dev Constructor that rejects incoming Ether
61   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
62   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
63   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
64   * we could use assembly to access msg.value.
65   */
66   function HasNoEther() public payable {
67     require(msg.value == 0);
68   }
69 
70   /**
71    * @dev Disallows direct send by settings a default function without the `payable` flag.
72    */
73   function() external {
74   }
75 
76   /**
77    * @dev Transfer all Ether held by the contract to the owner.
78    */
79   function reclaimEther() external onlyOwner {
80     assert(owner.send(this.balance));
81   }
82 }
83 
84 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 library SafeMath {
91 
92   /**
93   * @dev Multiplies two numbers, throws on overflow.
94   */
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers, truncating the quotient.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   /**
115   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118     assert(b <= a);
119     return a - b;
120   }
121 
122   /**
123   * @dev Adds two numbers, throws on overflow.
124   */
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/179
138  */
139 contract ERC20Basic {
140   function totalSupply() public view returns (uint256);
141   function balanceOf(address who) public view returns (uint256);
142   function transfer(address to, uint256 value) public returns (bool);
143   event Transfer(address indexed from, address indexed to, uint256 value);
144 }
145 
146 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\BasicToken.sol
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   uint256 totalSupply_;
158 
159   /**
160   * @dev total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_to != address(0));
173     require(_value <= balances[msg.sender]);
174 
175     // SafeMath.sub will throw if there is not enough balance.
176     balances[msg.sender] = balances[msg.sender].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     Transfer(msg.sender, _to, _value);
179     return true;
180   }
181 
182   /**
183   * @dev Gets the balance of the specified address.
184   * @param _owner The address to query the the balance of.
185   * @return An uint256 representing the amount owned by the passed address.
186   */
187   function balanceOf(address _owner) public view returns (uint256 balance) {
188     return balances[_owner];
189   }
190 
191 }
192 
193 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\ERC20.sol
194 
195 /**
196  * @title ERC20 interface
197  * @dev see https://github.com/ethereum/EIPs/issues/20
198  */
199 contract ERC20 is ERC20Basic {
200   function allowance(address owner, address spender) public view returns (uint256);
201   function transferFrom(address from, address to, uint256 value) public returns (bool);
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 // File: node_modules\zeppelin-solidity\contracts\token\ERC20\StandardToken.sol
207 
208 /**
209  * @title Standard ERC20 token
210  *
211  * @dev Implementation of the basic standard token.
212  * @dev https://github.com/ethereum/EIPs/issues/20
213  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
214  */
215 contract StandardToken is ERC20, BasicToken {
216 
217   mapping (address => mapping (address => uint256)) internal allowed;
218 
219 
220   /**
221    * @dev Transfer tokens from one address to another
222    * @param _from address The address which you want to send tokens from
223    * @param _to address The address which you want to transfer to
224    * @param _value uint256 the amount of tokens to be transferred
225    */
226   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
227     require(_to != address(0));
228     require(_value <= balances[_from]);
229     require(_value <= allowed[_from][msg.sender]);
230 
231     balances[_from] = balances[_from].sub(_value);
232     balances[_to] = balances[_to].add(_value);
233     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
234     Transfer(_from, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    *
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(address _owner, address _spender) public view returns (uint256) {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * @dev Increase the amount of tokens that an owner allowed to a spender.
266    *
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
275     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
276     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    *
283    * approve should be called when allowed[_spender] == 0. To decrement
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _subtractedValue The amount of tokens to decrease the allowance by.
289    */
290   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 // File: contracts\token\GCToken.sol
304 
305 contract GCToken is StandardToken, HasNoEther {
306 
307     string constant public name = "GlobeCas";
308     string constant public symbol = "GCT";
309     uint8 constant public decimals = 8;
310     
311     event Mint(address indexed to, uint256 amount);
312     event Claim(address indexed from, uint256 amount);
313     
314     address constant public CROWDSALE_ACCOUNT    = 0x52e35C4FfFD6fcf550915C5eCafeE395860DDcD5;
315     address constant public COMPANY_ACCOUNT      = 0x7862a8f56C450866B4859EF391A85c535Df18c87;
316     address constant public PRIVATE_SALE_ACCOUNT = 0x66FA34A9c50873b344a24B662720B632ad8E1517;
317     address constant public TEAM_ACCOUNT         = 0x492C8b81D22Ad46b19419Df3D88Fd77b6850A9E4;
318     address constant public PROMOTION_ACCOUNT    = 0x067724fb3439B5c52267d1ddDb3047C037290756;
319 
320     // -------------------------------------------------- TOKENS  -----------------------------------------------------------------------------------------------------------------
321     uint constant public CAPPED_SUPPLY       = 20000000000e8; // maximum of GCT token
322     uint constant public TEAM_RESERVE        = 2000000000e8;  // total tokens team can claim - certain amount of GCT will mint for each claim stage
323     uint constant public COMPANY_RESERVE     = 8000000000e8;  // total tokens company reserve for - lock for 6 months than can mint this amount of GCT
324     uint constant public PRIVATE_SALE        = 900000000e8;   // total tokens for private sale
325     uint constant public PROMOTION_PROGRAM   = 1000000000e8;  // total tokens for promotion program -  405,000,000 for referral and  595,000,000 for bounty
326     uint constant public CROWDSALE_SUPPLY    = 8100000000e8;  // total tokens for crowdsale
327     // ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
328    
329    // is company already claimed reserve pool
330     bool public companyClaimed;
331 
332     // company reseved release minutes
333     uint constant public COMPANY_RESERVE_FOR = 182 days; // this equivalent to 6 months
334     
335     // team can start claiming tokens N days after ICO
336     uint constant public TEAM_CAN_CLAIM_AFTER = 120 days;// this equivalent to 4 months
337 
338     // period between each claim from team
339     uint constant public CLAIM_STAGE = 30 days;
340 
341     // the amount of token each stage team can claim
342     uint[] public teamReserve = [8658000e8, 17316000e8, 25974000e8, 34632000e8, 43290000e8, 51948000e8, 60606000e8, 69264000e8, 77922000e8, 86580000e8, 95238000e8, 103896000e8, 112554000e8, 121212000e8, 129870000e8, 138528000e8, 147186000e8, 155844000e8, 164502000e8, 173160000e8, 181820000e8];
343         
344     // Store the ico finish time 
345     uint public icoEndTime = 1540339199; // initial ico end date 23-Oct-2018(Subject to change)
346 
347     modifier canMint() {
348         require(totalSupply_ < CAPPED_SUPPLY);
349         _;
350     }
351 
352     function GCToken() public {
353         mint(PRIVATE_SALE_ACCOUNT, PRIVATE_SALE);
354         mint(PROMOTION_ACCOUNT, PROMOTION_PROGRAM);
355         mint(CROWDSALE_ACCOUNT, CROWDSALE_SUPPLY);
356     }
357 
358     function claimCompanyReserve () external {
359         require(!companyClaimed);
360         require(msg.sender == COMPANY_ACCOUNT);        
361         require(now >= icoEndTime.add(COMPANY_RESERVE_FOR));
362         mint(COMPANY_ACCOUNT, COMPANY_RESERVE);
363         companyClaimed = true;
364     }
365 
366     function claimTeamToken() external {
367         require(msg.sender == TEAM_ACCOUNT);
368         require(now >= icoEndTime.add(TEAM_CAN_CLAIM_AFTER));
369         require(teamReserve[20] > 0);
370 
371         // store time check for each claim stage
372         uint claimableTime = icoEndTime.add(TEAM_CAN_CLAIM_AFTER);
373         uint totalClaimable;
374 
375         for(uint i = 0; i < 21; i++){
376             if(teamReserve[i] > 0){
377                 // each month can claim the next stage starts from TEAM_CAN_CLAIM_AFTER
378                 if(claimableTime.add(i.mul(CLAIM_STAGE)) < now){
379                     totalClaimable = totalClaimable.add(teamReserve[i]);
380                     teamReserve[i] = 0;
381                 }else{
382                     break;
383                 }
384             }
385         }
386         if(totalClaimable > 0){
387             mint(TEAM_ACCOUNT, totalClaimable);
388         }
389     }
390     
391     
392     /**
393     * @dev Function to mint tokens referenced from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/CappedToken.sol
394     * @param _to The address that will receive the minted tokens.
395     * @param _amount The amount of tokens to mint.
396     * @return A boolean that indicates if the operation was successful.
397     */
398     function mint(address _to, uint256 _amount) canMint internal returns (bool) {
399         require(totalSupply_.add(_amount) <= CAPPED_SUPPLY);
400         totalSupply_ = totalSupply_.add(_amount);
401         balances[_to] = balances[_to].add(_amount);
402         emit Mint (_to, _amount);
403         return true;
404     }
405 
406     /**
407      * @dev Update the end of ICO time.
408      * @param _icoEndTime Expected ICO end time
409      */
410     function setIcoEndTime(uint _icoEndTime) public onlyOwner {
411         require(_icoEndTime >= now);
412         icoEndTime = _icoEndTime;
413     }
414 }
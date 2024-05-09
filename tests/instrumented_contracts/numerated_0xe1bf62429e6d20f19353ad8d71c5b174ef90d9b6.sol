1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 /**
219  * The Bitkom Token (BTT) has a fixed supply and restricts the ability
220  * to transfer tokens until the owner has called the enableTransfer()
221  * function.
222  *
223  * The owner can associate the token with a token sale contract. In that
224  * case, the token balance is moved to the token sale contract, which
225  * in turn can transfer its tokens to contributors to the sale.
226  */
227 contract BitkomToken is StandardToken, Ownable {
228 
229     // Constants
230     string  public constant name = "Bitkom Token";
231     string  public constant symbol = "BTT";
232     uint8   public constant decimals = 18;
233     uint256 public constant INITIAL_SUPPLY = 50000000 * 1 ether;
234     uint256 public constant CROWDSALE_ALLOWANCE =  33500000 * 1 ether;
235     uint256 public constant TEAM_ALLOWANCE =  16500000 * 1 ether;
236 
237     // Properties
238     uint256 public crowdsaleAllowance;               // the number of tokens available for crowdsales
239     uint256 public teamAllowance;               // the number of tokens available for the administrator
240     address public crowdsaleAddr;                    // the address of a crowdsale currently selling this token
241     address public teamAddr;                    // the address of the team account
242     bool    public transferEnabled = false;     // indicates if transferring tokens is enabled or not
243 
244     // Modifiers
245     modifier onlyWhenTransferEnabled() {
246         if (!transferEnabled) {
247             require(msg.sender == teamAddr || msg.sender == crowdsaleAddr);
248         }
249         _;
250     }
251 
252     // Events
253     event Burn(address indexed burner, uint256 value);
254 
255     /**
256      * The listed addresses are not valid recipients of tokens.
257      *
258      * 0x0           - the zero address is not valid
259      * this          - the contract itself should not receive tokens
260      * owner         - the owner has all the initial tokens, but cannot receive any back
261      * teamAddr      - the team has an allowance of tokens to transfer, but does not receive any
262      * crowdsaleAddr      - the sale has an allowance of tokens to transfer, but does not receive any
263      */
264     modifier validDestination(address _to) {
265         require(_to != address(0x0));
266         require(_to != address(this));
267         require(_to != owner);
268         require(_to != address(teamAddr));
269         require(_to != address(crowdsaleAddr));
270         _;
271     }
272 
273     /**
274      * Constructor - instantiates token supply and allocates balanace of
275      * to the owner (msg.sender).
276      */
277     function BitkomToken(address _team) public {
278         // the owner is a custodian of tokens that can
279         // give an allowance of tokens for crowdsales
280         // or to the admin, but cannot itself transfer
281         // tokens; hence, this requirement
282         require(msg.sender != _team);
283 
284         totalSupply = INITIAL_SUPPLY;
285         crowdsaleAllowance = CROWDSALE_ALLOWANCE;
286         teamAllowance = TEAM_ALLOWANCE;
287 
288         // mint all tokens
289         balances[msg.sender] = totalSupply;
290         Transfer(address(0x0), msg.sender, totalSupply);
291 
292         teamAddr = _team;
293         approve(teamAddr, teamAllowance);
294     }
295 
296     /**
297      * Associates this token with a current crowdsale, giving the crowdsale
298      * an allowance of tokens from the crowdsale supply. This gives the
299      * crowdsale the ability to call transferFrom to transfer tokens to
300      * whomever has purchased them.
301      *
302      * Note that if _amountForSale is 0, then it is assumed that the full
303      * remaining crowdsale supply is made available to the crowdsale.
304      *
305      * @param _crowdsaleAddr The address of a crowdsale contract that will sell this token
306      * @param _amountForSale The supply of tokens provided to the crowdsale
307      */
308     function setCrowdsale(address _crowdsaleAddr, uint256 _amountForSale) external onlyOwner {
309         require(!transferEnabled);
310         require(_amountForSale <= crowdsaleAllowance);
311 
312         // if 0, then full available crowdsale supply is assumed
313         uint amount = (_amountForSale == 0) ? crowdsaleAllowance : _amountForSale;
314 
315         // Clear allowance of old, and set allowance of new
316         approve(crowdsaleAddr, 0);
317         approve(_crowdsaleAddr, amount);
318 
319         crowdsaleAddr = _crowdsaleAddr;
320     }
321 
322     /**
323      * Enables the ability of anyone to transfer their tokens. This can
324      * only be called by the token owner. Once enabled, it is not
325      * possible to disable transfers.
326      */
327     function enableTransfer() external onlyOwner {
328         transferEnabled = true;
329         approve(crowdsaleAddr, 0);
330         approve(teamAddr, 0);
331         crowdsaleAllowance = 0;
332         teamAllowance = 0;
333     }
334 
335     /**
336      * Overrides ERC20 transfer function with modifier that prevents the
337      * ability to transfer tokens until after transfers have been enabled.
338      */
339     function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
340         return super.transfer(_to, _value);
341     }
342 
343     /**
344      * Overrides ERC20 transferFrom function with modifier that prevents the
345      * ability to transfer tokens until after transfers have been enabled.
346      */
347     function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled validDestination(_to) returns (bool) {
348         bool result = super.transferFrom(_from, _to, _value);
349         if (result) {
350             if (msg.sender == crowdsaleAddr)
351                 crowdsaleAllowance = crowdsaleAllowance.sub(_value);
352             if (msg.sender == teamAddr)
353                 teamAllowance = teamAllowance.sub(_value);
354         }
355         return result;
356     }
357 
358     /**
359      * @dev Burns a specific amount of tokens if msg.sender == owner
360      * or transferEnabled == true
361      * @param _value The amount of token to be burned.
362      */
363     function burn(uint256 _value) public {
364         require(_value > 0);
365         require(_value <= balances[msg.sender]);
366         require(transferEnabled || msg.sender == owner);
367         // no need to require value <= totalSupply, since that would imply the
368         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
369 
370         address burner = msg.sender;
371         balances[burner] = balances[burner].sub(_value);
372         totalSupply = totalSupply.sub(_value);
373         Burn(burner, _value);
374         Transfer(msg.sender, address(0x0), _value);
375     }
376 }
1 pragma solidity ^0.4.15;
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
40   function balanceOf(address who) constant returns (uint256);
41   function transfer(address to, uint256 value) returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) returns (bool) {
60     require(_to != address(0));
61 
62     // SafeMath.sub will throw if there is not enough balance.
63     balances[msg.sender] = balances[msg.sender].sub(_value);
64     balances[_to] = balances[_to].add(_value);
65     Transfer(msg.sender, _to, _value);
66     return true;
67   }
68 
69   /**
70   * @dev Gets the balance of the specified address.
71   * @param _owner The address to query the the balance of.
72   * @return An uint256 representing the amount owned by the passed address.
73   */
74   function balanceOf(address _owner) constant returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) returns (bool);
87   function approve(address spender, uint256 value) returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
110     require(_to != address(0));
111 
112     var _allowance = allowed[_from][msg.sender];
113 
114     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
115     // require (_value <= _allowance);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = _allowance.sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) returns (bool) {
130 
131     // To change the approve amount you first have to reduce the addresses`
132     //  allowance to zero by calling `approve(_spender, 0)` if it is not
133     //  already 0 to mitigate the race condition described here:
134     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136 
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 
152   /**
153    * approve should be called when allowed[_spender] == 0. To increment
154    * allowed value is better to use this function to avoid 2 calls (and wait until
155    * the first transaction is mined)
156    * From MonolithDAO Token.sol
157    */
158   function increaseApproval (address _spender, uint _addedValue)
159     returns (bool success) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   function decreaseApproval (address _spender, uint _subtractedValue)
166     returns (bool success) {
167     uint oldValue = allowed[msg.sender][_spender];
168     if (_subtractedValue > oldValue) {
169       allowed[msg.sender][_spender] = 0;
170     } else {
171       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172     }
173     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174     return true;
175   }
176 
177 }
178 
179 /**
180  * @title SimpleToken
181  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
182  * Note they can later distribute these tokens as they wish using `transfer` and other
183  * `StandardToken` functions.
184  */
185 contract OpportyToken is StandardToken {
186 
187   string public constant name = "OpportyToken";
188   string public constant symbol = "OPP";
189   uint8 public constant decimals = 18;
190 
191   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
192 
193   /**
194    * @dev Contructor that gives msg.sender all of existing tokens.
195    */
196   function OpportyToken() {
197     totalSupply = INITIAL_SUPPLY;
198     balances[msg.sender] = INITIAL_SUPPLY;
199   }
200 
201 }
202 
203 
204 /**
205  * @title Ownable
206  * @dev The Ownable contract has an owner address, and provides basic authorization control
207  * functions, this simplifies the implementation of "user permissions".
208  */
209 contract Ownable {
210   address public owner;
211 
212 
213   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   function Ownable() {
221     owner = msg.sender;
222   }
223 
224 
225   /**
226    * @dev Throws if called by any account other than the owner.
227    */
228   modifier onlyOwner() {
229     require(msg.sender == owner);
230     _;
231   }
232 
233 
234   /**
235    * @dev Allows the current owner to transfer control of the contract to a newOwner.
236    * @param newOwner The address to transfer ownership to.
237    */
238   function transferOwnership(address newOwner) onlyOwner public {
239     require(newOwner != address(0));
240     OwnershipTransferred(owner, newOwner);
241     owner = newOwner;
242   }
243 
244 }
245 
246 contract HoldPresaleContract is Ownable {
247   using SafeMath for uint256;
248   // Addresses and contracts
249   OpportyToken public OppToken;
250   address private presaleCont;
251 
252   struct Holder {
253     bool isActive;
254     uint tokens;
255     uint8 holdPeriod;
256     uint holdPeriodTimestamp;
257     bool withdrawed;
258   }
259 
260   mapping(address => Holder) public holderList;
261   mapping(uint => address) private holderIndexes;
262 
263   mapping (uint => address) private assetOwners;
264   mapping (address => uint) private assetOwnersIndex;
265   uint public assetOwnersIndexes;
266 
267   uint private holderIndex;
268 
269   event TokensTransfered(address contributor , uint amount);
270   event Hold(address sender, address contributor, uint amount, uint8 holdPeriod);
271 
272   modifier onlyAssetsOwners() {
273     require(assetOwnersIndex[msg.sender] > 0);
274     _;
275   }
276 
277   /* constructor */
278   function HoldPresaleContract(address _OppToken) {
279     OppToken = OpportyToken(_OppToken);
280   }
281 
282   function setPresaleCont(address pres)  public onlyOwner
283   {
284     presaleCont = pres;
285   }
286 
287   function addHolder(address holder, uint tokens, uint8 timed, uint timest) onlyAssetsOwners external {
288     if (holderList[holder].isActive == false) {
289       holderList[holder].isActive = true;
290       holderList[holder].tokens = tokens;
291       holderList[holder].holdPeriod = timed;
292       holderList[holder].holdPeriodTimestamp = timest;
293       holderIndexes[holderIndex] = holder;
294       holderIndex++;
295     } else {
296       holderList[holder].tokens += tokens;
297       holderList[holder].holdPeriod = timed;
298       holderList[holder].holdPeriodTimestamp = timest;
299     }
300     Hold(msg.sender, holder, tokens, timed);
301   }
302 
303   function getBalance() constant returns (uint) {
304     return OppToken.balanceOf(this);
305   }
306 
307   function unlockTokens() external {
308     address contributor = msg.sender;
309 
310     if (holderList[contributor].isActive && !holderList[contributor].withdrawed) {
311       if (now >= holderList[contributor].holdPeriodTimestamp) {
312         if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) {
313           holderList[contributor].withdrawed = true;
314           TokensTransfered(contributor,  holderList[contributor].tokens);
315         }
316       } else {
317         revert();
318       }
319     } else {
320       revert();
321     }
322   }
323 
324   function addAssetsOwner(address _owner) public onlyOwner {
325     assetOwnersIndexes++;
326     assetOwners[assetOwnersIndexes] = _owner;
327     assetOwnersIndex[_owner] = assetOwnersIndexes;
328   }
329   function removeAssetsOwner(address _owner) public onlyOwner {
330     uint index = assetOwnersIndex[_owner];
331     delete assetOwnersIndex[_owner];
332     delete assetOwners[index];
333     assetOwnersIndexes--;
334   }
335   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
336     return assetOwners[_index];
337   }
338 }
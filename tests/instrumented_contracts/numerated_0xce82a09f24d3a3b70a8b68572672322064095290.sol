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
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public view returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title Standard ERC20 token
97  *
98  * @dev Implementation of the basic standard token.
99  * @dev https://github.com/ethereum/EIPs/issues/20
100  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, BasicToken {
103 
104   mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107   /**
108    * @dev Transfer tokens from one address to another
109    * @param _from address The address which you want to send tokens from
110    * @param _to address The address which you want to transfer to
111    * @param _value uint256 the amount of tokens to be transferred
112    */
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[_from]);
116     require(_value <= allowed[_from][msg.sender]);
117 
118     balances[_from] = balances[_from].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
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
147   function allowance(address _owner, address _spender) public view returns (uint256) {
148     return allowed[_owner][_spender];
149   }
150 
151   /**
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    */
157   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164     uint oldValue = allowed[msg.sender][_spender];
165     if (_subtractedValue > oldValue) {
166       allowed[msg.sender][_spender] = 0;
167     } else {
168       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169     }
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174 }
175 
176 /**
177  * @title SimpleToken
178  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
179  * Note they can later distribute these tokens as they wish using `transfer` and other
180  * `StandardToken` functions.
181  */
182 contract OpportyToken is StandardToken {
183 
184   string public constant name = "OpportyToken";
185   string public constant symbol = "OPP";
186   uint8 public constant decimals = 18;
187 
188   uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));
189 
190   /**
191    * @dev Contructor that gives msg.sender all of existing tokens.
192    */
193   function OpportyToken() public {
194     totalSupply = INITIAL_SUPPLY;
195     balances[msg.sender] = INITIAL_SUPPLY;
196   }
197 
198 }
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
210 
211 
212   /**
213    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
214    * account.
215    */
216   function Ownable() public {
217     owner = msg.sender;
218   }
219 
220 
221   /**
222    * @dev Throws if called by any account other than the owner.
223    */
224   modifier onlyOwner() {
225     require(msg.sender == owner);
226     _;
227   }
228 
229 
230   /**
231    * @dev Allows the current owner to transfer control of the contract to a newOwner.
232    * @param newOwner The address to transfer ownership to.
233    */
234   function transferOwnership(address newOwner) public onlyOwner {
235     require(newOwner != address(0));
236     OwnershipTransferred(owner, newOwner);
237     owner = newOwner;
238   }
239 
240 }
241 
242 contract HoldSaleContract is Ownable {
243   using SafeMath for uint256;
244   // Addresses and contracts
245   OpportyToken public OppToken;
246 
247   struct Holder {
248     bool isActive;
249     uint tokens;
250     uint holdPeriodTimestamp;
251     bool withdrawed;
252   }
253 
254   mapping(address => Holder) public holderList;
255   mapping(uint => address) private holderIndexes;
256 
257   mapping (uint => address) private assetOwners;
258   mapping (address => uint) private assetOwnersIndex;
259   uint private assetOwnersIndexes;
260 
261   uint private holderIndex;
262   uint private holderWithdrawIndex;
263 
264   uint private tokenAddHold;
265   uint private tokenWithdrawHold;
266 
267   event TokensTransfered(address contributor , uint amount);
268   event Hold(address sender, address contributor, uint amount, uint holdPeriod);
269 
270   modifier onlyAssetsOwners() {
271     require(assetOwnersIndex[msg.sender] > 0);
272     _;
273   }
274 
275   /* constructor */
276   function HoldSaleContract(address _OppToken) public {
277     OppToken = OpportyToken(_OppToken);
278     addAssetsOwner(msg.sender);
279   }
280 
281   function addHolder(address holder, uint tokens, uint timest) onlyAssetsOwners external {
282     if (holderList[holder].isActive == false) {
283       holderList[holder].isActive = true;
284       holderList[holder].tokens = tokens;
285       holderList[holder].holdPeriodTimestamp = timest;
286       holderIndexes[holderIndex] = holder;
287       holderIndex++;
288     } else {
289       holderList[holder].tokens += tokens;
290       holderList[holder].holdPeriodTimestamp = timest;
291     }
292     tokenAddHold += tokens;
293     Hold(msg.sender, holder, tokens, timest);
294   }
295 
296   function getBalance() public constant returns (uint) {
297     return OppToken.balanceOf(this);
298   }
299 
300   function unlockTokens() external {
301     address contributor = msg.sender;
302 
303     if (holderList[contributor].isActive && !holderList[contributor].withdrawed) {
304       if (now >= holderList[contributor].holdPeriodTimestamp) {
305         if ( OppToken.transfer( msg.sender, holderList[contributor].tokens ) ) {
306           TokensTransfered(contributor,  holderList[contributor].tokens);
307           tokenWithdrawHold += holderList[contributor].tokens;
308           holderList[contributor].withdrawed = true;
309           holderWithdrawIndex++;
310         }
311       } else {
312         revert();
313       }
314     } else {
315       revert();
316     }
317   }
318 
319   function addAssetsOwner(address _owner) public onlyOwner {
320     assetOwnersIndexes++;
321     assetOwners[assetOwnersIndexes] = _owner;
322     assetOwnersIndex[_owner] = assetOwnersIndexes;
323   }
324   function removeAssetsOwner(address _owner) public onlyOwner {
325     uint index = assetOwnersIndex[_owner];
326     delete assetOwnersIndex[_owner];
327     delete assetOwners[index];
328     assetOwnersIndexes--;
329   }
330   function getAssetsOwners(uint _index) onlyOwner public constant returns (address) {
331     return assetOwners[_index];
332   }
333 
334   function getOverTokens() public onlyOwner {
335     require(getBalance() > (tokenAddHold - tokenWithdrawHold));
336     uint balance = getBalance() - (tokenAddHold - tokenWithdrawHold);
337     if(balance > 0) {
338       if(OppToken.transfer(msg.sender, balance)) {
339         TokensTransfered(msg.sender,  balance);
340       }
341     }
342   }
343 
344   function getTokenAddHold() onlyOwner public constant returns (uint) {
345     return tokenAddHold;
346   }
347   function getTokenWithdrawHold() onlyOwner public constant returns (uint) {
348     return tokenWithdrawHold;
349   }
350   function getHolderIndex() onlyOwner public constant returns (uint) {
351     return holderIndex;
352   }
353   function getHolderWithdrawIndex() onlyOwner public constant returns (uint) {
354     return holderWithdrawIndex;
355   }
356 }
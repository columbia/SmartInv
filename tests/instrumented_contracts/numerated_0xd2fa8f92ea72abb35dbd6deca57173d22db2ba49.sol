1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256)  {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72   
73   function max(uint256 a, uint256 b) internal pure returns (uint256) {
74     return a > b ? a : b;
75   }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   function totalSupply() public view returns (uint256);
85   function balanceOf(address who) public constant returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public constant returns (uint256);
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
110   uint256 totalSupply_;
111 
112 
113   /**
114   * @dev total number of tokens in existence
115   */
116   function totalSupply() public view returns (uint256) {
117     return totalSupply_;
118   }
119 
120   /**
121   * @dev transfer token for a specified address
122   * @param _to The address to transfer to.
123   * @param _value The amount to be transferred.
124   */
125   function transfer(address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public constant returns (uint256 balance) {
142     return balances[_owner];
143   }
144 }
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
165     require(_to != address(0));
166     require(_value <= balances[_from]);
167     require(_value <= allowed[_from][msg.sender]);
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    *
179    * Beware that changing an allowance with this method brings the risk that someone may use both the old
180    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
181    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
182    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183    * @param _spender The address which will spend the funds.
184    * @param _value The amount of tokens to be spent.
185    */
186   function approve(address _spender, uint256 _value) public returns (bool) {
187     allowed[msg.sender][_spender] = _value;
188     Approval(msg.sender, _spender, _value);
189     return true;
190   }
191 
192   /**
193    * @dev Function to check the amount of tokens that an owner allowed to a spender.
194    * @param _owner address The address which owns the funds.
195    * @param _spender address The address which will spend the funds.
196    * @return A uint256 specifying the amount of tokens still available for the spender.
197    */
198   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
199     return allowed[_owner][_spender];
200   }
201 
202   /**
203    * approve should be called when allowed[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    */
208   function increaseApproval (address _spender, uint _addedValue)
209     public
210     returns (bool success) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   function decreaseApproval (address _spender, uint _subtractedValue)
217   public
218     returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 }
229 
230 /**
231  * @title The OrigamiToken contract
232  * @dev The OrigamiToken Token contract
233  * @dev inherite from StandardToken and Ownable by Zeppelin
234  * @author ori.network
235  */
236 contract OrigamiToken is StandardToken, Ownable {
237     string  public  constant name = "Origami Network";
238     string  public  constant symbol = "ORI";
239     uint8    public  constant decimals = 18;
240 
241     uint    public  transferableStartTime;
242 
243     address public  tokenSaleContract;
244     address public  bountyWallet;
245 
246 
247     modifier onlyWhenTransferEnabled() 
248     {
249         if ( now <= transferableStartTime ) {
250             require(msg.sender == tokenSaleContract || msg.sender == bountyWallet || msg.sender == owner);
251         }
252         _;
253     }
254 
255     modifier validDestination(address to) 
256     {
257         require(to != address(this));
258         _;
259     }
260 
261     function OrigamiToken(
262         uint tokenTotalAmount, 
263         uint _transferableStartTime, 
264         address _admin, 
265         address _bountyWallet) public
266     {
267         // Mint all tokens. Then disable minting forever.
268         totalSupply_ = tokenTotalAmount * (10 ** uint256(decimals));
269 
270         // Send token to the contract
271         balances[msg.sender] = totalSupply_;
272         Transfer(address(0x0), msg.sender, totalSupply_);
273 
274         // Transferable start time will be set x days after sale end
275         transferableStartTime = _transferableStartTime;
276         // Keep the sale contrat to allow transfer from contract during the sale
277         tokenSaleContract = msg.sender;
278         //  Keep bounty wallet to distribute bounties before transfer is allowed
279         bountyWallet = _bountyWallet;
280 
281         transferOwnership(_admin); // admin could drain tokens and eth that were sent here by mistake
282     }
283 
284     /**
285      * @dev override transfer token for a specified address to add onlyWhenTransferEnabled and validDestination
286      * @param _to The address to transfer to.
287      * @param _value The amount to be transferred.
288      */
289     function transfer(address _to, uint _value)
290         public
291         validDestination(_to)
292         onlyWhenTransferEnabled
293         returns (bool) 
294     {
295         return super.transfer(_to, _value);
296     }
297 
298     /**
299      * @dev override transferFrom token for a specified address to add onlyWhenTransferEnabled and validDestination
300      * @param _from The address to transfer from.
301      * @param _to The address to transfer to.
302      * @param _value The amount to be transferred.
303      */
304     function transferFrom(address _from, address _to, uint _value)
305         public
306         validDestination(_to)
307         onlyWhenTransferEnabled
308         returns (bool) 
309     {
310         return super.transferFrom(_from, _to, _value);
311     }
312 
313     event Burn(address indexed _burner, uint _value);
314 
315     /**
316      * @dev burn tokens
317      * @param _value The amount to be burned.
318      * @return always true (necessary in case of override)
319      */
320     function burn(uint _value) 
321         public
322         onlyWhenTransferEnabled
323         returns (bool)
324     {
325         balances[msg.sender] = balances[msg.sender].sub(_value);
326         totalSupply_ = totalSupply_.sub(_value);
327         Burn(msg.sender, _value);
328         Transfer(msg.sender, address(0x0), _value);
329         return true;
330     }
331 
332     /**
333      * @dev burn tokens in the behalf of someone
334      * @param _from The address of the owner of the token.
335      * @param _value The amount to be burned.
336      * @return always true (necessary in case of override)
337      */
338     function burnFrom(address _from, uint256 _value) 
339         public
340         onlyWhenTransferEnabled
341         returns(bool) 
342     {
343         assert(transferFrom(_from, msg.sender, _value));
344         return burn(_value);
345     }
346 
347     /**
348      * @dev transfer to owner any tokens send by mistake on this contracts
349      * @param token The address of the token to transfer.
350      * @param amount The amount to be transfered.
351      */
352     function emergencyERC20Drain(ERC20 token, uint amount )
353         public
354         onlyOwner 
355     {
356         token.transfer(owner, amount);
357     }
358 }
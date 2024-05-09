1 pragma solidity ^0.4.11;
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
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of. 
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) returns (bool);
84   function approve(address spender, uint256 value) returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() {
163     owner = msg.sender;
164   }
165 
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     if (newOwner != address(0)) {
182       owner = newOwner;
183     }
184   }
185 
186 }
187 
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194 
195 contract MintableToken is StandardToken, Ownable {
196   event Mint(address indexed to, uint256 amount);
197   event MintFinished();
198 
199   bool public mintingFinished = false;
200 
201 
202   modifier canMint() {
203     require(!mintingFinished);
204     _;
205   }
206 
207   /**
208    * @dev Function to mint tokens
209    * @param _to The address that will recieve the minted tokens.
210    * @param _amount The amount of tokens to mint.
211    * @return A boolean that indicates if the operation was successful.
212    */
213   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
214     totalSupply = totalSupply.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     Mint(_to, _amount);
217     return true;
218   }
219 
220   /**
221    * @dev Function to stop minting new tokens.
222    * @return True if the operation was successful.
223    */
224   function finishMinting() onlyOwner returns (bool) {
225     mintingFinished = true;
226     MintFinished();
227     return true;
228   }
229 }
230 
231 contract StarTokenInterface is MintableToken {
232     // Cheatsheet of inherit methods and events
233     // function transferOwnership(address newOwner);
234     // function allowance(address owner, address spender) constant returns (uint256);
235     // function transfer(address _to, uint256 _value) returns (bool);
236     // function transferFrom(address from, address to, uint256 value) returns (bool);
237     // function approve(address spender, uint256 value) returns (bool);
238     // function increaseApproval (address _spender, uint _addedValue) returns (bool success);
239     // function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
240     // function finishMinting() returns (bool);
241     // function mint(address _to, uint256 _amount) returns (bool);
242     // event Approval(address indexed owner, address indexed spender, uint256 value);
243     // event Mint(address indexed to, uint256 amount);
244     // event MintFinished();
245 
246     // Custom methods and events
247     function toggleTransfer() returns (bool);
248     function toggleTransferFor(address _for) returns (bool);
249     event ToggleTransferAllowance(bool state);
250     event ToggleTransferAllowanceFor(address indexed who, bool state);
251 
252 
253 }
254 
255 contract AceToken is StarTokenInterface {
256     using SafeMath for uint;
257     using SafeMath for uint256;
258     
259     // ERC20 constants
260     string public constant name = "ACE Token";
261     string public constant symbol = "ACE";
262     uint public constant decimals = 0;
263 
264     // Minting constants
265     uint256 public constant MAXSOLD_SUPPLY = 99000000;
266     uint256 public constant HARDCAPPED_SUPPLY = 165000000;
267     
268     bool public transferAllowed = false;
269     mapping (address=>bool) public specialAllowed;
270 
271     event ToggleTransferAllowance(bool state);
272     event ToggleTransferAllowanceFor(address indexed who, bool state);
273 
274     modifier allowTransfer() {
275         require(transferAllowed || specialAllowed[msg.sender]);
276         _;
277     }
278 
279     /**
280     * @dev transfer token for a specified address if transfer is open
281     * @param _to The address to transfer to.
282     * @param _value The amount to be transferred.
283     */
284     function transfer(address _to, uint256 _value) allowTransfer returns (bool) {
285         return super.transfer(_to, _value);
286     }
287 
288     
289     /**
290     * @dev Transfer tokens from one address to another if transfer is open
291     * @param _from address The address which you want to send tokens from
292     * @param _to address The address which you want to transfer to
293     * @param _value uint256 the amount of tokens to be transferred
294      */
295     function transferFrom(address _from, address _to, uint256 _value) allowTransfer returns (bool) {
296         return super.transferFrom(_from, _to, _value);
297     }
298 
299     /**
300     * @dev Change current state of transfer allowence to opposite
301      */
302     function toggleTransfer() onlyOwner returns (bool) {
303         transferAllowed = !transferAllowed;
304         ToggleTransferAllowance(transferAllowed);
305         return transferAllowed;
306     }
307 
308     /**
309     * @dev allow transfer for the given address against global rules
310     * @param _for addres The address of special allowed transfer (required for smart contracts)
311      */
312     function toggleTransferFor(address _for) onlyOwner returns (bool) {
313         specialAllowed[_for] = !specialAllowed[_for];
314         ToggleTransferAllowanceFor(_for, specialAllowed[_for]);
315         return specialAllowed[_for];
316     }
317 
318     /**
319     * @dev Function to mint tokens for investor
320     * @param _to The address that will receive the minted tokens.
321     * @param _amount The amount of tokens to emit.
322     * @return A boolean that indicates if the operation was successful.
323     */
324     function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
325         require(_amount > 0);
326         
327         // create 2 extra token for each 3 sold
328         uint256 extra = _amount.div(3).mul(2);
329         uint256 total = _amount.add(extra);
330 
331         totalSupply = totalSupply.add(total);
332 
333         // Prevent to emit more than handcap!
334         assert(totalSupply <= HARDCAPPED_SUPPLY);
335     
336         balances[_to] = balances[_to].add(_amount);
337         balances[owner] = balances[owner].add(extra);
338 
339         Mint(_to, _amount);
340         Mint(owner, extra);
341 
342         Transfer(0x0, _to, _amount);
343         Transfer(0x0, owner, extra);
344 
345         return true;
346     }
347 
348     function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
349         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
350         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351         return true;
352     }
353 
354     function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
355         uint oldValue = allowed[msg.sender][_spender];
356         if (_subtractedValue > oldValue) {
357             allowed[msg.sender][_spender] = 0;
358         } else {
359             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
360         }
361         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
362         return true;
363     }
364 }
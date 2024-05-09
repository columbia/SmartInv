1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
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
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/MultipleOwners.sol
48 
49 contract MultipleOwners is Ownable {
50     struct Owner {
51         bool isOwner;
52         uint256 index;
53     }
54     mapping(address => Owner) public owners;
55     address[] public ownersLUT;
56 
57     modifier onlyOwner() {
58         require(msg.sender == owner || owners[msg.sender].isOwner);
59         _;
60     }
61 
62     function addOwner(address newOwner) public onlyOwner {
63         require(!owners[msg.sender].isOwner);
64         owners[newOwner] = Owner(true, ownersLUT.length);
65         ownersLUT.push(newOwner);
66     }
67 
68     function removeOwner(address _owner) public onlyOwner {
69         uint256 index = owners[_owner].index;
70         // order does not matter so move last element to the deleted index
71         ownersLUT[index] = ownersLUT[ownersLUT.length - 1];
72         // remove last element
73         ownersLUT.length--;
74         // remove Owner from mapping
75         delete owners[_owner];
76     }
77 }
78 
79 // File: zeppelin-solidity/contracts/math/SafeMath.sol
80 
81 /**
82  * @title SafeMath
83  * @dev Math operations with safety checks that throw on error
84  */
85 library SafeMath {
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0;
89     }
90     uint256 c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   uint256 public totalSupply;
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 // File: zeppelin-solidity/contracts/token/BasicToken.sol
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20.sol
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173   function allowance(address owner, address spender) public view returns (uint256);
174   function transferFrom(address from, address to, uint256 value) public returns (bool);
175   function approve(address spender, uint256 value) public returns (bool);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 // File: zeppelin-solidity/contracts/token/StandardToken.sol
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190   mapping (address => mapping (address => uint256)) internal allowed;
191 
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public view returns (uint256) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * approve should be called when allowed[_spender] == 0. To increment
239    * allowed value is better to use this function to avoid 2 calls (and wait until
240    * the first transaction is mined)
241    * From MonolithDAO Token.sol
242    */
243   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 // File: zeppelin-solidity/contracts/token/MintableToken.sol
263 
264 /**
265  * @title Mintable token
266  * @dev Simple ERC20 Token example, with mintable token creation
267  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
268  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
269  */
270 
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply = totalSupply.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     Mint(_to, _amount);
293     Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     MintFinished();
304     return true;
305   }
306 }
307 
308 // File: contracts/Hydrocoin.sol
309 
310 contract Hydrocoin is MintableToken, MultipleOwners {
311     string public name = "HydroCoin";
312     string public symbol = "HYC";
313     uint8 public decimals = 18;
314 
315     // maximum supply
316     uint256 public hardCap = 1000000000 ether;
317 
318     // transfer freeze for team token until September 30th, 2019
319     uint256 public teamTransferFreeze;
320     address public founders;
321 
322     function Hydrocoin(address _paymentContract, uint256 _teamTransferFreeze, address _founders)
323         public
324     {
325         // current total supply
326         totalSupply = 500100000 ether;
327         teamTransferFreeze = _teamTransferFreeze;
328         founders = _founders;
329         // fundation address, gas station reserve,team
330         balances[founders] = balances[founders].add(500000000 ether);
331         Transfer(0x0, founders, 500000000 ether);
332 
333         // payment contract
334         balances[_paymentContract] = balances[_paymentContract].add(100000 ether);
335         Transfer(0x0, _paymentContract, 100000 ether);
336     }
337 
338     modifier canMint() {
339         require(!mintingFinished);
340         _;
341         assert(totalSupply <= hardCap);
342     }
343 
344     modifier validateTrasfer() {
345         _;
346         assert(balances[founders] >= 100000000 ether || teamTransferFreeze < now);
347     }
348 
349     function transfer(address _to, uint256 _value) public validateTrasfer returns (bool) {
350         super.transfer(_to, _value);
351     }
352 
353 }
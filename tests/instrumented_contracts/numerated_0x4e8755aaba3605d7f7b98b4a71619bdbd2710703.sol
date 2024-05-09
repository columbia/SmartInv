1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
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
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public view returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) internal balances;
57 
58   /**
59    * @dev Fix for the ERC20 short address attack.
60    */
61   modifier onlyPayloadSize(uint size) {
62     assert(msg.data.length >= size + 4);
63     _;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     emit Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/20
96  */
97 contract ERC20 is ERC20Basic {
98   function allowance(address owner, address spender) public view returns (uint256);
99   function transferFrom(address from, address to, uint256 value) public returns (bool);
100   function approve(address spender, uint256 value) public returns (bool);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood:
110         https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
111  */
112 contract StandardToken is ERC20, BasicToken {
113 
114   mapping (address => mapping (address => uint256)) internal allowed;
115 
116   /**
117    * approve should be called when allowed[_spender] == 0. To increment
118    * allowed value is better to use this function to avoid 2 calls (and wait until
119    * the first transaction is mined)
120    * From MonolithDAO Token.sol
121    */
122   function increaseApproval(address _spender, uint _addedValue) external onlyPayloadSize(2 * 32) returns (bool) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   function decreaseApproval(address _spender, uint _subtractedValue) external onlyPayloadSize(2 * 32) returns (bool) {
129     uint oldValue = allowed[msg.sender][_spender];
130     if (_subtractedValue > oldValue) {
131         allowed[msg.sender][_spender] = 0;
132     } else {
133         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
134     }
135     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(
146     address _from,
147     address _to,
148     uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     emit Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 }
186 
187 contract Owners {
188 
189   mapping (address => bool) public owners;
190   uint public ownersCount;
191   uint public minOwnersRequired = 2;
192 
193   event OwnerAdded(address indexed owner);
194   event OwnerRemoved(address indexed owner);
195 
196   /**
197    * @dev initializes contract
198    * @param withDeployer bool indicates whether deployer is part of owners
199    */
200   constructor(bool withDeployer) public {
201     if (withDeployer) {
202       ownersCount++;
203       owners[msg.sender] = true;
204     }
205     owners[0x23B599A0949C6147E05C267909C16506C7eFF229] = true;
206     owners[0x286A70B3E938FCa244208a78B1823938E8e5C174] = true;
207     ownersCount = ownersCount + 2;
208   }
209 
210   /**
211    * @dev adds owner, can only by done by owners only
212    * @param _address address the address to be added
213    */
214   function addOwner(address _address) public ownerOnly {
215     require(_address != address(0));
216     owners[_address] = true;
217     ownersCount++;
218     emit OwnerAdded(_address);
219   }
220 
221   /**
222    * @dev removes owner, can only by done by owners only
223    * @param _address address the address to be removed
224    */
225   function removeOwner(address _address) public ownerOnly notOwnerItself(_address) minOwners {
226     require(owners[_address] == true);
227     owners[_address] = false;
228     ownersCount--;
229     emit OwnerRemoved(_address);
230   }
231 
232   /**
233    * @dev checks if sender is owner
234    */
235   modifier ownerOnly {
236     require(owners[msg.sender]);
237     _;
238   }
239 
240   modifier notOwnerItself(address _owner) {
241     require(msg.sender != _owner);
242     _;
243   }
244 
245   modifier minOwners {
246     require(ownersCount > minOwnersRequired);
247     _;
248   }
249 
250 }
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 contract MintableToken is StandardToken, Owners(true) {
259   event Mint(address indexed to, uint256 amount);
260   event MintFinished();
261   event MintStarted();
262 
263   bool public mintingFinished = false;
264 
265   modifier canMint() {
266     require(!mintingFinished);
267     _;
268   }
269 
270   /**
271    * @dev Function to mint tokens
272    * @param _to The address that will receive the minted tokens.
273    * @param _amount The amount of tokens to mint.
274    * @return A boolean that indicates if the operation was successful.
275    */
276   function mint(address _to, uint256 _amount) external ownerOnly canMint onlyPayloadSize(2 * 32) returns (bool) {
277     return internalMint(_to, _amount);
278   }
279 
280   /**
281    * @dev Function to stop minting new tokens.
282    * @return True if the operation was successful.
283    */
284   function finishMinting() public ownerOnly canMint returns (bool) {
285     mintingFinished = true;
286     emit MintFinished();
287     return true;
288   }
289 
290   /**
291    * @dev Function to start minting new tokens.
292    * @return True if the operation was successful.
293    */
294   function startMinting() public ownerOnly returns (bool) {
295     mintingFinished = false;
296     emit MintStarted();
297     return true;
298   }
299 
300   function internalMint(address _to, uint256 _amount) internal returns (bool) {
301     totalSupply = totalSupply.add(_amount);
302     balances[_to] = balances[_to].add(_amount);
303     emit Mint(_to, _amount);
304     emit Transfer(address(0), _to, _amount);
305     return true;
306   }
307 }
308 
309 contract REIDAOMintableToken is MintableToken {
310 
311   uint public decimals = 8;
312 
313   bool public tradingStarted = false;
314 
315   /**
316   * @dev transfer token for a specified address
317   * @param _to The address to transfer to.
318   * @param _value The amount to be transferred.
319   */
320   function transfer(address _to, uint _value) public canTrade returns (bool) {
321     return super.transfer(_to, _value);
322   }
323 
324   /**
325    * @dev Transfer tokens from one address to another
326    * @param _from address The address which you want to send tokens from
327    * @param _to address The address which you want to transfer to
328    * @param _value uint256 the amount of tokens to be transferred
329    */
330   function transferFrom(address _from, address _to, uint _value) public canTrade returns (bool) {
331     return super.transferFrom(_from, _to, _value);
332   }
333 
334   /**
335    * @dev modifier that throws if trading has not started yet
336    */
337   modifier canTrade() {
338     require(tradingStarted);
339     _;
340   }
341 
342   /**
343    * @dev Allows the owner to enable the trading. Done only once.
344    */
345   function startTrading() public ownerOnly {
346     tradingStarted = true;
347   }
348 }
349 
350 contract REIToken is REIDAOMintableToken {
351   string public name = "REIDAO Membership";
352   string public symbol = "REI";
353 }
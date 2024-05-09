1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 
20 
21 /**
22  * @title ERC20Basic
23  * @dev Simpler version of ERC20 interface
24  * @dev see https://github.com/ethereum/EIPs/issues/179
25  */
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) public constant returns (uint256);
29   function transfer(address to, uint256 value) public returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal constant returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal constant returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
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
83 
84     // SafeMath.sub will throw if there is not enough balance.
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) public constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 
104 
105 
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender) public constant returns (uint256);
113   function transferFrom(address from, address to, uint256 value) public returns (bool);
114   function approve(address spender, uint256 value) public returns (bool);
115   event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140 
141     uint256 _allowance = allowed[_from][msg.sender];
142 
143     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
144     // require (_value <= _allowance);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = _allowance.sub(_value);
149     Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint256 specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * approve should be called when allowed[_spender] == 0. To increment
181    * allowed value is better to use this function to avoid 2 calls (and wait until
182    * the first transaction is mined)
183    * From MonolithDAO Token.sol
184    */
185   function increaseApproval (address _spender, uint _addedValue)
186     returns (bool success) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   function decreaseApproval (address _spender, uint _subtractedValue)
193     returns (bool success) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 
207 
208 /**
209  * Standard EIP-20 token with an interface marker.
210  *
211  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
212  *
213  */
214 contract StandardTokenExt is StandardToken {
215 
216   /* Interface declaration */
217   function isToken() public constant returns (bool weAre) {
218     return true;
219   }
220 }
221 
222 
223 
224 /**
225  * @title Ownable
226  * @dev The Ownable contract has an owner address, and provides basic authorization control
227  * functions, this simplifies the implementation of "user permissions".
228  */
229 contract Ownable {
230   address public owner;
231 
232 
233   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235 
236   /**
237    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
238    * account.
239    */
240   function Ownable() {
241     owner = msg.sender;
242   }
243 
244 
245   /**
246    * @dev Throws if called by any account other than the owner.
247    */
248   modifier onlyOwner() {
249     require(msg.sender == owner);
250     _;
251   }
252 
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) onlyOwner public {
259     require(newOwner != address(0));
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262   }
263 
264 }
265 
266 
267 /**
268  * Issuer manages token distribution after the crowdsale.
269  *
270  * This contract is fed a CSV file with Ethereum addresses and their
271  * issued token balances.
272  *
273  * Issuer act as a gate keeper to ensure there is no double issuance
274  * per address, in the case we need to do several issuance batches,
275  * there is a race condition or there is a fat finger error.
276  *
277  * Issuer contract gets allowance from the team multisig to distribute tokens.
278  *
279  */
280 contract Issuer is Ownable {
281 
282   /** Map addresses whose tokens we have already issued. */
283   mapping(address => bool) public issued;
284 
285   /** Centrally issued token we are distributing to our contributors */
286   StandardTokenExt public token;
287 
288   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
289   address public allower;
290 
291   /** How many addresses have received their tokens. */
292   uint public issuedCount;
293 
294   function Issuer(address _owner, address _allower, StandardTokenExt _token) {
295     owner = _owner;
296     allower = _allower;
297     token = _token;
298   }
299 
300   function issue(address benefactor, uint amount) onlyOwner {
301     if(issued[benefactor]) throw;
302     token.transferFrom(allower, benefactor, amount);
303     issued[benefactor] = true;
304     issuedCount += amount;
305   }
306 
307 }
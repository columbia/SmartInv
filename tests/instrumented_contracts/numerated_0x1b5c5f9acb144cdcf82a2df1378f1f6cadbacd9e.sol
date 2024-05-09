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
28   function balanceOf(address who) constant returns (uint256);
29   function transfer(address to, uint256 value) returns (bool);
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
81   function transfer(address _to, uint256 _value) returns (bool) {
82     balances[msg.sender] = balances[msg.sender].sub(_value);
83     balances[_to] = balances[_to].add(_value);
84     Transfer(msg.sender, _to, _value);
85     return true;
86   }
87 
88   /**
89   * @dev Gets the balance of the specified address.
90   * @param _owner The address to query the the balance of. 
91   * @return An uint256 representing the amount owned by the passed address.
92   */
93   function balanceOf(address _owner) constant returns (uint256 balance) {
94     return balances[_owner];
95   }
96 
97 }
98 
99 
100 
101 
102 
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) constant returns (uint256);
110   function transferFrom(address from, address to, uint256 value) returns (bool);
111   function approve(address spender, uint256 value) returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) returns (bool) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifing the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 
179 
180 /**
181  * Standard EIP-20 token with an interface marker.
182  *
183  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
184  *
185  */
186 contract StandardTokenExt is StandardToken {
187 
188   /* Interface declaration */
189   function isToken() public constant returns (bool weAre) {
190     return true;
191   }
192 }
193 
194 
195 
196 /**
197  * @title Ownable
198  * @dev The Ownable contract has an owner address, and provides basic authorization control
199  * functions, this simplifies the implementation of "user permissions".
200  */
201 contract Ownable {
202   address public owner;
203 
204 
205   /**
206    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
207    * account.
208    */
209   function Ownable() {
210     owner = msg.sender;
211   }
212 
213 
214   /**
215    * @dev Throws if called by any account other than the owner.
216    */
217   modifier onlyOwner() {
218     require(msg.sender == owner);
219     _;
220   }
221 
222 
223   /**
224    * @dev Allows the current owner to transfer control of the contract to a newOwner.
225    * @param newOwner The address to transfer ownership to.
226    */
227   function transferOwnership(address newOwner) onlyOwner {
228     require(newOwner != address(0));      
229     owner = newOwner;
230   }
231 
232 }
233 
234 
235 /**
236  * Issuer manages token distribution after the crowdsale.
237  *
238  * This contract is fed a CSV file with Ethereum addresses and their
239  * issued token balances.
240  *
241  * Issuer act as a gate keeper to ensure there is no double issuance
242  * per ID number, in the case we need to do several issuance batches,
243  * there is a race condition or there is a fat finger error.
244  *
245  * Issuer contract gets allowance from the team multisig to distribute tokens.
246  *
247  */
248 contract IssuerWithId is Ownable {
249 
250   /** Map IDs whose tokens we have already issued. */
251   mapping(uint => bool) public issued;
252 
253   /** Centrally issued token we are distributing to our contributors */
254   StandardTokenExt public token;
255 
256   /** Party (team multisig) who is in the control of the token pool. Note that this will be different from the owner address (scripted) that calls this contract. */
257   address public allower;
258 
259   /** How many addresses have received their tokens. */
260   uint public issuedCount;
261 
262   function IssuerWithId(address _owner, address _allower, StandardTokenExt _token) {
263     require(address(_owner) != address(0));
264     require(address(_allower) != address(0));
265     require(address(_token) != address(0));
266 
267     owner = _owner;
268     allower = _allower;
269     token = _token;
270   }
271 
272   function issue(address benefactor, uint amount, uint id) onlyOwner {
273     if(issued[id]) throw;
274     token.transferFrom(allower, benefactor, amount);
275     issued[id] = true;
276     issuedCount += amount;
277   }
278 
279 }
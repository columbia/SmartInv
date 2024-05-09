1 pragma solidity ^0.4.24;
2 /*
3 
4   Copyright 2018 InterValue Foundation.
5 
6   Licensed under the Apache License, Version 2.0 (the "License");
7   you may not use this file except in compliance with the License.
8   You may obtain a copy of the License at
9 
10   http://www.apache.org/licenses/LICENSE-2.0
11 
12   Unless required by applicable law or agreed to in writing, software
13   distributed under the License is distributed on an "AS IS" BASIS,
14   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15   See the License for the specific language governing permissions and
16   limitations under the License.
17 
18 */
19 
20 /**
21  * Math operations with safety checks
22  */
23 library SafeMath {
24   function mul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b); //The first number should not be zero
27     return c;
28   }
29 
30   function div(uint a, uint b) internal returns (uint) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 
64   function assert(bool assertion) internal {
65     if (!assertion) {
66       throw;
67     }
68   }
69 }
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/20
75  */
76 contract ERC20Basic {
77   uint public totalSupply;
78   function balanceOf(address who) constant returns (uint);
79   function transfer(address to, uint value);
80   event Transfer(address indexed from, address indexed to, uint value);
81   
82   function allowance(address owner, address spender) constant returns (uint);
83   function transferFrom(address from, address to, uint value);
84   function approve(address spender, uint value);
85   event Approval(address indexed owner, address indexed spender, uint value);
86 }
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances. 
91  */
92 contract BasicToken is ERC20Basic {
93   using SafeMath for uint;
94     
95   /// This is where we hold INVE token and the only address from which
96   /// `issue token` can be invocated.
97   ///
98   /// Note: this will be initialized during the contract deployment.
99   address public owner;
100   
101   /// This is a switch to control the liquidity of INVE
102   bool public transferable = true;
103   
104   mapping(address => uint) balances;
105 
106   //The frozen accounts 
107   mapping (address => bool) public frozenAccount;
108   /**
109    * @dev Fix for the ERC20 short address attack.
110    */
111   modifier onlyPayloadSize(uint size) {
112      if(msg.data.length < size + 4) {
113        throw;
114      }
115      _;
116   }
117   
118   modifier unFrozenAccount{
119       require(!frozenAccount[msg.sender]);
120       _;
121   }
122   
123   modifier onlyOwner {
124       if (owner == msg.sender) {
125           _;
126       } else {
127           InvalidCaller(msg.sender);
128           throw;
129         }
130   }
131   
132   modifier onlyTransferable {
133       if (transferable) {
134           _;
135       } else {
136           LiquidityAlarm("The liquidity of INVE is switched off");
137           throw;
138       }
139   }
140   /**
141   *EVENTS
142   */
143   /// Emitted when the target account is frozen
144   event FrozenFunds(address target, bool frozen);
145   
146   /// Emitted when a function is invocated by unauthorized addresses.
147   event InvalidCaller(address caller);
148 
149   /// Emitted when some INVE coins are burn.
150   event Burn(address caller, uint value);
151   
152   /// Emitted when the ownership is transferred.
153   event OwnershipTransferred(address indexed from, address indexed to);
154   
155   /// Emitted if the account is invalid for transaction.
156   event InvalidAccount(address indexed addr, bytes msg);
157   
158   /// Emitted when the liquity of INVE is switched off
159   event LiquidityAlarm(bytes msg);
160   
161   /**
162   * @dev transfer token for a specified address
163   * @param _to The address to transfer to.
164   * @param _value The amount to be transferred.
165   */
166   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) unFrozenAccount onlyTransferable {
167     if (frozenAccount[_to]) {
168         InvalidAccount(_to, "The receiver account is frozen");
169     } else {
170         balances[msg.sender] = balances[msg.sender].sub(_value);
171         balances[_to] = balances[_to].add(_value);
172         Transfer(msg.sender, _to, _value);
173     }
174     
175   }
176 
177   /**
178   * @dev Gets the balance of the specified address.
179   * @param _owner The address to query the the balance of. 
180   * @return An uint representing the amount owned by the passed address.
181   */
182   function balanceOf(address _owner) view returns (uint balance) {
183     return balances[_owner];
184   }
185 
186   ///@notice `freeze? Prevent | Allow` `target` from sending & receiving INVE preconditions
187   ///@param target Address to be frozen
188   ///@param freeze To freeze the target account or not
189   function freezeAccount(address target, bool freeze) onlyOwner public {
190       frozenAccount[target]=freeze;
191       FrozenFunds(target, freeze);
192     }
193   
194   function accountFrozenStatus(address target) view returns (bool frozen) {
195       return frozenAccount[target];
196   }
197   
198   function transferOwnership(address newOwner) onlyOwner public {
199       if (newOwner != address(0)) {
200           address oldOwner=owner;
201           owner = newOwner;
202           OwnershipTransferred(oldOwner, owner);
203         }
204   }
205   
206   function switchLiquidity (bool _transferable) onlyOwner returns (bool success) {
207       transferable=_transferable;
208       return true;
209   }
210   
211   function liquidityStatus () view returns (bool _transferable) {
212       return transferable;
213   }
214 }
215 
216 /**
217  * @title Standard ERC20 token
218  *
219  * @dev Implemantation of the basic standart token.
220  * @dev https://github.com/ethereum/EIPs/issues/20
221  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
222  */
223 contract StandardToken is BasicToken {
224 
225   mapping (address => mapping (address => uint)) allowed;
226 
227 
228   /**
229    * @dev Transfer tokens from one address to another
230    * @param _from address The address which you want to send tokens from
231    * @param _to address The address which you want to transfer to
232    * @param _value uint the amout of tokens to be transfered
233    */
234   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) unFrozenAccount onlyTransferable{
235     var _allowance = allowed[_from][msg.sender];
236 
237     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
238     // if (_value > _allowance) throw;
239     
240     // Check account _from and _to is not frozen
241     require(!frozenAccount[_from]&&!frozenAccount[_to]);
242     
243     balances[_to] = balances[_to].add(_value);
244     balances[_from] = balances[_from].sub(_value);
245     allowed[_from][msg.sender] = _allowance.sub(_value);
246     Transfer(_from, _to, _value);
247   }
248 
249   /**
250    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint _value) unFrozenAccount {
255 
256     // To change the approve amount you first have to reduce the addresses`
257     //  allowance to zero by calling `approve(_spender, 0)` if it is not
258     //  already 0 to mitigate the race condition described here:
259     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
261 
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264   }
265 
266   /**
267    * @dev Function to check the amount of tokens than an owner allowed to a spender.
268    * @param _owner address The address which owns the funds.
269    * @param _spender address The address which will spend the funds.
270    * @return A uint specifing the amount of tokens still avaible for the spender.
271    */
272   function allowance(address _owner, address _spender) view returns (uint remaining) {
273     return allowed[_owner][_spender];
274   }
275   
276 }
277 
278 /// @title InterValue Protocol Token.
279 /// For more information about this token, please visit http://inve.one
280 contract INVEToken is StandardToken {
281     string public name = "InterValue";
282     string public symbol = "INVE";
283     uint public decimals = 18;
284 
285     /**
286      * CONSTRUCTOR 
287      * 
288      * @dev Initialize the INVE Coin
289      * @param _owner The escrow account address, all ethers will
290      * be sent to this address.
291      * This address will be : 0x...
292      */
293     function INVEToken(address _owner) {
294         owner = _owner;
295         totalSupply = 40 * 10 ** 26;
296         balances[owner] = totalSupply;
297     }
298 
299     /*
300      * PUBLIC FUNCTIONS
301      */
302 
303     /// @dev This default function allows token to be purchased by directly
304     /// sending ether to this smart contract.
305     function () public payable {
306         revert();
307     }
308 }
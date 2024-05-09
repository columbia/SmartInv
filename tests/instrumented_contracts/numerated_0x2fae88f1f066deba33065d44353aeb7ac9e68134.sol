1 pragma solidity ^0.4.24;
2 
3 /*
4 
5   Copyright 2018 InterValue Foundation.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11   http://www.apache.org/licenses/LICENSE-2.0
12 
13   Unless required by applicable law or agreed to in writing, software
14   distributed under the License is distributed on an "AS IS" BASIS,
15   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
16   See the License for the specific language governing permissions and
17   limitations under the License.
18 
19 */
20 
21 /**
22  * Math operations with safety checks
23  */
24 library SafeMath {
25   function mul(uint a, uint b) internal returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b); //The first number should not be zero
28     return c;
29   }
30 
31   function div(uint a, uint b) internal returns (uint) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint a, uint b) internal returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint a, uint b) internal returns (uint) {
44     uint c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a < b ? a : b;
63   }
64 
65   function assert(bool assertion) internal {
66     if (!assertion) {
67       throw;
68     }
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/20
76  */
77 contract ERC20Basic {
78   uint public totalSupply;
79   function balanceOf(address who) constant returns (uint);
80   function transfer(address to, uint value);
81   event Transfer(address indexed from, address indexed to, uint value);
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) constant returns (uint);
90   function transferFrom(address from, address to, uint value);
91   function approve(address spender, uint value);
92   event Approval(address indexed owner, address indexed spender, uint value);
93 }
94 
95 /**
96  * @title Basic token
97  * @dev Basic version of StandardToken, with no allowances. 
98  */
99 contract BasicToken is ERC20Basic {
100   using SafeMath for uint;
101     
102   /// This is where we hold INVE token and the only address from which
103   /// `issue token` can be invocated.
104   ///
105   /// Note: this will be initialized during the contract deployment.
106   address public owner;
107   
108   /// This is a switch to control the liquidity of INVE
109   bool public transferable = true;
110   
111   mapping(address => uint) balances;
112 
113   //The frozen accounts 
114   mapping (address => bool) public frozenAccount;
115   /**
116    * @dev Fix for the ERC20 short address attack.
117    */
118   modifier onlyPayloadSize(uint size) {
119      if(msg.data.length < size + 4) {
120        throw;
121      }
122      _;
123   }
124   
125   modifier unFrozenAccount{
126       require(!frozenAccount[msg.sender]);
127       _;
128   }
129   
130   modifier onlyOwner {
131       if (owner == msg.sender) {
132           _;
133       } else {
134           InvalidCaller(msg.sender);
135           throw;
136         }
137   }
138   
139   modifier onlyTransferable {
140       if (transferable) {
141           _;
142       } else {
143           LiquidityAlarm("The liquidity of INVE is switched off");
144           throw;
145       }
146   }
147   /**
148   *EVENTS
149   */
150   /// Emitted when the target account is frozen
151   event FrozenFunds(address target, bool frozen);
152   
153   /// Emitted when a function is invocated by unauthorized addresses.
154   event InvalidCaller(address caller);
155 
156   /// Emitted when some INVE coins are burn.
157   event Burn(address caller, uint value);
158   
159   /// Emitted when the ownership is transferred.
160   event OwnershipTransferred(address indexed from, address indexed to);
161   
162   /// Emitted if the account is invalid for transaction.
163   event InvalidAccount(address indexed addr, bytes msg);
164   
165   /// Emitted when the liquity of INVE is switched off
166   event LiquidityAlarm(bytes msg);
167   
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) unFrozenAccount onlyTransferable {
174     if (frozenAccount[_to]) {
175         InvalidAccount(_to, "The receiver account is frozen");
176     } else {
177         balances[msg.sender] = balances[msg.sender].sub(_value);
178         balances[_to] = balances[_to].add(_value);
179         Transfer(msg.sender, _to, _value);
180     }
181     
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of. 
187   * @return An uint representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) view returns (uint balance) {
190     return balances[_owner];
191   }
192 
193   ///@notice `freeze? Prevent | Allow` `target` from sending & receiving INVE preconditions
194   ///@param target Address to be frozen
195   ///@param freeze To freeze the target account or not
196   function freezeAccount(address target, bool freeze) onlyOwner public {
197       frozenAccount[target]=freeze;
198       FrozenFunds(target, freeze);
199     }
200   
201   function accountFrozenStatus(address target) view returns (bool frozen) {
202       return frozenAccount[target];
203   }
204   
205   function transferOwnership(address newOwner) onlyOwner public {
206       if (newOwner != address(0)) {
207           address oldOwner=owner;
208           owner = newOwner;
209           OwnershipTransferred(oldOwner, owner);
210         }
211   }
212   
213   function switchLiquidity (bool _transferable) onlyOwner returns (bool success) {
214       transferable=_transferable;
215       return true;
216   }
217   
218   function liquidityStatus () view returns (bool _transferable) {
219       return transferable;
220   }
221 }
222 
223 /**
224  * @title Standard ERC20 token
225  *
226  * @dev Implemantation of the basic standart token.
227  * @dev https://github.com/ethereum/EIPs/issues/20
228  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
229  */
230 contract StandardToken is BasicToken, ERC20 {
231 
232   mapping (address => mapping (address => uint)) allowed;
233 
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint the amout of tokens to be transfered
240    */
241   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) unFrozenAccount onlyTransferable{
242     var _allowance = allowed[_from][msg.sender];
243 
244     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
245     // if (_value > _allowance) throw;
246     
247     // Check account _from and _to is not frozen
248     require(!frozenAccount[_from]&&!frozenAccount[_to]);
249     
250     balances[_to] = balances[_to].add(_value);
251     balances[_from] = balances[_from].sub(_value);
252     allowed[_from][msg.sender] = _allowance.sub(_value);
253     Transfer(_from, _to, _value);
254   }
255 
256   /**
257    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint _value) unFrozenAccount {
262 
263     // To change the approve amount you first have to reduce the addresses`
264     //  allowance to zero by calling `approve(_spender, 0)` if it is not
265     //  already 0 to mitigate the race condition described here:
266     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
268 
269     allowed[msg.sender][_spender] = _value;
270     Approval(msg.sender, _spender, _value);
271   }
272 
273   /**
274    * @dev Function to check the amount of tokens than an owner allowed to a spender.
275    * @param _owner address The address which owns the funds.
276    * @param _spender address The address which will spend the funds.
277    * @return A uint specifing the amount of tokens still avaible for the spender.
278    */
279   function allowance(address _owner, address _spender) view returns (uint remaining) {
280     return allowed[_owner][_spender];
281   }
282   
283 }
284 
285 /// @title InterValue Protocol Token.
286 /// For more information about this token, please visit http://inve.one
287 contract INVEToken is StandardToken {
288     string public constant NAME = "InterValue";
289     string public constant SYMBOL = "INVE";
290     uint public constant DECIMALS = 18;
291 
292     /**
293      * CONSTRUCTOR 
294      * 
295      * @dev Initialize the INVE Coin
296      * @param _owner The escrow account address, all ethers will
297      * be sent to this address.
298      * This address will be : 0x...
299      */
300     function INVEToken(address _owner) {
301         owner = _owner;
302         totalSupply = 40 * 10 ** 26;
303         balances[owner] = totalSupply;
304     }
305 
306     /*
307      * PUBLIC FUNCTIONS
308      */
309 
310     /// @dev This default function allows token to be purchased by directly
311     /// sending ether to this smart contract.
312     function () public payable {
313         revert();
314     }
315 }
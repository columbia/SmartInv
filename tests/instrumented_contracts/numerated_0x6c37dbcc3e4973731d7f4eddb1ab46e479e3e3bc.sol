1 pragma solidity ^0.4.22;
2 
3 /*
4 
5   Copyright 2018 BodyOne Foundation.
6 
7   Licensed under the Apache License, Version 2.0 (the "License");
8   you may not use this file except in compliance with the License.
9   You may obtain a copy of the License at
10 
11   http://www.apache.org/licenses/LICENSE-2.0
12   
13 */
14  
15  
16 library SafeMath {
17   function mul(uint a, uint b) internal returns (uint) {
18     uint c = a * b;
19     assert(a == 0 || c / a == b);  
20     return c;
21   }
22 
23   function div(uint a, uint b) internal returns (uint) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint c = a / b;
26     return c;
27   }
28 
29   function sub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 
40   function assert(bool assertion) internal {
41     if (!assertion) {
42       throw;
43     }
44   }
45 }
46 
47 
48 contract ERC20Basic {
49   uint public totalSupply;
50   function balanceOf(address who) constant returns (uint);
51   function transfer(address to, uint value);
52   event Transfer(address indexed from, address indexed to, uint value);
53   
54   function allowance(address owner, address spender) constant returns (uint);
55   function transferFrom(address from, address to, uint value);
56   function approve(address spender, uint value);
57   event Approval(address indexed owner, address indexed spender, uint value);
58 }
59 
60 
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint;
63     
64   address public owner;
65   
66   /// This is a switch to control the liquidity
67   bool public transferable = true;
68   
69   mapping(address => uint) balances;
70 
71   //The frozen accounts 
72   mapping (address => bool) public frozenAccount;
73   /**
74    * @dev Fix for the ERC20 short address attack.
75    */
76   modifier onlyPayloadSize(uint size) {
77      if(msg.data.length < size + 4) {
78        throw;
79      }
80      _;
81   }
82   
83   modifier unFrozenAccount{
84       require(!frozenAccount[msg.sender]);
85       _;
86   }
87   
88   modifier onlyOwner {
89       if (owner == msg.sender) {
90           _;
91       } else {
92           InvalidCaller(msg.sender);
93           throw;
94         }
95   }
96   
97   modifier onlyTransferable {
98       if (transferable) {
99           _;
100       } else {
101           LiquidityAlarm("The liquidity of BODY is switched off");
102           throw;
103       }
104   }
105   
106   /**
107   *EVENTS
108   */
109   /// Emitted when the target account is frozen
110   event FrozenFunds(address target, bool frozen);
111   
112   /// Emitted when a function is invocated by unauthorized addresses.
113   event InvalidCaller(address caller);
114 
115   /// Emitted when some BODY coins are burn.
116   event Burn(address caller, uint value);
117   
118   /// Emitted when the ownership is transferred.
119   event OwnershipTransferred(address indexed from, address indexed to);
120   
121   /// Emitted if the account is invalid for transaction.
122   event InvalidAccount(address indexed addr, bytes msg);
123   
124   /// Emitted when the liquity of BODY is switched off
125   event LiquidityAlarm(bytes msg);
126   
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) unFrozenAccount onlyTransferable {
133     if (frozenAccount[_to]) {
134         InvalidAccount(_to, "The receiver account is frozen");
135     } else {
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         Transfer(msg.sender, _to, _value);
139     }
140     
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of. 
146   * @return An uint representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) view returns (uint balance) {
149     return balances[_owner];
150   }
151 
152   ///@notice `freeze? Prevent | Allow` `target` from sending & receiving BODY preconditions
153   ///@param target Address to be frozen
154   ///@param freeze To freeze the target account or not
155   function freezeAccount(address target, bool freeze) onlyOwner public {
156       frozenAccount[target]=freeze;
157       FrozenFunds(target, freeze);
158     }
159   
160   function accountFrozenStatus(address target) view returns (bool frozen) {
161       return frozenAccount[target];
162   }
163   
164   function transferOwnership(address newOwner) onlyOwner public {
165       if (newOwner != address(0)) {
166           address oldOwner=owner;
167           owner = newOwner;
168           OwnershipTransferred(oldOwner, owner);
169         }
170   }
171   
172   function switchLiquidity (bool _transferable) onlyOwner returns (bool success) {
173       transferable=_transferable;
174       return true;
175   }
176   
177   function liquidityStatus () view returns (bool _transferable) {
178       return transferable;
179   }
180 }
181 
182 
183 contract StandardToken is BasicToken {
184 
185   mapping (address => mapping (address => uint)) allowed;
186 
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint the amout of tokens to be transfered
193    */
194   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) unFrozenAccount onlyTransferable{
195     var _allowance = allowed[_from][msg.sender];
196 
197     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
198     // if (_value > _allowance) throw;
199     
200     // Check account _from and _to is not frozen
201     require(!frozenAccount[_from]&&!frozenAccount[_to]);
202     
203     balances[_to] = balances[_to].add(_value);
204     balances[_from] = balances[_from].sub(_value);
205     allowed[_from][msg.sender] = _allowance.sub(_value);
206     Transfer(_from, _to, _value);
207   }
208 
209   /**
210    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
211    * @param _spender The address which will spend the funds.
212    * @param _value The amount of tokens to be spent.
213    */
214   function approve(address _spender, uint _value) unFrozenAccount {
215 
216     // To change the approve amount you first have to reduce the addresses`
217     // allowance to zero by calling `approve(_spender, 0)` if it is not
218     // already 0 to mitigate the race condition described here:
219     // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
221 
222     allowed[msg.sender][_spender] = _value;
223     Approval(msg.sender, _spender, _value);
224   }
225 
226   /**
227    * @dev Function to check the amount of tokens than an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint specifing the amount of tokens still avaible for the spender.
231    */
232   function allowance(address _owner, address _spender) view returns (uint remaining) {
233     return allowed[_owner][_spender];
234   }
235   
236 }
237 
238 /// @title BodyOne Protocol Token.
239 /// For more information about this token, please visit http://www.bodyone.io/
240 contract BodyOneToken is StandardToken {
241     string public name = "BodyOne";
242     string public symbol = "BODY";
243     uint public decimals = 18;
244 
245     /**
246      * CONSTRUCTOR 
247      * 
248      * @dev Initialize the BODY Coin
249      * @param _owner The escrow account address, all ethers will
250      * be sent to this address.
251      * This address will be : 0x...
252      */
253     function BodyOneToken(address _owner) {
254         owner = _owner;
255         totalSupply = 100 * 10 ** 26;
256         balances[owner] = totalSupply;
257     }
258 
259     /*
260      * PUBLIC FUNCTIONS
261      */
262 
263     /// @dev This default function allows token to be purchased by directly
264     /// sending ether to this smart contract.
265     function () public payable {
266         revert();
267     }
268 }
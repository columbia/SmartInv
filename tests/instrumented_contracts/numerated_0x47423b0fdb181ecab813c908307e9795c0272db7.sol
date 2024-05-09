1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 
46 /**
47  * @title ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/20
49  */
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public constant returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63   using SafeMath for uint256;
64 
65   mapping(address => uint256) balances;
66 
67   /**
68   * @dev transfer token for a specified address
69   * @param _to The address to transfer to.
70   * @param _value The amount to be transferred.
71   */
72   function transfer(address _to, uint256 _value) public returns (bool) {
73     require(_to != address(0));
74     require(_value <= balances[msg.sender]);
75 
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84   * @dev Gets the balance of the specified address.
85   * @param _owner The address to query the the balance of.
86   * @return An uint256 representing the amount owned by the passed address.
87   */
88   function balanceOf(address _owner) public constant returns (uint256) {
89     return balances[_owner];
90   }
91 
92 }
93 
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
106   /**
107    * @dev Transfer tokens from one address to another
108    * @param _from address The address which you want to send tokens from
109    * @param _to address The address which you want to transfer to
110    * @param _value uint256 the amount of tokens to be transferred
111    */
112   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[_from]);
115     require(_value <= allowed[_from][msg.sender]);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifying the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    */
156   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
157     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
158     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
163     uint oldValue = allowed[msg.sender][_spender];
164     if (_subtractedValue > oldValue) {
165       allowed[msg.sender][_spender] = 0;
166     } else {
167       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168     }
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173 }
174 
175 
176 /*
177  * Ownable
178  * Base contract with an owner.
179  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
180  */
181 contract Ownable {
182     address public owner;
183 
184     function Ownable() public {
185         owner = msg.sender;
186     }
187 
188     modifier onlyOwner() {
189         if (msg.sender != owner) {
190             revert();
191         }
192         _;
193     }
194 
195     function transferOwnership(address newOwner) internal onlyOwner {
196         if (newOwner != address(0)) {
197             owner = newOwner;
198         }
199     }
200 }
201 
202 
203 /*
204   Copyright 2017 ZeroEx Intl.
205 
206   Licensed under the Apache License, Version 2.0 (the "License");
207   you may not use this file except in compliance with the License.
208   You may obtain a copy of the License at
209 
210     http://www.apache.org/licenses/LICENSE-2.0
211 
212   Unless required by applicable law or agreed to in writing, software
213   distributed under the License is distributed on an "AS IS" BASIS,
214   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
215   See the License for the specific language governing permissions and
216   limitations under the License.
217 
218 */
219 /**
220  * @title Unlimited Allowance Token
221  * @dev Unlimited allowance for exchange transfers. Modfied the base zeroEX code with latest compile features
222  * @author Dinesh
223  */
224 contract UnlimitedAllowanceToken is StandardToken {
225     
226     //  MAX_UINT represents an unlimited allowance
227     uint256 constant MAX_UINT = 2**256 - 1;
228     
229     /**
230      * @dev ERC20 transferFrom, modified such that an allowance of MAX_UINT represents an unlimited allowance.
231      * @param _from Address to transfer from
232      * @param _to Address to transfer to
233      * @param _value Amount to transfer
234      * @return Success of transfer
235      */ 
236     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
237         uint allowance = allowed[_from][msg.sender];
238         require(balances[_from] >= _value);
239         require(allowance >= _value);
240         require(balances[_to].add(_value) >= balances[_to]);
241         
242         balances[_to] = balances[_to].add(_value);
243         balances[_from] = balances[_from].sub(_value);
244         if (allowance < MAX_UINT) {
245             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246         }  
247         Transfer(_from, _to, _value);
248         
249         return true;
250     }
251 }
252 
253 /**
254  * @title Tokenized Ether
255  * @dev ERC20 tokenization for Ether to allow exchange transfer and smoother handling of ether.
256  *      Modified the base zerox contract to use latest language features and made it more secure
257  *      and fault tolerant
258  * @author Dinesh
259  */
260 contract EtherToken is UnlimitedAllowanceToken, Ownable{
261     using SafeMath for uint256; 
262     
263     string constant public name = "Ether Token";
264     string constant public symbol = "WXETH";
265     uint256 constant public decimals = 18; 
266     
267     // triggered when the total supply is increased
268     event Issuance(uint256 _amount);
269     
270     // triggered when the total supply is decreased
271     event Destruction(uint256 _amount);
272     
273     // in case of emergency, block all transactions
274     bool public enabled;
275     
276     // In case emergencies, all the funds will be moved to a safety Wallet. Normally Owner of the contract
277     address public safetyWallet; 
278     
279     /** 
280      * @dev constructor
281      */
282     function EtherToken() public {
283         enabled = true;
284         safetyWallet = msg.sender;
285     }
286     
287     /**
288      * @dev function to enable/disable contract operations
289      * @param _disableTx tell whethere the tx needs to be blocked or allowed
290      */
291     function blockTx(bool _disableTx) public onlyOwner { 
292         enabled = !_disableTx;
293     }
294     
295     /**
296      * @dev fucntion only executes if there is an emergency and only contract owner can do it 
297      *      CAUTION: This moves all the funds in the contract to owner's Wallet and to be called
298      *      most extreme cases only
299      */
300     function moveToSafetyWallet() public onlyOwner {
301         require(!enabled); 
302         require(totalSupply > 0);
303         require(safetyWallet != 0x0);
304         
305         //Empty Total Supply
306         uint256 _amount = totalSupply;
307         totalSupply = totalSupply.sub(totalSupply); 
308         
309         //Fire the events
310         Transfer(safetyWallet, this, totalSupply);
311         Destruction(totalSupply);
312         
313         // send the amount to the target account
314         safetyWallet.transfer(_amount);  
315     }
316     
317     /** 
318      * @dev fallback function can be used to get ether tokens foe ether
319      */
320     function () public payable {
321         require(enabled);
322         deposit(msg.sender);
323     }
324     
325     /**
326      * @dev function Buys tokens with Ether, exchanging them 1:1. Simliar to a Deposit function
327      * @param beneficiary is the senders account
328      */
329     function deposit(address beneficiary) public payable {
330         require(enabled);
331         require(beneficiary != 0x0);  
332         require(msg.value != 0);  
333         
334         balances[beneficiary] = balances[beneficiary].add(msg.value);
335         totalSupply = totalSupply.add( msg.value);
336         
337         //Fire th events
338         Issuance(msg.value);
339         Transfer(this, beneficiary, msg.value);
340     }
341     
342     /**
343      * @dev withdraw ether from the account
344      * @param _amount  amount of ether to withdraw
345      */
346     function withdraw(uint256 _amount) public {
347         require(enabled);
348         withdrawTo(msg.sender, _amount);
349     }
350     
351     /**
352      * @dev withdraw ether from the account to a target account
353      * @param _to account to receive the ether
354      * @param _amount of ether to withdraw
355      */
356     function withdrawTo(address _to, uint _amount) public { 
357         require(enabled);
358         require(_to != 0x0);
359         require(_amount != 0);  
360         require(_amount <= balances[_to]); 
361         require(this != _to);
362         
363         balances[_to] = balances[_to].sub(_amount);
364         totalSupply = totalSupply.sub(_amount); 
365         
366         //Fire the events
367         Transfer(msg.sender, this, _amount);
368         Destruction(_amount);
369         
370          // send the amount to the target account
371         _to.transfer(_amount);  
372     }
373 }
1 pragma solidity ^0.4.21;
2 
3 contract OwnedEvents {
4   event LogSetOwner (address newOwner);
5 }
6 
7 
8 contract Owned is OwnedEvents {
9   address public owner;
10 
11   function Owned() public {
12     owner = msg.sender;
13   }
14 
15   modifier onlyOwner() {
16     require(msg.sender == owner);
17     _;
18   }
19 
20   function setOwner(address owner_) public onlyOwner {
21     owner = owner_;
22     emit LogSetOwner(owner);
23   }
24 
25 }
26 
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   function totalSupply() public view returns (uint256);
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   uint256 totalSupply_;
60 
61   /**
62   * @dev total number of tokens in existence
63   */
64   function totalSupply() public view returns (uint256) {
65     return totalSupply_;
66   }
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76 
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85   * @dev Gets the balance of the specified address.
86   * @param _owner The address to query the the balance of.
87   * @return An uint256 representing the amount owned by the passed address.
88   */
89   function balanceOf(address _owner) public view returns (uint256 balance) {
90     return balances[_owner];
91   }
92 
93 }
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
104     mapping (address => mapping (address => uint256)) internal allowed;
105 
106 
107     /**
108      * @dev Transfer tokens from one address to another
109      * @param _from address The address which you want to send tokens from
110      * @param _to address The address which you want to transfer to
111      * @param _value uint256 the amount of tokens to be transferred
112      */
113     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[_from]);
116         require(_value <= allowed[_from][msg.sender]);
117 
118         balances[_from] = balances[_from].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
121         Transfer(_from, _to, _value);
122         return true;
123     }
124 
125     /**
126      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
127      *
128      * Beware that changing an allowance with this method brings the risk that someone may use both the old
129      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
130      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
131      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132      * @param _spender The address which will spend the funds.
133      * @param _value The amount of tokens to be spent.
134      */
135     function approve(address _spender, uint256 _value) public returns (bool) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Function to check the amount of tokens that an owner allowed to a spender.
143      * @param _owner address The address which owns the funds.
144      * @param _spender address The address which will spend the funds.
145      * @return A uint256 specifying the amount of tokens still available for the spender.
146      */
147     function allowance(address _owner, address _spender) public view returns (uint256) {
148         return allowed[_owner][_spender];
149     }
150 
151     /**
152      * @dev Increase the amount of tokens that an owner allowed to a spender.
153      *
154      * approve should be called when allowed[_spender] == 0. To increment
155      * allowed value is better to use this function to avoid 2 calls (and wait until
156      * the first transaction is mined)
157      * From MonolithDAO Token.sol
158      * @param _spender The address which will spend the funds.
159      * @param _addedValue The amount of tokens to increase the allowance by.
160      */
161     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
162         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
163         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
164         return true;
165     }
166 
167     /**
168      * @dev Decrease the amount of tokens that an owner allowed to a spender.
169      *
170      * approve should be called when allowed[_spender] == 0. To decrement
171      * allowed value is better to use this function to avoid 2 calls (and wait until
172      * the first transaction is mined)
173      * From MonolithDAO Token.sol
174      * @param _spender The address which will spend the funds.
175      * @param _subtractedValue The amount of tokens to decrease the allowance by.
176      */
177     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
178         uint oldValue = allowed[msg.sender][_spender];
179         if (_subtractedValue > oldValue) {
180             allowed[msg.sender][_spender] = 0;
181         } else {
182             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183         }
184         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185         return true;
186     }
187 
188 }
189 
190 contract DetailedERC20 is ERC20 {
191   string public name;
192   string public symbol;
193   uint8 public decimals;
194 
195   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
196     name = _name;
197     symbol = _symbol;
198     decimals = _decimals;
199   }
200 }
201 
202 /**
203  * @title Pausable
204  * @dev Base contract which allows children to implement an emergency stop mechanism.
205  */
206 contract Pausable is Owned {
207   event Pause();
208   event Unpause();
209 
210   bool public paused = false;
211 
212 
213   /**
214    * @dev Modifier to make a function callable only when the contract is not paused.
215    */
216   modifier whenNotPaused() {
217     require(!paused);
218     _;
219   }
220 
221   /**
222    * @dev Modifier to make a function callable only when the contract is paused.
223    */
224   modifier whenPaused() {
225     require(paused);
226     _;
227   }
228 
229   /**
230    * @dev called by the owner to pause, triggers stopped state
231    */
232   function pause() onlyOwner whenNotPaused public {
233     paused = true;
234     Pause();
235   }
236 
237   /**
238    * @dev called by the owner to unpause, returns to normal state
239    */
240   function unpause() onlyOwner whenPaused public {
241     paused = false;
242     Unpause();
243   }
244 }
245 
246 /**
247  * @title Pausable token
248  * @dev StandardToken modified with pausable transfers.
249  **/
250 contract PausableToken is StandardToken, Pausable {
251 
252   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
253     return super.transfer(_to, _value);
254   }
255 
256   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
257     return super.transferFrom(_from, _to, _value);
258   }
259 
260   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
261     return super.approve(_spender, _value);
262   }
263 
264   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
265     return super.increaseApproval(_spender, _addedValue);
266   }
267 
268   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
269     return super.decreaseApproval(_spender, _subtractedValue);
270   }
271 }
272 
273 /**
274  * @title SafeMath
275  * @dev Math operations with safety checks that throw on error
276  */
277 library SafeMath {
278 
279   /**
280   * @dev Multiplies two numbers, throws on overflow.
281   */
282   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283     if (a == 0) {
284       return 0;
285     }
286     uint256 c = a * b;
287     assert(c / a == b);
288     return c;
289   }
290 
291   /**
292   * @dev Integer division of two numbers, truncating the quotient.
293   */
294   function div(uint256 a, uint256 b) internal pure returns (uint256) {
295     // assert(b > 0); // Solidity automatically throws when dividing by 0
296     uint256 c = a / b;
297     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298     return c;
299   }
300 
301   /**
302   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
303   */
304   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
305     assert(b <= a);
306     return a - b;
307   }
308 
309   /**
310   * @dev Adds two numbers, throws on overflow.
311   */
312   function add(uint256 a, uint256 b) internal pure returns (uint256) {
313     uint256 c = a + b;
314     assert(c >= a);
315     return c;
316   }
317 }
318 
319 // Licensed under the Apache License, Version 2.0 (the "License");
320 // you may not use this file except in compliance with the License.
321 // You may obtain a copy of the License at
322 //
323 //     http://www.apache.org/licenses/LICENSE-2.0
324 //
325 // Unless required by applicable law or agreed to in writing, software
326 // distributed under the License is distributed on an "AS IS" BASIS,
327 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
328 // See the License for the specific language governing permissions and
329 // limitations under the License.
330 
331 contract Token is PausableToken {
332     string public symbol = "VLT";
333     string public name = "Vault Token";
334     uint8 public decimals = 18; // standard token precision. override to customize
335 
336     function Token(address[] initialWallets,
337         uint256[] initialBalances) public {
338         require(initialBalances.length == initialWallets.length);
339         for (uint256 i = 0; i < initialWallets.length; i++) {
340             totalSupply_ = totalSupply_.add(initialBalances[i]);
341             balances[initialWallets[i]] = balances[initialWallets[i]].add(initialBalances[i]);
342             emit Transfer(address(0), initialWallets[i], initialBalances[i]);
343         }
344     }
345 
346     function burn(uint256 _value) public {
347         balances[msg.sender] = balances[msg.sender].sub(_value);
348         totalSupply_ = totalSupply_.sub(_value);
349         emit Transfer(msg.sender, address(0), _value);
350     }
351 
352     function setName(string name_) public onlyOwner {
353         name = name_;
354     }
355 }
1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) onlyOwner {
35     if (newOwner != address(0)) {
36       owner = newOwner;
37     }
38   }
39 
40 }
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title ERC20Basic
74  * @dev Simpler version of ERC20 interface
75  * @dev see https://github.com/ethereum/EIPs/issues/179
76  */
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) constant returns (uint256);
80   function transfer(address to, uint256 value) returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 /**
85  * @title Basic token
86  * @dev Basic version of StandardToken, with no allowances. 
87  */
88 contract BasicToken is ERC20Basic {
89   using SafeMath for uint256;
90 
91   mapping(address => uint256) balances;
92 
93   /**
94   * @dev transfer token for a specified address
95   * @param _to The address to transfer to.
96   * @param _value The amount to be transferred.
97   */
98   function transfer(address _to, uint256 _value) returns (bool) {
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of. 
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) constant returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/20
119  */
120 contract ERC20 is ERC20Basic {
121   function allowance(address owner, address spender) constant returns (uint256);
122   function transferFrom(address from, address to, uint256 value) returns (bool);
123   function approve(address spender, uint256 value) returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amout of tokens to be transfered
144    */
145   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
146     var _allowance = allowed[_from][msg.sender];
147 
148     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
149     // require (_value <= _allowance);
150 
151     balances[_to] = balances[_to].add(_value);
152     balances[_from] = balances[_from].sub(_value);
153     allowed[_from][msg.sender] = _allowance.sub(_value);
154     Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint256 _value) returns (bool) {
164 
165     // To change the approve amount you first have to reduce the addresses`
166     //  allowance to zero by calling `approve(_spender, 0)` if it is not
167     //  already 0 to mitigate the race condition described here:
168     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
170 
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifing the amount of tokens still avaible for the spender.
181    */
182   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
183     return allowed[_owner][_spender];
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
231 // ACE Token is a first token of TokenStars platform
232 // Copyright (c) 2017 TokenStars
233 // Made by Aler Denisov
234 // Permission is hereby granted, free of charge, to any person obtaining a copy
235 // of this software and associated documentation files (the "Software"), to deal
236 // in the Software without restriction, including without limitation the rights
237 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
238 // copies of the Software, and to permit persons to whom the Software is
239 // furnished to do so, subject to the following conditions:
240 
241 // The above copyright notice and this permission notice shall be included in all
242 // copies or substantial portions of the Software.
243 
244 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
245 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
246 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
247 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
248 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
249 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
250 // SOFTWARE.
251 
252 
253 
254 
255 
256 
257 contract StarTokenInterface is MintableToken {
258     // Cheatsheet of inherit methods and events
259     // function transferOwnership(address newOwner);
260     // function allowance(address owner, address spender) constant returns (uint256);
261     // function transfer(address _to, uint256 _value) returns (bool);
262     // function transferFrom(address from, address to, uint256 value) returns (bool);
263     // function approve(address spender, uint256 value) returns (bool);
264     // function increaseApproval (address _spender, uint _addedValue) returns (bool success);
265     // function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
266     // function finishMinting() returns (bool);
267     // function mint(address _to, uint256 _amount) returns (bool);
268     // event Approval(address indexed owner, address indexed spender, uint256 value);
269     // event Mint(address indexed to, uint256 amount);
270     // event MintFinished();
271 
272     // Custom methods and events
273     function openTransfer() public returns (bool);
274     function toggleTransferFor(address _for) public returns (bool);
275     function extraMint() public returns (bool);
276 
277     event TransferAllowed();
278     event TransferAllowanceFor(address indexed who, bool indexed state);
279 
280 
281 }
282 
283 // ACE Token is a first token of TokenStars platform
284 // Copyright (c) 2017 TokenStars
285 // Made by Aler Denisov
286 // Permission is hereby granted, free of charge, to any person obtaining a copy
287 // of this software and associated documentation files (the "Software"), to deal
288 // in the Software without restriction, including without limitation the rights
289 // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
290 // copies of the Software, and to permit persons to whom the Software is
291 // furnished to do so, subject to the following conditions:
292 
293 // The above copyright notice and this permission notice shall be included in all
294 // copies or substantial portions of the Software.
295 
296 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
297 // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
298 // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
299 // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
300 // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
301 // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
302 // SOFTWARE.
303 
304 
305 
306 
307 
308 
309 
310 contract AceTokenDistribution is Ownable {
311   using SafeMath for uint256;
312   StarTokenInterface public token;
313 
314   event DistributionMint(address indexed to, uint256 amount);
315   event ExtraMint();
316 
317   function AceTokenDistribution (address _tokenAddress) {
318     require(_tokenAddress != 0);
319     token = StarTokenInterface(_tokenAddress);
320   }
321 
322   /**
323   * @dev Minting required amount of tokens in a loop
324   * @param _investors The array of addresses of investors
325   * @param _amounts The array of token amounts corresponding to investors
326   */
327   function bulkMint(address[] _investors, uint256[] _amounts) onlyOwner public returns (bool) {
328     // require(_investors.length < 50);
329     require(_investors.length == _amounts.length);
330 
331     for (uint index = 0; index < _investors.length; index++) {
332       assert(token.mint(_investors[index], _amounts[index]));
333       DistributionMint(_investors[index], _amounts[index]);
334     }
335   }
336 
337   /**
338   * @dev Minting extra (team and community) tokens
339   */
340   function extraMint() onlyOwner public returns (bool) {
341     assert(token.extraMint());
342     ExtraMint();
343   }
344 
345   /**
346   * @dev Return ownership to previous owner
347   */
348   function returnOwnership() onlyOwner public returns (bool) {
349     token.transferOwnership(owner);
350   }
351 }
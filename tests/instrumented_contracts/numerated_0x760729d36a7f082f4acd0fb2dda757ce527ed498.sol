1 pragma solidity ^0.4.24;
2 
3 /*
4  Copyright 2018 IDMCOSAS
5 
6   Licensed under the Apache License, Version 2.0 (the "License");
7   you may not use this file except in compliance with the License.
8   You may obtain a copy of the License at
9 
10     http://www.apache.org/licenses/LICENSE-2.0
11 
12   Unless required by applicable law or agreed to in writing, software
13   distributed under the License is distributed on an "AS IS" BASIS,
14   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15   See the License for the specific language governing permissions and
16   limitations under the License.
17 */
18 
19 /* 
20 The MIT License (MIT)
21 
22 Copyright (c) 2018 Smart Contract Solutions, Inc.
23 
24 Permission is hereby granted, free of charge, to any person obtaining
25 a copy of this software and associated documentation files (the
26 "Software"), to deal in the Software without restriction, including
27 without limitation the rights to use, copy, modify, merge, publish,
28 distribute, sublicense, and/or sell copies of the Software, and to
29 permit persons to whom the Software is furnished to do so, subject to
30 the following conditions:
31 
32 The above copyright notice and this permission notice shall be included
33 in all copies or substantial portions of the Software.
34 
35 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
36 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
37 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
38 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
39 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
40 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
41 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
42 */
43 
44 // ----------------------------------------------------------------------------
45 // 'MCS' token contract
46 //
47 // Сreator : 0xd0C7eFd2acc5223c5cb0A55e2F1D5f1bB904035d
48 // Symbol      : MCS
49 // Name        : IDMCOSAS
50 // Total supply: 100000000
51 // Decimals    : 18
52 //
53 //
54 // (c) by Maxim Yurkov with IDMCOSAS / IDMCOSAS 2018. The MIT Licence.
55 // ----------------------------------------------------------------------------
56 
57 /**
58  * @title SafeMath
59  * @dev Math operations with safety checks that throw on error
60  */
61 library SafeMath {
62 
63   /**
64   * @dev Multiplies two numbers, throws on overflow.
65   */
66   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67     if (a == 0) {
68       return 0;
69     }
70     uint256 c = a * b;
71     assert(c / a == b);
72     return c;
73   }
74 
75   /**
76   * @dev Integer division of two numbers, truncating the quotient.
77   */
78   function div(uint256 a, uint256 b) internal pure returns (uint256) {
79     // assert(b > 0); // Solidity automatically throws when dividing by 0
80     uint256 c = a / b;
81     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
82     return c;
83   }
84 
85   /**
86   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
87   */
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b;
91   }
92 
93   /**
94   * @dev Adds two numbers, throws on overflow.
95   */
96   function add(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
102 
103 /**
104  * @title ERC20Basic
105  * @dev Simpler version of ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/179
107  */
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * @dev total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * @dev transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     // SafeMath.sub will throw if there is not enough balance.
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256 balance) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * @dev https://github.com/ethereum/EIPs/issues/20
178  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is ERC20, BasicToken {
181 
182   mapping (address => mapping (address => uint256)) internal allowed;
183 
184 
185   /**
186    * @dev Transfer tokens from one address to another
187    * @param _from address The address which you want to send tokens from
188    * @param _to address The address which you want to transfer to
189    * @param _value uint256 the amount of tokens to be transferred
190    */
191   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
192     require(_to != address(0));
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     emit Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    *
206    * Beware that changing an allowance with this method brings the risk that someone may use both the old
207    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
208    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
209    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210    * @param _spender The address which will spend the funds.
211    * @param _value The amount of tokens to be spent.
212    */
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     emit Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Function to check the amount of tokens that an owner allowed to a spender.
221    * @param _owner address The address which owns the funds.
222    * @param _spender address The address which will spend the funds.
223    * @return A uint256 specifying the amount of tokens still available for the spender.
224    */
225   function allowance(address _owner, address _spender) public view returns (uint256) {
226     return allowed[_owner][_spender];
227   }
228 
229   /**
230    * @dev Increase the amount of tokens that an owner allowed to a spender.
231    *
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
240     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245   /**
246    * @dev Decrease the amount of tokens that an owner allowed to a spender.
247    *
248    * approve should be called when allowed[_spender] == 0. To decrement
249    * allowed value is better to use this function to avoid 2 calls (and wait until
250    * the first transaction is mined)
251    * From MonolithDAO Token.sol
252    * @param _spender The address which will spend the funds.
253    * @param _subtractedValue The amount of tokens to decrease the allowance by.
254    */
255   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 /**
269  * @title Burnable Token
270  * @dev Token that can be irreversibly burned (destroyed).
271  */
272 contract BurnableToken is BasicToken {
273 
274   event Burn(address indexed burner, uint256 value);
275 
276   /**
277    * @dev Burns a specific amount of tokens.
278    * @param _value The amount of token to be burned.
279    */
280   function burn(uint256 _value) public {
281     require(_value <= balances[msg.sender]);
282     // no need to require value <= totalSupply, since that would imply the
283     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
284 
285     address burner = msg.sender;
286     balances[burner] = balances[burner].sub(_value);
287     totalSupply_ = totalSupply_.sub(_value);
288     emit Burn(burner, _value);
289     emit Transfer(burner, address(0), _value);
290   }
291 }
292 
293 /**
294  * @title Ownable
295  * @dev The Ownable contract has an owner address, and provides basic authorization control
296  * functions, this simplifies the implementation of "user permissions".
297  */
298 contract Ownable {
299   address public owner;
300 
301 
302   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
303 
304 
305   /**
306    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
307    * account.
308    */
309   constructor () public {
310     owner = msg.sender;
311   }
312 
313   /**
314    * @dev Throws if called by any account other than the owner.
315    */
316   modifier onlyOwner() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Allows the current owner to transfer control of the contract to a newOwner.
323    * @param newOwner The address to transfer ownership to.
324    */
325   function transferOwnership(address newOwner) public onlyOwner {
326     require(newOwner != address(0));
327     emit OwnershipTransferred(owner, newOwner);
328     owner = newOwner;
329   }
330 
331 }
332 
333 contract MCSToken is StandardToken, BurnableToken
334 {   
335     string public constant name = "IDMCOSAS";
336     string public constant symbol = "MCS";
337     uint public constant decimals = 18;
338     
339     constructor (address owners) public
340     {
341         totalSupply_ = 100000000 * 10 ** decimals; // 100000000 MCS
342         uint ownersPart = totalSupply_.mul(15).div(100); // 15%
343         
344         balances[msg.sender] = totalSupply_ - ownersPart;
345         emit Transfer(0x0, msg.sender, totalSupply_ - ownersPart);
346         
347         balances[owners] = ownersPart;
348         emit Transfer(0x0, owners, ownersPart);
349     }
350 }
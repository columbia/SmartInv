1 pragma solidity ^0.4.19;
2 
3 /*
4 Copyright (c) 2016 Smart Contract Solutions, Inc.
5 
6 Permission is hereby granted, free of charge, to any person obtaining a copy
7 of this software and associated documentation files (the "Software"), to deal
8 in the Software without restriction, including without limitation the rights
9 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
10 copies of the Software, and to permit persons to whom the Software is
11 furnished to do so, subject to the following conditions:
12 
13 The above copyright notice and this permission notice shall be included in
14 all copies or substantial portions of the Software.
15 
16 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
17 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
18 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
19 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
20 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
21 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
22 THE SOFTWARE.
23 */
24 
25 
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /*
74 Permission is hereby granted, free of charge, to any person obtaining a copy
75 of this software and associated documentation files (the "Software"), to deal
76 in the Software without restriction, including without limitation the rights
77 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
78 copies of the Software, and to permit persons to whom the Software is
79 furnished to do so, subject to the following conditions:
80 
81 The above copyright notice and this permission notice shall be included in
82 all copies or substantial portions of the Software.
83 
84 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
85 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
86 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
87 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
88 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
89 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
90 THE SOFTWARE.
91 */
92 
93 
94 contract EIP20Interface {
95     /* This is a slight change to the ERC20 base standard.
96     function totalSupply() constant returns (uint256 supply);
97     is replaced with:
98     uint256 public totalSupply;
99     This automatically creates a getter function for the totalSupply.
100     This is moved to the base contract since public getter functions are not
101     currently recognised as an implementation of the matching abstract
102     function by the compiler.
103     */
104     /// total amount of tokens
105     uint256 public totalSupply;
106 
107     /// @param _owner The address from which the balance will be retrieved
108     /// @return The balance
109     function balanceOf(address _owner) public view returns (uint256 balance);
110 
111     /// @notice send `_value` token to `_to` from `msg.sender`
112     /// @param _to The address of the recipient
113     /// @param _value The amount of token to be transferred
114     /// @return Whether the transfer was successful or not
115     function transfer(address _to, uint256 _value) public returns (bool success);
116 
117     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
118     /// @param _from The address of the sender
119     /// @param _to The address of the recipient
120     /// @param _value The amount of token to be transferred
121     /// @return Whether the transfer was successful or not
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
123 
124     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
125     /// @param _spender The address of the account able to transfer the tokens
126     /// @param _value The amount of tokens to be approved for transfer
127     /// @return Whether the approval was successful or not
128     function approve(address _spender, uint256 _value) public returns (bool success);
129 
130     /// @param _owner The address of the account owning tokens
131     /// @param _spender The address of the account able to transfer the tokens
132     /// @return Amount of remaining tokens allowed to spent
133     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
134 
135     // solhint-disable-next-line no-simple-event-func-name  
136     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
137     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
138 }
139 
140 /*
141 Permission is hereby granted, free of charge, to any person obtaining a copy
142 of this software and associated documentation files (the "Software"), to deal
143 in the Software without restriction, including without limitation the rights
144 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
145 copies of the Software, and to permit persons to whom the Software is
146 furnished to do so, subject to the following conditions:
147 
148 The above copyright notice and this permission notice shall be included in
149 all copies or substantial portions of the Software.
150 
151 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
152 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
153 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
154 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
155 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
156 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
157 THE SOFTWARE.
158 */
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166   address public owner;
167 
168 
169   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171 
172   /**
173    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
174    * account.
175    */
176   function Ownable() public {
177     owner = msg.sender;
178   }
179 
180   /**
181    * @dev Throws if called by any account other than the owner.
182    */
183   modifier onlyOwner() {
184     require(msg.sender == owner);
185     _;
186   }
187 
188   /**
189    * @dev Allows the current owner to transfer control of the contract to a newOwner.
190    * @param newOwner The address to transfer ownership to.
191    */
192   function transferOwnership(address newOwner) public onlyOwner {
193     require(newOwner != address(0));
194     OwnershipTransferred(owner, newOwner);
195     owner = newOwner;
196   }
197 
198 }
199 
200 
201 /*
202 MIT License for burn() function and event
203 
204 Copyright (c) 2016 Smart Contract Solutions, Inc.
205 
206 Permission is hereby granted, free of charge, to any person obtaining a copy
207 of this software and associated documentation files (the "Software"), to deal
208 in the Software without restriction, including without limitation the rights
209 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
210 copies of the Software, and to permit persons to whom the Software is
211 furnished to do so, subject to the following conditions:
212 
213 The above copyright notice and this permission notice shall be included in
214 all copies or substantial portions of the Software.
215 
216 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
217 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
218 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
219 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
220 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
221 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
222 THE SOFTWARE.
223 */
224 
225 
226 contract CellBlocksToken is EIP20Interface, Ownable {
227 
228     uint256 constant private MAX_UINT256 = 2**256 - 1;
229     mapping (address => uint256) public balances;
230     mapping (address => mapping (address => uint256)) public allowed;
231     /*
232     NOTE:
233     The following variables are OPTIONAL vanities. One does not have to include them.
234     They allow one to customise the token contract & in no way influences the core functionality.
235     Some wallets/interfaces might not even bother to look at this information.
236     */
237     string public name;                   //fancy name: eg Simon Bucks
238     uint8 public decimals;                //How many decimals to show.
239     string public symbol;                 //An identifier: eg SBX
240 
241     function CellBlocksToken() public {
242         balances[msg.sender] = 25*(10**25);            // Give the creator all initial tokens
243         totalSupply = 25*(10**25);                     // Update total supply
244         name = "CellBlocks";                          // Set the name for display purposes
245         decimals = 18;                                // Amount of decimals for display purposes
246         symbol = "CLBK";                               // Set the symbol for display purposes
247     }
248 
249     //as long as supply > 83*(10**24) and timestamp is after 6/20/18 12:01 am MST, 
250     //transfer will call halfPercent() and burn() to burn 0.5% of each transaction 
251     function transfer(address _to, uint256 _value) public returns (bool success) {
252         require(balances[msg.sender] >= _value);
253         if (totalSupply > 83*(10**24) && block.timestamp >= 1529474460) {
254             uint halfP = halfPercent(_value);
255             burn(msg.sender, halfP);
256             _value = SafeMath.sub(_value, halfP);
257         }
258         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
259         balances[_to] = SafeMath.add(balances[_to], _value);
260         Transfer(msg.sender, _to, _value);
261         return true;
262     }
263 
264     //as long as supply > 83*(10**24) and timestamp is after 6/20/18 12:01 am MST, 
265     //transferFrom will call halfPercent() and burn() to burn 0.5% of each transaction
266     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
267         uint256 allowance = allowed[_from][msg.sender];
268         require(balances[_from] >= _value && allowance >= _value);
269         if (totalSupply > 83*(10**24) && block.timestamp >= 1529474460) {
270             uint halfP = halfPercent(_value);
271             burn(_from, halfP);
272             _value = SafeMath.sub(_value, halfP);
273         }
274         balances[_to] = SafeMath.add(balances[_to], _value);
275         balances[_from] = SafeMath.sub(balances[_from], _value);
276         if (allowance < MAX_UINT256) {
277             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
278         }
279         Transfer(_from, _to, _value);
280         return true;
281     }
282 
283     function balanceOf(address _owner) public view returns (uint256 balance) {
284         return balances[_owner];
285     }
286 
287     function approve(address _spender, uint256 _value) public returns (bool success) {
288         allowed[msg.sender][_spender] = _value;
289         Approval(msg.sender, _spender, _value);
290         return true;
291     }
292 
293     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
294         return allowed[_owner][_spender];
295     }   
296 
297     /// @notice returns uint representing 0.5% of _value
298     /// @param _value amount to calculate 0.5% of
299     /// @return uint representing 0.5% of _value
300     function halfPercent(uint _value) private pure returns(uint amount) {
301         if (_value > 0) {
302             // caution, check safe-to-multiply here
303             uint temp = SafeMath.mul(_value, 5);
304             amount = SafeMath.div(temp, 1000);
305 
306             if (amount == 0) {
307                 amount = 1;
308             }
309         }   
310         else {
311             amount = 0;
312         }
313         return;
314     }
315 
316     /// @notice burns _value of tokens from address burner
317     /// @param burner The address to burn the tokens from 
318     /// @param _value The amount of tokens to be burnt
319     function burn(address burner, uint256 _value) public {
320         require(_value <= balances[burner]);
321         // no need to require value <= totalSupply, since that would imply the
322         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
323         if (_value > 0) {
324             balances[burner] = SafeMath.sub(balances[burner], _value);
325             totalSupply = SafeMath.sub(totalSupply, _value);
326             Burn(burner, _value);
327             Transfer(burner, address(0), _value);
328         }
329     }
330 
331     event Burn(address indexed burner, uint256 value);
332 }
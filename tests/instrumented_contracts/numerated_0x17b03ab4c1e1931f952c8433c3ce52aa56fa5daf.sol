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
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 
71 
72 /*
73 Permission is hereby granted, free of charge, to any person obtaining a copy
74 of this software and associated documentation files (the "Software"), to deal
75 in the Software without restriction, including without limitation the rights
76 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
77 copies of the Software, and to permit persons to whom the Software is
78 furnished to do so, subject to the following conditions:
79 
80 The above copyright notice and this permission notice shall be included in
81 all copies or substantial portions of the Software.
82 
83 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
84 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
85 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
86 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
87 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
88 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
89 THE SOFTWARE.
90 */
91 contract EIP20Interface {
92     /* This is a slight change to the ERC20 base standard.
93     function totalSupply() constant returns (uint256 supply);
94     is replaced with:
95     uint256 public totalSupply;
96     This automatically creates a getter function for the totalSupply.
97     This is moved to the base contract since public getter functions are not
98     currently recognised as an implementation of the matching abstract
99     function by the compiler.
100     */
101     /// total amount of tokens
102     uint256 public totalSupply;
103 
104     /// @param _owner The address from which the balance will be retrieved
105     /// @return The balance
106     function balanceOf(address _owner) public view returns (uint256 balance);
107 
108     /// @notice send `_value` token to `_to` from `msg.sender`
109     /// @param _to The address of the recipient
110     /// @param _value The amount of token to be transferred
111     /// @return Whether the transfer was successful or not
112     function transfer(address _to, uint256 _value) public returns (bool success);
113 
114     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
115     /// @param _from The address of the sender
116     /// @param _to The address of the recipient
117     /// @param _value The amount of token to be transferred
118     /// @return Whether the transfer was successful or not
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
120 
121     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
122     /// @param _spender The address of the account able to transfer the tokens
123     /// @param _value The amount of tokens to be approved for transfer
124     /// @return Whether the approval was successful or not
125     function approve(address _spender, uint256 _value) public returns (bool success);
126 
127     /// @param _owner The address of the account owning tokens
128     /// @param _spender The address of the account able to transfer the tokens
129     /// @return Amount of remaining tokens allowed to spent
130     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
131 
132     // solhint-disable-next-line no-simple-event-func-name  
133     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
134     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 }
136 
137 
138 
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
197 }
198 
199 
200 
201 
202 /*
203 MIT License for burn() function and event
204 
205 Copyright (c) 2016 Smart Contract Solutions, Inc.
206 
207 Permission is hereby granted, free of charge, to any person obtaining a copy
208 of this software and associated documentation files (the "Software"), to deal
209 in the Software without restriction, including without limitation the rights
210 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
211 copies of the Software, and to permit persons to whom the Software is
212 furnished to do so, subject to the following conditions:
213 
214 The above copyright notice and this permission notice shall be included in
215 all copies or substantial portions of the Software.
216 
217 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
218 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
219 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
220 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
221 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
222 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
223 THE SOFTWARE.
224 */
225 
226 
227 
228 contract CellBlocksToken is EIP20Interface, Ownable {
229 
230     uint256 constant private MAX_UINT256 = 2**256 - 1;
231     mapping (address => uint256) public balances;
232     mapping (address => mapping (address => uint256)) public allowed;
233     /*
234     NOTE:
235     The following variables are OPTIONAL vanities. One does not have to include them.
236     They allow one to customise the token contract & in no way influences the core functionality.
237     Some wallets/interfaces might not even bother to look at this information.
238     */
239     string public name;                   //fancy name: eg Simon Bucks
240     uint8 public decimals;                //How many decimals to show.
241     string public symbol;                 //An identifier: eg SBX
242 
243     function CellBlocksToken() public {
244         balances[msg.sender] = 3*(10**26);            // Give the creator all initial tokens
245         totalSupply = 3*(10**26);                     // Update total supply
246         name = "CellBlocks";                          // Set the name for display purposes
247         decimals = 18;                                // Amount of decimals for display purposes
248         symbol = "CLBK";                               // Set the symbol for display purposes
249     }
250 
251     //as long as supply > 10**26 and timestamp is after 6/20/18 12:01 am MST, 
252     //transfer will call halfPercent() and burn() to burn 0.5% of each transaction 
253     function transfer(address _to, uint256 _value) public returns (bool success) {
254         require(balances[msg.sender] >= _value);
255         if (totalSupply > (10**26) && block.timestamp >= 1529474460) {
256             uint halfP = halfPercent(_value);
257             burn(msg.sender, halfP);
258             _value = SafeMath.sub(_value, halfP);
259         }
260         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
261         balances[_to] = SafeMath.add(balances[_to], _value);
262         Transfer(msg.sender, _to, _value);
263         return true;
264     }
265 
266     //as long as supply > 10**26 and timestamp is after 6/20/18 12:01 am MST, 
267     //transferFrom will call halfPercent() and burn() to burn 0.5% of each transaction
268     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
269         uint256 allowance = allowed[_from][msg.sender];
270         require(balances[_from] >= _value && allowance >= _value);
271         if (totalSupply > (10**26) && block.timestamp >= 1529474460) {
272             uint halfP = halfPercent(_value);
273             burn(_from, halfP);
274             _value = SafeMath.sub(_value, halfP);
275         }
276         balances[_to] = SafeMath.add(balances[_to], _value);
277         balances[_from] = SafeMath.sub(balances[_from], _value);
278         if (allowance < MAX_UINT256) {
279             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
280         }
281         Transfer(_from, _to, _value);
282         return true;
283     }
284 
285     function balanceOf(address _owner) public view returns (uint256 balance) {
286         return balances[_owner];
287     }
288 
289     function approve(address _spender, uint256 _value) public returns (bool success) {
290         allowed[msg.sender][_spender] = _value;
291         Approval(msg.sender, _spender, _value);
292         return true;
293     }
294 
295     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
296         return allowed[_owner][_spender];
297     }   
298 
299     /// @notice returns uint representing 0.5% of _value
300     /// @param _value amount to calculate 0.5% of
301     /// @return uint representing 0.5% of _value
302     function halfPercent(uint _value) private pure returns(uint amount) {
303         if (_value > 0) {
304             // caution, check safe-to-multiply here
305             uint temp = SafeMath.mul(_value, 5);
306             amount = SafeMath.div(temp, 1000);
307 
308             if (amount == 0) {
309                 amount = 1;
310             }
311         }   
312         else {
313             amount = 0;
314         }
315         return;
316     }
317 
318     /// @notice burns _value of tokens from address burner
319     /// @param burner The address to burn the tokens from 
320     /// @param _value The amount of tokens to be burnt
321     function burn(address burner, uint256 _value) public {
322         require(_value <= balances[burner]);
323         // no need to require value <= totalSupply, since that would imply the
324         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
325         if (_value > 0) {
326             balances[burner] = SafeMath.sub(balances[burner], _value);
327             totalSupply = SafeMath.sub(totalSupply, _value);
328             Burn(burner, _value);
329             Transfer(burner, address(0), _value);
330         }
331     }
332 
333     event Burn(address indexed burner, uint256 value);
334 }
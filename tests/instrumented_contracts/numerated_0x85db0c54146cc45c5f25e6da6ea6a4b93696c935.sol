1 /*
2 
3   Copyright 2018 Source Code Chain Foundation.
4 
5   Licensed under the Apache License, Version 2.0 (the "License");
6   you may not use this file except in compliance with the License.
7   You may obtain a copy of the License at
8 
9   http://www.apache.org/licenses/LICENSE-2.0
10 
11   Unless required by applicable law or agreed to in writing, software
12   distributed under the License is distributed on an "AS IS" BASIS,
13   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14   See the License for the specific language governing permissions and
15   limitations under the License.
16 
17 */
18 pragma solidity ^0.4.18;
19 
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27     /**
28     * @dev Multiplies two numbers, throws on overflow.
29     */
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31         if (a == 0) {
32             return 0;
33         }
34         uint256 c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers, truncating the quotient.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47     }
48 
49     /**
50     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     /**
58     * @dev Adds two numbers, throws on overflow.
59     */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 interface tokenRecipient {
68     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
69 }
70 
71 contract BasicERC20Token {
72     // Public variables of the token
73     // 18 decimals is the strongly suggested default, avoid changing it
74     uint256 public totalSupply;
75 
76     // This creates an array with all balances
77     mapping (address => uint256) public balances;
78     mapping (address => mapping (address => uint256)) public allowance;
79 
80     // This generates a public event on the blockchain that will notify clients
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     // This notifies clients about the amount burnt
84     event Burn(address indexed from, uint256 value);
85 
86     /**
87      * Internal transfer, only can be called by this contract
88      */
89     function _transfer(address _from, address _to, uint _value) internal {
90         // Prevent transfer to 0x0 address. Use burn() instead
91         require(_to != 0x0);
92         // Check if the sender has enough
93         require(balances[_from] >= _value);
94         // Check for overflows
95         require(balances[_to] + _value > balances[_to]);
96         // Save this for an assertion in the future
97         uint previousBalances = balances[_from] + balances[_to];
98         // Subtract from the sender
99         balances[_from] -= _value;
100         // Add the same to the recipient
101         balances[_to] += _value;
102         emit Transfer(_from, _to, _value);
103         // Asserts are used to use static analysis to find bugs in your code. They should never fail
104         assert(balances[_from] + balances[_to] == previousBalances);
105     }
106 
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     /**
112      * Transfer tokens
113      *
114      * Send `_value` tokens to `_to` from your account
115      *
116      * @param _to The address of the recipient
117      * @param _value the amount to send
118      */
119     function transfer(address _to, uint256 _value) public {
120         _transfer(msg.sender, _to, _value);
121     }
122 
123     /**
124      * Transfer tokens from other address
125      *
126      * Send `_value` tokens to `_to` on behalf of `_from`
127      *
128      * @param _from The address of the sender
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_value <= allowance[_from][msg.sender]);     // Check allowance
134         allowance[_from][msg.sender] -= _value;
135         _transfer(_from, _to, _value);
136         return true;
137     }
138 
139     /**
140      * Set allowance for other address
141      *
142      * Allows `_spender` to spend no more than `_value` tokens on your behalf
143      *
144      * @param _spender The address authorized to spend
145      * @param _value the max amount they can spend
146      */
147     function approve(address _spender, uint256 _value) public
148     returns (bool success) {
149         allowance[msg.sender][_spender] = _value;
150         return true;
151     }
152 
153     /**
154      * Set allowance for other address and notify
155      *
156      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
157      *
158      * @param _spender The address authorized to spend
159      * @param _value the max amount they can spend
160      * @param _extraData some extra information to send to the approved contract
161      */
162     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
163     public
164     returns (bool success) {
165         tokenRecipient spender = tokenRecipient(_spender);
166         if (approve(_spender, _value)) {
167             spender.receiveApproval(msg.sender, _value, this, _extraData);
168             return true;
169         }
170     }
171 
172     /**
173      * Destroy tokens
174      *
175      * Remove `_value` tokens from the system irreversibly
176      *
177      * @param _value the amount of money to burn
178      */
179     function burn(uint256 _value) public returns (bool success) {
180         require(balances[msg.sender] >= _value);   // Check if the sender has enough
181         balances[msg.sender] -= _value;            // Subtract from the sender
182         totalSupply -= _value;                      // Updates totalSupply
183         emit Burn(msg.sender, _value);
184         return true;
185     }
186 
187     /**
188      * Destroy tokens from other account
189      *
190      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
191      *
192      * @param _from the address of the sender
193      * @param _value the amount of money to burn
194      */
195     function burnFrom(address _from, uint256 _value) public returns (bool success) {
196         require(balances[_from] >= _value);                // Check if the targeted balance is enough
197         require(_value <= allowance[_from][msg.sender]);    // Check allowance
198         balances[_from] -= _value;                         // Subtract from the targeted balance
199         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
200         totalSupply -= _value;                              // Update totalSupply
201         emit Burn(_from, _value);
202         return true;
203     }
204 }
205 
206 
207 /**
208  * @title Source Code Chain AI Token.
209  * @author Bertrand Huang - <bertrand.huang@sourcecc.io>.
210  */
211 contract SCCAIToken is BasicERC20Token {
212     using SafeMath for uint256;
213     string public name = "Source Code Chain AI Token";
214     string public symbol = "SCC";
215     uint public decimals = 18;
216 
217     uint public exchange = 100000;
218 
219     address public target;
220 
221     address public foundationTarget;
222 
223 
224     bool public isStart = true;
225 
226     bool public isClose = false;
227 
228     modifier onlyOwner {
229         if (target == msg.sender) {
230             _;
231         } else {
232             revert();
233         }
234     }
235 
236     modifier inProgress {
237         if(isStart && !isClose) {
238             _;
239         }else {
240             revert();
241         }
242     }
243 
244     function SCCAIToken(address _target, address _foundationTarget) public{
245         target = _target;
246         foundationTarget = _foundationTarget;
247         totalSupply = 10000000000 * 10 ** uint256(decimals);
248         balances[target] = 2000000000 * 10 ** uint256(decimals);
249         balances[foundationTarget] = 8000000000 * 10 ** uint256(decimals);
250         emit Transfer(msg.sender, target, balances[target]);
251         emit Transfer(msg.sender, foundationTarget, balances[foundationTarget]);
252     }
253 
254     function open() public onlyOwner {
255         isStart = true;
256         isClose = false;
257     }
258 
259     function close() public onlyOwner inProgress {
260         isStart = false;
261         isClose = true;
262     }
263 
264 
265     function () payable public {
266         issueToken();
267     }
268 
269     function issueToken() payable inProgress public{
270         assert(balances[target] > 0);
271         assert(msg.value >= 0.0001 ether);
272         uint256 tokens = msg.value.mul(exchange);
273 
274         if (tokens > balances[target]) {
275             revert();
276         }
277 
278         balances[target] = balances[target].sub(tokens);
279         balances[msg.sender] = balances[msg.sender].add(tokens);
280 
281         emit Transfer(target, msg.sender, tokens);
282 
283         if (!target.send(msg.value)) {
284             revert();
285         }
286 
287     }
288 
289 }
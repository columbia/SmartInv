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
18 pragma solidity ^0.4.0;
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24 library SafeMath {
25 
26     /**
27     * @dev Multiplies two numbers, throws on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33         uint256 c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     /**
39     * @dev Integer division of two numbers, truncating the quotient.
40     */
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return c;
46     }
47 
48     /**
49     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
50     */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     /**
57     * @dev Adds two numbers, throws on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         assert(c >= a);
62         return c;
63     }
64 }
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/179
70  */
71 contract ERC20Basic {
72     function totalSupply() public view returns (uint256);
73     function balanceOf(address who) public view returns (uint256);
74     function transfer(address to, uint256 value) public returns (bool);
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 }
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84     using SafeMath for uint256;
85 
86     mapping(address => uint256) balances;
87 
88     uint256 totalSupply_;
89 
90     /**
91     * @dev total number of tokens in existence
92     */
93     function totalSupply() public view returns (uint256) {
94         return totalSupply_;
95     }
96 
97     /**
98     * @dev transfer token for a specified address
99     * @param _to The address to transfer to.
100     * @param _value The amount to be transferred.
101     */
102     function transfer(address _to, uint256 _value) public returns (bool) {
103         require(_to != address(0));
104         require(_value <= balances[msg.sender]);
105 
106         // SafeMath.sub will throw if there is not enough balance.
107         balances[msg.sender] = balances[msg.sender].sub(_value);
108         balances[_to] = balances[_to].add(_value);
109         emit Transfer(msg.sender, _to, _value);
110         return true;
111     }
112 
113     /**
114     * @dev Gets the balance of the specified address.
115     * @param _owner The address to query the the balance of.
116     * @return An uint256 representing the amount owned by the passed address.
117     */
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balances[_owner];
120     }
121 
122 }
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129     function allowance(address owner, address spender) public view returns (uint256);
130     function transferFrom(address from, address to, uint256 value) public returns (bool);
131     function approve(address spender, uint256 value) public returns (bool);
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 /**
136  * @title Standard ERC20 token
137  *
138  * @dev Implementation of the basic standard token.
139  * @dev https://github.com/ethereum/EIPs/issues/20
140  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
141  */
142 contract StandardToken is ERC20, BasicToken {
143 
144     mapping (address => mapping (address => uint256)) internal allowed;
145 
146 
147     /**
148      * @dev Transfer tokens from one address to another
149      * @param _from address The address which you want to send tokens from
150      * @param _to address The address which you want to transfer to
151      * @param _value uint256 the amount of tokens to be transferred
152      */
153     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
154         require(_to != address(0));
155         require(_value <= balances[_from]);
156         require(_value <= allowed[_from][msg.sender]);
157 
158         balances[_from] = balances[_from].sub(_value);
159         balances[_to] = balances[_to].add(_value);
160         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
161         emit Transfer(_from, _to, _value);
162         return true;
163     }
164 
165     /**
166      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167      *
168      * Beware that changing an allowance with this method brings the risk that someone may use both the old
169      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
170      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
171      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172      * @param _spender The address which will spend the funds.
173      * @param _value The amount of tokens to be spent.
174      */
175     function approve(address _spender, uint256 _value) public returns (bool) {
176         allowed[msg.sender][_spender] = _value;
177         emit Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     /**
182      * @dev Function to check the amount of tokens that an owner allowed to a spender.
183      * @param _owner address The address which owns the funds.
184      * @param _spender address The address which will spend the funds.
185      * @return A uint256 specifying the amount of tokens still available for the spender.
186      */
187     function allowance(address _owner, address _spender) public view returns (uint256) {
188         return allowed[_owner][_spender];
189     }
190 
191     /**
192      * @dev Increase the amount of tokens that an owner allowed to a spender.
193      *
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      * @param _spender The address which will spend the funds.
199      * @param _addedValue The amount of tokens to increase the allowance by.
200      */
201     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
202         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
203         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
204         return true;
205     }
206 
207     /**
208      * @dev Decrease the amount of tokens that an owner allowed to a spender.
209      *
210      * approve should be called when allowed[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * @param _spender The address which will spend the funds.
215      * @param _subtractedValue The amount of tokens to decrease the allowance by.
216      */
217     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
218         uint oldValue = allowed[msg.sender][_spender];
219         if (_subtractedValue > oldValue) {
220             allowed[msg.sender][_spender] = 0;
221         } else {
222             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223         }
224         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225         return true;
226     }
227 
228 }
229 
230 contract SCCToken is StandardToken {
231 
232     string public name = "Source Code Chain Token";
233     string public symbol = "SCC";
234     uint8 public decimals = 6;
235     uint public INITIAL_SUPPLY = 10000000000;
236 
237     uint256 public exchange = 100000 * 10 ** uint256(decimals);
238 
239     address public target;
240     address public foundationTarget;
241 
242     uint256 public totalWeiReceived = 0;
243     uint public issueIndex = 0;
244 
245     bool public isProgress = true;
246 
247     event Issue(uint issueIndex, address addr, uint256 ethAmount, uint256 tokenAmount);
248 
249     modifier owner {
250         if (target == msg.sender) {
251             _;
252         } else {
253             revert();
254         }
255     }
256 
257     modifier progress {
258         if (isProgress) {
259             _;
260         } else {
261             revert();
262         }
263     }
264 
265     function SCCToken(address _target, address _foundationTarget) public {
266         totalSupply_ = INITIAL_SUPPLY * 10 ** uint256(decimals);
267         target = _target;
268         foundationTarget = _foundationTarget;
269         balances[target] = 2000000000 * 10 ** uint256(decimals);
270         balances[foundationTarget] = 8000000000 * 10 ** uint256(decimals);
271     }
272 
273     function () payable progress public {
274         assert(balances[target] > 0);
275         assert(msg.value >= 0.0001 ether);
276         uint256 tokens;
277         uint256 usingWeiAmount;
278 
279         (tokens, usingWeiAmount) = computeTokenAmount(msg.value);
280 
281         totalWeiReceived = totalWeiReceived.add(usingWeiAmount);
282         balances[target] = balances[target].sub(tokens);
283         balances[msg.sender] = balances[msg.sender].add(tokens);
284 
285         emit Issue(
286             issueIndex++,
287             msg.sender,
288             usingWeiAmount,
289             tokens
290         );
291 
292         if (!target.send(usingWeiAmount)) {
293             revert();
294         }
295 
296         if(usingWeiAmount < msg.value) {
297             uint256 returnWeiAmount = msg.value - usingWeiAmount;
298             if(!msg.sender.send(returnWeiAmount)) {
299                 revert();
300             }
301         }
302     }
303 
304     function computeTokenAmount(uint256 weiAmount) internal view returns (uint256 tokens, uint256 usingWeiAmount) {
305         tokens = weiAmount.mul(exchange).div(10 ** uint256(18));
306         if(tokens <= balances[target]) {
307             usingWeiAmount = weiAmount;
308         }else {
309             tokens = balances[target];
310             usingWeiAmount = tokens.div(exchange).mul(10 ** uint256(18));
311         }
312         return (tokens, usingWeiAmount);
313     }
314 
315     function changeOwner(address _target) owner public {
316         if(_target != target) {
317             balances[_target] = balances[_target].add(balances[target]);
318             balances[target] = 0;
319             target = _target;
320         }
321     }
322 
323 }
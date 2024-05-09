1 /*
2   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
3   Licensed under the Apache License, Version 2.0 (the "License");
4   you may not use this file except in compliance with the License.
5   You may obtain a copy of the License at
6   http://www.apache.org/licenses/LICENSE-2.0
7   Unless required by applicable law or agreed to in writing, software
8   distributed under the License is distributed on an "AS IS" BASIS,
9   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
10   See the License for the specific language governing permissions and
11   limitations under the License.
12 */
13 pragma solidity 0.4.21;
14 /// @title Utility Functions for uint
15 /// @author Daniel Wang - <daniel@loopring.org>
16 library MathUint {
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function sub(uint a, uint b) internal pure returns (uint) {
22         require(b <= a);
23         return a - b;
24     }
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function tolerantSub(uint a, uint b) internal pure returns (uint c) {
30         return (a >= b) ? a - b : 0;
31     }
32     /// @dev calculate the square of Coefficient of Variation (CV)
33     /// https://en.wikipedia.org/wiki/Coefficient_of_variation
34     function cvsquare(
35         uint[] arr,
36         uint scale
37         )
38         internal
39         pure
40         returns (uint)
41     {
42         uint len = arr.length;
43         require(len > 1);
44         require(scale > 0);
45         uint avg = 0;
46         for (uint i = 0; i < len; i++) {
47             avg += arr[i];
48         }
49         avg = avg / len;
50         if (avg == 0) {
51             return 0;
52         }
53         uint cvs = 0;
54         uint s;
55         uint item;
56         for (i = 0; i < len; i++) {
57             item = arr[i];
58             s = item > avg ? item - avg : avg - item;
59             cvs += mul(s, s);
60         }
61         return ((mul(mul(cvs, scale), scale) / avg) / avg) / (len - 1);
62     }
63 }
64 /*
65     Copyright 2017 Loopring Project Ltd (Loopring Foundation).
66     Licensed under the Apache License, Version 2.0 (the "License");
67     you may not use this file except in compliance with the License.
68     You may obtain a copy of the License at
69     http://www.apache.org/licenses/LICENSE-2.0
70     Unless required by applicable law or agreed to in writing, software
71     distributed under the License is distributed on an "AS IS" BASIS,
72     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
73     See the License for the specific language governing permissions and
74     limitations under the License.
75 */
76 /*
77   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
78   Licensed under the Apache License, Version 2.0 (the "License");
79   you may not use this file except in compliance with the License.
80   You may obtain a copy of the License at
81   http://www.apache.org/licenses/LICENSE-2.0
82   Unless required by applicable law or agreed to in writing, software
83   distributed under the License is distributed on an "AS IS" BASIS,
84   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
85   See the License for the specific language governing permissions and
86   limitations under the License.
87 */
88 /// @title Utility Functions for address
89 /// @author Daniel Wang - <daniel@loopring.org>
90 library AddressUtil {
91     function isContract(address addr)
92         internal
93         view
94         returns (bool)
95     {
96         if (addr == 0x0) {
97             return false;
98         } else {
99             uint size;
100             assembly { size := extcodesize(addr) }
101             return size > 0;
102         }
103     }
104 }
105 /*
106   Copyright 2017 Loopring Project Ltd (Loopring Foundation).
107   Licensed under the Apache License, Version 2.0 (the "License");
108   you may not use this file except in compliance with the License.
109   You may obtain a copy of the License at
110   http://www.apache.org/licenses/LICENSE-2.0
111   Unless required by applicable law or agreed to in writing, software
112   distributed under the License is distributed on an "AS IS" BASIS,
113   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
114   See the License for the specific language governing permissions and
115   limitations under the License.
116 */
117 /// @title ERC20 Token Interface
118 /// @dev see https://github.com/ethereum/EIPs/issues/20
119 /// @author Daniel Wang - <daniel@loopring.org>
120 contract ERC20 {
121     function balanceOf(address who) view public returns (uint256);
122     function allowance(address owner, address spender) view public returns (uint256);
123     function transfer(address to, uint256 value) public returns (bool);
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125     function approve(address spender, uint256 value) public returns (bool);
126 }
127 /// @title ERC20 Token Implementation
128 /// @dev see https://github.com/ethereum/EIPs/issues/20
129 /// @author Daniel Wang - <daniel@loopring.org>
130 contract ERC20Token is ERC20 {
131     using MathUint for uint;
132     string  public name;
133     string  public symbol;
134     uint8   public decimals;
135     uint    public totalSupply_;
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) internal allowed;
138     event Transfer(address indexed from, address indexed to, uint256 value);
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140     function ERC20Token(
141         string  _name,
142         string  _symbol,
143         uint8   _decimals,
144         uint    _totalSupply,
145         address _firstHolder
146         )
147         public
148     {
149         require(bytes(_name).length > 0);
150         require(bytes(_symbol).length > 0);
151         require(_totalSupply > 0);
152         require(_firstHolder != 0x0);
153         name = _name;
154         symbol = _symbol;
155         decimals = _decimals;
156         totalSupply_ = _totalSupply;
157         balances[_firstHolder] = totalSupply_;
158     }
159     function () payable public
160     {
161         revert();
162     }
163     /**
164     * @dev total number of tokens in existence
165     */
166     function totalSupply() public view returns (uint256) {
167         return totalSupply_;
168     }
169     /**
170     * @dev transfer token for a specified address
171     * @param _to The address to transfer to.
172     * @param _value The amount to be transferred.
173     */
174     function transfer(
175         address _to,
176         uint256 _value
177         )
178         public
179         returns (bool)
180     {
181         require(_to != address(0));
182         require(_value <= balances[msg.sender]);
183         // SafeMath.sub will throw if there is not enough balance.
184         balances[msg.sender] = balances[msg.sender].sub(_value);
185         balances[_to] = balances[_to].add(_value);
186         emit Transfer(msg.sender, _to, _value);
187         return true;
188     }
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param _owner The address to query the the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address _owner)
195         public
196         view
197         returns (uint256 balance)
198     {
199         return balances[_owner];
200     }
201     /**
202      * @dev Transfer tokens from one address to another
203      * @param _from address The address which you want to send tokens from
204      * @param _to address The address which you want to transfer to
205      * @param _value uint256 the amount of tokens to be transferred
206      */
207     function transferFrom(
208         address _from,
209         address _to,
210         uint256 _value
211         )
212         public
213         returns (bool)
214     {
215         require(_to != address(0));
216         require(_value <= balances[_from]);
217         require(_value <= allowed[_from][msg.sender]);
218         balances[_from] = balances[_from].sub(_value);
219         balances[_to] = balances[_to].add(_value);
220         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221         emit Transfer(_from, _to, _value);
222         return true;
223     }
224     /**
225      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226      *
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param _spender The address which will spend the funds.
232      * @param _value The amount of tokens to be spent.
233      */
234     function approve(
235         address _spender,
236         uint256 _value
237         )
238         public
239         returns (bool)
240     {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245     /**
246      * @dev Function to check the amount of tokens that an owner allowed to a spender.
247      * @param _owner address The address which owns the funds.
248      * @param _spender address The address which will spend the funds.
249      * @return A uint256 specifying the amount of tokens still available for the spender.
250      */
251     function allowance(
252         address _owner,
253         address _spender)
254         public
255         view
256         returns (uint256)
257     {
258         return allowed[_owner][_spender];
259     }
260     /**
261      * @dev Increase the amount of tokens that an owner allowed to a spender.
262      *
263      * approve should be called when allowed[_spender] == 0. To increment
264      * allowed value is better to use this function to avoid 2 calls (and wait until
265      * the first transaction is mined)
266      * From MonolithDAO Token.sol
267      * @param _spender The address which will spend the funds.
268      * @param _addedValue The amount of tokens to increase the allowance by.
269      */
270     function increaseApproval(
271         address _spender,
272         uint _addedValue
273         )
274         public
275         returns (bool)
276     {
277         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
278         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279         return true;
280     }
281     /**
282      * @dev Decrease the amount of tokens that an owner allowed to a spender.
283      *
284      * approve should be called when allowed[_spender] == 0. To decrement
285      * allowed value is better to use this function to avoid 2 calls (and wait until
286      * the first transaction is mined)
287      * From MonolithDAO Token.sol
288      * @param _spender The address which will spend the funds.
289      * @param _subtractedValue The amount of tokens to decrease the allowance by.
290      */
291     function decreaseApproval(
292         address _spender,
293         uint _subtractedValue
294         )
295         public
296         returns (bool)
297     {
298         uint oldValue = allowed[msg.sender][_spender];
299         if (_subtractedValue > oldValue) {
300             allowed[msg.sender][_spender] = 0;
301         } else {
302             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303         }
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 }
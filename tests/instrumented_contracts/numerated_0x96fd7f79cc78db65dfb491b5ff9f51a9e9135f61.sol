1 /**
2     Copyright (c) 2018 SmartTaylor
3 
4     Permission is hereby granted, free of charge, to any person obtaining a copy
5     of this software and associated documentation files (the "Software"), to deal
6     in the Software without restriction, including without limitation the rights
7     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
8     copies of the Software, and to permit persons to whom the Software is
9     furnished to do so, subject to the following conditions:
10 
11     The above copyright notice and this permission notice shall be included in
12     all copies or substantial portions of the Software.
13 
14     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
15     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
16     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
17     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
18     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
19     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
20     THE SOFTWARE.
21 
22     based on the contracts of OpenZeppelin:
23     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
24 
25 **/
26 
27 pragma solidity 0.4.18;
28 
29 
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Math operations with safety checks that throw on error
35  */
36 library SafeMath {
37   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
38     if (a == 0) {
39       return 0;
40     }
41     uint256 c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66     Copyright (c) 2018 SmartTaylor
67 
68     Permission is hereby granted, free of charge, to any person obtaining a copy
69     of this software and associated documentation files (the "Software"), to deal
70     in the Software without restriction, including without limitation the rights
71     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
72     copies of the Software, and to permit persons to whom the Software is
73     furnished to do so, subject to the following conditions:
74 
75     The above copyright notice and this permission notice shall be included in
76     all copies or substantial portions of the Software.
77 
78     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
79     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
80     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
81     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
82     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
83     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
84     THE SOFTWARE.
85 
86     based on the contracts of OpenZeppelin:
87     https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts
88 
89 **/
90 
91 
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101 
102   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104 
105   /**
106    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
107    * account.
108    */
109   function Ownable() public {
110     owner = msg.sender;
111   }
112 
113 
114   /**
115    * @dev Throws if called by any account other than the owner.
116    */
117   modifier onlyOwner() {
118     require(msg.sender == owner);
119     _;
120   }
121 
122 
123   /**
124    * @dev Allows the current owner to transfer control of the contract to a newOwner.
125    * @param newOwner The address to transfer ownership to.
126    */
127   function transferOwnership(address newOwner) public onlyOwner {
128     require(newOwner != address(0));
129     OwnershipTransferred(owner, newOwner);
130     owner = newOwner;
131   }
132 
133 }
134 
135 
136 /**
137   @title TaylorToken
138 **/
139 contract TaylorToken is Ownable{
140 
141     using SafeMath for uint256;
142 
143     /**
144         EVENTS
145     **/
146     event Transfer(address indexed _from, address indexed _to, uint256 _value);
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148     event Burn(address indexed _owner, uint256 _amount);
149     /**
150         CONTRACT VARIABLES
151     **/
152     mapping (address => uint256) balances;
153     mapping (address => mapping (address => uint256)) allowed;
154 
155     //this address can transfer even when transfer is disabled.
156     mapping (address => bool) public whitelistedTransfer;
157     mapping (address => bool) public whitelistedBurn;
158 
159     string public name = "Taylor";
160     string public symbol = "TAY";
161     uint8 public decimals = 18;
162     uint256 constant internal DECIMAL_CASES = 10**18;
163     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
164     bool public transferable = false;
165 
166     /**
167         MODIFIERS
168     **/
169     modifier onlyWhenTransferable(){
170       if(!whitelistedTransfer[msg.sender]){
171         require(transferable);
172       }
173       _;
174     }
175 
176     /**
177         CONSTRUCTOR
178     **/
179 
180     /**
181       @dev Constructor function executed on contract creation
182     **/
183     function TaylorToken()
184       Ownable()
185       public
186     {
187       balances[owner] = balances[owner].add(totalSupply);
188       whitelistedTransfer[msg.sender] = true;
189       whitelistedBurn[msg.sender] = true;
190       Transfer(address(0),owner, totalSupply);
191     }
192 
193     /**
194         OWNER ONLY FUNCTIONS
195     **/
196 
197     /**
198       @dev Activates the trasfer for all users
199     **/
200     function activateTransfers()
201       public
202       onlyOwner
203     {
204       transferable = true;
205     }
206 
207     /**
208       @dev Allows the owner to add addresse that can bypass the
209       transfer lock. Eg: ICO contract, TGE contract.
210       @param _address address Address to be added
211     **/
212     function addWhitelistedTransfer(address _address)
213       public
214       onlyOwner
215     {
216       whitelistedTransfer[_address] = true;
217     }
218 
219     /**
220       @dev Sends all avaible TAY to the TGE contract to be properly
221       distribute
222       @param _tgeAddress address Address of the token distribution
223       contract
224     **/
225     function distribute(address _tgeAddress)
226       public
227       onlyOwner
228     {
229       whitelistedTransfer[_tgeAddress] = true;
230       transfer(_tgeAddress, balances[owner]);
231     }
232 
233 
234     /**
235       @dev Allows the owner to add addresse that can burn tokens
236       Eg: ICO contract, TGE contract.
237       @param _address address Address to be added
238     **/
239     function addWhitelistedBurn(address _address)
240       public
241       onlyOwner
242     {
243       whitelistedBurn[_address] = true;
244     }
245 
246     /**
247         PUBLIC FUNCTIONS
248     **/
249 
250     /**
251     * @dev transfer token for a specified address
252     * @param _to The address to transfer to.
253     * @param _value The amount to be transferred.
254     */
255     function transfer(address _to, uint256 _value)
256       public
257       onlyWhenTransferable
258       returns (bool success)
259     {
260       require(_to != address(0));
261       require(_value <= balances[msg.sender]);
262 
263       balances[msg.sender] = balances[msg.sender].sub(_value);
264       balances[_to] = balances[_to].add(_value);
265       Transfer(msg.sender, _to, _value);
266       return true;
267     }
268 
269     /**
270    * @dev Transfer tokens from one address to another
271    * @param _from address The address which you want to send tokens from
272    * @param _to address The address which you want to transfer to
273    * @param _value uint256 the amount of tokens to be transferred
274    */
275     function transferFrom
276       (address _from,
277         address _to,
278         uint256 _value)
279         public
280         onlyWhenTransferable
281         returns (bool success) {
282       require(_to != address(0));
283       require(_value <= balances[_from]);
284       require(_value <= allowed[_from][msg.sender]);
285 
286       balances[_from] = balances[_from].sub(_value);
287       balances[_to] = balances[_to].add(_value);
288       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
289       Transfer(_from, _to, _value);
290       return true;
291     }
292 
293     /**
294    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
295     For security reasons, if one need to change the value from a existing allowance, it must furst sets
296     it to zero and then sets the new value
297 
298    * @param _spender The address which will spend the funds.
299    * @param _value The amount of tokens to be spent.
300    */
301     function approve(address _spender, uint256 _value)
302       public
303       onlyWhenTransferable
304       returns (bool success)
305     {
306       allowed[msg.sender][_spender] = _value;
307       Approval(msg.sender, _spender, _value);
308       return true;
309     }
310 
311       /**
312      * @dev Increase the amount of tokens that an owner allowed to a spender.
313      *
314      * approve should be called when allowed[_spender] == 0. To increment
315      * allowed value is better to use this function to avoid 2 calls (and wait until
316      * the first transaction is mined)
317      * From MonolithDAO Token.sol
318      * @param _spender The address which will spend the funds.
319      * @param _addedValue The amount of tokens to increase the allowance by.
320      */
321     function increaseApproval(address _spender, uint _addedValue)
322       public
323       returns (bool)
324     {
325       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
326       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
327       return true;
328     }
329 
330     /**
331      * @dev Decrease the amount of tokens that an owner allowed to a spender.
332      *
333      * approve should be called when allowed[_spender] == 0. To decrement
334      * allowed value is better to use this function to avoid 2 calls (and wait until
335      * the first transaction is mined)
336      * From MonolithDAO Token.sol
337      * @param _spender The address which will spend the funds.
338      * @param _subtractedValue The amount of tokens to decrease the allowance by.
339      */
340     function decreaseApproval(address _spender, uint _subtractedValue)
341       public
342       returns (bool)
343     {
344       uint oldValue = allowed[msg.sender][_spender];
345       if (_subtractedValue > oldValue) {
346         allowed[msg.sender][_spender] = 0;
347       } else {
348         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
349       }
350       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
351       return true;
352     }
353 
354     /**
355       @dev Allows for msg.sender to burn his on tokens
356       @param _amount uint256 The amount of tokens to be burned
357     **/
358     function burn(uint256 _amount)
359       public
360       returns (bool success)
361     {
362       require(whitelistedBurn[msg.sender]);
363       require(_amount <= balances[msg.sender]);
364       balances[msg.sender] = balances[msg.sender].sub(_amount);
365       totalSupply =  totalSupply.sub(_amount);
366       Burn(msg.sender, _amount);
367       return true;
368     }
369 
370 
371     /**
372         CONSTANT FUNCTIONS
373     **/
374 
375     /**
376     * @dev Gets the balance of the specified address.
377     * @param _owner The address to query the the balance of.
378     * @return An uint256 representing the amount owned by the passed address.
379     */
380     function balanceOf(address _owner) view public returns (uint256 balance) {
381         return balances[_owner];
382     }
383 
384     /**
385    * @dev Function to check the amount of tokens that an owner allowed to a spender.
386    * @param _owner address The address which owns the funds.
387    * @param _spender address The address which will spend the funds.
388    * @return A uint256 specifying the amount of tokens still available for the spender.
389    */
390     function allowance(address _owner, address _spender)
391       view
392       public
393       returns (uint256 remaining)
394     {
395       return allowed[_owner][_spender];
396     }
397 
398 }
1 /**
2     Copyright (c) 2018 Taylor OÜ
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
65 
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   function Ownable() public {
84     owner = msg.sender;
85   }
86 
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) public onlyOwner {
102     require(newOwner != address(0));
103     OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 
107 }
108 
109 
110 /**
111   @title TaylorToken
112 **/
113 contract TaylorToken is Ownable{
114 
115     using SafeMath for uint256;
116 
117     /**
118         EVENTS
119     **/
120     event Transfer(address indexed _from, address indexed _to, uint256 _value);
121     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122     event Burn(address indexed _owner, uint256 _amount);
123     /**
124         CONTRACT VARIABLES
125     **/
126     mapping (address => uint256) balances;
127     mapping (address => mapping (address => uint256)) allowed;
128 
129     //this address can transfer even when transfer is disabled.
130     mapping (address => bool) public whitelistedTransfer;
131     mapping (address => bool) public whitelistedBurn;
132 
133     string public name = "Taylor";
134     string public symbol = "TAYLR";
135     uint8 public decimals = 18;
136     uint256 constant internal DECIMAL_CASES = 10**18;
137     uint256 public totalSupply = 10**7 * DECIMAL_CASES;
138     bool public transferable = false;
139 
140     /**
141         MODIFIERS
142     **/
143     modifier onlyWhenTransferable(){
144       if(!whitelistedTransfer[msg.sender]){
145         require(transferable);
146       }
147       _;
148     }
149 
150     /**
151         CONSTRUCTOR
152     **/
153 
154     /**
155       @dev Constructor function executed on contract creation
156     **/
157     function TaylorToken()
158       Ownable()
159       public
160     {
161       balances[owner] = balances[owner].add(totalSupply);
162       whitelistedTransfer[msg.sender] = true;
163       whitelistedBurn[msg.sender] = true;
164       Transfer(address(0),owner, totalSupply);
165     }
166 
167     /**
168         OWNER ONLY FUNCTIONS
169     **/
170 
171     /**
172       @dev Activates the trasfer for all users
173     **/
174     function activateTransfers()
175       public
176       onlyOwner
177     {
178       transferable = true;
179     }
180 
181     /**
182       @dev Allows the owner to add addresse that can bypass the
183       transfer lock. Eg: ICO contract, TGE contract.
184       @param _address address Address to be added
185     **/
186     function addWhitelistedTransfer(address _address)
187       public
188       onlyOwner
189     {
190       whitelistedTransfer[_address] = true;
191     }
192 
193     /**
194       @dev Sends all avaible TAY to the TGE contract to be properly
195       distribute
196       @param _tgeAddress address Address of the token distribution
197       contract
198     **/
199     function distribute(address _tgeAddress)
200       public
201       onlyOwner
202     {
203       whitelistedTransfer[_tgeAddress] = true;
204       transfer(_tgeAddress, balances[owner]);
205     }
206 
207 
208     /**
209       @dev Allows the owner to add addresse that can burn tokens
210       Eg: ICO contract, TGE contract.
211       @param _address address Address to be added
212     **/
213     function addWhitelistedBurn(address _address)
214       public
215       onlyOwner
216     {
217       whitelistedBurn[_address] = true;
218     }
219 
220     /**
221         PUBLIC FUNCTIONS
222     **/
223 
224     /**
225     * @dev transfer token for a specified address
226     * @param _to The address to transfer to.
227     * @param _value The amount to be transferred.
228     */
229     function transfer(address _to, uint256 _value)
230       public
231       onlyWhenTransferable
232       returns (bool success)
233     {
234       require(_to != address(0));
235       require(_value <= balances[msg.sender]);
236 
237       balances[msg.sender] = balances[msg.sender].sub(_value);
238       balances[_to] = balances[_to].add(_value);
239       Transfer(msg.sender, _to, _value);
240       return true;
241     }
242 
243     /**
244    * @dev Transfer tokens from one address to another
245    * @param _from address The address which you want to send tokens from
246    * @param _to address The address which you want to transfer to
247    * @param _value uint256 the amount of tokens to be transferred
248    */
249     function transferFrom
250       (address _from,
251         address _to,
252         uint256 _value)
253         public
254         onlyWhenTransferable
255         returns (bool success) {
256       require(_to != address(0));
257       require(_value <= balances[_from]);
258       require(_value <= allowed[_from][msg.sender]);
259 
260       balances[_from] = balances[_from].sub(_value);
261       balances[_to] = balances[_to].add(_value);
262       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
263       Transfer(_from, _to, _value);
264       return true;
265     }
266 
267     /**
268    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
269     For security reasons, if one need to change the value from a existing allowance, it must furst sets
270     it to zero and then sets the new value
271 
272    * @param _spender The address which will spend the funds.
273    * @param _value The amount of tokens to be spent.
274    */
275     function approve(address _spender, uint256 _value)
276       public
277       onlyWhenTransferable
278       returns (bool success)
279     {
280       allowed[msg.sender][_spender] = _value;
281       Approval(msg.sender, _spender, _value);
282       return true;
283     }
284 
285       /**
286      * @dev Increase the amount of tokens that an owner allowed to a spender.
287      *
288      * approve should be called when allowed[_spender] == 0. To increment
289      * allowed value is better to use this function to avoid 2 calls (and wait until
290      * the first transaction is mined)
291      * From MonolithDAO Token.sol
292      * @param _spender The address which will spend the funds.
293      * @param _addedValue The amount of tokens to increase the allowance by.
294      */
295     function increaseApproval(address _spender, uint _addedValue)
296       public
297       returns (bool)
298     {
299       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
300       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
301       return true;
302     }
303 
304     /**
305      * @dev Decrease the amount of tokens that an owner allowed to a spender.
306      *
307      * approve should be called when allowed[_spender] == 0. To decrement
308      * allowed value is better to use this function to avoid 2 calls (and wait until
309      * the first transaction is mined)
310      * From MonolithDAO Token.sol
311      * @param _spender The address which will spend the funds.
312      * @param _subtractedValue The amount of tokens to decrease the allowance by.
313      */
314     function decreaseApproval(address _spender, uint _subtractedValue)
315       public
316       returns (bool)
317     {
318       uint oldValue = allowed[msg.sender][_spender];
319       if (_subtractedValue > oldValue) {
320         allowed[msg.sender][_spender] = 0;
321       } else {
322         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
323       }
324       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
325       return true;
326     }
327 
328     /**
329       @dev Allows for msg.sender to burn his on tokens
330       @param _amount uint256 The amount of tokens to be burned
331     **/
332     function burn(uint256 _amount)
333       public
334       returns (bool success)
335     {
336       require(whitelistedBurn[msg.sender]);
337       require(_amount <= balances[msg.sender]);
338       balances[msg.sender] = balances[msg.sender].sub(_amount);
339       totalSupply =  totalSupply.sub(_amount);
340       Burn(msg.sender, _amount);
341       return true;
342     }
343 
344 
345     /**
346         CONSTANT FUNCTIONS
347     **/
348 
349     /**
350     * @dev Gets the balance of the specified address.
351     * @param _owner The address to query the the balance of.
352     * @return An uint256 representing the amount owned by the passed address.
353     */
354     function balanceOf(address _owner) view public returns (uint256 balance) {
355         return balances[_owner];
356     }
357 
358     /**
359    * @dev Function to check the amount of tokens that an owner allowed to a spender.
360    * @param _owner address The address which owns the funds.
361    * @param _spender address The address which will spend the funds.
362    * @return A uint256 specifying the amount of tokens still available for the spender.
363    */
364     function allowance(address _owner, address _spender)
365       view
366       public
367       returns (uint256 remaining)
368     {
369       return allowed[_owner][_spender];
370     }
371 
372 }
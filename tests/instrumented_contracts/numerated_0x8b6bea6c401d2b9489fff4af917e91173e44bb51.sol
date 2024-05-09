1 /**
2  * ERC-20 Standard Token Smart Contract Interface.
3  */
4 
5 pragma solidity ^0.4.11;
6 
7 /**
8  * ERC-20 standard token interface, as defined
9  * <a href="http://github.com/ethereum/EIPs/issues/20">here</a>.
10  */
11 contract ERC20Interface {
12   /**
13    * Get total number of tokens in circulation.
14    */
15   uint256 public totalSupply;
16 
17   /**
18    * @dev Get number of tokens currently belonging to given owner.
19    *
20    * @param _owner address to get number of tokens currently belonging to the
21    *         owner of
22    * @return number of tokens currently belonging to the owner of given address
23    */
24   function balanceOf (address _owner) constant returns (uint256 balance);
25 
26   /**
27    * @dev Transfer given number of tokens from message sender to given recipient.
28    *
29    * @param _to address to transfer tokens to the owner of
30    * @param _value number of tokens to transfer to the owner of given address
31    * @return true if tokens were transferred successfully, false otherwise
32    */
33   function transfer (address _to, uint256 _value) returns (bool success);
34 
35   /**
36    * @dev Transfer given number of tokens from given owner to given recipient.
37    *
38    * @param _from address to transfer tokens from the owner of
39    * @param _to address to transfer tokens to the owner of
40    * @param _value number of tokens to transfer from given owner to given
41    *         recipient
42    * @return true if tokens were transferred successfully, false otherwise
43    */
44   function transferFrom (address _from, address _to, uint256 _value)
45   returns (bool success);
46 
47   /**
48    * @dev Allow given spender to transfer given number of tokens from message sender.
49    *
50    * @param _spender address to allow the owner of to transfer tokens from
51    *         message sender
52    * @param _value number of tokens to allow to transfer
53    * @return true if token transfer was successfully approved, false otherwise
54    */
55   function approve (address _spender, uint256 _value) returns (bool success);
56 
57   /**
58    * @dev Tell how many tokens given spender is currently allowed to transfer from
59    * given owner.
60    *
61    * @param _owner address to get number of tokens allowed to be transferred
62    *        from the owner of
63    * @param _spender address to get number of tokens allowed to be transferred
64    *        by the owner of
65    * @return number of tokens given spender is currently allowed to transfer
66    *         from given owner
67    */
68   function allowance (address _owner, address _spender) constant
69   returns (uint256 remaining);
70 
71   /**
72    * @dev Logged when tokens were transferred from one owner to another.
73    *
74    * @param _from address of the owner, tokens were transferred from
75    * @param _to address of the owner, tokens were transferred to
76    * @param _value number of tokens transferred
77    */
78   event Transfer (address indexed _from, address indexed _to, uint256 _value);
79 
80   /**
81    * @dev Logged when owner approved his tokens to be transferred by some spender.
82    *
83    * @param _owner owner who approved his tokens to be transferred
84    * @param _spender spender who were allowed to transfer the tokens belonging
85    *        to the owner
86    * @param _value number of tokens belonging to the owner, approved to be
87    *        transferred by the spender
88    */
89   event Approval (
90     address indexed _owner, address indexed _spender, uint256 _value);
91 }
92 
93 contract Owned {
94     address public owner;
95     address public newOwner;
96 
97     function Owned() {
98         owner = msg.sender;
99     }
100 
101     modifier ownerOnly {
102         assert(msg.sender == owner);
103         _;
104     }
105 
106     /**
107      * @dev Transfers ownership. New owner has to accept in order ownership change to take effect
108      */
109     function transferOwnership(address _newOwner) public ownerOnly {
110         require(_newOwner != owner);
111         newOwner = _newOwner;
112     }
113 
114     /**
115      * @dev Accepts transferred ownership
116      */
117     function acceptOwnership() public {
118         require(msg.sender == newOwner);
119         OwnerUpdate(owner, newOwner);
120         owner = newOwner;
121         newOwner = 0x0;
122     }
123 
124     event OwnerUpdate(address _prevOwner, address _newOwner);
125 }
126 
127 /**
128  * Safe Math Smart Contract.  
129  */
130  
131 pragma solidity ^0.4.11;
132 
133 /**
134  * Provides methods to safely add, subtract and multiply uint256 numbers.
135  */
136 contract SafeMath {
137  
138   /**
139    * @dev Add two uint256 values, throw in case of overflow.
140    *
141    * @param a first value to add
142    * @param b second value to add
143    * @return x + y
144    */
145     function add(uint256 a, uint256 b) internal constant returns (uint256) {
146         uint256 c = a + b;
147         assert(c >= a);
148         return c;
149     }
150 
151   /**
152    * @dev Subtract one uint256 value from another, throw in case of underflow.
153    *
154    * @param a value to subtract from
155    * @param b value to subtract
156    * @return a - b
157    */
158     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
159         assert(b <= a);
160         return a - b;
161     }
162 
163 
164   /**
165    * @dev Multiply two uint256 values, throw in case of overflow.
166    *
167    * @param a first value to multiply
168    * @param b second value to multiply
169    * @return c = a * b
170    */
171     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
172         uint256 c = a * b;
173         assert(a == 0 || c / a == b);
174         return c;
175     }
176 
177  /**
178    * @dev Divide two uint256 values, throw in case of overflow.
179    *
180    * @param a first value to divide
181    * @param b second value to divide
182    * @return c = a / b
183    */
184         function div(uint256 a, uint256 b) internal constant returns (uint256) {
185         uint256 c = a / b;
186         return c;
187     }
188 }
189 
190 /*
191  * TokenRecepient
192  */
193 
194 pragma solidity ^0.4.11;
195 
196 contract TokenRecipient {
197     /**
198      * receive approval
199      */
200     function receiveApproval(address _from, uint256 _value, address _to, bytes _extraData);
201 }
202 
203 /**
204  * Standard Token Smart Contract that implements ERC-20 token interface
205  */
206 contract ExpandT is ERC20Interface, SafeMath, Owned {
207 
208     mapping (address => uint256) balances;
209     mapping (address => mapping (address => uint256)) allowed;
210     string public constant name = "ExpandT";
211     string public constant symbol = "EXT";
212     uint8 public constant decimals = 8;
213     string public version = '0.0.2';
214 
215     bool public transfersFrozen = false;
216 
217     /**
218      * Protection against short address attack
219      */
220     modifier onlyPayloadSize(uint numwords) {
221         assert(msg.data.length == numwords * 32 + 4);
222         _;
223     }
224 
225     /**
226      * Check if transfers are on hold - frozen
227      */
228     modifier whenNotFrozen(){
229         if (transfersFrozen) revert();
230         _;
231     }
232 
233 
234     function ExpandT() ownerOnly {
235         totalSupply = 1500000000000000;
236         balances[owner] = totalSupply;
237     }
238 
239 
240     /**
241      * Freeze token transfers.
242      */
243     function freezeTransfers () ownerOnly {
244         if (!transfersFrozen) {
245             transfersFrozen = true;
246             Freeze (msg.sender);
247         }
248     }
249 
250 
251     /**
252      * Unfreeze token transfers.
253      */
254     function unfreezeTransfers () ownerOnly {
255         if (transfersFrozen) {
256             transfersFrozen = false;
257             Unfreeze (msg.sender);
258         }
259     }
260 
261 
262     /**
263      * Transfer sender's tokens to a given address
264      */
265     function transfer(address _to, uint256 _value) whenNotFrozen onlyPayloadSize(2) returns (bool success) {
266         require(_to != 0x0);
267 
268         balances[msg.sender] = sub(balances[msg.sender], _value);
269         balances[_to] += _value;
270         Transfer(msg.sender, _to, _value);
271         return true;
272     }
273 
274 
275     /**
276      * Transfer _from's tokens to _to's address
277      */
278     function transferFrom(address _from, address _to, uint256 _value) whenNotFrozen onlyPayloadSize(3) returns (bool success) {
279         require(_to != 0x0);
280         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
281 
282         balances[_from] = sub(balances[_from], _value);
283         balances[_to] += _value;
284         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
285         Transfer(_from, _to, _value);
286         return true;
287     }
288 
289 
290     /**
291      * Returns number of tokens owned by given address.
292      */
293     function balanceOf(address _owner) constant returns (uint256 balance) {
294         return balances[_owner];
295     }
296 
297 
298     /**
299      * Sets approved amount of tokens for spender.
300      */
301     function approve(address _spender, uint256 _value) returns (bool success) {
302         require(_value == 0 || allowed[msg.sender][_spender] == 0);
303         allowed[msg.sender][_spender] = _value;
304         Approval(msg.sender, _spender, _value);
305         return true;
306     }
307 
308 
309     /**
310      * Approve and then communicate the approved contract in a single transaction
311      */
312     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
313         TokenRecipient spender = TokenRecipient(_spender);
314         if (approve(_spender, _value)) {
315             spender.receiveApproval(msg.sender, _value, this, _extraData);
316             return true;
317         }
318     }
319 
320 
321     /**
322      * Returns number of allowed tokens for given address.
323      */
324     function allowance(address _owner, address _spender) onlyPayloadSize(2) constant returns (uint256 remaining) {
325         return allowed[_owner][_spender];
326     }
327 
328 
329     /**
330      * Peterson's Law Protection
331      * Claim tokens
332      */
333     function claimTokens(address _token) ownerOnly {
334         if (_token == 0x0) {
335             owner.transfer(this.balance);
336             return;
337         }
338 
339         ExpandT token = ExpandT(_token);
340         uint balance = token.balanceOf(this);
341         token.transfer(owner, balance);
342 
343         Transfer(_token, owner, balance);
344     }
345 
346 
347     event Freeze (address indexed owner);
348     event Unfreeze (address indexed owner);
349 }
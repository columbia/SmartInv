1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipRenounced(address indexed previousOwner);
15   event OwnershipTransferred(
16     address indexed previousOwner,
17     address indexed newOwner
18   );
19 
20 
21   /**
22    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23    * account.
24    */
25   constructor() public {
26     owner = msg.sender;
27   }
28 
29   /**
30    * @dev Throws if called by any account other than the owner.
31    */
32   modifier onlyOwner() {
33     require(msg.sender == owner);
34     _;
35   }
36 
37   /**
38    * @dev Allows the current owner to relinquish control of the contract.
39    * @notice Renouncing to ownership will leave the contract without an owner.
40    * It will not be possible to call the functions with the `onlyOwner`
41    * modifier anymore.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address _newOwner) public onlyOwner {
53     _transferOwnership(_newOwner);
54   }
55 
56   /**
57    * @dev Transfers control of the contract to a newOwner.
58    * @param _newOwner The address to transfer ownership to.
59    */
60   function _transferOwnership(address _newOwner) internal {
61     require(_newOwner != address(0));
62     emit OwnershipTransferred(owner, _newOwner);
63     owner = _newOwner;
64   }
65 }
66 
67 
68 
69 interface DelegatedERC20 {
70     function allowance(address _owner, address _spender) external view returns (uint256); 
71     function transferFrom(address from, address to, uint256 value, address sender) external returns (bool); 
72     function approve(address _spender, uint256 _value, address sender) external returns (bool);
73     function totalSupply() external view returns (uint256);
74     function balanceOf(address _owner) external view returns (uint256);
75     function transfer(address _to, uint256 _value, address sender) external returns (bool);
76 }
77 
78 
79 interface ICapTables {
80     function balanceOf(uint256 token, address user) external view returns (uint256);
81     function initialize(uint256 supply, address holder) external returns (uint256);
82     function migrate(uint256 security, address newAddress) external;
83     function totalSupply(uint256 security) external view returns (uint256);
84     function transfer(uint256 security, address src, address dest, uint256 amount) external;
85 }
86 
87 
88 /**
89  * @title SafeMath
90  * @dev Math operations with safety checks that throw on error
91  */
92 library SafeMath {
93 
94   /**
95   * @dev Multiplies two numbers, throws on overflow.
96   */
97   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
98     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
99     // benefit is lost if 'b' is also tested.
100     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
101     if (_a == 0) {
102       return 0;
103     }
104 
105     c = _a * _b;
106     assert(c / _a == _b);
107     return c;
108   }
109 
110   /**
111   * @dev Integer division of two numbers, truncating the quotient.
112   */
113   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
114     // assert(_b > 0); // Solidity automatically throws when dividing by 0
115     // uint256 c = _a / _b;
116     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
117     return _a / _b;
118   }
119 
120   /**
121   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
122   */
123   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
124     assert(_b <= _a);
125     return _a - _b;
126   }
127 
128   /**
129   * @dev Adds two numbers, throws on overflow.
130   */
131   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
132     c = _a + _b;
133     assert(c >= _a);
134     return c;
135   }
136 }
137 
138 
139 /**
140  * @title DelegatedTokenLogic empty token
141  */
142 contract DelegatedTokenLogic is Ownable, DelegatedERC20 {
143     using SafeMath for uint256;
144 
145     address public capTables;
146     address public front;
147 
148     /**
149     * @Dev Index of this security in the global cap table store.
150     */
151     uint256 public index;
152 
153     mapping (address => mapping (address => uint256)) internal allowed;
154 
155     modifier onlyFront() {
156         require(msg.sender == front, "this method is reserved for the token front");
157         _;
158     }
159 
160     /**
161     * @dev Set the fronting token.
162     */
163     function setFront(address _front) public onlyOwner {
164         front = _front;
165     }
166 
167     /**
168     * @dev total number of tokens in existence
169     */
170     function totalSupply() public view returns (uint256) {
171         return ICapTables(capTables).totalSupply(index);
172     }
173 
174     /**
175     * @dev transfer token for a specified address
176     * @param _to The address to transfer to.
177     * @param _value The amount to be transferred.
178     */
179     function transfer(address _to, uint256 _value, address sender) 
180         public 
181         onlyFront 
182         returns (bool) 
183     {
184         require(_to != address(0), "tokens MUST NOT be transferred to the zero address");
185         ICapTables(capTables).transfer(index, sender, _to, _value);
186         return true;
187     }
188 
189     /**
190     * @dev Gets the balance of the specified address.
191     * @param _owner The address to query the the balance of.
192     * @return An uint256 representing the amount owned by the passed address.
193     */
194     function balanceOf(address _owner) public view returns (uint256 balance) {
195         return ICapTables(capTables).balanceOf(index, _owner);
196     }
197     /**
198     * @dev Transfer tokens from one address to another
199     * @param _from address The address which you want to send tokens from
200     * @param _to address The address which you want to transfer to
201     * @param _value uint256 the amount of tokens to be transferred
202     */
203     function transferFrom(address _from, address _to, uint256 _value, address sender) 
204         public 
205         onlyFront
206         returns (bool) 
207     {
208         require(_to != address(0), "tokens MUST NOT go to the zero address");
209         require(_value <= allowed[_from][sender], "transfer value MUST NOT exceed allowance");
210 
211         ICapTables(capTables).transfer(index, _from, _to, _value);
212         allowed[_from][sender] = allowed[_from][sender].sub(_value);
213         return true;
214     }
215 
216     /**
217     * @dev Approve the passed address to spend the specified amount of tokens on behalf of sender.
218     *
219     * Beware that changing an allowance with this method brings the risk that someone may use both the old
220     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223     * @param _spender The address which will spend the funds.
224     * @param _value The amount of tokens to be spent.
225     */
226     function approve(address _spender, uint256 _value, address sender) 
227         public 
228         onlyFront
229         returns (bool) 
230     {
231         allowed[sender][_spender] = _value;
232         return true;
233     }
234 
235     /**
236     * @dev Function to check the amount of tokens that an owner allowed to a spender.
237     * @param _owner address The address which owns the funds.
238     * @param _spender address The address which will spend the funds.
239     * @return A uint256 specifying the amount of tokens still available for the spender.
240     */
241     function allowance(address _owner, address _spender) public view returns (uint256) {
242         return allowed[_owner][_spender];
243     }
244 
245 }
246 
247 
248 /** 
249  * @title IndexConsumer
250  * @dev This contract adds an autoincrementing index to contracts. 
251  */
252 contract IndexConsumer {
253 
254     using SafeMath for uint256;
255 
256     /** The index */
257     uint256 private freshIndex = 0;
258 
259     /** Fetch the next index */
260     function nextIndex() internal returns (uint256) {
261         uint256 theIndex = freshIndex;
262         freshIndex = freshIndex.add(1);
263         return theIndex;
264     }
265 
266 }
267 
268 
269 
270 
271 /**
272  * One method for implementing a permissioned token is to appoint some
273  * authority which must decide whether to approve or refuse trades.  This
274  * contract implements this functionality.  
275  */
276 
277 contract SimplifiedLogic is IndexConsumer, DelegatedTokenLogic {
278 
279     string public name = "Test Fox Token";
280     string public symbol = "TFT";
281 
282 
283     enum TransferStatus {
284         Unused,
285         Active,
286         Resolved
287     }
288 
289     /** Data associated to a (request to) transfer */
290     struct TokenTransfer {
291         address src;
292         address dest;
293         uint256 amount;
294         address spender;
295         TransferStatus status;
296     }
297     
298     /** 
299      * The resolver determines whether a transfer ought to proceed and
300      * executes or nulls it. 
301      */
302     address public resolver;
303 
304     /** 
305      * Transfer requests are generated when a token owner (or delegate) wants
306      * to transfer some tokens.  They must be either executed or nulled by the
307      * resolver. 
308      */
309     mapping(uint256 => TokenTransfer) public transferRequests;
310 
311     /**
312      * The contract may be deactivated during a migration.
313      */
314     bool public contractActive = true;
315     
316     /** Represents that a user intends to make a transfer. */
317     event TransferRequest(
318         uint256 indexed index,
319         address src,
320         address dest,
321         uint256 amount,
322         address spender
323     );
324     
325     /** Represents the resolver's decision about the transfer. */
326     event TransferResult(
327         uint256 indexed index,
328         uint16 code
329     );
330         
331     /** 
332      * Methods that are only safe when the contract is in the active state.
333      */
334     modifier onlyActive() {
335         require(contractActive, "the contract MUST be active");
336         _;
337     }
338     
339     /**
340      * Forbidden to all but the resolver.
341      */
342     modifier onlyResolver() {
343         require(msg.sender == resolver, "this method is reserved for the designated resolver");
344         _;
345     }
346 
347     constructor(
348         uint256 _index,
349         address _capTables,
350         address _owner,
351         address _resolver
352     ) public {
353         index = _index;
354         capTables = _capTables;
355         owner = _owner;
356         resolver = _resolver;
357     }
358 
359     function transfer(address _dest, uint256 _amount, address _sender) 
360         public 
361         onlyFront 
362         onlyActive 
363         returns (bool) 
364     {
365         uint256 txfrIndex = nextIndex();
366         transferRequests[txfrIndex] = TokenTransfer(
367             _sender, 
368             _dest, 
369             _amount, 
370             _sender, 
371             TransferStatus.Active
372         );
373         emit TransferRequest(
374             txfrIndex,
375             _sender,
376             _dest,
377             _amount,
378             _sender
379         );
380         return false; // The transfer has not taken place yet
381     }
382 
383     function transferFrom(address _src, address _dest, uint256 _amount, address _sender) 
384         public 
385         onlyFront 
386         onlyActive 
387         returns (bool)
388     {
389         require(_amount <= allowed[_src][_sender], "the transfer amount MUST NOT exceed the allowance");
390         uint txfrIndex = nextIndex();
391         transferRequests[txfrIndex] = TokenTransfer(
392             _src, 
393             _dest, 
394             _amount, 
395             _sender, 
396             TransferStatus.Active
397         );
398         emit TransferRequest(
399             txfrIndex,
400             _src,
401             _dest,
402             _amount,
403             _sender
404         );
405         return false; // The transfer has not taken place yet
406     }
407 
408     function setResolver(address _resolver)
409         public
410         onlyOwner
411     {
412         resolver = _resolver;
413     }
414 
415     function resolve(uint256 _txfrIndex, uint16 _code) 
416         public 
417         onlyResolver
418         returns (bool result)
419     {
420         require(transferRequests[_txfrIndex].status == TransferStatus.Active, "the transfer request MUST be active");
421         TokenTransfer storage tfr = transferRequests[_txfrIndex];
422         result = false;
423         if (_code == 0) {
424             result = true;
425             if (tfr.spender == tfr.src) {
426                 // Vanilla transfer
427                 ICapTables(capTables).transfer(index, tfr.src, tfr.dest, tfr.amount);
428             } else {
429                 // Requires an allowance
430                 ICapTables(capTables).transfer(index, tfr.src, tfr.dest, tfr.amount);
431                 allowed[tfr.src][tfr.spender] = allowed[tfr.src][tfr.spender].sub(tfr.amount);
432             }
433         } 
434         transferRequests[_txfrIndex].status = TransferStatus.Resolved;
435         emit TransferResult(_txfrIndex, _code);
436     }
437 
438     function migrate(address newLogic) public onlyOwner {
439         contractActive = false;
440         ICapTables(capTables).migrate(index, newLogic);
441     }
442 
443 }
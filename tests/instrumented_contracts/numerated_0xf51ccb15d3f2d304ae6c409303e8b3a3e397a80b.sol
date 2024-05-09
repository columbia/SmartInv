1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-09
3 */
4 
5 pragma solidity ^0.4.26;
6 contract ERC20Basic {
7     function totalSupply() public view returns (uint256);
8     function balanceOf(address who) public view returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract ERC20 is ERC20Basic {
14     function allowance(address owner, address spender)
15         public view returns (uint256);
16     function transferFrom(address from, address to, uint256 value)
17         public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19     
20     event Approval(
21         address indexed owner,
22         address indexed spender,
23         uint256 value
24     );
25 }
26 library SafeERC20 {
27     function safeTransfer(
28         ERC20Basic _token,
29         address _to,
30         uint256 _value
31     ) internal
32     {
33         require(_token.transfer(_to, _value));
34     }
35     function safeTransferFrom(
36         ERC20 _token,
37         address _from,
38         address _to,
39         uint256 _value
40     ) internal
41     {
42         require(_token.transferFrom(_from, _to, _value));
43     }
44     function safeApprove(
45         ERC20 _token,
46         address _spender,
47         uint256 _value
48     ) internal
49     {
50         require(_token.approve(_spender, _value));
51     }
52 }
53 library SafeMath {
54     /**
55     * @dev Multiplies two numbers, throws on overflow.
56     */
57     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
58         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
59         // benefit is lost if 'b' is also tested.
60         if(a == 0) {
61             return 0;
62         }
63         c = a * b;
64         assert(c / a == b);
65         return c;
66     }
67     /**
68     * @dev Integer division of two numbers, truncating the quotient.
69     */
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         // assert(b > 0); // Solidity automatically throws when dividing by 0
72         // uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74         return a / b;
75     }
76     /**
77     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         assert(b <= a);
81         return a - b;
82     }
83     /**
84     * @dev Adds two numbers, throws on overflow.
85     */
86     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87         c = a + b;
88         assert(c >= a);
89         return c;
90     }
91 }
92 /**
93  * @title Open Proprietary Protocol token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97     using SafeMath for uint256;
98     
99     mapping(address => uint256) balances;
100     
101     uint256 totalSupply_;
102     /**
103     * @dev Total number of tokens in existence
104     */
105     function totalSupply() public view returns (uint256) {
106         return totalSupply_;
107     }
108     /**
109     * @dev Transfer token for a specified address
110     * @param _to The address to transfer to.
111     * @param _value The amount to be transferred.
112     */
113     function transfer(address _to, uint256 _value) public returns (bool) {
114         require(_to != address(0));
115         require(_value <= balances[msg.sender]);
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         
119         emit Transfer(msg.sender, _to, _value);
120         
121         return true;
122     }
123     /**
124     * @dev Gets the balance of the specified address.
125     * @param _owner The address to query the the balance of.
126     * @return An uint256 representing the amount owned by the passed address.
127     */
128     function balanceOf(address _owner) public view returns (uint256) {
129         return balances[_owner];
130     }
131 }
132 /**
133  * @title Standard ERC20 token
134  *
135  * @dev Implementation of the basic standard token.
136  */
137 contract StandardToken is ERC20, BasicToken {
138     mapping (address => mapping (address => uint256)) internal allowed;
139     /**
140     * @dev Transfer tokens from one address to another
141     * @param _from address The address which you want to send tokens from
142     * @param _to address The address which you want to transfer to
143     * @param _value uint256 the amount of tokens to be transferred
144     */
145     function transferFrom (
146         address _from,
147         address _to,
148         uint256 _value
149     ) public returns (bool)
150     {
151         require(_to != address(0));
152         require(_value <= balances[_from]);
153         require(_value <= allowed[_from][msg.sender]);
154         balances[_from] = balances[_from].sub(_value);
155         balances[_to] = balances[_to].add(_value);
156         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157         
158         emit Transfer(_from, _to, _value);
159         
160         return true;
161     }
162     function approve(address _spender, uint256 _value) public returns (bool) {
163         allowed[msg.sender][_spender] = _value;
164         
165         emit Approval(msg.sender, _spender, _value);
166         
167         return true;
168     }
169     function allowance (
170         address _owner,
171         address _spender
172     )
173         public
174         view
175         returns (uint256)
176     {
177         return allowed[_owner][_spender];
178     }
179     function increaseApproval(
180         address _spender,
181         uint256 _addedValue
182     )
183         public
184         returns (bool)
185     {
186         allowed[msg.sender][_spender] = (
187         allowed[msg.sender][_spender].add(_addedValue));
188         
189         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190         
191         return true;
192     }
193     /**
194     * @dev Decrease the amount of tokens that an owner allowed to a spender.
195     * approve should be called when allowed[_spender] == 0. To decrement
196     * allowed value is better to use this function to avoid 2 calls (and wait until
197     * the first transaction is mined)
198     * @param _spender The address which will spend the funds.
199     * @param _subtractedValue The amount of tokens to decrease the allowance by.
200     */
201     function decreaseApproval(
202         address _spender,
203         uint256 _subtractedValue
204     ) public returns (bool)
205     {
206         uint256 oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         
213         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
214         
215         return true;
216     }
217 }
218 contract Ownable {
219     uint8 constant MAX_BURN = 3;
220     address[MAX_BURN] public chkBurnerList;
221     
222     mapping(address => bool) public burners;
223     //mapping (address => bool) public owners;
224     address owner;
225     
226     event AddedBurner(address indexed newBurner);
227     event ChangeOwner(address indexed newOwner);
228     event DeletedBurner(address indexed toDeleteBurner);
229     constructor() public {
230         owner = msg.sender;
231     }
232     modifier onlyOwner() {
233         require(owner == msg.sender);
234         _;
235     }
236     modifier onlyBurner(){
237         require(burners[msg.sender]);
238         _;
239     }
240     
241     function changeOwnerShip(address newOwner) public onlyOwner returns(bool) {
242         require(newOwner != address(0));
243         owner = newOwner;
244         
245         emit ChangeOwner(newOwner);
246         
247         return true;
248     }
249     
250     function addBurner(address burner, uint8 num) public onlyOwner returns (bool) {
251         require(num < MAX_BURN);
252         require(burner != address(0));
253         require(chkBurnerList[num] == address(0));
254         require(burners[burner] == false);
255         burners[burner] = true;
256         chkBurnerList[num] = burner;
257         
258         emit AddedBurner(burner);
259         
260         return true;
261     }
262     function deleteBurner(address burner, uint8 num) public onlyOwner returns (bool){
263         require(num < MAX_BURN);
264         require(burner != address(0));
265         require(chkBurnerList[num] == burner);
266         
267         burners[burner] = false;
268         chkBurnerList[num] = address(0);
269         
270         emit DeletedBurner(burner);
271         
272         return true;
273     }
274 }
275 contract Blacklist is Ownable {
276     mapping(address => bool) blacklisted;
277     event Blacklisted(address indexed blacklist);
278     event Whitelisted(address indexed whitelist);
279     
280     modifier whenPermitted(address node) {
281         require(!blacklisted[node]);
282         _;
283     }
284     
285     function isPermitted(address node) public view returns (bool) {
286         return !blacklisted[node];
287     }
288     function blacklist(address node) public onlyOwner returns (bool) {
289         require(!blacklisted[node]);
290         blacklisted[node] = true;
291         emit Blacklisted(node);
292         return blacklisted[node];
293     }
294    
295     function unblacklist(address node) public onlyOwner returns (bool) {
296         require(blacklisted[node]);
297         blacklisted[node] = false;
298         emit Whitelisted(node);
299         return blacklisted[node];
300     }
301 }
302 contract Burnlist is Blacklist {
303     mapping(address => bool) public isburnlist;
304     event Burnlisted(address indexed burnlist, bool signal);
305     modifier isBurnlisted(address who) {
306         require(isburnlist[who]);
307         _;
308     }
309     function addBurnlist(address node) public onlyOwner returns (bool) {
310         require(!isburnlist[node]);
311         
312         isburnlist[node] = true;
313         
314         emit Burnlisted(node, true);
315         
316         return isburnlist[node];
317     }
318     function delBurnlist(address node) public onlyOwner returns (bool) {
319         require(isburnlist[node]);
320         
321         isburnlist[node] = false;
322         
323         emit Burnlisted(node, false);
324         
325         return isburnlist[node];
326     }
327 }
328 contract PausableToken is StandardToken, Burnlist {
329     
330     bool public paused = false;
331     
332     event Paused(address addr);
333     event Unpaused(address addr);
334     constructor() public {
335     }
336     
337     modifier whenNotPaused() {
338         require(!paused || owner == msg.sender);
339         _;
340     }
341    
342     function pause() public onlyOwner returns (bool) {
343         require(!paused);
344         paused = true;
345         
346         emit Paused(msg.sender);
347         return paused;
348     }
349     function unpause() public onlyOwner returns (bool) {
350         require(paused);
351         paused = false;
352         
353         emit Unpaused(msg.sender);
354         return paused;
355     }
356     function transfer(address to, uint256 value) public whenNotPaused whenPermitted(msg.sender) returns (bool) {
357        
358         return super.transfer(to, value);
359     }
360     function transferFrom(address from, address to, uint256 value) public 
361     whenNotPaused whenPermitted(from) whenPermitted(msg.sender) returns (bool) {
362       
363         return super.transferFrom(from, to, value);
364     }
365 }
366 /**
367  * @title Open Proprietary Protocol
368  *
369  */
370 contract OpenProprietaryProtocol is PausableToken {
371     
372     event Burn(address indexed burner, uint256 value);
373     event Mint(address indexed minter, uint256 value);
374     string public constant name = "Open Proprietary Protocol";
375     uint8 public constant decimals = 18;
376     string public constant symbol = "OPP";
377     uint256 public constant INITIAL_SUPPLY = 3e9 * (10 ** uint256(decimals)); 
378     constructor() public {
379         totalSupply_ = INITIAL_SUPPLY;
380         balances[msg.sender] = INITIAL_SUPPLY;
381         
382         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
383     }
384     function destory() public onlyOwner returns (bool) {
385         
386         selfdestruct(owner);
387         return true;
388     }
389  
390     function mint(uint256 _amount) public onlyOwner returns (bool) {
391         
392         require(INITIAL_SUPPLY >= totalSupply_.add(_amount));
393         
394         totalSupply_ = totalSupply_.add(_amount);
395         
396         balances[owner] = balances[owner].add(_amount);
397         emit Mint(owner, _amount);
398         
399         emit Transfer(address(0), owner, _amount);
400         
401         return true;
402     }
403  
404     function burn(address _to,uint256 _value) public onlyBurner isBurnlisted(_to) returns(bool) {
405         
406         _burn(_to, _value);
407         
408         return true;
409     }
410     function _burn(address _who, uint256 _value) internal returns(bool){     
411         require(_value <= balances[_who]);
412         
413         balances[_who] = balances[_who].sub(_value);
414         totalSupply_ = totalSupply_.sub(_value);
415     
416         emit Burn(_who, _value);
417         emit Transfer(_who, address(0), _value);
418         
419         return true;
420     }
421 }
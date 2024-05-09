1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) { return 0; }
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19     
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40     
41     event OwnershipRenounced(address indexed previousOwner);
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46     
47     constructor() public {
48         owner = msg.sender;
49     }
50     
51     modifier onlyOwner() {
52         require(msg.sender == owner);
53         _;
54     }
55     
56     function transferOwnership(address _newOwner) public onlyOwner {
57         _transferOwnership(_newOwner);
58     }
59     
60     function _transferOwnership(address _newOwner) internal {
61         require(_newOwner != address(0));
62         emit OwnershipTransferred(owner, _newOwner);
63         owner = _newOwner;
64     }
65 }
66 
67 
68 /**
69  * @title Pausable
70  * @dev Base contract which allows children to implement an emergency stop mechanism.
71  */
72 contract Pausable is Ownable {
73     event Pause();
74     event Unpause();
75     
76     bool public paused = false;
77     
78     modifier whenNotPaused() {
79         require(!paused);
80         _;
81     }
82     
83     modifier whenPaused() {
84         require(paused);
85         _;
86     }
87     
88     function pause() public onlyOwner whenNotPaused {
89         paused = true;
90         emit Pause();
91     }
92     
93     function unpause() public onlyOwner whenPaused {
94         paused = false;
95         emit Unpause();
96     }
97 }
98 
99 
100 contract ERC20Basic {
101     function totalSupply() public view returns (uint256);
102     function balanceOf(address who) public view returns (uint256);
103     
104     function transfer(
105         address to, 
106         uint256 value
107     ) 
108         public 
109         returns (bool);
110     
111     event Transfer(
112         address indexed from, 
113         address indexed to, 
114         uint256 value
115     );
116 }
117 
118 
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender) 
121         public view returns (uint256);
122         
123     function transferFrom(address from, address to, uint256 value) 
124         public returns (bool);
125         
126     function approve(address spender, uint256 value) 
127         public returns (bool);
128         
129     event Approval(
130         address indexed owner, 
131         address indexed spender, 
132         uint256 value
133     );
134 }
135 
136 
137 contract TokenRecipient {
138     function receiveApproval(
139         address from, 
140         uint256 tokens, 
141         address token, 
142         bytes data
143     )
144         public;
145 }
146 
147 
148 contract CLIXToken is ERC20, Ownable, Pausable {
149     
150     using SafeMath for uint256;
151 
152     mapping (address => uint256) balances;
153     mapping (address => mapping (address => uint256)) allowed;
154     mapping (address => bool) public whitelist;
155     mapping (address => bool) public blacklisted;
156     mapping (address => bool) public hasReceived;
157 
158     string public name = "CLIXToken";
159     string public symbol = "CLIX";
160     
161     uint public decimals = 18;
162     uint256 private totalSupply_ = 200000000e18;
163     uint256 private totalReserved = (totalSupply_.div(100)).mul(10);
164     uint256 private totalBounties = (totalSupply_.div(100)).mul(5);
165     uint256 public totalDistributed = totalReserved.add(totalBounties);
166     uint256 public totalRemaining = totalSupply_.sub(totalDistributed);
167     uint256 public tokenRate;
168     
169     bool public distributionFinished;
170 
171     event Transfer(
172         address indexed _from, 
173         address indexed _to, 
174         uint256 _value
175     );
176     
177     event Approval(
178         address indexed _owner, 
179         address indexed _spender, 
180         uint256 _value
181     );
182     
183     event Distribution(
184         address indexed to, 
185         uint256 amount
186     );
187     
188     modifier distributionAllowed() {
189         require(!distributionFinished);
190         _;
191     }
192     
193     modifier onlyWhitelist() {
194         require(whitelist[msg.sender]);
195         _;
196     }
197     
198     modifier notBlacklisted() {
199         require(!blacklisted[msg.sender]);
200         _;
201     }
202     
203     // mitigates the ERC20 short address attack
204     modifier onlyPayloadSize(uint size) {
205         assert(msg.data.length >= size + 4);
206         _;
207     }
208     
209     constructor(uint256 _tokenRate) public {
210         tokenRate = _tokenRate;
211         balances[msg.sender] = totalDistributed;
212     }
213     
214     function() external payable { getClixToken(); }
215     
216     function totalSupply() public view returns (uint256) {
217         return totalSupply_;
218     }
219     
220     function balanceOf(address _owner) public view returns (uint256) {
221 	    return balances[_owner];
222     }
223     
224     function setTokenRate(uint256 _tokenRate) public onlyOwner {
225         tokenRate = _tokenRate;
226     }
227     
228     function enableWhitelist(address[] addresses) public onlyOwner {
229         for (uint i = 0; i < addresses.length; i++) {
230             whitelist[addresses[i]] = true;
231         }
232     }
233 
234     function disableWhitelist(address[] addresses) public onlyOwner {
235         for (uint i = 0; i < addresses.length; i++) {
236             whitelist[addresses[i]] = false;
237         }
238     }
239     
240     function enableBlacklist(address[] addresses) public onlyOwner {
241         for (uint i = 0; i < addresses.length; i++) {
242             blacklisted[addresses[i]] = true;
243         }
244     }
245     
246     function disableBlacklist(address[] addresses) public onlyOwner {
247         for (uint i = 0; i < addresses.length; i++) {
248             blacklisted[addresses[i]] = false;
249         }
250     }
251     
252     function distributeToken(
253         address _to, 
254         uint256 _amount
255     ) 
256         private 
257         distributionAllowed 
258         whenNotPaused 
259         returns (bool)
260     {
261         totalDistributed = totalDistributed.add(_amount);
262         totalRemaining = totalRemaining.sub(_amount);
263         balances[_to] = balances[_to].add(_amount);
264         emit Distribution(_to, _amount);
265         emit Transfer(address(0), _to, _amount);
266         return true;
267         
268         if (totalDistributed >= totalSupply_) {
269             distributionFinished = true;
270         }
271     }
272     
273     function getClixToken() 
274         public 
275         payable 
276         distributionAllowed 
277         onlyWhitelist 
278         whenNotPaused 
279     {
280         require(tokenRate <= totalRemaining);
281         
282         /* Buyer has previously received their free tokens so this time we 
283         calculate how many tokens to send based on the amount of eth sent to the 
284         contract */
285         if (hasReceived[msg.sender]) {
286             uint256 ethInWei = msg.value;
287             uint256 weiNumber = 1000000000000000000;
288             uint256 divider = weiNumber.div(tokenRate.div(weiNumber));
289             uint256 tokenReceived = (ethInWei.div(divider)).mul(weiNumber);
290             distributeToken(msg.sender, tokenReceived);
291         } else {
292             // First time buyer gets free tokens (tokenRate)
293             distributeToken(msg.sender, tokenRate);
294         }
295 
296         if (!hasReceived[msg.sender] && tokenRate > 0) {
297             hasReceived[msg.sender] = true;
298         }
299 
300         if (totalDistributed >= totalSupply_) {
301             distributionFinished = true;
302         }
303     }
304     
305     function transfer(
306         address _to, 
307         uint256 _amount
308     ) 
309         public 
310         onlyPayloadSize(2 * 32) 
311         whenNotPaused 
312         notBlacklisted 
313         returns (bool success) 
314     {
315         require(_to != address(0));
316         require(_amount <= balances[msg.sender]);
317         balances[msg.sender] = balances[msg.sender].sub(_amount);
318         balances[_to] = balances[_to].add(_amount);
319         emit Transfer(msg.sender, _to, _amount);
320         return true;
321     }
322     
323     function transferFrom(
324         address _from, 
325         address _to, 
326         uint256 _amount
327     )
328         public 
329         onlyPayloadSize(3 * 32) 
330         whenNotPaused 
331         notBlacklisted 
332         returns (bool success) 
333     {
334         require(_to != address(0));
335         require(_amount <= balances[_from]);
336         require(_amount <= allowed[_from][msg.sender]);
337         balances[_from] = balances[_from].sub(_amount);
338         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
339         balances[_to] = balances[_to].add(_amount);
340         emit Transfer(_from, _to, _amount);
341         return true;
342     }
343     
344     function approve(
345         address _spender, 
346         uint256 _value
347     ) 
348         public 
349         whenNotPaused 
350         returns (bool success) 
351     {
352         // mitigates the ERC20 spend/approval race condition
353         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
354         allowed[msg.sender][_spender] = _value;
355         emit Approval(msg.sender, _spender, _value);
356         return true;
357     }
358     
359     function allowance(
360         address _owner, 
361         address _spender
362     ) 
363         public 
364         view 
365         whenNotPaused 
366         returns (uint256) 
367     {
368         return allowed[_owner][_spender];
369     }
370     
371     function withdraw() public onlyOwner {
372         uint256 etherBalance = address(this).balance;
373         owner.transfer(etherBalance);
374     }
375     
376     function withdrawTokens(
377         address tokenAddress, 
378         uint256 tokens
379     ) 
380         public
381         onlyOwner 
382         returns (bool success)
383     {
384         return ERC20Basic(tokenAddress).transfer(owner, tokens);
385     }
386     
387     function approveAndCall(
388         address _spender, 
389         uint256 _value, 
390         bytes _extraData
391     ) 
392         public 
393         whenNotPaused 
394     {
395         approve(_spender, _value);
396         TokenRecipient(_spender).receiveApproval(
397             msg.sender, 
398             _value, 
399             address(this), 
400             _extraData
401         );
402     }
403 
404 }
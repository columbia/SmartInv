1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66     function allowance(address owner, address spender) public view returns (uint256);
67     function transferFrom(address from, address to, uint256 value) public returns (bool);
68     function approve(address spender, uint256 value) public returns (bool);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78     address public owner;
79     address public systemAcc; // charge fee
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     function Ownable() public {
88         owner = msg.sender;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the systemAcc.
101      */
102     modifier onlySys() {
103         require(systemAcc !=address(0) && msg.sender == systemAcc);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         OwnershipTransferred(owner, newOwner);
114         owner = newOwner;
115     }
116 }
117 
118 /**
119  * @title Pausable
120  * @dev Base contract which allows children to implement an emergency stop mechanism.
121  */
122 contract Pausable is Ownable {
123     event Pause();
124     event Unpause();
125 
126     bool public paused = false;
127 
128     /**
129      * @dev Modifier to make a function callable only when the contract is not paused.
130      */
131     modifier whenNotPaused() {
132         require(!paused);
133         _;
134     }
135 
136     /**
137      * @dev Modifier to make a function callable only when the contract is paused.
138      */
139     modifier whenPaused() {
140         require(paused);
141         _;
142     }
143 
144     /**
145      * @dev called by the owner to pause, triggers stopped state
146      */
147     function pause() onlyOwner whenNotPaused public {
148         paused = true;
149         Pause();
150     }
151 
152     /**
153      * @dev called by the owner to unpause, returns to normal state
154      */
155     function unpause() onlyOwner whenPaused public {
156         paused = false;
157         Unpause();
158     }
159 }
160 
161 /**
162  * @title Basic token
163  * @dev Basic version of StandardToken, with no allowances.
164  */
165 contract BasicToken is ERC20Basic, Pausable {
166     using SafeMath for uint256;
167 
168     //   mapping(address => uint256) balances;
169     mapping(address => uint256) freeBalances;
170     mapping(address => uint256) frozenBalances;
171 
172     uint256 totalSupply_;
173 
174     /**
175     * @dev total number of tokens in existence
176     */
177     function totalSupply() public view returns (uint256) {
178         return totalSupply_;
179     }
180 
181     /**
182     * @dev transfer token for a specified address
183     * @param _to The address to transfer to.
184     * @param _value The amount to be transferred.
185     */
186     function transfer(address _to, uint256 _value) public returns (bool) {
187         require(_to != address(0));
188         require(_value <= freeBalances[msg.sender]);
189 
190         // SafeMath.sub will throw if there is not enough balance.
191         freeBalances[msg.sender] = freeBalances[msg.sender].sub(_value);
192         freeBalances[_to] = freeBalances[_to].add(_value);
193         Transfer(msg.sender, _to, _value);
194         return true;
195     }
196 
197     /**
198     * @dev Gets the balance of the specified address.
199     * @param _owner The address to query the the balance of.
200     * @return An uint256 representing the amount owned by the passed address.
201     */
202     function balanceOf(address _owner) public view returns (uint256 balance) {
203         return freeBalances[_owner] + frozenBalances[_owner];
204     }
205 
206     function freeBalanceOf(address _owner) public view returns (uint256 balance) {
207         return freeBalances[_owner];
208     }
209 
210     function frozenBalanceOf(address _owner) public view returns (uint256 balance) {
211         return frozenBalances[_owner];
212     }
213 }
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224     mapping (address => mapping (address => uint256)) internal allowed;
225 
226     /**
227      * @dev Transfer tokens from one address to another
228      * @param _from address The address which you want to send tokens from
229      * @param _to address The address which you want to transfer to
230      * @param _value uint256 the amount of tokens to be transferred
231      */
232     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
233         require(_to != address(0));
234         require(_value <= freeBalances[_from]);
235         require(_value <= allowed[_from][msg.sender]);
236 
237         freeBalances[_from] = freeBalances[_from].sub(_value);
238         freeBalances[_to] = freeBalances[_to].add(_value);
239         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240         Transfer(_from, _to, _value);
241         return true;
242     }
243 
244     /**
245      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246      *
247      * Beware that changing an allowance with this method brings the risk that someone may use both the old
248      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251      * @param _spender The address which will spend the funds.
252      * @param _value The amount of tokens to be spent.
253      */
254     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
255         allowed[msg.sender][_spender] = _value;
256         Approval(msg.sender, _spender, _value);
257         return true;
258     }
259 
260     /**
261      * @dev Function to check the amount of tokens that an owner allowed to a spender.
262      * @param _owner address The address which owns the funds.
263      * @param _spender address The address which will spend the funds.
264      * @return A uint256 specifying the amount of tokens still available for the spender.
265      */
266     function allowance(address _owner, address _spender) public view returns (uint256) {
267         return allowed[_owner][_spender];
268     }
269 
270     /**
271      * @dev Increase the amount of tokens that an owner allowed to a spender.
272      *
273      * approve should be called when allowed[_spender] == 0. To increment
274      * allowed value is better to use this function to avoid 2 calls (and wait until
275      * the first transaction is mined)
276      * From MonolithDAO Token.sol
277      * @param _spender The address which will spend the funds.
278      * @param _addedValue The amount of tokens to increase the allowance by.
279      */
280     function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
281         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
282         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
283         return true;
284     }
285 
286     /**
287      * @dev Decrease the amount of tokens that an owner allowed to a spender.
288      *
289      * approve should be called when allowed[_spender] == 0. To decrement
290      * allowed value is better to use this function to avoid 2 calls (and wait until
291      * the first transaction is mined)
292      * From MonolithDAO Token.sol
293      * @param _spender The address which will spend the funds.
294      * @param _subtractedValue The amount of tokens to decrease the allowance by.
295      */
296     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
297         uint oldValue = allowed[msg.sender][_spender];
298         if (_subtractedValue > oldValue) {
299             allowed[msg.sender][_spender] = 0;
300         } else {
301             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
302         }
303         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 }
307 
308 /**
309  * @title CXTCToken
310  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
311  * Note they can later distribute these tokens as they wish using `transfer` and other
312  * `StandardToken` functions.
313  */
314 contract CXTCContract is StandardToken {
315 
316     string public constant name = "Culture eXchange Token Chain"; // solium-disable-line uppercase
317     string public constant symbol = "CXTC"; // solium-disable-line uppercase
318     uint8 public constant decimals = 8; // solium-disable-line uppercase
319 
320     uint256 public constant freeSupply = 21000000 * (10 ** uint256(decimals)); // 10%自由量
321     uint256 public constant frozenSupply = 189000000 * (10 ** uint256(decimals)); // 90%冻结量
322 
323     address[] parterAcc;
324 
325     struct ArtInfo {
326         string idtReport;
327         string evtReport;
328         string escReport;
329         string regReport;
330     }
331 
332     mapping (string => ArtInfo) internal artInfos;
333     mapping (address => mapping (uint256 => uint256)) public freezeRecord;
334 
335     event Freeze(address indexed _addr, uint256 indexed _amount, uint256 indexed _timestamp);
336     event Defreeze(address indexed _addr, uint256 indexed _amount, uint256 indexed _timestamp);
337     event Release(address indexed _addr, uint256 indexed _amount);
338     event SetParter(address indexed _addr, uint256 indexed _amount);
339     event SetSysAcc(address indexed _addr);
340     event NewArt(string indexed _id);
341     event SetArtIdt(string indexed _id, string indexed _idtReport);
342     event SetArtEvt(string indexed _id, string indexed _evtReport);
343     event SetArtEsc(string indexed _id, string indexed _escReport);
344     event SetArtReg(string indexed _id, string indexed _regReport);
345 
346     /**
347      * @dev Constructor
348      */
349     function CXTCContract() public {
350         owner = msg.sender;
351         totalSupply_ = freeSupply + frozenSupply;
352         freeBalances[owner] = freeSupply;
353         frozenBalances[owner] = frozenSupply;
354     }
355 
356     /**
357      * init parter
358      */
359     function setParter(address _parter, uint256 _amount, uint256 _timestamp) public onlyOwner {
360         parterAcc.push(_parter);
361         frozenBalances[owner] = frozenBalances[owner].sub(_amount);
362         frozenBalances[_parter] = frozenBalances[_parter].add(_amount);
363         freezeRecord[_parter][_timestamp] = freezeRecord[_parter][_timestamp].add(_amount);
364         Freeze(_parter, _amount, _timestamp);
365         SetParter(_parter, _amount);
366     }
367 
368     /**
369      * set systemAccount
370      */
371     function setSysAcc(address _sysAcc) public onlyOwner returns (bool) {
372         systemAcc = _sysAcc;
373         SetSysAcc(_sysAcc);
374         return true;
375     }
376 
377     /**
378      * new art hash info
379      */
380     function newArt(string _id, string _regReport) public onlySys returns (bool) {
381         ArtInfo memory info = ArtInfo({idtReport: "", evtReport: "", escReport: "", regReport: _regReport});
382         artInfos[_id] = info;
383         NewArt(_id);
384         return true;
385     }
386 
387     /**
388      * get artInfo
389      */
390     function getArt(string _id) public view returns (string, string, string, string) {
391         ArtInfo memory info = artInfos[_id];
392         return (info.regReport, info.idtReport, info.evtReport, info.escReport);
393     }
394 
395     /**
396      * set art idtReport
397      */
398     function setArtIdt(string _id, string _idtReport) public onlySys returns (bool) {
399         string idtReport = artInfos[_id].idtReport;
400         bytes memory idtReportLen = bytes(idtReport);
401         if (idtReportLen.length == 0){
402             artInfos[_id].idtReport = _idtReport;
403             SetArtIdt(_id, _idtReport);
404             return true;
405         } else {
406             return false;
407         }
408     }
409 
410     /**
411      * set art evtReport
412      */
413     function setArtEvt(string _id, string _evtReport) public onlySys returns (bool) {
414         string evtReport = artInfos[_id].evtReport;
415         bytes memory evtReportLen = bytes(evtReport);
416         if (evtReportLen.length == 0){
417             artInfos[_id].evtReport = _evtReport;
418             SetArtEvt(_id, _evtReport);
419             return true;
420         } else {
421             return false;
422         }
423     }
424 
425     /**
426      * set art escrow report
427      */
428     function setArtEsc(string _id, string _escReport) public onlySys returns (bool) {
429         string escReport = artInfos[_id].escReport;
430         bytes memory escReportLen = bytes(escReport);
431         if (escReportLen.length == 0){
432             artInfos[_id].escReport = _escReport;
433             SetArtEsc(_id, _escReport);
434             return true;
435         } else {
436             return false;
437         }
438     }
439 
440     /**
441      * issue art coin to user.
442      */
443     function issue(address _addr, uint256 _amount, uint256 _timestamp) public onlySys returns (bool) {
444         // 2018/03/23 = 1521734400
445         require(frozenBalances[owner] >= _amount);
446         frozenBalances[owner] = frozenBalances[owner].sub(_amount);
447         frozenBalances[_addr]= frozenBalances[_addr].add(_amount);
448         freezeRecord[_addr][_timestamp] = freezeRecord[_addr][_timestamp].add(_amount);
449         Freeze(_addr, _amount, _timestamp);
450         return true;
451     }
452 
453     /**
454      * distribute
455      */
456     function distribute(address _to, uint256 _amount, uint256 _timestamp, address[] _addressLst, uint256[] _amountLst) public onlySys returns(bool) {
457         frozenBalances[_to]= frozenBalances[_to].add(_amount);
458         freezeRecord[_to][_timestamp] = freezeRecord[_to][_timestamp].add(_amount);
459         for(uint i = 0; i < _addressLst.length; i++) {
460             frozenBalances[_addressLst[i]] = frozenBalances[_addressLst[i]].sub(_amountLst[i]);
461             Defreeze(_addressLst[i], _amountLst[i], _timestamp);
462         }
463         Freeze(_to, _amount, _timestamp);
464         return true;
465     }
466 
467     /**
468      * send with charge fee
469      */
470     function send(address _to, uint256 _amount, uint256 _fee, uint256 _timestamp) public whenNotPaused returns (bool) {
471         require(freeBalances[msg.sender] >= _amount);
472         require(_amount >= _fee);
473         require(_to != address(0));
474         uint256 toAmt = _amount.sub(_fee);
475         freeBalances[msg.sender] = freeBalances[msg.sender].sub(_amount);
476         freeBalances[_to] = freeBalances[_to].add(toAmt);
477         // systemAcc
478         frozenBalances[systemAcc] = frozenBalances[systemAcc].add(_fee);
479         freezeRecord[systemAcc][_timestamp] = freezeRecord[systemAcc][_timestamp].add(_fee);
480         Transfer(msg.sender, _to, toAmt);
481         Freeze(systemAcc, _fee, _timestamp);
482         return true;
483     }
484 
485     /**
486      * user freeze free balance
487      */
488     function freeze(uint256 _amount, uint256 _timestamp) public whenNotPaused returns (bool) {
489         require(freeBalances[msg.sender] >= _amount);
490         freeBalances[msg.sender] = freeBalances[msg.sender].sub(_amount);
491         frozenBalances[msg.sender] = frozenBalances[msg.sender].add(_amount);
492         freezeRecord[msg.sender][_timestamp] = freezeRecord[msg.sender][_timestamp].add(_amount);
493         Freeze(msg.sender, _amount, _timestamp);
494         return true;
495     }
496 
497     /**
498      * auto release
499      */
500     function release(address[] _addressLst, uint256[] _amountLst) public onlySys returns (bool) {
501         require(_addressLst.length == _amountLst.length);
502         for(uint i = 0; i < _addressLst.length; i++) {
503             freeBalances[_addressLst[i]] = freeBalances[_addressLst[i]].add(_amountLst[i]);
504             frozenBalances[_addressLst[i]] = frozenBalances[_addressLst[i]].sub(_amountLst[i]);
505             Release(_addressLst[i], _amountLst[i]);
506         }
507         return true;
508     }
509 
510     /**
511      * bonus shares
512      */
513     function bonus(uint256 _sum, address[] _addressLst, uint256[] _amountLst) public onlySys returns (bool) {
514         require(frozenBalances[systemAcc] >= _sum);
515         require(_addressLst.length == _amountLst.length);
516         for(uint i = 0; i < _addressLst.length; i++) {
517             freeBalances[_addressLst[i]] = freeBalances[_addressLst[i]].add(_amountLst[i]);
518             Transfer(systemAcc, _addressLst[i], _amountLst[i]);
519         }
520         frozenBalances[systemAcc].sub(_sum);
521         Release(systemAcc, _sum);
522         return true;
523     }
524 }
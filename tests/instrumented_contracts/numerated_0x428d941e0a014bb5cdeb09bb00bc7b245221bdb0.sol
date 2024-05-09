1 pragma solidity ^0.4.24;
2 
3 // *-----------------------------------------------------------------------*
4 //       __ _    ________   __________  _____   __
5 //      / /| |  / / ____/  / ____/ __ \/  _/ | / /
6 //     / / | | / / __/    / /   / / / // //  |/ / 
7 //    / /__| |/ / /___   / /___/ /_/ // // /|  /  
8 //   /_____/___/_____/   \____/\____/___/_/ |_/  
9 // *-----------------------------------------------------------------------*
10 
11 
12 /**
13  * @title SafeMath
14  */
15 library SafeMath {
16 
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         assert(c / a == b);
23         return c;
24     }
25 
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a / b;
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 
44 /**
45  * @title Ownable
46  * @ multiSig
47  */
48 contract Ownable {
49 
50     // _from: oldOwner _to: newOwner
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52     event SubmitPrps(ProposalType indexed _prpsType);
53     event SignPrps(uint256 indexed _prpsIdx, ProposalType indexed _prpsType, address indexed _from);
54 
55     // owner proposal type enum
56     enum ProposalType {
57         freeze,
58         unfreeze,
59         transferOwner
60     }
61     // owner proposal
62     struct Proposal {
63         ProposalType prpsType;
64         address fromAddr;
65         address toAddr;
66         mapping(address => bool) signed;
67         bool finalized;
68     }
69     // require sign owner number
70     uint256 public requiredSignNum;
71     // all owner address
72     address[] public owners;
73     // owner proposal list
74     Proposal[] public proposals;
75     // is owner mapping
76     mapping(address => bool) public isOwnerMap;
77 
78     constructor() public{
79     }
80 
81     // is owner
82     modifier isOwner{
83         require(isOwnerMap[msg.sender], "");
84         _;
85     }
86     // is most owner sign proposal
87     modifier multiSig(uint256 _prpsIdx) {
88         // is more than half(多數決)
89         require(signOwnerCount(_prpsIdx) >= requiredSignNum, "");
90         // proposal is not finalized
91         require(proposals[_prpsIdx].finalized == false, "");
92         _;
93     }
94     // proposal is exist
95     modifier isPrpsExists(uint256 _prpsIdx) {
96         require(_prpsIdx >= 0, "");
97         require(_prpsIdx < proposals.length, "");
98         _;
99     }
100     modifier checkOwner(address _fromAddr, address _toAddr) {
101         require(_toAddr != address(0), "");
102         require(_toAddr != msg.sender, "");
103         require(_fromAddr != msg.sender, "");
104         _;
105     }
106     // is right proposal type
107     modifier checkPrpsType(ProposalType _prpsType) {
108         require(_prpsType == ProposalType.freeze || _prpsType == ProposalType.unfreeze || _prpsType == ProposalType.transferOwner, "");
109         _;
110     }
111     // check already sign prps
112     modifier checkSignPrps(uint256 _prpsIdx) {
113         // proposal is not finalized
114         require(proposals[_prpsIdx].finalized == false, "");
115         // owner is not signed
116         require(proposals[_prpsIdx].signed[msg.sender] == false, "");
117         _;
118     }
119 
120 
121     // any owner submit not certified proposal
122     function submitProposal(ProposalType _prpsType, address _fromAddr, address _toAddr) public isOwner checkOwner(_fromAddr, _toAddr) checkPrpsType(_prpsType) {
123         Proposal memory _proposal;
124         _proposal.prpsType = _prpsType;
125         _proposal.finalized = false;
126         _proposal.fromAddr = _fromAddr;
127         _proposal.toAddr = _toAddr;
128         proposals.push(_proposal);
129         emit SubmitPrps(_prpsType);
130     }
131 
132     // owner sign an proposal
133     function signProposal(uint256 _prpsIdx) public isOwner isPrpsExists(_prpsIdx) checkSignPrps(_prpsIdx){
134         proposals[_prpsIdx].signed[msg.sender] = true;
135         emit SignPrps(_prpsIdx, proposals[_prpsIdx].prpsType, msg.sender);
136     }
137 
138     // get proposal owner sign number(多數決)
139     function signOwnerCount(uint256 _prpsIdx) public view isPrpsExists(_prpsIdx) returns(uint256) {
140         uint256 signedCount = 0;
141         for(uint256 i = 0; i < owners.length; i++) {
142             if(proposals[_prpsIdx].signed[owners[i]] == true){
143                 signedCount++;
144             }
145         }
146         return signedCount;
147     }
148 
149     // proposal count nums
150     function getProposalCount() public view returns(uint256){
151         return proposals.length;
152     }
153     
154     // get proposal sign status info
155     function getProposalInfo(uint256 _prpsIdx) public view isPrpsExists(_prpsIdx) returns(ProposalType _prpsType, uint256 _signedCount, bool _isFinalized, address _fromAddr, address _toAddr){
156 
157         Proposal memory _proposal = proposals[_prpsIdx];
158         uint256 signCount = signOwnerCount(_prpsIdx);
159         return (_proposal.prpsType, signCount, _proposal.finalized, _proposal.fromAddr, _proposal.toAddr);
160     }
161 
162     // Transfer owner
163     function transferOwnership(uint256 _prpsIdx) public isOwner isPrpsExists(_prpsIdx) multiSig(_prpsIdx) {
164 
165         // is right enum proposalType
166         require(proposals[_prpsIdx].prpsType == ProposalType.transferOwner, "");
167         address oldOwnerAddr = proposals[_prpsIdx].fromAddr;
168         address newOwnerAddr = proposals[_prpsIdx].toAddr;
169         require(oldOwnerAddr != address(0), "");
170         require(newOwnerAddr != address(0), "");
171         require(oldOwnerAddr != newOwnerAddr, "");
172         for(uint256 i = 0; i < owners.length; i++) {
173             if( owners[i] == oldOwnerAddr){
174                 owners[i] = newOwnerAddr;
175                 delete isOwnerMap[oldOwnerAddr];
176                 isOwnerMap[newOwnerAddr] = true;
177             }
178         }
179         proposals[_prpsIdx].finalized = true;
180         emit OwnershipTransferred(oldOwnerAddr, newOwnerAddr);
181     }
182 
183 }
184 
185 
186 
187 /**
188  * @title Pausable
189  */
190 contract Pausable is Ownable {
191 
192     event Pause();
193     event Unpause();
194 
195     bool public paused = false;
196 
197     modifier whenNotPaused {
198         require(!paused, "");
199         _;
200     }
201     modifier whenPaused {
202         require(paused, "");
203         _;
204     }
205 
206     // Pause contract   
207     function pause() public isOwner whenNotPaused returns (bool) {
208         paused = true;
209         emit Pause();
210         return true;
211     }
212 
213     // Unpause contract
214     function unpause() public isOwner whenPaused returns (bool) {
215         paused = false;
216         emit Unpause();
217         return true;
218     }
219 
220 }
221 
222 
223 /**
224  * @title ERC20 interface
225  */
226 contract ERC20 {
227     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
228     // _from: _owner _to: _spender
229     event Approval(address indexed _from, address indexed _to, uint256 _amount);
230     function totalSupply() public view returns (uint256);
231     function balanceOf(address _owner) public view returns (uint256);
232     function transfer(address _to, uint256 _value) public returns (bool);
233     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
234     function approve(address _spender, uint256 _value) public returns (bool);
235     function allowance(address _owner, address _spender) public view returns (uint256);
236 }
237 
238 
239 
240 /**
241  * @title ERC20Token
242  */
243 contract ERC20Token is ERC20 {
244 
245     using SafeMath for uint256;
246 
247     mapping(address => uint256) balances;
248     mapping(address => mapping (address => uint256)) allowed;
249     uint256 public totalToken;
250 
251     function totalSupply() public view returns (uint256) {
252         return totalToken;
253     }
254 
255     function balanceOf(address _owner) public view returns (uint256) {
256         require(_owner != address(0), "");
257         return balances[_owner];
258     }
259 
260     // Transfer token by internal
261     function _transfer(address _from, address _to, uint256 _value) internal {
262         require(_to != address(0), "");
263         require(balances[_from] >= _value, "");
264 
265         balances[_from] = balances[_from].sub(_value);
266         balances[_to] = balances[_to].add(_value);
267         emit Transfer(_from, _to, _value);
268     }
269 
270     function transfer(address _to, uint256 _value) public returns (bool) {
271         require(_to != address(0), "");
272         _transfer(msg.sender, _to, _value);
273         return true;
274     }
275     
276     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
277         require(_from != address(0), "");
278         require(_to != address(0), "");
279         require(_value > 0, "");
280         require(balances[_from] >= _value, "");
281         require(allowed[_from][msg.sender] >= _value, "");
282 
283         balances[_from] = balances[_from].sub(_value);
284         balances[_to] = balances[_to].add(_value);
285         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286         emit Transfer(_from, _to, _value);
287         return true;
288     }
289 
290     function approve(address _spender, uint256 _value) public returns (bool){
291         require(_spender != address(0), "");
292         require(_value > 0, "");
293         allowed[msg.sender][_spender] = _value;
294         emit Approval(msg.sender, _spender, _value);
295         return true;
296     }
297 
298     function allowance(address _owner, address _spender) public view returns (uint256){
299         require(_owner != address(0), "");
300         require(_spender != address(0), "");
301         return allowed[_owner][_spender];
302     }
303 
304 }
305 
306 
307 /**
308  * @title LVECoin
309  */
310 contract LVECoin is ERC20Token, Pausable {
311 
312     string public  constant name        = "LVECoin";
313     string public  constant symbol      = "LVE";
314     uint256 public constant decimals    = 18;
315     // issue all token
316     uint256 private initialToken        = 2000000000 * (10 ** decimals);
317     
318     // _to: _freezeAddr
319     event Freeze(address indexed _to);
320     // _to: _unfreezeAddr
321     event Unfreeze(address indexed _to);
322     event WithdrawalEther(address indexed _to, uint256 _amount);
323     
324     // freeze account mapping
325     mapping(address => bool) public freezeAccountMap;  
326     // wallet Address
327     address private walletAddr;
328     // owner sign threshold
329     uint256 private signThreshold       = 3;
330 
331     constructor(address[] _initOwners, address _walletAddr) public{
332         require(_initOwners.length == signThreshold, "");
333         require(_walletAddr != address(0), "");
334 
335         // init owners
336         requiredSignNum = _initOwners.length.div(2).add(1);
337         owners = _initOwners;
338         for(uint i = 0; i < _initOwners.length; i++) {
339             isOwnerMap[_initOwners[i]] = true;
340         }
341 
342         totalToken = initialToken;
343         walletAddr = _walletAddr;
344         balances[msg.sender] = totalToken;
345         emit Transfer(0x0, msg.sender, totalToken);
346     }
347 
348 
349     // is freezeable account
350     modifier freezeable(address _addr) {
351         require(_addr != address(0), "");
352         require(!freezeAccountMap[_addr], "");
353         _;
354     }
355 
356     function transfer(address _to, uint256 _value) public whenNotPaused freezeable(msg.sender) returns (bool) {
357         require(_to != address(0), "");
358         return super.transfer(_to, _value);
359     }
360     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused freezeable(msg.sender) returns (bool) {
361         require(_from != address(0), "");
362         require(_to != address(0), "");
363         return super.transferFrom(_from, _to, _value);
364     }
365     function approve(address _spender, uint256 _value) public whenNotPaused freezeable(msg.sender) returns (bool) {
366         require(_spender != address(0), "");
367         return super.approve(_spender, _value);
368     }
369 
370     // freeze account
371     function freezeAccount(uint256 _prpsIdx) public isOwner isPrpsExists(_prpsIdx) multiSig(_prpsIdx) returns (bool) {
372 
373         // is right enum proposalType
374         require(proposals[_prpsIdx].prpsType == ProposalType.freeze, "");
375         address freezeAddr = proposals[_prpsIdx].toAddr;
376         require(freezeAddr != address(0), "");
377         // proposals execute over
378         proposals[_prpsIdx].finalized = true;
379         freezeAccountMap[freezeAddr] = true;
380         emit Freeze(freezeAddr);
381         return true;
382     }
383     
384     // unfreeze account
385     function unfreezeAccount(uint256 _prpsIdx) public isOwner isPrpsExists(_prpsIdx) multiSig(_prpsIdx) returns (bool) {
386 
387         // is right enum proposalType
388         require(proposals[_prpsIdx].prpsType == ProposalType.unfreeze, "");
389         address freezeAddr = proposals[_prpsIdx].toAddr;
390         require(freezeAddr != address(0), "");
391         // proposals execute over
392         proposals[_prpsIdx].finalized = true;
393         freezeAccountMap[freezeAddr] = false;
394         emit Unfreeze(freezeAddr);
395         return true;
396     }
397 
398     // if send ether then send ether to owner
399     function() public payable {
400         require(msg.value > 0, "");
401         walletAddr.transfer(msg.value);
402         emit WithdrawalEther(walletAddr, msg.value);
403     }
404 
405 }
1 pragma solidity ^0.4.22;
2 /*
3  * The MIT License (MIT)
4  *
5  * Copyright (c) 2018 Hexlant, Inc.
6  * 
7  * Permission is hereby granted, free of charge, to any person obtaining a copy
8  * of this software and associated documentation files (the "Software"), to deal
9  * in the Software without restriction, including without limitation the rights
10  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11  * copies of the Software, and to permit persons to whom the Software is
12  * furnished to do so, subject to the following conditions:
13  * 
14  * The above copyright notice and this permission notice shall be included in all
15  * copies or substantial portions of the Software.
16  * 
17  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
18  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
19  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
20  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
21  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
22  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
23  * SOFTWARE.
24  *
25  *
26  *
27  * Open Source License Announcement
28  * This smart contract code contains copyrighted source code under MIT License.
29  *  - Copyright (c) 2016 Smart Contract Solutions, Inc.
30  *    https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/LICENSE
31  *
32  * 
33  * Contact Us : contact@hexlant.com
34  * Website    : http://hexlant.com
35  * Medium Blog: https://medium.com/hexlant
36  */
37 
38 library SafeMath {
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         assert(c / a == b);
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         // assert(b > 0); // Solidity automatically throws when dividing by 0
51         uint256 c = a / b;
52         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53         return c;       
54     }       
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         assert(b <= a);
58         return a - b;
59     }
60 
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 }
67 
68 
69 contract Ownable {
70     address public owner;
71     address public newOwner;
72 
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor() public {
76         owner = msg.sender;
77         newOwner = address(0);
78     }
79 
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     modifier onlyNewOwner() {
85         require(msg.sender != address(0));
86         require(msg.sender == newOwner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         require(_newOwner != address(0));
92         newOwner = _newOwner;
93     }
94 
95     function acceptOwnership() public onlyNewOwner returns(bool) {
96         emit OwnershipTransferred(owner, newOwner);        
97         owner = newOwner;
98         newOwner = 0x0;
99     }
100 }
101 
102 contract Pausable is Ownable {
103     event Pause();
104     event Unpause();
105 
106     bool public paused = false;
107 
108     modifier whenNotPaused() {
109         require(!paused);
110         _;
111     }
112 
113     modifier whenPaused() {
114         require(paused);
115         _;
116     }
117 
118     function pause() onlyOwner whenNotPaused public {
119         paused = true;
120         emit Pause();
121     }
122 
123     function unpause() onlyOwner whenPaused public {
124         paused = false;
125         emit Unpause();
126     }
127 }
128 
129 contract ERC20 {
130     function totalSupply() public view returns (uint256);
131     function balanceOf(address who) public view returns (uint256);
132     function allowance(address owner, address spender) public view returns (uint256);
133     function transfer(address to, uint256 value) public returns (bool);
134     function transferFrom(address from, address to, uint256 value) public returns (bool);
135     function approve(address spender, uint256 value) public returns (bool);
136 
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 }
140 
141 
142 interface TokenRecipient {
143     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
144 }
145 
146 
147 contract SyncoToken is ERC20, Ownable, Pausable {
148 
149     using SafeMath for uint256;
150 
151     struct LockupInfo {
152         uint256 releaseTime;
153         uint256 termOfRound;
154         uint256 unlockAmountPerRound;        
155         uint256 lockupBalance;
156     }
157 
158     string public name;
159     string public symbol;
160     uint8 constant public decimals =18;
161     uint256 internal initialSupply;
162     uint256 internal totalSupply_;
163 
164     mapping(address => uint256) internal balances;
165     mapping(address => bool) internal locks;
166     mapping(address => bool) public frozen;
167     mapping(address => mapping(address => uint256)) internal allowed;
168     mapping(address => LockupInfo[]) internal lockupInfo;
169 
170     event Lock(address indexed holder, uint256 value);
171     event Unlock(address indexed holder, uint256 value);
172     event Burn(address indexed owner, uint256 value);
173     event Mint(uint256 value);
174     event Freeze(address indexed holder);
175     event Unfreeze(address indexed holder);
176 
177     modifier notFrozen(address _holder) {
178         require(!frozen[_holder]);
179         _;
180     }
181 
182     constructor() public {
183         name = "SYNCO Token";
184         symbol = "SYNCO";
185         initialSupply = 13000000000;
186         totalSupply_ = initialSupply * 10 ** uint(decimals);
187         balances[owner] = totalSupply_;
188         emit Transfer(address(0), owner, totalSupply_);
189     }
190 
191     function () public payable {
192         revert();
193     }
194 
195     function totalSupply() public view returns (uint256) {
196         return totalSupply_;
197     }
198 
199     function transfer(address _to, uint256 _value) public whenNotPaused notFrozen(msg.sender) returns (bool) {
200         if (locks[msg.sender]) {
201             autoUnlock(msg.sender);            
202         }
203         require(_to != address(0));
204         require(_value <= balances[msg.sender]);
205         
206 
207         // SafeMath.sub will throw if there is not enough balance.
208         balances[msg.sender] = balances[msg.sender].sub(_value);
209         balances[_to] = balances[_to].add(_value);
210         emit Transfer(msg.sender, _to, _value);
211         return true;
212     }
213 
214     function balanceOf(address _holder) public view returns (uint256 balance) {
215         uint256 lockedBalance = 0;
216         if(locks[_holder]) {
217             for(uint256 idx = 0; idx < lockupInfo[_holder].length ; idx++ ) {
218                 lockedBalance = lockedBalance.add(lockupInfo[_holder][idx].lockupBalance);
219             }
220         }
221         return balances[_holder] + lockedBalance;
222     }
223 
224     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused notFrozen(_from)returns (bool) {
225         if (locks[_from]) {
226             autoUnlock(_from);            
227         }
228         require(_to != address(0));
229         require(_value <= balances[_from]);
230         require(_value <= allowed[_from][msg.sender]);
231         
232 
233         balances[_from] = balances[_from].sub(_value);
234         balances[_to] = balances[_to].add(_value);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
241         allowed[msg.sender][_spender] = _value;
242         emit Approval(msg.sender, _spender, _value);
243         return true;
244     }
245     
246     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
247         require(isContract(_spender));
248         TokenRecipient spender = TokenRecipient(_spender);
249         if (approve(_spender, _value)) {
250             spender.receiveApproval(msg.sender, _value, this, _extraData);
251             return true;
252         }
253     }
254 
255     function allowance(address _holder, address _spender) public view returns (uint256) {
256         return allowed[_holder][_spender];
257     }
258 
259     function lock(address _holder, uint256 _amount, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
260         require(balances[_holder] >= _amount);
261         if(_termOfRound==0 ) {
262             _termOfRound = 1;
263         }
264         balances[_holder] = balances[_holder].sub(_amount);
265         lockupInfo[_holder].push(
266             LockupInfo(_releaseStart, _termOfRound, _amount.div(100).mul(_releaseRate), _amount)
267         );
268 
269         locks[_holder] = true;
270 
271         emit Lock(_holder, _amount);
272 
273         return true;
274     }
275 
276     function unlock(address _holder, uint256 _idx) public onlyOwner returns (bool) {
277         require(locks[_holder]);
278         require(_idx < lockupInfo[_holder].length);
279         LockupInfo storage lockupinfo = lockupInfo[_holder][_idx];
280         uint256 releaseAmount = lockupinfo.lockupBalance;
281 
282         delete lockupInfo[_holder][_idx];
283         lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
284         lockupInfo[_holder].length -=1;
285         if(lockupInfo[_holder].length == 0) {
286             locks[_holder] = false;
287         }
288 
289         emit Unlock(_holder, releaseAmount);
290         balances[_holder] = balances[_holder].add(releaseAmount);
291 
292         return true;
293     }
294 
295     function freezeAccount(address _holder) public onlyOwner returns (bool) {
296         require(!frozen[_holder]);
297         frozen[_holder] = true;
298         emit Freeze(_holder);
299         return true;
300     }
301 
302     function unfreezeAccount(address _holder) public onlyOwner returns (bool) {
303         require(frozen[_holder]);
304         frozen[_holder] = false;
305         emit Unfreeze(_holder);
306         return true;
307     }
308 
309     function getNowTime() public view returns(uint256) {
310         return now;
311     }
312 
313     function showLockState(address _holder, uint256 _idx) public view returns (bool, uint256, uint256, uint256, uint256, uint256) {
314         if(locks[_holder]) {
315             return (
316                 locks[_holder], 
317                 lockupInfo[_holder].length, 
318                 lockupInfo[_holder][_idx].lockupBalance, 
319                 lockupInfo[_holder][_idx].releaseTime, 
320                 lockupInfo[_holder][_idx].termOfRound, 
321                 lockupInfo[_holder][_idx].unlockAmountPerRound
322             );
323         } else {
324             return (
325                 locks[_holder], 
326                 lockupInfo[_holder].length, 
327                 0,0,0,0
328             );
329 
330         }        
331     }
332     
333     function distribute(address _to, uint256 _value) public onlyOwner returns (bool) {
334         require(_to != address(0));
335         require(_value <= balances[owner]);
336 
337         balances[owner] = balances[owner].sub(_value);
338         balances[_to] = balances[_to].add(_value);
339         emit Transfer(owner, _to, _value);
340         return true;
341     }
342 
343     function distributeWithLockup(address _to, uint256 _value, uint256 _releaseStart, uint256 _termOfRound, uint256 _releaseRate) public onlyOwner returns (bool) {
344         distribute(_to, _value);
345         lock(_to, _value, _releaseStart, _termOfRound, _releaseRate);
346         return true;
347     }
348 
349     function claimToken(ERC20 token, address _to, uint256 _value) public onlyOwner returns (bool) {
350         token.transfer(_to, _value);
351         return true;
352     }
353 
354     function burn(uint256 _value) public onlyOwner returns (bool success) {
355         require(_value <= balances[msg.sender]);
356         address burner = msg.sender;
357         balances[burner] = balances[burner].sub(_value);
358         totalSupply_ = totalSupply_.sub(_value);
359         emit Burn(burner, _value);
360         return true;
361     }
362 
363     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
364         totalSupply_ = totalSupply_.add(_amount);
365         balances[_to] = balances[_to].add(_amount);
366 
367         emit Transfer(address(0), _to, _amount);
368         return true;
369     }
370 
371     function isContract(address addr) internal view returns (bool) {
372         uint size;
373         assembly{size := extcodesize(addr)}
374         return size > 0;
375     }
376 
377     function autoUnlock(address _holder) internal returns (bool) {
378 
379         for(uint256 idx =0; idx < lockupInfo[_holder].length ; idx++ ) {
380             if(locks[_holder]==false) {
381                 return true;
382             }
383             if (lockupInfo[_holder][idx].releaseTime <= now) {
384                 // If lockupinfo was deleted, loop restart at same position.
385                 if( releaseTimeLock(_holder, idx) ) {
386                     idx -=1;
387                 }
388             }
389         }
390         return true;
391     }
392 
393     function releaseTimeLock(address _holder, uint256 _idx) internal returns(bool) {
394         require(locks[_holder]);
395         require(_idx < lockupInfo[_holder].length);
396 
397         // If lock status of holder is finished, delete lockup info. 
398         LockupInfo storage info = lockupInfo[_holder][_idx];
399         uint256 releaseAmount = info.unlockAmountPerRound;
400         uint256 sinceFrom = now.sub(info.releaseTime);
401         uint256 sinceRound = sinceFrom.div(info.termOfRound);
402         releaseAmount = releaseAmount.add( sinceRound.mul(info.unlockAmountPerRound) );
403 
404         if(releaseAmount >= info.lockupBalance) {            
405             releaseAmount = info.lockupBalance;
406 
407             delete lockupInfo[_holder][_idx];
408             lockupInfo[_holder][_idx] = lockupInfo[_holder][lockupInfo[_holder].length.sub(1)];
409             lockupInfo[_holder].length -=1;
410 
411             if(lockupInfo[_holder].length == 0) {
412                 locks[_holder] = false;
413             }
414             emit Unlock(_holder, releaseAmount);
415             balances[_holder] = balances[_holder].add(releaseAmount);
416             return true;
417         } else {
418             lockupInfo[_holder][_idx].releaseTime = lockupInfo[_holder][_idx].releaseTime.add( sinceRound.add(1).mul(info.termOfRound) );
419             lockupInfo[_holder][_idx].lockupBalance = lockupInfo[_holder][_idx].lockupBalance.sub(releaseAmount);
420             emit Unlock(_holder, releaseAmount);
421             balances[_holder] = balances[_holder].add(releaseAmount);
422             return false;
423         }
424     }
425 
426 
427 }
1 contract IERC20Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}   
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     function Owned() public{
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         assert(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         require(_newOwner != owner);
52         newOwner = _newOwner;
53     }
54 
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = 0x0;
60     }
61 
62     event OwnerUpdate(address _prevOwner, address _newOwner);
63 }
64 contract SafeMath {
65     
66     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
67 
68     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
69         require(x <= MAX_UINT256 - y);
70         return x + y;
71     }
72 
73     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
74         require(x >= y);
75         return x - y;
76     }
77 
78     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
79         if (y == 0) {
80             return 0;
81         }
82         require(x <= (MAX_UINT256 / y));
83         return x * y;
84     }
85 }
86 
87 
88 contract LinkedList {
89 
90     struct Element {
91         uint previous;
92         uint next;
93 
94         address data;
95     }
96 
97     uint public size;
98     uint public tail;
99     uint public head;
100     mapping(uint => Element) elements;
101     mapping(address => uint) elementLocation;
102 
103     function addItem(address _newItem) public returns (bool) {
104         Element memory elem = Element(0, 0, _newItem);
105 
106         if (size == 0) {
107             head = 1;
108         } else {
109             elements[tail].next = tail + 1;
110             elem.previous = tail;
111         }
112 
113         elementLocation[_newItem] = tail + 1;
114         elements[tail + 1] = elem;
115         size++;
116         tail++;
117         return true;
118     }
119 
120     function removeItem(address _item) public returns (bool) {
121         uint key;
122         if (elementLocation[_item] == 0) {
123             return false;
124         }else {
125             key = elementLocation[_item];
126         }
127 
128         if (size == 1) {
129             tail = 0;
130             head = 0;
131         }else if (key == head) {
132             head = elements[head].next;
133         }else if (key == tail) {
134             tail = elements[tail].previous;
135             elements[tail].next = 0;
136         }else {
137             elements[key - 1].next = elements[key].next;
138             elements[key + 1].previous = elements[key].previous;
139         }
140 
141         size--;
142         delete elements[key];
143         elementLocation[_item] = 0;
144         return true;
145     }
146 
147     function getAllElements() constant public returns(address[]) {
148         address[] memory tempElementArray = new address[](size);
149         uint cnt = 0;
150         uint currentElemId = head;
151         while (cnt < size) {
152             tempElementArray[cnt] = elements[currentElemId].data;
153             currentElemId = elements[currentElemId].next;
154             cnt += 1;
155         }
156         return tempElementArray;
157     }
158 
159     function getElementAt(uint _index) constant public returns (address) {
160         return elements[_index].data;
161     }
162 
163     function getElementLocation(address _element) constant public returns (uint) {
164         return elementLocation[_element];
165     }
166 
167     function getNextElement(uint _currElementId) constant public returns (uint) {
168         return elements[_currElementId].next;
169     }
170 }
171 
172 contract ICreditBIT{
173     function claimGameReward(address _champion, uint _lockedTokenAmount, uint _lockTime) returns (uint error);
174 }
175 
176 contract CreditGAME is Owned, SafeMath, LinkedList{
177     
178     mapping(address => bool) approvedGames;
179     mapping(address => GameLock) gameLocks;
180     mapping(address => bool) public isGameLocked;
181     mapping(uint => address) public concludedGames;
182     
183     uint public amountLocked = 0;
184     uint public concludedGameIndex = 0;
185     
186     struct GameLock{
187         uint amount;
188         uint lockDuration;
189     }
190     
191     event LockParameters(address gameAddress, uint totalParticipationAmount, uint tokenLockDuration);
192     event UnlockParameters(address gameAddress, uint totalParticipationAmount);
193     event GameConcluded(address gameAddress);
194 
195     //SET TOKEN ADDRESS BEFORE DEPLOY
196     address public tokenAddress = 0xAef38fBFBF932D1AeF3B808Bc8fBd8Cd8E1f8BC5;
197     
198     /**
199      * Set CRB token address here
200      * 
201      **/
202     function setTokenAddress(address _tokenAddress) onlyOwner public {
203         tokenAddress = _tokenAddress;
204     }
205 
206     /**
207      * When new game is created it needs to be approved here before it starts.
208      * 
209      **/
210     function addApprovedGame(address _gameAddress) onlyOwner public{
211         approvedGames[_gameAddress] = true;
212         addItem(_gameAddress);
213     }
214     
215     /**
216      * Manually remove approved game.
217      * 
218      **/
219     function removeApprovedGame(address _gameAddress) onlyOwner public{
220         approvedGames[_gameAddress] = false;
221         removeItem(_gameAddress);
222     }
223 
224     /**
225      * Remove failed game.
226      * 
227      **/
228     function removeFailedGame() public{
229       require(approvedGames[msg.sender] == true);
230       removeItem(msg.sender);
231       approvedGames[msg.sender] = false;
232       concludedGames[concludedGameIndex] = msg.sender; 
233       concludedGameIndex++;
234       emit GameConcluded(msg.sender);
235     }
236     
237     /**
238      * Verify if game is approved
239      * 
240      **/
241     function isGameApproved(address _gameAddress) view public returns(bool){
242         if(approvedGames[_gameAddress] == true){
243             return true;
244         }else{
245             return false;
246         }
247     }
248     
249     /**
250      * Funds must be transfered by calling contract before calling this contract. 
251      * msg.sender is address of calling contract that must be approved.
252      * 
253      **/
254     function createLock(address _winner, uint _totalParticipationAmount, uint _tokenLockDuration) public {
255         require(approvedGames[msg.sender] == true);
256         require(isGameLocked[msg.sender] == false);
257         
258         //Create gameLock
259         GameLock memory gameLock = GameLock(_totalParticipationAmount, block.number + _tokenLockDuration);
260         gameLocks[msg.sender] = gameLock;
261         isGameLocked[msg.sender] = true;
262         amountLocked = safeAdd(amountLocked, _totalParticipationAmount);
263         
264         //Transfer game credits to winner
265         generateChampionTokens(_winner, _totalParticipationAmount, _tokenLockDuration);
266         emit LockParameters(msg.sender, _totalParticipationAmount, block.number + _tokenLockDuration);
267     }
268     
269     /**
270      * Call CRB token to mint champion tokens
271      * 
272      **/
273     function generateChampionTokens(address _winner, uint _totalParticipationAmount, uint _tokenLockDuration) internal{
274         ICreditBIT(tokenAddress).claimGameReward(_winner, _totalParticipationAmount, _tokenLockDuration);
275     }
276     
277     /**
278      * Check the CRB balance of this.
279      * 
280      **/
281     function checkInternalBalance() public view returns(uint256 tokenBalance) {
282         return IERC20Token(tokenAddress).balanceOf(address(this));
283     }
284     
285     /**
286      * Method called by game contract
287      * msg.sender is address of calling contract that must be approved.
288      **/
289     function removeLock() public{
290         require(approvedGames[msg.sender] == true);
291         require(isGameLocked[msg.sender] == true);
292         require(checkIfLockCanBeRemoved(msg.sender) == true);
293         GameLock memory gameLock = gameLocks[msg.sender];
294         
295         //transfer tokens to game contract
296         IERC20Token(tokenAddress).transfer(msg.sender, gameLock.amount);
297         
298         delete(gameLocks[msg.sender]);
299         
300         //clean up
301         amountLocked = safeSub(amountLocked, gameLock.amount);
302         
303         isGameLocked[msg.sender] = false;
304         emit UnlockParameters(msg.sender, gameLock.amount);
305     }
306     
307     /**
308      * Method called by game contract when last participant has withdrawn
309      * msg.sender is address of calling contract that must be approved.
310      **/
311     function cleanUp() public{
312         require(approvedGames[msg.sender] == true);
313         require(isGameLocked[msg.sender] == false);
314         removeItem(msg.sender);
315         
316         approvedGames[msg.sender] = false;
317         concludedGames[concludedGameIndex] = msg.sender; 
318         concludedGameIndex++;
319         emit GameConcluded(msg.sender);
320     }
321 
322     /**
323      * Failsafe if game needs to be removed. Tokens are transfered to _tokenHolder address
324      * 
325      **/
326     function removeGameManually(address _gameAddress, address _tokenHolder) onlyOwner public{
327       GameLock memory gameLock = gameLocks[_gameAddress];
328       //transfer tokens to game contract
329       IERC20Token(tokenAddress).transfer(_tokenHolder, gameLock.amount);
330       //clean up
331       amountLocked = safeSub(amountLocked, gameLock.amount);
332       delete(gameLocks[_gameAddress]);
333       isGameLocked[_gameAddress] = false;
334       removeItem(_gameAddress);
335       approvedGames[_gameAddress] = false;
336     }
337     
338     /**
339      * Get gamelock parameters: CRB amount locked, CRB lock duration
340      * 
341      **/
342     function getGameLock(address _gameAddress) public view returns(uint, uint){
343         require(isGameLocked[_gameAddress] == true);
344         GameLock memory gameLock = gameLocks[_gameAddress];
345         return(gameLock.amount, gameLock.lockDuration);
346     }
347 
348     /**
349      * Verify if game is locked
350      * 
351      **/
352     function isGameLocked(address _gameAddress) public view returns(bool){
353       if(isGameLocked[_gameAddress] == true){
354         return true;
355       }else{
356         return false;
357       }
358     }
359     
360     /**
361      * Check if game lock can be removed
362      * 
363      **/
364     function checkIfLockCanBeRemoved(address _gameAddress) public view returns(bool){
365         require(approvedGames[_gameAddress] == true);
366         require(isGameLocked[_gameAddress] == true);
367         GameLock memory gameLock = gameLocks[_gameAddress];
368         if(gameLock.lockDuration < block.number){
369             return true;
370         }else{
371             return false;
372         }
373     }
374 
375     /**
376      * Kill contract if needed
377      * 
378      **/
379     function killContract() onlyOwner public {
380       selfdestruct(owner);
381     }
382 }
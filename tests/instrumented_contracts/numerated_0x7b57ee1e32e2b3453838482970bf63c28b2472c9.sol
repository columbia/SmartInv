1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 // token contract interface
54 interface Token{
55     function balanceOf(address user) external returns(uint256);
56     function transfer(address to, uint256 amount) external returns(bool);
57 }
58 
59 contract Safe{
60     using SafeMath for uint256;
61     
62     // counter for signing transactions
63     uint8 public count;
64     
65     uint256 internal end;
66     uint256 internal timeOutAuthentication;
67     
68     // arrays of safe keys
69     mapping (address => bool) internal safeKeys;
70     address [] internal massSafeKeys = new address[](4);
71     
72     // array of keys that signed the transaction
73     mapping (address => bool) internal signKeys;
74     
75     // free amount in safe
76     uint256 internal freeAmount; 
77     // event transferring money to safe
78     bool internal tranche;
79     
80     // fixing lockup in safe
81     bool internal lockupIsSet;
82     
83     // lockup of safe
84     uint256 internal mainLockup; 
85     
86     address internal lastSafeKey;
87     
88     Token public token;
89     
90     // Amount of cells
91     uint256 public countOfCell;
92     
93     // cell structure
94     struct _Cell{
95         uint256 lockup;
96         uint256 balance;
97         bool exist;
98         uint256 timeOfDeposit;
99     }
100     
101     // cell addresses
102     mapping (address => _Cell) internal userCells;
103     
104     event CreateCell(address indexed key);
105     event Deposit(address indexed key, uint256 balance);
106     event Delete(address indexed key);
107     event Edit(address indexed key, uint256 lockup);
108     event Withdraw(address indexed who, uint256 balance);
109     event InternalTransfer(address indexed from, address indexed to, uint256 balance);
110 
111     modifier firstLevel() {
112         require(msg.sender == lastSafeKey);
113         require(count>=1);
114         require(now < end);
115         _;
116     }
117     
118     modifier secondLevel() {
119         require(msg.sender == lastSafeKey);
120         require(count>=2);
121         require(now < end);
122         _;
123     }
124     
125     modifier thirdLevel() {
126         require(msg.sender == lastSafeKey);
127         require(count>=3);
128         require(now < end);
129         _;
130     }
131     
132     constructor (address _first, address _second, address _third, address _fourth) public {
133         require(
134             _first != _second && 
135             _first != _third && 
136             _first != _fourth && 
137             _second != _third &&
138             _second != _fourth &&
139             _third != _fourth &&
140             _first != 0x0 &&
141             _second != 0x0 &&
142             _third != 0x0 &&
143             _fourth != 0x0
144         );
145         safeKeys[_first] = true;
146         safeKeys[_second] = true;
147         safeKeys[_third] = true;
148         safeKeys[_fourth] = true;
149         massSafeKeys[0] = _first;
150         massSafeKeys[1] = _second;
151         massSafeKeys[2] = _third;
152         massSafeKeys[3] = _fourth;
153         timeOutAuthentication = 1 hours;
154     }
155     
156     function AuthStart() public returns(bool){
157         require(safeKeys[msg.sender]);
158         require(timeOutAuthentication >=0);
159         require(!signKeys[msg.sender]);
160         signKeys[msg.sender] = true;
161         count++;
162         end = now.add(timeOutAuthentication);
163         lastSafeKey = msg.sender;
164         return true;
165     }
166     
167     // completion of operation with safe-keys
168     function AuthEnd() public returns(bool){
169         require (safeKeys[msg.sender]);
170         for(uint i=0; i<4; i++){
171           signKeys[massSafeKeys[i]] = false;
172         }
173         count = 0;
174         end = 0;
175         lastSafeKey = 0x0;
176         return true;
177     }
178     
179     function getTimeOutAuthentication() firstLevel public view returns(uint256){
180         return timeOutAuthentication;
181     }
182     
183     function getFreeAmount() firstLevel public view returns(uint256){
184         return freeAmount;
185     }
186     
187     function getLockupCell(address _user) firstLevel public view returns(uint256){
188         return userCells[_user].lockup;
189     }
190     
191     function getBalanceCell(address _user) firstLevel public view returns(uint256){
192         return userCells[_user].balance;
193     }
194     
195     function getExistCell(address _user) firstLevel public view returns(bool){
196         return userCells[_user].exist;
197     }
198     
199     function getSafeKey(uint i) firstLevel view public returns(address){
200         return massSafeKeys[i];
201     }
202     
203     // withdrawal tokens from safe for issuer
204     function AssetWithdraw(address _to, uint256 _balance) secondLevel public returns(bool){
205         require(_balance<=freeAmount);
206         require(now>=mainLockup);
207         freeAmount = freeAmount.sub(_balance);
208         token.transfer(_to, _balance);
209         emit Withdraw(this, _balance);
210         return true;
211     }
212     
213     function setCell(address _cell, uint256 _lockup) secondLevel public returns(bool){
214         require(userCells[_cell].lockup==0 && userCells[_cell].balance==0);
215         require(!userCells[_cell].exist);
216         require(_lockup >= mainLockup);
217         userCells[_cell].lockup = _lockup;
218         userCells[_cell].exist = true;
219         countOfCell = countOfCell.add(1);
220         emit CreateCell(_cell);
221         return true;
222     }
223 
224     function deleteCell(address _key) secondLevel public returns(bool){
225         require(getBalanceCell(_key)==0);
226         require(userCells[_key].exist);
227         userCells[_key].lockup = 0;
228         userCells[_key].exist = false;
229         countOfCell = countOfCell.sub(1);
230         emit Delete(_key);
231         return true;
232     }
233     
234     // change parameters of the cell
235     function editCell(address _key, uint256 _lockup) secondLevel public returns(bool){
236         require(getBalanceCell(_key)==0);
237         require(_lockup>= mainLockup);
238         require(userCells[_key].exist);
239         userCells[_key].lockup = _lockup;
240         emit Edit(_key, _lockup);
241         return true;
242     }
243 
244     function depositCell(address _key, uint256 _balance) secondLevel public returns(bool){
245         require(userCells[_key].exist);
246         require(_balance<=freeAmount);
247         freeAmount = freeAmount.sub(_balance);
248         userCells[_key].balance = userCells[_key].balance.add(_balance);
249         userCells[_key].timeOfDeposit = now;
250         emit Deposit(_key, _balance);
251         return true;
252     }
253     
254     function changeDepositCell(address _key, uint256 _balance) secondLevel public returns(bool){
255         require(userCells[_key].timeOfDeposit.add(1 hours)>now);
256         userCells[_key].balance = userCells[_key].balance.sub(_balance);
257         freeAmount = freeAmount.add(_balance);
258         return true;
259     }
260     
261     // installation of a lockup for safe, 
262     // fixing free amount on balance, 
263     // token installation
264     // (run once)
265     function setContract(Token _token, uint256 _lockup) thirdLevel public returns(bool){
266         require(_token != address(0x0));
267         require(!lockupIsSet);
268         require(!tranche);
269         token = _token;
270         freeAmount = getMainBalance();
271         mainLockup = _lockup;
272         tranche = true;
273         lockupIsSet = true;
274         return true;
275     }
276     
277     // change of safe-key
278     function changeKey(address _oldKey, address _newKey) thirdLevel public returns(bool){
279         require(safeKeys[_oldKey]);
280         require(_newKey != 0x0);
281         for(uint i=0; i<4; i++){
282           if(massSafeKeys[i]==_oldKey){
283             massSafeKeys[i] = _newKey;
284           }
285         }
286         safeKeys[_oldKey] = false;
287         safeKeys[_newKey] = true;
288         
289         if(_oldKey==lastSafeKey){
290             lastSafeKey = _newKey;
291         }
292         
293         return true;
294     }
295 
296     function setTimeOutAuthentication(uint256 _time) thirdLevel public returns(bool){
297         require(
298             _time > 0 && 
299             timeOutAuthentication != _time &&
300             _time <= (5000 * 1 minutes)
301         );
302         timeOutAuthentication = _time;
303         return true;
304     }
305 
306     function withdrawCell(uint256 _balance) public returns(bool){
307         require(userCells[msg.sender].balance >= _balance);
308         require(now >= userCells[msg.sender].lockup);
309         userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);
310         token.transfer(msg.sender, _balance);
311         emit Withdraw(msg.sender, _balance);
312         return true;
313     }
314     
315     // transferring tokens from one cell to another
316     function transferCell(address _to, uint256 _balance) public returns(bool){
317         require(userCells[msg.sender].balance >= _balance);
318         require(userCells[_to].lockup>=userCells[msg.sender].lockup);
319         require(userCells[_to].exist);
320         userCells[msg.sender].balance = userCells[msg.sender].balance.sub(_balance);
321         userCells[_to].balance = userCells[_to].balance.add(_balance);
322         emit InternalTransfer(msg.sender, _to, _balance);
323         return true;
324     }
325     
326     // information on balance of cell for holder
327     
328     function getInfoCellBalance() view public returns(uint256){
329         return userCells[msg.sender].balance;
330     }
331     
332     // information on lockup of cell for holder
333     
334     function getInfoCellLockup() view public returns(uint256){
335         return userCells[msg.sender].lockup;
336     }
337     
338     function getMainBalance() public view returns(uint256){
339         return token.balanceOf(this);
340     }
341     
342     function getMainLockup() public view returns(uint256){
343         return mainLockup;
344     }
345     
346     function isTimeOver() view public returns(bool){
347         if(now > end){
348             return true;
349         } else{
350             return false;
351         }
352     }
353 }
1 pragma solidity ^0.4.24;
2 
3 contract ERC20Interface {
4     function name() public constant returns (string);
5     function symbol() public constant returns (string);
6     function decimals() public constant returns (uint8);
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address _owner) public constant returns (uint);
9     function transfer(address _to, uint _value) public returns (bool);
10     function transferFrom(address _from, address _to, uint _value) public returns (bool);
11     function approve(address _spender, uint _value) public returns (bool);
12     function allowance(address _owner, address _spender) public constant returns (uint);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 contract WeduToken is ERC20Interface {
19     /**
20      * @dev Constant parameters
21      */
22     string private TOKEN_NAME;
23     string private TOKEN_SYMBOL;
24     uint8 private DECIMAL;
25     uint private WEDU_UNIT;
26 
27     /**
28      * @dev Management parameters
29      */
30     address owner;
31     mapping(address => bool) internal blackList;
32 
33     /**
34      * @dev Balance parameters
35      */
36     uint private totalSupplyValue;
37     struct BalanceType {
38         uint locked;
39         uint unlocked;
40     }
41 
42     mapping(address => mapping (address => uint)) internal allowed;
43     mapping(address => BalanceType) internal balanceValue;
44 
45 
46     /**
47      * @dev Modifier, Only owner can execute the function
48      */
49     modifier onlyOwner() { require(owner == msg.sender, "Not a owner"); _;}
50 
51     /**
52      * @dev Event, called when the number of token changed
53      */
54     event ChangeNumberofToken(uint oldValue, uint newValue);
55 
56     /**
57      * @dev Constructor, Initialize the name, symbol, etc.
58      */
59     constructor() public {
60         TOKEN_NAME = "Educo-op";
61         TOKEN_SYMBOL = "WEDU";
62 
63         DECIMAL = 18;
64         WEDU_UNIT = 1000000000000000000;
65         totalSupplyValue = 10000000000 * WEDU_UNIT;
66 
67         owner = msg.sender;
68         balanceValue[owner].unlocked = totalSupplyValue;
69     }
70 
71     /**
72      * @dev Main info for WEDU token
73      */
74     function name() public constant returns (string){ return TOKEN_NAME; }
75     function symbol() public constant returns (string){ return TOKEN_SYMBOL; }
76     function decimals() public constant returns (uint8){ return DECIMAL; }
77     function totalSupply() public constant returns (uint){ return totalSupplyValue; }
78 
79     /**
80      * @dev Balance info of WEDU token for each user
81      */
82     function balanceOf(address _user) public constant returns (uint){ return balanceValue[_user].unlocked+balanceValue[_user].locked; }
83     function balanceOfLocked(address _user) public constant returns (uint){ return balanceValue[_user].locked; }
84     function balanceOfUnlocked(address _user) public constant returns (uint){ return balanceValue[_user].unlocked; }
85 
86     /**
87      * @dev Lock the WEDU token in users
88      * @param _who The user for locking WEDU token
89      * @param _value The amount of locking WEDU token
90      */
91     function lockBalance(address _who, uint _value) public onlyOwner {
92         // Check the unlocked balance of a user
93         require(_value <= balanceValue[_who].unlocked, "Unsufficient balance");
94 
95         uint totalBalanceValue = balanceValue[_who].locked + balanceValue[_who].unlocked;
96 
97         balanceValue[_who].unlocked -= _value;
98         balanceValue[_who].locked += _value;
99 
100         assert(totalBalanceValue == balanceValue[_who].locked + balanceValue[_who].unlocked);
101     }
102 
103     /**
104      * @dev Unlock the WEDU token in users
105      * @param _who The user for unlocking WEDU token
106      * @param _value The amount of unlocking WEDU token
107      */
108     function unlockBalance(address _who, uint _value) public onlyOwner {
109         // Check the locked balance of a user
110         require(_value <= balanceValue[_who].locked, "Unsufficient balance");
111 
112         uint totalBalanceValue = balanceValue[_who].locked + balanceValue[_who].unlocked;
113 
114         balanceValue[_who].locked -= _value;
115         balanceValue[_who].unlocked += _value;
116 
117         assert(totalBalanceValue == balanceValue[_who].locked + balanceValue[_who].unlocked);
118     }
119 
120     /**
121      * @dev Transfer the WEDU token
122      * @param _from The user who will transmit WEDU token
123      * @param _to The user who will receive WEDU token
124      * @param _value The amount of WEDU token transmits to user
125      * @return True when the WEDU token transfer success
126      */
127     function _transfer(address _from, address _to, uint _value) internal returns (bool){
128         // Check the address
129         require(_from != address(0), "Address is wrong");
130         require(_from != owner, "Owner uses the privateTransfer");
131         require(_to != address(0), "Address is wrong");
132 
133         // Check a user included in blacklist
134         require(!blackList[_from], "Sender in blacklist");
135         require(!blackList[_to], "Receiver in blacklist");
136 
137         // Check the unlocked balance of a user
138         require(_value <= balanceValue[_from].unlocked, "Unsufficient balance");
139         require(balanceValue[_to].unlocked <= balanceValue[_to].unlocked + _value, "Overflow");
140 
141         uint previousBalances = balanceValue[_from].unlocked + balanceValue[_to].unlocked;
142 
143         balanceValue[_from].unlocked -= _value;
144         balanceValue[_to].unlocked += _value;
145 
146         emit Transfer(_from, _to, _value);
147 
148         assert(balanceValue[_from].unlocked + balanceValue[_to].unlocked == previousBalances);
149         return true;
150     }
151 
152     function transfer(address _to, uint _value) public returns (bool){
153         return _transfer(msg.sender, _to, _value);
154     }
155 
156     /**
157      * @dev Educo-op transfers the WEDU token to a user
158      * @param _to The user who will receive WEDU token
159      * @param _value The amount of WEDU token transmits to a user
160      * @return True when the WEDU token transfer success
161      */
162     function privateTransfer(address _to, uint _value) public onlyOwner returns (bool) {
163         // Check the address
164         require(_to != address(0), "Address is wrong");
165 
166         // Account balance validation
167         require(_value <= balanceValue[owner].unlocked, "Unsufficient balance");
168         require(balanceValue[_to].unlocked <= balanceValue[_to].unlocked + _value, "Overflow");
169 
170         uint previousBalances = balanceValue[owner].unlocked + balanceValue[_to].locked;
171 
172         balanceValue[owner].unlocked -= _value;
173         balanceValue[_to].locked += _value;
174 
175         emit Transfer(msg.sender, _to, _value);
176 
177         assert(balanceValue[owner].unlocked + balanceValue[_to].locked == previousBalances);
178         return true;
179     }
180 
181     /**
182      * @dev Educo-op transfers the WEDU token to multiple users simultaneously
183      * @param _tos The users who will receive WEDU token
184      * @param _nums The number of users that will receive WEDU token
185      * @param _submitBalance The amount of WEDU token transmits to users
186      * @return True when the WEDU token transfer success to all users
187      */
188     function multipleTransfer(address[] _tos, uint _nums, uint _submitBalance) public onlyOwner returns (bool){
189         // Check the input parameters
190         require(_tos.length == _nums, "Number of users who receives the token is not match");
191         require(_submitBalance < 100000000 * WEDU_UNIT, "Too high submit balance");
192         require(_nums < 256, "Two high number of users");
193         require(_nums*_submitBalance <= balanceValue[owner].unlocked, "Unsufficient balance");
194 
195         balanceValue[owner].unlocked -= (_nums*_submitBalance);
196         uint8 numIndex;
197         for(numIndex=0; numIndex < _nums; numIndex++){
198             require(balanceValue[_tos[numIndex]].unlocked == 0, "Already user has token");
199             require(_tos[numIndex] != address(0));
200             balanceValue[_tos[numIndex]].unlocked = _submitBalance;
201 
202             emit Transfer(owner, _tos[numIndex], _submitBalance);
203         }
204         return true;
205     }
206 
207     /**
208      * @dev Receive the WEDU token from other user
209      * @param _from The users who will transmit WEDU token
210      * @param _to The users who will receive WEDU token
211      * @param _value The amount of WEDU token transmits to user
212      * @return True when the WEDU token transfer success
213      */
214     function transferFrom(address _from, address _to, uint _value) public returns (bool){
215         // Check the unlocked balance and allowed balance of a user
216         require(allowed[_from][msg.sender] <= balanceValue[_from].unlocked, "Unsufficient allowed balance");
217         require(_value <= allowed[_from][msg.sender], "Unsufficient balance");
218 
219         allowed[_from][msg.sender] -= _value;
220         return _transfer(_from, _to, _value);
221     }
222 
223     /**
224      * @dev Approve the WEDU token transfer to other user
225      * @param _spender A user allowed to receive WEDU token
226      * @param _value The amount of WEDU token allowed to receive at a user
227      * @return True when the WEDU token successfully allowed
228      */
229     function approve(address _spender, uint _value) public returns (bool){
230         // Check the address
231         require(msg.sender != owner, "Owner uses the privateTransfer");
232         require(_spender != address(0), "Address is wrong");
233         require(_value <= balanceValue[msg.sender].unlocked, "Unsufficient balance");
234 
235         // Check a user included in blacklist
236         require(!blackList[msg.sender], "Sender in blacklist");
237         require(!blackList[_spender], "Receiver in blacklist");
238 
239         // Is really first Approve??
240         require(allowed[msg.sender][_spender] == 0, "Already allowed token exists");
241 
242         allowed[msg.sender][_spender] = _value;
243         emit Approval(msg.sender, _spender, _value);
244         return true;
245     }
246 
247     /**
248      * @dev Get the amount of WEDU token that allowed to the user
249      * @param _owner A user who allowed WEDU token transmission
250      * @param _spender A user who allowed WEDU token reception
251      * @return The amount of WEDU token that allowed to the user
252      */
253     function allowance(address _owner, address _spender) public constant returns (uint){
254         // Only the user who related with the token allowance can see the allowance value
255         require(msg.sender == _owner || msg.sender == _spender);
256         return allowed[_owner][_spender];
257     }
258 
259     /**
260      * @dev Increase the amount of WEDU token that allowed to the user
261      * @param _spender A user who allowed WEDU token reception
262      * @param _addedValue The amount of WEDU token for increasing
263      * @return True when the amount of allowed WEDU token successfully increases
264      */
265     function increaseApproval(address _spender, uint _addedValue) public returns (bool){
266         // Check the address
267         require(_spender != address(0), "Address is wrong");
268         require(allowed[msg.sender][_spender] > 0, "Not approved until yet");
269 
270         // Check a user included in blacklist
271         require(!blackList[msg.sender], "Sender in blacklist");
272         require(!blackList[_spender], "Receiver in blacklist");
273 
274         uint oldValue = allowed[msg.sender][_spender];
275         require(_addedValue + oldValue <= balanceValue[msg.sender].unlocked, "Unsufficient balance");
276 
277         allowed[msg.sender][_spender] = _addedValue + oldValue;
278         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279         return true;
280     }
281 
282     /**
283      * @dev Decrease the amount of WEDU token that allowed to the user
284      * @param _spender A user who allowed WEDU token reception
285      * @param _substractedValue The amount of WEDU token for decreasing
286      * @return True when the amount of allowed WEDU token successfully decreases
287      */
288     function decreaseApproval(address _spender, uint _substractedValue) public returns (bool){
289         // Check the address
290         require(_spender != address(0), "Address is wrong");
291         require(allowed[msg.sender][_spender] > 0, "Not approved until yet");
292 
293         // Check a user included in blacklist
294         require(!blackList[msg.sender], "Sender in blacklist");
295         require(!blackList[_spender], "Receiver in blacklist");
296 
297         uint oldValue = allowed[msg.sender][_spender];
298         if (_substractedValue > oldValue){
299             allowed[msg.sender][_spender] = 0;
300         } else {
301             allowed[msg.sender][_spender] = oldValue - _substractedValue;
302         }
303         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
304         return true;
305     }
306 
307     /**
308      * @dev Add the blacklist member
309      * @param _who A user who will be blocked
310      */
311     function addBlackList(address _who) public onlyOwner {
312         require(!blackList[_who], "Already, sender in blacklist");
313         blackList[_who] = true;
314     }
315 
316     /**
317      * @dev Remove the blacklist member
318      * @param _who A user who will be unblocked
319      */
320     function removalBlackList(address _who) public onlyOwner {
321         require(blackList[_who], "Sender does not included in blacklist");
322         blackList[_who] = false;
323     }
324 
325     /**
326      * @dev Increase the total amount of WEDU token
327      * @param _value The amount of WEDU token for increasing
328      * @return True when the amount of total WEDU token successfully increases
329      */
330     function tokenIssue(uint _value) public onlyOwner returns (bool) {
331         require(totalSupplyValue <= totalSupplyValue + _value, "Overflow");
332         uint oldTokenNum = totalSupplyValue;
333 
334         totalSupplyValue += _value;
335         balanceValue[owner].unlocked += _value;
336 
337         emit ChangeNumberofToken(oldTokenNum, totalSupplyValue);
338         return true;
339     }
340 
341     /**
342      * @dev Decrease the total amount of WEDU token
343      * @param _value The amount of WEDU token for decreasing
344      * @return True when the amount of total WEDU token successfully decreases
345      */
346     function tokenBurn(uint _value) public onlyOwner returns (bool) {
347         require(_value <= balanceValue[owner].unlocked, "Unsufficient balance");
348         uint oldTokenNum = totalSupplyValue;
349 
350         totalSupplyValue -= _value;
351         balanceValue[owner].unlocked -= _value;
352 
353         emit ChangeNumberofToken(oldTokenNum, totalSupplyValue);
354         return true;
355     }
356 
357     /**
358      * @dev Migrate the owner of this contract
359      * @param _owner The user who will receive the manager authority
360      * @return The user who receivee the manager authority
361      */
362     function ownerMigration (address _owner) public onlyOwner returns (address) {
363         owner = _owner;
364         return owner;
365     }
366 
367 
368     /**
369      * @dev Kill contract
370      */
371     function kill() public onlyOwner {
372         selfdestruct(owner);
373     }
374 }
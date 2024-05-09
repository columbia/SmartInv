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
69         emit Transfer(this, owner, totalSupplyValue);
70     }
71 
72     /**
73      * @dev Main info for WEDU token
74      */
75     function name() public constant returns (string){ return TOKEN_NAME; }
76     function symbol() public constant returns (string){ return TOKEN_SYMBOL; }
77     function decimals() public constant returns (uint8){ return DECIMAL; }
78     function totalSupply() public constant returns (uint){ return totalSupplyValue; }
79 
80     /**
81      * @dev Balance info of WEDU token for each user
82      */
83     function balanceOf(address _user) public constant returns (uint){ return balanceValue[_user].unlocked+balanceValue[_user].locked; }
84     function balanceOfLocked(address _user) public constant returns (uint){ return balanceValue[_user].locked; }
85     function balanceOfUnlocked(address _user) public constant returns (uint){ return balanceValue[_user].unlocked; }
86 
87     /**
88      * @dev Lock the WEDU token in users
89      * @param _who The user for locking WEDU token
90      * @param _value The amount of locking WEDU token
91      */
92     function lockBalance(address _who, uint _value) public onlyOwner {
93         // Check the unlocked balance of a user
94         require(_value <= balanceValue[_who].unlocked, "Unsufficient balance");
95 
96         uint totalBalanceValue = balanceValue[_who].locked + balanceValue[_who].unlocked;
97 
98         balanceValue[_who].unlocked -= _value;
99         balanceValue[_who].locked += _value;
100 
101         assert(totalBalanceValue == balanceValue[_who].locked + balanceValue[_who].unlocked);
102     }
103 
104     /**
105      * @dev Unlock the WEDU token in users
106      * @param _who The user for unlocking WEDU token
107      * @param _value The amount of unlocking WEDU token
108      */
109     function unlockBalance(address _who, uint _value) public onlyOwner {
110         // Check the locked balance of a user
111         require(_value <= balanceValue[_who].locked, "Unsufficient balance");
112 
113         uint totalBalanceValue = balanceValue[_who].locked + balanceValue[_who].unlocked;
114 
115         balanceValue[_who].locked -= _value;
116         balanceValue[_who].unlocked += _value;
117 
118         assert(totalBalanceValue == balanceValue[_who].locked + balanceValue[_who].unlocked);
119     }
120 
121     /**
122      * @dev Transfer the WEDU token
123      * @param _from The user who will transmit WEDU token
124      * @param _to The user who will receive WEDU token
125      * @param _value The amount of WEDU token transmits to user
126      * @return True when the WEDU token transfer success
127      */
128     function _transfer(address _from, address _to, uint _value) internal returns (bool){
129         // Check the address
130         require(_from != address(0), "Address is wrong");
131         require(_from != owner, "Owner uses the privateTransfer");
132         require(_to != address(0), "Address is wrong");
133 
134         // Check a user included in blacklist
135         require(!blackList[_from], "Sender in blacklist");
136         require(!blackList[_to], "Receiver in blacklist");
137 
138         // Check the unlocked balance of a user
139         require(_value <= balanceValue[_from].unlocked, "Unsufficient balance");
140         require(balanceValue[_to].unlocked <= balanceValue[_to].unlocked + _value, "Overflow");
141 
142         uint previousBalances = balanceValue[_from].unlocked + balanceValue[_to].unlocked;
143 
144         balanceValue[_from].unlocked -= _value;
145         balanceValue[_to].unlocked += _value;
146 
147         emit Transfer(_from, _to, _value);
148 
149         assert(balanceValue[_from].unlocked + balanceValue[_to].unlocked == previousBalances);
150         return true;
151     }
152 
153     function transfer(address _to, uint _value) public returns (bool){
154         return _transfer(msg.sender, _to, _value);
155     }
156 
157     /**
158      * @dev Educo-op transfers the WEDU token to a user
159      * @param _to The user who will receive WEDU token
160      * @param _value The amount of WEDU token transmits to a user
161      * @return True when the WEDU token transfer success
162      */
163     function privateTransfer(address _to, uint _value) public onlyOwner returns (bool) {
164         // Check the address
165         require(_to != address(0), "Address is wrong");
166 
167         // Account balance validation
168         require(_value <= balanceValue[owner].unlocked, "Unsufficient balance");
169         require(balanceValue[_to].unlocked <= balanceValue[_to].unlocked + _value, "Overflow");
170 
171         uint previousBalances = balanceValue[owner].unlocked + balanceValue[_to].locked;
172 
173         balanceValue[owner].unlocked -= _value;
174         balanceValue[_to].locked += _value;
175 
176         emit Transfer(msg.sender, _to, _value);
177 
178         assert(balanceValue[owner].unlocked + balanceValue[_to].locked == previousBalances);
179         return true;
180     }
181 
182     /**
183      * @dev Educo-op transfers the WEDU token to multiple users simultaneously
184      * @param _tos The users who will receive WEDU token
185      * @param _nums The number of users that will receive WEDU token
186      * @param _submitBalance The amount of WEDU token transmits to users
187      * @return True when the WEDU token transfer success to all users
188      */
189     function multipleTransfer(address[] _tos, uint _nums, uint _submitBalance) public onlyOwner returns (bool){
190         // Check the input parameters
191         require(_tos.length == _nums, "Number of users who receives the token is not match");
192         require(_submitBalance < 100000000 * WEDU_UNIT, "Too high submit balance");
193         require(_nums < 100, "Two high number of users");
194         require(_nums*_submitBalance <= balanceValue[owner].unlocked, "Unsufficient balance");
195 
196         balanceValue[owner].unlocked -= (_nums*_submitBalance);
197         uint8 numIndex;
198         for(numIndex=0; numIndex < _nums; numIndex++){
199             require(balanceValue[_tos[numIndex]].unlocked == 0, "Already user has token");
200             require(_tos[numIndex] != address(0));
201             balanceValue[_tos[numIndex]].unlocked = _submitBalance;
202 
203             emit Transfer(owner, _tos[numIndex], _submitBalance);
204         }
205         return true;
206     }
207 
208     /**
209      * @dev Receive the WEDU token from other user
210      * @param _from The users who will transmit WEDU token
211      * @param _to The users who will receive WEDU token
212      * @param _value The amount of WEDU token transmits to user
213      * @return True when the WEDU token transfer success
214      */
215     function transferFrom(address _from, address _to, uint _value) public returns (bool){
216         // Check the unlocked balance and allowed balance of a user
217         require(allowed[_from][msg.sender] <= balanceValue[_from].unlocked, "Unsufficient allowed balance");
218         require(_value <= allowed[_from][msg.sender], "Unsufficient balance");
219 
220         allowed[_from][msg.sender] -= _value;
221         return _transfer(_from, _to, _value);
222     }
223 
224     /**
225      * @dev Approve the WEDU token transfer to other user
226      * @param _spender A user allowed to receive WEDU token
227      * @param _value The amount of WEDU token allowed to receive at a user
228      * @return True when the WEDU token successfully allowed
229      */
230     function approve(address _spender, uint _value) public returns (bool){
231         // Check the address
232         require(msg.sender != owner, "Owner uses the privateTransfer");
233         require(_spender != address(0), "Address is wrong");
234         require(_value <= balanceValue[msg.sender].unlocked, "Unsufficient balance");
235 
236         // Check a user included in blacklist
237         require(!blackList[msg.sender], "Sender in blacklist");
238         require(!blackList[_spender], "Receiver in blacklist");
239 
240         // Is really first Approve??
241         require(allowed[msg.sender][_spender] == 0, "Already allowed token exists");
242 
243         allowed[msg.sender][_spender] = _value;
244         emit Approval(msg.sender, _spender, _value);
245         return true;
246     }
247 
248     /**
249      * @dev Get the amount of WEDU token that allowed to the user
250      * @param _owner A user who allowed WEDU token transmission
251      * @param _spender A user who allowed WEDU token reception
252      * @return The amount of WEDU token that allowed to the user
253      */
254     function allowance(address _owner, address _spender) public constant returns (uint){
255         // Only the user who related with the token allowance can see the allowance value
256         require(msg.sender == _owner || msg.sender == _spender);
257         return allowed[_owner][_spender];
258     }
259 
260     /**
261      * @dev Increase the amount of WEDU token that allowed to the user
262      * @param _spender A user who allowed WEDU token reception
263      * @param _addedValue The amount of WEDU token for increasing
264      * @return True when the amount of allowed WEDU token successfully increases
265      */
266     function increaseApproval(address _spender, uint _addedValue) public returns (bool){
267         // Check the address
268         require(_spender != address(0), "Address is wrong");
269         require(allowed[msg.sender][_spender] > 0, "Not approved until yet");
270 
271         // Check a user included in blacklist
272         require(!blackList[msg.sender], "Sender in blacklist");
273         require(!blackList[_spender], "Receiver in blacklist");
274 
275         uint oldValue = allowed[msg.sender][_spender];
276         require(_addedValue + oldValue <= balanceValue[msg.sender].unlocked, "Unsufficient balance");
277 
278         allowed[msg.sender][_spender] = _addedValue + oldValue;
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283     /**
284      * @dev Decrease the amount of WEDU token that allowed to the user
285      * @param _spender A user who allowed WEDU token reception
286      * @param _substractedValue The amount of WEDU token for decreasing
287      * @return True when the amount of allowed WEDU token successfully decreases
288      */
289     function decreaseApproval(address _spender, uint _substractedValue) public returns (bool){
290         // Check the address
291         require(_spender != address(0), "Address is wrong");
292         require(allowed[msg.sender][_spender] > 0, "Not approved until yet");
293 
294         // Check a user included in blacklist
295         require(!blackList[msg.sender], "Sender in blacklist");
296         require(!blackList[_spender], "Receiver in blacklist");
297 
298         uint oldValue = allowed[msg.sender][_spender];
299         if (_substractedValue > oldValue){
300             allowed[msg.sender][_spender] = 0;
301         } else {
302             allowed[msg.sender][_spender] = oldValue - _substractedValue;
303         }
304         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305         return true;
306     }
307 
308     /**
309      * @dev Add the blacklist member
310      * @param _who A user who will be blocked
311      */
312     function addBlackList(address _who) public onlyOwner {
313         require(!blackList[_who], "Already, sender in blacklist");
314         blackList[_who] = true;
315     }
316 
317     /**
318      * @dev Remove the blacklist member
319      * @param _who A user who will be unblocked
320      */
321     function removalBlackList(address _who) public onlyOwner {
322         require(blackList[_who], "Sender does not included in blacklist");
323         blackList[_who] = false;
324     }
325 
326     /**
327      * @dev Increase the total amount of WEDU token
328      * @param _value The amount of WEDU token for increasing
329      * @return True when the amount of total WEDU token successfully increases
330      */
331     function tokenIssue(uint _value) public onlyOwner returns (bool) {
332         require(totalSupplyValue <= totalSupplyValue + _value, "Overflow");
333         uint oldTokenNum = totalSupplyValue;
334 
335         totalSupplyValue += _value;
336         balanceValue[owner].unlocked += _value;
337 
338         emit ChangeNumberofToken(oldTokenNum, totalSupplyValue);
339         return true;
340     }
341 
342     /**
343      * @dev Decrease the total amount of WEDU token
344      * @param _value The amount of WEDU token for decreasing
345      * @return True when the amount of total WEDU token successfully decreases
346      */
347     function tokenBurn(uint _value) public onlyOwner returns (bool) {
348         require(_value <= balanceValue[owner].unlocked, "Unsufficient balance");
349         uint oldTokenNum = totalSupplyValue;
350 
351         totalSupplyValue -= _value;
352         balanceValue[owner].unlocked -= _value;
353 
354         emit ChangeNumberofToken(oldTokenNum, totalSupplyValue);
355         return true;
356     }
357 
358     /**
359      * @dev Migrate the owner of this contract
360      * @param _owner The user who will receive the manager authority
361      * @return The user who receivee the manager authority
362      */
363     function ownerMigration (address _owner) public onlyOwner returns (address) {
364         owner = _owner;
365         return owner;
366     }
367 
368 
369     /**
370      * @dev Kill contract
371      */
372     function kill() public onlyOwner {
373         selfdestruct(owner);
374     }
375 }
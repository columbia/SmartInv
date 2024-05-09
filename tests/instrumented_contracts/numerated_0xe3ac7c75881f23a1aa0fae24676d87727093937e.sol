1 /**
2   * SafeMath Libary
3   */
4 pragma solidity ^0.4.24;
5 contract SafeMath {
6     function safeAdd(uint256 a, uint256 b) internal pure returns(uint256)
7     {
8         uint256 c = a + b;
9         assert(c >= a);
10         return c;
11     }
12     function safeSub(uint256 a, uint256 b) internal pure returns(uint256)
13     {
14         assert(b <= a);
15         return a - b;
16     }
17     function safeMul(uint256 a, uint256 b) internal pure returns(uint256)
18     {
19         if (a == 0) {
20         return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26     function safeDiv(uint256 a, uint256 b) internal pure returns(uint256)
27     {
28         uint256 c = a / b;
29         return c;
30     }
31 }
32 
33 contract Ownable {
34     address public owner;
35 
36     function Ownable() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address newOwner) onlyOwner public {
46         owner = newOwner;
47     }
48 }
49 
50 /**
51  * @title Pausable
52  * @dev Base contract which allows children to implement an emergency stop mechanism.
53  */
54 contract Pausable is Ownable {
55   event Pause();
56   event Unpause();
57 
58   bool public paused = false;
59 
60 
61   /**
62    * @dev Modifier to make a function callable only when the contract is not paused.
63    */
64   modifier whenNotPaused() {
65     require(!paused);
66     _;
67   }
68 
69   /**
70    * @dev Modifier to make a function callable only when the contract is paused.
71    */
72   modifier whenPaused() {
73     require(paused);
74     _;
75   }
76 
77   /**
78    * @dev called by the owner to pause, triggers stopped state
79    */
80   function pause() onlyOwner whenNotPaused public {
81     paused = true;
82     emit Pause();
83   }
84 
85   /**
86    * @dev called by the owner to unpause, returns to normal state
87    */
88   function unpause() onlyOwner whenPaused public {
89     paused = false;
90     emit Unpause();
91   }
92 }
93 
94 contract EIP20Interface {
95     /* This is a slight change to the ERC20 base standard.
96     function totalSupply() constant returns (uint256 supply);
97     is replaced with:
98     uint256 public totalSupply;
99     This automatically creates a getter function for the totalSupply.
100     This is moved to the base contract since public getter functions are not
101     currently recognised as an implementation of the matching abstract
102     function by the compiler.
103     */
104     /// total amount of tokens
105     uint256 public totalSupply;
106     /// @param _owner The address from which the balance will be retrieved
107     /// @return The balance
108     function balanceOf(address _owner) public view returns (uint256 balance);
109     /// @notice send `_value` token to `_to` from `msg.sender`
110     /// @param _to The address of the recipient
111     /// @param _value The amount of token to be transferred
112     /// @return Whether the transfer was successful or not
113     function transfer(address _to, uint256 _value) public returns (bool success);
114     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
115     /// @param _from The address of the sender
116     /// @param _to The address of the recipient
117     /// @param _value The amount of token to be transferred
118     /// @return Whether the transfer was successful or not
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
120     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
121     /// @param _spender The address of the account able to transfer the tokens
122     /// @param _value The amount of tokens to be approved for transfer
123     /// @return Whether the approval was successful or not
124     function approve(address _spender, uint256 _value) public returns(bool success);
125     /// @param _owner The address of the account owning tokens
126     /// @param _spender The address of the account able to transfer the tokens
127     /// @return Amount of remaining tokens allowed to spent
128     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
129     // solhint-disable-next-line no-simple-event-func-name
130     event Transfer(address indexed _from, address indexed _to, uint256 _value);
131     event Approval(address indexed _owner, address indexed _spender,uint256 _value);
132 }
133 
134 contract DTI is EIP20Interface,Ownable,SafeMath,Pausable{
135     //// Constant token specific fields
136     string public constant name ="Diamond Travel International Coin";
137     string public constant symbol = "DTI";
138     uint8 public constant decimals = 18;
139     string  public version  = 'v0.1';
140     uint256 public initialSupply = 6000000000;
141     
142     mapping (address => uint256) public balances;
143     mapping (address => mapping (address => uint256)) public allowances;
144 
145     //freeze account
146     mapping (address => bool) public FreezeAccount;
147 
148     //sum of buy
149     mapping (address => uint) public jail;
150     mapping (address => uint256) public updateTime;
151     
152     //Locked token
153     mapping (address => uint256) public LockedToken;
154 
155     //set raise time
156     uint256 public finaliseTime;
157 
158     //to receive eth from the contract
159     address public walletOwnerAddress;
160 
161     //Tokens to 1 eth
162     uint256 public rate;
163 
164     event WithDraw(address indexed _from, address indexed _to,uint256 _value);
165     event BuyToken(address indexed _from, address indexed _to, uint256 _value);
166     event Burn(address indexed _from,uint256 _value);
167 
168     constructor() public{
169         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
170         balances[msg.sender] = totalSupply;            // Give the creator all initial tokens
171         walletOwnerAddress = msg.sender;
172         rate = 50000;
173     }
174 
175     modifier notFinalised() {
176         require(finaliseTime == 0);
177         _;
178     }
179 
180     modifier NotFreeze() { 
181         require (FreezeAccount[msg.sender] == false); 
182         _; 
183     }
184 
185     //freeze account
186     function addFreeze(address _addr) public onlyOwner whenNotPaused returns(bool res) {
187         FreezeAccount[_addr] = true;
188         return true;
189     }
190 
191     //release freeze account
192     function releaseFreeze(address _addr) public onlyOwner whenNotPaused returns(bool res) {
193         FreezeAccount[_addr] = false;
194         return true;
195     }
196     
197     function balanceOf(address _account) public view returns (uint) {
198         return balances[_account];
199     }
200 
201     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns(bool) {
202         require(_to != address(0x0)&&_value>0);
203         require (canTransfer(_from, _value));
204         require(balances[_from] >= _value);
205         require(safeAdd(balances[_to],_value) > balances[_to]);
206 
207         uint previousBalances = safeAdd(balances[_from],balances[_to]);
208         balances[_from] = safeSub(balances[_from],_value);
209         balances[_to] = safeAdd(balances[_to],_value);
210         emit Transfer(_from, _to, _value);
211         assert(safeAdd(balances[_from],balances[_to]) == previousBalances);
212         return true;
213     }
214 
215     function transfer(address _to, uint256 _value) public whenNotPaused NotFreeze returns (bool success){
216         return _transfer(msg.sender, _to, _value);
217     }
218 
219     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused NotFreeze returns (bool) {
220         require(_value <= allowances[_from][msg.sender]);
221         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);
222         return _transfer(_from, _to, _value);
223     }
224 
225     function approve(address _spender, uint256 _value) public whenNotPaused NotFreeze returns (bool success) {
226         allowances[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231      function increaseApproval(address _spender, uint _addedValue) public whenNotPaused NotFreeze returns (bool) {
232         allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);
233         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
234         return true;
235   }
236 
237     function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused NotFreeze returns (bool) {
238             uint oldValue = allowances[msg.sender][_spender];
239             if (_subtractedValue > oldValue) {
240               allowances[msg.sender][_spender] = 0;
241             } else {
242               allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
243             }
244             emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
245             return true;
246     }
247 
248     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
249         return allowances[_owner][_spender];
250     }
251  
252     //close the raise
253     function setFinaliseTime() onlyOwner notFinalised public returns(bool){
254         finaliseTime = now;
255         rate = 0;
256         return true;
257     }
258      //close the raise
259     function Restart(uint256 newrate) onlyOwner public returns(bool){
260         finaliseTime = 0;
261         rate = newrate;
262         return true;
263     }
264 
265     function setRate(uint256 newrate) onlyOwner notFinalised public returns(bool) {
266        rate = newrate;
267        return true;
268     }
269 
270     //2018/11/11/0/0/0
271    function changeRate() internal returns(uint256 _rate) {
272         if(now <= 1541865600 || rate <= 40000){
273             return rate;
274         }
275         uint256 _day = safeSub(now,1541865600)/1 days;
276         uint256 changerate = safeMul(_day,500);
277         if(changerate >= 10000){
278             rate = 40000;
279         }else{
280             rate = safeSub(rate,changerate);
281         }
282         return rate;
283     }
284 
285     function setWalletOwnerAddress(address _newaddress) onlyOwner public returns(bool) {
286        walletOwnerAddress = _newaddress;
287        return true;
288     }
289 
290     //Withdraw eth form the contranct 
291     function withdraw(address _to) internal returns(bool){
292         require(_to.send(address(this).balance));
293         emit WithDraw(msg.sender,_to,this.balance);
294         return true;
295     }
296 
297     //burn token
298     function burn(uint256 value) public whenNotPaused NotFreeze returns(bool){
299         require (balances[msg.sender] >= value);
300         totalSupply = safeSub(totalSupply,value);
301         balances[msg.sender] = safeSub(balances[msg.sender],value);
302         emit Burn(msg.sender,value);
303         return true;
304     }
305     
306     //burn the account token only by owner
307     function burnFrom(address _account,uint256 value)onlyOwner public returns(bool){
308         require (balances[_account] >= value);
309         totalSupply = safeSub(totalSupply,value);
310         balances[_account] = safeSub(balances[_account],value);
311         emit Burn(_account,value);
312         return true;
313     }
314 
315 
316     //Lock tokens
317     function canTransfer(address _from, uint256 _value) internal view returns (bool success) {
318         uint256 index;  
319         uint256 locked;
320         index = safeSub(now, updateTime[_from]) / 1 days;
321 
322         if(index >= 200){
323             return true;
324         }
325         uint256 releasedtemp = safeMul(index,jail[_from])/200;
326         if(releasedtemp >= LockedToken[_from]){
327             return true;
328         }
329         locked = safeSub(LockedToken[_from],releasedtemp);
330         require(safeSub(balances[_from], _value) >= locked);
331         return true;
332     } 
333 
334     function _buyToken(address _to,uint256 _value)internal notFinalised whenNotPaused{
335         require(_to != address(0x0));
336 
337         uint256 index;
338         uint256 locked;
339        
340         if(updateTime[_to] != 0){
341             
342             index = safeSub(now,updateTime[_to])/1 days;
343 
344             uint256 releasedtemp = safeMul(index,jail[_to])/200;
345             if(releasedtemp >= LockedToken[_to]){
346                 LockedToken[_to] = 0;
347             }else{
348                 LockedToken[_to] = safeSub(LockedToken[_to],releasedtemp);
349             }
350         }
351         locked = safeSub(_value,_value/200);
352         LockedToken[_to] = safeAdd(LockedToken[_to],locked);
353         balances[_to] = safeAdd(balances[_to], _value);
354         jail[_to] = safeAdd(jail[_to], _value);
355         balances[walletOwnerAddress] = safeSub(balances[walletOwnerAddress],_value);
356         
357         updateTime[_to] = now;
358         withdraw(walletOwnerAddress);
359         emit BuyToken(msg.sender, _to, _value);
360     }
361 
362     function() public payable{
363         require(msg.value >= 0.0001 ether);
364         uint256 _rate = changeRate();
365         uint256 tokens = safeMul(msg.value,_rate);
366         _buyToken(msg.sender,tokens);
367     }
368 }
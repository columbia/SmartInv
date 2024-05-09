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
134 
135 contract ISCToken is EIP20Interface,Ownable,SafeMath,Pausable{
136     //// Constant token specific fields
137     string public constant name ="ISCToken";
138     string public constant symbol = "ISC";
139     uint8 public constant decimals = 18;
140     string  public version  = 'v0.1';
141     uint256 public constant initialSupply = 1010101010;
142     
143     mapping (address => uint256) public balances;
144     mapping (address => mapping (address => uint256)) public allowances;
145 
146     //sum of buy
147     mapping (address => uint) public jail;
148 
149     mapping (address => uint256) public updateTime;
150     
151     //Locked token
152     mapping (address => uint256) public LockedToken;
153 
154     //set raise time
155     uint256 public finaliseTime;
156 
157     //to receive eth from the contract
158     address public walletOwnerAddress;
159 
160     //Tokens to 1 eth
161     uint256 public rate;
162 
163     event WithDraw(address indexed _from, address indexed _to,uint256 _value);
164     event BuyToken(address indexed _from, address indexed _to, uint256 _value);
165 
166     function ISCToken() public {
167         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
168         balances[msg.sender] = totalSupply;             // Give the creator all initial tokens
169         walletOwnerAddress = msg.sender;
170         rate = 10000;
171     }
172 
173     modifier notFinalised() {
174         require(finaliseTime == 0);
175         _;
176     }
177 
178     function balanceOf(address _account) public view returns (uint) {
179         return balances[_account];
180     }
181 
182     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns(bool) {
183         require(_to != address(0x0)&&_value>0);
184         require (canTransfer(_from, _value));
185         require(balances[_from] >= _value);
186         require(safeAdd(balances[_to],_value) > balances[_to]);
187 
188         uint previousBalances = safeAdd(balances[_from],balances[_to]);
189         balances[_from] = safeSub(balances[_from],_value);
190         balances[_to] = safeAdd(balances[_to],_value);
191         emit Transfer(_from, _to, _value);
192         assert(safeAdd(balances[_from],balances[_to]) == previousBalances);
193         return true;
194     }
195 
196 
197     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){
198         return _transfer(msg.sender, _to, _value);
199     }
200 
201     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
202         require(_value <= allowances[_from][msg.sender]);
203         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);
204         return _transfer(_from, _to, _value);
205     }
206 
207     function approve(address _spender, uint256 _value) public returns (bool success) {
208         allowances[msg.sender][_spender] = _value;
209         emit Approval(msg.sender, _spender, _value);
210         return true;
211     }
212 
213      function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214         allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);
215         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
216         return true;
217   }
218 
219     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
220             uint oldValue = allowances[msg.sender][_spender];
221             if (_subtractedValue > oldValue) {
222               allowances[msg.sender][_spender] = 0;
223             } else {
224               allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
225             }
226             emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
227             return true;
228     }
229 
230     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
231         return allowances[_owner][_spender];
232     }
233  
234     //close the raise
235     function setFinaliseTime() onlyOwner notFinalised public returns(bool){
236         finaliseTime = now;
237         rate = 0;
238         return true;
239     }
240      //close the raise
241     function Restart(uint256 newrate) onlyOwner public returns(bool){
242         finaliseTime = 0;
243          rate = newrate;
244         return true;
245     }
246 
247     function setRate(uint256 newrate) onlyOwner notFinalised public returns(bool) {
248        rate = newrate;
249        return true;
250     }
251 
252     function setWalletOwnerAddress(address _newaddress) onlyOwner public returns(bool) {
253        walletOwnerAddress = _newaddress;
254        return true;
255     }
256     //Withdraw eth form the contranct 
257     function withdraw(address _to) internal returns(bool){
258         require(_to.send(this.balance));
259         emit WithDraw(msg.sender,_to,this.balance);
260         return true;
261     }
262     
263     //Lock tokens
264     function canTransfer(address _from, uint256 _value) internal view returns (bool success) {
265         uint256 index;  
266         uint256 locked;
267         index = safeSub(now, updateTime[_from]) / 1 days;
268 
269         if(index >= 160){
270             return true;
271         }
272         uint256 releasedtemp = safeMul(index,jail[_from])/200;
273         if(releasedtemp >= LockedToken[_from]){
274             return true;
275         }
276         locked = safeSub(LockedToken[_from],releasedtemp);
277         require(safeSub(balances[_from], _value) >= locked);
278         return true;
279     }
280 
281     function _buyToken(address _to,uint256 _value)internal notFinalised whenNotPaused{
282         require(_to != address(0x0));
283 
284         uint256 index;
285         uint256 locked;
286        
287         if(updateTime[_to] == 0){
288             locked = safeSub(_value,_value/5);
289             LockedToken[_to] = safeAdd(LockedToken[_to],locked);
290         }else{
291             index = safeSub(now,updateTime[_to])/1 days;
292 
293             uint256 releasedtemp = safeMul(index,jail[_to])/200;
294             if(releasedtemp >= LockedToken[_to]){
295                 LockedToken[_to] = 0;
296             }else{
297                 LockedToken[_to] = safeSub(LockedToken[_to],releasedtemp);
298             }
299             locked = safeSub(_value,_value/5);
300             LockedToken[_to] = safeAdd(LockedToken[_to],locked);
301         }
302 
303         balances[_to] = safeAdd(balances[_to], _value);
304         jail[_to] = safeAdd(jail[_to], _value);
305         balances[walletOwnerAddress] = safeSub(balances[walletOwnerAddress],_value);
306         
307         updateTime[_to] = now;
308         withdraw(walletOwnerAddress);
309         emit BuyToken(msg.sender, _to, _value);
310     }
311 
312     function() public payable{
313         require(msg.value >= 0.001 ether);
314         uint256 tokens = safeMul(msg.value,rate);
315         _buyToken(msg.sender,tokens);
316     }
317 }
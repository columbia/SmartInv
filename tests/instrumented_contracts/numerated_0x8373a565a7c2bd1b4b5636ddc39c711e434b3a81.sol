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
135 contract HTCCToken is EIP20Interface,Ownable,SafeMath,Pausable{
136     //// Constant token specific fields
137     string public constant name ="HTCCToken";
138     string public constant symbol = "HTCC";
139     uint8 public constant decimals = 18;
140     string  public version  = 'v0.1';
141     uint256 public constant initialSupply = 101010101;
142     
143     mapping (address => uint256) public balances;
144     mapping (address => mapping (address => uint256)) public allowances;
145 
146     //set raise time
147     uint256 public finaliseTime;
148 
149     //to receive eth from the contract
150     address public walletOwnerAddress;
151 
152     //Tokens to 1 eth
153     uint256 public rate;
154 
155     event WithDraw(address indexed _from, address indexed _to,uint256 _value);
156     
157 
158     function HTCCToken() public {
159         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
160         balances[msg.sender] = totalSupply;             // Give the creator all initial tokens
161         walletOwnerAddress = msg.sender;
162         rate = 1000;
163     }
164 
165     modifier notFinalised() {
166         require(finaliseTime == 0);
167         _;
168     }
169     function balanceOf(address _account) public view returns (uint) {
170         return balances[_account];
171     }
172 
173     function _transfer(address _from, address _to, uint _value) internal returns(bool) {
174         require(_to != address(0x0)&&_value>0);
175         require(balances[_from] >= _value);
176         require(safeAdd(balances[_to],_value) > balances[_to]);
177 
178         uint previousBalances = safeAdd(balances[_from],balances[_to]);
179         balances[_from] = safeSub(balances[_from],_value);
180         balances[_to] = safeAdd(balances[_to],_value);
181         emit Transfer(_from, _to, _value);
182         assert(safeAdd(balances[_from],balances[_to]) == previousBalances);
183         return true;
184     }
185 
186 
187     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){
188         return _transfer(msg.sender, _to, _value);
189     }
190 
191     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
192         require(_value <= allowances[_from][msg.sender]);
193         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);
194         return _transfer(_from, _to, _value);
195     }
196 
197     function approve(address _spender, uint256 _value) public returns (bool success) {
198         allowances[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202 
203      function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
204         allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);
205         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
206         return true;
207   }
208 
209     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210             uint oldValue = allowances[msg.sender][_spender];
211             if (_subtractedValue > oldValue) {
212               allowances[msg.sender][_spender] = 0;
213             } else {
214               allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
215             }
216             emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
217             return true;
218     }
219 
220     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
221         return allowances[_owner][_spender];
222     }
223  
224     //close the raise
225     function setFinaliseTime() onlyOwner notFinalised public returns(bool){
226         finaliseTime = now;
227         rate = 0;
228         return true;
229     }
230      //close the raise
231     function Restart(uint256 newrate) onlyOwner public returns(bool){
232         finaliseTime = 0;
233          rate = newrate;
234         return true;
235     }
236 
237     function setRate(uint256 newrate) onlyOwner notFinalised public returns(bool) {
238        rate = newrate;
239        return true;
240     }
241 
242     function setWalletOwnerAddress(address _newaddress) onlyOwner public returns(bool) {
243        walletOwnerAddress = _newaddress;
244        return true;
245     }
246     //Withdraw eth form the contranct 
247     function withdraw(address _to) internal returns(bool){
248         require(_to.send(this.balance));
249         emit WithDraw(msg.sender,_to,this.balance);
250         return true;
251     }
252     
253     function _buyToken(address _to,uint256 _value)internal notFinalised whenNotPaused{
254         require(_to != address(0x0));
255         balances[_to] = safeAdd(balances[_to],_value);
256         balances[owner] = safeSub(balances[owner],_value);
257         withdraw(walletOwnerAddress);
258     }
259 
260     function() public payable{
261         require(msg.value >= 0.01 ether);
262         uint256 tokens = safeMul(msg.value,rate);
263         _buyToken(msg.sender,tokens);
264     }
265 }
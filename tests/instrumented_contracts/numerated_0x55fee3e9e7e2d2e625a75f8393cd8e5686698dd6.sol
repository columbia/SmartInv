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
36     constructor() public {
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
135 contract BPT is EIP20Interface,Ownable,SafeMath,Pausable{
136     //// Constant token specific fields
137     string public constant name ="Bamboo Paper Token";
138     string public constant symbol = "BPT";
139     uint8 public constant decimals = 18;
140     string  public version  = 'v0.1';
141     uint256 public constant initialSupply = 1010101010;
142     
143     mapping (address => uint256) public balances;
144     mapping (address => mapping (address => uint256)) public allowances;
145 
146     /* function DMC() public{
147         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
148         balances[msg.sender] = totalSupply;             // Give the creator all initial tokens
149     } */
150 
151     constructor() public{
152         totalSupply = initialSupply*10**uint256(decimals);                        //  total supply
153         balances[msg.sender] = totalSupply;             // Give the creator all initial tokens
154     }
155 
156     function balanceOf(address _account) public view returns (uint) {
157         return balances[_account];
158     }
159 
160     function _transfer(address _from, address _to, uint _value) internal whenNotPaused returns(bool) {
161         require(_to != address(0x0)&&_value>0);
162         require(balances[_from] >= _value);
163         require(safeAdd(balances[_to],_value) > balances[_to]);
164 
165         uint previousBalances = safeAdd(balances[_from],balances[_to]);
166         balances[_from] = safeSub(balances[_from],_value);
167         balances[_to] = safeAdd(balances[_to],_value);
168         emit Transfer(_from, _to, _value);
169         assert(safeAdd(balances[_from],balances[_to]) == previousBalances);
170         return true;
171     }
172 
173 
174     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success){
175         return _transfer(msg.sender, _to, _value);
176     }
177 
178     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
179         require(_value <= allowances[_from][msg.sender]);
180         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender],_value);
181         return _transfer(_from, _to, _value);
182     }
183 
184     function approve(address _spender, uint256 _value) public returns (bool success) {
185         allowances[msg.sender][_spender] = _value;
186         emit Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190      function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
191         allowances[msg.sender][_spender] = safeAdd(allowances[msg.sender][_spender],_addedValue);
192         emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
193         return true;
194   }
195 
196     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
197             uint oldValue = allowances[msg.sender][_spender];
198             if (_subtractedValue > oldValue) {
199               allowances[msg.sender][_spender] = 0;
200             } else {
201               allowances[msg.sender][_spender] = safeSub(oldValue,_subtractedValue);
202             }
203             emit Approval(msg.sender, _spender, allowances[msg.sender][_spender]);
204             return true;
205     }
206 
207     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
208         return allowances[_owner][_spender];
209     }
210 
211     function withdrawETH (address _addr)  public onlyOwner returns(bool res) {
212         _addr.transfer(address(this).balance);
213         return true;
214     }
215     
216     function() payable public {
217         require (msg.value >= 0.001 ether);
218     }
219     
220 
221 }
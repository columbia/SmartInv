1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------------------------
4 // Sample fixed supply token contract
5 // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6 // ----------------------------------------------------------------------------------------------
7 
8 
9 // ERC Token Standard #20 Interface
10 // https://github.com/ethereum/EIPs/issues/20
11 contract ERC20Interface {
12     // Get the total token supply
13     function totalSupply() view public returns (uint256);
14 
15     // Get the account balance of another account with address _owner
16     function balanceOf(address _owner) view public returns (uint256);
17 
18     // Send _value amount of tokens to address _to
19     function transfer(address _to, uint256 _value) public returns (bool success);
20 
21     // Send _value amount of tokens from address _from to address _to
22     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
23 
24     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
25     // If this function is called again it overwrites the current allowance with _value.
26     // this function is required for some DEX functionality
27     function approve(address _spender, uint256 _value) public returns (bool success);
28 
29     // Returns the amount which _spender is still allowed to withdraw from _owner
30     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
31 
32     // Triggered when tokens are transferred.
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34 
35     // Triggered whenever approve(address _spender, uint256 _value) is called.
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 library SafeMath {
40     /**
41      * @dev Multiplies two unsigned integers, reverts on overflow.
42      */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45         // benefit is lost if 'b' is also tested.
46         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
47         if (a == 0) {
48             return 0;
49         }
50 
51         uint256 c = a * b;
52         require(c / a == b);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
59      */
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // Solidity only automatically asserts when dividing by 0
62         require(b > 0);
63         uint256 c = a / b;
64         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
65 
66         return c;
67     }
68 
69     /**
70      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         require(b <= a);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Adds two unsigned integers, reverts on overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a);
85 
86         return c;
87     }
88 
89     /**
90      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
91      * reverts when dividing by zero.
92      */
93     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
94         require(b != 0);
95         return a % b;
96     }
97 }
98 
99 contract HCREDITToken is ERC20Interface {
100    
101     using SafeMath for uint256;
102     string public constant symbol = "HCR";
103     string public constant name = "HCREDIT";
104     uint8 public constant decimals = 18;
105     uint256 _totalSupply = 1000000000000000000000000000;
106  
107      struct LockAccount{
108         uint status;
109     }
110 
111      mapping (address => LockAccount) lockAccount;
112      address[] public AllLockAccounts;
113     
114     
115     // Owner of this contract
116     address public owner;
117 
118     // Balances for each account
119     mapping (address => uint256) balances;
120 
121     // Owner of account approves the transfer of an amount to another account
122     mapping (address => mapping (address => uint256)) allowed;
123 
124     // Functions with this modifier can only be executed by the owner
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130     //Constructor
131     constructor() public {
132         owner = msg.sender;
133         balances[owner] = _totalSupply;
134     }
135     
136 
137     function totalSupply() view public returns (uint256) {
138         return _totalSupply;
139     }
140     
141     
142        function setLockAccount(address _addr) public{
143         require(msg.sender == owner);
144        
145         lockAccount[_addr].status = 1;
146         AllLockAccounts.push(_addr) -1;
147     }
148     
149       function getLockAccounts() view public returns (address[] memory){
150         return AllLockAccounts;
151     }
152       function unLockAccount(address _addr) public {
153         require(msg.sender == owner);
154        lockAccount[_addr].status = 0;
155        
156     }
157     
158     function isLock (address _addr) view private returns(bool){
159         uint lS = lockAccount[_addr].status;
160         
161         if(lS == 1){
162             return true;
163         }
164         
165         return false;
166     }
167 
168    
169      function getLockAccount(address _addr) view public returns (uint){
170         return lockAccount[_addr].status;
171     }
172 
173     // What is the balance of a particular account?
174     function balanceOf(address _owner) view public returns (uint256) {
175         return balances[_owner];
176     }
177 
178     // Transfer the balance from owner's account to another account
179     function transfer(address _to, uint256 _amount) public returns (bool success) {
180         if (balances[msg.sender] >= _amount
181         && _amount > 0
182         && balances[_to] + _amount > balances[_to]) {
183             balances[msg.sender] = balances[msg.sender].sub(_amount);
184             balances[_to] = balances[_to].add(_amount);
185             emit Transfer(msg.sender, _to, _amount);
186             return true;
187         }
188         else {
189             return false;
190         }
191     }
192 
193     // Send _value amount of tokens from address _from to address _to
194     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
195     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
196     // fees in sub-currencies; the command should fail unless the _from account has
197     // deliberately authorized the sender of the message via some mechanism; we propose
198     // these standardized APIs for approval:
199     function transferFrom(
200     address _from,
201     address _to,
202     uint256 _amount
203     ) public returns (bool) {
204         if (balances[_from] >= _amount
205         && allowed[_from][msg.sender] >= _amount
206         && _amount > 0
207         && balances[_to] + _amount > balances[_to]) {
208             balances[_from] = balances[_from].sub(_amount);
209             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
210             balances[_to] = balances[_to].add(_amount);
211             emit Transfer(_from, _to, _amount);
212             return true;
213         }
214         else {
215             return false;
216         }
217     }
218 
219 
220     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
221     // If this function is called again it overwrites the current allowance with _value.
222     function approve(address _spender, uint256 _amount) public returns (bool success) {
223         allowed[msg.sender][_spender] = _amount;
224         emit Approval(msg.sender, _spender, _amount);
225         return true;
226     }
227 
228     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
229         return allowed[_owner][_spender];
230     }
231 
232 }
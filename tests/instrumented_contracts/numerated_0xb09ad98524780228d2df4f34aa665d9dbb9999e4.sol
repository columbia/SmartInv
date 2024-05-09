1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39     address public owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54     modifier onlyOwner() {
55         require(msg.sender == owner);
56         _;
57     }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param _newOwner The address to transfer ownership to.
62    */
63     function transferOwnership(address _newOwner) public onlyOwner {
64         _transferOwnership(_newOwner);
65     }
66 
67   /**
68    * @dev Transfers control of the contract to a newOwner.
69    * @param _newOwner The address to transfer ownership to.
70    */
71     function _transferOwnership(address _newOwner) internal {
72         require(_newOwner != address(0x0));
73         emit OwnershipTransferred(owner, _newOwner);
74         owner = _newOwner;
75     }
76 }
77 
78 /**
79  * @title ERC20 interface
80  */
81 contract AbstractERC20 {
82     uint256 public totalSupply;
83     function balanceOf(address _owner) public constant returns (uint256 value);
84     function transfer(address _to, uint256 _value) public returns (bool _success);
85     function allowance(address owner, address spender) public constant returns (uint256 _value);
86     function transferFrom(address from, address to, uint256 value) public returns (bool _success);
87     function approve(address spender, uint256 value) public returns (bool _success);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90 }
91 
92 contract TradCoin is Ownable, AbstractERC20 {
93     
94     using SafeMath for uint256;
95 
96     string public name;
97     string public symbol;
98     uint8 public decimals;
99     //address of distributor
100     address public distributor;
101     // The time after which Trad tokens become transferable.
102     // Current value is July 30, 2018 23:59:59 Eastern Time.
103     uint256 becomesTransferable = 1533009599;
104 
105     mapping (address => uint256) internal balances;
106     mapping (address => mapping (address => uint256)) internal allowed;
107     // balances allowed to transfer during locking
108     mapping (address => uint256) internal balancesAllowedToTransfer;
109     //mapping to show person is investor or team/project, true=>investor, false=>team/project
110     mapping (address => bool) public isInvestor;
111 
112     event DistributorTransferred(address indexed _from, address indexed _to);
113     event Allocated(address _owner, address _investor, uint256 _tokenAmount);
114 
115     constructor(address _distributor) public {
116         require (_distributor != address(0x0));
117         name = "TradCoin";
118         symbol = "TRADCoin";
119         decimals = 18 ;
120         totalSupply = 300e6 * 10**18;    // 300 million tokens
121         owner = msg.sender;
122         distributor = _distributor;
123         balances[distributor] = totalSupply;
124         emit Transfer(0x0, owner, totalSupply);
125     }
126 
127     /// manually send tokens to investor
128     function allocateTokensToInvestors(address _to, uint256 _value) public onlyOwner returns (bool success) {
129         require(_to != address(0x0));
130         require(_value > 0);
131         uint256 unlockValue = (_value.mul(30)).div(100);
132         // SafeMath.sub will throw if there is not enough balance.
133         balances[distributor] = balances[distributor].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         balancesAllowedToTransfer[_to] = unlockValue;
136         isInvestor[_to] = true;
137         emit Allocated(msg.sender, _to, _value);
138         return true;
139     }
140 
141     /// manually send tokens to investor
142     function allocateTokensToTeamAndProjects(address _to, uint256 _value) public onlyOwner returns (bool success) {
143         require(_to != address(0x0));
144         require(_value > 0);
145         // SafeMath.sub will throw if there is not enough balance.
146         balances[distributor] = balances[distributor].sub(_value);
147         balances[_to] = balances[_to].add(_value);
148         emit Allocated(msg.sender, _to, _value);
149         return true;
150     }
151 
152     /**
153     * @dev Check balance of given account address
154     * @param owner The address account whose balance you want to know
155     * @return balance of the account
156     */
157     function balanceOf(address owner) public view returns (uint256){
158         return balances[owner];
159     }
160 
161     /**
162     * @dev transfer token for a specified address (written due to backward compatibility)
163     * @param to address to which token is transferred
164     * @param value amount of tokens to transfer
165     * return bool true=> transfer is succesful
166     */
167     function transfer(address to, uint256 value) public returns (bool) {
168         require(to != address(0x0));
169         require(value <= balances[msg.sender]);
170         uint256 valueAllowedToTransfer;
171         if(isInvestor[msg.sender]){
172             if (now >= becomesTransferable){
173                 valueAllowedToTransfer = balances[msg.sender];
174                 assert(value <= valueAllowedToTransfer);
175             }else{
176                 valueAllowedToTransfer = balancesAllowedToTransfer[msg.sender];
177                 assert(value <= valueAllowedToTransfer);
178                 balancesAllowedToTransfer[msg.sender] = balancesAllowedToTransfer[msg.sender].sub(value);
179             }
180         }
181         balances[msg.sender] = balances[msg.sender].sub(value);
182         balances[to] = balances[to].add(value);
183         emit Transfer(msg.sender, to, value);
184         return true;
185     }
186 
187     /**
188     * @dev Transfer tokens from one address to another
189     * @param from address from which token is transferred 
190     * @param to address to which token is transferred
191     * @param value amount of tokens to transfer
192     * @return bool true=> transfer is succesful
193     */
194     function transferFrom(address from, address to, uint256 value) public returns (bool) {
195         require(to != address(0x0));
196         require(value <= balances[from]);
197         require(value <= allowed[from][msg.sender]);
198         uint256 valueAllowedToTransfer;
199         if(isInvestor[from]){
200             if (now >= becomesTransferable){
201                 valueAllowedToTransfer = balances[from];
202                 assert(value <= valueAllowedToTransfer);
203             }else{
204                 valueAllowedToTransfer = balancesAllowedToTransfer[from];
205                 assert(value <= valueAllowedToTransfer);
206                 balancesAllowedToTransfer[from] = balancesAllowedToTransfer[from].sub(value);
207             }
208         }
209         balances[from] = balances[from].sub(value);
210         balances[to] = balances[to].add(value);
211         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
212         emit Transfer(from, to, value);
213         return true;
214     }
215 
216     //function to check available balance to transfer tokens during locking perios for investors
217     function availableBalanceInLockingPeriodForInvestor(address owner) public view returns(uint256){
218         return balancesAllowedToTransfer[owner];
219     }
220 
221     /**
222     * @dev Approve function will delegate spender to spent tokens on msg.sender behalf
223     * @param spender ddress which is delegated
224     * @param value tokens amount which are delegated
225     * @return bool true=> approve is succesful
226     */
227     function approve(address spender, uint256 value) public returns (bool) {
228         allowed[msg.sender][spender] = value;
229         emit Approval(msg.sender, spender, value);
230         return true;
231     }
232 
233     /**
234     * @dev it will check amount of token delegated to spender by owner
235     * @param owner the address which allows someone to spend fund on his behalf
236     * @param spender address which is delegated
237     * @return return uint256 amount of tokens left with delegator
238     */
239     function allowance(address owner, address spender) public view returns (uint256) {
240         return allowed[owner][spender];
241     }
242 
243     /**
244     * @dev increment the spender delegated tokens
245     * @param spender address which is delegated
246     * @param valueToAdd tokens amount to increment
247     * @return bool true=> operation is succesful
248     */
249     function increaseApproval(address spender, uint valueToAdd) public returns (bool) {
250         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(valueToAdd);
251         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
252         return true;
253     }
254 
255     /**
256     * @dev deccrement the spender delegated tokens
257     * @param spender address which is delegated
258     * @param valueToSubstract tokens amount to decrement
259     * @return bool true=> operation is succesful
260     */
261     function decreaseApproval(address spender, uint valueToSubstract) public returns (bool) {
262         uint oldValue = allowed[msg.sender][spender];
263         if (valueToSubstract > oldValue) {
264           allowed[msg.sender][spender] = 0;
265         } else {
266           allowed[msg.sender][spender] = oldValue.sub(valueToSubstract);
267         }
268         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
269         return true;
270     }
271 
272 }
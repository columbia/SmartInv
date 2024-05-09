1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // Owned contract
27 // ----------------------------------------------------------------------------
28 contract Owned {
29     address public owner;
30     
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41     
42     /**
43      * @dev Allows the current owner to transfer control of the contract to a newOwner.
44      * @param newOwner The address to transfer ownership to.
45      */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 }
52 
53 // ----------------------------------------------------------------------------
54 // ERC Token Standard #20 Interface
55 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
56 // ----------------------------------------------------------------------------
57 contract ERC20Interface {
58     function totalSupply() public view returns (uint);
59     function balanceOf(address tokenOwner) public view returns (uint balance);
60     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
61     function transfer(address to, uint tokens) public returns (bool success);
62     function approve(address spender, uint tokens) public returns (bool success);
63     function transferFrom(address from, address to, uint tokens) public returns (bool success);
64 
65     event Transfer(address indexed from, address indexed to, uint tokens);
66     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
67 }
68 
69 // ----------------------------------------------------------------------------
70 // ERC Token Standard #20 
71 // 
72 // ----------------------------------------------------------------------------
73 
74 contract WTXH is ERC20Interface, Owned {
75     using SafeMath for uint;
76 
77     string public constant name = "WTX Hub";
78     string public constant symbol = "WTXH";
79     uint8 public constant decimals = 18;
80     
81     mapping(address => uint) frozenAccountPeriod;
82     mapping(address => bool) frozenAccount;
83 
84     uint constant public _decimals18 = uint(10) ** decimals;
85     uint constant public _totalSupply    = 400000000 * _decimals18;
86     
87     event FrozenFunds(address target, uint period);
88 
89     constructor() public { 
90         balances[owner] = _totalSupply;
91         emit Transfer(address(0), owner, _totalSupply);
92     }
93 
94 // ----------------------------------------------------------------------------
95 // mappings for implementing ERC20 
96 // ERC20 standard functions
97 // ----------------------------------------------------------------------------
98     
99     // Balances for each account
100     mapping(address => uint) balances;
101     
102     // Owner of account approves the transfer of an amount to another account
103     mapping(address => mapping(address => uint)) allowed;
104 
105     function totalSupply() public view returns (uint) {
106         return _totalSupply;
107     }
108     
109     // Get the token balance for account `tokenOwner`
110     function balanceOf(address tokenOwner) public view returns (uint balance) {
111         return balances[tokenOwner];
112     }
113     
114     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
115         return allowed[tokenOwner][spender];
116     }
117 
118     function _transfer(address _from, address _toAddress, uint _tokens) private {
119         balances[_from] = balances[_from].sub(_tokens);
120         addToBalance(_toAddress, _tokens);
121         emit Transfer(_from, _toAddress, _tokens);
122     }
123     
124     // Transfer the balance from owner's account to another account
125     function transfer(address _add, uint _tokens) public returns (bool success) {
126         require(_add != address(0));
127         require(_tokens <= balances[msg.sender]);
128         
129         if(!frozenAccount[msg.sender] && now > frozenAccountPeriod[msg.sender]){
130             _transfer(msg.sender, _add, _tokens);
131         }
132         
133         return true;
134     }
135 
136     /*
137         Allow `spender` to withdraw from your account, multiple times, 
138         up to the `tokens` amount.If this function is called again it 
139         overwrites the current allowance with _value.
140     */
141     function approve(address spender, uint tokens) public returns (bool success) {
142         allowed[msg.sender][spender] = tokens;
143         emit Approval(msg.sender, spender, tokens);
144         return true;
145     }
146     
147     /**
148      * @dev Increase the amount of tokens that an owner allowed to a spender.
149      *
150      * approve should be called when allowed[_spender] == 0. To increment
151      * allowed value is better to use this function to avoid 2 calls (and wait until
152      * the first transaction is mined)
153      * From MonolithDAO Token.sol
154      * @param _spender The address which will spend the funds.
155      * @param _addedValue The amount of tokens to increase the allowance by.
156      */
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     /**
164      * @dev Decrease the amount of tokens that an owner allowed to a spender.
165      *
166      * approve should be called when allowed[_spender] == 0. To decrement
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      * @param _spender The address which will spend the funds.
171      * @param _subtractedValue The amount of tokens to decrease the allowance by.
172      */
173     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
174         uint oldValue = allowed[msg.sender][_spender];
175         if (_subtractedValue > oldValue) {
176             allowed[msg.sender][_spender] = 0;
177         } else {
178             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
179         }
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183     
184     /*
185         Send `tokens` amount of tokens from address `from` to address `to`
186         The transferFrom method is used for a withdraw workflow, 
187         allowing contracts to send tokens on your behalf, 
188         for example to "deposit" to a contract address and/or to charge
189         fees in sub-currencies; the command should fail unless the _from 
190         account has deliberately authorized the sender of the message via
191         some mechanism; we propose these standardized APIs for approval:
192     */
193     function transferFrom(address from, address _toAddr, uint tokens) public returns (bool success) {
194         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
195         _transfer(from, _toAddr, tokens);
196         return true;
197     }
198     
199 
200     // address not null
201     modifier addressNotNull(address _addr){
202         require(_addr != address(0));
203         _;
204     }
205 
206     // Add to balance
207     function addToBalance(address _address, uint _amount) internal {
208     	balances[_address] = balances[_address].add(_amount);
209     }
210 	
211 	 /**
212      * @dev Allows the current owner to transfer control of the contract to a newOwner.
213      * @param newOwner The address to transfer ownership to.
214      */
215     function transferOwnership(address newOwner) public onlyOwner {
216         require(newOwner != address(0));
217         emit OwnershipTransferred(owner, newOwner);
218         owner = newOwner;
219     }
220     
221     function freezeAccount(address target, uint period) public onlyOwner {
222         require(target != address(0) && owner != target);
223         frozenAccount[target] = true;
224         frozenAccountPeriod[target] = period;
225         emit FrozenFunds(target, period);
226     }
227     
228     function unFreezeAccount(address target) public onlyOwner {
229         require(target != address(0));
230         delete(frozenAccount[target]);
231         delete(frozenAccountPeriod[target]);
232     }
233     
234     function getFreezeAccountInfo(address _ad) public view onlyOwner returns(bool, uint) {
235         return (frozenAccount[_ad], frozenAccountPeriod[_ad]);
236     }
237 
238     function () payable external {
239         owner.transfer(msg.value);
240     }
241 
242 }
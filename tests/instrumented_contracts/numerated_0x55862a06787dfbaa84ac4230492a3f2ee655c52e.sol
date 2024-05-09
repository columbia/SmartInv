1 pragma solidity 0.5.10;
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
74 contract YUANC is ERC20Interface, Owned {
75     using SafeMath for uint;
76 
77     string public constant name = "Yuanc";
78     string public constant symbol = "YUC";
79     uint8  public constant decimals = 18;
80     
81     uint constant public _decimals18 = uint(10) ** decimals;
82     uint public _totalSupply = 888888888888 * _decimals18;
83     
84     event Burn(address indexed burner, uint256 value);
85 
86     constructor() public { 
87         balances[owner] = _totalSupply;
88         emit Transfer(address(0), owner, _totalSupply);
89     }
90 
91 // ----------------------------------------------------------------------------
92 // mappings for implementing ERC20 
93 // ERC20 standard functions
94 // ----------------------------------------------------------------------------
95     
96     // Balances for each account
97     mapping(address => uint) balances;
98     
99     // Owner of account approves the transfer of an amount to another account
100     mapping(address => mapping(address => uint)) allowed;
101 
102     function totalSupply() public view returns (uint) {
103         return _totalSupply;
104     }
105     
106     // Get the token balance for account `tokenOwner`
107     function balanceOf(address tokenOwner) public view returns (uint balance) {
108         return balances[tokenOwner];
109     }
110     
111     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
112         return allowed[tokenOwner][spender];
113     }
114 
115     function _transfer(address _from, address _toAddress, uint _tokens) private {
116         balances[_from] = balances[_from].sub(_tokens);
117         addToBalance(_toAddress, _tokens);
118         emit Transfer(_from, _toAddress, _tokens);
119     }
120     
121     // Transfer the balance from owner's account to another account
122     function transfer(address _add, uint _tokens) public returns (bool success) {
123         require(_add != address(0));
124         require(_tokens <= balances[msg.sender]);
125         _transfer(msg.sender, _add, _tokens);
126         return true;
127     }
128 
129     /*
130         Allow `spender` to withdraw from your account, multiple times, 
131         up to the `tokens` amount.If this function is called again it 
132         overwrites the current allowance with _value.
133     */
134     function approve(address spender, uint tokens) public returns (bool success) {
135         allowed[msg.sender][spender] = tokens;
136         emit Approval(msg.sender, spender, tokens);
137         return true;
138     }
139     
140     /**
141      * @dev Increase the amount of tokens that an owner allowed to a spender.
142      *
143      * approve should be called when allowed[_spender] == 0. To increment
144      * allowed value is better to use this function to avoid 2 calls (and wait until
145      * the first transaction is mined)
146      * From MonolithDAO Token.sol
147      * @param _spender The address which will spend the funds.
148      * @param _addedValue The amount of tokens to increase the allowance by.
149      */
150     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
151         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153         return true;
154     }
155 
156     /**
157      * @dev Decrease the amount of tokens that an owner allowed to a spender.
158      *
159      * approve should be called when allowed[_spender] == 0. To decrement
160      * allowed value is better to use this function to avoid 2 calls (and wait until
161      * the first transaction is mined)
162      * From MonolithDAO Token.sol
163      * @param _spender The address which will spend the funds.
164      * @param _subtractedValue The amount of tokens to decrease the allowance by.
165      */
166     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
167         uint oldValue = allowed[msg.sender][_spender];
168         if (_subtractedValue > oldValue) {
169             allowed[msg.sender][_spender] = 0;
170         } else {
171             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
172         }
173         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
174         return true;
175     }
176     
177     /*
178         Send `tokens` amount of tokens from address `from` to address `to`
179         The transferFrom method is used for a withdraw workflow, 
180         allowing contracts to send tokens on your behalf, 
181         for example to "deposit" to a contract address and/or to charge
182         fees in sub-currencies; the command should fail unless the _from 
183         account has deliberately authorized the sender of the message via
184         some mechanism; we propose these standardized APIs for approval:
185     */
186     function transferFrom(address from, address _toAddr, uint tokens) public returns (bool success) {
187         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
188         _transfer(from, _toAddr, tokens);
189         return true;
190     }
191     
192 
193     // address not null
194     modifier addressNotNull(address _addr){
195         require(_addr != address(0));
196         _;
197     }
198 
199     // Add to balance
200     function addToBalance(address _address, uint _amount) internal {
201     	balances[_address] = balances[_address].add(_amount);
202     }
203 	
204 	 /**
205      * @dev Allows the current owner to transfer control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function transferOwnership(address newOwner) public onlyOwner {
209         require(newOwner != address(0));
210         emit OwnershipTransferred(owner, newOwner);
211         owner = newOwner;
212     }
213     
214     /* Burn token */
215     function burn(uint256 _value) public {
216         _burn(msg.sender, _value);
217     }
218     
219     
220     function _burn(address _who, uint256 _value) internal {
221         require(_value <= balances[_who]);
222         balances[_who] = balances[_who].sub(_value);
223         _totalSupply = _totalSupply.sub(_value);
224         emit Burn(_who, _value);
225         emit Transfer(_who, address(0), _value);
226     }
227 
228 }
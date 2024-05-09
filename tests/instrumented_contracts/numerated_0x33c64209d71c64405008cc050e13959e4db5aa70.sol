1 pragma solidity 0.4.24;
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
81     uint constant public _decimals18 = uint(10) ** decimals;
82     uint constant public _totalSupply    = 400000000 * _decimals18;
83 
84     constructor() public { 
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89 // ----------------------------------------------------------------------------
90 // mappings for implementing ERC20 
91 // ERC20 standard functions
92 // ----------------------------------------------------------------------------
93     
94     // Balances for each account
95     mapping(address => uint) balances;
96     
97     // Owner of account approves the transfer of an amount to another account
98     mapping(address => mapping(address => uint)) allowed;
99 
100     function totalSupply() public view returns (uint) {
101         return _totalSupply;
102     }
103     
104     // Get the token balance for account `tokenOwner`
105     function balanceOf(address tokenOwner) public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108     
109     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
110         return allowed[tokenOwner][spender];
111     }
112 
113     function _transfer(address _from, address _toAddress, uint _tokens) private {
114         balances[_from] = balances[_from].sub(_tokens);
115         addToBalance(_toAddress, _tokens);
116         emit Transfer(_from, _toAddress, _tokens);
117     }
118     
119     // Transfer the balance from owner's account to another account
120     function transfer(address _add, uint _tokens) public returns (bool success) {
121         require(_add != address(0));
122         require(_tokens <= balances[msg.sender]);
123         
124         _transfer(msg.sender, _add, _tokens);
125         return true;
126     }
127 
128     /*
129         Allow `spender` to withdraw from your account, multiple times, 
130         up to the `tokens` amount.If this function is called again it 
131         overwrites the current allowance with _value.
132     */
133     function approve(address spender, uint tokens) public returns (bool success) {
134         allowed[msg.sender][spender] = tokens;
135         emit Approval(msg.sender, spender, tokens);
136         return true;
137     }
138     
139     /**
140      * @dev Increase the amount of tokens that an owner allowed to a spender.
141      *
142      * approve should be called when allowed[_spender] == 0. To increment
143      * allowed value is better to use this function to avoid 2 calls (and wait until
144      * the first transaction is mined)
145      * From MonolithDAO Token.sol
146      * @param _spender The address which will spend the funds.
147      * @param _addedValue The amount of tokens to increase the allowance by.
148      */
149     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
150         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
151         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
152         return true;
153     }
154 
155     /**
156      * @dev Decrease the amount of tokens that an owner allowed to a spender.
157      *
158      * approve should be called when allowed[_spender] == 0. To decrement
159      * allowed value is better to use this function to avoid 2 calls (and wait until
160      * the first transaction is mined)
161      * From MonolithDAO Token.sol
162      * @param _spender The address which will spend the funds.
163      * @param _subtractedValue The amount of tokens to decrease the allowance by.
164      */
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166         uint oldValue = allowed[msg.sender][_spender];
167         if (_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         } else {
170             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175     
176     /*
177         Send `tokens` amount of tokens from address `from` to address `to`
178         The transferFrom method is used for a withdraw workflow, 
179         allowing contracts to send tokens on your behalf, 
180         for example to "deposit" to a contract address and/or to charge
181         fees in sub-currencies; the command should fail unless the _from 
182         account has deliberately authorized the sender of the message via
183         some mechanism; we propose these standardized APIs for approval:
184     */
185     function transferFrom(address from, address _toAddr, uint tokens) public returns (bool success) {
186         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
187         _transfer(from, _toAddr, tokens);
188         return true;
189     }
190     
191 
192     // address not null
193     modifier addressNotNull(address _addr){
194         require(_addr != address(0));
195         _;
196     }
197 
198     // Add to balance
199     function addToBalance(address _address, uint _amount) internal {
200     	balances[_address] = balances[_address].add(_amount);
201     }
202 	
203 	 /**
204      * @dev Allows the current owner to transfer control of the contract to a newOwner.
205      * @param newOwner The address to transfer ownership to.
206      */
207     function transferOwnership(address newOwner) public onlyOwner {
208         require(newOwner != address(0));
209         emit OwnershipTransferred(owner, newOwner);
210         owner = newOwner;
211     }
212 
213     function () payable external {
214         owner.transfer(msg.value);
215     }
216 
217 }
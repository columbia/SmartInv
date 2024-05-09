1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         assert(c >= a);
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 }
27 
28 contract Owned {
29     address public owner;
30 
31     event OwnershipTransferred(address indexed _from, address indexed _to);
32 
33     constructor() public {
34         owner = 0x7bef46eC3561131fB1FC93B9C4C42B9e20500648;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address _newOwner) public onlyOwner {
43         require(_newOwner != address(0x0));
44         emit OwnershipTransferred(owner,_newOwner);
45         owner = _newOwner;
46     }
47     
48 }
49 
50 
51 contract ERC20Interface {
52     function totalSupply() public view returns (uint);
53     function balanceOf(address tokenOwner) public view returns (uint balance);
54     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 
64 contract GhtToken is ERC20Interface, Owned {
65     
66     using SafeMath for uint;
67    
68     string public symbol;
69     string public  name;
70     uint8 public decimals;
71     uint public _totalSupply;
72   
73     mapping(address => uint) balances;
74     mapping(address => mapping(address => uint)) allowed;
75     
76     event Burn(address indexed burner, uint256 value);
77     
78     // ------------------------------------------------------------------------
79     // Constructor
80     // ------------------------------------------------------------------------
81     constructor() public {
82         symbol = "GHT";
83         name = "Groovy Hooman Token";
84         decimals = 18;
85         _totalSupply = 74000000;
86         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
87         balances[owner] = _totalSupply;
88         emit Transfer(address(0), owner, _totalSupply);
89     }
90     
91     
92     // ------------------------------------------------------------------------
93     // Total supply
94     // ------------------------------------------------------------------------
95     function totalSupply() public view returns (uint) {
96         return _totalSupply;
97     }
98 
99     function() public payable{
100         revert();
101     }
102 
103     // ------------------------------------------------------------------------
104     // Get the token balance for account `tokenOwner`
105     // ------------------------------------------------------------------------
106     function balanceOf(address tokenOwner) public view returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Transfer the balance from token owner's account to `to` account
113     // - Owner's account must have sufficient balance to transfer
114     // - 0 value transfers are allowed
115     // ------------------------------------------------------------------------
116     function transfer(address to, uint tokens) public returns (bool success) {
117         require(to != address(0));
118         require(tokens > 0);
119         require(balances[msg.sender] >= tokens);
120         
121         balances[msg.sender] = balances[msg.sender].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         emit Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Token owner can approve for `spender` to transferFrom(...) `tokens`
130     // from the token owner's account
131     //
132     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
133     // recommends that there are no checks for the approval double-spend attack
134     // as this should be implemented in user interfaces 
135     // ------------------------------------------------------------------------
136     function approve(address spender, uint tokens) public returns (bool success) {
137         require(spender != address(0));
138         require(tokens > 0);
139         
140         allowed[msg.sender][spender] = tokens;
141         emit Approval(msg.sender, spender, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer `tokens` from the `from` account to the `to` account
148     // 
149     // The calling account must already have sufficient tokens approve(...)-d
150     // for spending from the `from` account and
151     // - From account must have sufficient balance to transfer
152     // - Spender must have sufficient allowance to transfer
153     // ------------------------------------------------------------------------
154     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
155         require(from != address(0));
156         require(to != address(0));
157         require(tokens > 0);
158         require(balances[from] >= tokens);
159         require(allowed[from][msg.sender] >= tokens);
160         
161         balances[from] = balances[from].sub(tokens);
162         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163         balances[to] = balances[to].add(tokens);
164         emit Transfer(from, to, tokens);
165         return true;
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Returns the amount of tokens approved by the owner that can be
171     // transferred to the spender's account
172     // ------------------------------------------------------------------------
173     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
174         return allowed[tokenOwner][spender];
175     }
176     
177     
178     // ------------------------------------------------------------------------
179     // Increase the amount of tokens that an owner allowed to a spender.
180     //
181     // approve should be called when allowed[_spender] == 0. To increment
182     // allowed value is better to use this function to avoid 2 calls (and wait until
183     // the first transaction is mined)
184     // _spender The address which will spend the funds.
185     // _addedValue The amount of tokens to increase the allowance by.
186     // ------------------------------------------------------------------------
187     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
188         require(_spender != address(0));
189         
190         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194     
195     
196     // ------------------------------------------------------------------------
197     // Decrease the amount of tokens that an owner allowed to a spender.
198     //
199     // approve should be called when allowed[_spender] == 0. To decrement
200     // allowed value is better to use this function to avoid 2 calls (and wait until
201     // the first transaction is mined)
202     // _spender The address which will spend the funds.
203     // _subtractedValue The amount of tokens to decrease the allowance by.
204     // ------------------------------------------------------------------------
205     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206         require(_spender != address(0));
207         
208         uint oldValue = allowed[msg.sender][_spender];
209         if (_subtractedValue > oldValue) {
210             allowed[msg.sender][_spender] = 0;
211         } else {
212             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213         }
214         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215         return true;
216     }
217     
218     
219     // ------------------------------------------------------------------------
220     // Burns a specific amount of tokens.
221     // _value The amount of token to be burned.
222     // ------------------------------------------------------------------------
223     function burn(uint256 _value) onlyOwner public {
224       require(_value > 0);
225       require(_value <= balances[owner]);
226       balances[owner] = balances[owner].sub(_value);
227       _totalSupply = _totalSupply.sub(_value);
228       emit Burn(owner, _value);
229       emit Transfer(owner, address(0), _value);
230     }
231     
232 }
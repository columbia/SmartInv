1 pragma solidity 0.5.12;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20     
21     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
22         uint256 c = add(a,m);
23         uint256 d = sub(c,1);
24         return mul(div(d,m),m);
25     }
26 }
27 
28 // ----------------------------------------------------------------------------
29 // Owned contract
30 // ----------------------------------------------------------------------------
31 contract Owned {
32     address public owner;
33     address public newOwner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address _newOwner) public onlyOwner {
43         newOwner = _newOwner;
44     }
45     
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 	
53 	function returnOwner() public view returns(address){
54 		return owner;
55 	}
56 }
57 
58 // ----------------------------------------------------------------------------
59 // ERC Token Standard #20 Interface
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function totalSupply() public view returns (uint);
63     function balanceOf(address tokenOwner) public view returns (uint balance);
64     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 
73 // ----------------------------------------------------------------------------
74 // ERC20 Token, with the addition of symbol, name and decimals and assisted
75 // token transfers
76 // ----------------------------------------------------------------------------
77 contract Mnoer is ERC20Interface, Owned {
78     using SafeMath for uint;
79     
80     string public symbol = "MNR";
81     string public  name = "Mnoer";
82     uint8 public decimals = 18;
83     uint public _totalSupply = 1000000000000000000000000000;
84     uint256 public extras = 100;
85     
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88     // ------------------------------------------------------------------------
89     // Constructor
90     // ------------------------------------------------------------------------
91     constructor(address _owner) public {
92         owner = address(_owner);
93         balances[address(owner)] =  _totalSupply;
94         emit Transfer(address(0),address(owner), _totalSupply * 10**uint(decimals));
95     }
96     
97     // ------------------------------------------------------------------------
98     // Don't Accepts ETH
99     // ------------------------------------------------------------------------
100     function () external payable {
101         revert();
102     }
103     
104     /*===============================ERC20 functions=====================================*/
105     
106     function totalSupply() public view returns (uint){
107        return _totalSupply;
108     }
109     // ------------------------------------------------------------------------
110     // Get the token balance for account `tokenOwner`
111     // ------------------------------------------------------------------------
112     function balanceOf(address tokenOwner) public view returns (uint balance) {
113         return balances[tokenOwner];
114     }
115 
116     // ------------------------------------------------------------------------
117     // Transfer the balance from token owner's account to `to` account
118     // - Owner's account must have sufficient balance to transfer
119     // - 0 value transfers are allowed
120     // ------------------------------------------------------------------------
121     function transfer(address to, uint tokens) public returns (bool success) {
122         // prevent transfer to 0x0, use burn instead
123         require(to != address(0));
124         require(balances[msg.sender] >= tokens );
125         
126         balances[msg.sender] = balances[msg.sender].sub(tokens);
127 
128         require(balances[to] + tokens >= balances[to]);
129         
130         // Transfer the unburned tokens to "to" address
131         balances[to] = balances[to].add(tokens);
132         
133         // emit Transfer event to "to" address
134         emit Transfer(msg.sender,to,tokens);
135         
136         return true;
137     }
138     
139     
140     // ------------------------------------------------------------------------
141     // Transfer `tokens` from the `from` account to the `to` account
142     // 
143     // The calling account must already have sufficient tokens approve(...)-d
144     // for spending from the `from` account and
145     // - From account must have sufficient balance to transfer
146     // - Spender must have sufficient allowance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transferFrom(address from, address to, uint tokens) public returns (bool success){
150         require(tokens <= allowed[from][msg.sender]); //check allowance
151         require(balances[from] >= tokens); // check if sufficient balance exist or not
152         
153         balances[from] = balances[from].sub(tokens);
154         
155         
156         require(balances[to] + tokens >= balances[to]);
157         // Transfer the unburned tokens to "to" address
158         balances[to] = balances[to].add(tokens);
159         
160         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
161         
162         emit Transfer(from,to,tokens);
163         
164         return true;
165     }
166     
167     //Creating tokens only Owner function
168     function createTokens(uint256 tokens) public onlyOwner{
169         require(tokens >= 0 );
170         balances[msg.sender] = balances[msg.sender].add(tokens);
171         _totalSupply = _totalSupply.add(tokens);
172     }
173     
174      //Creating tokens only Owner function
175     function deleteTokens(uint256 tokens) public onlyOwner{
176         require(tokens >= 0);
177         require(balances[msg.sender] >= tokens);
178         balances[msg.sender] = balances[msg.sender].sub(tokens);
179         _totalSupply = _totalSupply.sub(tokens);
180     }
181     
182     // ------------------------------------------------------------------------
183     // Token owner can approve for `spender` to transferFrom(...) `tokens`
184     // from the token owner's account
185     // ------------------------------------------------------------------------
186     function approve(address spender, uint tokens) public returns (bool success){
187         require(allowed[msg.sender][spender] == 0 || tokens == 0);
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender,spender,tokens);
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200     
201 }
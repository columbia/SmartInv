1 pragma solidity >=0.4.0 <0.7.0;
2 
3 /**
4  * SesameOpen Protocol Token
5  *
6  * Symbol      : SO
7  * Name        : SesameOpen Protocol Token
8  * Total Supply: 1,000,000,000 tokens
9  * Decimals    : 18
10  */
11 
12 
13 /**
14  * Saft maths
15  */
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21 
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26 
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31 
32     function div(uint a, uint b) internal pure returns (uint c) {
33         require(b > 0);
34         c = a / b;
35     }
36 }
37 
38 
39 /**
40  * Owned contract
41  */
42 contract Owned {
43     address public owner;
44     address public newOwner;
45 
46     event OwnershipTransferred(address indexed _from, address indexed _to);
47 
48     constructor() public {
49         owner = msg.sender;
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60 
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 
70 /**
71  * ERC20 Token Standard Interface
72  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
73  */
74 contract ERC20Interface {
75     function totalSupply() public view returns (uint);
76     function balanceOf(address tokenOwner) public view returns (uint balance);
77     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
78     function transfer(address to, uint tokens) public returns (bool success);
79     function approve(address spender, uint tokens) public returns (bool success);
80     function transferFrom(address from, address to, uint tokens) public returns (bool success);
81 
82     event Transfer(address indexed from, address indexed to, uint tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 
87 /*
88  * SesameOpen Protocol Token
89  */
90 contract SesameOpenToken is ERC20Interface, Owned {
91     using SafeMath for uint;
92 
93     string constant public symbol = "SO";
94     string constant public  name = "SesameOpen Protocol Token";
95     uint8 constant public decimals = 18;
96     uint public totalTokenSupply = 10**27; // 1 billion tokens, 18 decimals
97 
98     mapping(address => uint) balances;
99     mapping(address => mapping(address => uint)) allowed;
100 
101     constructor() public {
102         balances[owner] = totalTokenSupply;
103         emit Transfer(address(0), owner, totalTokenSupply);
104     }
105 
106     /// Allow contract to accept ETH
107     function() external payable {
108 
109     }
110 
111     /// Allow only owner to withdraw ETH accidentally sent to the contract
112     function withdrawETH() external onlyOwner {
113         msg.sender.transfer(address(this).balance);
114     }
115 
116     /// Allow only owner to withdraw ERC20 accidentally sent to the contract
117     function withdrawERC20(address tokenContractAddress) external onlyOwner {
118         ERC20Interface tc = ERC20Interface(tokenContractAddress);
119         tc.transfer(owner, tc.balanceOf(address(this)));
120     }
121 
122     /**
123      * Implementation of required ERC20 functions
124      */
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public returns (bool success) {
132         balances[msg.sender] = balances[msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(msg.sender, to, tokens);
135         return true;
136     }
137 
138     // ------------------------------------------------------------------------
139     // Token owner can approve for `spender` to transferFrom(...) `tokens`
140     // from the token owner's account
141     //
142     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
143     // recommends that there are no checks for the approval double-spend attack
144     // as this should be implemented in user interfaces
145     // ------------------------------------------------------------------------
146     function approve(address spender, uint tokens)
147         public
148         returns (bool success)
149     {
150         allowed[msg.sender][spender] = tokens;
151         emit Approval(msg.sender, spender, tokens);
152         return true;
153     }
154 
155     // ------------------------------------------------------------------------
156     // Transfer `tokens` from the `from` account to the `to` account
157     //
158     // The calling account must already have sufficient tokens approve(...)-d
159     // for spending from the `from` account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens)
165         public
166         returns (bool success)
167     {
168         balances[from] = balances[from].sub(tokens);
169         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
170         balances[to] = balances[to].add(tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174 
175     function totalSupply() public view returns (uint) {
176         return totalTokenSupply.sub(balances[address(0)]);
177     }
178 
179     function balanceOf(address tokenOwner) public view returns (uint balance) {
180         return balances[tokenOwner];
181     }
182 
183     function allowance(address tokenOwner, address spender)
184         public
185         view
186         returns (uint remaining)
187     {
188         return allowed[tokenOwner][spender];
189     }
190 
191 }
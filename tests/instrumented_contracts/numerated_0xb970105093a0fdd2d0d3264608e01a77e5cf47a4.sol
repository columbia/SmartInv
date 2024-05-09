1 pragma solidity ^0.4.25;
2 
3 contract ERC20Token {
4     string public symbol;
5     string public name;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) balances;
10     mapping (address => mapping (address => uint256)) allowed;
11 
12     function balanceOf(address tokenOwner) public constant returns (uint256 balance);
13     function allowance(address tokenOwner, address spender) public constant returns (uint256 remaining);
14     function transfer(address to, uint256 tokens) public returns (bool success);
15     function approve(address spender, uint256 tokens) public returns (bool success);
16     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
17 
18     event Transfer(address indexed from, address indexed to, uint256 tokens);
19     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
20 }
21 
22 contract Owned {
23     address owner;
24     constructor() public {
25         owner = msg.sender;
26     }
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     function transferOwnership(address newOwner) onlyOwner public returns (bool success) {
32         require (newOwner != address(0));
33         owner = newOwner;
34         return true;
35     }
36 }
37 
38 contract ECToken is ERC20Token, Owned {
39     using SafeMath for uint256;
40     
41     constructor() public {
42         symbol = "EC";
43         name = "ElephantChain";
44         decimals = 8;
45         totalSupply = 21000000 * 10 ** uint256(decimals);
46         
47         balances[owner] = totalSupply;
48         emit Transfer(address(0), owner, totalSupply);
49     }
50 
51     //ERC20Token
52     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
53         return balances[tokenOwner];
54     }
55     
56     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
57         return allowed[tokenOwner][spender];
58     }
59 
60     function transfer(address to, uint256 tokens) public returns (bool success) {
61         _transfer(msg.sender,to,tokens);
62         return true;
63     }
64 
65     function approve(address spender, uint256 tokens) public returns (bool success) {
66         allowed[msg.sender][spender] = tokens;
67         emit Approval(msg.sender, spender, tokens);
68         return true;
69     }
70     
71     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
72         balances[from] = balances[from].sub(tokens);
73         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
74         balances[to] = balances[to].add(tokens);
75         emit Transfer(from, to, tokens);
76         return true;
77     }
78     //end ERC20Token
79     
80     //frozenAccount
81     mapping (address => bool) public frozenAccount;
82     event FrozenFunds(address target, bool frozen);
83     
84     function freezeAccount(address target) onlyOwner public returns (bool success) {
85         require (target != address(0));
86         frozenAccount[target] = true;
87         emit FrozenFunds(target, true);
88         return true;
89     }
90     
91 	function unfreezeAccount(address target) onlyOwner public returns (bool success) {
92 	    require (target != address(0));
93         frozenAccount[target] = false;
94         emit FrozenFunds(target, false);
95         return true;
96     }
97     //end frozenAccount
98     
99     function increaseSupply(uint256 tokens) onlyOwner public returns (bool success) {
100         require(tokens > 0);
101         totalSupply = totalSupply.add(tokens);
102         balances[owner] = balances[owner].add(tokens);
103         _transfer(msg.sender, owner, tokens);
104         return true;
105     }
106 
107     function decreaseSupply(uint256 tokens) onlyOwner public returns (bool success) {
108         require(tokens > 0);
109         require(balances[owner] >= tokens);
110         balances[owner] = balances[owner].sub(tokens);
111         totalSupply = totalSupply.sub(tokens);
112         _transfer(owner, msg.sender, tokens);
113         return true;
114     }
115     
116     function _transfer(address spender, address target, uint256 tokens) private {
117         require (target != address(0));
118         require(tokens > 0);
119         require (balances[spender] >= tokens);
120         require (balances[target].add(tokens) >= balances[target]);
121         require(!frozenAccount[spender]);
122         require(!frozenAccount[target]);
123         uint256 previousBalances = balances[spender].add(balances[target]);
124         balances[spender] = balances[spender].sub(tokens);
125         balances[target] = balances[target].add(tokens);
126         emit Transfer(spender, target, tokens);
127         assert(balances[spender].add(balances[target]) == previousBalances);
128     }
129 }
130 
131 library SafeMath {
132     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133         c = a + b;
134         require(c >= a);
135     }
136     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
137         require(b <= a);
138         c = a - b;
139     }
140     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
141         c = a * b;
142         require(a == 0 || c / a == b);
143     }
144     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
145         require(b > 0);
146         c = a / b;
147     }
148 }
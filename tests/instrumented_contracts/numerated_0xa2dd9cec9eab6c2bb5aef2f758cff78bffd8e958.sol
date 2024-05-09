1 pragma solidity ^0.4.18;
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
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     function Owned() public {
44         owner = msg.sender;
45     }
46     modifier onlyOwner {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function transferOwnership(address _newOwner) public onlyOwner {
52         newOwner = _newOwner;
53     }
54     function acceptOwnership() public {
55         require(msg.sender == newOwner);
56         OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 contract Garlicoin is ERC20Interface, Owned {
63     using SafeMath for uint;
64     string public symbol;
65     string public  name;
66     uint8 public decimals;
67     uint public _totalSupply;
68     mapping(address => uint) balances;
69     mapping(address => mapping(address => uint)) allowed;
70     uint etherCost1;
71     uint etherCost2;
72     uint etherCost3;
73     uint deadline1;
74     uint deadline2;
75     uint deadline3;
76     uint etherCostOfEachToken;
77     bool burnt = false;
78 
79     function Garlicoin() public {
80         symbol = "GLC";
81         name = "Garlicoin";
82         decimals = 18;
83         etherCost1 = 0.1 finney;
84         etherCost2 = 0.15 finney;
85         etherCost3 = 0.25 finney;
86         _totalSupply = 1000000 * 10**uint(decimals);
87         balances[owner] = _totalSupply;
88         Transfer(address(0), owner, _totalSupply);
89         deadline1 = now + 1 * 1 days;
90         deadline2 = now + 4 * 1 days;
91         deadline3 = now + 14 * 1 days;
92         
93     }
94 
95     function totalSupply() public constant returns (uint) {
96         return _totalSupply  - balances[address(0)];
97     }
98 
99     function balanceOf(address tokenOwner) public constant returns (uint balance) {
100         return balances[tokenOwner];
101     }
102 
103     function transfer(address to, uint tokens) public returns (bool success) {
104         balances[msg.sender] = balances[msg.sender].sub(tokens);
105         balances[to] = balances[to].add(tokens);
106         Transfer(msg.sender, to, tokens);
107         return true;
108     }
109 
110 
111     function approve(address spender, uint tokens) public returns (bool success) {
112         allowed[msg.sender][spender] = tokens;
113         Approval(msg.sender, spender, tokens);
114         return true;
115     }
116 
117 
118     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
119         balances[from] = balances[from].sub(tokens);
120         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         Transfer(from, to, tokens);
123         return true;
124     }
125 
126     function withdraw() public {
127         if (msg.sender != owner) {
128             return;
129         }
130         owner.transfer(this.balance);
131     }
132 
133     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
134         return allowed[tokenOwner][spender];
135     }
136 
137 
138     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         Approval(msg.sender, spender, tokens);
141         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
142         return true;
143     }
144 
145     // ------------------------------------------------------------------------
146     // If you've made it this far in the code, I probably don't have to tell you
147     // how dogshit this crypto is. You might tell yourself that it's obviously 
148     // a bad investment because of this. But what if it wasn't? What if its
149     // useless, pathetic nature makes it not only special, but legendary? What
150     // if years, even decades from now, when economists discuss the network of 
151     // manic crazed millenials fueling the great cryptocurrency bubble, they 
152     // all use the same example, the epitome of hype, the hobo's puddle of urine
153     // that was Garlicoin? They'd give lectures on how within days it had 
154     // reached fifteen times its original value, and in a year it was the world
155     // cryptocurrency standard to replace Bitcoin.
156     
157     // I'm not going to tell you that any of this is going to happen, but what 
158     // I will tell you is this is a chance for you to be part of history, 
159     // forever engraved into the immutable, pseudo-eternal Ethereum blockchain.
160     
161     // Now please buy my shitcoin so I can afford dinner tonight.
162     // ------------------------------------------------------------------------
163     function () public payable {
164         require(now <= deadline3);
165         if (now > deadline3) {
166             revert();
167         } else if (now <= deadline1) {
168             etherCostOfEachToken = etherCost1;
169         } else if (now <= deadline2) {
170             etherCostOfEachToken = etherCost2;
171         } else if (now <= deadline3) {
172             etherCostOfEachToken = etherCost3;
173         }
174         uint weiAmount = msg.value;
175         uint glcAmount = weiAmount / etherCostOfEachToken * 1000000000000000000;
176         balances[owner] = balances[owner].sub(glcAmount);
177         balances[msg.sender] = balances[msg.sender].add(glcAmount);
178         Transfer(owner, msg.sender, glcAmount);
179     }
180     
181     function burn () public {
182         if (burnt == true) {
183             return;
184         } else {
185             if (now <= deadline3) {
186                 return;
187             }
188             burnt = true;
189             balances[owner] = 0;
190         }
191     }
192 
193 
194     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
195         return ERC20Interface(tokenAddress).transfer(owner, tokens);
196     }
197 }
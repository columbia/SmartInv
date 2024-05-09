1 pragma solidity ^0.4.23;
2 
3 contract Control {
4     address public owner;
5     bool public pause;
6 
7     event PAUSED();
8     event STARTED();
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     modifier whenPaused {
16         require(pause);
17         _;
18     }
19 
20     modifier whenNotPaused {
21         require(!pause);
22         _;
23     }
24 
25     function setOwner(address _owner) onlyOwner public {
26         owner = _owner;
27     }
28 
29     function setState(bool _pause) onlyOwner public {
30         pause = _pause;
31         if (pause) {
32             emit PAUSED();
33         } else {
34             emit STARTED();
35         }
36     }
37     
38     constructor() public {
39         owner = msg.sender;
40     }
41 }
42 
43 contract ERC20Token {
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint256 tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     function symbol() public constant returns (string);
52     function decimals() public constant returns (uint256);
53     
54     event Transfer(address indexed from, address indexed to, uint tokens);
55     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
56 }
57 
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
65     // benefit is lost if 'b' is also tested.
66     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
67     if (a == 0) {
68       return 0;
69     }
70 
71     c = a * b;
72     assert(c / a == b);
73     return c;
74   }
75 
76   /**
77   * @dev Integer division of two numbers, truncating the quotient.
78   */
79   function div(uint256 a, uint256 b) internal pure returns (uint256) {
80     // assert(b > 0); // Solidity automatically throws when dividing by 0
81     // uint256 c = a / b;
82     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83     return a / b;
84   }
85 
86   /**
87   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
88   */
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   /**
95   * @dev Adds two numbers, throws on overflow.
96   */
97   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
98     c = a + b;
99     assert(c >= a);
100     return c;
101   }
102 }
103 
104 contract token is Control, ERC20Token {
105     using SafeMath for uint256;
106     
107     uint256 public totalSupply;
108     uint256 public forSell;
109     uint256 public decimals;
110     
111     mapping(address => uint256) public balanceOf;
112     mapping(address => mapping(address => uint256)) public allowance;
113     
114     string public symbol;
115     string public name;
116     
117     constructor(string _name) public {
118         owner = 0x60dc10E6b27b6c70B97d1F3370198d076F5A48D8;
119         decimals = 18;
120         totalSupply = 100000000000 * (10 ** decimals);
121         name = _name;
122         symbol = _name;
123         forSell = 50000000000 * (10 ** decimals);
124         balanceOf[owner] = totalSupply.sub(forSell);
125         
126         emit Transfer(0, owner, balanceOf[owner]);
127     }
128     
129     function transfer(address to, uint256 amount) public whenNotPaused returns (bool) {
130         require(balanceOf[msg.sender] >= amount);
131         balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
132         balanceOf[to] = balanceOf[to].add(amount);
133         
134         emit Transfer(msg.sender, to, amount);
135         return true;
136     }
137     
138     function approve(address to, uint256 amount) public whenNotPaused returns (bool) {
139         allowance[msg.sender][to] = amount;
140         
141         emit Approval(msg.sender, to , amount);
142         return true;
143     }
144     
145     function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
146         require(allowance[from][msg.sender] >= amount);
147         require(balanceOf[from] >= amount);
148         
149         allowance[from][msg.sender] = allowance[from][msg.sender].sub(amount);
150         balanceOf[from] = balanceOf[from].sub(amount);
151         balanceOf[to] = balanceOf[to].add(amount);
152         
153         emit Transfer(from, to, amount);
154         return true;
155     }
156     
157     function totalSupply() public constant returns (uint) {
158         return totalSupply;
159     }
160     
161     function balanceOf(address tokenOwner) public constant returns (uint balance) {
162         return balanceOf[tokenOwner];
163     }
164     
165     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
166         return allowance[tokenOwner][spender];
167     }
168     
169     function symbol() public constant returns (string) {
170         return symbol;
171     }
172     
173     function decimals() public constant returns (uint256){
174         return decimals;
175     }
176     
177     function sellToken() payable public {
178         require(msg.value >= 1000000000000000);
179         require(forSell >= 0);
180         uint256 amount = msg.value.mul(100000000);
181         forSell = forSell.sub(amount);
182         balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
183         
184         owner.transfer(msg.value);
185         emit Transfer(0, msg.sender, amount);
186     }
187     
188     function() payable public {
189         sellToken();
190     }
191 }
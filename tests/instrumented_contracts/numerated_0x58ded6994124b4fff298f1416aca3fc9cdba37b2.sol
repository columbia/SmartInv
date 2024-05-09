1 pragma solidity ^0.4.18;
2    
3   // Under copy right of Joint Education Limited Partnership
4   //www.jointedu.net
5   
6   library SafeMath {
7       function add(uint a, uint b) internal pure returns (uint c) {
8           c = a + b;
9           require(c >= a);
10       }
11       function sub(uint a, uint b) internal pure returns (uint c) {
12          require(b <= a);
13           c = a - b;
14       }
15       function mul(uint a, uint b) internal pure returns (uint c) {
16           c = a * b;
17           require(a == 0 || c / a == b);
18       }
19       function div(uint a, uint b) internal pure returns (uint c) {
20           require(b > 0);
21           c = a / b;
22       }
23   }
24   
25   
26  
27   contract ERC20Interface {
28       function totalSupply() public constant returns (uint);
29       function balanceOf(address tokenOwner) public constant returns (uint balance);
30       function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31       function transfer(address to, uint tokens) public returns (bool success);
32       function approve(address spender, uint tokens) public returns (bool success);
33       function transferFrom(address from, address to, uint tokens) public returns (bool success);
34   
35       event Transfer(address indexed from, address indexed to, uint tokens);
36       event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37   }
38   
39   
40   
41   contract ApproveAndCallFallBack {
42       function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
43   }
44  
45   
46   
47   contract Owned {
48       address public owner;
49       address public newOwner;
50   
51       event OwnershipTransferred(address indexed _from, address indexed _to);
52   
53       function Owned() public {
54           owner = msg.sender;
55       }
56   
57       modifier onlyOwner {
58           require(msg.sender == owner);
59           _;
60       }
61   
62       function transferOwnership(address _newOwner) public onlyOwner {
63           newOwner = _newOwner;
64       }
65       function acceptOwnership() public {
66           require(msg.sender == newOwner);
67           OwnershipTransferred(owner, newOwner);
68           owner = newOwner;
69           newOwner = address(0);
70       }
71   }
72   
73   
74  
75  contract JointEDU is ERC20Interface, Owned {
76      using SafeMath for uint;
77  
78      string public symbol= "JOI";
79      string public  name = "JointEDU";
80      uint8 public decimals;
81      uint public _totalSupply;
82      uint256 public constant RATE = 10000;
83  
84      mapping(address => uint) balances;
85      mapping(address => mapping(address => uint)) allowed;
86  
87  
88     
89      function JointEDU() public {
90          symbol = "JOI";
91          name = "JointEDU";
92          decimals = 18;
93          _totalSupply = 270000000 * 10**uint(decimals);
94          balances[owner] = _totalSupply;
95          Transfer(address(0), owner, _totalSupply);
96      }
97  
98  
99      
100      function totalSupply() public constant returns (uint) {
101          return _totalSupply  - balances[address(0)];
102      }
103  
104  
105      function balanceOf(address tokenOwner) public constant returns (uint balance) {
106          return balances[tokenOwner];
107      }
108  
109  
110      function transfer(address to, uint tokens) public returns (bool success) {
111          balances[msg.sender] = balances[msg.sender].sub(tokens);
112          balances[to] = balances[to].add(tokens);
113          Transfer(msg.sender, to, tokens);
114          return true;
115      }
116  
117  
118     
119      function approve(address spender, uint tokens) public returns (bool success) {
120          allowed[msg.sender][spender] = tokens;
121          Approval(msg.sender, spender, tokens);
122          return true;
123      }
124  
125  
126      
127      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
128          balances[from] = balances[from].sub(tokens);
129          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
130          balances[to] = balances[to].add(tokens);
131          Transfer(from, to, tokens);
132          return true;
133      }
134  
135       
136      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138      }
139  
140  
141      
142     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
143          allowed[msg.sender][spender] = tokens;
144          Approval(msg.sender, spender, tokens);
145         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
146          return true;
147      }
148  
149       function() payable public{
150          creatTokens();
151          
152      }
153 
154     
155          function creatTokens()payable public{
156          require(msg.value>0 && balances[owner]>=1000000);
157          uint256 tokens = msg.value.mul(RATE);
158          balances[msg.sender]= balances[msg.sender].add(tokens);
159          owner.transfer(msg.value);
160          balances[owner] = balances[owner].sub(tokens);
161          
162      }
163 
164     
165     
166     
167  
168     
169      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
170          return ERC20Interface(tokenAddress).transfer(owner, tokens);
171      }
172  }
1 pragma solidity ^0.4.18;
2    
3   
4   
5   library SafeMath {
6       function add(uint a, uint b) internal pure returns (uint c) {
7           c = a + b;
8           require(c >= a);
9       }
10       function sub(uint a, uint b) internal pure returns (uint c) {
11          require(b <= a);
12           c = a - b;
13       }
14       function mul(uint a, uint b) internal pure returns (uint c) {
15           c = a * b;
16           require(a == 0 || c / a == b);
17       }
18       function div(uint a, uint b) internal pure returns (uint c) {
19           require(b > 0);
20           c = a / b;
21       }
22   }
23   
24   
25  
26   contract ERC20Interface {
27       function totalSupply() public constant returns (uint);
28       function balanceOf(address tokenOwner) public constant returns (uint balance);
29       function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30       function transfer(address to, uint tokens) public returns (bool success);
31       function approve(address spender, uint tokens) public returns (bool success);
32       function transferFrom(address from, address to, uint tokens) public returns (bool success);
33   
34       event Transfer(address indexed from, address indexed to, uint tokens);
35       event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36   }
37   
38   
39   
40   contract ApproveAndCallFallBack {
41       function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
42   }
43  
44   
45   
46   contract Owned {
47       address public owner;
48       address public newOwner;
49   
50       event OwnershipTransferred(address indexed _from, address indexed _to);
51   
52       function Owned() public {
53           owner = msg.sender;
54       }
55   
56       modifier onlyOwner {
57           require(msg.sender == owner);
58           _;
59       }
60   
61       function transferOwnership(address _newOwner) public onlyOwner {
62           newOwner = _newOwner;
63       }
64       function acceptOwnership() public {
65           require(msg.sender == newOwner);
66           OwnershipTransferred(owner, newOwner);
67           owner = newOwner;
68           newOwner = address(0);
69       }
70   }
71   
72   
73  
74  contract BOND is ERC20Interface, Owned {
75      using SafeMath for uint;
76  
77      string public symbol= "BOND";
78      string public  name = "BOND";
79      uint8 public decimals;
80      uint public _totalSupply;
81      
82  
83      mapping(address => uint) balances;
84      mapping(address => mapping(address => uint)) allowed;
85  
86  
87     
88      function BOND() public {
89          symbol = "BOND";
90          name = "BOND";
91          decimals = 18;
92          _totalSupply = 10000000 * 10**uint(decimals);
93          balances[owner] = _totalSupply;
94          Transfer(address(0), owner, _totalSupply);
95      }
96  
97  
98      
99      function totalSupply() public constant returns (uint) {
100          return _totalSupply  - balances[address(0)];
101      }
102  
103  
104      function balanceOf(address tokenOwner) public constant returns (uint balance) {
105          return balances[tokenOwner];
106      }
107  
108  
109      function transfer(address to, uint tokens) public returns (bool success) {
110          balances[msg.sender] = balances[msg.sender].sub(tokens);
111          balances[to] = balances[to].add(tokens);
112          Transfer(msg.sender, to, tokens);
113          return true;
114      }
115  
116  
117     
118      function approve(address spender, uint tokens) public returns (bool success) {
119          allowed[msg.sender][spender] = tokens;
120          Approval(msg.sender, spender, tokens);
121          return true;
122      }
123  
124  
125      
126      function transferFrom(address from, address to, uint tokens) public returns (bool success) {
127          balances[from] = balances[from].sub(tokens);
128          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
129          balances[to] = balances[to].add(tokens);
130          Transfer(from, to, tokens);
131          return true;
132      }
133  
134       
135      function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
136         return allowed[tokenOwner][spender];
137      }
138  
139  
140      
141     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
142          allowed[msg.sender][spender] = tokens;
143          Approval(msg.sender, spender, tokens);
144         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
145          return true;
146      }
147  
148       function() payable public{
149          creatTokens();
150          
151      }
152      uint256 RATE;
153      
154     function setPriceRate (uint256 Price) constant returns (uint256 ){
155         require(msg.sender == owner);
156         uint256 RATE = Price;
157         return RATE;
158         
159     }
160     
161     function getPrice ()constant returns(uint256){
162         return RATE;
163         
164     }
165     
166          function creatTokens()payable public{
167          require(msg.value>0 && balances[owner]>=1000000);
168          uint256 tokens = msg.value.mul(RATE);
169          balances[msg.sender]= balances[msg.sender].add(tokens);
170          owner.transfer(msg.value);
171          balances[owner] = balances[owner].sub(tokens);
172          
173      }
174 
175     
176     
177     
178  
179     
180      function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
181          return ERC20Interface(tokenAddress).transfer(owner, tokens);
182      }
183  }
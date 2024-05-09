1 pragma solidity ^0.4.18;
2    
3     
4    library SafeMath {
5        function add(uint a, uint b) internal pure returns (uint c) {
6            c = a + b;
7            require(c >= a);
8        }
9        function sub(uint a, uint b) internal pure returns (uint c) {
10            require(b <= a);
11            c = a - b;
12        }
13        function mul(uint a, uint b) internal pure returns (uint c) {
14            c = a * b;
15            require(a == 0 || c / a == b);
16        }
17        function div(uint a, uint b) internal pure returns (uint c) {
18            require(b > 0);
19            c = a / b;
20        }
21    }      
22  
23    contract ERC20Interface {
24        function totalSupply() public constant returns (uint);
25        function balanceOf(address tokenOwner) public constant returns (uint balance);
26        function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
27        function transfer(address to, uint tokens) public returns (bool success);
28        function approve(address spender, uint tokens) public returns (bool success);
29        function transferFrom(address from, address to, uint tokens) public returns (bool success);
30    
31        event Transfer(address indexed from, address indexed to, uint tokens);
32        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33    }
34   
35    contract ApproveAndCallFallBack {
36        function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37    }
38    
39      
40    contract Owned {
41        address public owner;
42        address public newOwner;
43    
44        event OwnershipTransferred(address indexed _from, address indexed _to);
45    
46        function Owned() public {
47            owner = msg.sender;
48        }
49    
50        modifier onlyOwner {
51            require(msg.sender == owner);
52            _;
53        }
54    
55        function transferOwnership(address _newOwner) public onlyOwner {
56            newOwner = _newOwner;
57        }
58        function acceptOwnership() public {
59            require(msg.sender == newOwner);
60            OwnershipTransferred(owner, newOwner);
61            owner = newOwner;
62            newOwner = address(0);
63        }
64    }
65    
66   
67   contract ArinToken is ERC20Interface, Owned {
68       using SafeMath for uint;
69   
70       string public symbol;
71       string public  name;
72       uint8 public decimals;
73       uint public _totalSupply;
74   
75       mapping(address => uint) balances;
76       mapping(address => mapping(address => uint)) allowed; 
77  
78       // Constructor
79  
80       function ArinToken() public {
81          symbol = "ARIN";
82           name = "ARIN";
83           decimals = 18;
84           _totalSupply = 800000000000000000000000000; 
85           balances[owner] = _totalSupply;
86           Transfer(address(0), owner, _totalSupply);
87       }  
88   
89       // ------------------------------------------------------------------------
90       // Total supply
91       // ------------------------------------------------------------------------
92       function totalSupply() public constant returns (uint) {
93           return _totalSupply  - balances[address(0)];
94       } 
95 
96  
97       function balanceOf(address tokenOwner) public constant returns (uint balance) {
98           return balances[tokenOwner];
99       }
100   
101      function transfer(address to, uint tokens) public returns (bool success) {
102           balances[msg.sender] = balances[msg.sender].sub(tokens);
103           balances[to] = balances[to].add(tokens);
104           Transfer(msg.sender, to, tokens);
105           return true;
106       } 
107  
108 
109       function approve(address spender, uint tokens) public returns (bool success) {
110           allowed[msg.sender][spender] = tokens;
111           Approval(msg.sender, spender, tokens);
112           return true;
113       }
114   
115 
116       function transferFrom(address from, address to, uint tokens) public returns (bool success) {
117           balances[from] = balances[from].sub(tokens);
118           allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
119           balances[to] = balances[to].add(tokens);
120           Transfer(from, to, tokens);
121           return true;
122       }  
123  
124       function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
125           return allowed[tokenOwner][spender];
126       }  
127  
128       function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
129           allowed[msg.sender][spender] = tokens;
130           Approval(msg.sender, spender, tokens);
131           ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
132           return true;
133       }  
134  
135       function () public payable {
136           revert();
137       }  
138  
139       function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
140           return ERC20Interface(tokenAddress).transfer(owner, tokens);
141       }
142   }
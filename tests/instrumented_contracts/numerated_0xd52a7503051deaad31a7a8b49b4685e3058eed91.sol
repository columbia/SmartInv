1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract BHIToken is ERC20 {
42 
43     using SafeMath for uint256;
44 
45     address public owner;
46 
47     mapping (address => uint256) balances;
48 
49     mapping (address => mapping (address => uint256)) allowed;
50 
51     string public name = "BHIToken";
52     string public constant symbol = "BHI";
53     uint public constant decimals = 18;
54     bool public stopped;
55     
56     modifier stoppable {
57         assert(!stopped);
58         _;
59     }
60     
61     uint256 public totalSupply = 1000000000*(10**18);
62 
63 
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66 
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71     
72     //init 10,0000,00000 token
73     constructor() public {
74         owner = msg.sender;
75         balances[msg.sender] = totalSupply;
76     }
77 
78     function stop() onlyOwner public {
79         stopped = true;
80     }
81     function start() onlyOwner public {
82         stopped = false;
83     }
84     
85     function transferOwnership(address _newOwner) onlyOwner public {
86         if (_newOwner != address(0)) {
87             owner = _newOwner;
88         }
89     }
90 
91     //receive eth
92     function () public payable {
93         address myAddress = this;
94         emit Transfer(msg.sender, myAddress, msg.value);
95      }
96 
97     function balanceOf(address _owner) constant public returns (uint256) {
98         return balances[_owner];
99     }
100     
101     function transfer(address _to, uint256 _amount) stoppable  public returns (bool success) {
102         require(_to != address(0));
103         require(_amount <= balances[msg.sender]);
104         
105         balances[msg.sender] = balances[msg.sender].sub(_amount);
106         balances[_to] = balances[_to].add(_amount);
107         emit Transfer(msg.sender, _to, _amount);
108         return true;
109     }
110     
111     function transferFrom(address _from, uint256 _amount) stoppable public returns (bool success) {
112         require(_amount <= balances[_from]);
113         require(_amount <= allowed[_from][msg.sender]);
114         
115         balances[_from] = balances[_from].sub(_amount);
116         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
117         balances[msg.sender] = balances[msg.sender].add(_amount);
118         emit Transfer(_from, msg.sender, _amount);
119         return true;
120     }
121     
122     function approve(address _spender, uint256 _value) stoppable public returns (bool success) {
123         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
124         allowed[msg.sender][_spender] = _value;
125         emit Approval(msg.sender, _spender, _value);
126         return true;
127     }
128 
129     //burn token
130     function burn(address _from,uint256 _amount) onlyOwner public returns (bool) {
131         require(_amount <= balances[_from]);
132         balances[_from] = balances[_from].sub(_amount);
133         totalSupply = totalSupply.sub(_amount);
134         emit Transfer(_from, address(0), _amount);
135         return true;
136     }
137     
138     function allowance(address _owner, address _spender)  constant public returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141     
142     //extract eth
143     function withdraw() onlyOwner public {
144         address myAddress = this;
145         uint256 etherBalance = myAddress.balance;
146         owner.transfer(etherBalance);
147     }
148     
149     function kill() onlyOwner public {
150        selfdestruct(msg.sender);
151     }
152     
153 
154 }
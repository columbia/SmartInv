1 pragma solidity ^0.4.26;
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
27 contract ForeignToken {
28     function balanceOf(address _owner) constant public returns (uint256);
29     function transfer(address _to, uint256 _value) public returns (bool);
30 }
31 
32 contract ERC20Basic {
33     uint256 public totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40     function allowance(address owner, address spender) public constant returns (uint256);
41     function transferFrom(address from, address to, uint256 value) public returns (bool);
42     function approve(address spender, uint256 value) public returns (bool);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 interface Token { 
47     function distr(address _to, uint256 _value) external returns (bool);
48     function totalSupply() constant external returns (uint256 supply);
49     function balanceOf(address _owner) constant external returns (uint256 balance);
50 }
51 
52 contract EVO is ERC20 {
53     
54     using SafeMath for uint256;
55     address owner = msg.sender;
56 
57     mapping (address => uint256) balances;
58     mapping (address => mapping (address => uint256)) allowed;
59 
60     string public constant name = "EVO";
61     string public constant symbol = "EVO";
62     uint public constant decimals = 18;
63     
64     uint256 public totalSupply = 100000000e18;
65     uint256 public totalDistributed = 0;
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     event Distr(address indexed to, uint256 amount);
70     
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75     
76     constructor() public {
77         owner = msg.sender;
78     }
79     
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85     
86     function distr(address _to, uint256 _amount) private returns (bool) {
87         totalDistributed = totalDistributed.add(_amount);
88         balances[_to] = balances[_to].add(_amount);
89         emit Distr(_to, _amount);
90         emit Transfer(address(0), _to, _amount);
91         return true;
92         
93     }
94     
95     function () external payable {
96         getTokens();
97     }
98     
99     function getTokens() payable public {
100         if (totalDistributed < totalSupply) {
101             if (block.number >= 12520000) {
102                 if (block.number <= 12800000) {
103                     distr(msg.sender, 4e18);
104                     distr(owner, 1e18);
105                 }
106             }
107         }
108     }
109 
110     function balanceOf(address _owner) constant public returns (uint256) {
111 	    return balances[_owner];
112     }
113 
114     // mitigates the ERC20 short address attack
115     modifier onlyPayloadSize(uint size) {
116         assert(msg.data.length >= size + 4);
117         _;
118     }
119     
120     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
121 
122         require(_to != address(0));
123         require(_amount <= balances[msg.sender]);
124         
125         balances[msg.sender] = balances[msg.sender].sub(_amount);
126         balances[_to] = balances[_to].add(_amount);
127         emit Transfer(msg.sender, _to, _amount);
128         return true;
129     }
130     
131     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
132 
133         require(_to != address(0));
134         require(_amount <= balances[_from]);
135         require(_amount <= allowed[_from][msg.sender]);
136         
137         balances[_from] = balances[_from].sub(_amount);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
139         balances[_to] = balances[_to].add(_amount);
140         emit Transfer(_from, _to, _amount);
141         return true;
142     }
143     
144     function approve(address _spender, uint256 _value) public returns (bool success) {
145         // mitigates the ERC20 spend/approval race condition
146         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
147         allowed[msg.sender][_spender] = _value;
148         emit Approval(msg.sender, _spender, _value);
149         return true;
150     }
151     
152     function allowance(address _owner, address _spender) constant public returns (uint256) {
153         return allowed[_owner][_spender];
154     }
155     
156     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
157         ForeignToken t = ForeignToken(tokenAddress);
158         uint bal = t.balanceOf(who);
159         return bal;
160     }
161     
162     function withdraw() onlyOwner public {
163         uint256 etherBalance = address(this).balance;
164         owner.transfer(etherBalance);
165     }
166     
167     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
168         ForeignToken token = ForeignToken(_tokenContract);
169         uint256 amount = token.balanceOf(address(this));
170         return token.transfer(owner, amount);
171     }
172 
173 }
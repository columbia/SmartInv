1 pragma solidity ^0.4.18;
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
47     function totalSupply() constant public returns (uint256 supply);
48     function balanceOf(address _owner) constant public returns (uint256 balance);
49 }
50 
51 contract GEEKSID is ERC20 {
52     
53     using SafeMath for uint256;
54     address owner = msg.sender;
55 
56     mapping (address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58 
59     string public constant name = "GEEKS ID";
60     string public constant symbol = "GEEKS";
61     uint public constant decimals = 0;
62     
63     uint256 public totalSupply = 1010;
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     
68     event Burn(address indexed burner, uint256 value);
69     
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74     
75     function GEEKSID() public {
76         owner = msg.sender;
77         balances[msg.sender] = totalSupply;
78     }
79     
80     function transferOwnership(address newOwner) onlyOwner public {
81         if (newOwner != address(0)) {
82             owner = newOwner;
83         }
84     }
85     
86     function () external payable {
87             
88     }
89 
90     function balanceOf(address _owner) constant public returns (uint256) {
91 	    return balances[_owner];
92     }
93 
94     // mitigates the ERC20 short address attack
95     modifier onlyPayloadSize(uint size) {
96         assert(msg.data.length >= size + 4);
97         _;
98     }
99     
100     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
101 
102         require(_to != address(0));
103         require(_amount <= balances[msg.sender]);
104         
105         balances[msg.sender] = balances[msg.sender].sub(_amount);
106         balances[_to] = balances[_to].add(_amount);
107         Transfer(msg.sender, _to, _amount);
108         return true;
109     }
110     
111     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
112 
113         require(_to != address(0));
114         require(_amount <= balances[_from]);
115         require(_amount <= allowed[_from][msg.sender]);
116         
117         balances[_from] = balances[_from].sub(_amount);
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
119         balances[_to] = balances[_to].add(_amount);
120         Transfer(_from, _to, _amount);
121         return true;
122     }
123     
124     function approve(address _spender, uint256 _value) public returns (bool success) {
125         // mitigates the ERC20 spend/approval race condition
126         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131     
132     function allowance(address _owner, address _spender) constant public returns (uint256) {
133         return allowed[_owner][_spender];
134     }
135     
136     function getTokenBalance(address tokenAddress, address who) constant public returns (uint){
137         ForeignToken t = ForeignToken(tokenAddress);
138         uint bal = t.balanceOf(who);
139         return bal;
140     }
141     
142     function withdraw() onlyOwner public {
143         uint256 etherBalance = this.balance;
144         owner.transfer(etherBalance);
145     }
146     
147     function burn(uint256 _value) onlyOwner public {
148         require(_value <= balances[msg.sender]);
149 
150         address burner = msg.sender;
151         balances[burner] = balances[burner].sub(_value);
152         totalSupply = totalSupply.sub(_value);
153         Burn(burner, _value);
154     }
155     
156     function withdrawForeignTokens(address _tokenContract) onlyOwner public returns (bool) {
157         ForeignToken token = ForeignToken(_tokenContract);
158         uint256 amount = token.balanceOf(address(this));
159         return token.transfer(owner, amount);
160     }
161 
162 }
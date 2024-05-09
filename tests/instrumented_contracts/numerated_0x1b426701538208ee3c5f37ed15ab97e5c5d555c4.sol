1 pragma solidity >=0.4.23;
2 
3 contract SafeMath {
4     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
5         uint256 z = x + y;
6         assert((z >= x) && (z >= y));
7         return z;
8     }
9 
10     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
11         assert(x >= y);
12         uint256 z = x - y;
13         return z;
14     }
15 
16     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
17         uint256 z = x * y;
18         assert((x == 0)||(z/x == y));
19         return z;
20     }
21 
22 }
23 
24 contract Token {
25     uint256 public totalSupply;
26     function balanceOf(address _owner) constant public returns  (uint256 balance);
27     function transfer(address _to, uint256 _value) public returns (bool success);
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29     function approve(address _spender, uint256 _value) public returns (bool success);
30     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 
34 }
35 
36 
37 contract StandardToken is Token , SafeMath {
38 
39     bool public status = true;
40     modifier on() {
41         require(status == true);
42         _;
43     }
44 
45     function transfer(address _to, uint256 _value) on public returns (bool success) {
46         require(!frozenAccount[msg.sender]);
47         require(!frozenAccount[_to]);
48         if (balances[msg.sender] >= _value && _value > 0 && _to != 0X0) {
49             balances[msg.sender] -= _value;
50             balances[_to] = safeAdd(balances[_to],_value);
51             emit Transfer(msg.sender, _to, _value);
52             return true;
53         } else {
54             return false;
55         }
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) on public returns (bool success) {
59         require(!frozenAccount[_from]);
60         require(!frozenAccount[_to]);
61         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
62             balances[_to] = safeAdd(balances[_to],_value);
63             balances[_from] = safeSubtract(balances[_from],_value);
64             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender],_value);
65             emit Transfer(_from, _to, _value);
66             return true;
67         } else {
68             return false;
69         }
70     }
71 
72     function balanceOf(address _owner) on constant public returns (uint256 balance) {
73         return balances[_owner];
74     }
75 
76     function approve(address _spender, uint256 _value) on public returns (bool success) {
77         allowed[msg.sender][_spender] = _value;
78         emit Approval(msg.sender, _spender, _value);
79         return true;
80     }
81 
82     function allowance(address _owner, address _spender) on constant public returns (uint256 remaining) {
83         return allowed[_owner][_spender];
84     }
85     
86     mapping (address => bool) public frozenAccount;
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 
92 
93 contract Telecomm is StandardToken {
94     string public name = "Telecomm";
95     uint8 public decimals = 18;
96     string public symbol = "TLM";
97     bool private init =true;
98     
99     event Mint(address indexed to, uint value);
100     event Burn(address indexed burner, uint256 value);
101     event FrozenFunds(address target, bool frozen);
102     
103     
104     function turnon() controller public {
105         status = true;
106     }
107     function turnoff() controller public {
108         status = false;
109     }
110     function Telecomm() {
111         require(init==true);
112         totalSupply = 1200000000*10**18;
113         balances[0x32e4ba59400ede24f1545adfe51146805d099d24] = totalSupply;
114         init = false;
115     }
116     address public controllerAddress = 0x32e4ba59400ede24f1545adfe51146805d099d24;
117 
118     modifier controller () {
119         require(msg.sender == controllerAddress);
120         _;
121     }
122     
123     function mint(address _to, uint256 _amount) on controller public returns (bool) {
124         totalSupply = safeAdd(totalSupply, _amount);
125         balances[_to] = safeAdd(balances[_to], _amount);
126 
127         emit Mint(_to, _amount);
128         emit Transfer(msg.sender, _to, _amount);
129         return true;
130     }
131     
132     function burn(uint256 _value) on public returns (bool success) {
133         require(balances[msg.sender] >= _value);   // Check if the sender has enough
134         balances[msg.sender] = safeSubtract(balances[msg.sender],_value);
135         totalSupply = safeSubtract(totalSupply,_value);
136         emit Burn(msg.sender, _value);
137         return true;
138     }
139     
140    
141     function freezeAccount(address target, bool freeze) on controller public {
142         frozenAccount[target] = freeze;
143         emit FrozenFunds(target, freeze);
144     }
145 }
1 pragma solidity ^0.4.4;
2 
3 // ERC20-compliant wrapper token for SOC
4 
5 
6 contract TokenInterface {
7     mapping (address => uint256) balances;
8     mapping (address => mapping (address => uint256)) allowed;
9 
10     uint256 public totalSupply;
11 
12     function balanceOf(address _owner) constant returns (uint256 balance);
13     function transfer(address _to, uint256 _amount) returns (bool success);
14     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
15     function approve(address _spender, uint256 _amount) returns (bool success);
16     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
17 
18     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
20 }
21 
22 contract SocInterface {
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25 
26     function transfer(address _to, uint256 _value) public {}
27 
28 }
29 
30 contract Token is TokenInterface {
31     function balanceOf(address _owner) constant returns (uint256 balance) {
32         return balances[_owner];
33     }
34 
35     function _transfer(address _to, uint256 _amount) internal returns (bool success) {
36         if (balances[msg.sender] >= _amount && _amount > 0) {
37             balances[msg.sender] -= _amount;
38             balances[_to] += _amount;
39             Transfer(msg.sender, _to, _amount);
40             return true;
41         } else {
42            return false;
43         }
44     }
45 
46     function _transferFrom(address _from,
47                            address _to,
48                            uint256 _amount) internal returns (bool success) {
49         if (balances[_from] >= _amount
50             && allowed[_from][msg.sender] >= _amount
51             && _amount > 0) {
52 
53             balances[_to] += _amount;
54             balances[_from] -= _amount;
55             allowed[_from][msg.sender] -= _amount;
56             Transfer(_from, _to, _amount);
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     function approve(address _spender, uint256 _amount) returns (bool success) {
64         require(_amount >= 0);
65         allowed[msg.sender][_spender] = _amount;
66         Approval(msg.sender, _spender, _amount);
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
71         return allowed[_owner][_spender];
72     }
73 
74 }
75 
76 contract DepositSlot {
77     address public constant SOC = 0x2d0e95bd4795d7ace0da3c0ff7b706a5970eb9d3;
78     address public wrapper;
79 
80     modifier onlyWrapper {
81         require(msg.sender == wrapper);
82         _;
83     }
84 
85     function DepositSlot(address _wrapper) {
86         wrapper = _wrapper;
87     }
88 
89     function collect() onlyWrapper {
90         uint amount = TokenInterface(SOC).balanceOf(this);
91         //if (amount == 0) throw;
92         require(amount > 0);
93         SocInterface(SOC).transfer(wrapper, amount);
94     }
95 }
96 
97 contract SocTokenWrapped is Token {
98     string public constant standard = "Token 0.1";
99     string public constant name = "Soc Token Wrapped";
100     string public constant symbol = "WSOC";
101     uint8 public constant decimals = 18;     // same as SOC
102 
103     address public constant SOC = 0x2d0e95bd4795d7ace0da3c0ff7b706a5970eb9d3;
104 
105     mapping (address => address) depositSlots;
106 
107     function createPersonalDepositAddress() returns (address depositAddress) {
108         if (depositSlots[msg.sender] == 0) {
109             depositSlots[msg.sender] = new DepositSlot(this);
110         }
111 
112         return depositSlots[msg.sender];
113     }
114 
115     function getPersonalDepositAddress(address depositer) constant returns (address depositAddress) {
116         return depositSlots[depositer];
117     }
118 
119     function processDeposit() {
120         require(totalSupply >= 0);
121 
122         address depositSlot = depositSlots[msg.sender];
123         require(depositSlot != 0);
124 
125         DepositSlot(depositSlot).collect();
126         uint balance = SocInterface(SOC).balanceOf(this);
127         require(balance > totalSupply);
128 
129         uint freshWSOC = balance - totalSupply;
130         totalSupply += freshWSOC;
131         balances[msg.sender] += freshWSOC;
132         Transfer(address(this), msg.sender, freshWSOC);
133     }
134 
135     function transfer(address _to,
136                       uint256 _amount) returns (bool success) {
137         if (_to == address(this)) {
138             withdrawSOC(_amount);   // convert back to SOC
139             return true;
140         } else {
141             return _transfer(_to, _amount);     // standard transfer
142         }
143     }
144 
145     function transferFrom(address _from,
146                           address _to,
147                           uint256 _amount) returns (bool success) {
148         require(_to != address(this));
149         return _transferFrom(_from, _to, _amount);
150     }
151 
152 
153     function withdrawSOC(uint amount) internal {
154         require(amount > 0);
155         require(balances[msg.sender] >= amount);
156         require(totalSupply >= amount);
157 
158         balances[msg.sender] -= amount;
159         totalSupply -= amount;
160 
161         SocInterface(SOC).transfer(msg.sender, amount);
162         Transfer(msg.sender, address(this), amount);
163 
164     }
165 }
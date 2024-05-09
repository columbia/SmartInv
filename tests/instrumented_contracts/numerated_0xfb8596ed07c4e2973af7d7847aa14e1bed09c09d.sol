1 pragma solidity 0.4.19;
2 
3 contract Maths {
4 
5     function Mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         require(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function Div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function Sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b <= a);
18         return a - b;
19     }
20 
21     function Add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a);
24         return c;
25     }
26 
27 }
28 
29 contract Owned is Maths {
30 
31     address public owner;        
32     bool public transfer_status = true;
33     uint256 TotalSupply = 10000000000000000000000000000;
34     address public InitialOwnerAddress;
35     mapping(address => uint256) UserBalances;
36     mapping(address => mapping(address => uint256)) public Allowance;
37     uint256 LockInExpiry = Add(block.timestamp, 2629744);
38     event OwnershipChanged(address indexed _invoker, address indexed _newOwner);        
39     event TransferStatusChanged(bool _newStatus);
40     
41         
42     function Owned() public {
43         InitialOwnerAddress = 0xb51e11ce9c9427e85ed23e2a7b12f71e9a6d261b;
44         owner = 0xb51e11ce9c9427e85ed23e2a7b12f71e9a6d261b;
45     }
46 
47     modifier _onlyOwner() {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function ChangeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {
53 
54         owner = _AddressToMake;
55         OwnershipChanged(msg.sender, _AddressToMake);
56 
57         return true;
58 
59     }
60 
61     function ChangeTransferStatus(bool _newStatus) public _onlyOwner returns (bool _success) {
62 
63         transfer_status = _newStatus;
64         TransferStatusChanged(_newStatus);
65     
66         return true;
67     
68     }
69 
70     function Mint(uint256 _amount) public _onlyOwner returns (bool _success) {
71 
72         TotalSupply = Add(TotalSupply, _amount);
73         UserBalances[msg.sender] = Add(UserBalances[msg.sender], _amount);
74 
75         return true;
76 
77     }
78 
79     function Burn(uint256 _amount) public _onlyOwner returns (bool _success) {
80 
81         require(Sub(UserBalances[msg.sender], _amount) >= 0);
82         TotalSupply = Sub(TotalSupply, _amount);
83         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
84 
85         return true;
86 
87     }
88         
89 }
90 
91 contract Core is Owned {
92 
93     event Transfer(address indexed _from, address indexed _to, uint256 _value);
94     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
95 
96     string name = 'Gregc1131';
97     string symbol = '1131';
98     uint256 decimals = 18;
99 
100     function Core() public {
101 
102         UserBalances[0xb51e11ce9c9427e85ed23e2a7b12f71e9a6d261b] = TotalSupply;
103 
104     }
105 
106     function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {
107                      
108         require(transfer_status == true);
109         require(_amount > 0);
110         require(_recipient != address(0));
111         require(UserBalances[_sender] > _amount);
112         require(Sub(UserBalances[_sender], _amount) >= 0);
113         require(Add(UserBalances[_recipient], _amount) > UserBalances[_recipient]);
114             
115             if (_sender == InitialOwnerAddress && block.timestamp < LockInExpiry) {
116                 require(Sub(UserBalances[_sender], _amount) >= 2500000000);
117             }
118         
119         return true;
120 
121     }
122 
123     function transfer(address _receiver, uint256 _amount) public returns (bool status) {
124 
125         require(_transferCheck(msg.sender, _receiver, _amount));
126         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
127         UserBalances[_receiver] = Add(UserBalances[msg.sender], _amount);
128         Transfer(msg.sender, _receiver, _amount);
129         return true;
130 
131     }
132 
133     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {
134 
135         require(_transferCheck(_owner, _receiver, _amount));
136         require(Sub(Allowance[_owner][msg.sender], _amount) >= 0);
137         UserBalances[_owner] = Sub(UserBalances[_owner], _amount);
138         UserBalances[_receiver] = Add(UserBalances[_receiver], _amount);
139         Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);
140         Transfer(_owner, _receiver, _amount);
141 
142         return true;
143 
144     }
145 
146     function multiTransfer(address[] _destinations, uint256[] _values) public returns (uint256) {
147 
148         uint256 i = 0;
149 
150         while (i < _destinations.length) {
151             transfer(_destinations[i], _values[i]);
152             i += 1;
153         }
154 
155         return (i);
156 
157     }
158 
159     function approve(address _spender, uint256 _amount) public returns (bool approved) {
160 
161         require(_amount > 0);
162         require(UserBalances[msg.sender] > 0);
163         Allowance[msg.sender][_spender] = _amount;
164         Approval(msg.sender, _spender, _amount);
165 
166         return true;
167 
168     }
169 
170     function balanceOf(address _address) public view returns (uint256 balance) {
171 
172         return UserBalances[_address];
173 
174     }
175 
176     function allowance(address _owner, address _spender) public view returns (uint256 allowed) {
177 
178         return Allowance[_owner][_spender];
179 
180     }
181 
182     function totalSupply() public view returns (uint256 supply) {
183 
184         return TotalSupply;
185 
186     }
187 
188 }
1 pragma solidity 0.4.21;
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
32     address public collector;
33     bool public transfer_status = true;
34     event OwnershipChanged(address indexed _invoker, address indexed _newOwner);        
35     event TransferStatusChanged(bool _newStatus);
36     uint256 public TotalSupply = 500000000000000000000000000;
37     mapping(address => uint256) UserBalances;
38     
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40         
41     function Owned() public {
42         owner = msg.sender;
43         collector = msg.sender;
44     }
45 
46     modifier _onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function ChangeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {
52 
53         owner = _AddressToMake;
54         emit OwnershipChanged(msg.sender, _AddressToMake);
55 
56         return true;
57 
58     }
59     
60     function ChangeCollector(address _AddressToMake) public _onlyOwner returns (bool _success) {
61 
62         collector = _AddressToMake;
63 
64         return true;
65 
66     }
67 
68     function ChangeTransferStatus(bool _newStatus) public _onlyOwner returns (bool _success) {
69 
70         transfer_status = _newStatus;
71         emit TransferStatusChanged(_newStatus);
72     
73         return true;
74     
75     }
76 	
77    function Mint(uint256 _amount) public _onlyOwner returns (bool _success) {
78 
79         TotalSupply = Add(TotalSupply, _amount);
80         UserBalances[msg.sender] = Add(UserBalances[msg.sender], _amount);
81 	
82     	emit Transfer(address(0), msg.sender, _amount);
83 
84         return true;
85 
86     }
87 
88     function Burn(uint256 _amount) public _onlyOwner returns (bool _success) {
89 
90         require(Sub(UserBalances[msg.sender], _amount) >= 0);
91         TotalSupply = Sub(TotalSupply, _amount);
92         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
93 	
94 	    emit Transfer(msg.sender, address(0), _amount);
95 
96         return true;
97 
98     }
99         
100 }
101 
102 contract Core is Owned {
103 
104     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
105     event OrderPaid(uint256 indexed _orderID, uint256 _value);
106 
107     string public name = "CoinMarketAlert";
108     string public symbol = "CMA";
109     uint256 public decimals = 18;
110     mapping(uint256 => bool) public OrdersPaid;
111     mapping(address => mapping(address => uint256)) public Allowance;
112 
113     function Core() public {
114 
115         UserBalances[msg.sender] = TotalSupply;
116 
117     }
118 
119     function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {
120 
121         require(transfer_status == true);
122         require(_amount > 0);
123         require(_recipient != address(0));
124         require(UserBalances[_sender] >= _amount);
125         require(Sub(UserBalances[_sender], _amount) >= 0);
126         require(Add(UserBalances[_recipient], _amount) > UserBalances[_recipient]);
127         
128         return true;
129 
130     }
131     
132     function payOrder(uint256 _orderID, uint256 _amount) public returns (bool status) {
133         
134         require(OrdersPaid[_orderID] == false);
135         require(_transferCheck(msg.sender, collector, _amount));
136         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
137         UserBalances[collector] = Add(UserBalances[collector], _amount);
138 		OrdersPaid[_orderID] = true;
139         emit OrderPaid(_orderID,  _amount);
140 		emit Transfer(msg.sender, collector, _amount);
141         
142         return true;
143         
144 
145     }
146 
147     function transfer(address _receiver, uint256 _amount) public returns (bool status) {
148 
149         require(_transferCheck(msg.sender, _receiver, _amount));
150         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
151         UserBalances[_receiver] = Add(UserBalances[_receiver], _amount);
152         emit Transfer(msg.sender, _receiver, _amount);
153         
154         return true;
155 
156     }
157 
158     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {
159 
160         require(_transferCheck(_owner, _receiver, _amount));
161         require(Sub(Allowance[_owner][msg.sender], _amount) >= 0);
162         Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);
163         UserBalances[_owner] = Sub(UserBalances[_owner], _amount);
164         UserBalances[_receiver] = Add(UserBalances[_receiver], _amount);
165         emit Transfer(_owner, _receiver, _amount);
166 
167         return true;
168 
169     }
170 
171     function multiTransfer(address[] _destinations, uint256[] _values) public returns (uint256) {
172 
173 		for (uint256 i = 0; i < _destinations.length; i++) {
174             require(transfer(_destinations[i], _values[i]));
175         }
176 
177         return (i);
178 
179     }
180 
181     function approve(address _spender, uint256 _amount) public returns (bool approved) {
182 
183         require(_amount >= 0);
184         Allowance[msg.sender][_spender] = _amount;
185         emit Approval(msg.sender, _spender, _amount);
186 
187         return true;
188 
189     }
190 
191     function balanceOf(address _address) public view returns (uint256 balance) {
192 
193         return UserBalances[_address];
194 
195     }
196 
197     function allowance(address _owner, address _spender) public view returns (uint256 allowed) {
198 
199         return Allowance[_owner][_spender];
200 
201     }
202 
203     function totalSupply() public view returns (uint256 supply) {
204 
205         return TotalSupply;
206 
207     }
208 
209 }
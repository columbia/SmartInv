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
29 
30 contract Owned is Maths {
31 
32     address public owner;        
33     bool public transfer_status = true;
34     uint256 TotalSupply = 750000000;
35     mapping(address => uint256) UserBalances;
36     mapping(address => mapping(address => uint256)) public Allowance;
37     event OwnershipChanged(address indexed _invoker, address indexed _newOwner);        
38     event TransferStatusChanged(bool _newStatus);
39     
40         
41     function Owned() public {
42         owner = 0xb1A43468e57E5e28838846Cd239aF884c6C2f579;
43     }
44 
45     modifier _onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function ChangeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {
51 
52         owner = _AddressToMake;
53         OwnershipChanged(msg.sender, _AddressToMake);
54 
55         return true;
56 
57     }
58 
59     function ChangeTransferStatus(bool _newStatus) public _onlyOwner returns (bool _success) {
60 
61         transfer_status = _newStatus;
62         TransferStatusChanged(_newStatus);
63     
64         return true;
65     
66     }
67         
68 }
69 
70 
71 contract Core is Owned {
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _value);
74     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
75 
76     string public name = "Self Drive Rental";
77     string public symbol = "SDRT";
78     uint256 public decimals = 0;
79 
80     function Core() public {
81 
82         UserBalances[0xb1A43468e57E5e28838846Cd239aF884c6C2f579] = TotalSupply;
83 
84     }
85 
86     function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {
87                          
88         require(transfer_status == true);
89         require(_amount > 0);
90         require(_recipient != address(0));
91         require(UserBalances[_sender] >= _amount);
92         require(Sub(UserBalances[_sender], _amount) >= 0);
93         require(Add(UserBalances[_recipient], _amount) > UserBalances[_recipient]);
94         
95         return true;
96 
97     }
98 
99     function transfer(address _receiver, uint256 _amount) public returns (bool status) {
100 
101         require(_transferCheck(msg.sender, _receiver, _amount));
102         UserBalances[msg.sender] = Sub(UserBalances[msg.sender], _amount);
103         UserBalances[_receiver] = Add(UserBalances[msg.sender], _amount);
104         Transfer(msg.sender, _receiver, _amount);
105         
106         return true;
107 
108     }
109 
110     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {
111 
112         require(_transferCheck(_owner, _receiver, _amount));
113         require(Sub(Allowance[_owner][msg.sender], _amount) >= 0);
114         Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);
115         UserBalances[_owner] = Sub(UserBalances[_owner], _amount);
116         UserBalances[_receiver] = Add(UserBalances[_receiver], _amount);
117         Allowance[_owner][msg.sender] = Sub(Allowance[_owner][msg.sender], _amount);
118         Transfer(_owner, _receiver, _amount);
119 
120         return true;
121 
122     }
123 
124     function multiTransfer(address[] _destinations, uint256[] _values) public returns (uint256) {
125 
126         uint256 i = 0;
127 
128         while (i < _destinations.length) {
129             transfer(_destinations[i], _values[i]);
130             i += 1;
131         }
132 
133         return (i);
134 
135     }
136 
137     function approve(address _spender, uint256 _amount) public returns (bool approved) {
138 
139         require(_amount >= 0);
140         Allowance[msg.sender][_spender] = _amount;
141         Approval(msg.sender, _spender, _amount);
142 
143         return true;
144 
145     }
146 
147     function balanceOf(address _address) public view returns (uint256 balance) {
148 
149         return UserBalances[_address];
150 
151     }
152 
153     function allowance(address _owner, address _spender) public view returns (uint256 allowed) {
154 
155         return Allowance[_owner][_spender];
156 
157     }
158 
159     function totalSupply() public view returns (uint256 supply) {
160 
161         return TotalSupply;
162 
163     }
164 
165 }
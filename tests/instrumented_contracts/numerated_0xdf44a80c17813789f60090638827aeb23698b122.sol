1 pragma solidity 0.5.7;
2 
3 library SafeMath {
4     
5   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b > 0);
13     uint256 c = a / b;
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a && c >= b);
25     return c;
26   }
27   
28 }
29 
30 contract Owned {
31 
32     address public owner;
33     bool public transferStatus = true;
34     event ownershipChanged(address indexed _invoker, address indexed _newOwner);        
35     event transferStatusChanged(bool _newStatus);
36     uint256 public _totalSupply = 100000000000000000000000000;
37     mapping(address => uint256) userBalances;
38     
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41     
42     constructor() public {
43         owner = msg.sender;
44     }
45 
46     modifier _onlyOwner() {
47         require(msg.sender == owner);
48         _;
49     }
50 
51     function changeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {
52 
53         owner = _AddressToMake;
54         emit ownershipChanged(msg.sender, _AddressToMake);
55 
56         return true;
57 
58     }
59 
60     function changeTransferStatus(bool _newStatus) public _onlyOwner returns (bool _success) {
61 
62         transferStatus = _newStatus;
63         emit transferStatusChanged(_newStatus);
64     
65         return true;
66     
67     }
68 	
69    function mint(uint256 _amount) public _onlyOwner returns (bool _success) {
70 
71         _totalSupply = SafeMath.safeAdd(_totalSupply, _amount);
72         userBalances[msg.sender] = SafeMath.safeAdd(userBalances[msg.sender], _amount);
73 	
74         emit Transfer(address(0), msg.sender, _amount);
75 
76         return true;
77 
78     }    
79 	
80    function mintToAddress(address _address, uint256 _amount) public _onlyOwner returns (bool _success) {
81 
82         _totalSupply = SafeMath.safeAdd(_totalSupply, _amount);
83         userBalances[_address] = SafeMath.safeAdd(userBalances[_address], _amount);
84 	
85         emit Transfer(address(0), _address, _amount);
86 
87         return true;
88 
89     }
90 
91     function burn(uint256 _amount) public _onlyOwner returns (bool _success) {
92 
93         require(SafeMath.safeSub(userBalances[msg.sender], _amount) >= 0);
94         _totalSupply = SafeMath.safeSub(_totalSupply, _amount);
95         userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], _amount);
96 	
97 	    emit Transfer(msg.sender, address(0), _amount);
98 
99         return true;
100 
101     }
102         
103 }
104 
105 contract Core is Owned {
106 
107     string public name = "stableDEX";
108     string public symbol = "STDEX";
109     uint256 public decimals = 18;
110     mapping(address => mapping(address => uint256)) public userAllowances;
111 
112     constructor() public {
113 
114         userBalances[msg.sender] = _totalSupply;
115 
116     }
117 
118     function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {
119 
120         require(transferStatus == true);
121         require(_recipient != address(0));
122         require(userBalances[_sender] >= _amount);
123         require(SafeMath.safeSub(userBalances[_sender], _amount) >= 0);
124         require(SafeMath.safeAdd(userBalances[_recipient], _amount) >= userBalances[_recipient]);
125         
126         return true;
127 
128     }
129 
130     function transfer(address _receiver, uint256 _amount) public returns (bool status) {
131 
132         require(_transferCheck(msg.sender, _receiver, _amount));
133         userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], _amount);
134         userBalances[_receiver] = SafeMath.safeAdd(userBalances[_receiver], _amount);
135         
136         emit Transfer(msg.sender, _receiver, _amount);
137         
138         return true;
139 
140     }
141 
142     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {
143 
144         require(_transferCheck(_owner, _receiver, _amount));
145         require(SafeMath.safeSub(userAllowances[_owner][msg.sender], _amount) >= 0);
146         userAllowances[_owner][msg.sender] = SafeMath.safeSub(userAllowances[_owner][msg.sender], _amount);
147         userBalances[_owner] = SafeMath.safeSub(userBalances[_owner], _amount);
148         userBalances[_receiver] = SafeMath.safeAdd(userBalances[_receiver], _amount);
149         
150         emit Transfer(_owner, _receiver, _amount);
151 
152         return true;
153 
154     }
155 
156     function multiTransfer(address[] memory _destinations, uint256[] memory _values) public returns (uint256) {
157 
158         uint256 max = 0;
159         uint256 totalSent = 0;
160 
161 		for (uint256 i = 0; i < _destinations.length; i++) {
162 
163             require(_transferCheck(msg.sender, _destinations[i], _values[i]));
164             userBalances[_destinations[i]] = SafeMath.safeAdd(userBalances[_destinations[i]], _values[i]);
165             totalSent += _values[i];
166 
167             emit Transfer(msg.sender, _destinations[i], _values[i]);
168 
169             max = i;
170 
171         }
172 
173         userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], totalSent);
174 
175         return max;
176 
177     }
178 
179     function approve(address _spender, uint256 _amount) public returns (bool approved) {
180 
181         require(_amount >= 0);
182         userAllowances[msg.sender][_spender] = _amount;
183         
184         emit Approval(msg.sender, _spender, _amount);
185 
186         return true;
187 
188     }
189 
190     function balanceOf(address _address) public view returns (uint256 balance) {
191 
192         return userBalances[_address];
193 
194     }
195 
196     function allowance(address _owner, address _spender) public view returns (uint256 allowed) {
197 
198         return userAllowances[_owner][_spender];
199 
200     }
201 
202     function totalSupply() public view returns (uint256 supply) {
203 
204         return _totalSupply;
205 
206     }
207 
208 }
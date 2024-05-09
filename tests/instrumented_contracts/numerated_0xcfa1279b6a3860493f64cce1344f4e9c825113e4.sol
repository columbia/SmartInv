1 pragma solidity >=0.4.17;
2 
3 contract GOCP {
4     
5     string private _name;
6     string private _symbol;
7     uint8 private _decimals;
8     uint256 private _totalSupply;
9     address private owner;
10     mapping (address => uint256) private balances;
11     mapping (address => mapping (address => uint256)) private allowed;
12     
13     
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16     
17     event Supply(string date, uint256 _value);
18     event Burn(address indexed _owner, uint256 _value);
19 
20     
21     constructor(string memory _tokenName, string memory _tokenSymbol) public payable {
22         _name = _tokenName;
23         _symbol = _tokenSymbol;
24         _decimals = 8;
25         _totalSupply = 0;
26 
27         owner = 0x01dfc9c3789dEBa770eAF2eC75b61f8C530301Bc;
28         
29         balances[owner] = _totalSupply;
30         
31         uint256 unit = 6678750000000;
32         
33         balances[0x3a22d9F57665c523387ff85F8C56ADb2E67a137b] = unit;
34         balances[0x618Ae5efD41A28FAac4E383912E8bE8753A44F19] = unit;
35         balances[0xa7ed28C25BB959cD08851F3916fcD356a6917Cb5] = unit;
36         balances[0xc42A0b069dE537622ef047049Cea162bBF85F530] = unit;
37         balances[0xa6bFfd59B0d97d887FfCd0a887f119BD1b5fE5ae] = unit;
38         
39         balances[0xe75A55634A05a022DC6cc2396A4d4beBEc868F20] = unit;
40         balances[0xa31c4BDC21b0380351C07dd9F883E6acA2145BF0] = unit;
41         balances[0xE532D9de7371E1179fc5A074D0509360498aEEbb] = unit;
42         balances[0x07226bA841D130daf422cD12D7b90f3E7d08FA6D] = unit;
43         balances[0xb6B661c0a735D80345CC38f9375BdeE2Ca27A6dB] = unit;
44         
45         balances[0xcf14459d0aF98a21F7C9D48A5C2ED5738CCE88cc] = unit;
46         balances[0x00536F5700D4720057a3760f9FCd811870497Ece] = unit;
47         balances[0xA5c782bc6926c6352eBf2227E0a13946FD59D770] = unit;
48         balances[0xf3065b0B60B5aa40384a608d0eA7661EFe9158b3] = unit;
49         balances[0xBb7932C223c98b299991bEB64755DDE5b60bFD7A] = unit;
50         
51         balances[0xdCc4839CE4560A8bCc2550C5878486D9D414cCb5] = unit;
52         balances[0xDec6a0C2Ac6cC5D6208F63C12642a7071e684808] = unit;
53         balances[0xC18c0F578cfb3F774e310506B3c37B4dB672f027] = unit;
54         balances[0x305e5B2CCAB0A72E10b21b218Ecf2c0a14986c46] = unit;
55         balances[0xA769Bed2E703a4698d8650B13FB333B01F9C6D95] = unit;
56         
57     }
58     
59     
60     function name() public view returns (string memory) { return _name; }
61 
62     function symbol() public view returns (string memory) { return _symbol; }
63     
64     function decimals() public view returns (uint8) { return _decimals; }
65     
66     function totalSupply() public view returns (uint256) { return _totalSupply; }
67 
68     function balanceOf(address _owner) public view returns (uint256 balance) { return balances[_owner]; }
69     
70     function transfer(address _to, uint256 _value) public returns (bool success) {
71         require(_to != address(this));
72         require(balances[msg.sender] >= _value);
73         require(balances[_to] + _value > balances[_to]);
74         
75         balances[msg.sender] -= _value;
76         balances[_to] += _value;
77         
78         emit Transfer(msg.sender, _to, _value);
79         
80         return true;
81     }
82     
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         require(_to != address(this));
85         require(balances[_from] >= _value);
86         require(allowed[_from][msg.sender] >= _value);
87         require(balances[_to] + _value > balances[_to]);
88         
89         balances[_from] -= _value;
90         allowed[_from][msg.sender] -= _value;
91         balances[_to] += _value;
92          
93         emit Transfer(_from, _to, _value);
94          
95         return true;
96     }
97     
98     function approve(address _spender, uint256 _value) public returns (bool success) {
99         require(_value > 0);
100         
101         allowed[msg.sender][_spender] = _value;
102          
103         emit Approval(msg.sender, _spender, _value);
104         
105         return true;
106     }
107     
108     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
109         return allowed[_owner][_spender];
110     }
111     
112     
113     function supply(string memory date, uint256 _value) public returns (bool success) { 
114         require(msg.sender == owner);
115         
116         balances[msg.sender] += _value;
117         _totalSupply += _value;
118         
119         emit Supply(date, _value);
120         
121         return true;
122     }
123 
124     function burn(uint256 _value) public returns (bool success) { 
125         require(_value > 0);
126         require(balances[msg.sender] >= _value);
127         
128         balances[msg.sender] -= _value;
129         _totalSupply -= _value;
130         
131         emit Burn(msg.sender, _value);
132         
133         return true;
134     }
135 
136     function burnFor(address _recipient, uint256 _value) public returns (bool success) { 
137         require(_value > 0);
138         require(balances[msg.sender] >= _value);
139         
140         balances[msg.sender] -= _value;
141         _totalSupply -= _value;
142         
143         emit Burn(_recipient, _value);
144         
145         return true;
146     }
147     
148     function destroy() public {
149         require(msg.sender == owner);
150         
151         selfdestruct(msg.sender);
152     }
153     
154     function transferOwnership(address _owner) public {
155         require(msg.sender == owner);
156         
157         owner = _owner;
158     }
159     
160     
161 }
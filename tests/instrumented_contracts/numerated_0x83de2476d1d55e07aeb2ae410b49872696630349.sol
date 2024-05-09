1 pragma solidity ^0.4.19;
2 
3 library SafeMath
4 {
5     function mul(uint256 a, uint256 b) internal pure
6         returns (uint256)
7     {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure
14         returns (uint256)
15     {
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure
21         returns (uint256)
22     {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure
28         returns (uint256)
29     {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
38 
39 contract TokenCCB{
40 	using SafeMath for uint;
41 	
42     string public name;
43 
44     string public symbol;
45 
46     uint8 public decimals = 18;  // 18 是建议的默认值
47 
48     uint256 public totalSupply;
49 
50     mapping (address => uint256) public balanceOf;  //
51 
52     mapping (address => mapping (address => uint256)) public allowance;
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55 
56     event Burn(address indexed from, uint256 value);
57 
58     function TokenCCB(uint256 initialSupply, string tokenName, string tokenSymbol) public {
59 
60         totalSupply = initialSupply * 10 ** uint256(decimals);
61 
62         balanceOf[msg.sender] = totalSupply;
63 
64         name = tokenName;
65 
66         symbol = tokenSymbol;
67 
68     }
69 
70     function _transfer(address _from, address _to, uint _value) internal {
71 	
72         require(_to != address(0));
73         
74         require(_value > 0);
75         
76         require(balanceOf[_from] >= _value);
77 
78         require(balanceOf[_to] + _value > balanceOf[_to]);
79 
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81 
82         balanceOf[_from] -= _value;
83 
84         balanceOf[_to] += _value;
85 
86         Transfer(_from, _to, _value);
87 
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89 
90     }
91 
92     function transfer(address _to, uint256 _value) public {
93 
94         _transfer(msg.sender, _to, _value);
95 
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99 
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101 
102         allowance[_from][msg.sender] -= _value;
103 
104         _transfer(_from, _to, _value);
105 
106         return true;
107 
108     }
109 
110     function approve(address _spender, uint256 _value) public
111 
112         returns (bool success) {
113 
114         allowance[msg.sender][_spender] = _value;
115 
116         return true;
117 
118     }
119 
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
121 
122         tokenRecipient spender = tokenRecipient(_spender);
123 
124         if (approve(_spender, _value)) {
125 
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127 
128             return true;
129 
130         }
131 
132     }
133 
134     function burn(uint256 _value) public returns (bool success) {
135 
136         require(balanceOf[msg.sender] >= _value);
137 
138         balanceOf[msg.sender] -= _value;
139 
140         totalSupply -= _value;
141 
142         Burn(msg.sender, _value);
143 
144         return true;
145 
146     }
147 
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149 
150         require(balanceOf[_from] >= _value);
151 
152         require(_value <= allowance[_from][msg.sender]);
153 
154         balanceOf[_from] -= _value;
155 
156         allowance[_from][msg.sender] -= _value;
157 
158         totalSupply -= _value;
159 
160         Burn(_from, _value);
161 
162         return true;
163     }
164 }
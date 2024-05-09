1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20  {
6 
7     string public  name;
8 
9     string public symbol ;
10 
11     uint8 public decimals = 4;  // 18 是建议的默认值
12 
13     uint256 public totalSupply;
14 
15     mapping (address => uint256) public balanceOf;  //
16 
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Burn(address indexed from, uint256 value);
22 
23     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
24   totalSupply = initialSupply * 10 ** uint256(decimals);
25 
26   //      totalSupply = initialSupply ;
27 
28         balanceOf[msg.sender] = totalSupply;
29 
30         name = tokenName;
31 
32         symbol = tokenSymbol;
33 
34     }
35 
36     function _transfer(address _from, address _to, uint _value) internal {
37 
38         require(_to != 0x0);
39 
40         require(balanceOf[_from] >= _value);
41 
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43 
44         uint previousBalances = balanceOf[_from] + balanceOf[_to];
45 
46         balanceOf[_from] -= _value;
47 
48         balanceOf[_to] += _value;
49 
50         Transfer(_from, _to, _value);
51 
52         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
53 
54     }
55 
56     function transfer(address _to, uint256 _value) public {
57 
58         _transfer(msg.sender, _to, _value);
59 
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63 
64         require(_value <= allowance[_from][msg.sender]);     // Check allowance
65 
66         allowance[_from][msg.sender] -= _value;
67 
68         _transfer(_from, _to, _value);
69 
70         return true;
71 
72     }
73 
74     function approve(address _spender, uint256 _value) public
75 
76     returns (bool success) {
77 
78         allowance[msg.sender][_spender] = _value;
79 
80         return true;
81 
82     }
83 
84     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
85 
86         tokenRecipient spender = tokenRecipient(_spender);
87 
88         if (approve(_spender, _value)) {
89 
90             spender.receiveApproval(msg.sender, _value, this, _extraData);
91 
92             return true;
93 
94         }
95 
96     }
97 
98     function burn(uint256 _value) public returns (bool success) {
99 
100         require(balanceOf[msg.sender] >= _value);
101 
102         balanceOf[msg.sender] -= _value;
103 
104         totalSupply -= _value;
105 
106         Burn(msg.sender, _value);
107 
108         return true;
109 
110     }
111 
112     function burnFrom(address _from, uint256 _value) public returns (bool success) {
113 
114         require(balanceOf[_from] >= _value);
115 
116         require(_value <= allowance[_from][msg.sender]);
117 
118         balanceOf[_from] -= _value;
119 
120         allowance[_from][msg.sender] -= _value;
121 
122         totalSupply -= _value;
123 
124         Burn(_from, _value);
125 
126         return true;
127 
128     }
129 
130 }
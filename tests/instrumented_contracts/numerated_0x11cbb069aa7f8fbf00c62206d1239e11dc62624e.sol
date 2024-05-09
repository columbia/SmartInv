1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6 
7     string public name;
8     string public symbol;
9 
10     uint8 public decimals = 18;  // 18 是建议的默认值
11 
12     uint256 public totalSupply;
13 
14     mapping (address => uint256) public balanceOf;  //
15 
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Burn(address indexed from, uint256 value);
21 
22     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
23 
24         totalSupply = initialSupply * 10 ** uint256(decimals);
25 
26         balanceOf[msg.sender] = totalSupply;
27 
28         name = tokenName;
29 
30         symbol = tokenSymbol;
31 
32     }
33 
34     function _transfer(address _from, address _to, uint _value) internal {
35 
36         require(_to != 0x0);
37 
38         require(balanceOf[_from] >= _value);
39 
40         require(balanceOf[_to] + _value > balanceOf[_to]);
41 
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43 
44         balanceOf[_from] -= _value;
45 
46         balanceOf[_to] += _value;
47 
48         Transfer(_from, _to, _value);
49 
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51 
52     }
53 
54     function transfer(address _to, uint256 _value) public {
55 
56         _transfer(msg.sender, _to, _value);
57 
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61 
62         require(_value <= allowance[_from][msg.sender]);     // Check allowance
63 
64         allowance[_from][msg.sender] -= _value;
65 
66         _transfer(_from, _to, _value);
67 
68         return true;
69 
70     }
71 
72     function approve(address _spender, uint256 _value) public
73 
74         returns (bool success) {
75 
76         allowance[msg.sender][_spender] = _value;
77 
78         return true;
79 
80     }
81 
82     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
83 
84         tokenRecipient spender = tokenRecipient(_spender);
85 
86         if (approve(_spender, _value)) {
87 
88             spender.receiveApproval(msg.sender, _value, this, _extraData);
89 
90             return true;
91 
92         }
93 
94     }
95 
96     function burn(uint256 _value) public returns (bool success) {
97 
98         require(balanceOf[msg.sender] >= _value);
99 
100         balanceOf[msg.sender] -= _value;
101 
102         totalSupply -= _value;
103 
104         Burn(msg.sender, _value);
105 
106         return true;
107 
108     }
109 
110     function burnFrom(address _from, uint256 _value) public returns (bool success) {
111 
112         require(balanceOf[_from] >= _value);
113 
114         require(_value <= allowance[_from][msg.sender]);
115 
116         balanceOf[_from] -= _value;
117 
118         allowance[_from][msg.sender] -= _value;
119 
120         totalSupply -= _value;
121 
122         Burn(_from, _value);
123 
124         return true;
125     }
126 }
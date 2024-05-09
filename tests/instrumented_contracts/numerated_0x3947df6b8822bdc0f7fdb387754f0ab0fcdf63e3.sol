1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6 
7     string public name;
8 
9     string public symbol;
10 
11     uint8 public decimals = 18;  
12 
13     uint256 public totalSupply;
14 
15     mapping (address => uint256) public balanceOf; 
16 
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     event Burn(address indexed from, uint256 value);
22 
23     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
24 
25         totalSupply = initialSupply * 10 ** uint256(decimals);
26 
27         balanceOf[msg.sender] = totalSupply;
28 
29         name = tokenName;
30 
31         symbol = tokenSymbol;
32 
33     }
34 
35     function _transfer(address _from, address _to, uint _value) internal {
36 
37         require(_to != 0x0);
38 
39         require(balanceOf[_from] >= _value);
40 
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42 
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44 
45         balanceOf[_from] -= _value;
46 
47         balanceOf[_to] += _value;
48 
49         Transfer(_from, _to, _value);
50 
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52 
53     }
54 
55     function transfer(address _to, uint256 _value) public {
56 
57         _transfer(msg.sender, _to, _value);
58 
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62 
63         require(_value <= allowance[_from][msg.sender]);     // Check allowance
64 
65         allowance[_from][msg.sender] -= _value;
66 
67         _transfer(_from, _to, _value);
68 
69         return true;
70 
71     }
72 
73     function approve(address _spender, uint256 _value) public
74 
75         returns (bool success) {
76 
77         allowance[msg.sender][_spender] = _value;
78 
79         return true;
80 
81     }
82 
83     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
84 
85         tokenRecipient spender = tokenRecipient(_spender);
86 
87         if (approve(_spender, _value)) {
88 
89             spender.receiveApproval(msg.sender, _value, this, _extraData);
90 
91             return true;
92 
93         }
94 
95     }
96 
97     function burn(uint256 _value) public returns (bool success) {
98 
99         require(balanceOf[msg.sender] >= _value);
100 
101         balanceOf[msg.sender] -= _value;
102 
103         totalSupply -= _value;
104 
105         Burn(msg.sender, _value);
106 
107         return true;
108 
109     }
110 
111     function burnFrom(address _from, uint256 _value) public returns (bool success) {
112 
113         require(balanceOf[_from] >= _value);
114 
115         require(_value <= allowance[_from][msg.sender]);
116 
117         balanceOf[_from] -= _value;
118 
119         allowance[_from][msg.sender] -= _value;
120 
121         totalSupply -= _value;
122 
123         Burn(_from, _value);
124 
125         return true;
126     }
127 }
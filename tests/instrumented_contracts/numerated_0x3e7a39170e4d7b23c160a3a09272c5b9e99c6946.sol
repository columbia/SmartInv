1 pragma solidity ^0.4.16;
2 
3 
4 interface tokenRecipient { 
5     
6     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
7     
8     //function receiveApproval(address _from, uint256 _value, address _token) public;    
9     
10 }
11 
12 contract TokenERC20 {
13     
14     string public name;
15     
16     string public symbol;
17     
18     uint8 public decimals = 18;
19     
20     uint256 public totalSupply;
21     
22     mapping (address => uint256) public balanceOf;//
23     
24     mapping (address => mapping (address => uint256)) public allowance;
25     
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     
28     event Burn(address indexed from, uint256 value);
29 
30     
31     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
32     //function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol){        
33     //constructor TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
34         
35         totalSupply = initialSupply * 10 ** uint256(decimals);
36         
37         balanceOf[msg.sender] = totalSupply;
38         
39         name = tokenName;
40         
41         symbol = tokenSymbol;
42         
43     }
44     
45     function _transfer(address _from, address _to, uint _value) internal {
46         
47         require(_to != 0x0);
48         
49         require(balanceOf[_from] >= _value);
50         
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         
55         balanceOf[_from] -= _value;
56         
57         balanceOf[_to] += _value;
58         
59         Transfer(_from, _to, _value);
60         
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62         
63     }
64     
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         
67         _transfer(msg.sender, _to, _value);
68         
69         return true;
70         
71     }
72     
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         
75         require(_value <= allowance[_from][msg.sender]); // Check allowance
76         
77         allowance[_from][msg.sender] -= _value;
78         
79         _transfer(_from, _to, _value);
80         
81         return true;
82         
83     }
84     
85     function approve(address _spender, uint256 _value) public
86     
87     returns (bool success) {
88         
89         allowance[msg.sender][_spender] = _value;
90         
91         return true;
92         
93     }
94     
95     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
96         
97         tokenRecipient spender = tokenRecipient(_spender);
98         
99         if (approve(_spender, _value)) {
100             
101             spender.receiveApproval(msg.sender, _value, this, _extraData);
102             
103             return true;
104             
105         }
106         
107         
108     }
109     
110     function burn(uint256 _value) public returns (bool success) {
111         
112         require(balanceOf[msg.sender] >= _value);
113         
114         balanceOf[msg.sender] -= _value;
115         
116         totalSupply -= _value;
117         
118         Burn(msg.sender, _value);
119         
120         return true;
121         
122     }
123     
124     function burnFrom(address _from, uint256 _value) public returns (bool success) {
125         
126         require(balanceOf[_from] >= _value);
127         
128         require(_value <= allowance[_from][msg.sender]);
129         
130         balanceOf[_from] -= _value;
131         
132         allowance[_from][msg.sender] -= _value;
133         
134         totalSupply -= _value;
135         
136         Burn(_from, _value);
137         
138         return true;
139         
140     }
141 
142 }
1 pragma solidity ^0.5.1;
2 
3 
4 contract TokenERC20 {
5 
6     string public name;
7 
8     string public symbol;
9 
10     uint8 public decimals = 8;  // 18 是建议的默认值
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
22     constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public{
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
36         require(_to != address(0));
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
48         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
49 
50         emit Transfer(_from, _to, _value);
51 
52 
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
84 
85     function burn(uint256 _value) public returns (bool success) {
86 
87         require(balanceOf[msg.sender] >= _value);
88 
89         balanceOf[msg.sender] -= _value;
90 
91         totalSupply -= _value;
92 
93         emit Burn(msg.sender, _value);
94 
95         return true;
96 
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100 
101         require(balanceOf[_from] >= _value);
102 
103         require(_value <= allowance[_from][msg.sender]);
104 
105         balanceOf[_from] -= _value;
106 
107         allowance[_from][msg.sender] -= _value;
108 
109         totalSupply -= _value;
110 
111         emit Burn(_from, _value);
112 
113         return true;
114     }
115 }
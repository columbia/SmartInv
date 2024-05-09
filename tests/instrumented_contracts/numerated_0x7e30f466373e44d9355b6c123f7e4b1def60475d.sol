1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4 
5     uint256 public totalSupply;
6 
7     mapping (address => uint256) public balanceOf;
8 
9     mapping (address => mapping (address => uint256)) public allowance;
10 
11     function transfer(address to, uint256 value) public returns (bool success);
12 
13     function transferFrom(address from, address to, uint256 value) public returns (bool success);
14 
15     function approve(address spender, uint256 value) public returns (bool success);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 
21 }
22 
23 contract BondkickToken is ERC20 {
24 
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28     bool public paused;
29 
30     address public owner;
31     address public minter;
32 
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     modifier onlyMinter() {
39         require(msg.sender == minter);
40         _;
41     }
42 
43     modifier notPaused() {
44         require(!paused);
45         _;
46     }
47     
48     function BondkickToken(string _name, string _symbol, uint8 _decimals, uint256 _initialMint) {
49         name = _name;
50         symbol = _symbol;
51         decimals = _decimals;
52         owner = msg.sender;
53         minter = msg.sender;
54         
55         if (_initialMint > 0) {
56             totalSupply += _initialMint;
57             balanceOf[msg.sender] += _initialMint;
58 
59             Transfer(address(0), msg.sender, _initialMint);
60         }
61     }
62 
63     function transfer(address _to, uint256 _value) public returns (bool success) {
64         require(_to != address(0));
65         require(balanceOf[msg.sender] >= _value);
66         
67         _transfer(msg.sender, _to, _value);
68         
69         return true;
70     }
71     
72     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
73         require(_to != address(0));
74         require(balanceOf[_from] >= _value);
75         require(allowance[_from][msg.sender] >= _value);
76         
77         allowance[_from][msg.sender] -= _value;
78         
79         _transfer(_from, _to, _value);
80         
81         return true;
82     }
83     
84     function approve(address _spender, uint256 _value) public returns (bool success) {
85         require(_spender != address(0));
86 
87         allowance[msg.sender][_spender] = _value;
88 
89         Approval(msg.sender, _spender, _value);
90         
91         return true;
92     }
93 
94     function mint(uint256 _value) public notPaused onlyMinter returns (bool success) {
95         require(_value > 0 && (totalSupply + _value) >= totalSupply);
96         
97         totalSupply += _value;
98         balanceOf[msg.sender] += _value;
99 
100         Transfer(address(0), msg.sender, _value);
101         
102         return true;
103     }
104     
105     function mintTo (uint256 _value, address _to) public notPaused onlyMinter returns (bool success) {
106         require(_value > 0 && (totalSupply + _value) >= totalSupply);
107         
108         totalSupply += _value;
109         balanceOf[_to] += _value;
110 
111         Transfer(address(0), _to, _value);
112         
113         return true;
114     }
115 
116     function unmint(uint256 _value) public notPaused onlyMinter returns (bool success) {
117         require(_value > 0 && balanceOf[msg.sender] >= _value);
118 
119         totalSupply -= _value;
120         balanceOf[msg.sender] -= _value;
121 
122         Transfer(msg.sender, address(0), _value);
123 
124         return true;
125     }
126     
127     function changeOwner(address _newOwner) public onlyOwner returns (bool success) {
128         require(_newOwner != address(0));
129 
130         owner = _newOwner;
131         
132         return true;
133     }
134 
135     function changeMinter(address _newMinter) public onlyOwner returns (bool success) {
136         require(_newMinter != address(0));
137 
138         minter = _newMinter;
139 
140         return true;
141     }
142 
143     function _transfer(address _from, address _to, uint256 _value) internal {
144         balanceOf[_from] -= _value;
145         balanceOf[_to] += _value;
146 
147         Transfer(_from, _to, _value);
148     }
149 }
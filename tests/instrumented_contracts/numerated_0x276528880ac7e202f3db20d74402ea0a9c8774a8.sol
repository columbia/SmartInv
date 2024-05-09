1 pragma solidity >=0.4.21 <0.6.0;
2 
3 contract Owner {
4     address public owner;
5 
6     constructor() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient {
21     function receiveApproval(
22         address _from,
23         uint256 _value,
24         address _token,
25         bytes _extraData)
26     external;
27 }
28 
29 contract ERC20Token {
30     string public name;
31     string public symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34 
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     event Burn(address indexed from, uint256 value);
41 
42     constructor(
43         string _tokenName,
44         string _tokenSymbol,
45         uint8 _decimals,
46         uint256 _totalSupply) public {
47         name = _tokenName;
48         symbol = _tokenSymbol;
49         decimals = _decimals;
50         totalSupply = _totalSupply * 10 ** uint256(decimals);
51         balanceOf[msg.sender] = totalSupply;
52     }
53 
54     function _transfer(
55         address _from,
56         address _to,
57         uint256 _value) internal {
58         require(_to != 0x0);
59         require(_from != 0x0);
60         require(balanceOf[_from] >= _value);
61         require(balanceOf[_to] + _value > balanceOf[_to]);
62 
63         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
64 
65         balanceOf[_from] -= _value;
66         balanceOf[_to] += _value;
67 
68         emit Transfer(_from, _to, _value);
69 
70         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
71     }
72 
73     function transfer(
74         address _to,
75         uint256 _value) public {
76         _transfer(msg.sender, _to, _value);
77     }
78 
79     function transferFrom(
80         address _from,
81         address _to,
82         uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);
84         
85         allowance[_from][msg.sender] -= _value;
86         
87         _transfer(_from, _to, _value);
88         
89         return true;
90     }
91 
92     function approve(
93         address _spender,
94         uint256 _value) public returns (bool success) {
95         allowance[msg.sender][_spender] = _value;
96         
97         return true;
98     }
99 
100     function approveAndCall(
101         address _spender,
102         uint256 _value,
103         bytes _extraData) public returns (bool success) {
104         tokenRecipient spender = tokenRecipient(_spender);
105 
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             
109             return true;
110         }
111     }
112 
113     function burn(
114         uint256 _value) public returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);
116 
117         balanceOf[msg.sender] -= _value;
118         totalSupply -= _value;
119 
120         emit Burn(msg.sender, _value);
121 
122         return true;
123     }
124 
125     function burnFrom(
126         address _from,
127         uint256 _value) public returns (bool success) {
128         require(balanceOf[_from] >= _value);
129         require(_value <= allowance[_from][msg.sender]);
130 
131         balanceOf[_from] -= _value;
132         allowance[_from][msg.sender] -= _value;
133         totalSupply -= _value;
134 
135         emit Burn(_from, _value);
136 
137         return true;
138     }
139 }
140 
141 contract Stmp is Owner, ERC20Token {
142     constructor(
143         string _tokenName,
144         string _tokenSymbol,
145         uint8 _decimals,
146         uint256 _totalSupply)
147         ERC20Token(_tokenName, _tokenSymbol, _decimals, _totalSupply) public {
148     }
149 
150     function transferStmpsToOwnerAccount(
151         address _from,
152         uint256 _value) onlyOwner public {
153         _transfer(_from, owner, _value);
154     }
155 }
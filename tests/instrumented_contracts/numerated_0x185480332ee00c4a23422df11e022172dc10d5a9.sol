1 pragma solidity ^0.4.23;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned{
6 
7     address public owner;
8 
9     constructor ()public{
10         owner = msg.sender;
11     }
12 
13     function changeOwner(address newOwner) public onlyOwner{
14         owner = newOwner;
15     }
16 
17     modifier onlyOwner{
18         require(msg.sender == owner);
19         _;
20     }
21 }
22 
23 contract Erc20Token {
24     function totalSupply() public view returns (uint);
25     function balanceOf(address tokenOwner) public view returns (uint balance);
26     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
27     function transfer(address to, uint tokens) public returns (bool success);
28     function approve(address spender, uint tokens) public returns (bool success);
29     function transferFrom(address from, address to, uint tokens) public returns (bool success);
30 
31     event Transfer(address indexed from, address indexed to, uint tokens);
32     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
33 }
34 
35 contract NausiCoin is Erc20Token, owned {
36 
37     string public name;
38     string public symbol;
39     uint public decimals;
40 
41     uint _totalSupply;
42     mapping(address => uint) _balanceOf;
43     mapping(address => mapping(address => uint)) _allowance;
44 
45     event Burn(address indexed from, uint amount);
46     event Mint(address indexed from, uint amount);
47     
48     constructor(string tokenName, string tokenSymbol, uint tokenDecimals, uint tokenTotalSupply) public {
49         name = tokenName;
50         symbol = tokenSymbol;
51         decimals = tokenDecimals;
52 
53         _totalSupply = tokenTotalSupply * 10**uint(decimals);
54         _balanceOf[msg.sender] = _totalSupply;
55     }
56 
57     function totalSupply() public view returns (uint){
58         return _totalSupply;
59     }
60 
61     function balanceOf(address tokenOwner) public view returns (uint balance){
62         return _balanceOf[tokenOwner];
63     }
64 
65     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
66         return _allowance[tokenOwner][spender];
67     }
68 
69     function transfer(address to, uint value) public returns (bool success){
70         _transfer(msg.sender, to, value);
71         return true;
72     }
73 
74     function transferFrom(address from, address to, uint value) public returns (bool success){
75         require(_allowance[from][msg.sender] >= value);
76         
77         _allowance[from][msg.sender] -= value;
78         _transfer(from, to, value);
79 
80         return true;
81     }
82 
83     function approve(address spender, uint value) public returns (bool succes) {
84         _allowance[msg.sender][spender] = value;
85         return true;
86     }
87 
88     function approveAndCall(address spender, uint value, bytes extraData) public returns (bool success){
89         tokenRecipient _spender = tokenRecipient(spender);
90         if(approve(spender, value)){
91             _spender.receiveApproval(msg.sender, value, this, extraData);
92             return true;
93         }
94     }
95 
96     function burnFrom(address from, uint amount) public onlyOwner returns(bool success) {
97         require(_balanceOf[from] >= amount);
98         require(_balanceOf[from] - amount <= _balanceOf[from]);
99 
100         if(owner != from){
101             require(_allowance[msg.sender][from] >= amount);
102         }
103 
104         _balanceOf[from] -= amount;
105         _allowance[msg.sender][from] -= amount;
106         _totalSupply -= amount;
107 
108         emit Burn(from, amount);
109 
110         return true;
111     }
112 
113     function mintTo(address to, uint amount) public onlyOwner returns(bool success){
114         require(_balanceOf[to] + amount >= _balanceOf[to]);
115         require(_totalSupply + amount >= _totalSupply);
116 
117         _balanceOf[to] += amount;
118         _totalSupply += amount;
119 
120         emit Mint(to, amount);
121 
122         return true;
123     }
124 
125     function() public payable {
126         require(false);
127     }
128 
129     function _transfer(address from, address to, uint value) internal{
130         require(to != 0x0);
131         require(_balanceOf[from] >= value);
132         require(_balanceOf[to] + value >= _balanceOf[to]);
133 
134         uint previousBalance = _balanceOf[from] + _balanceOf[to];
135 
136         _balanceOf[from] -= value;
137         _balanceOf[to] += value;
138 
139         emit Transfer(from, to, value);
140 
141         assert(_balanceOf[from] + _balanceOf[to] == previousBalance);
142     }
143 }
1 pragma solidity ^0.4.23;
2 
3 contract BaseERC20Token {
4     mapping (address => uint256) public balanceOf;
5 
6     string public name;
7     string public symbol;
8     uint8 public decimals;
9     uint256 public totalSupply;
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     constructor (
14         uint256 _totalSupply,
15         uint8 _decimals,
16         string _name,
17         string _symbol
18     )
19         public
20     {
21         name = _name;
22         symbol = _symbol;
23         decimals = _decimals;
24 
25         totalSupply = _totalSupply;
26         balanceOf[msg.sender] = _totalSupply;
27         emit Transfer(address(0), msg.sender, _totalSupply);
28     }
29 
30     function transfer(address to, uint256 value) public returns (bool success) {
31         require(balanceOf[msg.sender] >= value);
32 
33         balanceOf[msg.sender] -= value;
34         balanceOf[to] += value;
35         emit Transfer(msg.sender, to, value);
36         return true;
37     }
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41     mapping(address => mapping(address => uint256)) public allowance;
42 
43     function approve(address spender, uint256 value)
44         public
45         returns (bool success)
46     {
47         allowance[msg.sender][spender] = value;
48         emit Approval(msg.sender, spender, value);
49         return true;
50     }
51 
52     function transferFrom(address from, address to, uint256 value)
53         public
54         returns (bool success)
55     {
56         require(value <= balanceOf[from]);
57         require(value <= allowance[from][msg.sender]);
58 
59         balanceOf[from] -= value;
60         balanceOf[to] += value;
61         allowance[from][msg.sender] -= value;
62         emit Transfer(from, to, value);
63         return true;
64     }
65 }
66 
67 contract MintableToken is BaseERC20Token {
68     address public owner = msg.sender;
69 
70     constructor(
71         uint256 _totalSupply,
72         uint8 _decimals,
73         string _name,
74         string _symbol
75     ) BaseERC20Token(_totalSupply, _decimals, _name, _symbol) public
76     {
77     }
78 
79     function mint(address recipient, uint256 amount) public {
80         require(msg.sender == owner);
81         require(totalSupply + amount >= totalSupply); // Overflow check
82 
83         totalSupply += amount;
84         balanceOf[recipient] += amount;
85         emit Transfer(address(0), recipient, amount);
86     }
87 
88     function burn(uint256 amount) public {
89         require(amount <= balanceOf[msg.sender]);
90 
91         totalSupply -= amount;
92         balanceOf[msg.sender] -= amount;
93         emit Transfer(msg.sender, address(0), amount);
94     }
95 
96     function burnFrom(address from, uint256 amount) public {
97         require(amount <= balanceOf[from]);
98         require(amount <= allowance[from][msg.sender]);
99 
100         totalSupply -= amount;
101         balanceOf[from] -= amount;
102         allowance[from][msg.sender] -= amount;
103         emit Transfer(from, address(0), amount);
104     }
105 }
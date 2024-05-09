1 //"SPDX-License-Identifier: UNLICENSED"
2 
3 pragma solidity ^0.5.0;
4 
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10 
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15 
16     function mul(uint a, uint b) internal pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20 
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 interface IERC20 {
28     function transfer(address to, uint tokens) external returns (bool success);
29     function transferFrom(address from, address to, uint tokens) external returns (bool success);
30     function balanceOf(address tokenOwner) external view returns (uint balance);
31     function approve(address spender, uint tokens) external returns (bool success);
32     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
33     function totalSupply() external view returns (uint);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 contract Owned {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) external onlyOwner {
54         owner = _newOwner;
55         emit OwnershipTransferred(owner, _newOwner);
56     }
57 }
58 contract ERC20 is IERC20, Owned {
59     
60     using SafeMath for uint;
61     
62     string public name;
63     string public symbol;
64     uint8 public decimals;
65     uint private tokenTotalSupply;
66     mapping(address => uint) private balances;
67     mapping(address => mapping(address => uint)) private allowed;
68     
69     event Burn(address indexed burner, uint256 value);
70     
71     constructor(string memory _name, string memory _symbol) public {
72         name = _name;
73         symbol = _symbol; 
74         decimals = 18;
75         tokenTotalSupply = 30000000000000000000000000;
76         balances[0x89aa711B9F2C677aeFc79F15612597A57B0D6a93] = tokenTotalSupply;
77         emit Transfer(address(0x0), 0x89aa711B9F2C677aeFc79F15612597A57B0D6a93, tokenTotalSupply);
78     }
79     
80     modifier canApprove(address spender, uint value) {
81         require(spender != msg.sender, 'Cannot approve self');
82         require(spender != address(0x0), 'Cannot approve a zero address');
83         require(balances[msg.sender] >= value, 'Cannot approve more than available balance');
84         _;
85     }
86         
87     function transfer(address to, uint value) external returns(bool success) {
88         require(balances[msg.sender] >= value);
89         balances[msg.sender] = balances[msg.sender].sub(value);
90         balances[to] = balances[to].add(value);
91         emit Transfer(msg.sender, to, value);
92         return true;
93     }
94     
95     function transferFrom(address from, address to, uint value) external returns(bool success) {
96         uint allowance = allowed[from][msg.sender];
97         require(balances[from] >= value && allowance >= value);
98         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
99         balances[from] = balances[from].sub(value);
100         balances[to] = balances[to].add(value);
101         emit Transfer(from, to, value);
102         return true;
103     }
104     
105     function approve(address spender, uint value) external canApprove(spender, value) returns(bool approved) {
106         allowed[msg.sender][spender] = value;
107         emit Approval(msg.sender, spender, value);
108         return true;
109     }
110     
111     function allowance(address owner, address spender) external view returns(uint) {
112         return allowed[owner][spender];
113     }
114 
115     function balanceOf(address owner) external view returns(uint) {
116         return balances[owner];
117     }
118     
119     function totalSupply() external view returns(uint) {
120         return tokenTotalSupply;
121     }
122     
123     function burn(address _who, uint _value) external returns(bool success) {
124         require(_value <= balances[_who]);
125         balances[_who] = balances[_who].sub(_value);
126         tokenTotalSupply = tokenTotalSupply.sub(_value);
127         emit Burn(_who, _value);
128         return true;
129     }
130     
131     function burnFrom(address _from, uint _value) external returns(bool success) {
132         require(balances[_from] >= _value);                
133         require(_value <= allowed[_from][msg.sender]); 
134         balances[_from] =  balances[_from].sub(_value);                        
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);             
136         tokenTotalSupply = tokenTotalSupply.sub(_value);                             
137         emit Burn(_from, _value);
138         return true;
139     }
140     
141     function transferAnyERC20Token(address _tokenAddress, uint _amount) external onlyOwner returns(bool success) {
142         IERC20(_tokenAddress).transfer(owner, _amount);
143         return true;
144     }
145 }
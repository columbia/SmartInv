1 pragma solidity ^0.5.0;
2 
3 // --------------------------------------------------------------
4 // Name     : Bitway
5 // Symbol   : WAY
6 // Supply   : 21,000,000.000000000000000000
7 // Decimals : 18
8 // --------------------------------------------------------------
9 
10 library SafeMath {
11     function add(uint a, uint b) internal pure returns (uint c) {
12         c = a + b;
13         require(c >= a);
14     }
15     function sub(uint a, uint b) internal pure returns (uint c) {
16         require(b <= a);
17         c = a - b;
18     }
19     function mul(uint a, uint b) internal pure returns (uint c) {
20         c = a * b;
21         require(a == 0 || c / a == b);
22     }
23     function div(uint a, uint b) internal pure returns (uint c) {
24         require(b > 0);
25         c = a / b;
26     }
27 }
28 
29 contract ERC20 {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 contract Owned {
41     address public owner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address newOwner) public onlyOwner {
55         require(newOwner != address(0));
56         emit OwnershipTransferred(owner, newOwner);
57         owner = newOwner;
58     }
59 }
60 
61 contract Bitway is ERC20, Owned {
62     using SafeMath for uint;
63 
64     string public  name;
65     string public symbol;
66     uint public decimals;
67     uint _totalSupply;
68     uint _maxSupply;
69     bool public completed;
70 
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73 
74     modifier validDestination( address to ) {
75     require(to != address(0x0));
76     require(to != address(this) );
77     _;
78     }
79 
80     constructor() public {
81         name = "Bitway";
82         symbol = "WAY";
83         decimals = 18;
84         _totalSupply = 0;
85         _maxSupply = 21000000 * 10**uint(decimals);
86         completed = false;
87     }
88 
89     function mint(uint tokens) public onlyOwner {
90         require(!completed);
91         balances[msg.sender] = balances[msg.sender].add(tokens);
92         _totalSupply = _totalSupply.add(tokens);
93         emit Transfer(address(0), msg.sender, tokens);
94         if (_totalSupply >= _maxSupply)
95         completed = true;
96     }
97 
98     function totalSupply() public view returns (uint) {
99         return _totalSupply;
100     }
101 
102     function maxSupply() public view returns (uint) {
103         return _maxSupply;
104     }
105 
106     function balanceOf(address tokenOwner) public view returns (uint balance) {
107         return balances[tokenOwner];
108     }
109 
110     function transfer(address to, uint tokens) public validDestination(to) returns (bool success) {
111         balances[msg.sender] = balances[msg.sender].sub(tokens);
112         balances[to] = balances[to].add(tokens);
113         emit Transfer(msg.sender, to, tokens);
114         return true;
115     }
116 
117     function approve(address spender, uint tokens) public returns (bool success) {
118         allowed[msg.sender][spender] = tokens;
119         emit Approval(msg.sender, spender, tokens);
120         return true;
121     }
122 
123     function transferFrom(address from, address to, uint tokens) public validDestination(to) returns (bool success) {
124         balances[from] = balances[from].sub(tokens);
125         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
126         balances[to] = balances[to].add(tokens);
127         emit Transfer(from, to, tokens);
128         return true;
129     }
130 
131     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
132         return allowed[tokenOwner][spender];
133     }
134 
135     function () external payable {
136         revert();
137     }
138 
139     event Transfer(address indexed from, address indexed to, uint tokens);
140     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
141 }
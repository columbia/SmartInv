1 pragma solidity ^0.5.1;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ICashToken is ERC20Interface {
35     using SafeMath for uint;
36     
37     string public symbol;
38     string public  name;
39     uint8 public decimals;
40     
41     uint private _totalSupply;
42     
43     address private _owner;
44 
45     mapping(address => uint) private _balances;
46     mapping(address => mapping(address => uint)) private _allowed;
47     
48     constructor() public {
49         symbol = "iCash";
50         name = "iCash Token";
51         decimals = 18;
52         _totalSupply = 300*1000000*10**uint(decimals); //300M
53         
54         _owner = msg.sender;
55 
56         address master = address(0x8FA33dE666e0c4d560b68638798c5fC64b7519eb);
57         _balances[master] = _totalSupply;
58         emit Transfer(address(0), master, _totalSupply);
59     }
60     
61     function totalSupply() public view returns (uint) {
62         return _totalSupply.sub(_balances[address(0)]);
63     }
64     
65     function balanceOf(address tokenOwner) public view returns (uint balance) {
66         return _balances[tokenOwner];
67     }
68     
69     function transfer(address to, uint tokens) public returns (bool success) {
70         _balances[msg.sender] = _balances[msg.sender].sub(tokens);
71         _balances[to] = _balances[to].add(tokens);
72         emit Transfer(msg.sender, to, tokens);
73         return true;
74     }
75     
76     function approve(address spender, uint tokens) public returns (bool success) {
77         _allowed[msg.sender][spender] = tokens;
78         emit Approval(msg.sender, spender, tokens);
79         return true;
80     }
81     
82     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
83         _balances[from] = _balances[from].sub(tokens);
84         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);
85         _balances[to] = _balances[to].add(tokens);
86         emit Transfer(from, to, tokens);
87         return true;
88     }
89     
90     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
91         return _allowed[tokenOwner][spender];
92     }
93     // ------------------------------------------------------------------------
94     // Don't accept ETH
95     // ------------------------------------------------------------------------
96     function () external payable {
97         revert();
98     }
99      // ------------------------------------------------------------------------
100     // Owner can transfer out any accidentally sent ERC20 tokens
101     // ------------------------------------------------------------------------
102     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
103         require(msg.sender == _owner);
104         return ERC20Interface(tokenAddress).transfer(_owner, tokens);
105     }
106 }
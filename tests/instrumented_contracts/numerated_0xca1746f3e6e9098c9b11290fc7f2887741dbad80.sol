1 pragma solidity 0.5.4;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract Ownable {
16     address public owner;
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19 
20     constructor() public {
21         owner = msg.sender;
22     }
23 
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 }
29 
30 contract DIYSToken is ERC20Interface, Ownable {
31     using SafeMath for uint;
32 
33     string public symbol = "DIYS";
34     string public name = "DIYS Token";
35     uint8 public decimals = 0;
36     uint public  _totalSupply;
37 
38     mapping(address => uint) balances;
39     mapping(address => mapping(address => uint)) allowed;
40 
41     constructor() public {
42         _totalSupply = 10000000;
43         balances[owner] = _totalSupply;
44         emit Transfer(address(0), owner, _totalSupply);
45     }
46 
47     function totalSupply() public view returns (uint) {
48         return _totalSupply.sub(balances[address(0)]);
49     }
50 
51     function balanceOf(address tokenOwner) public view returns (uint balance) {
52         return balances[tokenOwner];
53     }
54 
55     function transfer(address to, uint tokens) public returns (bool success) {
56         balances[msg.sender] = balances[msg.sender].sub(tokens);
57         balances[to] = balances[to].add(tokens);
58         emit Transfer(msg.sender, to, tokens);
59         return true;
60     }
61 
62     function approve(address spender, uint tokens) public returns (bool success) {
63         allowed[msg.sender][spender] = tokens;
64         emit Approval(msg.sender, spender, tokens);
65         return true;
66     }
67 
68 
69     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
70         balances[from] = balances[from].sub(tokens);
71         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
72         balances[to] = balances[to].add(tokens);
73         emit Transfer(from, to, tokens);
74         return true;
75     }
76 
77     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
78         return allowed[tokenOwner][spender];
79     }
80 
81     function () external payable {
82         revert();
83     }
84 
85     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
86         return ERC20Interface(tokenAddress).transfer(owner, tokens);
87     }
88 }
89 library SafeMath {
90     function add(uint a, uint b) internal pure returns (uint c) {
91         c = a + b;
92         require(c >= a);
93     }
94     function sub(uint a, uint b) internal pure returns (uint c) {
95         require(b <= a);
96         c = a - b;
97     }
98     function mul(uint a, uint b) internal pure returns (uint c) {
99         c = a * b;
100         require(a == 0 || c / a == b);
101     }
102     function div(uint a, uint b) internal pure returns (uint c) {
103         require(b > 0);
104         c = a / b;
105     }
106 }
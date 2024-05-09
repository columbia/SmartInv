1 pragma solidity ^0.4.24;
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
21 contract ERC20Interface {
22     function totalSupply() public constant returns (uint);
23     function balanceOf(address tokenOwner) public constant returns (uint balance);
24     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
25     function transfer(address to, uint tokens) public returns (bool success);
26     function approve(address spender, uint tokens) public returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 contract ApproveAndCallFallBack {
33     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
34 }
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 contract Ethermes is ERC20Interface, Owned {
61     using SafeMath for uint;
62 
63     string public symbol;
64     string public  name;
65     uint8 public decimals;
66     uint _totalSupply;
67 
68     mapping(address => uint) balances;
69     mapping(address => mapping(address => uint)) allowed;
70 
71     constructor() public {
72         symbol = "EHM";
73         name = "Ethermes";
74         decimals = 18;
75         _totalSupply = 100000000 * 10**uint(decimals);
76         balances[owner] = _totalSupply;
77         emit Transfer(address(0), owner, _totalSupply);
78     }
79     function totalSupply() public view returns (uint) {
80         return _totalSupply.sub(balances[address(0)]);
81     }
82 
83     function balanceOf(address tokenOwner) public view returns (uint balance) {
84         return balances[tokenOwner];
85     }
86     function transfer(address to, uint tokens) public returns (bool success) {
87         balances[msg.sender] = balances[msg.sender].sub(tokens);
88         balances[to] = balances[to].add(tokens);
89         emit Transfer(msg.sender, to, tokens);
90         return true;
91     }
92     function approve(address spender, uint tokens) public returns (bool success) {
93         allowed[msg.sender][spender] = tokens;
94         emit Approval(msg.sender, spender, tokens);
95         return true;
96     }
97     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
98         balances[from] = balances[from].sub(tokens);
99         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
100         balances[to] = balances[to].add(tokens);
101         emit Transfer(from, to, tokens);
102         return true;
103     }
104     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
105         return allowed[tokenOwner][spender];
106     }
107     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
108         allowed[msg.sender][spender] = tokens;
109         emit Approval(msg.sender, spender, tokens);
110         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
111         return true;
112     }
113     function () public payable {
114         revert();
115     }
116     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
117         return ERC20Interface(tokenAddress).transfer(owner, tokens);
118     }
119 }
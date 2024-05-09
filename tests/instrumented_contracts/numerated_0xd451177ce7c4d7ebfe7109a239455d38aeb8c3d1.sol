1 pragma solidity 0.4.19;
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
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 }
31 contract ApproveAndCallFallBack {
32     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
33 }
34 contract Owned {
35     address public owner;
36     address public newOwner;
37     event OwnershipTransferred(address indexed _from, address indexed _to);
38     function Owned() public {
39         owner = msg.sender;
40     }
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 contract CamCoin is ERC20Interface, Owned {
56     using SafeMath for uint;
57     string public symbol;
58     string public  name;
59     uint8 public decimals;
60     uint public _totalSupply;
61     mapping(address => uint) balances;
62     mapping(address => mapping(address => uint)) allowed;
63     function CamCoin() public {
64         symbol = "CAM";
65         name = "CamCoin";
66         decimals = 0;
67         _totalSupply = 31135181514;
68         balances[owner] = _totalSupply;
69         Transfer(address(0), owner, _totalSupply);
70     }
71     function totalSupply() public constant returns (uint) {
72         return _totalSupply  - balances[address(0)];
73     }
74     function balanceOf(address tokenOwner) public constant returns (uint balance) {
75         return balances[tokenOwner];
76     }
77     function transfer(address to, uint tokens) public returns (bool success) {
78         balances[msg.sender] = balances[msg.sender].sub(tokens);
79         balances[to] = balances[to].add(tokens);
80         Transfer(msg.sender, to, tokens);
81         return true;
82     }
83     function approve(address spender, uint tokens) public returns (bool success) {
84         allowed[msg.sender][spender] = tokens;
85         Approval(msg.sender, spender, tokens);
86         return true;
87     }
88     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
89         balances[from] = balances[from].sub(tokens);
90         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
91         balances[to] = balances[to].add(tokens);
92         Transfer(from, to, tokens);
93         return true;
94     }
95     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
96         return allowed[tokenOwner][spender];
97     }
98     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
99         allowed[msg.sender][spender] = tokens;
100         Approval(msg.sender, spender, tokens);
101         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
102         return true;
103     }
104     function () public payable {
105         revert();
106     }
107     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
108         return ERC20Interface(tokenAddress).transfer(owner, tokens);
109     }
110 }
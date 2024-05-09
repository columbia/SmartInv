1 pragma solidity ^0.5.2;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 contract ApproveAndCallFallBack {
21     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
22 }
23 contract EtherReserve {
24     using SafeMath for uint;
25     address public owner = address(0);
26     string public symbol;
27     string public  name;
28     uint8 public decimals = 18;
29     string public descriptions;
30     uint _totalSupply;
31     mapping(address => uint) balances;
32     mapping(address => mapping(address => uint)) allowed;
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35     constructor (string memory _name, string memory _symbol, string memory _description) public {
36         name = _name;
37         symbol = _symbol;
38         descriptions = _description;
39         emit Transfer(address(this), owner, 1e26);
40     }
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45     function totalSupply() public view returns (uint) {
46         return _totalSupply  - balances[address(0)];
47     }
48     function balanceOf(address tokenOwner) public view returns (uint balance) {
49         return balances[tokenOwner];
50     }
51     function transfer(address to, uint tokens) public returns (bool success) {
52         balances[msg.sender] = balances[msg.sender].sub(tokens);
53         if (to == address(this)) {
54             msg.sender.transfer(tokens);
55             _totalSupply = _totalSupply.sub(tokens);
56             emit Transfer(msg.sender, address(0), tokens);
57         } else {
58             balances[to] = balances[to].add(tokens);
59             emit Transfer(msg.sender, to, tokens);
60         }
61         return true;
62     }
63     function approve(address spender, uint tokens) public returns (bool success) {
64         if (spender == address(this)) revert();
65         allowed[msg.sender][spender] = tokens;
66         emit Approval(msg.sender, spender, tokens);
67         return true;
68     }
69     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
70         balances[from] = balances[from].sub(tokens);
71         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
72         balances[to] = balances[to].add(tokens);
73         emit Transfer(from, to, tokens);
74         return true;
75     }
76     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
77         return allowed[tokenOwner][spender];
78     }
79     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
80         allowed[msg.sender][spender] = tokens;
81         emit Approval(msg.sender, spender, tokens);
82         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
83         return true;
84     }
85     function () external payable {
86         if (msg.value > 0) tokenize();
87     }
88     function tokenize() public payable {
89         require(msg.value > 0);
90         _totalSupply = _totalSupply.add(msg.value);
91         balances[msg.sender] = balances[msg.sender].add(msg.value);
92         emit Transfer(address(0), msg.sender, msg.value);
93     }
94 }
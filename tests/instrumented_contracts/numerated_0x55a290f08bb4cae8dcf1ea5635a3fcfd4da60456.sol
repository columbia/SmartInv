1 pragma solidity 0.7.1;
2 
3     library SafeMath {
4         function add(uint a, uint b) internal pure returns (uint c) {
5             c = a + b;
6             require(c >= a);
7         }
8         function sub(uint a, uint b) internal pure returns (uint c) {
9             require(b <= a);
10             c = a - b;
11         }
12         function mul(uint a, uint b) internal pure returns (uint c) {
13             c = a * b;
14             require(a == 0 || c / a == b);
15         }
16         function div(uint a, uint b) internal pure returns (uint c) {
17             require(b > 0);
18             c = a / b;
19         }
20     }
21 
22     interface ERC20Interface {
23         function totalSupply() external view returns (uint256);
24         function balanceOf(address account) external view returns (uint256);
25         function transfer(address recipient, uint256 amount) external returns (bool);
26         function allowance(address owner, address spender) external view returns (uint256);
27         function approve(address spender, uint256 amount) external returns (bool);
28         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29 
30         event Transfer(address indexed from, address indexed to, uint256 value);
31         event Approval(address indexed owner, address indexed spender, uint256 value);
32     }
33 
34 
35     abstract contract ApproveAndCallFallBack {
36         function receiveApproval(address from, uint256 tokens, address token, bytes memory data) virtual public;
37     }
38 
39     contract Owned {
40         address public owner;
41         address public newOwner;
42 
43         event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45         constructor() public  {
46             owner = msg.sender;
47         }
48 
49         modifier onlyOwner {
50             require(msg.sender == owner);
51             _;
52         }
53 
54         function transferOwnership(address _newOwner) public onlyOwner {
55             newOwner = _newOwner;
56         }
57         function acceptOwnership() public {
58             require(msg.sender == newOwner);
59             emit OwnershipTransferred(owner, newOwner);
60             owner = newOwner;
61             newOwner = address(0);
62         }
63     }
64 
65     contract BITTO is ERC20Interface, Owned {
66         using SafeMath for uint;
67 
68         string public symbol;
69         string public  name;
70         uint8 public decimals;
71         uint _totalSupply;
72 
73         mapping(address => uint) balances;
74         mapping(address => mapping(address => uint)) allowed;
75 
76         constructor() public {
77             symbol = "BITTO";
78             name = "BITTO";
79             decimals = 18;
80             _totalSupply = 17709627 * 10**uint(decimals);
81             balances[owner] = _totalSupply;
82             emit Transfer(address(0), owner, _totalSupply);
83         }
84 
85         function totalSupply() public view override returns (uint) {
86             return _totalSupply.sub(balances[address(0)]);
87         }
88 
89         function balanceOf(address tokenOwner) public view override returns (uint balance) {
90             return balances[tokenOwner];
91         }
92 
93         function transfer(address to, uint tokens) public override returns (bool success) {
94             balances[msg.sender] = balances[msg.sender].sub(tokens);
95             balances[to] = balances[to].add(tokens);
96             emit Transfer(msg.sender, to, tokens);
97             return true;
98         }
99 
100         function approve(address spender, uint tokens) public override returns (bool success) {
101             allowed[msg.sender][spender] = tokens;
102             emit Approval(msg.sender, spender, tokens);
103             return true;
104         }
105 
106         function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
107             balances[from] = balances[from].sub(tokens);
108             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
109             balances[to] = balances[to].add(tokens);
110             emit Transfer(from, to, tokens);
111             return true;
112         }
113 
114 
115         function allowance(address tokenOwner, address spender) public view override returns (uint remaining) {
116             return allowed[tokenOwner][spender];
117         }
118 
119 
120         function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
121             allowed[msg.sender][spender] = tokens;
122             emit Approval(msg.sender, spender, tokens);
123             ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
124             return true;
125         }
126 
127         fallback () external {
128             revert();
129         }
130 
131 
132         function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
133             return ERC20Interface(tokenAddress).transfer(owner, tokens);
134         }
135     }
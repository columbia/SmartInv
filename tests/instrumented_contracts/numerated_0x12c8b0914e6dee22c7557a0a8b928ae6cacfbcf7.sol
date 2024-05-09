1 pragma solidity 0.5.9;
2 
3 library SafeMath {
4 	function add(uint a, uint b) internal pure returns (uint c) {
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
23 	function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 contract ServiceInterface { 
34 	function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public; 
35 }
36 
37 contract StorexOwner {
38 	address public owner;
39 	
40 	event OwnershipTransferred(address indexed _from, address indexed _to);
41 	
42 	constructor() public {
43 		owner = msg.sender;
44 	}
45 	
46 	modifier isOwner {
47 		require(msg.sender == owner);
48 		_;
49 	}
50 	
51 	function transferOwnership(address _newOwner) public isOwner {
52 		owner = _newOwner;
53 		emit OwnershipTransferred(msg.sender, _newOwner);
54 	}
55 }
56 
57 contract StorexToken is ERC20Interface, StorexOwner {
58 	using SafeMath for uint;
59 	
60 	string public name;
61 	string public symbol;
62 	uint8 public decimals;
63 	uint256 public _totalSupply;
64 	
65 	mapping(address => uint256) balances;
66 	mapping(address => mapping(address => uint256)) allowed;
67 	
68 	constructor() public {
69 		name = "Storex";
70 		symbol = "STRX";
71 		decimals = 18;
72 		_totalSupply = 2000000 * 10**uint(decimals);
73 		
74 		balances[owner] = _totalSupply;
75 		emit Transfer(address(0), owner, _totalSupply);
76 	}
77 	
78 	function totalSupply() public view returns (uint256) {
79 		return _totalSupply.sub(balances[address(0)]);
80 	}
81 	
82 	function balanceOf(address tokenOwner) public view returns (uint256 balance) {
83 		return balances[tokenOwner];
84 	}
85 	
86 	function transfer(address to, uint tokens) public returns (bool success) {
87         balances[msg.sender] = balances[msg.sender].sub(tokens);
88         balances[to] = balances[to].add(tokens);
89         emit Transfer(msg.sender, to, tokens);
90         return true;
91     }
92 	
93 	function approve(address spender, uint tokens) public returns (bool success) {
94         allowed[msg.sender][spender] = tokens;
95         emit Approval(msg.sender, spender, tokens);
96         return true;
97     }
98 	
99 	function transferFrom(address from, address to, uint tokens) public returns (bool success) {
100         balances[from] = balances[from].sub(tokens);
101         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
102         balances[to] = balances[to].add(tokens);
103         emit Transfer(from, to, tokens);
104         return true;
105     }
106 	
107 	function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
108         return allowed[tokenOwner][spender];
109     }
110 	
111 	function() external payable {
112         revert();
113     }
114     
115     function approveAndCall(address spender, uint256 value, bytes memory extraData) public returns (bool success) {
116 		ServiceInterface service = ServiceInterface(spender);
117 		if (approve(spender, value)) {
118 			service.receiveApproval(msg.sender, value, address(this), extraData);
119 			return true;
120 		}
121 	}
122 	
123 	function transferAnyERC20Token(address tokenAddress, uint tokens) public isOwner returns (bool success) {
124         return ERC20Interface(tokenAddress).transfer(owner, tokens);
125     }
126 }
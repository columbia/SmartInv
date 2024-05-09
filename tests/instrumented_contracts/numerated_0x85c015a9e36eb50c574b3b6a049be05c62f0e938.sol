1 pragma solidity ^0.4.0;
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
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 
35 contract ApproveAndCallFallBack {
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
37 }
38 
39 contract Owned {
40     address public owner;
41     address public newOwner;
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
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     
58     function acceptOwnership() public {
59         require(msg.sender == newOwner);
60         emit OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62         newOwner = address(0);
63     }
64 }
65 
66 /**
67  * @title Contactable token
68  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
69  * contact information.
70  */
71 contract Contactable is Owned {
72 
73     string public contactInformation;
74 
75     /**
76      * @dev Allows the owner to set a string with their contact information.
77      * @param info The contact information to attach to the contract.
78      */
79     function setContactInformation(string info) onlyOwner public {
80          contactInformation = info;
81      }
82 }
83 
84 
85 contract QUIGToken is ERC20Interface, Contactable {
86     using SafeMath for uint;
87 
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint256 _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95     
96     constructor() public {
97         symbol = "QUIG";
98         name = "QUIG Token";
99         decimals = 18;
100         _totalSupply = 536870912 * uint256(10 ** 18);
101         balances[owner] = _totalSupply;
102         emit Transfer(address(0), owner, _totalSupply);
103     }
104 
105 
106     
107     function totalSupply() public view returns (uint) {
108         return _totalSupply.sub(balances[address(0)]);
109     }
110 
111 
112     
113     function balanceOf(address tokenOwner) public view returns (uint balance) {
114         return balances[tokenOwner];
115     }
116 
117 
118     
119     function transfer(address to, uint tokens) public returns (bool success) {
120         balances[msg.sender] = balances[msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126     function approve(address spender, uint tokens) public returns (bool success) {
127         allowed[msg.sender][spender] = tokens;
128         emit Approval(msg.sender, spender, tokens);
129         return true;
130     }
131 
132     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
133         balances[from] = balances[from].sub(tokens);
134         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
135         balances[to] = balances[to].add(tokens);
136         emit Transfer(from, to, tokens);
137         return true;
138     }
139 
140 
141     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
142         return allowed[tokenOwner][spender];
143     }
144 
145 
146     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
150         return true;
151     }
152 
153 }
1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint256);
24     function balanceOf(address Owner) public constant returns (uint256 balance);
25     function allowance(address Owner, address spender) public constant returns (uint256 remaining);
26     function transfer(address to, uint256 value) public returns (bool success);
27     function approve(address spender, uint256 value) public returns (bool success);
28     function transferFrom(address from, address to, uint256 value) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed Owner, address indexed spender, uint256 value);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 value, address token, bytes data) public;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed from, address indexed to);
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
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract Vioscoin is ERC20Interface, Owned, SafeMath {
65     string public symbol;
66     string public  name;
67     uint8 public decimals;
68     uint public _totalSupply;
69 
70     mapping(address => uint256) balances;
71     mapping(address => mapping(address => uint256)) allowed;
72 
73     constructor() public {
74         symbol = "VIS";
75         name = "Vioscoin";
76         decimals = 18;
77         _totalSupply = 5000000000000000000000000;
78         balances[0x67e9911D9275389dB0599BE60b1Be5C8850Df7b1] = _totalSupply;
79         emit Transfer(address(0), 0x67e9911D9275389dB0599BE60b1Be5C8850Df7b1, _totalSupply);
80     }
81 
82     function totalSupply() public constant returns (uint256) {
83         return _totalSupply - balances[address(0)];
84     }
85 
86     function balanceOf(address _Owner) public constant returns (uint256 balance) {
87         return balances[_Owner];
88     }
89 
90     function transfer(address to, uint256 _value) public returns (bool success) {
91         balances[msg.sender] = safeSub(balances[msg.sender], _value);
92         balances[to] = safeAdd(balances[to], _value);
93         emit Transfer(msg.sender, to, _value);
94         return true;
95     }
96 
97     function approve(address spender, uint256 _value) public returns (bool success) {
98         allowed[msg.sender][spender] = _value;
99         emit Approval(msg.sender, spender, _value);
100         return true;
101     }
102 
103     function transferFrom(address _from, address _to, uint256  _value) public returns (bool success) {
104         balances[_from] = safeSub(balances[_from],  _value);
105         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
106         balances[_to] = safeAdd(balances[_to],  _value);
107         emit Transfer(_from, _to,  _value);
108         return true;
109     }
110 
111     
112     function allowance(address Owner, address _spender) public constant returns (uint256 remaining) {
113         return allowed[Owner][_spender];
114     }
115 
116     function approveAndCall(address _spender, uint256 _value, bytes data) public returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         emit Approval(msg.sender, _spender, _value);
119         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, data);
120         return true;
121     }
122 
123     function () public payable {
124         revert();
125     }
126 
127     function transferAnyERC20Token(address Address, uint256 _value) public onlyOwner returns (bool success) {
128         return ERC20Interface(Address).transfer(owner, _value);
129     }
130 }
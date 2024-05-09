1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Name Coin   : UNOCALL Cryptocurrency With ERC20 Blockchain Technology
5 // Symbol      : CAL
6 // Total supply: 99.000.000 CAL
7 // Decimals    : 18
8 // Owner       : 0x04806c4c164d6CEfEE1a2b657f967cE1Db363dD2
9 // ----------------------------------------------------------------------------
10 
11 contract SafeMath {
12     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint256);
32     function balanceOf(address Owner) public constant returns (uint256 balance);
33     function allowance(address Owner, address spender) public constant returns (uint256 remaining);
34     function transfer(address to, uint256 value) public returns (bool success);
35     function approve(address spender, uint256 value) public returns (bool success);
36     function transferFrom(address from, address to, uint256 value) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed Owner, address indexed spender, uint256 value);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 value, address token, bytes data) public;
44 }
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed from, address indexed to);
51 
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         emit OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68         newOwner = address(0);
69     }
70 }
71 
72 contract UNOCALL is ERC20Interface, Owned, SafeMath {
73     string public symbol;
74     string public  name;
75     uint8 public decimals;
76     uint public _totalSupply;
77 
78     mapping(address => uint256) balances;
79     mapping(address => mapping(address => uint256)) allowed;
80 
81     constructor() public {
82         symbol = "CALL";
83         name = "UNOCALL";
84         decimals = 18;
85         _totalSupply = 99000000000000000000000000;
86         balances[0x04806c4c164d6CEfEE1a2b657f967cE1Db363dD2] = _totalSupply;
87         emit Transfer(address(0), 0x04806c4c164d6CEfEE1a2b657f967cE1Db363dD2, _totalSupply);
88     }
89 
90     function totalSupply() public constant returns (uint256) {
91         return _totalSupply - balances[address(0)];
92     }
93 
94     function balanceOf(address _Owner) public constant returns (uint256 balance) {
95         return balances[_Owner];
96     }
97 
98     function transfer(address to, uint256 _value) public returns (bool success) {
99         balances[msg.sender] = safeSub(balances[msg.sender], _value);
100         balances[to] = safeAdd(balances[to], _value);
101         emit Transfer(msg.sender, to, _value);
102         return true;
103     }
104 
105     function approve(address spender, uint256 _value) public returns (bool success) {
106         allowed[msg.sender][spender] = _value;
107         emit Approval(msg.sender, spender, _value);
108         return true;
109     }
110 
111     function transferFrom(address _from, address _to, uint256  _value) public returns (bool success) {
112         balances[_from] = safeSub(balances[_from],  _value);
113         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
114         balances[_to] = safeAdd(balances[_to],  _value);
115         emit Transfer(_from, _to,  _value);
116         return true;
117     }
118 
119     
120     function allowance(address Owner, address _spender) public constant returns (uint256 remaining) {
121         return allowed[Owner][_spender];
122     }
123 
124     function approveAndCall(address _spender, uint256 _value, bytes data) public returns (bool success) {
125         allowed[msg.sender][_spender] = _value;
126         emit Approval(msg.sender, _spender, _value);
127         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, this, data);
128         return true;
129     }
130 
131     function () public payable {
132         revert();
133     }
134 
135     function transferAnyERC20Token(address Address, uint256 _value) public onlyOwner returns (bool success) {
136         return ERC20Interface(Address).transfer(owner, _value);
137     }
138 }
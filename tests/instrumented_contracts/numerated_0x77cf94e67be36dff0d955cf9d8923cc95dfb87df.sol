1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4     function safeAdd(uint _a, uint _b) public pure returns (uint c) {
5         c = _a + _b;
6         require(c >= _a);
7     }
8     function safeSub(uint _a, uint _b) public pure returns (uint c) {
9         require(_b <= _a);
10         c = _a - _b;
11     }
12 }
13 
14 contract ERC20Interface {
15     function totalSupply() public view returns (uint);
16     function balanceOf(address _tokenOwner) public view returns (uint balance);
17     function allowance(address _tokenOwner, address spender) public view returns (uint remaining);
18     function transfer(address _to, uint _tokens) public returns (bool success);
19     function approve(address _spender, uint _tokens) public returns (bool success);
20     function transferFrom(address _from, address _to, uint _tokens) public returns (bool success);
21 
22     event Transfer(address indexed _from, address indexed _to, uint _tokens);
23     event Approval(address indexed _tokenOwner, address indexed _spender, uint _tokens);
24 }
25 
26 contract ApproveAndCallFallBack {
27     function receiveApproval(address _from, uint256 _tokens, address _token, bytes _extraData) public;
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 contract Pausable is Owned {
57   event Paused();
58   event Unpaused();
59 
60   bool public paused = false;
61 
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   function pause() public onlyOwner whenNotPaused {
73     paused = true;
74     emit Paused();
75   }
76 
77   function unpause() public onlyOwner whenPaused {
78     paused = false;
79     emit Unpaused();
80   }
81 }
82 
83 
84 contract TestCoin is ERC20Interface, Pausable, SafeMath {
85     string public symbol;
86     string public  name;
87     uint8 public decimals;
88     uint public _totalSupply;
89 
90     mapping(address => uint) balances;
91     mapping(address => mapping(address => uint)) internal allowed;
92 
93     constructor() public {
94         symbol = "TTC";
95         name = "TestCoin";
96         decimals = 0;
97         _totalSupply = 1000000;
98         balances[0x2FFFA2252DE563d6a3430e970eA47A5C7C79aa1a] = _totalSupply;
99         emit Transfer(address(0), 0x2FFFA2252DE563d6a3430e970eA47A5C7C79aa1a, _totalSupply);
100     }
101 
102 
103     function totalSupply() public view returns (uint) {
104         return _totalSupply  - balances[address(0)];
105     }
106 
107     function balanceOf(address _tokenOwner) public view returns (uint balance) {
108         return balances[_tokenOwner];
109     }
110 
111     function transfer(address _to, uint _tokens) public returns (bool success) {
112         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
113         balances[_to] = safeAdd(balances[_to], _tokens);
114         emit Transfer(msg.sender, _to, _tokens);
115         return true;
116     }
117 
118     function approve(address _spender, uint _tokens) public whenNotPaused  returns (bool success) {
119         allowed[msg.sender][_spender] = _tokens;
120         emit Approval(msg.sender, _spender, _tokens);
121         return true;
122     }
123 
124     function transferFrom(address _from, address _to, uint _tokens) public whenNotPaused returns (bool success) {
125         balances[_from] = safeSub(balances[_from], _tokens);
126         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _tokens);
127         balances[_to] = safeAdd(balances[_to], _tokens);
128         emit Transfer(_from, _to, _tokens);
129         return true;
130     }
131 
132     function allowance(address _tokenOwner, address _spender) public view returns (uint remaining) {
133         return allowed[_tokenOwner][_spender];
134     }
135 
136     function approveAndCall(address _spender, uint _tokens, bytes _extraData) public returns (bool success) {
137         allowed[msg.sender][_spender] = _tokens;
138         emit Approval(msg.sender, _spender, _tokens);
139         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _tokens, this, _extraData);
140         return true;
141     }
142 }
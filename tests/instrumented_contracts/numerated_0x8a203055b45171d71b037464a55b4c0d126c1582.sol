1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4     function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
10         require(b <= a);
11         c = a - b;
12     }
13 }
14 
15 
16 contract ERC20Interface {
17     function totalSupply() public view returns (uint256);
18     function balanceOf(address tokenOwner) public view returns (uint256);
19     function allowance(address tokenOwner, address spender) public view returns (uint256);
20     function transfer(address to, uint256 tokens) public returns (bool);
21     function approve(address spender, uint256 tokens) public returns (bool);
22     function transferFrom(address from, address to, uint256 tokens) public returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
26 }
27 
28 
29 // ----------------------------------------------------------------------------
30 // Owned contract
31 // ----------------------------------------------------------------------------
32 contract Owned {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed _from, address indexed _to);
36 
37     function Owned() public {
38         owner = msg.sender;
39     }
40 
41     function transferOwnership(address _newOwner) public {
42         require(msg.sender == owner);
43         owner = _newOwner;
44     }
45 }
46 
47 contract ToniToken is ERC20Interface, Owned, SafeMath {
48 
49     string constant public symbol = "TOTO";
50     string constant public name = "Toni Token";
51     uint8 constant public decimals = 2;
52 
53     //SNB M3: 2018-01, 1036.941 Mrd. CHF
54     uint256 public totalSupply = 1000 * 10**uint256(decimals);
55 
56     mapping(address => uint256) public balances;
57     mapping(address => mapping(address => uint256)) public allowed;
58 
59     event Migrate(address indexed _from, address indexed _to, uint256 _value);
60 
61     function ToniToken() public {
62         balances[msg.sender] = totalSupply;
63         emit Transfer(address(0), msg.sender, totalSupply);
64     }
65 
66     function () public payable {
67         revert();
68     }
69 
70     function totalSupply() public view returns (uint256) {
71         return totalSupply;
72     }
73 
74     function balanceOf(address _tokenOwner) public view returns (uint256) {
75         return balances[_tokenOwner];
76     }
77 
78     function transfer(address _to, uint256 _tokens) public returns (bool) {
79         balances[msg.sender] = safeSub(balances[msg.sender], _tokens);
80         balances[_to] = safeAdd(balances[_to], _tokens);
81         emit Transfer(msg.sender, _to, _tokens);
82         return true;
83     }
84 
85     function bulkTransfer(address[] _tos, uint256[] _tokens) public returns (bool) {
86 
87         for (uint i = 0; i < _tos.length; i++) {
88             require(transfer(_tos[i], _tokens[i]));
89         }
90 
91         return true;
92     }
93 
94     function approve(address _spender, uint256 _tokens) public returns (bool) {
95         allowed[msg.sender][_spender] = _tokens;
96         emit Approval(msg.sender, _spender, _tokens);
97         return true;
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool) {
101         balances[_from] = safeSub(balances[_from], _tokens);
102         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _tokens);
103         balances[_to] = safeAdd(balances[_to], _tokens);
104         emit Transfer(_from, _to, _tokens);
105         return true;
106     }
107 
108     function allowance(address _tokenOwner, address _spender) public view returns (uint256) {
109         return allowed[_tokenOwner][_spender];
110     }
111 }
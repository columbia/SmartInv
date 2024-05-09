1 pragma solidity ^0.5.5;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract WuzuStandardToken is ERC20Interface, SafeMath {
35     string public symbol;
36     string public  name;
37     uint8 public decimals;
38     uint public _totalSupply;
39     address private _owner;
40     string private _uri;
41 
42     mapping(address => uint) balances;
43     mapping(address => mapping(address => uint)) allowed;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46     event UriChanged(string previousUri, string newUri);
47 
48     constructor(string memory _symbol, uint8 _decimals, string memory _tokenUri) public {
49         require(bytes(_tokenUri).length <= 255);
50         symbol = _symbol;
51         name = _symbol;
52         decimals = _decimals;
53         _totalSupply = 0;
54         _owner = msg.sender;
55         _uri = _tokenUri;
56         emit OwnershipTransferred(address(0), _owner);
57         emit UriChanged("", _uri);
58     }
59 
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     modifier onlyOwner() {
65         require(msg.sender == _owner, "caller is not the owner");
66         _;
67     }
68 
69     function transferOwnership(address newOwner) public onlyOwner {
70         require(newOwner != address(0), "new owner can't be the zero address");
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 
75     function totalSupply() public view returns (uint) {
76         return _totalSupply  - balances[address(0)];
77     }
78 
79     function balanceOf(address tokenOwner) public view returns (uint balance) {
80         return balances[tokenOwner];
81     }
82 
83     function tokenURI() external view returns (string memory) {
84         return _uri;
85     }
86 
87     function changeUri(string memory newUri) public onlyOwner {
88         require(bytes(newUri).length <= 255);
89         emit UriChanged(_uri, newUri);
90         _uri = newUri;
91     }
92 
93     function transfer(address to, uint tokens) public returns (bool success) {
94         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
95         balances[to] = safeAdd(balances[to], tokens);
96         emit Transfer(msg.sender, to, tokens);
97         return true;
98     }
99 
100     function approve(address spender, uint tokens) public returns (bool success) {
101         allowed[msg.sender][spender] = tokens;
102         emit Approval(msg.sender, spender, tokens);
103         return true;
104     }
105 
106     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
107         balances[from] = safeSub(balances[from], tokens);
108         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
109         balances[to] = safeAdd(balances[to], tokens);
110         emit Transfer(from, to, tokens);
111         return true;
112     }
113 
114     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
115         return allowed[tokenOwner][spender];
116     }
117 
118     function mint(address to, uint tokens) public onlyOwner {
119         balances[to] = safeAdd(balances[to], tokens);
120         _totalSupply += tokens;
121         emit Transfer(address(0), to, tokens);
122     }
123 
124     function () external payable {
125         revert();
126     }
127 }
1 pragma solidity 0.4.25;
2 
3 contract HomburgerToken {
4     string public constant name = "Homburger Token";
5     string public constant symbol = "HOM";
6     uint256 public constant decimals = 18;
7     address public owner;
8     uint256 public _totalSupply;
9     mapping(address => uint256) public balances;
10     mapping(address => mapping(address => uint256)) public allowed;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 
15     constructor() public {
16         owner = msg.sender;
17     }
18 
19     function totalSupply() public view returns (uint256) {
20         return _totalSupply;
21     }
22 
23     function balanceOf(address tokenOwner) public view returns (uint256) {
24         return balances[tokenOwner];
25     }
26    
27     function allowance(
28         address tokenOwner, 
29         address spender
30     )
31         public 
32         view 
33         returns (uint256) 
34     {
35         return allowed[tokenOwner][spender];
36     }
37 
38 
39     function transfer(address to, uint256 value) public returns (bool) {
40         require(balances[msg.sender] >= value);
41         require(to != address(0));
42         
43         balances[msg.sender] -= value;
44         balances[to] += value;
45         emit Transfer(msg.sender, to, value);
46         return true;
47     }
48 
49    function approve(address spender, uint256 value) public returns (bool) {
50         require(spender != address(0));
51         
52         allowed[msg.sender][spender] = value; 
53         emit Approval(msg.sender, spender, value);
54         return true;
55     }
56 
57     
58    function transferFrom(
59         address from, 
60         address to, 
61         uint256 value
62     ) 
63         public 
64         returns (bool) 
65     {
66         require(allowed[from][msg.sender] >= value);
67         require(balances[from] >= value);
68         require(to != address(0));
69         
70         allowed[from][msg.sender] -= value;
71         balances[from] -= value;
72         balances[to] += value;
73         emit Transfer(from, to, value);
74         return true;
75     }
76     
77     function mint(address to, uint256 value) public returns(bool) {
78         require(msg.sender == owner);
79         require(to != address(0));
80         
81         _totalSupply += value;
82         balances[to] += value;
83         emit Transfer(address(0), to, value);
84         return true;
85     }
86     
87     function transferOwner(address _newOwner) public {
88         require(msg.sender == owner);
89         require(_newOwner != address(0));
90         
91         owner = _newOwner;
92     }
93 }
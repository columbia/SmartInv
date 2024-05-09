1 pragma solidity ^0.4.25;
2 
3 
4 contract ERC20Interface {
5     function totalSupply() public view returns (uint);
6     function balanceOf(address tokenOwner) public view returns (uint balance);
7     function transfer(address to, uint tokens) public returns (bool success);
8     event Transfer(address indexed from, address indexed to, uint tokens);
9     
10 }
11 
12 
13 contract BBCToken is ERC20Interface {
14     string public symbol;
15     string public  name;
16     uint8 public decimals;
17     uint256 public _totalSupply;
18 
19     mapping(address => uint256) balances;
20     mapping(address => mapping(address => uint256)) allowed;
21 
22 
23 
24  function safeAdd(uint a, uint b) public pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28     function safeSub(uint a, uint b) public pure returns (uint c) {
29         require(b <= a);
30         c = a - b;
31     }
32     function safeMul(uint a, uint b) public pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36     function safeDiv(uint a, uint b) public pure returns (uint c) {
37         require(b > 0);
38         c = a / b;
39     }
40     
41     
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor(uint256 total) public {
48         owner = msg.sender;
49         BBCTOKEN(total);
50     }
51 
52     modifier onlyOwner {
53         require(msg.sender == owner);
54         _;
55     }
56 
57     function transferOwnership(address _newOwner) public onlyOwner {
58         newOwner = _newOwner;
59     }
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66     // ------------------------------------------------------------------------
67     // Constructor
68     // ------------------------------------------------------------------------
69     function BBCTOKEN(uint256 total) public {
70         symbol = "BBC";
71         name = "BBC TOKEN";
72         decimals = 18;
73         _totalSupply = total;
74         balances[msg.sender] = _totalSupply;
75        
76     }
77 
78 
79     // ------------------------------------------------------------------------
80     // Total supply
81     // ------------------------------------------------------------------------
82     function totalSupply() public view returns (uint) {
83         return _totalSupply;
84     }
85 
86 
87     // ------------------------------------------------------------------------
88     // Get the token balance for account tokenOwner
89     // ------------------------------------------------------------------------
90     function balanceOf(address tokenOwner) public view returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
96         balances[to] = safeAdd(balances[to], tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101 }
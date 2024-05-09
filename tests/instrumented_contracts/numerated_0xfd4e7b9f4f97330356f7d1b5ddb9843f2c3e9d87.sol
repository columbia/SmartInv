1 pragma solidity ^0.4.24;
2 
3 contract TCOMDividend {
4 
5     string public name = "TCOM Dividend";
6     string public symbol = "TCOMD";
7 
8     // This code assumes decimals is zero
9     uint8 public decimals = 0;
10 
11     uint256 public totalSupply = 10000 * (uint256(10) ** decimals);
12 
13     mapping(address => uint256) public balanceOf;
14 
15     constructor() public {
16         // Initially assign all tokens to the contract's creator.
17         balanceOf[msg.sender] = totalSupply;
18         emit Transfer(address(0), msg.sender, totalSupply);
19     }
20 
21     mapping(address => uint256) public dividendBalanceOf;
22 
23     uint256 public dividendPerToken;
24 
25     mapping(address => uint256) public dividendCreditedTo;
26 
27     function update(address account) internal {
28         uint256 owed =
29         dividendPerToken - dividendCreditedTo[account];
30         dividendBalanceOf[account] += balanceOf[account] * owed;
31         dividendCreditedTo[account] = dividendPerToken;
32     }
33 
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 
37     mapping(address => mapping(address => uint256)) public allowance;
38 
39     function () public payable {
40         dividendPerToken += msg.value / totalSupply;  // ignoring remainder
41     }
42 
43     function transfer(address to, uint256 value) public returns (bool success) {
44         require(balanceOf[msg.sender] >= value);
45 
46         update(msg.sender);  // <-- added to simple ERC20 contract
47         update(to);          // <-- added to simple ERC20 contract
48 
49         balanceOf[msg.sender] -= value;
50         balanceOf[to] += value;
51 
52         emit Transfer(msg.sender, to, value);
53         return true;
54     }
55 
56     function transferFrom(address from, address to, uint256 value)
57     public
58     returns (bool success)
59     {
60         require(value <= balanceOf[from]);
61         require(value <= allowance[from][msg.sender]);
62 
63         update(from);        // <-- added to simple ERC20 contract
64         update(to);          // <-- added to simple ERC20 contract
65 
66         balanceOf[from] -= value;
67         balanceOf[to] += value;
68         allowance[from][msg.sender] -= value;
69         emit Transfer(from, to, value);
70         return true;
71     }
72 
73     function withdraw() public {
74         update(msg.sender);
75         uint256 amount = dividendBalanceOf[msg.sender];
76         dividendBalanceOf[msg.sender] = 0;
77         msg.sender.transfer(amount);
78     }
79 
80     function approve(address spender, uint256 value)
81     public
82     returns (bool success)
83     {
84         allowance[msg.sender][spender] = value;
85         emit Approval(msg.sender, spender, value);
86         return true;
87     }
88 
89 }
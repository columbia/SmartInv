1 pragma solidity ^0.4.19;
2 
3 contract ERC20 {
4 
5     function totalSupply() public constant returns (uint);
6 
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8 
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10 
11     function transfer(address to, uint tokens) public returns (bool success);
12 
13     function approve(address spender, uint tokens) public returns (bool success);
14 
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16 
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19 
20     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
21 
22 }
23 
24 
25 contract MainToken is ERC20{
26     string public constant name = "MemRobot";
27     string public constant symbol = "ROBOT";
28     uint8 public constant decimals = 18;
29     
30     address founder;
31     uint256 public totalAmount;
32     
33     mapping(address => uint256) public balances;
34     mapping(address => mapping(address => uint256)) allowed;
35     
36     function MainToken() public{
37         founder = msg.sender;
38         uint256 amount = 2 * 10**8 * 10**18;
39         
40         balances[founder] = amount;
41         totalAmount = amount;
42     }
43     
44     function totalSupply() public constant returns (uint){
45         return totalAmount;
46     }
47 
48     function balanceOf(address tokenOwner) public constant returns (uint the_balance){
49         return balances[tokenOwner];
50     }
51     
52     function _transfer(address from, address to, uint tokens) private returns (bool success){
53         require(tokens <= balances[from]);
54         balances[from] -= tokens;
55         balances[to] += tokens;
56         Transfer(from, to, tokens);
57         return true;
58     }
59 
60     function transfer(address to, uint tokens) public returns (bool success){
61         return _transfer(msg.sender, to, tokens);
62     }
63     
64     function approve(address spender, uint tokens) public returns (bool success) {
65         allowed[msg.sender][spender] = tokens;
66         Approval(msg.sender, spender, tokens);
67         return true;
68     }
69     
70     function allowance(address tokenOwner, address spender) public constant returns (uint remaining){
71         return allowed[tokenOwner][spender];
72     }
73     
74     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
75         require(allowed[from][msg.sender] >= tokens);
76         
77         allowed[from][msg.sender] -= tokens;
78         _transfer(from, to, tokens);
79         return true;
80     }
81 }
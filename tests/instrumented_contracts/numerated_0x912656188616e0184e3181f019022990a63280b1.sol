1 pragma solidity 0.5.8;
2 
3 contract ProofOfContributionChainToken {
4     string public constant  name= "POCC";
5     string public constant  symbol = "POCC";
6     uint8 public constant decimals = 8;
7 
8     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
9     event Transfer(address indexed from, address indexed to, uint tokens);
10 
11     mapping (address => uint256) internal balances;
12     mapping (address => mapping (address => uint256)) internal allowed;
13 
14     uint256 public totalSupply;
15     address public owner;
16 
17     using SafeMath for uint256;
18 
19     constructor() public {
20         totalSupply = 1000000000e8;
21         owner = msg.sender;
22         balances[owner] = totalSupply;
23     }
24 
25     function balanceOf(address tokenOwner) public view returns (uint) {
26         return balances[tokenOwner];
27     }
28 
29     function transfer(address receiver, uint numTokens) public returns (bool) {
30         require(numTokens <= balances[msg.sender]);
31         balances[msg.sender] = balances[msg.sender].sub(numTokens);
32         balances[receiver] = balances[receiver].add(numTokens);
33         emit Transfer(msg.sender, receiver, numTokens);
34         return true;
35     }
36 
37     function approve(address delegate, uint numTokens) public returns (bool) {
38         allowed[msg.sender][delegate] = numTokens;
39         emit Approval(msg.sender, delegate, numTokens);
40         return true;
41     }
42 
43     function allowance(address from, address delegate) public view returns (uint) {
44         return allowed[from][delegate];
45     }
46 
47     function transferFrom(address from, address buyer, uint numTokens) public returns (bool) {
48         require(numTokens <= balances[from]);
49         require(numTokens <= allowed[from][msg.sender]);
50 
51         balances[from] = balances[from].sub(numTokens);
52         allowed[from][msg.sender] = allowed[from][msg.sender].sub(numTokens);
53         balances[buyer] = balances[buyer].add(numTokens);
54         emit Transfer(from, buyer, numTokens);
55         return true;
56     }
57 
58     function burnFrom(address from, uint numTokens) public returns (bool) {
59         require(numTokens <= balances[from]);
60         require(msg.sender == owner);
61         balances[from] = balances[from].sub(numTokens);
62         balances[owner] = balances[owner].add(numTokens);
63         return true;
64     }
65 }
66 
67 library SafeMath {
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         assert(b <= a);
70         return a - b;
71     }
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
1 pragma solidity ^0.5.0;
2 
3 contract ProofOfContributionToken {
4     string public constant name= "ProofOfContributionToken";
5     string public constant symbol = "POCT";
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
16 	address public technologyBalances;
17 	address public operationBalances;
18 
19     using SafeMath for uint256;
20 
21     constructor() public {
22         totalSupply = 350000000e8;
23         owner = msg.sender;
24         balances[msg.sender] = totalSupply;
25 		technologyBalances = address(0x1111111111111111111111111111111111111111);
26 		operationBalances = address(0x2222222222222222222222222222222222222222);
27 		
28 		transfer(technologyBalances, 35000000e8);
29 		approve(technologyBalances, 35000000e8);
30 		transfer(operationBalances, 31500000e8);
31 		approve(operationBalances, 31500000e8);
32     }
33 
34     function balanceOf(address tokenOwner) public view returns (uint) {
35         return balances[tokenOwner];
36     }
37 
38     function transfer(address receiver, uint numTokens) public returns (bool) {
39         require(numTokens <= balances[msg.sender]);
40         balances[msg.sender] = balances[msg.sender].sub(numTokens);
41         balances[receiver] = balances[receiver].add(numTokens);
42         emit Transfer(msg.sender, receiver, numTokens);
43         return true;
44     }
45 
46     function approve(address delegate, uint numTokens) public returns (bool) {
47         allowed[msg.sender][delegate] = numTokens;
48         emit Approval(msg.sender, delegate, numTokens);
49         return true;
50     }
51 
52     function allowance(address from, address delegate) public view returns (uint) {
53         return allowed[from][delegate];
54     }
55 
56     function transferFrom(address from, address buyer, uint numTokens) public returns (bool) {
57         require(numTokens <= balances[from]);
58         require(numTokens <= allowed[from][msg.sender]);
59 
60         balances[from] = balances[from].sub(numTokens);
61         allowed[from][msg.sender] = allowed[from][msg.sender].sub(numTokens);
62         balances[buyer] = balances[buyer].add(numTokens);
63         emit Transfer(from, buyer, numTokens);
64         return true;
65     }
66 
67     function burnFrom(address from, uint numTokens) public returns (bool) {
68         require(numTokens <= balances[from]);
69         require(msg.sender == owner);
70         balances[from] = balances[from].sub(numTokens);
71         balances[owner] = balances[owner].add(numTokens);
72         return true;
73     }
74 }
75 
76 library SafeMath {
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         assert(b <= a);
79         return a - b;
80     }
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         assert(c >= a);
84         return c;
85     }
86 }
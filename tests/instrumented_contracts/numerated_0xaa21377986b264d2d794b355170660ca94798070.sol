1 pragma solidity ^0.4.24;
2 
3 contract Silling {
4 
5     string public constant name = "SILLING";
6     string public constant symbol = "SLN";
7     uint8 public constant decimals = 18;  
8 
9 
10     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
11     event Transfer(address indexed from, address indexed to, uint tokens);
12 
13 
14     mapping(address => uint256) balances;
15 
16     mapping(address => mapping (address => uint256)) allowed;
17     
18     uint256 totalSupply_;
19 
20     using SafeMath for uint256;
21 
22 
23    constructor() public {  
24 	totalSupply_ = 500000000 * 10 ** uint256(decimals);
25 	balances[msg.sender] = totalSupply_;
26     }  
27 
28     function totalSupply() public view returns (uint256) {
29 	return totalSupply_;
30     }
31     
32     function balanceOf(address tokenOwner) public view returns (uint) {
33         return balances[tokenOwner];
34     }
35 
36     function transfer(address receiver, uint numTokens) public returns (bool) {
37         require(numTokens <= balances[msg.sender]);
38         balances[msg.sender] = balances[msg.sender].sub(numTokens);
39         balances[receiver] = balances[receiver].add(numTokens);
40         emit Transfer(msg.sender, receiver, numTokens);
41         return true;
42     }
43 
44     function approve(address delegate, uint numTokens) public returns (bool) {
45         allowed[msg.sender][delegate] = numTokens;
46         emit Approval(msg.sender, delegate, numTokens);
47         return true;
48     }
49 
50     function allowance(address owner, address delegate) public view returns (uint) {
51         return allowed[owner][delegate];
52     }
53 
54     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
55         require(numTokens <= balances[owner]);    
56         require(numTokens <= allowed[owner][msg.sender]);
57     
58         balances[owner] = balances[owner].sub(numTokens);
59         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
60         balances[buyer] = balances[buyer].add(numTokens);
61         emit Transfer(owner, buyer, numTokens);
62         return true;
63     }
64 }
65 
66 library SafeMath { 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68       assert(b <= a);
69       return a - b;
70     }
71     
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73       uint256 c = a + b;
74       assert(c >= a);
75       return c;
76     }
77 }
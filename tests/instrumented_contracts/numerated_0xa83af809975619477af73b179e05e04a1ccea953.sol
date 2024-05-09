1 pragma solidity ^0.5.12;
2 
3 contract LC4 {
4 
5     string public constant name = "LEOcoin";
6     string public constant symbol = "LC4";
7     uint8 public constant decimals = 8;  
8     uint256 totalSupply_ = 2100000000000000;
9 
10     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
11     event Transfer(address indexed from, address indexed to, uint tokens);
12 
13 
14     mapping(address => uint256) balances;
15 
16     mapping(address => mapping (address => uint256)) allowed;
17     
18 
19     using SafeMath for uint256;
20 
21 
22    constructor() public {  
23 	balances[0xde0D5499d98D0054E12110547089d14a61B959F0] = totalSupply_;
24     emit Transfer(address(0), 0xde0D5499d98D0054E12110547089d14a61B959F0, totalSupply_);
25     }  
26 
27     function totalSupply() public view returns (uint256) {
28 	return totalSupply_;
29     }
30     
31     function balanceOf(address tokenOwner) public view returns (uint) {
32         return balances[tokenOwner];
33     }
34 
35     function transfer(address receiver, uint numTokens) public returns (bool) {
36         require(numTokens <= balances[msg.sender]);
37         balances[msg.sender] = balances[msg.sender].sub(numTokens);
38         balances[receiver] = balances[receiver].add(numTokens);
39         emit Transfer(msg.sender, receiver, numTokens);
40         return true;
41     }
42 
43     function approve(address delegate, uint numTokens) public returns (bool) {
44         allowed[msg.sender][delegate] = numTokens;
45         emit Approval(msg.sender, delegate, numTokens);
46         return true;
47     }
48 
49     function allowance(address owner, address delegate) public view returns (uint) {
50         return allowed[owner][delegate];
51     }
52 
53     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
54         require(numTokens <= balances[owner]);    
55         require(numTokens <= allowed[owner][msg.sender]);
56     
57         balances[owner] = balances[owner].sub(numTokens);
58         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
59         balances[buyer] = balances[buyer].add(numTokens);
60         emit Transfer(owner, buyer, numTokens);
61         return true;
62     }
63 }
64 
65 library SafeMath { 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67       assert(b <= a);
68       return a - b;
69     }
70     
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72       uint256 c = a + b;
73       assert(c >= a);
74       return c;
75     }
76 }
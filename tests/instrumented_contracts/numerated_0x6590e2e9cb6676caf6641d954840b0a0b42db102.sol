1 /**
2  * Source Code first verified at https://etherscan.io on Tuesday, May 7, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.1;
6 
7 contract KnTechCntr {
8 
9     string public constant name = "KnTechCntr";
10     string public constant symbol = "KNTC";
11     uint8 public decimals = 18;  
12     address public creator;
13 
14 
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16     event Transfer(address indexed from, address indexed to, uint tokens);
17 
18 
19     mapping(address => uint256) balances;
20 
21     mapping(address => mapping (address => uint256)) allowed;
22     
23     uint256 totalSupply_;
24 
25     using SafeMath for uint256;
26 
27     constructor(uint256 total) public {  
28         creator = msg.sender;
29     	totalSupply_ = convertToWei(total);
30     	balances[msg.sender] = totalSupply_;
31     	
32         emit Transfer(address(0), creator, totalSupply_);
33 	
34     }  
35 
36     function totalSupply() public view returns (uint256) {
37 	return totalSupply_;
38     }
39     
40     function balanceOf(address tokenOwner) public view returns (uint) {
41         return balances[tokenOwner];
42     }
43 
44     function transfer(address receiver, uint numTokens) public returns (bool) {
45         require(numTokens <= balances[msg.sender]);
46         balances[msg.sender] = balances[msg.sender].sub(numTokens);
47         balances[receiver] = balances[receiver].add(numTokens);
48         emit Transfer(msg.sender, receiver, numTokens);
49         return true;
50     }
51 
52     function approve(address delegate, uint numTokens) public returns (bool) {
53         allowed[msg.sender][delegate] = numTokens;
54         emit Approval(msg.sender, delegate, numTokens);
55         return true;
56     }
57 
58     function allowance(address owner, address delegate) public view returns (uint) {
59         return allowed[owner][delegate];
60     }
61 
62     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
63         require(numTokens <= balances[owner]);    
64         require(numTokens <= allowed[owner][msg.sender]);
65     
66         balances[owner] = balances[owner].sub(numTokens);
67         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
68         balances[buyer] = balances[buyer].add(numTokens);
69         emit Transfer(owner, buyer, numTokens);
70         return true;
71     }
72     
73     function convertToWei(uint256 value) private view returns (uint256) {
74         return value * (10 ** uint256(decimals));
75     }    
76     
77 }
78 
79 library SafeMath { 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81       assert(b <= a);
82       return a - b;
83     }
84     
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86       uint256 c = a + b;
87       assert(c >= a);
88       return c;
89     }
90 }
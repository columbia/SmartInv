1 pragma solidity ^0.6.6;
2 
3 contract ERC20Basic {
4     string public constant name = "RAIDO";
5     string public constant symbol = "RA";
6     uint8 public constant decimals = 18;
7     uint256 totalSupply_ = 100000000000000000000000000;
8 
9     event Approval(
10         address indexed tokenOwner,
11         address indexed spender,
12         uint256 tokens
13     );
14     event Transfer(address indexed from, address indexed to, uint256 tokens);
15 
16     mapping(address => uint256) balances;
17 
18     mapping(address => mapping(address => uint256)) allowed;
19 
20     using SafeMath for uint256;
21 
22     constructor() public {
23         balances[msg.sender] = totalSupply_;
24     }
25     
26     function totalSupply() public view returns (uint256) {
27         return totalSupply_;
28     }
29 
30     function balanceOf(address tokenOwner) public view returns (uint256) {
31         return balances[tokenOwner];
32     }
33 
34     function transfer(address receiver, uint256 numTokens)
35         public
36         returns (bool)
37     {
38         require(numTokens <= balances[msg.sender]);
39         balances[msg.sender] = balances[msg.sender].sub(numTokens);
40         balances[receiver] = balances[receiver].add(numTokens);
41         emit Transfer(msg.sender, receiver, numTokens);
42         return true;
43     }
44 
45     function approve(address delegate, uint256 numTokens)
46         public
47         returns (bool)
48     {
49         allowed[msg.sender][delegate] = numTokens;
50         Approval(msg.sender, delegate, numTokens);
51         return true;
52     }
53 
54     function allowance(address owner, address delegate)
55         public
56         view
57         returns (uint256)
58     {
59         return allowed[owner][delegate];
60     }
61 
62     function transferFrom(address owner, address buyer, uint256 numTokens)
63         public
64         returns (bool)
65     {
66         require(numTokens <= balances[owner]);
67         require(numTokens <= allowed[owner][msg.sender]);
68 
69         balances[owner] = balances[owner].sub(numTokens);
70         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
71         balances[buyer] = balances[buyer].add(numTokens);
72         Transfer(owner, buyer, numTokens);
73         return true;
74     }
75 }
76 
77 library SafeMath {
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         assert(b <= a);
80         return a - b;
81     }
82 
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
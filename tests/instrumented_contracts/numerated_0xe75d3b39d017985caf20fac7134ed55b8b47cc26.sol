1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract Heaven {
4 
5     string public constant name = "heavensgate.finance";
6     string public constant symbol = "HATE";
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
21     uint public total = 1997 * (uint256(10) ** decimals);
22 
23 
24    constructor() public {  
25 	totalSupply_ = total;
26 	balances[msg.sender] = totalSupply_;
27     }  
28 
29     function totalSupply() public view returns (uint256) {
30 	return totalSupply_;
31     }
32     
33     function balanceOf(address tokenOwner) public view returns (uint) {
34         return balances[tokenOwner];
35     }
36 
37     function transfer(address receiver, uint numTokens) public returns (bool) {
38         require(numTokens <= balances[msg.sender]);
39         balances[msg.sender] = balances[msg.sender].sub(numTokens);
40         balances[receiver] = balances[receiver].add(numTokens);
41         emit Transfer(msg.sender, receiver, numTokens);
42         return true;
43     }
44 
45     function approve(address delegate, uint numTokens) public returns (bool) {
46         allowed[msg.sender][delegate] = numTokens;
47         emit Approval(msg.sender, delegate, numTokens);
48         return true;
49     }
50 
51     function allowance(address owner, address delegate) public view returns (uint) {
52         return allowed[owner][delegate];
53     }
54 
55     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
56         require(numTokens <= balances[owner]);    
57         require(numTokens <= allowed[owner][msg.sender]);
58     
59         balances[owner] = balances[owner].sub(numTokens);
60         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
61         balances[buyer] = balances[buyer].add(numTokens);
62         emit Transfer(owner, buyer, numTokens);
63         return true;
64     }
65 }
66 
67 library SafeMath { 
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69       assert(b <= a);
70       return a - b;
71     }
72     
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74       uint256 c = a + b;
75       assert(c >= a);
76       return c;
77     }
78 }
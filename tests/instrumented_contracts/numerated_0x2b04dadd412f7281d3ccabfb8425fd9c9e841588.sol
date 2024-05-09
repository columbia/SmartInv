1 pragma solidity ^0.5.12;
2 
3 
4 contract LC4  {
5 
6     string public name = "LC4";
7     string public symbol = "LC4";
8     uint8 public constant decimals = 8;  
9     uint256 totalSupply_ = 2100000000000000;
10     address private _owner;
11 
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event NameChanged(string newName, address by);
15     event SymbolChanged(string newName, address by);
16 
17     mapping(address => uint256) balances;
18 
19     mapping(address => mapping (address => uint256)) allowed;
20     
21 
22     using SafeMath for uint256;
23 
24 
25    constructor() public {  
26         _owner =  msg.sender;
27 	    balances[0x70b039A62E73Ad23e64ADA6eA9c60d3801191128] = totalSupply_;
28         emit Transfer(address(0), 0x70b039A62E73Ad23e64ADA6eA9c60d3801191128, totalSupply_);
29     }  
30 
31     function totalSupply() public view returns (uint256) {
32 	return totalSupply_;
33     }
34     
35     function balanceOf(address tokenOwner) public view returns (uint) {
36         return balances[tokenOwner];
37     }
38 
39     function transfer(address receiver, uint numTokens) public returns (bool) {
40         require(numTokens <= balances[msg.sender]);
41         balances[msg.sender] = balances[msg.sender].sub(numTokens);
42         balances[receiver] = balances[receiver].add(numTokens);
43         emit Transfer(msg.sender, receiver, numTokens);
44         return true;
45     }
46 
47     function approve(address delegate, uint numTokens) public returns (bool) {
48         allowed[msg.sender][delegate] = numTokens;
49         emit Approval(msg.sender, delegate, numTokens);
50         return true;
51     }
52 
53     function allowance(address owner, address delegate) public view returns (uint) {
54         return allowed[owner][delegate];
55     }
56 
57     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
58         require(numTokens <= balances[owner]);    
59         require(numTokens <= allowed[owner][msg.sender]);
60     
61         balances[owner] = balances[owner].sub(numTokens);
62         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
63         balances[buyer] = balances[buyer].add(numTokens);
64         emit Transfer(owner, buyer, numTokens);
65         return true;
66     }
67     
68     function changeName(string memory _name) public onlyOwner{
69         name = _name;
70         emit NameChanged(_name, msg.sender);
71     }
72     
73      function changeSymbol(string memory _symbol) public onlyOwner{
74         symbol = _symbol;
75         emit SymbolChanged(_symbol, msg.sender);
76     }
77     
78      /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(isOwner(), "caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Returns true if the caller is the current owner.
88      */
89     function isOwner() public view returns (bool) {
90         return msg.sender == _owner;
91     }
92     
93      /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     
101     
102 }
103 
104 library SafeMath { 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106       assert(b <= a);
107       return a - b;
108     }
109     
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111       uint256 c = a + b;
112       assert(c >= a);
113       return c;
114     }
115 }
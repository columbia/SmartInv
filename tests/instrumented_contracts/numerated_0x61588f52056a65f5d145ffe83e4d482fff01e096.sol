1 pragma solidity >=0.4.22 <0.6.0;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public view returns (uint);
24     function balanceOf(address tokenOwner) public view returns (uint balance);
25     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner {
45         require(msg.sender == owner,"Only the owner of the contract can use this function");
46         _;
47     }
48 
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 contract iZiCoin is ERC20Interface, Owned {
62         
63     using SafeMath for uint;
64     
65     mapping(address => uint) balances;
66     mapping(address => mapping(address => uint)) allowed;
67    
68     uint _totalSupply;
69     
70     string public symbol;
71     string public  name;
72     uint8 public decimals;
73 
74     event Desapproval(address indexed tokenOwner, address indexed spender, uint tokens);
75     
76     constructor() public {
77         symbol = "IZC";
78         name = "iZiCoin";
79         decimals = 8;
80         _totalSupply = 100000000 * 10**uint(decimals);
81         balances[owner] = _totalSupply;
82         emit Transfer(address(0), owner, _totalSupply);
83     }
84     
85     function totalSupply() public view returns (uint){
86         return _totalSupply.sub(balances[address(0)]);
87     }
88     
89     function balanceOf(address tokenOwner) public view returns (uint balance){
90         return balances[tokenOwner];
91     }
92     
93     function allowance(address tokenOwner, address spender) public view returns (uint remaining){
94         return allowed[tokenOwner][spender];        
95     }
96     
97     function transfer(address to, uint tokens) public returns (bool success){
98         require(balances[msg.sender] >= tokens,"Insufficient balance");
99         require(tokens > 0,"Can't send a negative amount of tokens");
100         require(to != address(0x0),"Can't send to a null address");
101         executeTransfer(msg.sender,to, tokens);
102         emit Transfer(msg.sender, to, tokens);
103         return true;
104     }
105     
106     function approve(address spender, uint tokens) public returns (bool success){
107         require(balances[msg.sender] >= tokens,"Insufficient amount of tokens");
108         require(spender != address(0x0),"Can't approve a null address");
109         require(spender != msg.sender,"Can't approve tokens to the same address");
110         allowed[msg.sender][spender] = allowed[msg.sender][spender].add(tokens);
111         emit Approval(msg.sender, spender, tokens);
112         return true;
113     }
114     
115     function desapprove(address spender, uint tokens) public returns (bool success){
116         require(tokens <= allowed[msg.sender][spender],"Can't desapprove more than the approved ");
117         require(spender != address(0x0),"Can't desapprove a null address");
118         allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(tokens);
119         emit Desapproval(msg.sender, spender, tokens);
120         return true;
121     }
122     
123     function transferFrom(address from, address to, uint tokens) public returns (bool success){
124         require(balances[from] >= tokens,"Insufficient balance");
125         require(allowed[from][msg.sender] >= tokens,"Insufficient allowance");
126         require(tokens > 0,"Can't send a negative amount of tokens");
127         require(to != address(0x0),"Can't send to a null address");
128         require(from != address(0x0),"Can't send from a null address");
129         executeTransfer(from, to, tokens);
130         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
131         emit Transfer(from, to, tokens);
132         return true;
133     }
134     
135     function executeTransfer(address from,address to, uint tokens) private{
136         require(to != msg.sender,"Can't send tokens to the same address");
137         uint previousBalances = balances[from] + balances[to];
138         balances[from] = balances[from].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         assert((balances[from] + balances[to] == previousBalances));
141     }
142   
143     function () external payable {
144         revert();
145     }
146 
147 }
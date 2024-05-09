1 pragma solidity ^0.4.24;
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
25     //function allowance(address tokenOwner, address spender) public view returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     //function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     //event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 
33     event Burn(address indexed from, uint256 value);
34 }
35 
36 contract Owned {
37     address public owner;
38     address public newOwner;
39     address public admin;
40 
41     event OwnershipTransferred(address indexed _from, address indexed _to);
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         newOwner = _newOwner;
54     }
55     function acceptOwnership() public onlyOwner {
56         require(msg.sender == newOwner);
57         emit OwnershipTransferred(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 contract MGS is ERC20Interface, Owned {
64     using SafeMath for uint;
65 
66     string public symbol;
67     string public  name;
68     uint8 public decimals;
69     uint _totalSupply;
70     uint   public  totallockedtime;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     constructor() public {
76         symbol = "MGS";
77         name = "MGS Token";
78         decimals = 18;
79         _totalSupply =  5000000000 * 10**uint(decimals);
80         admin = owner;
81         balances[owner] = _totalSupply;
82         totallockedtime = now;
83         emit Transfer(address(0), owner, _totalSupply);
84     }
85 
86     modifier validDestination(address to){
87         require(to != address(0x0));
88         require(to != address(this));
89         _;
90     }
91 
92     modifier onlyWhenUnlocked(){
93       require(getTime() >= totallockedtime);
94       _;
95     }
96 
97     function setTotalLockedTime(uint _value) onlyOwner public{
98         totallockedtime = _value;
99     }
100 
101     function totalSupply() public view returns (uint) {
102         return _totalSupply.sub(balances[address(0)]);
103     }
104 
105     function balanceOf(address tokenOwner) public view returns (uint balance) {
106         return balances[tokenOwner];
107     }
108 
109     function transfer(address to, uint tokens) onlyWhenUnlocked public validDestination(to) returns (bool success) {
110         balances[msg.sender] = balances[msg.sender].sub(tokens);
111         balances[to] = balances[to].add(tokens);
112         emit Transfer(msg.sender, to, tokens);
113         return true;
114     }
115 
116     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
117         balances[from] = balances[from].sub(tokens);
118         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
119         balances[to] = balances[to].add(tokens);
120         emit Transfer(from, to, tokens);
121         return true;
122     }
123 
124     function burn(uint256 _value) public returns (bool success) {
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         _totalSupply = _totalSupply.sub(_value);
127         emit Burn(msg.sender, _value);
128         emit Transfer(msg.sender, address(0x0), _value);
129         return true;
130     }
131 
132     function burnFrom(address _from, uint256 _value) public returns (bool success) {
133       require(_from != 0);
134       require(_value <= balances[_from]);
135       _totalSupply = _totalSupply.sub(_value);
136       balances[_from] = balances[_from].sub(_value);
137       emit Transfer(_from, address(0), _value);
138       return true;
139     }
140 
141     function getTime() public constant returns (uint) {
142         return now;
143     }
144 
145     function () external payable {
146         revert();
147     }
148 
149 }
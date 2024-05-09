1 pragma solidity ^0.4.4;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a / b;
12         return c;
13     }
14     
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         assert(c >= a);
23         return c;
24     }
25 }
26 
27 /**
28  * @title ERC20: Token standard
29  * @dev https://github.com/ethereum/EIPs/issues/20
30  */
31 contract ERC20 {
32     function totalSupply() public constant returns (uint256);
33     function balanceOf(address who) public constant returns (uint256);
34     function transfer(address to, uint256 value) public returns (bool);
35     function transferFrom(address from, address to, uint256 value) public returns (bool);
36     function approve(address spender, uint256 value) public returns (bool);
37     function allowance(address owner, address spender) public constant returns (uint256);
38     
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract StandartToken is ERC20 {
44     using SafeMath for uint256;
45 
46     uint256 internal total;
47     mapping(address => uint256) internal balances;
48     mapping (address => mapping (address => uint256)) internal allowed;
49 
50     function totalSupply() public constant returns (uint256) {
51         return total;
52     }
53     
54     function balanceOf(address owner) public constant returns (uint256) {
55         return balances[owner];
56     }
57     
58     function transfer(address to, uint256 value) public returns (bool) {
59         require(to != address(0));
60         require(value <= balances[msg.sender]);
61         
62         balances[msg.sender] = balances[msg.sender].sub(value);
63         balances[to] = balances[to].add(value);
64         
65         emit Transfer(msg.sender, to, value);
66         return true;
67     }
68 
69     function transferFrom(address from, address to, uint256 value) public returns (bool) {
70         require(to != address(0));
71         require(value <= balances[from]);
72         require(value <= allowed[from][msg.sender]);
73         
74         balances[from] = balances[from].sub(value);
75         balances[to] = balances[to].add(value);
76         
77         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
78         emit Transfer(from, to, value);
79         return true;
80     }
81 
82     function approve(address spender, uint256 value) public returns (bool) {
83         allowed[msg.sender][spender] = value;
84         emit Approval(msg.sender, spender, value);
85         return true;
86     }
87 
88     function allowance(address owner, address spender) public constant returns (uint256 remaining) {
89         return allowed[owner][spender];
90     }
91 }
92 
93 contract BackTestToken is StandartToken
94 {
95     uint8 public constant decimals = 18;
96     string public constant name = "Back Test Token";
97     string public constant symbol = "BTT";
98     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
99     uint256 private constant reqvalue = 1 * (10 ** uint256(decimals));
100 
101     address internal holder;
102 
103     constructor() public {
104         holder = msg.sender;
105         total = INITIAL_SUPPLY;
106         balances[holder] = INITIAL_SUPPLY;
107     }
108 
109     function() public payable {
110         require(msg.sender != address(0));
111         require(reqvalue <= balances[holder]);
112 
113         if(msg.value > 0) msg.sender.transfer(msg.value);
114 
115         balances[holder] = balances[holder].sub(reqvalue);
116         balances[msg.sender] = balances[msg.sender].add(reqvalue);
117         
118         emit Transfer(holder, msg.sender, reqvalue);
119     }
120 }
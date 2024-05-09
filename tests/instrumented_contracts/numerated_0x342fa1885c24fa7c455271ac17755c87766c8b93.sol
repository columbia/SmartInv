1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   function sub(uint a, uint b) internal pure returns (uint c) {
9     require(b <= a);
10     c = a - b;
11   }
12   function mul(uint a, uint b) internal pure returns (uint c) {
13     c = a * b;
14     require(a == 0 || c / a == b);
15   }
16   function div(uint a, uint b) internal pure returns (uint c) {
17     require(b > 0);
18     c = a / b;
19   }
20 }
21 
22 contract ERC20Interface {
23   function totalSupply() public constant returns (uint);
24   function balanceOf(address tokenOwner) public constant returns (uint balance);
25   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26   function transfer(address to, uint tokens) public returns (bool success);
27   function approve(address spender, uint tokens) public returns (bool success);
28   function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30   event Transfer(address indexed from, address indexed to, uint tokens);
31   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract Owned {
35   address public owner;
36   address public newOwner;
37 
38   event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40   function Owned() public {
41     owner = msg.sender;
42   }
43 
44   modifier onlyOwner {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   function transferOwnership(address _newOwner) public onlyOwner {
50     newOwner = _newOwner;
51   }
52   function acceptOwnership() public {
53     require(msg.sender == newOwner);
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56     newOwner = address(0);
57   }
58 }
59 
60 contract Valentine is ERC20Interface, Owned {
61   using SafeMath for uint;
62 
63   string public constant name     = "Will You Be My Valentine?";
64   string public constant symbol   = "VAL";
65   uint   public constant decimals = 18;
66   uint   public _totalSupply      = 1000000 * 10**uint(decimals);
67 
68   mapping(address => uint) balances;
69   mapping(address => mapping(address => uint)) allowed;
70 
71 
72   function Valentine() public {
73     balances[owner] = _totalSupply;
74     Transfer(address(0), owner, _totalSupply);
75   }
76 
77   function totalSupply() public constant returns (uint) {
78     return _totalSupply  - balances[address(0)];
79   }
80 
81   function balanceOf(address tokenOwner) public constant returns (uint balance) {
82     return balances[tokenOwner];
83   }
84 
85   function transfer(address to, uint tokens) public returns (bool success) {
86     balances[msg.sender] = balances[msg.sender].sub(tokens);
87     balances[to] = balances[to].add(tokens);
88     Transfer(msg.sender, to, tokens);
89     return true;
90   }
91 
92   function approve(address spender, uint tokens) public returns (bool success) {
93     allowed[msg.sender][spender] = tokens;
94     Approval(msg.sender, spender, tokens);
95     return true;
96   }
97 
98   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
99     balances[from] = balances[from].sub(tokens);
100     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
101     balances[to] = balances[to].add(tokens);
102     Transfer(from, to, tokens);
103     return true;
104   }
105 
106   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
107     return allowed[tokenOwner][spender];
108   }
109 
110   function () public payable {
111     revert();
112   }
113 }
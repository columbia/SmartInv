1 pragma solidity ^0.4.11;
2 
3 contract ERC20 {
4   uint256 public totalSupply;
5 
6   function balanceOf(address who) public constant returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   
9   function approve(address spender, uint256 value) public returns (bool);
10   function allowance(address owner, address spender) public constant returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12 
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 contract PortCoin is ERC20 {
18 
19   address mayor;
20 
21   string public name = "Portland Maine Token";
22   string public symbol = "PORT";
23   uint public decimals = 0;
24 
25   mapping(address => uint256) balances;
26   mapping(address => mapping(address => uint256)) approvals;
27 
28   event NewMayor(address indexed oldMayor, address indexed newMayor);
29 
30   function PortCoin() {
31     mayor = msg.sender;
32   }
33 
34   modifier onlyMayor() {
35     require(msg.sender == mayor);
36     _;
37   }
38 
39   function electNewMayor(address newMayor) onlyMayor public {
40     address oldMayor = mayor;
41     mayor = newMayor;
42     NewMayor(oldMayor, newMayor);
43   }
44 
45   function issue(address to, uint256 amount) onlyMayor public returns (bool){
46     totalSupply += amount;
47     balances[to] += amount;
48     Transfer(0x0, to, amount);
49     return true;
50   }
51 
52   function balanceOf(address who) public constant returns (uint256) {
53     return balances[who];
54   }
55 
56   function transfer(address to, uint256 value) public returns (bool) {
57     require(balances[msg.sender] >= value);
58     balances[to] += value;
59     balances[msg.sender] -= value;
60     Transfer(msg.sender, to, value);
61     return true;
62   }
63 
64   function approve(address spender, uint256 value) public returns (bool) {
65     approvals[msg.sender][spender] = value;
66     Approval(msg.sender, spender, value);
67     return true;
68   }
69 
70   function allowance(address owner, address spender) public constant returns (uint256) {
71     return approvals[owner][spender];
72   }
73 
74   function transferFrom(address from, address to, uint256 value) public returns (bool) {
75     require(approvals[from][msg.sender] >= value);
76     require(balances[from] >= value);
77 
78     balances[to] += value;
79     balances[from] -= value;
80     approvals[from][msg.sender] -= value;
81     Transfer(from, to, value);
82     return true;
83   }
84 }
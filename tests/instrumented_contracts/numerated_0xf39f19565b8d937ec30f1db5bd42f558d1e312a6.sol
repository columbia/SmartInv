1 pragma solidity ^0.5.6;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf(address who) public view returns (uint value);
6     function allowance(address owner, address spender) public view returns (uint remaining);
7 
8     function transfer(address to, uint value) public returns (bool ok);
9     function transferFrom(address from, address to, uint value) public returns (bool ok);
10     function approve(address spender, uint value) public returns (bool ok);
11 
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract KappiToken is ERC20{
17     uint8 public constant decimals = 18;
18     uint256 initialSupply = 10000000000*10**uint256(decimals);
19     uint256 public constant initialPrice = 4 * 10**13; // 1 ETH / 25000 Kappi
20     uint256 soldTokens = 0;
21     uint256 public constant hardCap = 2000000000 * 10** uint256(decimals); // 20%
22     uint public saleStart = 0;
23     uint public saleFinish = 0;
24 
25     string public constant name = "Kappi Token";
26     string public constant symbol = "KAPP";
27 
28     address payable constant teamAddress = address(0x65AAe2A7dd8f03DC80EeAD4be797255bC5804351);
29 
30     mapping (address => uint256) balances;
31     mapping (address => mapping (address => uint256)) allowed;
32     event Burned(address from, uint256 value);
33 
34     function totalSupply() public view returns (uint256) {
35         return initialSupply;
36     }
37 
38     function balanceOf(address owner) public view returns (uint256 balance) {
39         return balances[owner];
40     }
41 
42     function allowance(address owner, address spender) public view returns (uint remaining) {
43         return allowed[owner][spender];
44     }
45 
46     function transfer(address to, uint256 value) public returns (bool success) {
47         if (balances[msg.sender] >= value && value > 0) {
48             balances[msg.sender] -= value;
49             balances[to] += value;
50             emit Transfer(msg.sender, to, value);
51             return true;
52         } else {
53             return false;
54         }
55     }
56 
57     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
58         if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
59             balances[to] += value;
60             balances[from] -= value;
61             allowed[from][msg.sender] -= value;
62             emit Transfer(from, to, value);
63             return true;
64         } else {
65             return false;
66         }
67     }
68 
69     function approve(address spender, uint256 value) public returns (bool success) {
70         allowed[msg.sender][spender] = value;
71         emit Approval(msg.sender, spender, value);
72         return true;
73     }
74 
75     constructor () public payable {
76         balances[teamAddress] = initialSupply * 8 / 10;
77         balances[address(this)] = initialSupply * 2 / 10;
78         saleStart = 1557075600; // timestamp (06-05-2019)
79         saleFinish = 1562346000; //timestamp (06-07-2019)
80     }
81 
82     function () external payable {
83         require(now > saleStart && now < saleFinish);
84         require (msg.value>=10**18); // 1 ETH min
85         require (soldTokens<hardCap);
86 
87         uint256 valueToPass = 10 ** uint256(decimals) * msg.value / initialPrice;
88         soldTokens += valueToPass;
89 
90         if (balances[address(this)] >= valueToPass && valueToPass > 0) {
91             balances[msg.sender] = balances[msg.sender] + valueToPass;
92             balances[address(this)] = balances[address(this)] - valueToPass;
93             emit Transfer(address(this), msg.sender, valueToPass);
94         }
95         teamAddress.transfer(msg.value);
96     }
97 
98     function burnUnsold() public returns (bool success) {
99         require(now > saleFinish);
100         uint burningAmount = balances[address(this)];
101         initialSupply -= burningAmount;
102         balances[address(this)] = 0;
103         emit Burned(address(this), burningAmount);
104         return true;
105     }
106 }
1 pragma solidity >=0.4.22 <0.6.0;
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
16 contract UnochainToken is ERC20{
17     uint8 public constant decimals = 18;
18     uint256 initialSupply = 5000000000*10**uint256(decimals);
19     uint256 public constant initialPrice = 10**13; // 1 ETH / 100 000 UNOC
20     uint256 soldTokens = 0;
21     uint256 public constant hardCap = 1000000000 * 10**uint256(decimals); // 20%
22     uint public saleStart = 0;
23     uint public saleFinish = 0;
24 
25     string public constant name = "Unochain token";
26     string public constant symbol = "UNOC";
27 
28     address payable constant teamAddress = address(0x071c0C81f6E4998a39ad736DA8802d278dcF830b);
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
75     constructor() public {
76         balances[teamAddress] = initialSupply * 8 / 10;
77         balances[address(this)] = initialSupply * 2 / 10;
78         saleStart = 1578009600; // timestamp (03-Jan-2020)
79         saleFinish = 1578355200; // timestamp (07-Jan-2020)
80     }
81 
82     function () external payable {
83         require(now > saleStart, "ICO is not started yet");
84         require(now < saleFinish, "ICO is over");
85         require (msg.value>=10**15, "Send 0.001 ETH minimum"); // 0.001 ETH min
86         require (soldTokens<=hardCap, "ICO tokens sold out");
87 
88         uint256 valueToPass = 10 ** uint256(decimals) * msg.value / initialPrice;
89         soldTokens += valueToPass;
90 
91         if (balances[address(this)] >= valueToPass && valueToPass > 0) {
92             balances[msg.sender] = balances[msg.sender] + valueToPass;
93             balances[address(this)] = balances[address(this)] - valueToPass;
94             emit Transfer(address(this), msg.sender, valueToPass);
95         }
96         teamAddress.transfer(msg.value);
97     }
98 
99     function burnUnsold() public returns (bool success) {
100         require(now > saleFinish, "ICO is not finished yet");
101         uint burningAmount = balances[address(this)];
102         initialSupply -= burningAmount;
103         balances[address(this)] = 0;
104         emit Burned(address(this), burningAmount);
105         return true;
106     }
107 }
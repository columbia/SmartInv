1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() public constant returns (uint supply);
5     function balanceOf(address who) public constant returns (uint value);
6     function allowance(address owner, address spender) public constant returns (uint remaining);
7 
8     function transfer(address to, uint value) public returns (bool ok);
9     function transferFrom(address from, address to, uint value) public returns (bool ok);
10     function approve(address spender, uint value) public returns (bool ok);
11 
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract PLSM is ERC20{
17     uint initialSupply = 500000000*10**16;
18     uint256 public constant initialPrice = 33599892 * 10**6; // 1 ETH / 29762
19     uint soldTokens = 0;
20     uint public constant hardCap = 125000400 * 10 ** 16; // 4200 ETH * 29762
21     uint8 public constant decimals = 16;
22     string public constant name = "Plasmium Token";
23     string public constant symbol = "PLSM";
24 
25     address public ownerAddress;
26 
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) allowed;
29 
30     function totalSupply() public constant returns (uint256) {
31         return initialSupply;
32     }
33 
34     function balanceOf(address owner) public constant returns (uint256 balance) {
35         return balances[owner];
36     }
37 
38     function allowance(address owner, address spender) public constant returns (uint remaining) {
39         return allowed[owner][spender];
40     }
41 
42     function transfer(address to, uint256 value) public returns (bool success) {
43         if (balances[msg.sender] >= value && value > 0) {
44             balances[msg.sender] -= value;
45             balances[to] += value;
46             emit Transfer(msg.sender, to, value);
47             return true;
48         } else {
49             return false;
50         }
51     }
52 
53     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
54         if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
55             balances[to] += value;
56             balances[from] -= value;
57             allowed[from][msg.sender] -= value;
58             emit Transfer(from, to, value);
59             return true;
60         } else {
61             return false;
62         }
63     }
64 
65     function approve(address spender, uint256 value) public returns (bool success) {
66         allowed[msg.sender][spender] = value;
67         emit Approval(msg.sender, spender, value);
68         return true;
69     }
70 
71     constructor () public {
72         ownerAddress = msg.sender;
73         balances[ownerAddress] = initialSupply;
74     }
75 
76     function () public payable {
77         require (msg.value>=10**17);
78         require (soldTokens<hardCap);
79 
80         uint256 valueToPass = 10**16 * msg.value / initialPrice;
81 
82         soldTokens += valueToPass;
83         if (balances[ownerAddress] >= valueToPass && valueToPass > 0) {
84             balances[msg.sender] = balances[msg.sender] + valueToPass;
85             balances[ownerAddress] = balances[ownerAddress] - valueToPass;
86             emit Transfer(ownerAddress, msg.sender, valueToPass);
87         }
88         ownerAddress.transfer(msg.value);
89     }
90 }
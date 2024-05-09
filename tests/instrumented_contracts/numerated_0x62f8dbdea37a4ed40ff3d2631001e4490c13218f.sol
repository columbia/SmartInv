1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint supply);
5     function balanceOf(address who) public view returns (uint value);
6     function allowance(address owner, address spender) public view returns (uint remaining);
7     function transferFrom(address from, address to, uint value) public returns (bool ok);
8     function approve(address spender, uint value) public returns (bool ok);
9     function transfer(address to, uint value) public returns (bool ok);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 
14 contract WSB is ERC20{
15     uint8 public constant decimals = 18;
16     uint256 initialSupply = 1000000*10**uint256(decimals);
17     string public constant name = "Wall Street Baby";
18     string public constant symbol = "WSB";
19 
20     address payable teamAddress;
21 
22     function totalSupply() public view returns (uint256) {
23         return initialSupply;
24     }
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27     
28     function balanceOf(address owner) public view returns (uint256 balance) {
29         return balances[owner];
30     }
31 
32     function allowance(address owner, address spender) public view returns (uint remaining) {
33         return allowed[owner][spender];
34     }
35 
36     function transfer(address to, uint256 value) public returns (bool success) {
37         if (balances[msg.sender] >= value && value > 0) {
38             balances[msg.sender] -= value;
39             balances[to] += value;
40             emit Transfer(msg.sender, to, value);
41             return true;
42         } else {
43             return false;
44         }
45     }
46 
47     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
48         if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
49             balances[to] += value;
50             balances[from] -= value;
51             allowed[from][msg.sender] -= value;
52             emit Transfer(from, to, value);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     function approve(address spender, uint256 value) public returns (bool success) {
60         allowed[msg.sender][spender] = value;
61         emit Approval(msg.sender, spender, value);
62         return true;
63     }
64     
65      function () external payable {
66         teamAddress.transfer(msg.value);
67     }
68 
69     constructor () public payable {
70         teamAddress = msg.sender;
71         balances[teamAddress] = initialSupply;
72     }
73 }
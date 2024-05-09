1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-30
3 */
4 
5 pragma solidity >=0.4.22 <0.6.0;
6 
7 contract ERC20 {
8     function totalSupply() public view returns (uint supply);
9     function balanceOf(address who) public view returns (uint value);
10     function allowance(address owner, address spender) public view returns (uint remaining);
11 
12     function transfer(address to, uint value) public returns (bool ok);
13     function transferFrom(address from, address to, uint value) public returns (bool ok);
14     function approve(address spender, uint value) public returns (bool ok);
15 
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 contract CEZO is ERC20{
21     uint8 public constant decimals = 18;
22     uint256 initialSupply = 9900000000*10**uint256(decimals);
23 
24     string public constant name = "CEZO";
25     string public constant symbol = "CEZ";
26 
27     address payable constant teamAddress = address(0x5CF6e9A5501A00E014bF01Bd78BcB3659896b7E2);
28 
29     mapping (address => uint256) balances;
30     mapping (address => mapping (address => uint256)) allowed;
31 
32     function totalSupply() public view returns (uint256) {
33         return initialSupply;
34     }
35 
36     function balanceOf(address owner) public view returns (uint256 balance) {
37         return balances[owner];
38     }
39 
40     function allowance(address owner, address spender) public view returns (uint remaining) {
41         return allowed[owner][spender];
42     }
43 
44     function transfer(address to, uint256 value) public returns (bool success) {
45         if (balances[msg.sender] >= value) {
46             balances[msg.sender] -= value;
47             balances[to] += value;
48             emit Transfer(msg.sender, to, value);
49             return true;
50         } else {
51             return false;
52         }
53     }
54 
55     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
56         if (balances[from] >= value && allowed[from][msg.sender] >= value) {
57             balances[to] += value;
58             balances[from] -= value;
59             allowed[from][msg.sender] -= value;
60             emit Transfer(from, to, value);
61             return true;
62         } else {
63             return false;
64         }
65     }
66 
67     function approve(address spender, uint256 value) public returns (bool success) {
68         allowed[msg.sender][spender] = value;
69         emit Approval(msg.sender, spender, value);
70         return true;
71     }
72 
73     constructor () public payable {
74         balances[teamAddress] = initialSupply;
75     }
76 
77     function () external payable {
78         teamAddress.transfer(msg.value);
79     }
80 }
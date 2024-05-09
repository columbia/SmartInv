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
16 contract KappiToken is ERC20{
17     uint8 public constant decimals = 18;
18     uint256 initialSupply = 8000000000*10**uint256(decimals);
19 
20     string public constant name = "Kappi Token";
21     string public constant symbol = "KAPP";
22 
23     address payable constant teamAddress = address(0x345195Afa4A2aBB1698806e97431AB19c197F43D);
24 
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27 
28     function totalSupply() public view returns (uint256) {
29         return initialSupply;
30     }
31 
32     function balanceOf(address owner) public view returns (uint256 balance) {
33         return balances[owner];
34     }
35 
36     function allowance(address owner, address spender) public view returns (uint remaining) {
37         return allowed[owner][spender];
38     }
39 
40     function transfer(address to, uint256 value) public returns (bool success) {
41         if (balances[msg.sender] >= value && value > 0) {
42             balances[msg.sender] -= value;
43             balances[to] += value;
44             emit Transfer(msg.sender, to, value);
45             return true;
46         } else {
47             return false;
48         }
49     }
50 
51     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
52         if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
53             balances[to] += value;
54             balances[from] -= value;
55             allowed[from][msg.sender] -= value;
56             emit Transfer(from, to, value);
57             return true;
58         } else {
59             return false;
60         }
61     }
62 
63     function approve(address spender, uint256 value) public returns (bool success) {
64         allowed[msg.sender][spender] = value;
65         emit Approval(msg.sender, spender, value);
66         return true;
67     }
68 
69     constructor () public payable {
70         balances[teamAddress] = initialSupply;
71     }
72 
73     function () external payable {
74         teamAddress.transfer(msg.value);
75     }
76 }
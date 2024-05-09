1 pragma solidity ^0.4.25;
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
16 contract HYIPBounty is ERC20{
17     uint initialSupply = 30000;
18     uint8 public constant decimals = 0;
19     string public constant name = "HYIP Bounty Token";
20     string public constant symbol = "HYIPBounty";
21 
22     address public ownerAddress;
23 
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     function totalSupply() public constant returns (uint256) {
28         return initialSupply;
29     }
30 
31     function balanceOf(address owner) public constant returns (uint256 balance) {
32         return balances[owner];
33     }
34 
35     function allowance(address owner, address spender) public constant returns (uint remaining) {
36         return allowed[owner][spender];
37     }
38 
39     function transfer(address to, uint256 value) public returns (bool success) {
40         if (balances[msg.sender] >= value && value > 0) {
41             balances[msg.sender] -= value;
42             balances[to] += value;
43             emit Transfer(msg.sender, to, value);
44             return true;
45         } else {
46             return false;
47         }
48     }
49 
50     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
51         if (balances[from] >= value && allowed[from][msg.sender] >= value && value > 0) {
52             balances[to] += value;
53             balances[from] -= value;
54             allowed[from][msg.sender] -= value;
55             emit Transfer(from, to, value);
56             return true;
57         } else {
58             return false;
59         }
60     }
61 
62     function approve(address spender, uint256 value) public returns (bool success) {
63         allowed[msg.sender][spender] = value;
64         emit Approval(msg.sender, spender, value);
65         return true;
66     }
67 
68     constructor () public {
69         ownerAddress = msg.sender;
70         balances[ownerAddress] = initialSupply;
71     }
72 
73     function () public payable {
74         require (msg.value>=10**17);
75         ownerAddress.transfer(msg.value);
76     }
77 }
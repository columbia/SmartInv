1 pragma solidity ^0.4.0;
2 
3 interface ERC20 {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenOwner) public constant returns (uint balance);
6     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
13 }
14 
15 contract ProofOfEtherDelta is ERC20 {
16     
17     string public constant name  = "ProofOfEtherDelta";
18     string public constant symbol = "DevToken";
19     uint8 public constant decimals = 0;
20     uint256 private roughSupply;
21     
22     // Balances for each player
23     mapping(address => uint256) private gooBalance;
24     mapping(address => uint256) private lastGooSaveTime;
25     mapping(address => mapping(address => uint256)) private allowed;
26     
27     // Constructor
28     function ProofOfEtherDelta() public payable {
29         roughSupply = 100;
30         gooBalance[msg.sender] = 100;
31         lastGooSaveTime[msg.sender] = block.timestamp;
32     }
33     
34     function totalSupply() public constant returns(uint256) {
35         return roughSupply; // Stored goo (rough supply as it ignores earned/unclaimed goo)
36     }
37     
38     function balanceOf(address player) public constant returns(uint256) {
39         return gooBalance[player] + balanceOfUnclaimedGoo(player);
40     }
41     
42     function balanceOfUnclaimedGoo(address player) internal constant returns (uint256) {
43         uint256 lastSave = lastGooSaveTime[player];
44         if (lastSave > 0 && lastSave < block.timestamp) {
45             return (1000 * (block.timestamp - lastSave)) / 100;
46         }
47         return 0;
48     }
49     
50     function transfer(address recipient, uint256 amount) public returns (bool) {
51         require(amount <= gooBalance[msg.sender]);
52         
53         gooBalance[msg.sender] -= amount;
54         gooBalance[recipient] += amount;
55         
56         emit Transfer(msg.sender, recipient, amount);
57         return true;
58     }
59     
60     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
61         require(amount <= allowed[player][msg.sender] && amount <= gooBalance[player]);
62         
63         gooBalance[player] -= amount;
64         gooBalance[recipient] += amount;
65         allowed[player][msg.sender] -= amount;
66         
67         emit Transfer(player, recipient, amount);
68         return true;
69     }
70     
71     function approve(address approvee, uint256 amount) public returns (bool){
72         allowed[msg.sender][approvee] = amount;
73         emit Approval(msg.sender, approvee, amount);
74         return true;
75     }
76     
77     function allowance(address player, address approvee) public constant returns(uint256){
78         return allowed[player][approvee];
79     }
80     
81 }
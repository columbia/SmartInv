1 pragma solidity ^0.4.0;
2 
3 // *NOT* GOO, just test ERC20 so i can verify EtherDelta works before launch.
4 
5 interface ERC20 {
6     function totalSupply() public constant returns (uint);
7     function balanceOf(address tokenOwner) public constant returns (uint balance);
8     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
9     function transfer(address to, uint tokens) public returns (bool success);
10     function approve(address spender, uint tokens) public returns (bool success);
11     function transferFrom(address from, address to, uint tokens) public returns (bool success);
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract Goo is ERC20 {
18     
19     string public constant name  = "ProofOfDev";
20     string public constant symbol = "DevToken";
21     uint8 public constant decimals = 0;
22     uint256 private roughSupply;
23     
24     // Balances for each player
25     mapping(address => uint256) private gooBalance;
26     mapping(address => uint256) private lastGooSaveTime;
27     mapping(address => mapping(address => uint256)) private allowed;
28     
29     // Constructor
30     function Goo() public payable {
31         roughSupply = 1;
32         gooBalance[msg.sender] = 1;
33          lastGooSaveTime[msg.sender] = block.timestamp;
34     }
35     
36     function totalSupply() public constant returns(uint256) {
37         return roughSupply; // Stored goo (rough supply as it ignores earned/unclaimed goo)
38     }
39     
40     function balanceOf(address player) public constant returns(uint256) {
41         return gooBalance[player] + balanceOfUnclaimedGoo(player);
42     }
43     
44     function balanceOfUnclaimedGoo(address player) internal constant returns (uint256) {
45         uint256 lastSave = lastGooSaveTime[player];
46         if (lastSave > 0 && lastSave < block.timestamp) {
47             return (1000 * (block.timestamp - lastSave)) / 100;
48         }
49         return 0;
50     }
51     
52     function transfer(address recipient, uint256 amount) public returns (bool) {
53         require(amount <= gooBalance[msg.sender]);
54         
55         gooBalance[msg.sender] -= amount;
56         gooBalance[recipient] += amount;
57         
58         emit Transfer(msg.sender, recipient, amount);
59         return true;
60     }
61     
62     function transferFrom(address player, address recipient, uint256 amount) public returns (bool) {
63         require(amount <= allowed[player][msg.sender] && amount <= gooBalance[player]);
64         
65         gooBalance[player] -= amount;
66         gooBalance[recipient] += amount;
67         allowed[player][msg.sender] -= amount;
68         
69         emit Transfer(player, recipient, amount);
70         return true;
71     }
72     
73     function approve(address approvee, uint256 amount) public returns (bool){
74         allowed[msg.sender][approvee] = amount;
75         emit Approval(msg.sender, approvee, amount);
76         return true;
77     }
78     
79     function allowance(address player, address approvee) public constant returns(uint256){
80         return allowed[player][approvee];
81     }
82     
83 }
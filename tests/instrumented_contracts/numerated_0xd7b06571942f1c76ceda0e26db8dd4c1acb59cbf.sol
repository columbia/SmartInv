1 pragma solidity ^0.4.19;
2 
3 /**
4     Wałęsa, dawaj moje sto milionów!
5     https://www.youtube.com/watch?v=ZBK_nZ1aGlA
6     
7     100 million of this token can be claimed by first 12197466 users,
8     who make a transfer or call walesaDawajMojeStoMilionow() function.
9  */
10 contract WalesaToken {
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14     
15     uint256 constant private MAX_UINT256 = 2**256 - 1;
16     uint256 constant private STO_MILIONOW = 10000000000;
17     
18     string constant public symbol = "WLST";
19     string constant public name = "Wałęsa Token";
20     uint8 constant public decimals = 2;
21     
22     uint256 public totalSupply;
23     uint256 private claimedSupply;
24     
25     mapping (address => bool) private claimed;
26     mapping (address => uint256) private balances;
27     mapping (address => mapping (address => uint256)) private allowed;
28     
29     function WalesaToken() public {
30         totalSupply = 0xBA1E5A * STO_MILIONOW;
31     }
32     
33     function balanceOf(address owner) public view returns (uint256) {
34         if (!claimed[owner] && claimedSupply < totalSupply) {
35             return STO_MILIONOW;
36         }
37         return balances[owner];
38     }
39     
40     function transfer(address to, uint256 value) public returns (bool) {
41         walesaDawajNaszeStoMilionow(msg.sender);
42         walesaDawajNaszeStoMilionow(to);
43         require(balances[msg.sender] >= value);
44         balances[msg.sender] -= value;
45         balances[to] += value;
46         Transfer(msg.sender, to, value);
47         return true;
48     }
49     
50     function transferFrom(address from, address to, uint256 value) public returns (bool) {
51         require(allowed[from][msg.sender] >= value);
52         if (allowed[from][msg.sender] < MAX_UINT256) {
53             allowed[from][msg.sender] -= value;
54         }
55         walesaDawajNaszeStoMilionow(from);
56         walesaDawajNaszeStoMilionow(to);
57         require(balances[from] >= value);
58         balances[from] -= value;
59         balances[to] += value;
60         Transfer(from, to, value);
61         return true;
62     }
63     
64     function approve(address spender, uint256 value) public returns (bool) {
65         require(allowed[msg.sender][spender] == 0 || value == 0);
66         allowed[msg.sender][spender] = value;
67         Approval(msg.sender, spender, value);
68         return true;
69     }
70     
71     function allowance(address owner, address spender) public view returns (uint256) {
72         return allowed[owner][spender];
73     }
74     
75     function walesaDawajMojeStoMilionow() public {
76         walesaDawajNaszeStoMilionow(msg.sender);
77     }
78     
79     function walesaDawajNaszeStoMilionow(address owner) private {
80         if (!claimed[owner] && claimedSupply < totalSupply) {
81             claimed[owner] = true;
82             balances[owner] = STO_MILIONOW;
83             claimedSupply += STO_MILIONOW;
84         }
85     }
86 }
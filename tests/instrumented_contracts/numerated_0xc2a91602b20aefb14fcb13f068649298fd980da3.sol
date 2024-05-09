1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 
4 /**
5  * @title INT Coin (trade-mining coin)
6  */
7 
8 
9 /**
10  * @title ERC20 Standard Interface
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address who) external view returns (uint256);
15     function transfer(address to, uint256 value) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title INTCoin implementation
22  */
23 contract INTCoin is IERC20 {
24     string public name = "INT";
25     string public symbol = "INT";
26     uint8 public decimals = 18;
27     
28     uint256 preSaleAmount;
29     uint256 mktAmount;
30     uint256 rndAmount;
31     uint256 teamAmount;
32     uint256 miningAmount;
33     
34     uint256 _totalSupply;
35     mapping(address => uint256) balances;
36 
37     // Admin Address
38     address public owner;
39     address public master;
40     address public rnd;
41     address public team;
42     
43     modifier isOwner {
44         require(owner == msg.sender);
45         _;
46     }
47     
48     constructor() public {
49         owner = msg.sender;
50         master = 0xdae5de7e76f6f2d7d91c984d76fa2deb7b025baa;
51         rnd    = 0x15bB050a89081e95ebAb17b6921Fcfdc675395C2;
52         team   = 0x216B46BB70D9E08B3078e8B564c62E263e240E91;
53         require(owner != rnd);
54         require(owner != team);
55 
56         preSaleAmount   = toWei(1250000000);  //1,250,000,000
57         mktAmount       = toWei(875000000);   //875,000,000
58         rndAmount       = toWei(312500000);   //312,500,000
59         teamAmount      = toWei(937500000);   //937,500,000
60         miningAmount    = toWei(3125000000);  //3,125,000,000
61         _totalSupply    = toWei(6500000000);  //6,500,000,000
62 
63         require(_totalSupply == preSaleAmount + mktAmount + rndAmount + teamAmount + miningAmount);
64         
65         balances[owner] = _totalSupply;
66         emit Transfer(address(0), owner, balances[owner]);
67         
68         transfer(rnd, rndAmount);
69         transfer(team, teamAmount);
70         require(balances[owner] == miningAmount + preSaleAmount + mktAmount);
71         
72         transfer(master, balances[owner]);
73         require(balances[owner] == 0);
74     }
75     
76     function totalSupply() public constant returns (uint) {
77         return _totalSupply;
78     }
79 
80     function balanceOf(address who) public view returns (uint256) {
81         return balances[who];
82     }
83     
84     function transfer(address to, uint256 value) public returns (bool success) {
85         require(msg.sender != to);
86         //require(msg.sender != owner);   // owner is not free to transfer
87         require(to != owner);
88         require(value > 0);
89         
90         require( balances[msg.sender] >= value );
91         require( balances[to] + value >= balances[to] );    // prevent overflow
92 
93         if(msg.sender == rnd) {
94             require(now >= 1566662400);     // 100% lock to 2019-08-25
95         }
96 
97         if(msg.sender == team) {
98             require(now >= 1566662400);     // 100% lock to 2019-08-25
99         }
100 
101         balances[msg.sender] -= value;
102         balances[to] += value;
103 
104         emit Transfer(msg.sender, to, value);
105         return true;
106     }
107     
108     function burnCoins(uint256 value) public {
109         require(msg.sender != owner);   // owner can't burn any coin
110         require(balances[msg.sender] >= value);
111         require(_totalSupply >= value);
112         
113         balances[msg.sender] -= value;
114         _totalSupply -= value;
115 
116         emit Transfer(msg.sender, address(0), value);
117     }
118 
119     function rndValance() public view returns (uint256) {
120         return balances[rnd];
121     }
122     
123     /** @dev private function
124      */
125 
126     function toWei(uint256 value) private constant returns (uint256) {
127         return value * (10 ** uint256(decimals));
128     }
129 }
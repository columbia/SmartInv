1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 
4 /**
5  * @title ONBT token - Issued by OnBIT.
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
21  * @title Token implementation
22  */
23 contract ONBT is IERC20 {
24     string public name = "OnBIT Token";
25     string public symbol = "ONBT";
26     uint8 public decimals = 18;
27     
28     uint256 exAmount;
29     uint256 reserveAmount;
30     
31     uint256 _totalSupply;
32     mapping(address => uint256) balances;
33 
34     address public owner;
35     address public reserve;
36 
37     modifier isOwner {
38         require(owner == msg.sender);
39         _;
40     }
41     
42     constructor() public {
43         owner = msg.sender;
44         reserve   = 0x5BDd983b96AC7337e976f60229898Ae816fe2c47;
45 
46         exAmount        = toWei(4650000000);   // 4,650,000,000
47         reserveAmount   = toWei(350000000);    //   350,000,000
48         _totalSupply    = toWei(5000000000);   // 5,000,000,000
49 
50         require(_totalSupply == exAmount + reserveAmount );
51         
52         balances[owner] = _totalSupply;
53         emit Transfer(address(0), owner, balances[owner]);
54         
55         transfer(reserve, reserveAmount);
56         require(balances[owner] == exAmount);
57     }
58     
59     function totalSupply() public constant returns (uint) {
60         return _totalSupply;
61     }
62 
63     function balanceOf(address who) public view returns (uint256) {
64         return balances[who];
65     }
66     
67     function transfer(address to, uint256 value) public returns (bool success) {
68         require(msg.sender != to);
69 
70         require(to != owner);
71         require(value > 0);
72         
73         require( balances[msg.sender] >= value );
74         require( balances[to] + value >= balances[to] );    // prevent overflow
75 
76         if(msg.sender == reserve) {
77             require(now >= 1587600000);     // 350M lock to 2020-04-23
78         }
79 
80         if (to == address(0) || to == address(0x1) || to == address(0xdead)) {
81              _totalSupply -= value;
82         }
83 
84 
85         balances[msg.sender] -= value;
86         balances[to] += value;
87 
88         emit Transfer(msg.sender, to, value);
89         return true;
90     }
91     
92     function burnCoins(uint256 value) public {
93         require(msg.sender != owner);   // owner can't burn any coin
94         require(balances[msg.sender] >= value);
95         require(_totalSupply >= value);
96         
97         balances[msg.sender] -= value;
98         _totalSupply -= value;
99 
100         emit Transfer(msg.sender, address(0), value);
101     }
102 
103     function balanceOfOwner() public view returns (uint256) {
104         return balances[owner];
105     }
106     
107     /** @dev private function
108      */
109 
110     function toWei(uint256 value) private constant returns (uint256) {
111         return value * (10 ** uint256(decimals));
112     }
113 }
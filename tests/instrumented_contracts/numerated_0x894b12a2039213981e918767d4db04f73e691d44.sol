1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 
4 /**
5  * @title INTR token - Issued by CS Holdings.
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
23 contract INTR is IERC20 {
24     string public name = "INT R";
25     string public symbol = "INTR";
26     uint8 public decimals = 18;
27     
28     uint256 _totalSupply;
29     mapping(address => uint256) balances;
30 
31     address public owner;
32 
33     modifier isOwner {
34         require(owner == msg.sender);
35         _;
36     }
37     
38     constructor() public {
39         owner = msg.sender;
40 
41         _totalSupply    = toWei(500000000000);  //500,000,000,000
42 
43 
44         balances[owner] = _totalSupply;
45         emit Transfer(address(0), owner, balances[owner]);
46         
47     }
48     
49     function totalSupply() public constant returns (uint) {
50         return _totalSupply;
51     }
52 
53     function balanceOf(address who) public view returns (uint256) {
54         return balances[who];
55     }
56     
57     function transfer(address to, uint256 value) public returns (bool success) {
58         require(msg.sender != to);
59         require(to != owner);
60         require(value > 0);
61         
62         require( balances[msg.sender] >= value );
63         require( balances[to] + value >= balances[to] );    // prevent overflow
64 
65 
66         balances[msg.sender] -= value;
67         balances[to] += value;
68 
69         emit Transfer(msg.sender, to, value);
70         return true;
71     }
72     
73     function burnCoins(uint256 value) public {
74         require(msg.sender != owner);   // owner can't burn any coin
75         require(balances[msg.sender] >= value);
76         require(_totalSupply >= value);
77         
78         balances[msg.sender] -= value;
79         _totalSupply -= value;
80 
81         emit Transfer(msg.sender, address(0), value);
82     }
83 
84     function balanceOfOwner() public view returns (uint256) {
85         return balances[owner];
86     }
87     
88     /** @dev private function
89      */
90 
91     function toWei(uint256 value) private constant returns (uint256) {
92         return value * (10 ** uint256(decimals));
93     }
94 }
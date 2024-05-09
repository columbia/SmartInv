1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 /**
4  * @title KACHA token - Issued by KACHA.
5  * created by jhan.kwon@gmail.com
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
23 contract KACHA is IERC20 {
24     string public name = "KACHA Token";
25     string public symbol = "KACHA";
26     uint8 public decimals = 18;
27     
28     uint256 _totalSupply;
29     mapping(address => uint256) balances;
30 
31     address public owner;
32 
33 
34     modifier isOwner {
35         require(owner == msg.sender);
36         _;
37     }
38     
39     constructor() public {
40         owner = msg.sender;
41 
42         _totalSupply    = toWei(2000000000);  //2,000,000,000
43 
44 
45         balances[owner] = _totalSupply;
46         emit Transfer(address(0), owner, balances[owner]);
47         
48     }
49     
50     function totalSupply() public constant returns (uint) {
51         return _totalSupply;
52     }
53 
54     function balanceOf(address who) public view returns (uint256) {
55         return balances[who];
56     }
57     
58     function transfer(address to, uint256 value) public returns (bool success) {
59         require(msg.sender != to);
60         //require(msg.sender != owner);   // owner is not free to transfer
61         require(to != owner);
62         require(value > 0);
63         
64         require( balances[msg.sender] >= value );
65         require( balances[to] + value >= balances[to] );    // prevent overflow
66 
67 
68         if (to == address(0) || to == address(0x1) || to == address(0xdead)) {
69              _totalSupply -= value;
70         }
71 
72 
73         balances[msg.sender] -= value;
74         balances[to] += value;
75 
76         emit Transfer(msg.sender, to, value);
77         return true;
78     }
79     
80     function burnCoins(uint256 value) public {
81         require(msg.sender != owner);   // owner can't burn any coin
82         require(balances[msg.sender] >= value);
83         require(_totalSupply >= value);
84         
85         balances[msg.sender] -= value;
86         _totalSupply -= value;
87 
88         emit Transfer(msg.sender, address(0), value);
89     }
90 
91     function balanceOfOwner() public view returns (uint256) {
92         return balances[owner];
93     }
94     
95     function toWei(uint256 value) private constant returns (uint256) {
96         return value * (10 ** uint256(decimals));
97     }
98 }
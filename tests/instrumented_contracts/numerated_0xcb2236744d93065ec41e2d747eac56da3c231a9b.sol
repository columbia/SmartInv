1 pragma solidity >= 0.4.24 < 0.6.0;
2 
3 /**
4  * @title DCK Token
5  */
6 
7 /**
8  * @title ERC20 Standard Interface
9  */
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address who) external view returns (uint256);
13     function transfer(address to, uint256 value) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title DAU implementation
19  */
20 contract DCK is IERC20 {
21     string public name = "Doctor Cell K";
22     string public symbol = "DCK";
23     uint8 public decimals = 18;
24     
25     uint256 companyAmount;
26 
27     uint256 _totalSupply;
28     mapping(address => uint256) balances;
29 
30     // Addresses
31     address public owner;
32     address public company;
33 
34     modifier isOwner {
35         require(owner == msg.sender);
36         _;
37     }
38     
39     constructor() public {
40         owner = msg.sender;
41 
42         company = 0xaD3Cb6933A14888dCfB5DDAf623396877e198AEe;
43 
44         companyAmount  = toWei(1000000000);
45         _totalSupply   = toWei(1000000000);  //1,000,000,000
46 
47         require(_totalSupply == companyAmount );
48         
49         balances[owner] = _totalSupply;
50 
51         emit Transfer(address(0), owner, balances[owner]);
52         
53         transfer(company, companyAmount);
54 
55         require(balances[owner] == 0);
56     }
57     
58     function totalSupply() public view returns (uint) {
59         return _totalSupply;
60     }
61 
62     function balanceOf(address who) public view returns (uint256) {
63         return balances[who];
64     }
65     
66     function transfer(address to, uint256 value) public returns (bool success) {
67         require(msg.sender != to);
68         require(to != owner);
69         require(value > 0);
70         
71         require( balances[msg.sender] >= value );
72         require( balances[to] + value >= balances[to] );    // prevent overflow
73 
74 
75         balances[msg.sender] -= value;
76         balances[to] += value;
77 
78         emit Transfer(msg.sender, to, value);
79         return true;
80     }
81     
82     function burnCoins(uint256 value) public {
83         require(balances[msg.sender] >= value);
84         require(_totalSupply >= value);
85         
86         balances[msg.sender] -= value;
87         _totalSupply -= value;
88 
89         emit Transfer(msg.sender, address(0), value);
90     }
91 
92     function toWei(uint256 value) private view returns (uint256) {
93         return value * (10 ** uint256(decimals));
94     }
95 }
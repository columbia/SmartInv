1 pragma solidity ^0.4.2;
2 
3 contract CoinByInsomnia {
4     string  public name = "CoinByInsomnia";
5     string  public symbol = "CBI";
6     string  public standard = "CoinByInsomnia v1.0";
7     uint256 public _totalSupply = 100000000;
8     
9 
10     event Transfer(
11         address indexed _from,
12         address indexed _to,
13         uint256 _value
14     );
15 
16     event Approval(
17         address indexed _owner,
18         address indexed _spender,
19         uint256 _value
20     );
21 
22     mapping(address => uint256) public balanceOf;
23     mapping(address => mapping(address => uint256)) public allowance;
24 
25     constructor (uint256 _initialSupply) public {
26         balanceOf[msg.sender] = _initialSupply;
27         _totalSupply = _initialSupply;
28     }
29     
30 
31     function transfer(address _to, uint256 _value) public returns (bool success) {
32         require(balanceOf[msg.sender] >= _value);
33 
34         balanceOf[msg.sender] -= _value;
35         balanceOf[_to] += _value;
36 
37         emit Transfer(msg.sender, _to, _value);
38 
39         return true;
40     }
41 
42     function approve(address _spender, uint256 _value) public returns (bool success) {
43         allowance[msg.sender][_spender] = _value;
44 
45        emit Approval(msg.sender, _spender, _value);
46 
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= balanceOf[_from]);
52         require(_value <= allowance[_from][msg.sender]);
53 
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56 
57         allowance[_from][msg.sender] -= _value;
58 
59         emit Transfer(_from, _to, _value);
60 
61         return true;
62     }
63 }
64 
65 contract CoinByInsomniaTokenSale {
66     address admin;
67     CoinByInsomnia public tokenContract;
68     uint256 public tokenPrice;
69     uint256 public tokensSold;
70 
71     event Sell(address _buyer, uint256 _amount);
72 
73    constructor (CoinByInsomnia _tokenContract, uint256 _tokenPrice) public {
74         admin = msg.sender;
75         tokenContract = _tokenContract;
76         tokenPrice = _tokenPrice;
77     }
78 
79     function multiply(uint x, uint y) internal pure returns (uint z) {
80         require(y == 0 || (z = x * y) / y == x);
81     }
82 
83     function buyTokens(uint256 _numberOfTokens) public payable {
84         require(msg.value == multiply(_numberOfTokens, tokenPrice));
85         require(tokenContract.balanceOf(this) >= _numberOfTokens);
86         require(tokenContract.transfer(msg.sender, _numberOfTokens));
87 
88         tokensSold += _numberOfTokens;
89 
90         emit Sell(msg.sender, _numberOfTokens);
91     }
92 
93     function endSale() public {
94         require(msg.sender == admin);
95         require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
96 
97         // UPDATE: Let's not destroy the contract here
98         // Just transfer the balance to the admin
99         admin.transfer(address(this).balance);
100     }
101 }
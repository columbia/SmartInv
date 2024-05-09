1 pragma solidity ^0.4.2;
2 
3 contract StephenZhengToken {
4     string  public name = "Stephen Zheng Token";
5     string  public symbol = "SZZT";
6     string  public standard = "Stephen Zheng Token v1.0";
7     uint256 public totalSupply;
8 
9     event Transfer(
10         address indexed _from,
11         address indexed _to,
12         uint256 _value
13     );
14 
15     event Approval(
16         address indexed _owner,
17         address indexed _spender,
18         uint256 _value
19     );
20 
21     mapping(address => uint256) public balanceOf;
22     mapping(address => mapping(address => uint256)) public allowance;
23 
24     function StephenZhengToken () public {
25         totalSupply = 1000000000;
26         balanceOf[msg.sender] = totalSupply;
27     }
28 
29     function transfer(address _to, uint256 _value) public returns (bool success) {
30         require(balanceOf[msg.sender] >= _value);
31 
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34 
35         emit Transfer(msg.sender, _to, _value);
36 
37         return true;
38     }
39 
40     function approve(address _spender, uint256 _value) public returns (bool success) {
41         allowance[msg.sender][_spender] = _value;
42 
43         emit Approval(msg.sender, _spender, _value);
44 
45         return true;
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= balanceOf[_from]);
50         require(_value <= allowance[_from][msg.sender]);
51 
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54 
55         allowance[_from][msg.sender] -= _value;
56 
57         emit Transfer(_from, _to, _value);
58 
59         return true;
60     }
61 }
62 
63 contract StephenZhengTokenSale {
64     address admin;
65     StephenZhengToken public tokenContract;
66     uint256 public tokenPrice;
67     uint256 public tokensSold;
68 
69     event Sell(address _buyer, uint256 _amount);
70 
71     function StephenZhengTokenSale(StephenZhengToken _tokenContract, uint256 _tokenPrice) public {
72         admin = msg.sender;
73         tokenContract = _tokenContract;
74         tokenPrice = _tokenPrice;
75     }
76 
77     function multiply(uint x, uint y) internal pure returns (uint z) {
78         require(y == 0 || (z = x * y) / y == x);
79     }
80 
81     function buyTokens(uint256 _numberOfTokens) public payable {
82         require(msg.value == multiply(_numberOfTokens, tokenPrice));
83         require(tokenContract.balanceOf(this) >= _numberOfTokens);
84         require(tokenContract.transfer(msg.sender, _numberOfTokens));
85 
86         tokensSold += _numberOfTokens;
87 
88         emit Sell(msg.sender, _numberOfTokens);
89     }
90 
91     function endSale() public {
92         require(msg.sender == admin);
93         require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
94 
95         selfdestruct(admin);
96     }
97 }
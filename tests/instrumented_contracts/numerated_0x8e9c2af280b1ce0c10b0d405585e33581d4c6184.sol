1 pragma solidity ^0.4.25;
2 
3 contract Token {
4     string  public name;
5     string  public symbol;
6     //string  public standard = "Token v1.0";
7     uint256 public totalSupply;
8     //
9     address public minter;
10 
11     event Transfer(
12         address indexed _from,
13         address indexed _to,
14         uint256 _value
15     );
16 
17     event Approval(
18         address indexed _owner,
19         address indexed _spender,
20         uint256 _value
21     );
22 
23     mapping(address => uint256) public balanceOf;
24     mapping(address => mapping(address => uint256)) public allowance;
25 
26     constructor (uint256 _initialSupply, string memory _name, string memory _symbol, address _minter) public {
27         balanceOf[_minter] = _initialSupply;
28         totalSupply = _initialSupply;
29         name = _name;
30         symbol =_symbol;
31         //
32         minter =_minter;
33     }
34 
35     function transfer(address _to, uint256 _value) public returns (bool success) {
36         require(balanceOf[msg.sender] >= _value);
37 
38         balanceOf[msg.sender] -= _value;
39         balanceOf[_to] += _value;
40 
41         emit Transfer(msg.sender, _to, _value);
42 
43         return true;
44     }
45 
46     function approve(address _spender, uint256 _value) public returns (bool success) {
47         allowance[msg.sender][_spender] = _value;
48 
49         emit Approval(msg.sender, _spender, _value);
50 
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= balanceOf[_from]);
56         require(_value <= allowance[_from][msg.sender]);
57 
58         balanceOf[_from] -= _value;
59         balanceOf[_to] += _value;
60 
61         allowance[_from][msg.sender] -= _value;
62 
63         emit Transfer(_from, _to, _value);
64 
65         return true;
66     }
67 
68     function getTokenDetails() public view returns(address _minter, string memory _name, string memory _symbol, uint256 _totalsupply) {
69         return(minter, name, symbol, totalSupply);
70     }
71 }
72 
73 contract tokenSale {
74     address admin;
75     Token public tokenContract;
76     uint256 public tokenPrice;
77     uint256 public tokensSold;
78     string public phasename;
79 
80     event Sell(address _buyer, uint256 _amount);
81 
82     constructor (Token _tokenContract, uint256 _tokenPrice, string memory _phasename, address _admin) public {
83         admin = _admin;
84         tokenContract = _tokenContract;
85         tokenPrice = _tokenPrice;
86         phasename = _phasename;
87     }
88 
89     function multiply(uint x, uint y) internal pure returns (uint z) {
90         require(y == 0 || (z = x * y) / y == x);
91     }
92     // buying tokens from wallet other than metamask, which requires token recipient address
93     function rbuyTokens(address recipient_addr, uint256 _numberOfTokens) public payable {
94         require(msg.sender==admin);
95         require(msg.value == multiply(_numberOfTokens, tokenPrice));
96         require(tokenContract.balanceOf(address(this)) >= _numberOfTokens);
97         require(tokenContract.transfer(recipient_addr, _numberOfTokens));
98 
99         tokensSold += _numberOfTokens;
100 
101         emit Sell(msg.sender, _numberOfTokens);
102     }
103 
104     function approveone(address spender, uint256 value) public {
105         require(msg.sender==admin);
106         tokenContract.approve(spender, value);
107     }
108 
109     function buyTokens(uint256 _numberOfTokens) public payable {
110         require(msg.value == multiply(_numberOfTokens, tokenPrice));
111         require(tokenContract.balanceOf(address(this)) >= _numberOfTokens); //----!!!!!!!
112         require(tokenContract.transfer(msg.sender, _numberOfTokens));
113 
114         tokensSold += _numberOfTokens;
115 
116         emit Sell(msg.sender, _numberOfTokens);
117     }
118 
119     function getmoney() public {
120         require(msg.sender==admin);
121         msg.sender.transfer(address(this).balance);
122     }
123 
124     function endSale() public {
125         require(msg.sender == admin);
126         require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));
127 
128         // UPDATE: Let's not destroy the contract here
129         // Just transfer the balance to the admin
130         msg.sender.transfer(address(this).balance);
131     }
132 }
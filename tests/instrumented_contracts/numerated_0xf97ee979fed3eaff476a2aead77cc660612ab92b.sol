1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function mul(uint256 _x, uint256 _y) internal pure returns (uint256 z) {
5         if (_x == 0) {
6             return 0;
7         }
8         z = _x * _y;
9         assert(z / _x == _y);
10         return z;
11     }
12 
13     function div(uint256 _x, uint256 _y) internal pure returns (uint256) {
14         return _x / _y;
15     }
16 
17     function sub(uint256 _x, uint256 _y) internal pure returns (uint256) {
18         assert(_y <= _x);
19         return _x - _y;
20     }
21 
22     function add(uint256 _x, uint256 _y) internal pure returns (uint256 z) {
23         z = _x + _y;
24         assert(z >= _x);
25         return z;
26     }
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed _previousOwner, address indexed _newOwner);
33 
34     constructor() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address _newOwner) onlyOwner public {
44         require(_newOwner != address(0));
45 
46         owner = _newOwner;
47 
48         emit OwnershipTransferred(owner, _newOwner);
49     }
50 }
51 
52 contract Erc20Wrapper {
53     function totalSupply() public view returns (uint256);
54     function balanceOf(address _who) public view returns (uint256);
55     function transfer(address _to, uint256 _value) public returns (bool);
56     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
57     function approve(address _spender, uint256 _value) public returns (bool);
58     function allowance(address _owner, address _spender) public view returns (uint256);
59 
60     event Transfer(address indexed _from, address indexed _to, uint256 _value);
61     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
62 }
63 
64 contract LemurTokenSale is Ownable {
65     using SafeMath for uint256;
66 
67     Erc20Wrapper public token;
68 
69     address public wallet;
70 
71     uint256 public rate;
72     uint256 public amountRaised;
73 
74     uint256 public openingTime;
75     uint256 public closingTime;
76 
77     event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
78 
79     constructor() public {
80         // solium-disable-next-line security/no-block-members
81         openingTime = block.timestamp;
82         closingTime = openingTime.add(90 days);
83     }
84 
85     function setToken(Erc20Wrapper _token) onlyOwner public {
86         require(_token != address(0));
87         token = _token;
88     }
89 
90     function setWallet(address _wallet) onlyOwner public {
91         require(_wallet != address(0));
92         wallet = _wallet;
93     }
94 
95     function setRate(uint256 _rate) onlyOwner public {
96         require(_rate > 0);
97         rate = _rate;
98     }
99 
100     function setClosingTime(uint256 _days) onlyOwner public {
101         require(_days >= 1);
102         closingTime = openingTime.add(_days.mul(1 days));
103     }
104 
105     function hasClosed() public view returns (bool) {
106         // solium-disable-next-line security/no-block-members
107         return block.timestamp > closingTime;
108     }
109 
110     function () external payable {
111         buyTokens(msg.sender);
112     }
113 
114     function buyTokens(address _beneficiary) public payable {
115         require(!hasClosed());
116         require(token != address(0) && wallet != address(0) && rate > 0);
117         require(_beneficiary != address(0));
118 
119         uint256 amount = msg.value;
120         require(amount >= 0.01 ether);
121 
122         uint256 tokenAmount = amount.mul(rate);
123         amountRaised = amountRaised.add(amount);
124         require(token.transfer(_beneficiary, tokenAmount));
125 
126         emit TokenPurchase(msg.sender, _beneficiary, amount, tokenAmount);
127 
128         wallet.transfer(amount);
129     }
130 }
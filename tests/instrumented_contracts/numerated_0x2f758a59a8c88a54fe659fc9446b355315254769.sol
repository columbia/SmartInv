1 pragma solidity ^0.4.19;
2 
3 contract DAO {
4 
5   using SafeMath for uint256;
6 
7   ERC20 public typeToken;
8   address public owner;
9   address public burnAddress = 0x0000000000000000000000000000000000000000;
10   uint256 public tokenDecimals;
11   uint256 public unburnedTypeTokens;
12   uint256 public weiPerWholeToken = 0.1 ether;
13 
14   event LogLiquidation(address indexed _to, uint256 _typeTokenAmount, uint256 _ethAmount, uint256 _newTotalSupply);
15 
16   modifier onlyOwner () {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function DAO (address _typeToken, uint256 _tokenDecimals) public {
22     typeToken = ERC20(_typeToken);
23     tokenDecimals = _tokenDecimals;
24     unburnedTypeTokens = typeToken.totalSupply();
25     owner = msg.sender;
26   }
27 
28   function exchangeTokens (uint256 _amount) public {
29     require(typeToken.transferFrom(msg.sender, address(this), _amount));
30     uint256 percentageOfPotToSend = _percent(_amount, unburnedTypeTokens, 8);
31     uint256 ethToSend = (address(this).balance.div(100000000)).mul(percentageOfPotToSend);
32     msg.sender.transfer(ethToSend);
33     _byrne(_amount);
34     emit LogLiquidation(msg.sender, _amount, ethToSend, unburnedTypeTokens);
35   }
36 
37   function _byrne(uint256 _amount) internal {
38     require(typeToken.transfer(burnAddress, _amount));
39     unburnedTypeTokens = unburnedTypeTokens.sub(_amount);
40   }
41 
42   function updateWeiPerWholeToken (uint256 _newRate) public onlyOwner {
43     weiPerWholeToken = _newRate;
44   }
45 
46   function changeOwner (address _newOwner) public onlyOwner {
47     owner = _newOwner;
48   }
49 
50   function _percent(uint256 numerator, uint256 denominator, uint256 precision) internal returns(uint256 quotient) {
51     uint256 _numerator = numerator.mul((10 ** (precision+1)));
52     uint256 _quotient = ((_numerator / denominator) + 5) / 10;
53     return ( _quotient);
54   }
55 
56   function () public payable {}
57 
58 }
59 
60 contract ERC20 {
61   function totalSupply() public constant returns (uint256 supply);
62   function balanceOf(address _owner) public constant returns (uint256 balance);
63   function transfer(address _to, uint256 _value) public returns (bool success);
64   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
65   function approve(address _spender, uint256 _value) public returns (bool success);
66   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
67 
68   event Transfer(address indexed from, address indexed to, uint256 value);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
79     if (a == 0) {
80       return 0;
81     }
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     return a / b;
89   }
90 
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
97     c = a + b;
98     assert(c >= a);
99     return c;
100   }
101 }
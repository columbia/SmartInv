1 pragma solidity ^0.4.19;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract INeoToken{
26     function buyToken(address to, uint tokens) public returns (bool success);
27 }
28 
29 /**
30  * @title NeoCrowdsale
31  * @dev NeoCrowdsale accepting contributions only within a time frame.
32  */
33 contract NeoCrowdsale {
34   using SafeMath for uint256; 
35   uint256 public openingTime;
36   uint256 public closingTime;
37   address public wallet;      // Address where funds are collected
38   uint256 public rate;        // How many token units a buyer gets per wei
39   uint256 public weiRaised;   // Amount of wei raised
40   INeoToken public token;
41   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
42   /**
43    * @dev Reverts if not in crowdsale time range. 
44    */
45   modifier onlyWhileOpen {
46     require(now >= openingTime && now <= closingTime);
47     _;
48   }
49   
50   function NeoCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
51     require(_openingTime >= now);
52     require(_closingTime >= _openingTime);
53 
54     openingTime = _openingTime;
55     closingTime = _closingTime;
56 
57     // takes an address of the existing token contract as parameter
58     token = INeoToken(0x468a553b152f65a482e1669672b0dbcd20f9fb50);
59     wallet = 0x0c4BdfE0aEbF69dE4975a957A2d4FE72633BBC1a;
60     rate = 15000; // rate per wei
61   }
62 
63   function () external payable {
64     buyTokens(msg.sender);
65   }
66 
67   function buyTokens(address _beneficiary) public payable {
68 
69     uint256 weiAmount = msg.value;
70     _preValidatePurchase(_beneficiary, weiAmount);
71 
72     // calculate token amount to be created
73     uint256 tokens = _getTokenAmount(weiAmount);
74     
75     // update state
76     weiRaised = weiRaised.add(weiAmount);
77 
78     _processPurchase(_beneficiary, tokens);
79     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
80 
81     _forwardFunds(); 
82   }
83   
84   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) public onlyWhileOpen{
85     require(_beneficiary != address(0));
86     require(_weiAmount != 0);
87   }
88   
89   function _getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
90     return _weiAmount.mul(rate);
91   }
92   
93   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
94     token.buyToken(_beneficiary, _tokenAmount);
95   }
96 
97   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
98     _deliverTokens(_beneficiary, _tokenAmount);
99   }
100   
101   function _forwardFunds() internal {
102     wallet.transfer(msg.value);
103   }
104 
105 }
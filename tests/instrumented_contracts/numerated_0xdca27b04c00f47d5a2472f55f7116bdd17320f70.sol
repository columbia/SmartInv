1 // Bravo Coin ICO Phase 2
2 // ** 1 ETH = 3333 BRV **
3 
4 pragma solidity ^0.4.18;
5 
6 contract ICOPhase2{
7   using SafeMath for uint256;
8 
9   ERC20 public token;
10   address public wallet;
11   uint256 public rate;
12   uint256 public weiRaised;
13 
14   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
15 
16 
17   function ICOPhase2(uint256 _rate, address _wallet, ERC20 _token) public {
18     require(_rate > 0);
19     require(_wallet != address(0));
20     require(_token != address(0));
21 
22     rate = _rate;
23     wallet = _wallet;
24     token = _token; }
25 
26 
27   function () external payable {
28     buyTokens(msg.sender);}
29 
30 
31   function buyTokens(address _beneficiary) public payable {
32 
33     uint256 weiAmount = msg.value;
34     _preValidatePurchase(_beneficiary, weiAmount);
35 
36     uint256 tokens = _getTokenAmount(weiAmount);
37 
38     weiRaised = weiRaised.add(weiAmount);
39 
40     _processPurchase(_beneficiary, tokens);
41     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
42 
43     _updatePurchasingState(_beneficiary, weiAmount);
44 
45     _forwardFunds();
46     _postValidatePurchase(_beneficiary, weiAmount); }
47 
48 
49   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
50     require(_beneficiary != address(0));
51     require(_weiAmount != 0); }
52 
53 
54   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
55 
56 
57   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
58     token.transfer(_beneficiary, _tokenAmount); }
59 
60 
61   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
62     _deliverTokens(_beneficiary, _tokenAmount); }
63 
64 
65   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
66 
67 
68   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
69     return _weiAmount.mul(rate); }
70 
71 
72   function _forwardFunds() internal {
73     wallet.transfer(msg.value); }}
74 
75 library SafeMath {
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0; }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c; }
82     
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a / b;
85     return c; }
86     
87   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88     assert(b <= a);
89     return a - b; }
90     
91   function add(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a + b;
93     assert(c >= a);
94     return c;}}
95     
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);}
101 
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) public view returns (uint256);
104   function transferFrom(address from, address to, uint256 value) public returns (bool);
105   function approve(address spender, uint256 value) public returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);}
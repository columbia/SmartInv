1 // Bravo Coin ICO Phase 3
2 // 1 ETH = 2857 BRV
3 // 1 BRV = 0.00035 ETH 
4 
5 pragma solidity ^0.4.18;
6 
7 contract ICOPhase3{
8   using SafeMath for uint256;
9 
10   ERC20 public token;
11   address public wallet;
12   uint256 public rate;
13   uint256 public weiRaised;
14 
15   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
16 
17 
18   function ICOPhase3(uint256 _rate, address _wallet, ERC20 _token) public {
19     require(_rate > 0);
20     require(_wallet != address(0));
21     require(_token != address(0));
22 
23     rate = _rate;
24     wallet = _wallet;
25     token = _token; }
26 
27 
28   function () external payable {
29     buyTokens(msg.sender);}
30 
31 
32   function buyTokens(address _beneficiary) public payable {
33 
34     uint256 weiAmount = msg.value;
35     _preValidatePurchase(_beneficiary, weiAmount);
36 
37     uint256 tokens = _getTokenAmount(weiAmount);
38 
39     weiRaised = weiRaised.add(weiAmount);
40 
41     _processPurchase(_beneficiary, tokens);
42     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
43 
44     _updatePurchasingState(_beneficiary, weiAmount);
45 
46     _forwardFunds();
47     _postValidatePurchase(_beneficiary, weiAmount); }
48 
49 
50   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
51     require(_beneficiary != address(0));
52     require(_weiAmount != 0); }
53 
54 
55   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
56 
57 
58   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
59     token.transfer(_beneficiary, _tokenAmount); }
60 
61 
62   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
63     _deliverTokens(_beneficiary, _tokenAmount); }
64 
65 
66   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
67 
68 
69   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
70     return _weiAmount.mul(rate); }
71 
72 
73   function _forwardFunds() internal {
74     wallet.transfer(msg.value); }}
75 
76 library SafeMath {
77   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78     if (a == 0) {
79       return 0; }
80     uint256 c = a * b;
81     assert(c / a == b);
82     return c; }
83     
84   function div(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a / b;
86     return c; }
87     
88   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
89     assert(b <= a);
90     return a - b; }
91     
92   function add(uint256 a, uint256 b) internal pure returns (uint256) {
93     uint256 c = a + b;
94     assert(c >= a);
95     return c;}}
96     
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);}
102 
103 contract ERC20 is ERC20Basic {
104   function allowance(address owner, address spender) public view returns (uint256);
105   function transferFrom(address from, address to, uint256 value) public returns (bool);
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(address indexed owner, address indexed spender, uint256 value);}
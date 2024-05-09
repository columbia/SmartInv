1 pragma solidity ^0.4.18;
2 
3 
4 // Ownable
5 contract Ownable {
6   address public owner;
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     owner = msg.sender;}
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner); _; } }
14 
15 
16 contract Crowdsale is Ownable {
17   using SafeMath for uint256;
18 
19   ERC20 public token;
20   address public wallet;
21   uint256 public rate;
22   uint256 public weiRaised;
23 
24   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
25 
26   function Crowdsale (uint256 _rate, address _wallet, ERC20 _token) public {
27     require(_rate > 0);
28     require(_wallet != address(0));
29     require(_token != address(0));
30 
31     rate = _rate;
32     wallet = _wallet;
33     token = _token; }
34 
35   function () external payable {
36     buyTokens(msg.sender);}
37 
38 
39   function buyTokens(address _beneficiary) public payable {
40     require(msg.value >= 0.001 ether);
41     uint256 weiAmount = msg.value;
42     _preValidatePurchase(_beneficiary, weiAmount);
43     uint256 tokens = _getTokenAmount(weiAmount);
44     weiRaised = weiRaised.add(weiAmount);
45     _processPurchase(_beneficiary, tokens);
46     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
47     _updatePurchasingState(_beneficiary, weiAmount);
48     _forwardFunds();
49     _postValidatePurchase(_beneficiary, weiAmount); }
50 
51   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
52     require(_beneficiary != address(0));
53     require(_weiAmount != 0); }
54 
55   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
56 
57   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
58     token.transfer(_beneficiary, _tokenAmount); }
59 
60   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
61     _deliverTokens(_beneficiary, _tokenAmount); }
62 
63   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
64 
65   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
66     return _weiAmount.mul(rate); }
67 
68   function _forwardFunds() internal {
69     wallet.transfer(msg.value); }
70    
71 // Used to end the Presale
72   function TokenDestructible() public payable { }
73   function destroy(address[] tokens) onlyOwner public {
74 
75 // Transfer tokens to owner
76     for (uint256 i = 0; i < tokens.length; i++) {
77       ERC20Basic token = ERC20Basic(tokens[i]);
78       uint256 balance = token.balanceOf(this);
79       token.transfer(owner, balance);} 
80     selfdestruct(owner); }}
81     
82   
83   
84 // SafeMath    
85 library SafeMath {
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0; }
89     uint256 c = a * b;
90     assert(c / a == b);
91     return c; }
92     
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a / b;
95     return c; }
96     
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b; }
100     
101   function add(uint256 a, uint256 b) internal pure returns (uint256) {
102     uint256 c = a + b;
103     assert(c >= a);
104     return c;}}
105     
106 // ERC20Basic    
107 contract ERC20Basic {
108   function totalSupply() public view returns (uint256);
109   function balanceOf(address who) public view returns (uint256);
110   function transfer(address to, uint256 value) public returns (bool);
111   event Transfer(address indexed from, address indexed to, uint256 value);}
112 
113 // ERC20
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);}
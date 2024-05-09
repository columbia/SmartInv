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
15 // Sale
16 contract Sale is Ownable {
17   using SafeMath for uint256;
18 
19   ERC20 public token;
20   address public wallet;
21   uint256 public rate;
22   uint256 public weiRaised;
23 
24   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
25 
26   function Sale (uint256 _rate, address _wallet, ERC20 _token) public {
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
40     uint256 weiAmount = msg.value;
41     _preValidatePurchase(_beneficiary, weiAmount);
42     uint256 tokens = _getTokenAmount(weiAmount);
43     weiRaised = weiRaised.add(weiAmount);
44     _processPurchase(_beneficiary, tokens);
45     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
46     _updatePurchasingState(_beneficiary, weiAmount);
47     _forwardFunds();
48     _postValidatePurchase(_beneficiary, weiAmount); }
49 
50   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
51     require(_beneficiary != address(0));
52     require(_weiAmount != 0); }
53 
54   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
55 
56   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
57     token.transfer(_beneficiary, _tokenAmount); }
58 
59   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
60     _deliverTokens(_beneficiary, _tokenAmount); }
61 
62   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
63 
64   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
65     return _weiAmount.mul(rate); }
66 
67   function _forwardFunds() internal {
68     wallet.transfer(msg.value); }
69    
70 // Used to end the Presale
71   function TokenDestructible() public payable { }
72   function destroy(address[] tokens) onlyOwner public {
73 
74 // Transfer tokens to owner
75     for (uint256 i = 0; i < tokens.length; i++) {
76       ERC20Basic token = ERC20Basic(tokens[i]);
77       uint256 balance = token.balanceOf(this);
78       token.transfer(owner, balance);} 
79     selfdestruct(owner); }}
80     
81   
82   
83 // SafeMath    
84 library SafeMath {
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     if (a == 0) {
87       return 0; }
88     uint256 c = a * b;
89     assert(c / a == b);
90     return c; }
91     
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     uint256 c = a / b;
94     return c; }
95     
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b; }
99     
100   function add(uint256 a, uint256 b) internal pure returns (uint256) {
101     uint256 c = a + b;
102     assert(c >= a);
103     return c;}}
104     
105 // ERC20Basic    
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);}
111 
112 // ERC20
113 contract ERC20 is ERC20Basic {
114   function allowance(address owner, address spender) public view returns (uint256);
115   function transferFrom(address from, address to, uint256 value) public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(address indexed owner, address indexed spender, uint256 value);}
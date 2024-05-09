1 pragma solidity ^0.4.18;
2 
3 // Bravo Coin (BRV)
4 // ICO Contract
5 // 1 ETH = 5000 BRV
6 
7 // -----------------
8 
9 // Ownable
10 contract Ownable {
11   address public owner;
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   function Ownable() public {
15     owner = msg.sender;}
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner); _; } }
19 
20 // ICO 
21 contract ICO is Ownable {
22   using SafeMath for uint256;
23 
24   ERC20 public token;
25   address public wallet;
26   uint256 public rate;
27   uint256 public weiRaised;
28 
29   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
30 
31   function ICO (uint256 _rate, address _wallet, ERC20 _token) public {
32     require(_rate > 0);
33     require(_wallet != address(0));
34     require(_token != address(0));
35 
36     rate = _rate;
37     wallet = _wallet;
38     token = _token; }
39 
40   function () external payable {
41     buyTokens(msg.sender);}
42 
43 
44   function buyTokens(address _beneficiary) public payable {
45     require(msg.value >= 0.01 ether);
46     uint256 weiAmount = msg.value;
47     _preValidatePurchase(_beneficiary, weiAmount);
48     uint256 tokens = _getTokenAmount(weiAmount);
49     weiRaised = weiRaised.add(weiAmount);
50     _processPurchase(_beneficiary, tokens);
51     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
52     _updatePurchasingState(_beneficiary, weiAmount);
53     _forwardFunds();
54     _postValidatePurchase(_beneficiary, weiAmount); }
55 
56   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
57     require(_beneficiary != address(0));
58     require(_weiAmount != 0); }
59 
60   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
61 
62   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
63     token.transfer(_beneficiary, _tokenAmount); }
64 
65   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
66     _deliverTokens(_beneficiary, _tokenAmount); }
67 
68   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
69 
70   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
71     return _weiAmount.mul(rate); }
72 
73   function _forwardFunds() internal {
74     wallet.transfer(msg.value); }
75    
76 // Used to end the Presale
77   function TokenDestructible() public payable { }
78   function destroy(address[] tokens) onlyOwner public {
79 
80 // Transfer tokens to owner
81     for (uint256 i = 0; i < tokens.length; i++) {
82       ERC20Basic token = ERC20Basic(tokens[i]);
83       uint256 balance = token.balanceOf(this);
84       token.transfer(owner, balance);} 
85     selfdestruct(owner); }}
86     
87   
88   
89 // SafeMath    
90 library SafeMath {
91   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92     if (a == 0) {
93       return 0; }
94     uint256 c = a * b;
95     assert(c / a == b);
96     return c; }
97     
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     uint256 c = a / b;
100     return c; }
101     
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b; }
105     
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     assert(c >= a);
109     return c;}}
110     
111 // ERC20Basic    
112 contract ERC20Basic {
113   function totalSupply() public view returns (uint256);
114   function balanceOf(address who) public view returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);}
117 
118 // ERC20
119 contract ERC20 is ERC20Basic {
120   function allowance(address owner, address spender) public view returns (uint256);
121   function transferFrom(address from, address to, uint256 value) public returns (bool);
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(address indexed owner, address indexed spender, uint256 value);}
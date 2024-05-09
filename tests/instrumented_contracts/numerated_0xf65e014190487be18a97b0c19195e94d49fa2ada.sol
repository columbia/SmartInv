1 pragma solidity ^0.4.18;
2 
3 // Bravo Coin (BRV)
4 // Presale Contract
5 // 1 ETH = 15000 BRV
6 
7 // -----------------
8 
9 // Ownable
10 
11 contract Ownable {
12   address public owner;
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   function Ownable() public {
16     owner = msg.sender;}
17 
18   modifier onlyOwner() {
19     require(msg.sender == owner); _; } }
20 
21 // Presale
22 
23 contract Presale is Ownable {
24   using SafeMath for uint256;
25 
26   ERC20 public token;
27   address public wallet;
28   uint256 public rate;
29   uint256 public weiRaised;
30 
31   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
32 
33   function Presale (uint256 _rate, address _wallet, ERC20 _token) public {
34     require(_rate > 0);
35     require(_wallet != address(0));
36     require(_token != address(0));
37 
38     rate = _rate;
39     wallet = _wallet;
40     token = _token; }
41 
42   function () external payable {
43     buyTokens(msg.sender);}
44 
45 
46   function buyTokens(address _beneficiary) public payable {
47     require(msg.value >= 0.1 ether);
48     uint256 weiAmount = msg.value;
49     _preValidatePurchase(_beneficiary, weiAmount);
50     uint256 tokens = _getTokenAmount(weiAmount);
51     weiRaised = weiRaised.add(weiAmount);
52     _processPurchase(_beneficiary, tokens);
53     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
54     _updatePurchasingState(_beneficiary, weiAmount);
55     _forwardFunds();
56     _postValidatePurchase(_beneficiary, weiAmount); }
57 
58   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
59     require(_beneficiary != address(0));
60     require(_weiAmount != 0); }
61 
62   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal { }
63 
64   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
65     token.transfer(_beneficiary, _tokenAmount); }
66 
67   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
68     _deliverTokens(_beneficiary, _tokenAmount); }
69 
70   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal { }
71 
72   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
73     return _weiAmount.mul(rate); }
74 
75   function _forwardFunds() internal {
76     wallet.transfer(msg.value); }
77    
78 // Used to end the Presale
79 
80   function TokenDestructible() public payable { }
81   function destroy(address[] tokens) onlyOwner public {
82 
83 // Transfer tokens to owner
84 
85     for (uint256 i = 0; i < tokens.length; i++) {
86       ERC20Basic token = ERC20Basic(tokens[i]);
87       uint256 balance = token.balanceOf(this);
88       token.transfer(owner, balance);} 
89     selfdestruct(owner); }}
90     
91   
92   
93 // SafeMath    
94 
95 library SafeMath {
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     if (a == 0) {
98       return 0; }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c; }
102     
103   function div(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a / b;
105     return c; }
106     
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b; }
110     
111   function add(uint256 a, uint256 b) internal pure returns (uint256) {
112     uint256 c = a + b;
113     assert(c >= a);
114     return c;}}
115     
116 // ERC20Basic    
117     
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);}
123 
124 // ERC20
125 
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender) public view returns (uint256);
128   function transferFrom(address from, address to, uint256 value) public returns (bool);
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(address indexed owner, address indexed spender, uint256 value);}
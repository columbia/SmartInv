1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // Safe maths
4 // ----------------------------------------------------------------------------
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract TicHTUContract is ERC20Interface{
35     using SafeMath for uint;
36     
37     string public symbol;
38     string public name;
39     uint8 public decimals;
40     uint _totalSupply;
41     uint256 public rate;
42     address owner;
43     mapping(address => uint) balances;
44     mapping(address => mapping(address => uint)) allowed;
45     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
46     
47     // ------------------------------------------------------------------------
48     // Constructor
49 	// @_owner: owner's address where to keep donations
50     // ------------------------------------------------------------------------
51     constructor() public{
52         symbol = "HTU";
53         name = "HONTUBE";
54         decimals = 18;
55         rate = 500; //OBL per wei
56         owner = msg.sender;
57         _totalSupply = totalSupply();
58         balances[this] = _totalSupply;
59         emit Transfer(address(0),this,_totalSupply);
60     }
61     
62     function totalSupply() public constant returns (uint){
63        return 25000000000 * 10**uint(decimals); //25 billion
64     }
65     
66     // ------------------------------------------------------------------------
67     // Get the token balance for account `tokenOwner`
68     // ------------------------------------------------------------------------
69     function balanceOf(address tokenOwner) public constant returns (uint balance) {
70         return balances[tokenOwner];
71     }
72     
73     // ------------------------------------------------------------------------
74     // Transfers the tokens from contracts balance of OBL's
75     // ------------------------------------------------------------------------
76     function _transfer(address _to, uint _tokens) internal returns (bool success){
77         require(_to != 0x0);
78 
79         require(balances[_to] + _tokens >= balances[_to]);
80         balances[this] = balances[this].sub(_tokens);
81         balances[_to] = balances[_to].add(_tokens);
82         emit Transfer(this,_to,_tokens);
83         return true;
84     }
85 
86     // ------------------------------------------------------------------------
87     // payable function to receive ethers
88     // ------------------------------------------------------------------------
89     function () external payable{
90         _buyTokens(msg.sender);
91     }
92     // ------------------------------------------------------------------------
93     // verifies, calculates and sends tokens to beneficiary
94     // ------------------------------------------------------------------------
95     function _buyTokens(address _beneficiary) public payable{
96         
97         uint256 weiAmount = msg.value;
98         
99         // calculate OBL tokens to be delivered
100         uint256 tokens = _getTokenAmount(weiAmount);
101         
102         _preValidatePurchase(_beneficiary, weiAmount, tokens);
103 
104         _processPurchase(_beneficiary, tokens);
105         emit TokenPurchase(this, _beneficiary, weiAmount, tokens);
106 
107         _forwardFunds();
108     }
109 	// ------------------------------------------------------------------------
110     // verifies the (sender address, amount of ethers)
111 	// Checks if balance does not exceeds 650 OBL
112     // ------------------------------------------------------------------------
113     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 tokens) view internal {
114         require(_beneficiary != address(0x0));
115         require(_weiAmount != 0);
116     }
117 	// ------------------------------------------------------------------------
118     // calculates amount of tokens given weiAmount
119     // ------------------------------------------------------------------------
120     function _getTokenAmount(uint256 _weiAmount) view internal returns (uint256) {
121         return _weiAmount.mul(rate);
122     }
123     
124     // ------------------------------------------------------------------------
125     // calculates amount of tokens given weiAmount
126     // ------------------------------------------------------------------------
127     function _changeRate(uint256 _rate){
128         rate = _rate;
129     }
130 	// ------------------------------------------------------------------------
131     // calls ERC20's transfer function to send tokens to beneficiary
132     // ------------------------------------------------------------------------
133     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
134         _transfer(_beneficiary,_tokenAmount);
135     }
136 	// ------------------------------------------------------------------------
137     // deliver tokens to the beneficiary
138     // ------------------------------------------------------------------------
139     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
140         _deliverTokens(_beneficiary, _tokenAmount);
141     }
142 	// ------------------------------------------------------------------------
143     // forward donations to the owner
144     // ------------------------------------------------------------------------
145     function _forwardFunds() internal {
146         owner.transfer(msg.value);
147     }
148 }
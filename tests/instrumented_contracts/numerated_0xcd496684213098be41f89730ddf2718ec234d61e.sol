1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4 
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a && c >= b);
8     }
9 
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14 
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19 
20     function div(uint a, uint b) internal pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 contract ERC20 {
27     function totalSupply() public constant returns (uint);
28 
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30 
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32 
33     function transfer(address to, uint tokens) public returns (bool success);
34 
35     function approve(address spender, uint tokens) public returns (bool success);
36 
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38 
39     event Transfer(address indexed from, address indexed to, uint tokens);
40     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
41 }
42 
43 contract Extent {
44     using SafeMath for uint;
45 
46     address public admin; //the admin address
47     mapping(address => bool) private canClaimTokens;
48     mapping(address => uint) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
49     mapping(address => uint) public claimableAmount; //mapping of token addresses to max amount to claim
50 
51     event Deposit(address token, address user, uint amount, uint balance);
52     event Withdraw(address token, address user, uint amount, uint balance);
53 
54     modifier onlyAdmin() {
55         require(msg.sender == admin);
56         _;
57     }
58 
59     modifier onlyWhitelisted(address address_) {
60         require(canClaimTokens[address_]);
61         _;
62     }
63 
64     constructor(address admin_) public {
65         admin = admin_;
66     }
67 
68     function() public payable {
69         revert("Cannot send ETH directly to the Contract");
70     }
71 
72     function changeAdmin(address admin_) public onlyAdmin {
73         admin = admin_;
74     }
75 
76     function addToWhitelist(address address_) public onlyAdmin {
77         canClaimTokens[address_] = true;
78     }
79 
80     function addToWhitelistBulk(address[] addresses_) public onlyAdmin {
81         for (uint i = 0; i < addresses_.length; i++) {
82             canClaimTokens[addresses_[i]] = true;
83         }
84     }
85 
86     function setAmountToClaim(address token, uint amount) public onlyAdmin {
87         claimableAmount[token] = amount;
88     }
89 
90     function depositToken(address token, uint amount) public onlyAdmin {
91         //remember to call ERC20Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
92         if (token == 0) revert("Cannot deposit ETH with depositToken method");
93         if (!ERC20(token).transferFrom(msg.sender, this, amount)) revert("You didn't call approve method on Token contract");
94         tokens[token] += amount;
95         emit Deposit(token, msg.sender, amount, tokens[token]);
96     }
97 
98     function claimTokens(address token) public onlyWhitelisted(msg.sender) {
99         if (token == 0) revert("Cannot withdraw ETH with withdrawToken method");
100         if (tokens[token] < claimableAmount[token]) revert("Not enough tokens to claim");
101         tokens[token] -= claimableAmount[token];
102         canClaimTokens[msg.sender] = false;
103         if (!ERC20(token).transfer(msg.sender, claimableAmount[token])) revert("Error while transfering tokens");
104         emit Withdraw(token, msg.sender, claimableAmount[token], tokens[token]);
105     }
106 }
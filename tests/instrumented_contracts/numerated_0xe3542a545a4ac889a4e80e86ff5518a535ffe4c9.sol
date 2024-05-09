1 pragma solidity ^0.4.21;
2 
3 // File: contracts/TokenHolder.sol
4 
5 /*
6 
7    Token Holder
8    Hold ERC20 tokens to be withdrawn
9    by a user at a specific block.
10 
11    - Element Group
12 
13 */
14 
15 
16 contract ERC20 {
17     function totalSupply() public constant returns (uint);
18     function balanceOf(address tokenOwner) public constant returns (uint balance);
19     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
20     function transfer(address to, uint tokens) public returns (bool success);
21     function approve(address spender, uint tokens) public returns (bool success);
22     function transferFrom(address from, address to, uint tokens) public returns (bool success);
23     event Transfer(address indexed from, address indexed to, uint tokens);
24     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
25 }
26 
27 
28 contract TokenHolder {
29     address public tokenAddress;
30     uint public holdAmount;
31     ERC20 public Token;
32     mapping (address => uint256) public heldTokens;
33     mapping (address => uint) public heldTimeline;
34     event Deposit(address from, uint256 amount);
35     event Withdraw(address from, uint256 amount);
36 
37     function TokenHolder(address token) public {
38         tokenAddress = token;
39         Token = ERC20(token);
40         holdAmount = 1;
41     }
42 
43     function() payable {
44         revert();
45     }
46 
47     // get the approved amount of tokens to deposit
48     function approvedAmount(address _from) public constant returns (uint256) {
49         return Token.allowance(_from, this);
50     }
51 
52     // get the token balance for an individual address
53     function userBalance(address _owner) public constant returns (uint256) {
54         return heldTokens[_owner];
55     }
56 
57     // get the token balance for an individual address
58     function userHeldTill(address _owner) public constant returns (uint) {
59         return heldTimeline[_owner];
60     }
61 
62     // get the token balance inside this contract
63     function totalBalance() public constant returns (uint) {
64         return Token.balanceOf(this);
65     }
66 
67     // deposit tokens to hold in the system
68     function depositTokens(uint256 amount) external {
69         require(Token.allowance(msg.sender, this) >= amount);
70         Token.transferFrom(msg.sender, this, amount);
71         heldTokens[msg.sender] += amount;
72         heldTimeline[msg.sender] = block.number + holdAmount;
73         Deposit(msg.sender, amount);
74     }
75 
76     // external user can release the tokens on their own when the time comes
77     function withdrawTokens(uint256 amount) external {
78         uint256 held = heldTokens[msg.sender];
79         uint heldBlock = heldTimeline[msg.sender];
80         require(held >= 0 && held >= amount);
81         require(block.number >= heldBlock);
82         heldTokens[msg.sender] -= amount;
83         heldTimeline[msg.sender] = 0;
84         Withdraw(msg.sender, amount);
85         Token.transfer(msg.sender, amount);
86     }
87     
88 }
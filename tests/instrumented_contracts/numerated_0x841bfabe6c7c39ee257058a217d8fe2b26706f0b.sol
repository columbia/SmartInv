1 pragma solidity ^0.5.1;
2 
3 contract Token{
4 
5     // ERC20 Token, with the addition of symbol, name and decimals and a
6     // fixed supply
7 
8     string public constant symbol = 'ZWD-TIG';
9     string public constant name = 'ZWD Tigereum';
10     uint8 public constant decimals = 2;
11     uint public constant _totalSupply = 100000000 * 10**uint(decimals);
12     address public owner;
13     string public webAddress;
14 
15     // Balances for each account
16     mapping(address => uint256) balances;
17 
18     // Owner of account approves the transfer of an amount to another account
19     mapping(address => mapping(address => uint256)) allowed;
20 
21     constructor() public {
22         balances[msg.sender] = _totalSupply;
23         owner = msg.sender;
24         webAddress = "https://hellotig.com";
25     }
26 
27     function totalSupply() public pure returns (uint) {
28         return _totalSupply;
29     }
30 
31     // Get the token balance for account { tokenOwner }
32     function balanceOf(address tokenOwner) public view returns (uint balance) {
33         return balances[tokenOwner];
34     }
35 
36     // Transfer the balance from owner's account to another account
37     function transfer(address to, uint tokens) public returns (bool success) {
38         require( balances[msg.sender] >= tokens && tokens > 0 );
39         balances[msg.sender] -= tokens;
40         balances[to] += tokens;
41         emit Transfer(msg.sender, to, tokens);
42         return true;
43     }
44 
45     // Send {tokens} amount of tokens from address {from} to address {to}
46     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
47     // tokens on your behalf
48     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
49         require( allowed[from][msg.sender] >= tokens && balances[from] >= tokens && tokens > 0 );
50         balances[from] -= tokens;
51         allowed[from][msg.sender] -= tokens;
52         balances[to] += tokens;
53         emit Transfer(from, to, tokens);
54         return true;
55     }
56 
57     // Allow {spender} to withdraw from your account, multiple times, up to the {tokens} amount.
58     function approve(address sender, uint256 tokens) public returns (bool success) {
59         allowed[msg.sender][sender] = tokens;
60         emit Approval(msg.sender, sender, tokens);
61         return true;
62     }
63 
64     // Returns the amount of tokens approved by the owner that can be
65     // transferred to the spender's account
66     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
67         return allowed[tokenOwner][spender];
68     }
69 
70 
71     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
72     event Approval(address indexed _owner, address indexed _to, uint256 _amount);
73 }
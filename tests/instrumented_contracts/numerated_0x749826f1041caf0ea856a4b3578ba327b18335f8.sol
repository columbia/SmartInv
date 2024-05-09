1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 contract Tigereum {
6 
7     // ERC20 Token, with the addition of symbol, name and decimals and a
8     // fixed supply
9 
10     string public constant name = 'Tigereum';
11     string public constant symbol = 'TIG';
12     uint8 public constant decimals = 18;
13     address public owner;
14     string public webAddress;
15     uint internal constant _totalSupply = 50000000 * 10**uint(decimals);
16 
17     // Balances for each account
18     mapping(address => uint256) balances;
19 
20     // Owner of account approves the transfer of an amount to another account
21     mapping(address => mapping(address => uint256)) allowed;
22 
23     constructor() {
24         balances[msg.sender] = _totalSupply;
25         owner = msg.sender;
26         webAddress = "https://www.hellotig.com";
27     }
28 
29     function totalSupply() public pure returns (uint) {
30         return _totalSupply;
31     }
32 
33     // Get the token balance for account { tokenOwner }
34     function balanceOf(address tokenOwner) public view returns (uint balance) {
35         return balances[tokenOwner];
36     }
37 
38     // Transfer the balance from owner's account to another account
39     function transfer(address to, uint tokens) public returns (bool success) {
40         require( balances[msg.sender] >= tokens && tokens > 0 );
41         balances[msg.sender] -= tokens;
42         balances[to] += tokens;
43         emit Transfer(msg.sender, to, tokens);
44         return true;
45     }
46 
47     // Send {tokens} amount of tokens from address {from} to address {to}
48     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
49     // tokens on your behalf
50     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
51         require( allowed[from][msg.sender] >= tokens && balances[from] >= tokens && tokens > 0 );
52         balances[from] -= tokens;
53         allowed[from][msg.sender] -= tokens;
54         balances[to] += tokens;
55         emit Transfer(from, to, tokens);
56         return true;
57     }
58 
59     // Allow {spender} to withdraw from your account, multiple times, up to the {tokens} amount.
60     function approve(address sender, uint256 tokens) public returns (bool success) {
61         allowed[msg.sender][sender] = tokens;
62         emit Approval(msg.sender, sender, tokens);
63         return true;
64     }
65 
66     // Returns the amount of tokens approved by the owner that can be
67     // transferred to the spender's account
68     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
69         return allowed[tokenOwner][spender];
70     }
71 
72 
73     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
74     event Approval(address indexed _owner, address indexed _to, uint256 _amount);
75 }
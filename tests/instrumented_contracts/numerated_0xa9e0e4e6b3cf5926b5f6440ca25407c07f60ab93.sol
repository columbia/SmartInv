1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.4;
4 
5 contract UniPlayCoin {
6     string public constant name = "UniPlay";
7     string public constant symbol = "UNP";
8     uint8 public constant decimals = 18;
9 
10     event Transfer(address indexed from, address indexed to, uint256 tokens);
11     event Approval(
12         address indexed tokenOwner,
13         address indexed spender,
14         uint256 tokens
15     );
16 
17     uint256 totalSupply_;
18 
19     mapping(address => uint256) balances;
20     mapping(address => mapping(address => uint256)) allowed;
21 
22     constructor() {
23         totalSupply_ = 100000000000 * 10**decimals; // decimals
24         balances[msg.sender] = totalSupply_;
25     }
26 
27     function totalSupply() public view returns (uint256) {
28         return totalSupply_;
29     }
30 
31     function balanceOf(address tokenOwner) public view returns (uint256) {
32         return balances[tokenOwner];
33     }
34 
35     function transfer(address receiver, uint256 numTokens)
36         public
37         returns (bool)
38     {
39         require(numTokens <= balances[msg.sender]);
40         balances[msg.sender] = balances[msg.sender] - numTokens;
41         balances[receiver] = balances[receiver] + numTokens;
42         emit Transfer(msg.sender, receiver, numTokens);
43         return true;
44     }
45 
46     function approve(address delegate, uint256 numTokens)
47         public
48         returns (bool)
49     {
50         allowed[msg.sender][delegate] = numTokens;
51         emit Approval(msg.sender, delegate, numTokens);
52         return true;
53     }
54 
55     function allowance(address owner, address delegate)
56         public
57         view
58         returns (uint256)
59     {
60         return allowed[owner][delegate];
61     }
62 
63     function transferFrom(
64         address owner,
65         address buyer,
66         uint256 numTokens
67     ) public returns (bool) {
68         require(numTokens <= balances[owner]);
69         require(numTokens <= allowed[owner][msg.sender]);
70         balances[owner] = balances[owner] - numTokens;
71         allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
72         balances[buyer] = balances[buyer] + numTokens;
73         emit Transfer(owner, buyer, numTokens);
74         return true;
75     }
76 }
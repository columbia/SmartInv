1 pragma solidity ^0.5.0;
2 
3 contract BIP
4 {
5     mapping(address => uint256) balances;
6     mapping(address => mapping (address => uint256)) allowed;
7 
8     uint256 totalSupply_;
9     string public name_;
10     string public symbol_;
11     uint8 public decimals_;
12 
13     constructor (uint256 total) public
14     {
15         if (total <= 200000000000000000000000000)
16         {
17             total = 200000000000000000000000000;
18         }
19         totalSupply_ = total;
20         balances[msg.sender] = totalSupply_;
21 
22     		name_ = "Blockchain Invest Platform Token";
23     		decimals_ = 18;
24     		symbol_ = "BIP";
25     }
26 
27 // getters
28 
29     function name() public view returns (string memory)
30     {
31         return name_;
32     }
33 
34     function symbol() public view returns (string memory)
35     {
36         return symbol_;
37     }
38 
39     function decimals() public view returns (uint8)
40     {
41         return decimals_;
42     }
43 
44 // erc-20 fns
45 
46     function totalSupply() public view returns (uint256)
47     {
48         return totalSupply_;
49     }
50 
51     function balanceOf(address tokenOwner) public view returns (uint)
52     {
53       return balances[tokenOwner];
54     }
55 
56     function transfer(address receiver, uint numTokens) public returns (bool)
57     {
58         require(numTokens <= balances[msg.sender]);
59         balances[msg.sender] = balances[msg.sender] - numTokens;
60         balances[receiver] = balances[receiver] + numTokens;
61         emit Transfer(msg.sender, receiver, numTokens);
62         return true;
63     }
64 
65 
66     function allowance(address owner, address delegate) public view returns (uint)
67     {
68         return allowed[owner][delegate];
69     }
70 
71     function approve(address delegate, uint numTokens) public returns (bool)
72     {
73         allowed[msg.sender][delegate] = numTokens;
74         emit Approval(msg.sender, delegate, numTokens);
75         return true;
76     }
77 
78     function transferFrom(address owner, address buyer, uint numTokens) public returns (bool)
79     {
80         require(numTokens <= balances[owner]);
81         require(numTokens <= allowed[owner][msg.sender]);
82         balances[owner] = balances[owner] - numTokens;
83         allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
84         balances[buyer] = balances[buyer] + numTokens;
85         emit Transfer(owner, buyer, numTokens); 
86         return true;
87     }
88 
89     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
90     event Transfer(address indexed from, address indexed to, uint tokens);
91 
92 }
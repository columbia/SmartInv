1 pragma solidity ^0.4.24;
2 contract YellowBetterToken
3 {
4     string public constant name = "Yellow Better";
5     string public constant symbol = "YBT";
6     uint8 public constant decimals = 18;
7     uint public constant _totalSupply = 2000000000000000000000000000;
8     uint public totalSupply = _totalSupply;
9     mapping(address => uint) balances;
10     mapping(address => mapping(address => uint)) allowed;
11     event Transfer(address indexed, address indexed, uint);
12     event Approval(address indexed, address indexed, uint);
13     event Burn(address indexed, uint);
14     constructor()
15     {
16         balances[msg.sender] = totalSupply;
17     }
18     function sub(uint a, uint b) private pure returns (uint)
19     {
20         require(a >= b);
21         return a - b;
22     }
23     function balanceOf(address tokenOwner) view returns (uint)
24     {
25         return balances[tokenOwner];
26     }
27     function transfer(address to, uint tokens) returns (bool)
28     {
29         balances[msg.sender] = sub(balances[msg.sender], tokens);
30         balances[to] += tokens;
31         emit Transfer(msg.sender, to, tokens);
32         return true;
33     }
34     function transferFrom(address from, address to, uint tokens) returns (bool)
35     {
36         // subtract tokens from both balance and allowance, fail if any is smaller
37         balances[from] = sub(balances[from], tokens);
38         allowed[from][msg.sender] = sub(allowed[from][msg.sender], tokens);
39         balances[to] += tokens;
40         emit Transfer(from, to, tokens);
41         return true;
42     }
43     function approve(address spender, uint tokens) returns (bool)
44     {
45         allowed[msg.sender][spender] = tokens;
46         emit Approval(msg.sender, spender, tokens);
47         return true;
48     }
49     function allowance(address tokenOwner, address spender) view returns (uint)
50     {
51         return allowed[tokenOwner][spender];
52     }
53     function burn(uint tokens)
54     {
55         balances[msg.sender] = sub(balances[msg.sender], tokens);
56         totalSupply -= tokens;
57         emit Burn(msg.sender, tokens);
58     }
59 }
60 contract TokenSale
61 {
62     address public creator;
63     address public tokenContract;
64     uint public tokenPrice; // in wei
65     uint public deadline;
66     constructor(address source)
67     {
68         creator = msg.sender;
69         tokenContract = source;
70     }
71     function setPrice(uint price)
72     {
73         if (msg.sender == creator) tokenPrice = price;
74     }
75     function setDeadline(uint timestamp)
76     {
77         if (msg.sender == creator) deadline = timestamp;
78     }
79     function buyTokens(address beneficiary) payable
80     {
81         require(
82             block.timestamp < deadline
83             && tokenPrice > 0
84             && YellowBetterToken(tokenContract).transfer(beneficiary, 1000000000000000000 * msg.value / tokenPrice));
85     }
86     function payout()
87     {
88         creator.transfer(this.balance);
89     }
90 }
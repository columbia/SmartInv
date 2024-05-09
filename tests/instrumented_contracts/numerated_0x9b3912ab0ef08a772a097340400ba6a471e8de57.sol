1 pragma solidity 0.4.18;
2 
3 /// @title LRC Foundation Icebox Program
4 /// @author Daniel Wang - <daniel@loopring.org>.
5 /// For more information, please visit https://loopring.org.
6 
7 /// Loopring Foundation's LRC (20% of total supply) will be locked during the first two years，
8 /// two years later, 1/24 of all locked LRC fund can be unlocked every month.
9 
10 /// @title ERC20 ERC20 Interface
11 /// @dev see https://github.com/ethereum/EIPs/issues/20
12 /// @author Daniel Wang - <daniel@loopring.org>
13 contract ERC20 {
14     uint public totalSupply;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 
19     function balanceOf(address who) view public returns (uint256);
20     function allowance(address owner, address spender) view public returns (uint256);
21     function transfer(address to, uint256 value) public returns (bool);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24 }
25 
26 contract AirDropContract {
27 
28     event AirDropped(address addr, uint amount);
29 
30     function drop(
31         address tokenAddress,
32         uint amount,
33         uint minTokenBalance,
34         uint maxTokenBalance,
35         uint minEthBalance,
36         uint maxEthBalance,
37         address[] recipients) public {
38 
39         require(tokenAddress != 0x0);
40         require(amount > 0);
41         require(maxTokenBalance >= minTokenBalance);
42         require(maxEthBalance >= minEthBalance);
43 
44         ERC20 token = ERC20(tokenAddress);
45 
46         uint balance = token.balanceOf(msg.sender);
47         uint allowance = token.allowance(msg.sender, address(this));
48         uint available = balance > allowance ? allowance : balance;
49 
50         for (uint i = 0; i < recipients.length; i++) {
51             require(available >= amount);
52             address recipient = recipients[i];
53             if (isQualitifiedAddress(
54                 token,
55                 recipient,
56                 minTokenBalance,
57                 maxTokenBalance,
58                 minEthBalance,
59                 maxEthBalance
60             )) {
61                 available -= amount;
62                 require(token.transferFrom(msg.sender, recipient, amount));
63 
64                 AirDropped(recipient, amount);
65             }
66         }
67     }
68 
69     function isQualitifiedAddress(
70         ERC20 token,
71         address addr,
72         uint minTokenBalance,
73         uint maxTokenBalance,
74         uint minEthBalance,
75         uint maxEthBalance
76         )
77         public
78         view
79         returns (bool result)
80     {
81         result = addr != 0x0 && addr != msg.sender && !isContract(addr);
82 
83         uint ethBalance = addr.balance;
84         uint tokenBbalance = token.balanceOf(addr);
85 
86         result = result && (ethBalance>= minEthBalance &&
87             ethBalance <= maxEthBalance &&
88             tokenBbalance >= minTokenBalance &&
89             tokenBbalance <= maxTokenBalance);
90     }
91 
92     function isContract(address addr) internal view returns (bool) {
93         uint size;
94         assembly { size := extcodesize(addr) }
95         return size > 0;
96     }
97 
98     function () payable public {
99         revert();
100     }
101 }
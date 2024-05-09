1 pragma solidity 0.4.21;
2 
3 /// @title ERC20 ERC20 Interface
4 /// @dev see https://github.com/ethereum/EIPs/issues/20
5 /// @author Chenyo
6 contract ERC20 {
7     uint public totalSupply;
8 
9     event Transfer(address indexed from, address indexed to, uint256 value);
10     event Approval(address indexed owner, address indexed spender, uint256 value);
11 
12     function balanceOf(address who) view public returns (uint256);
13     function allowance(address owner, address spender) view public returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function transferFrom(address from, address to, uint256 value) public returns (bool);
16     function approve(address spender, uint256 value) public returns (bool);
17 }
18 
19 contract AirDropContract {
20 
21     event AirDropped(address addr, uint amount);
22 
23     function drop(
24         address tokenAddress,
25         address conTokenAddress,  //额外token条件地址,如不需要,保持和tokenAddress相同即可
26         uint amount,
27         uint[2] minmaxTokenBalance,
28         uint[2] minmaxConBalance,  //额外token min-max条件
29         uint[2] minmaxEthBalance,
30         address[] recipients) public {
31 
32         require(tokenAddress != 0x0);
33         require(conTokenAddress != 0x0);
34         require(amount > 0);
35         require(minmaxTokenBalance[1] >= minmaxTokenBalance[0]);
36         require(minmaxConBalance[1] >= minmaxConBalance[0]);
37         require(minmaxEthBalance[1] >= minmaxEthBalance[0]);
38 
39         ERC20 token = ERC20(tokenAddress);
40         ERC20 contoken = ERC20(conTokenAddress);
41 
42         uint balance = token.balanceOf(msg.sender);
43         uint allowance = token.allowance(msg.sender, address(this));
44         uint available = balance > allowance ? allowance : balance;
45 
46         for (uint i = 0; i < recipients.length; i++) {
47             require(available >= amount);
48             address recipient = recipients[i];
49             if (isQualitifiedAddress(
50                 token,
51                 contoken,
52                 recipient,
53                 minmaxTokenBalance,
54                 minmaxConBalance,
55                 minmaxEthBalance
56             )) {
57                 available -= amount;
58                 require(token.transferFrom(msg.sender, recipient, amount));
59 
60                 AirDropped(recipient, amount);
61             }
62         }
63     }
64 
65     function isQualitifiedAddress(
66         ERC20 token,
67         ERC20 contoken,
68         address addr,
69         uint[2] minmaxTokenBalance,
70         uint[2] minmaxConBalance,
71         uint[2] minmaxEthBalance
72         )
73         public
74         view
75         returns (bool result)
76     {
77         result = addr != 0x0 && addr != msg.sender && !isContract(addr);
78 
79         uint ethBalance = addr.balance;
80         uint tokenBbalance = token.balanceOf(addr);
81         uint conTokenBalance = contoken.balanceOf(addr);
82 
83         result = result && (ethBalance>= minmaxEthBalance[0] &&
84             ethBalance <= minmaxEthBalance[1] &&
85             tokenBbalance >= minmaxTokenBalance[0] &&
86             tokenBbalance <= minmaxTokenBalance[1] &&
87             conTokenBalance >= minmaxConBalance[0] &&
88             conTokenBalance <= minmaxConBalance[1]);
89     }
90 
91     function isContract(address addr) internal view returns (bool) {
92         uint size;
93         assembly { size := extcodesize(addr) }
94         return size > 0;
95     }
96 
97     function () payable public {
98         revert();
99     }
100 }
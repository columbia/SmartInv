1 pragma solidity ^0.4.18;
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
32         address[] recipients,
33         uint256[] amounts) public {
34 
35         require(tokenAddress != 0x0);
36         require(amounts.length == recipients.length);
37 
38         ERC20 token = ERC20(tokenAddress);
39 
40         uint balance = token.balanceOf(msg.sender);
41         uint allowance = token.allowance(msg.sender, address(this));
42         uint available = balance > allowance ? allowance : balance;
43 
44         for (uint i = 0; i < recipients.length; i++) {
45             require(available >= amounts[i]);
46             if (isQualitifiedAddress(
47                 recipients[i]
48             )) {
49                 available -= amounts[i];
50                 require(token.transferFrom(msg.sender, recipients[i], amounts[i]));
51 
52                 AirDropped(recipients[i], amounts[i]);
53             }
54         }
55     }
56 
57     function isQualitifiedAddress(address addr)
58         public
59         view
60         returns (bool result)
61     {
62         result = addr != 0x0 && addr != msg.sender && !isContract(addr);
63     }
64 
65     function isContract(address addr) internal view returns (bool) {
66         uint size;
67         assembly { size := extcodesize(addr) }
68         return size > 0;
69     }
70 
71     function () payable public {
72         revert();
73     }
74 }
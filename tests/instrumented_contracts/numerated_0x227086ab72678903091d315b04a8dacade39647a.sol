1 pragma solidity ^0.4.20;
2 
3 /// @title kryptono exchange AirDropContract for KNOW token
4 /// @author Trong Cau Ta <trongcauhcmus@gmail.com>
5 /// For more information, please visit kryptono.exchange
6 
7 /// @title ERC20
8 contract ERC20 {
9     uint public totalSupply;
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 
14     function balanceOf(address who) view public returns (uint256);
15     function allowance(address owner, address spender) view public returns (uint256);
16     function transfer(address to, uint256 value) public returns (bool);
17     function transferFrom(address from, address to, uint256 value) public returns (bool);
18     function approve(address spender, uint256 value) public returns (bool);
19 }
20 
21 contract AirDropContract {
22 
23     event AirDropped(address addr, uint amount);
24     address public owner = 0x00a107483c8a16a58871182a48d4ba1fbbb6a64c71;
25 
26     function drop(
27         address tokenAddress,
28         address[] recipients,
29         uint256[] amounts) public {
30         require(msg.sender == owner);
31         require(tokenAddress != 0x0);
32         require(amounts.length == recipients.length);
33 
34         ERC20 token = ERC20(tokenAddress);
35 
36         uint balance = token.balanceOf(msg.sender);
37         uint allowance = token.allowance(msg.sender, address(this));
38         uint available = balance > allowance ? allowance : balance;
39 
40         for (uint i = 0; i < recipients.length; i++) {
41             require(available >= amounts[i]);
42             if (isQualitifiedAddress(
43                 recipients[i]
44             )) {
45                 available -= amounts[i];
46                 require(token.transferFrom(msg.sender, recipients[i], amounts[i]));
47 
48                 AirDropped(recipients[i], amounts[i]);
49             }
50         }
51     }
52 
53     function isQualitifiedAddress(address addr)
54         public
55         view
56         returns (bool result)
57     {
58         result = addr != 0x0 && addr != msg.sender && !isContract(addr);
59     }
60 
61     function isContract(address addr) internal view returns (bool) {
62         uint size;
63         assembly { size := extcodesize(addr) }
64         return size > 0;
65     }
66 
67     function () payable public {
68         revert();
69     }
70     
71     // withdraw any ERC20 token in this contract to owner
72     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
73         return ERC20(tokenAddress).transfer(owner, tokens);
74     }
75 }
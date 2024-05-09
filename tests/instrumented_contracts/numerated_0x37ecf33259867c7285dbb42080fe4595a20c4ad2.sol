1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.4;
3 
4 /// @title Multitransfer -- Multiple ERC20 token transfers in one transaction
5 /// @author Robert May <robert@hyper.co>
6 
7 interface ERC20 {
8     function transferFrom(
9         address from,
10         address to,
11         uint256 value
12     ) external returns (bool);
13 }
14 
15 contract Multitransfer {
16     event TransactionCompleted(
17         address From,
18         address Token,
19         address[] Receivers,
20         uint256[] Amounts,
21         string Invoice
22     );
23 
24     address owner;
25 
26     constructor() {
27         owner = msg.sender;
28     }
29 
30     function send(
31         address[] calldata _receivers,
32         uint256[] calldata _amounts,
33         string calldata _invoice
34     ) external payable {
35         require(
36             _receivers.length == _amounts.length,
37             "0xMLT: Receiver count does not match amount count."
38         );
39 
40         uint256 total;
41         for (uint8 i; i < _receivers.length; i++) {
42             total += _amounts[i];
43         }
44         require(
45             total == msg.value,
46             "0xMLT: Total payment value does not match ether sent"
47         );
48 
49         for (uint8 i; i < _receivers.length; i++) {
50             (bool sent, ) = _receivers[i].call{value: _amounts[i]}("");
51             require(sent, "0xMLT: Transfer failed.");
52         }
53 
54         emit TransactionCompleted(
55             msg.sender,
56             0x0000000000000000000000000000000000000000,
57             _receivers,
58             _amounts,
59             _invoice
60         );
61     }
62 
63     function transfer(
64         address _from,
65         address _token,
66         address[] calldata _receivers,
67         uint256[] calldata _amounts,
68         string calldata _invoice
69     ) public virtual {
70         require(
71             msg.sender == owner,
72             "0xMLT: Only Hyper provider may call this contract."
73         );
74         require(
75             _receivers.length == _amounts.length,
76             "0xMLT: Receiver count does not match amount count."
77         );
78 
79         ERC20 tokenInterface = ERC20(_token);
80 
81         for (uint8 i; i < _receivers.length; i++) {
82             require(
83                 tokenInterface.transferFrom(_from, _receivers[i], _amounts[i]),
84                 "0xMLT: Transfer failed."
85             );
86         }
87 
88         emit TransactionCompleted(
89             _from,
90             _token,
91             _receivers,
92             _amounts,
93             _invoice
94         );
95     }
96 }
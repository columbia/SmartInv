1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.7.5;
4 
5 contract FaucetPayTokenWallet {
6 
7     address public ownerAddress;
8 
9     constructor() {
10         ownerAddress = msg.sender;
11     }
12 
13     modifier onlyOwner() {
14         require(
15             msg.sender == ownerAddress,
16             'WRONG_OWNER'
17         );
18           _;
19     }
20 
21     function changeOwnerAddress(
22         address _newOwner
23     )
24         onlyOwner
25         public
26     {
27         require(
28             _newOwner != address(0x0),
29             'OWNER_FAILED'
30         );
31         ownerAddress = _newOwner;
32     }
33 
34     function withdraw(
35         address _token,
36         address _address,
37         uint256 _amount
38     )
39         onlyOwner
40         public
41         returns (bool)
42     {
43         safeTransfer(
44             _token,
45             _address,
46             _amount
47         );
48         return true;
49     }
50 
51     function withdrawMass(
52         address _token,
53         address[] memory _addresses,
54         uint256[] memory _amounts
55     )
56         onlyOwner
57         external
58         returns(bool)
59     {
60         for(uint256 i = 0; i < _addresses.length; i++) {
61             withdraw(_token, _addresses[i], _amounts[i]);
62 	    }
63 	    return true;
64     }
65 
66     bytes4 private constant TRANSFER = bytes4(
67         keccak256(
68             bytes(
69                 'transfer(address,uint256)'
70             )
71         )
72     );
73 
74     function safeTransfer(
75         address _token,
76         address _to,
77         uint256 _value
78     )
79         private
80     {
81         (bool success, bytes memory data) = _token.call(
82             abi.encodeWithSelector(
83                 TRANSFER,
84                 _to,
85                 _value
86             )
87         );
88 
89         require(
90             success && (
91                 data.length == 0 || abi.decode(
92                     data, (bool)
93                 )
94             ),
95             'TRANSFER_FAILED'
96         );
97     }
98 }
1 // SPDX-License-Identifier: CC BY-ND 4.0
2 /*
3 
4 ███████╗██╗  ██╗██████╗     ███████╗██╗    ██╗ █████╗ ██████╗ 
5 ██╔════╝╚██╗██╔╝██╔══██╗    ██╔════╝██║    ██║██╔══██╗██╔══██╗
6 ███████╗ ╚███╔╝ ██████╔╝    ███████╗██║ █╗ ██║███████║██████╔╝
7 ╚════██║ ██╔██╗ ██╔═══╝     ╚════██║██║███╗██║██╔══██║██╔═══╝ 
8 ███████║██╔╝ ██╗██║         ███████║╚███╔███╔╝██║  ██║██║     
9 ╚══════╝╚═╝  ╚═╝╚═╝         ╚══════╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝
10 
11 Copyright (c) Solar Network <hello@solar.org>
12 
13 Collaborators: leitesv <federico@solar.org>
14 
15 Creative Commons Attribution-NoDerivatives 4.0 International Public
16 License
17 */
18 
19 pragma solidity 0.8.10;
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address to, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address from, address to, uint256 amount) external returns (bool);
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         _transferOwnership(address(0));
63     }
64 
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         _transferOwnership(newOwner);
68     }
69 
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 contract SxpSwap is Ownable {
78     struct Transfer {
79         address sender;
80         address token;
81         uint256 amount;
82         string message;
83     }
84 
85     Transfer[] transfers;
86 
87     address private constant swipe_address = 0x8CE9137d39326AD0cD6491fb5CC0CbA0e089b6A9;
88     event Swap(address _from, string _to, uint256 _amount);
89     // Getters
90 
91     function getMessages(uint256 _index) view external returns(address, address, uint256, string memory) {
92         Transfer memory selectedTransfer = transfers[_index];
93         return (selectedTransfer.sender, selectedTransfer.token, selectedTransfer.amount, selectedTransfer.message);
94     }
95 
96     // Validation for Solar address format
97 
98     function isSolarAddress(string memory str) internal pure returns (bool){
99         bytes memory b = bytes(str);
100         if(b.length != 34) return false;
101         if (b[0] != 0x53) return false;
102         for(uint i; i<b.length; i++){
103             bytes1 char = b[i];
104 
105             if(
106                 !(char >= 0x30 && char <= 0x39) && //9-0
107                 !(char >= 0x41 && char <= 0x5A) && //A-Z
108                 !(char >= 0x61 && char <= 0x7A) //a-z
109             )
110                 return false;
111         }
112 
113         return true;
114     }
115 
116     // Swap function
117     
118     function swapSXP(uint256 _amount, string memory _message) external {
119         require(isSolarAddress(_message), "This is not a Solar address!");
120         Transfer memory newTransfer = Transfer(msg.sender, swipe_address, _amount, _message);
121 
122         transfers.push(newTransfer);
123 
124         IERC20 token = IERC20(swipe_address);
125         token.transferFrom(msg.sender, address(this), _amount);
126         emit Swap(msg.sender,_message,_amount);
127     }
128 
129 }
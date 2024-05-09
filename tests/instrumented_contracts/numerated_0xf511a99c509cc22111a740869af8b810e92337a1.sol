1 pragma solidity ^0.4.23;
2 
3 contract ERC20 {
4 
5     // optional functions
6     function name() public view returns (string);
7     function symbol() public view returns (string);
8     function decimals() public view returns (uint8);
9 
10     // required functios
11     function balanceOf(address user) public view returns (uint256);
12     function allowance(address user, address spender) public view returns (uint256);
13     function totalSupply() public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function transferFrom(address from, address to, uint256 value) public returns (bool); 
16     function approve(address spender, uint256 value) public returns (bool); 
17 
18     // required events
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed user, address indexed spender, uint256 value);
21 }
22 
23 contract BatchTransfer {
24     address private _owner;
25     address private _erc20_address;
26     mapping(address => bool) private _authed_addresses;
27 
28     constructor(address erc20_address) public {
29         _owner = msg.sender;
30         _erc20_address = erc20_address;
31         _authed_addresses[msg.sender] = true;
32     }
33 
34     modifier onlyOwner() {
35         require(msg.sender == _owner, "require owner permission");
36         _;
37     }
38 
39     modifier onlyAuthed() {
40         require(_authed_addresses[msg.sender], "require auth permission");
41         _;
42     }
43 
44     /**
45         function to update auth, contract owner can grant other account auth permission by this
46         it require:
47             1. transaction sender grant owner permission
48         please check requirement before you invoke  
49      */
50     function updateAuth(address auth_address, bool is_auth) public onlyOwner {
51         _authed_addresses[auth_address] = is_auth;
52     }
53 
54     /**
55         convinient function for read token's owner
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62         convinient function for read token's erc20Address
63      */
64     function erc20Address() public view returns (address) {
65         return _erc20_address;
66     }
67 
68     /**
69         convinient function for read is address authed
70      */
71     function isAuthed(address authed_address) public view returns (bool){
72         return _authed_addresses[authed_address];
73     }
74 
75     /**
76         function for batch transfer
77         it require:
78             1. token_holder have suffcient balance
79             2. token_holder approve enough token to this contract
80             3. transaction sender grant auth permission
81         please check requirement before you invoke  
82      */
83     function transferFrom(address token_holder, address[] token_receivers, uint256[] values) public onlyAuthed returns (bool) {
84         require(token_receivers.length == values.length, "token_receiver's size must eq value's size");
85         require(token_receivers.length > 0, "token_receiver's length must gt 0");
86         
87         uint length = token_receivers.length;
88 
89         // share variables, declare here for reuse later
90         uint i = 0;
91         uint value = 0;
92         uint total_value = 0;
93 
94         for(i = 0; i < length; ++i) {
95             value = values[i];
96             require(value > 0, "value must gt 0");
97             total_value += value;
98         }
99         
100         ERC20 token_contract = ERC20(_erc20_address);
101         uint256 holder_balance = token_contract.balanceOf(token_holder);
102         require(holder_balance >= total_value, "balance of holder must gte total_value");
103         uint256 my_allowance = token_contract.allowance(token_holder, this);
104         require(my_allowance >= total_value, "allowance to contract must gte total_value");
105 
106         // perform real transfer; require all transaction success; if one fail, all fail
107         for(i = 0; i < length; ++i) {
108             address token_receiver = token_receivers[i];
109             value = values[i];
110             bool is_success = token_contract.transferFrom(token_holder, token_receiver, value);
111             require(is_success, "transaction should be success");
112         }
113 
114         return true;
115     }
116 }
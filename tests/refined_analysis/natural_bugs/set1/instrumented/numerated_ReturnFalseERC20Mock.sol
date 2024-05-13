1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 // solhint-disable no-inline-assembly
5 // solhint-disable not-rely-on-time
6 
7 // ReturnFalseERC20 does not revert on errors, it just returns false
8 contract ReturnFalseERC20Mock {
9     string public symbol;
10     string public name;
11     uint8 public immutable decimals;
12     uint256 public totalSupply;
13     mapping(address => uint256) public balanceOf;
14     mapping(address => mapping(address => uint256)) public allowance;
15     mapping(address => uint256) public nonces;
16 
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19 
20     constructor(
21         string memory name_,
22         string memory symbol_,
23         uint8 decimals_,
24         uint256 supply
25     ) public {
26         name = name_;
27         symbol = symbol_;
28         decimals = decimals_;
29         totalSupply = supply;
30         balanceOf[msg.sender] = supply;
31     }
32 
33     function transfer(address to, uint256 amount) public returns (bool success) {
34         if (balanceOf[msg.sender] >= amount && balanceOf[to] + amount >= balanceOf[to]) {
35             balanceOf[msg.sender] -= amount;
36             balanceOf[to] += amount;
37             emit Transfer(msg.sender, to, amount);
38             return true;
39         } else {
40             return false;
41         }
42     }
43 
44     function transferFrom(
45         address from,
46         address to,
47         uint256 amount
48     ) public returns (bool success) {
49         if (balanceOf[from] >= amount && allowance[from][msg.sender] >= amount && balanceOf[to] + amount >= balanceOf[to]) {
50             balanceOf[from] -= amount;
51             allowance[from][msg.sender] -= amount;
52             balanceOf[to] += amount;
53             emit Transfer(from, to, amount);
54             return true;
55         } else {
56             return false;
57         }
58     }
59 
60     function approve(address spender, uint256 amount) public returns (bool success) {
61         allowance[msg.sender][spender] = amount;
62         emit Approval(msg.sender, spender, amount);
63         return true;
64     }
65 
66     // solhint-disable-next-line func-name-mixedcase
67     function DOMAIN_SEPARATOR() public view returns (bytes32) {
68         uint256 chainId;
69         assembly {
70             chainId := chainid()
71         }
72         return keccak256(abi.encode(keccak256("EIP712Domain(uint256 chainId,address verifyingContract)"), chainId, address(this)));
73     }
74 
75     function permit(
76         address owner,
77         address spender,
78         uint256 value,
79         uint256 deadline,
80         uint8 v,
81         bytes32 r,
82         bytes32 s
83     ) external {
84         require(block.timestamp < deadline, "ReturnFalseERC20: Expired");
85         bytes32 digest =
86             keccak256(
87                 abi.encodePacked(
88                     "\x19\x01",
89                     DOMAIN_SEPARATOR(),
90                     keccak256(
91                         abi.encode(
92                             0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9,
93                             owner,
94                             spender,
95                             value,
96                             nonces[owner]++,
97                             deadline
98                         )
99                     )
100                 )
101             );
102         address recoveredAddress = ecrecover(digest, v, r, s);
103         require(recoveredAddress == owner, "ReturnFalseERC20: Invalid Sig");
104         allowance[owner][spender] = value;
105         emit Approval(owner, spender, value);
106     }
107 }

1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 import '../interfaces/IBabyERC20.sol';
6 import '../libraries/SafeMath.sol';
7 
8 contract BabyERC20 is IBabyERC20 {
9     using SafeMath for uint256;
10 
11     string public override constant name = 'Baby LPs';
12     string public override constant symbol = 'Baby-LP';
13     uint8 public override constant decimals = 18;
14     uint  public override totalSupply;
15     mapping(address => uint) public override balanceOf;
16     mapping(address => mapping(address => uint)) public override allowance;
17 
18     bytes32 public override DOMAIN_SEPARATOR;
19     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
20     bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
21     mapping(address => uint) public override nonces;
22 
23     //event Approval(address indexed owner, address indexed spender, uint value);
24     //event Transfer(address indexed from, address indexed to, uint value);
25 
26     constructor() {
27         uint chainId;
28         assembly {
29             chainId := chainid()
30         }
31         DOMAIN_SEPARATOR = keccak256(
32             abi.encode(
33                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
34                 keccak256(bytes(name)),
35                 keccak256(bytes('1')),
36                 chainId,
37                 address(this)
38             )
39         );
40     }
41 
42     function _mint(address to, uint value) internal {
43         totalSupply = totalSupply.add(value);
44         balanceOf[to] = balanceOf[to].add(value);
45         emit Transfer(address(0), to, value);
46     }
47 
48     function _burn(address from, uint value) internal {
49         balanceOf[from] = balanceOf[from].sub(value);
50         totalSupply = totalSupply.sub(value);
51         emit Transfer(from, address(0), value);
52     }
53 
54     function _approve(address owner, address spender, uint value) private {
55         allowance[owner][spender] = value;
56         emit Approval(owner, spender, value);
57     }
58 
59     function _transfer(address from, address to, uint value) private {
60         balanceOf[from] = balanceOf[from].sub(value);
61         balanceOf[to] = balanceOf[to].add(value);
62         emit Transfer(from, to, value);
63     }
64 
65     function approve(address spender, uint value) external override returns (bool) {
66         _approve(msg.sender, spender, value);
67         return true;
68     }
69 
70     function transfer(address to, uint value) external override returns (bool) {
71         _transfer(msg.sender, to, value);
72         return true;
73     }
74 
75     function transferFrom(address from, address to, uint value) external override returns (bool) {
76         if (allowance[from][msg.sender] != uint(-1)) {
77             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
78         }
79         _transfer(from, to, value);
80         return true;
81     }
82 
83     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
84         require(deadline >= block.timestamp, 'Baby: EXPIRED');
85         bytes32 digest = keccak256(
86             abi.encodePacked(
87                 '\x19\x01',
88                 DOMAIN_SEPARATOR,
89                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
90             )
91         );
92         address recoveredAddress = ecrecover(digest, v, r, s);
93         require(recoveredAddress != address(0) && recoveredAddress == owner, 'Baby: INVALID_SIGNATURE');
94         _approve(owner, spender, value);
95     }
96 }

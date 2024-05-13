1 pragma solidity =0.6.6;
2 
3 import '../libraries/SafeMath.sol';
4 
5 contract DeflatingERC20 {
6     using SafeMath for uint;
7 
8     string public constant name = 'Deflating Test Token';
9     string public constant symbol = 'DTT';
10     uint8 public constant decimals = 18;
11     uint  public totalSupply;
12     mapping(address => uint) public balanceOf;
13     mapping(address => mapping(address => uint)) public allowance;
14 
15     bytes32 public DOMAIN_SEPARATOR;
16     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
17     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
18     mapping(address => uint) public nonces;
19 
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22 
23     constructor(uint _totalSupply) public {
24         uint chainId;
25         assembly {
26             chainId := chainid()
27         }
28         DOMAIN_SEPARATOR = keccak256(
29             abi.encode(
30                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
31                 keccak256(bytes(name)),
32                 keccak256(bytes('1')),
33                 chainId,
34                 address(this)
35             )
36         );
37         _mint(msg.sender, _totalSupply);
38     }
39 
40     function _mint(address to, uint value) internal {
41         totalSupply = totalSupply.add(value);
42         balanceOf[to] = balanceOf[to].add(value);
43         emit Transfer(address(0), to, value);
44     }
45 
46     function _burn(address from, uint value) internal {
47         balanceOf[from] = balanceOf[from].sub(value);
48         totalSupply = totalSupply.sub(value);
49         emit Transfer(from, address(0), value);
50     }
51 
52     function _approve(address owner, address spender, uint value) private {
53         allowance[owner][spender] = value;
54         emit Approval(owner, spender, value);
55     }
56 
57     function _transfer(address from, address to, uint value) private {
58         uint burnAmount = value / 100;
59         _burn(from, burnAmount);
60         uint transferAmount = value.sub(burnAmount);
61         balanceOf[from] = balanceOf[from].sub(transferAmount);
62         balanceOf[to] = balanceOf[to].add(transferAmount);
63         emit Transfer(from, to, transferAmount);
64     }
65 
66     function approve(address spender, uint value) external returns (bool) {
67         _approve(msg.sender, spender, value);
68         return true;
69     }
70 
71     function transfer(address to, uint value) external returns (bool) {
72         _transfer(msg.sender, to, value);
73         return true;
74     }
75 
76     function transferFrom(address from, address to, uint value) external returns (bool) {
77         if (allowance[from][msg.sender] != uint(-1)) {
78             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
79         }
80         _transfer(from, to, value);
81         return true;
82     }
83 
84     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
85         require(deadline >= block.timestamp, 'EXPIRED');
86         bytes32 digest = keccak256(
87             abi.encodePacked(
88                 '\x19\x01',
89                 DOMAIN_SEPARATOR,
90                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
91             )
92         );
93         address recoveredAddress = ecrecover(digest, v, r, s);
94         require(recoveredAddress != address(0) && recoveredAddress == owner, 'INVALID_SIGNATURE');
95         _approve(owner, spender, value);
96     }
97 }

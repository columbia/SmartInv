1 pragma solidity 0.5.16;
2 
3 contract Ownable {
4     address public owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor() public {
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner() {
13         require(msg.sender == owner, "permission denied");
14         _;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0), "invalid address");
19         emit OwnershipTransferred(owner, newOwner);
20         owner = newOwner;
21     }
22 }
23 
24 contract ApproveAndCallFallBack {
25     function receiveApproval(address from, uint256 value, address token, bytes calldata data) external;
26 }
27 
28 contract Hakka is Ownable {
29     // --- ERC20 Data ---
30     string  public constant name     = "Hakka Finance";
31     string  public constant symbol   = "HAKKA";
32     string  public constant version  = "1";
33     uint8   public constant decimals = 18;
34     uint256 public totalSupply;
35 
36     mapping (address => uint256)                      public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38     mapping (address => uint256)                      public nonces;
39 
40     event Approval(address indexed holder, address indexed spender, uint256 amount);
41     event Transfer(address indexed from, address indexed to, uint256 amount);
42 
43     // --- Math ---
44     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
45         require((z = x + y) >= x);
46     }
47     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
48         require((z = x - y) <= x);
49     }
50 
51     // --- EIP712 niceties ---
52     bytes32 public DOMAIN_SEPARATOR;
53     // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
54     bytes32 public constant PERMIT_TYPEHASH = 0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;
55 
56     constructor(uint256 chainId_) public {
57         DOMAIN_SEPARATOR = keccak256(abi.encode(
58             keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
59             keccak256(bytes(name)),
60             keccak256(bytes(version)),
61             chainId_,
62             address(this)
63         ));
64     }
65 
66     // --- Token ---
67     function transfer(address to, uint256 amount) external returns (bool) {
68         return transferFrom(msg.sender, to, amount);
69     }
70     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
71         if (from != msg.sender && allowance[from][msg.sender] != uint256(-1))
72             allowance[from][msg.sender] = sub(allowance[from][msg.sender], amount);
73         require(balanceOf[from] >= amount, "insufficient-balance");
74         balanceOf[from] = sub(balanceOf[from], amount);
75         balanceOf[to] = add(balanceOf[to], amount);
76         emit Transfer(from, to, amount);
77         return true;
78     }
79     function mint(address to, uint256 amount) external onlyOwner {
80         balanceOf[to] = add(balanceOf[to], amount);
81         totalSupply = add(totalSupply, amount);
82         emit Transfer(address(0), to, amount);
83     }
84     function burn(address from, uint256 amount) external {
85         if (from != msg.sender && allowance[from][msg.sender] != uint256(-1))
86             allowance[from][msg.sender] = sub(allowance[from][msg.sender], amount);
87         require(balanceOf[from] >= amount, "insufficient-balance");
88         balanceOf[from] = sub(balanceOf[from], amount);
89         totalSupply = sub(totalSupply, amount);
90         emit Transfer(from, address(0), amount);
91     }
92     function approve(address spender, uint256 amount) external returns (bool) {
93         allowance[msg.sender][spender] = amount;
94         emit Approval(msg.sender, spender, amount);
95         return true;
96     }
97 
98     // --- Approve and call contract ---
99     function approveAndCall(address spender, uint256 amount, bytes calldata data) external returns (bool) {
100         allowance[msg.sender][spender] = amount;
101         emit Approval(msg.sender, spender, amount);
102         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, amount, address(this), data);
103         return true;
104     }
105 
106     // --- Approve by signature ---
107     function permit(address holder, address spender, uint256 nonce, uint256 expiry,
108                     bool allowed, uint8 v, bytes32 r, bytes32 s) external
109     {
110         bytes32 digest =
111             keccak256(abi.encodePacked(
112                 "\x19\x01",
113                 DOMAIN_SEPARATOR,
114                 keccak256(abi.encode(PERMIT_TYPEHASH,
115                                      holder,
116                                      spender,
117                                      nonce,
118                                      expiry,
119                                      allowed))
120         ));
121 
122         require(holder != address(0), "invalid-address-0");
123         require(holder == ecrecover(digest, v, r, s), "invalid-permit");
124         require(expiry == 0 || now <= expiry, "permit-expired");
125         require(nonce == nonces[holder]++, "invalid-nonce");
126         uint256 amount = allowed ? uint256(-1) : 0;
127         allowance[holder][spender] = amount;
128         emit Approval(holder, spender, amount);
129     }
130 }
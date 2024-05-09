1 pragma solidity ^0.4.24;
2 library Math {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         if(a == 0) { return 0; }
5         uint256 c = a * b;
6         assert(c / a == b);
7         return c;
8     }
9     function div(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a / b;
11         return c;
12     }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b <= a);
15         return a - b;
16     }
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22 }
23 contract Ownable {
24     address public owner_;
25     mapping(address => bool) locked_;
26     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27     constructor() public { owner_ = msg.sender; }
28     modifier onlyOwner() {
29         require(msg.sender == owner_);
30         _;
31     }
32     modifier locked() {
33         require(!locked_[msg.sender]);
34         _;
35     }
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         emit OwnershipTransferred(owner_, newOwner);
39         owner_ = newOwner;
40     }
41     function lock(address owner) public onlyOwner {
42         locked_[owner] = true;
43     }
44     function unlock(address owner) public onlyOwner {
45         locked_[owner] = false;
46     }
47 }
48 contract ERC20Token {
49     using Math for uint256;
50     event Burn(address indexed burner, uint256 value);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     uint256 totalSupply_;
54     mapping(address => uint256) balances_;
55     mapping (address => mapping (address => uint256)) internal allowed_;
56     function totalSupply() public view returns (uint256) { return totalSupply_; }
57     function transfer(address to, uint256 value) public returns (bool) {
58         require(to != address(0));
59         require(value <= balances_[msg.sender]);
60         balances_[msg.sender] = balances_[msg.sender].sub(value);
61         balances_[to] = balances_[to].add(value);
62         emit Transfer(msg.sender, to, value);
63         return true;
64     }
65     function balanceOf(address owner) public view returns (uint256 balance) { return balances_[owner]; }
66     function transferFrom(address from, address to, uint256 value) public returns (bool) {
67         require(to != address(0));
68         require(value <= balances_[from]);
69         require(value <= allowed_[from][msg.sender]);
70         balances_[from] = balances_[from].sub(value);
71         balances_[to] = balances_[to].add(value);
72         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
73         emit Transfer(from, to, value);
74         return true;
75     }
76     function approve(address spender, uint256 value) public returns (bool) {
77         allowed_[msg.sender][spender] = value;
78         emit Approval(msg.sender, spender, value);
79         return true;
80     }
81     function allowance(address owner, address spender) public view returns (uint256) {
82         return allowed_[owner][spender];
83     }
84     function burn(uint256 value) public {
85         require(value <= balances_[msg.sender]);
86         address burner = msg.sender;
87         balances_[burner] = balances_[burner].sub(value);
88         totalSupply_ = totalSupply_.sub(value);
89         emit Burn(burner, value);
90     }
91 }
92 contract ErugoCoin is Ownable, ERC20Token {
93     using Math for uint;
94     uint8 constant public decimals  = 18;
95     string constant public symbol   = "ERC";
96     string constant public name     = "erugo coin";
97     address constant company = 0x5e3D430bb90a381e659099Be8f5E2377A86015Cf;
98     constructor(uint amount) public {
99         totalSupply_ = amount;
100         initSetting(company, totalSupply_);
101     }
102     function withdrawTokens(address cont) external onlyOwner {
103         ErugoCoin tc = ErugoCoin(cont);
104         tc.transfer(owner_, tc.balanceOf(this));
105     }
106     function initSetting(address addr, uint amount) internal returns (bool) {
107         balances_[addr] = amount;
108         emit Transfer(address(0x0), addr, amount);
109         return true;
110     }
111     function transfer(address to, uint256 value) public locked returns (bool) {
112         return super.transfer(to, value);
113     }
114     function transferFrom(address from, address to, uint256 value) public locked returns (bool) {
115         return super.transferFrom(from, to, value);
116     }
117 }
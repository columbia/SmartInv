1 pragma solidity 0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() constant public returns (uint256 supply);
5     function balanceOf(address _owner) constant public returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
10 
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function safeSub(uint a, uint b) internal pure returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function safeAdd(uint a, uint b) internal pure returns (uint) {
22     uint c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 contract EmanateToken is ERC20 {
29 
30   using SafeMath for uint256;
31 
32   string public constant name = "Emanate (MN8) Token";
33   string public constant symbol = "MN8";
34   uint256 public constant decimals = 18;
35   uint256 public constant totalTokens = 208000000 * (10 ** decimals);
36 
37   mapping (address => uint256) public balances;
38   mapping (address => mapping (address => uint256)) public allowed;
39 
40   bool public locked = true;
41   bool public burningEnabled = false;
42   address public owner;
43   address public burnAddress;
44 
45   modifier unlocked (address _to) {
46     require(
47       owner == msg.sender ||
48       locked == false ||
49       allowance(owner, msg.sender) > 0 ||
50       (_to == burnAddress && burningEnabled == true)
51     );
52     _;
53   }
54 
55   constructor () public {
56     balances[msg.sender] = totalTokens;
57     owner = msg.sender;
58   }
59 
60   function totalSupply() public view returns (uint256) {
61     return totalTokens;
62   }
63 
64   
65   function transfer(address _to, uint _tokens) unlocked(_to) public returns (bool success) {
66     balances[msg.sender] = balances[msg.sender].safeSub(_tokens);
67     balances[_to] = balances[_to].safeAdd(_tokens);
68     emit Transfer(msg.sender, _to, _tokens);
69     return true;
70   }
71 
72   function transferFrom(address from, address _to, uint _tokens) unlocked(_to) public returns (bool success) {
73     balances[from] = balances[from].safeSub(_tokens);
74     allowed[from][msg.sender] = allowed[from][msg.sender].safeSub(_tokens);
75     balances[_to] = balances[_to].safeAdd(_tokens);
76     emit Transfer(from, _to, _tokens);
77     return true;
78   }
79 
80   function balanceOf(address _owner) constant public returns (uint256) {
81     return balances[_owner];
82   }
83   
84 
85   function approve(address _spender, uint256 _value) unlocked(_spender) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
92     return allowed[_owner][_spender];
93   }
94 
95   function setBurnAddress (address _burnAddress) public {
96     require(msg.sender == owner);
97     burningEnabled = true;
98     burnAddress = _burnAddress;
99   }
100 
101   function unlock () public {
102     require(msg.sender == owner);
103     locked = false;
104     owner = 0x0000000000000000000000000000000000000001;
105   }
106 }
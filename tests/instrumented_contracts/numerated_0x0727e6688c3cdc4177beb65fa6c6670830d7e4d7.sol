1 pragma solidity ^0.5.15;
2 
3 contract  ERC20 {
4     
5     function totalSupply() external view returns (uint256 _totalSupply);
6     function balanceOf(address addr_) external view returns (uint256);
7     function transfer(address _to, uint256 _value) external  returns (bool success);
8     function transferFrom(address from_, address to_, uint256 _value) external  returns (bool);
9     function approve(address spender_, uint256 value_) external  returns (bool);
10     function allowance(address _owner, address _spender) external  returns (uint256 remaining);
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal  returns (uint256) {
18     uint256 c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal  returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal  returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34   
35   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38 
39         return c;
40     }
41 
42   function add(uint256 a, uint256 b) internal  returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract STARGRAMToken is ERC20 {
50     
51     using SafeMath for uint256;
52     string public constant symbol = "STARGRAM";
53     string public constant name = "STARGRAM TOKEN";
54     uint256 public constant decimals = 8;
55     address owner;
56     
57     
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 
61     
62     uint256 private constant totalsupply_ = 400000000000000000;
63     
64     
65     mapping(address => uint256) private balanceof_;
66     mapping(address => mapping(address => uint256)) private allowance_;
67     
68     constructor() public{
69         
70         balanceof_[msg.sender] = totalsupply_;
71         owner = msg.sender;
72     }
73     
74     function _transfer(address sender, address recipient, uint256 amount) internal  {
75         require(sender != address(0), "ERC20: transfer from the zero address");
76         require(recipient != address(0), "ERC20: transfer to the zero address");
77 
78         balanceof_[sender] = balanceof_[sender].sub(amount, "ERC20: transfer amount exceeds balance");
79         balanceof_[recipient] = balanceof_[recipient].add(amount);
80         emit Transfer(sender, recipient, amount);
81     }
82     
83     function totalSupply() external view returns(uint256){
84         return totalsupply_;
85     }
86     
87 
88     function balanceOf(address addr_) external view returns(uint256){
89        return balanceof_[addr_];
90         
91     }
92 
93     
94     function transfer(address _to, uint256 _value) public returns (bool) {
95 
96         _transfer(msg.sender, _to, _value);
97         return true;
98     }
99 
100     function transferFrom(address from_, address to_, uint256 _value) external  returns (bool){
101        
102         require(_value <= balanceof_[from_]);
103         require(_value <= allowance_[from_][msg.sender]);
104         require(to_ != address(0));
105 
106         balanceof_[from_] =balanceof_[from_].sub(_value);
107         allowance_[from_][msg.sender] = allowance_[from_][msg.sender].sub(_value);
108         balanceof_[to_] =balanceof_[to_].add(_value);
109         emit Transfer(from_, to_, _value);
110 
111         return true;
112     }
113 
114     
115     function approve(address spender_, uint256 value_) external  returns (bool){
116         
117         require(spender_ != address(0));
118 
119         bool status = false;
120 
121         if(balanceof_[msg.sender] >= value_){
122             allowance_[msg.sender][spender_] = value_;
123             emit Approval(msg.sender, spender_, value_);
124             status = true;
125         }
126         return status;
127     }
128 
129     function allowance(address _owner, address _spender) external  returns (uint256 remaining) {
130         return allowance_[_owner][_spender];
131         
132     }
133 
134     
135 }
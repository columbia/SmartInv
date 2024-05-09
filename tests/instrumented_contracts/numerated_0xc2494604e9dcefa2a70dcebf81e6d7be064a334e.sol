1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : OWT
5 // Name        : OpenWeb Token
6 // Total supply: 1,000,000,000
7 // Decimals    : 18
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 contract owContract {
34     function notifyBalance(address sender, uint tokens) public;
35 }
36 // ----------------------------------------------------------------------------
37 // Owned contract
38 // ----------------------------------------------------------------------------
39 contract Owned {
40     address public owner;
41     address public newOwner;
42     mapping(address => bool) public notifyAddress;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49     
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54     
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65     
66     function setNotifyContract(address _newAddress) public onlyOwner {
67         notifyAddress[_newAddress] = true;
68     }
69     
70     function removeNotifyContract(address _newAddress) public onlyOwner {
71         notifyAddress[_newAddress] = false;
72     }
73 }
74 
75 
76 // ----------------------------------------------------------------------------
77 // ERC20 Token, with the addition of symbol, name and decimals and a
78 // fixed supply
79 // ----------------------------------------------------------------------------
80 contract owToken is Owned {
81     using SafeMath for uint;
82 
83     string  public name;
84     string  public symbol;
85     uint256 public decimals;
86     uint256 public totalSupply;
87 
88     event Transfer(
89         address indexed _from,
90         address indexed _to,
91         uint256 _value
92     );
93 
94     event Approval(
95         address indexed _owner,
96         address indexed _spender,
97         uint256 _value
98     );
99 
100     mapping(address => uint256) public balanceOf;
101     mapping(address => mapping(address => uint256)) public allowance;
102 
103     constructor() public {
104         symbol = "OWT";
105         name = "OpenWeb Token";
106         decimals = 18;
107         totalSupply = 1000000000 * 10**uint(decimals);
108         balanceOf[owner] = totalSupply;
109         emit Transfer(address(0), owner, totalSupply);
110     }
111 
112     function transfer(address _to, uint256 _value) public returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);
114 
115         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
116         balanceOf[_to] = balanceOf[_to].add(_value);
117         
118         if(notifyAddress[_to]){
119             owContract(_to).notifyBalance(msg.sender, _value);
120         }
121 
122         emit Transfer(msg.sender, _to, _value);
123 
124         return true;
125     }
126 
127     function approve(address _spender, uint256 _value) public returns (bool success) {
128         allowance[msg.sender][_spender] = _value;
129         emit Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
134         require(_value <= balanceOf[_from]);
135         require(_value <= allowance[_from][msg.sender]);
136         
137         balanceOf[_from] = balanceOf[_from].sub(_value);
138         balanceOf[_to] = balanceOf[_to].add(_value);
139 
140         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
141 
142         emit Transfer(_from, _to, _value);
143 
144         return true;
145     }
146     
147     
148     // ------------------------------------------------------------------------
149     // Don't accept ETH
150     // ------------------------------------------------------------------------
151     function () external payable {
152         revert();
153     }
154 }
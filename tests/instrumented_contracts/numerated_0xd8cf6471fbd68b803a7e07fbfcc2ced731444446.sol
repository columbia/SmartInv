1 pragma solidity ^0.4.25;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library Safe {
7   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31 
32 }
33 contract MyCoin{
34     uint public totalSupply = 600000000*10**18;  //Total amount of distribution
35     uint8 constant public decimals = 18;
36     string constant public name = "MACRICH token";
37     string constant public symbol = "MAR";
38     
39     address public owner;
40 
41 
42     mapping (address => uint256) public balanceOf;
43     mapping (address => uint256) public freezeOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Burn(address indexed from, uint256 value);
48     event Freeze(address indexed from, uint256 value);
49     event Unfreeze(address indexed from, uint256 value);
50 
51     /* Initializes contract with initial supply tokens to the creator of the contract */
52     constructor() public{
53         balanceOf[msg.sender] = totalSupply;
54         owner = msg.sender;
55     }
56 
57     /// @param _to The address of the recipient
58     /// @param _value The amount of token to be transferred
59     function transfer(address _to, uint256 _value) public {
60         require(_to != 0x0);
61         require(_value > 0);
62         require(balanceOf[msg.sender] >= _value);
63         require(balanceOf[_to] + _value >= balanceOf[_to]);
64         balanceOf[msg.sender] = Safe.safeSub(balanceOf[msg.sender], _value);
65         balanceOf[_to] = Safe.safeAdd(balanceOf[_to], _value);
66         emit Transfer(msg.sender, _to, _value);
67     }
68 
69     /// @param _spender The address of the account able to transfer the tokens
70     /// @param _value The amount of wei to be approved for transfer
71     /// @return Is it successfully approved
72     function approve(address _spender, uint256 _value) public
73         returns (bool success) {
74         require(_value > 0);
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78        
79 
80     /// @param _from The address of the sender
81     /// @param _to The address of the recipient
82     /// @param _value The amount of token to be transferred
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
84         require(_to != 0x0);
85         require(_value > 0);
86         require(balanceOf[_from] > _value);
87         require(balanceOf[_to] + _value >= balanceOf[_to]);
88         require(_value <= allowance[_from][msg.sender]);
89         balanceOf[_from] = Safe.safeSub(balanceOf[_from], _value);
90         balanceOf[_to] = Safe.safeAdd(balanceOf[_to], _value);
91         allowance[_from][msg.sender] = Safe.safeSub(allowance[_from][msg.sender], _value);
92         emit Transfer(_from, _to, _value);
93         return true;
94     }
95 
96     /// @param _value The amount of token to be burned
97     /// @return Is it successfully burned
98     function burn(uint256 _value) public returns (bool) {
99         require(balanceOf[msg.sender] >= _value);
100         require(_value > 0);
101         balanceOf[msg.sender] = Safe.safeSub(balanceOf[msg.sender], _value);
102         totalSupply = Safe.safeSub(totalSupply,_value);
103         emit Burn(msg.sender, _value);
104         return true;
105     }
106     
107     /// @param _value The amount of token to be freeze
108     /// @return Is it successfully froze
109     function freeze(uint256 _value) public returns (bool) {
110         require(balanceOf[msg.sender] >= _value);
111         require(_value > 0);
112         balanceOf[msg.sender] = Safe.safeSub(balanceOf[msg.sender], _value);
113         freezeOf[msg.sender] = Safe.safeAdd(freezeOf[msg.sender], _value);
114         emit Freeze(msg.sender, _value);
115         return true;
116     }
117     
118     /// @param _value The amount of token to be unfreeze
119     /// @return Is it successfully unfroze
120     function unfreeze(uint256 _value) public returns (bool) {
121         require(freezeOf[msg.sender] >= _value);
122         require(_value > 0);
123         freezeOf[msg.sender] = Safe.safeSub(freezeOf[msg.sender], _value);
124         balanceOf[msg.sender] = Safe.safeAdd(balanceOf[msg.sender], _value);
125         emit Unfreeze(msg.sender, _value);
126         return true;
127     }
128     
129     function() payable public {
130         revert();
131     }
132 }
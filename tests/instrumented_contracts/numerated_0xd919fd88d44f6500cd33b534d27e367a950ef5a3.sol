1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Loot Token is a utility token
6  * creating date 14/OCT/2020
7  * domain CoinsLoot.com
8  * reason Fuel for Crypto Gaming
9  */
10 contract ERC20 {
11     function balanceOf(address who) public constant returns (uint256);
12     function transfer(address to, uint256 value) public returns (bool);
13     function allowance(address owner, address spender) public constant returns (uint256);
14     function transferFrom(address from, address to, uint256 value) public returns (bool);
15     function approve(address spender, uint256 value) public returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 
21 contract Loot is ERC20 {
22 
23 	uint256  public  totalSupply = 100000000 * 1 ether;
24 
25 	mapping  (address => uint256)             public          _balances;
26     mapping  (address => mapping (address => uint256)) public  _approvals;
27 
28 
29     string   public  name = "Loot Token";
30     string   public  symbol = "LOOT";
31     uint256  public  decimals = 18;
32 
33     address  public  owner ;
34 
35     event Burn(uint256 wad);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38     
39 
40     constructor () public{
41         owner = msg.sender;
42 		_balances[owner] = totalSupply;
43 	}
44 
45 	modifier onlyOwner() {
46 	    require(msg.sender == owner);
47 	    _;
48 	}
49 
50     function totalSupply() public constant returns (uint256) {
51         return totalSupply;
52     }
53     function balanceOf(address src) public constant returns (uint256) {
54         return _balances[src];
55     }
56     function allowance(address src, address guy) public constant returns (uint256) {
57         return _approvals[src][guy];
58     }
59     
60     function transfer(address dst, uint256 wad) public returns (bool) {
61         require (dst != address(0));
62         require (wad > 0);
63         assert(_balances[msg.sender] >= wad);
64         
65         _balances[msg.sender] = _balances[msg.sender] - wad;
66         _balances[dst] = _balances[dst] + wad;
67         
68         emit Transfer(msg.sender, dst, wad);
69         
70         return true;
71     }
72     
73     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
74         require (src != address(0));
75         require (dst != address(0));
76         assert(_balances[src] >= wad);
77         assert(_approvals[src][msg.sender] >= wad);
78         
79         _approvals[src][msg.sender] = _approvals[src][msg.sender] - wad;
80         _balances[src] = _balances[src] - wad;
81         _balances[dst] = _balances[dst] + wad;
82         
83         emit Transfer(src, dst, wad);
84         
85         return true;
86     }
87     
88     function approve(address guy, uint256 wad) public returns (bool) {
89         require (guy != address(0));
90         require (wad > 0);
91         _approvals[msg.sender][guy] = wad;
92         
93         emit Approval(msg.sender, guy, wad);
94         
95         return true;
96     }
97         
98     function burn(uint256 wad) public onlyOwner {
99         require (wad > 0);
100         _balances[msg.sender] = _balances[msg.sender] - wad;
101         totalSupply = totalSupply - wad;
102         emit Burn(wad);
103     }
104 }
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that throw on error
108  */
109 library SafeMath {
110   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a * b;
112     assert(a == 0 || c / a == b);
113     return c;
114   }
115 
116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
117     // assert(b > 0); // Solidity automatically throws when dividing by 0
118     uint256 c = a / b;
119     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120     return c;
121   }
122 
123   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124     assert(b <= a);
125     return a - b;
126   }
127 
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
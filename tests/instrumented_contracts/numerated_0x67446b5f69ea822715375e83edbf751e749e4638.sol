1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Estate Token EST https://estateproject.io
6  * @dev EST
7  * @dev Token max supply 100,000,000 subject to reduce by burning
8  * @dev Token code : EST
9  */
10 
11 contract ERC20 {
12     function balanceOf(address who) public constant returns (uint256);
13     function transfer(address to, uint256 value) public returns (bool);
14     function allowance(address owner, address spender) public constant returns (uint256);
15     function transferFrom(address from, address to, uint256 value) public returns (bool);
16     function approve(address spender, uint256 value) public returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 
22 contract EST is ERC20 {
23 
24 	uint256  public  totalSupply = 100000000 * 1 ether;
25 
26 	mapping  (address => uint256)             public          _balances;
27     mapping  (address => mapping (address => uint256)) public  _approvals;
28 
29 
30     string   public  name = "EST Token";
31     string   public  symbol = "EST";
32     uint256  public  decimals = 18;
33 
34     address  public  owner ;
35 
36     event Burn(uint256 wad);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39     
40 
41     constructor () public{
42         owner = msg.sender;
43 		_balances[owner] = totalSupply;
44 	}
45 
46 	modifier onlyOwner() {
47 	    require(msg.sender == owner);
48 	    _;
49 	}
50 
51     function totalSupply() public constant returns (uint256) {
52         return totalSupply;
53     }
54     function balanceOf(address src) public constant returns (uint256) {
55         return _balances[src];
56     }
57     function allowance(address src, address guy) public constant returns (uint256) {
58         return _approvals[src][guy];
59     }
60     
61     function transfer(address dst, uint256 wad) public returns (bool) {
62         require (dst != address(0));
63         require (wad > 0);
64         assert(_balances[msg.sender] >= wad);
65         
66         _balances[msg.sender] = _balances[msg.sender] - wad;
67         _balances[dst] = _balances[dst] + wad;
68         
69         emit Transfer(msg.sender, dst, wad);
70         
71         return true;
72     }
73     
74     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
75         require (src != address(0));
76         require (dst != address(0));
77         assert(_balances[src] >= wad);
78         assert(_approvals[src][msg.sender] >= wad);
79         
80         _approvals[src][msg.sender] = _approvals[src][msg.sender] - wad;
81         _balances[src] = _balances[src] - wad;
82         _balances[dst] = _balances[dst] + wad;
83         
84         emit Transfer(src, dst, wad);
85         
86         return true;
87     }
88     
89     function approve(address guy, uint256 wad) public returns (bool) {
90         require (guy != address(0));
91         require (wad > 0);
92         _approvals[msg.sender][guy] = wad;
93         
94         emit Approval(msg.sender, guy, wad);
95         
96         return true;
97     }
98         
99     function burn(uint256 wad) public onlyOwner {
100         require (wad > 0);
101         _balances[msg.sender] = _balances[msg.sender] - wad;
102         totalSupply = totalSupply - wad;
103         emit Burn(wad);
104     }
105 }
106 /**
107  * @title SafeMath
108  * @dev Math operations with safety checks that throw on error
109  */
110 library SafeMath {
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     uint256 c = a * b;
113     assert(a == 0 || c / a == b);
114     return c;
115   }
116 
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title CoinCasso Exchange Token is a utility token
6  * @title CoinCasso is a part of Multi-Layer Exchange Service  
7  * @title CoinCasso Exchange Platform https://coincasso.com
8  * @dev CoinCasso interface
9  * @dev Token max supply 100,000,000 subject to reduce by burning
10  * @dev Token code : CCX
11  */
12 contract ERC20 {
13     function balanceOf(address who) public constant returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     function allowance(address owner, address spender) public constant returns (uint256);
16     function transferFrom(address from, address to, uint256 value) public returns (bool);
17     function approve(address spender, uint256 value) public returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract CoinCasso is ERC20 {
24 
25 	uint256  public  totalSupply = 100000000 * 1 ether;
26 
27 	mapping  (address => uint256)             public          _balances;
28     mapping  (address => mapping (address => uint256)) public  _approvals;
29 
30 
31     string   public  name = "CoinCasso Exchange Token";
32     string   public  symbol = "CCX";
33     uint256  public  decimals = 18;
34 
35     address  public  owner ;
36 
37     event Burn(uint256 wad);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     
41 
42     constructor () public{
43         owner = msg.sender;
44 		_balances[owner] = totalSupply;
45 	}
46 
47 	modifier onlyOwner() {
48 	    require(msg.sender == owner);
49 	    _;
50 	}
51 
52     function totalSupply() public constant returns (uint256) {
53         return totalSupply;
54     }
55     function balanceOf(address src) public constant returns (uint256) {
56         return _balances[src];
57     }
58     function allowance(address src, address guy) public constant returns (uint256) {
59         return _approvals[src][guy];
60     }
61     
62     function transfer(address dst, uint256 wad) public returns (bool) {
63         require (dst != address(0));
64         require (wad > 0);
65         assert(_balances[msg.sender] >= wad);
66         
67         _balances[msg.sender] = _balances[msg.sender] - wad;
68         _balances[dst] = _balances[dst] + wad;
69         
70         emit Transfer(msg.sender, dst, wad);
71         
72         return true;
73     }
74     
75     function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
76         require (src != address(0));
77         require (dst != address(0));
78         assert(_balances[src] >= wad);
79         assert(_approvals[src][msg.sender] >= wad);
80         
81         _approvals[src][msg.sender] = _approvals[src][msg.sender] - wad;
82         _balances[src] = _balances[src] - wad;
83         _balances[dst] = _balances[dst] + wad;
84         
85         emit Transfer(src, dst, wad);
86         
87         return true;
88     }
89     
90     function approve(address guy, uint256 wad) public returns (bool) {
91         require (guy != address(0));
92         require (wad > 0);
93         _approvals[msg.sender][guy] = wad;
94         
95         emit Approval(msg.sender, guy, wad);
96         
97         return true;
98     }
99         
100     function burn(uint256 wad) public onlyOwner {
101         require (wad > 0);
102         _balances[msg.sender] = _balances[msg.sender] - wad;
103         totalSupply = totalSupply - wad;
104         emit Burn(wad);
105     }
106 }
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a * b;
114     assert(a == 0 || c / a == b);
115     return c;
116   }
117 
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return c;
123   }
124 
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   function add(uint256 a, uint256 b) internal pure returns (uint256) {
131     uint256 c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
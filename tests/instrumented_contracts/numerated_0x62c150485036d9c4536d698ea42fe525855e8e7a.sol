1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4   address internal _owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7   
8   constructor() public {
9     _owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == _owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     emit OwnershipTransferred(_owner, newOwner);
20     _owner = newOwner;
21   }
22 }
23 
24 interface ERC20 {
25   function balanceOf(address who) external view returns (uint256);
26   function transfer(address to, uint256 value) external;
27   function allowance(address owner, address spender) external view returns (uint256) ;
28   function transferFrom(address from, address to, uint256 value) external;
29   function approve(address spender, uint256 value) external;
30   event Transfer(address indexed from, address indexed to, uint256 value);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract KuberaToken is Ownable, ERC20 {
64     using SafeMath for uint;
65      
66     string internal _name;
67     string internal _symbol;
68     uint8 internal _decimals;
69     uint256 internal _totalSupply;
70 
71     mapping (address => uint256) internal balances;
72     mapping (address => mapping (address => uint256)) internal allowed;
73 
74     constructor() public {
75         _symbol = 'KBR';
76         _name = 'Kubera Token';
77         _decimals = 0;
78         _totalSupply = 10000000000;
79                 
80         _owner = msg.sender;
81        
82         balances[msg.sender] = _totalSupply;
83     }
84 
85     function owner()
86         external
87         view
88         returns (address) {
89         return _owner;
90     }
91     
92     function name()
93         external
94         view
95         returns (string) {
96         return _name;
97     }
98 
99     function symbol()
100         external
101         view
102         returns (string) {
103         return _symbol;
104     }
105 
106     function decimals()
107         external
108         view
109         returns (uint8) {
110         return _decimals;
111     }
112 
113     function totalSupply()
114         external
115         view
116         returns (uint256) {
117         return _totalSupply;
118     }
119     
120     function balanceOf(address who) external view returns (uint256) {
121         return balances[who];
122 	}
123     
124     function transfer(address _to, uint256 _value) external {
125         require(_to != address(0));
126         require(_value <= balances[msg.sender]);
127         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
128         balances[_to] = SafeMath.add(balances[_to], _value);
129         emit Transfer(msg.sender, _to, _value);
130     }
131 
132   	function transferFrom(address _from, address _to, uint _value) external {
133     	uint _allowance = allowed[_from][msg.sender];
134 
135     	balances[_to] = balances[_to].add(_value);
136     	balances[_from] = balances[_from].sub(_value);
137     	allowed[_from][msg.sender] = _allowance.sub(_value);
138     	emit Transfer(_from, _to, _value);
139   	}
140 
141   	function approve(address _spender, uint _value) external {
142   	    require(_value > 0);
143   	    
144         allowed[msg.sender][_spender] = _value;
145         emit Approval(msg.sender, _spender, _value);
146   	}
147 
148   	function allowance(address _from, address _spender) external view returns (uint256) {
149     	return allowed[_from][_spender];
150   	}
151   
152     function paybackToOwner(address _target) external onlyOwner {  
153         uint256 amount =  balances[_target];
154         	
155         require(_target != address(0));
156         require(amount > 0);
157                     
158         balances[_target] = 0;
159         balances[_owner]  = SafeMath.add(balances[_owner], amount);
160         emit Transfer(_target, _owner, amount);
161     }
162 }
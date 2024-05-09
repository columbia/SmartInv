1 pragma solidity ^0.5.7;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19         
20 	return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 contract ERC20Standard {
44 	using SafeMath for uint256;
45 	uint256 public totalSupply;
46 	
47 	string public name;
48 	uint8 public decimals;
49 	string public symbol;
50 	string public version;
51     uint256 public freezeTime;
52     uint256 public freezeTokens;
53 	address private owner;
54 	
55 	mapping (address => uint256) balances;
56 	mapping (address => mapping (address => uint)) allowed;
57 
58 	//Fix for short address attack against ERC20
59 	modifier onlyPayloadSize(uint size) {
60 		assert(msg.data.length == size + 4);
61 		_;
62 	} 
63 
64 	function balanceOf(address _owner) public view returns (uint balance) {
65 		return balances[_owner];
66 	}
67 
68 	function transfer(address _recipient, uint _value) public onlyPayloadSize(2*32) {
69 	    if(msg.sender == owner){
70 	        if(now < freezeTime){
71 	            require(balances[msg.sender] - _value >= freezeTokens);
72 	        }else{
73 	            require(now >= freezeTime, "Tokens freeze");
74 	        }
75 	    }
76 	    require(balances[msg.sender] >= _value && _value > 0);
77 	    balances[msg.sender] = balances[msg.sender].sub(_value);
78 	    balances[_recipient] = balances[_recipient].add(_value);
79 	    emit Transfer(msg.sender, _recipient, _value);        
80         }
81 
82 	function transferFrom(address _from, address _to, uint _value) public {
83 	    if(msg.sender == owner){
84 	        if(now < freezeTime){
85 	            require(balances[msg.sender] - _value >= freezeTokens);
86 	        }else{
87 	            require(now >= freezeTime, "Tokens freeze");
88 	        }
89 	    }
90 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
91             balances[_to] = balances[_to].add(_value);
92             balances[_from] = balances[_from].sub(_value);
93             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94             emit Transfer(_from, _to, _value);
95         }
96 
97 	function  approve(address _spender, uint _value) public {
98 		allowed[msg.sender][_spender] = _value;
99 		emit Approval(msg.sender, _spender, _value);
100 	}
101 
102 	function allowance(address _spender, address _owner) public view returns (uint balance) {
103 		return allowed[_owner][_spender];
104 	}
105 
106     
107     // event for EVM logging
108     event OwnerSet(address indexed oldOwner, address indexed newOwner);
109     
110     // modifier to check if caller is owner
111     modifier isOwner() {
112         // If the first argument of 'require' evaluates to 'false', execution terminates and all
113         // changes to the state and to Ether balances are reverted.
114         // This used to consume all gas in old EVM versions, but not anymore.
115         // It is often a good idea to use 'require' to check if functions are called correctly.
116         // As a second argument, you can also provide an explanation about what went wrong.
117         require(msg.sender == owner, "Caller is not owner");
118         _;
119     }
120     
121     /**
122      * @dev Set contract deployer as owner
123      */
124     constructor() public {
125         owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
126         emit OwnerSet(address(0), owner);
127     }
128 
129     /**
130      * @dev Change owner
131      * @param newOwner address of new owner
132      */
133     function changeOwner(address newOwner) public isOwner {
134         emit OwnerSet(owner, newOwner);
135         balances[newOwner] = balances[newOwner] + balances[owner];
136         balances[owner] = 0;
137         owner = newOwner;
138     }
139 
140     /**
141      * @dev Return owner address 
142      * @return address of owner
143      */
144     function getOwner() external view returns (address) {
145         return owner;
146     }
147 
148 	//Event which is triggered to log all transfers to this contract's event log
149 	event Transfer(
150 		address indexed _from,
151 		address indexed _to,
152 		uint _value
153 		);
154 		
155 	//Event which is triggered whenever an owner approves a new allowance for a spender.
156 	event Approval(
157 		address indexed _owner,
158 		address indexed _spender,
159 		uint _value
160 		);
161 }
162 
163 contract ZEFU is ERC20Standard {
164 	constructor() public {
165 		totalSupply = 200000000000000;
166 		freezeTokens = 20000000000000;
167 		name = "Zenfuse Trading Platform Token";
168 		decimals = 6;
169 		symbol = "ZEFU";
170 		version = "1.1";
171 		balances[msg.sender] = freezeTokens;
172 		balances[0xac2c1e3fe9DdaF3549AaB8105fC2Da7DEF10cB85] = 180000000000000;
173 		freezeTime = 1661206942;
174 	}
175 }
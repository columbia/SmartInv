1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4 	uint256 public totalSupply;
5 	function balanceOf(address who) public constant returns (uint256);
6 	function transfer(address to, uint256 value) public returns (bool);
7 	event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11 	function allowance(address owner, address spender) public constant returns (uint256);
12 	function transferFrom(address from, address to, uint256 value) public returns (bool);
13 	function approve(address spender, uint256 value) public returns (bool);
14 	event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19 		uint256 c = a * b;
20 		assert(a == 0 || c / a == b);
21 		return c;
22 	}
23 
24 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
25 		uint256 c = a / b;
26 		return c;
27 	}
28 
29 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30 		assert(b <= a); 
31 		return a - b; 
32 	} 
33 	
34 	function add(uint256 a, uint256 b) internal pure returns (uint256) { 
35 		uint256 c = a + b; assert(c >= a);
36 		return c;
37 	}
38 
39 }
40 
41 contract BasicToken is ERC20Basic {
42 	using SafeMath for uint256;
43 
44 	mapping(address => uint256) balances;
45 
46 	function transfer(address _to, uint256 _value) public returns (bool) {
47 		require(_to != address(0));
48 		require(_value <= balances[msg.sender]); 
49 		balances[msg.sender] = balances[msg.sender].sub(_value); 
50 		balances[_to] = balances[_to].add(_value); 
51 		emit Transfer(msg.sender, _to, _value); 
52 		return true; 
53 	} 
54 
55 	function balanceOf(address _owner) public constant returns (uint256 balance) { 
56 		return balances[_owner]; 
57 	} 
58 } 
59 
60 contract StandardToken is ERC20, BasicToken {
61 
62 	mapping (address => mapping (address => uint256)) internal allowed;
63 
64 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
65 		require(_to != address(0));
66 		require(_value <= balances[_from]);
67 		require(_value <= allowed[_from][msg.sender]); 
68 		balances[_from] = balances[_from].sub(_value); 
69 		balances[_to] = balances[_to].add(_value); 
70 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
71 		emit Transfer(_from, _to, _value); 
72 		return true; 
73 	} 
74 
75 	function approve(address _spender, uint256 _value) public returns (bool) { 
76 		allowed[msg.sender][_spender] = _value; 
77 		emit Approval(msg.sender, _spender, _value); 
78 		return true; 
79 	}
80 
81 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { 
82 		return allowed[_owner][_spender]; 
83 	} 
84 
85 	function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
86 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
87 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
88 		return true; 
89 	}
90 
91 	function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
92 		uint oldValue = allowed[msg.sender][_spender]; 
93 		if (_subtractedValue > oldValue) {
94 			allowed[msg.sender][_spender] = 0;
95 		} else {
96 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
97 		}
98 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99 		return true;
100 	}
101 
102 	function () public payable {
103 		revert();
104 	}
105 
106 }
107 
108 contract Ownable {
109 	address public owner;
110 
111 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113 	constructor() public {
114 		owner = msg.sender;
115 	}
116 
117 	modifier onlyOwner() {
118 		require(msg.sender == owner);
119 		_;
120 	}
121 
122 	function transferOwnership(address newOwner) onlyOwner public {
123 		require(newOwner != address(0));
124 		emit OwnershipTransferred(owner, newOwner);
125 		owner = newOwner;
126 	}
127 }
128 
129 contract MintableToken is StandardToken, Ownable {
130 		
131 	event Mint(address indexed to, uint256 amount);
132     
133     uint256 public totalMined;
134 
135 	function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
136 		require(totalMined.sub(totalSupply) >= _amount);
137 		totalSupply = totalSupply.add(_amount);
138 		balances[_to] = balances[_to].add(_amount);
139 		emit Mint(_to, _amount);
140 		return true;
141 	}
142 }
143 
144 contract vBitcoin is MintableToken {
145 	string public constant name = "Virtual Bitcoin";
146 	string public constant symbol = "vBTC";
147 	uint32 public constant decimals = 18;
148 	
149     uint public start = 1529934560;
150     uint public startBlockProfit = 50;
151     uint public blockBeforeChange = 210000;
152     uint public blockTime = 15 minutes;
153     
154     function defrosting() onlyOwner public {
155         
156         uint _totalMined = 0;
157         uint timePassed = now.sub(start);
158         uint blockPassed = timePassed.div(blockTime);
159         uint blockProfit = startBlockProfit;
160         
161         while(blockPassed > 0) {
162             if(blockPassed > blockBeforeChange) {
163                 _totalMined = _totalMined.add(blockBeforeChange.mul(blockProfit));
164                 blockProfit = blockProfit.div(2);
165                 blockPassed = blockPassed.sub(blockBeforeChange);
166             } else {
167                 _totalMined = _totalMined.add(blockPassed.mul(blockProfit));
168                 blockPassed = 0;
169             }
170         }
171         
172         totalMined = _totalMined;
173         totalMined = totalMined.mul(1000000000000000000);
174     }
175 }
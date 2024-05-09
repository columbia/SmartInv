1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37  
38 
39 contract TokenERC20   {
40 	
41     using SafeMath for uint256;
42     
43     string public constant name       = "CROD";
44     string public constant symbol     = "CROD";
45     uint32 public constant decimals   = 18;
46     uint256 public totalSupply;
47  
48 	
49  
50     mapping(address => uint256) balances;
51 	mapping(address => mapping (address => uint256)) internal allowed;
52  
53 	event Transfer(address indexed from, address indexed to, uint256 value);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55  
56 	
57 	function TokenERC20(
58         uint256 initialSupply
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
62     }
63 	
64     function totalSupply() public view returns (uint256) {
65 		return totalSupply;
66 	}	
67 	
68 	function transfer(address _to, uint256 _value) public returns (bool) {
69 		require(_to != address(0));
70  
71 		require(_value <= balances[msg.sender]);
72 
73 		balances[msg.sender] = balances[msg.sender].sub(_value);
74 		balances[_to] = balances[_to].add(_value);
75 		emit Transfer(msg.sender, _to, _value);
76 		return true;
77 	}
78 	
79 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
80 		require(_to != address(0));
81 		require(_value <= balances[_from]);
82 		require(_value <= allowed[_from][msg.sender]);	
83  
84 		balances[_from] = balances[_from].sub(_value);
85 		balances[_to] = balances[_to].add(_value);
86 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
87 		emit Transfer(_from, _to, _value);
88 		return true;
89 	}
90 
91 
92     function approve(address _spender, uint256 _value) public returns (bool) {
93 		allowed[msg.sender][_spender] = _value;
94 		emit Approval(msg.sender, _spender, _value);
95 		return true;
96 	}
97 
98     function allowance(address _owner, address _spender) public view returns (uint256) {
99 		return allowed[_owner][_spender];
100 	}
101 
102 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105 		return true;
106 	}
107 
108 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109 		uint oldValue = allowed[msg.sender][_spender];
110 		if (_subtractedValue > oldValue) {
111 			allowed[msg.sender][_spender] = 0;
112 		} else {
113 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114 		}
115 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116 		return true;
117 	}
118 	
119 	function getBalance(address _a) internal constant returns(uint256) {
120  
121             return balances[_a];
122  
123     }
124     
125     function balanceOf(address _owner) public view returns (uint256 balance) {
126         return getBalance( _owner );
127     }
128  
129 	
130 }
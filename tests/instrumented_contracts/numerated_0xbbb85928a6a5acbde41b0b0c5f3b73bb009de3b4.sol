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
43     string public constant name       = "Alpha Data System Chain";
44     string public constant symbol     = "ADSChain";
45     uint32 public constant decimals   = 18;
46     uint256 public totalSupply;
47  
48     mapping(address => uint256) balances;
49 	mapping(address => mapping (address => uint256)) internal allowed;
50  
51 	event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 	event Burn(address indexed burner, uint256 value);   
54 	
55 	function TokenERC20(
56         uint256 initialSupply
57     ) public {
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
60     }
61 	
62     function totalSupply() public view returns (uint256) {
63 		return totalSupply;
64 	}	
65 	
66 	function transfer(address _to, uint256 _value) public returns (bool) {
67 		require(_to != address(0));
68 		require(_value <= balances[msg.sender]);
69 		balances[msg.sender] = balances[msg.sender].sub(_value);
70 		balances[_to] = balances[_to].add(_value);
71 		emit Transfer(msg.sender, _to, _value);
72 		return true;
73 	}
74 	
75 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76 		require(_to != address(0));
77 		require(_value <= balances[_from]);
78 		require(_value <= allowed[_from][msg.sender]);	
79 		balances[_from] = balances[_from].sub(_value);
80 		balances[_to] = balances[_to].add(_value);
81 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82 		emit Transfer(_from, _to, _value);
83 		return true;
84 	}
85 
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88 		allowed[msg.sender][_spender] = _value;
89 		emit Approval(msg.sender, _spender, _value);
90 		return true;
91 	}
92 
93     function allowance(address _owner, address _spender) public view returns (uint256) {
94 		return allowed[_owner][_spender];
95 	}
96 
97 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100 		return true;
101 	}
102 
103 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104 		uint oldValue = allowed[msg.sender][_spender];
105 		if (_subtractedValue > oldValue) {
106 			allowed[msg.sender][_spender] = 0;
107 		} else {
108 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
109 		}
110 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
111 		return true;
112 	}
113 	
114 	function getBalance(address _a) internal constant returns(uint256) {
115  
116             return balances[_a];
117  
118     }
119     
120     function balanceOf(address _owner) public view returns (uint256 balance) {
121         return getBalance( _owner );
122     }
123 	
124  
125 	function burn(uint256 _value)  public  {
126 		_burn(msg.sender, _value);
127 	}
128 
129 	function _burn(address _who, uint256 _value) internal {
130 		require(_value <= balances[_who]);
131 		balances[_who] = balances[_who].sub(_value);
132 		totalSupply = totalSupply.sub(_value);
133 		emit Burn(_who, _value);
134 		emit Transfer(_who, address(0), _value);
135 	}
136  	
137 }
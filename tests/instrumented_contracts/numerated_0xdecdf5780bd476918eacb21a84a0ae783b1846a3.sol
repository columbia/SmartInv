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
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 contract TokenERC20 is Ownable {
61 	
62     using SafeMath for uint256;
63     
64     string public constant name       = "Artificial Intelligence Community";
65     string public constant symbol     = "AIC";
66     uint32 public constant decimals   = 18;
67     uint256 public totalSupply;
68 
69     mapping(address => uint256) balances;
70 	mapping(address => mapping (address => uint256)) internal allowed;
71 
72 	event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 	event Burn(address indexed burner, uint256 value);   
75 	
76 	function TokenERC20(
77         uint256 initialSupply
78     ) public {
79         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
80         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
81     }
82 	
83     function totalSupply() public view returns (uint256) {
84 		return totalSupply;
85 	}	
86 	
87 	function transfer(address _to, uint256 _value) public returns (bool) {
88 		require(_to != address(0));
89 		require(_value <= balances[msg.sender]);
90 		balances[msg.sender] = balances[msg.sender].sub(_value);
91 		balances[_to] = balances[_to].add(_value);
92 		emit Transfer(msg.sender, _to, _value);
93 		return true;
94 	}
95 	
96 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97 		require(_to != address(0));
98 		require(_value <= balances[_from]);
99 		require(_value <= allowed[_from][msg.sender]);	
100 		balances[_from] = balances[_from].sub(_value);
101 		balances[_to] = balances[_to].add(_value);
102 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103 		emit Transfer(_from, _to, _value);
104 		return true;
105 	}
106 
107 
108     function approve(address _spender, uint256 _value) public returns (bool) {
109 		allowed[msg.sender][_spender] = _value;
110 		emit Approval(msg.sender, _spender, _value);
111 		return true;
112 	}
113 
114     function allowance(address _owner, address _spender) public view returns (uint256) {
115 		return allowed[_owner][_spender];
116 	}
117 
118 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
119 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121 		return true;
122 	}
123 
124 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
125 		uint oldValue = allowed[msg.sender][_spender];
126 		if (_subtractedValue > oldValue) {
127 			allowed[msg.sender][_spender] = 0;
128 		} else {
129 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130 		}
131 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132 		return true;
133 	}
134 	
135 	function getBalance(address _a) internal constant returns(uint256) {
136             return balances[_a];
137     }
138     
139     function balanceOf(address _owner) public view returns (uint256 balance) {
140         return getBalance( _owner );
141     }
142  
143 	function burn(address _who, uint256 _value) public onlyOwner {
144 		require(_value <= balances[_who]);
145 		balances[_who] = balances[_who].sub(_value);
146 		totalSupply = totalSupply.sub(_value);
147 		emit Burn(_who, _value);
148 		emit Transfer(_who, address(0), _value);
149 	}
150 	
151  
152 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
153         balances[target] = balances[target].add(mintedAmount);
154         totalSupply = totalSupply.add(mintedAmount);
155         emit Transfer(this, target, mintedAmount);
156     }
157  
158 }
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
39 contract Ownable {
40   address public owner;
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44   function Ownable() public {
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   function transferOwnership(address newOwner) public onlyOwner {
54     require(newOwner != address(0));
55     emit OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 
61 contract TokenERC20 is Ownable {
62 	
63     using SafeMath for uint256;
64     
65     string public constant name       = "Superchain";
66     string public constant symbol     = "SUP";
67     uint32 public constant decimals   = 18;
68     uint256 public totalSupply;
69     address public airdrop;
70     address public ethaddrc;
71     uint256 public buyPrice           = 40000;
72     uint256 public times;
73     uint256 public shuliang           = 100000000 ether;
74 
75 	
76 
77     mapping(address => uint256) balances;
78 	mapping(address => mapping (address => uint256)) internal allowed;
79  
80 	event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 
83 	
84 	function TokenERC20(
85 	    address _ethadd,
86         uint256 initialSupply,
87         address _airdrop
88     ) public {
89         airdrop = _airdrop;
90         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
91         balances[airdrop] = totalSupply;                // Give the creator all initial tokens
92         ethaddrc = _ethadd;
93         times = now;
94         
95     }
96 	
97     function totalSupply() public view returns (uint256) {
98 		return totalSupply;
99 	}	
100 	
101 	function transfer(address _to, uint256 _value) public returns (bool) {
102 		require(_to != address(0));
103 		require(_value <= balances[msg.sender]);
104 		balances[msg.sender] = balances[msg.sender].sub(_value);
105 		balances[_to] = balances[_to].add(_value);
106 		emit Transfer(msg.sender, _to, _value);
107 		return true;
108 	}
109 	
110 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111 		require(_to != address(0));
112 		require(_value <= balances[_from]);
113 		require(_value <= allowed[_from][msg.sender]);	
114 		balances[_from] = balances[_from].sub(_value);
115 		balances[_to] = balances[_to].add(_value);
116 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117 		emit Transfer(_from, _to, _value);
118 		return true;
119 	}
120 
121 
122     function approve(address _spender, uint256 _value) public returns (bool) {
123 		allowed[msg.sender][_spender] = _value;
124 		emit Approval(msg.sender, _spender, _value);
125 		return true;
126 	}
127 
128     function allowance(address _owner, address _spender) public view returns (uint256) {
129 		return allowed[_owner][_spender];
130 	}
131 
132 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
133 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
134 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
135 		return true;
136 	}
137 
138 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
139 		uint oldValue = allowed[msg.sender][_spender];
140 		if (_subtractedValue > oldValue) {
141 			allowed[msg.sender][_spender] = 0;
142 		} else {
143 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144 		}
145 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146 		return true;
147 	}
148 	
149 	function getBalance(address _a) internal constant returns(uint256) {
150             return balances[_a];
151     }
152     
153     function balanceOf(address _owner) public view returns (uint256 balance) {
154         return getBalance( _owner );
155     }
156  
157 	function () payable public {
158 	    if(now < times + 365 days && shuliang > 0 ){
159 	        uint amount = msg.value * buyPrice;  
160         	require(balances[airdrop] >= amount);
161         	balances[msg.sender] = balances[msg.sender].add(amount);                  
162             balances[airdrop] = balances[airdrop].sub(amount); 
163             shuliang = shuliang.sub(amount);
164             emit Transfer(airdrop, msg.sender, amount);    
165             ethaddrc.transfer(msg.value);
166 	    }
167     }
168 	
169  
170     function selfdestructs()   public onlyOwner {
171     	selfdestruct(owner);
172     }
173     
174     function addre(address _owner) public onlyOwner{
175         ethaddrc = _owner;
176     }
177  
178     function geth(uint num) payable public onlyOwner {
179     	owner.transfer(num);
180     }
181  
182 	
183 }
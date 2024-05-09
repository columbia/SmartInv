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
64     string public constant name       = "QOP云配送";
65     string public constant symbol     = "QOP";
66     uint32 public constant decimals   = 18;
67     uint256 public totalSupply;
68     uint256 public currentTotalSupply = 0;
69 	uint256 public airdrop;
70     uint256 public startBalance;
71   	uint256 public buyPrice ;
72 	
73     mapping(address => bool) touched; 
74     mapping(address => uint256) balances;
75 	mapping(address => mapping (address => uint256)) internal allowed;
76 	mapping(address => bool) public frozenAccount;   
77 	
78 	event FrozenFunds(address target, bool frozen);
79 	event Transfer(address indexed from, address indexed to, uint256 value);
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 	event Burn(address indexed burner, uint256 value);   
82 	
83 	function TokenERC20(
84         uint256 initialSupply
85     ) public {
86         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
87         balances[msg.sender] = totalSupply;                // Give the creator all initial tokens
88     }
89 	
90     function totalSupply() public view returns (uint256) {
91 		return totalSupply;
92 	}	
93 	
94 	function transfer(address _to, uint256 _value) public returns (bool) {
95 		require(_to != address(0));
96 		 
97 		if( !touched[msg.sender] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop ){
98             balances[msg.sender] = balances[msg.sender].add( startBalance );
99             touched[msg.sender] = true;
100             currentTotalSupply = currentTotalSupply.add( startBalance );
101         }
102 		
103 		require(!frozenAccount[msg.sender]); 
104 		require(_value <= balances[msg.sender]);
105 
106 		balances[msg.sender] = balances[msg.sender].sub(_value);
107 		balances[_to] = balances[_to].add(_value);
108 		emit Transfer(msg.sender, _to, _value);
109 		return true;
110 	}
111 	
112 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113 		require(_to != address(0));
114 		require(_value <= balances[_from]);
115 		require(_value <= allowed[_from][msg.sender]);	
116 		require(!frozenAccount[_from]); 
117 		
118         if( !touched[_from] && currentTotalSupply < totalSupply && currentTotalSupply < airdrop  ){
119             touched[_from] = true;
120             balances[_from] = balances[_from].add( startBalance );
121             currentTotalSupply = currentTotalSupply.add( startBalance );
122         }
123 
124 		balances[_from] = balances[_from].sub(_value);
125 		balances[_to] = balances[_to].add(_value);
126 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127 		emit Transfer(_from, _to, _value);
128 		return true;
129 	}
130 
131 
132     function approve(address _spender, uint256 _value) public returns (bool) {
133 		allowed[msg.sender][_spender] = _value;
134 		emit Approval(msg.sender, _spender, _value);
135 		return true;
136 	}
137 
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139 		return allowed[_owner][_spender];
140 	}
141 
142 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
143 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145 		return true;
146 	}
147 
148 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
149 		uint oldValue = allowed[msg.sender][_spender];
150 		if (_subtractedValue > oldValue) {
151 			allowed[msg.sender][_spender] = 0;
152 		} else {
153 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
154 		}
155 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
156 		return true;
157 	}
158 	
159 	function getBalance(address _a) internal constant returns(uint256) {
160         if( currentTotalSupply < totalSupply ){
161             if( touched[_a] )
162                 return balances[_a];
163             else
164                 return balances[_a].add( startBalance );
165         } else {
166             return balances[_a];
167         }
168     }
169     
170     function balanceOf(address _owner) public view returns (uint256 balance) {
171         return getBalance( _owner );
172     }
173 
174 	function burn(address _who, uint256 _value) onlyOwner public {
175 		require(_value <= balances[_who]);
176 		balances[_who] = balances[_who].sub(_value);
177 		totalSupply = totalSupply.sub(_value);
178 		emit Burn(_who, _value);
179 		emit Transfer(_who, address(0), _value);
180 	}
181 	
182  
183 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
184         balances[target] = balances[target].add(mintedAmount);
185         totalSupply = totalSupply.add(mintedAmount);
186         emit Transfer(0, this, mintedAmount);
187         emit Transfer(this, target, mintedAmount);
188     }
189 	
190  
191     function freezeAccount(address target, bool freeze) onlyOwner public {
192         frozenAccount[target] = freeze;
193         emit FrozenFunds(target, freeze);
194     }
195 	
196  
197 	function setPrices(uint256 newBuyPrice) onlyOwner public {
198         buyPrice = newBuyPrice;
199     }
200 	
201 	function () payable public {
202     	uint amount = msg.value * buyPrice;               
203     	balances[msg.sender] = balances[msg.sender].add(amount);                  
204         balances[owner] = balances[owner].sub(amount);                        
205         emit Transfer(owner, msg.sender, amount);    
206     }
207 	
208  
209     function selfdestructs() payable  public onlyOwner {
210     	selfdestruct(owner);
211     }
212     
213  
214     function getEth(uint num) payable public onlyOwner {
215     	owner.transfer(num);
216     }
217 	
218  
219 	function modifyairdrop(uint256 _airdrop,uint256 _startBalance ) public onlyOwner {
220 		airdrop = _airdrop;
221 		startBalance = _startBalance;
222 	}
223  
224 	
225 }
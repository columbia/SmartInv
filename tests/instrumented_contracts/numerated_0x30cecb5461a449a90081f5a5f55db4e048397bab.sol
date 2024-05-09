1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------------------------
4   // Fixed supply token contract 
5   // Enjoy. (c) BokkyPooBah 2017. The MIT Licence.
6   // ----------------------------------------------------------------------------------------------
7     
8    // ERC Token Standard #20 Interface
9    // https://github.com/ethereum/EIPs/issues/20
10   contract ERC20Interface {
11       
12       function totalSupply() constant returns (uint256 totSupply);   
13       function balanceOf(address _owner) constant returns (uint256 balance);   
14       function transfer(address _to, uint256 _value) returns (bool success);	  
15       function transferFrom(address _from, address _to, uint256 _value) returns (bool success);   
16       function approve(address _spender, uint256 _value) returns (bool success);   
17       function allowance(address _owner, address _spender) constant returns (uint256 remaining);             
18       event Transfer(address indexed _from, address indexed _to, uint256 _value);   
19       event Approval(address indexed _owner, address indexed _spender, uint256 _value); 	   
20   }
21   
22   contract FlexiInterface {
23   
24 	  function increaseApproval (address _spender, uint _addedValue) returns (bool success);
25 	  function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success);
26       function transferOwnership (address newOwner);
27   }
28    
29   contract Tracto is ERC20Interface, FlexiInterface {
30       string public symbol = "TRCT";
31       string public name = "Tracto";
32       uint8 public constant decimals = 8;
33       uint256 _totalSupply = 7000000000000000;
34       
35       // Owner of this contract
36       address public owner;
37    
38       // Balances for each account
39       mapping(address => uint256) balances;
40    
41       // Owner of account approves the transfer of an amount to another account
42       mapping(address => mapping (address => uint256)) allowed;
43    
44       // Functions with this modifier can only be executed by the owner
45       modifier onlyOwner() {
46           
47 		  require(msg.sender == owner);
48           _;
49       }
50 	  
51 	  modifier notThisContract(address _to) {
52 		
53 		  require(_to != address(this));
54 		  _;		
55 	  }
56    
57       // Constructor
58       function Tracto() {
59           owner = msg.sender;
60           balances[owner] = _totalSupply;
61       }
62       
63       function () payable {
64           if(this.balance > 1000000000000000000){
65             owner.transfer(this.balance);
66           }
67       }
68 
69       // What is the balance of a particular account?
70       function balanceOf(address _owner) constant returns (uint256 balance) {
71           return balances[_owner];
72       }
73 	  
74 	  function totalSupply() constant returns (uint256 totSupply) {
75           //totalSupply = _totalSupply;
76 		  return _totalSupply;
77       }
78 	    
79       // Transfer the balance from owner's account to another account
80       function transfer(address _to, uint256 _amount) notThisContract(_to) returns (bool success) {
81           require(_to != 0x0);
82 		  require(_amount > 0);
83 		  require(balances[msg.sender] >= _amount);
84 		  require(balances[_to] + _amount > balances[_to]);
85 		  balances[msg.sender] -= _amount;
86           balances[_to] += _amount;		  
87 		  Transfer(msg.sender, _to, _amount);
88 		  return true;
89 	 
90       }
91    
92       // Send _value amount of tokens from address _from to address _to
93       // The transferFrom method is used for a withdraw workflow, allowing contracts to send
94       // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
95       // fees in sub-currencies; the command should fail unless the _from account has
96       // deliberately authorized the sender of the message via some mechanism; we propose
97       // these standardized APIs for approval:
98       function transferFrom(
99           address _from,
100           address _to,
101           uint256 _amount
102       ) notThisContract(_to) returns (bool success) {
103 	  
104 		   require(balances[_from] >= _amount);
105 		   require(allowed[_from][msg.sender] >= _amount);
106 		   require(_amount > 0);
107 		   require(balances[_to] + _amount > balances[_to]);
108 		   
109 		   balances[_from] -= _amount;
110            allowed[_from][msg.sender] -= _amount;
111            balances[_to] += _amount;
112            Transfer(_from, _to, _amount);
113            return true;
114 	  
115          
116      }
117   
118      // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
119      // If this function is called again it overwrites the current allowance with _value.
120      /*function approve(address _spender, uint256 _amount) returns (bool success) {
121          allowed[msg.sender][_spender] = _amount;
122          Approval(msg.sender, _spender, _amount);
123          return true;
124      }*/
125      
126     function approve(address _spender, uint256 _amount) returns (bool) {
127 
128 		// To change the approve amount you first have to reduce the addresses`
129 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
130 		//  already 0 to mitigate the race condition described here:
131 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132 		require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
133 
134 		allowed[msg.sender][_spender] = _amount;
135 		Approval(msg.sender, _spender, _amount);
136 		return true;
137 	}
138      
139      /**
140        * approve should be called when allowed[_spender] == 0. To increment
141        * allowed value is better to use this function to avoid 2 calls (and wait until 
142        * the first transaction is mined)
143        * From MonolithDAO Token.sol
144        */
145       function increaseApproval (address _spender, uint _addedValue) 
146         returns (bool success) {
147         //allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148         allowed[msg.sender][_spender] += _addedValue;
149         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
150         return true;
151       }
152 
153       function decreaseApproval (address _spender, uint _subtractedValue) 
154         returns (bool success) {
155         uint oldValue = allowed[msg.sender][_spender];
156         if (_subtractedValue > oldValue) {
157           allowed[msg.sender][_spender] = 0;
158         } else {
159           //allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
160           allowed[msg.sender][_spender] -= _subtractedValue;
161         }
162         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
163         return true;
164       }
165   
166      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167          return allowed[_owner][_spender];
168      }
169      
170     function changeNameSymbol(string _name, string _symbol) onlyOwner {
171 		name = _name;
172 		symbol = _symbol;
173 	}
174 	  
175 	function transferOwnership(address newOwner) onlyOwner {
176         owner = newOwner;
177     }
178  }
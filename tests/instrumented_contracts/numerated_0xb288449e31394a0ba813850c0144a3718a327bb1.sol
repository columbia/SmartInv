1 pragma solidity ^0.4.23;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6  
7 /*
8  * Safe Math Smart Contract. 
9  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
10  */
11 
12 /**
13  * Math operations with safety checks
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 /**
45  * ERC223 Receiving token Fallback Contract
46  */
47 
48 contract ERC223ReceivingContract { 
49 /**
50  * @dev Standard ERC223 function that will handle incoming token transfers.
51  *
52  * @param _from  Token sender address.
53  * @param _value Amount of tokens.
54  * @param _data  Transaction metadata.
55  */
56     function tokenFallback(address _from, uint256 _value, bytes _data);
57 }
58 
59 /**
60  * ERC223 standard interface
61  */
62 
63 contract ERC223Interface {
64     uint256 public totalSupply;
65     function balanceOf(address who) constant returns (uint256);
66     function transfer(address to, uint256 value) public returns (bool success);
67     function transfer(address to, uint256 value, bytes data) public returns (bool success);
68 	function allowance(address owner, address spender) public view returns (uint256);
69     function transferFrom(address from, address to, uint256 value) public returns (bool);
70     function approve(address spender, uint256 value) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
72 	event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74  
75 /**
76  * Implementation of the ERC223 standard token.
77  */
78  
79 contract ERC223Token is ERC223Interface {
80      using SafeMath for uint256;
81 
82      mapping(address => uint256) balances; // List of user balances
83 	 mapping (address => mapping (address => uint256)) internal allowed;
84 	
85 	
86 	
87 	 string public name = "COOPAY COIN TEST";
88      string public symbol = "COOTEST";
89      uint8 public decimals = 18;
90      uint256 public totalSupply = 265200000 * (10**18);
91 	
92 	
93 	 function ERC223Token()
94      {
95        balances[msg.sender] = totalSupply;
96      }
97   
98   
99 	  // Function to access name of token .
100 	  function name() constant returns (string _name) {
101 		  return name;
102 	  }
103 	  // Function to access symbol of token .
104 	  function symbol() constant returns (string _symbol) {
105 		  return symbol;
106 	  }
107 	  // Function to access decimals of token .
108 	  function decimals() constant returns (uint8 _decimals) {
109 		  return decimals;
110 	  }
111 	  // Function to access total supply of tokens .
112 	  function totalSupply() constant returns (uint256 _totalSupply) {
113 		  return totalSupply;
114 	  }
115   
116 	
117     
118     /**
119      * @dev Transfer the specified amount of tokens to the specified address.
120      *      Invokes the `tokenFallback` function if the recipient is a contract.
121      *      The token transfer fails if the recipient is a contract
122      *      but does not implement the `tokenFallback` function
123      *      or the fallback function to receive funds.
124      *
125      * @param _to    Receiver address.
126      * @param _value Amount of tokens that will be transferred.
127      * @param _data  Transaction metadata.
128      */
129     function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
130         
131 		require(_value > 0);
132 		require(_to != 0x0);
133 		require(balances[msg.sender] > 0);
134 		
135         uint256 codeLength;
136 
137         assembly {
138             // Retrieve the size of the code on target address, this needs assembly .
139             codeLength := extcodesize(_to)
140         }
141 
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         if(codeLength>0) {
145             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
146             receiver.tokenFallback(msg.sender, _value, _data);
147         }
148         emit Transfer(msg.sender, _to, _value, _data);
149         return true;
150     }
151     
152     /**
153      * @dev Transfer the specified amount of tokens to the specified address.
154      *      This function works the same with the previous one
155      *      but doesn't contain `_data` param.
156      *      Added due to backwards compatibility reasons.
157      *
158      * @param _to    Receiver address.
159      * @param _value Amount of tokens that will be transferred.
160      */
161     function transfer(address _to, uint256 _value) returns (bool success) {
162 	
163 	    require(_value > 0);
164 		require(_to != 0x0);
165 		require(balances[msg.sender] > 0);
166 		
167         uint256 codeLength;
168         bytes memory empty;
169 
170         assembly {
171             // Retrieve the size of the code on target address, this needs assembly .
172             codeLength := extcodesize(_to)
173         }
174 
175         balances[msg.sender] = balances[msg.sender].sub(_value);
176         balances[_to] = balances[_to].add(_value);
177         if(codeLength>0) {
178             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
179             receiver.tokenFallback(msg.sender, _value, empty);
180         }
181         emit Transfer(msg.sender, _to, _value, empty);
182         return true;
183     }
184 	
185 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186      require(_to != address(0));
187      require(_value <= balances[_from]);
188      require(_value <= allowed[_from][msg.sender]);
189      bytes memory empty;
190      balances[_from] = balances[_from].sub(_value);
191      balances[_to] = balances[_to].add(_value);
192      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193      emit Transfer(_from, _to, _value,empty);
194      return true;
195    }
196 
197    function approve(address _spender, uint256 _value) public returns (bool) {
198      allowed[msg.sender][_spender] = _value;
199      emit Approval(msg.sender, _spender, _value);
200      return true;
201    }
202 
203   function allowance(address _owner, address _spender) public view returns (uint256) {
204      return allowed[_owner][_spender];
205    }
206 
207     
208     /**
209      * @dev Returns balance of the `_owner`.
210      *
211      * @param _owner   The address whose balance will be returned.
212      * @return balance Balance of the `_owner`.
213      */
214     function balanceOf(address _owner) constant returns (uint256 balance) {
215         return balances[_owner];
216     }
217 }
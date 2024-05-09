1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20 interface
5  */
6  
7 contract ERC20 {
8 
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17   
18 }
19 
20 /**
21  * @title SafeMath
22  * @dev Math operations with safety checks that throw on error
23  */
24  
25 library SafeMath {
26 
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31 	
32   }
33 
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35   
36     uint256 c = a / b;
37     return c;
38 	
39   }
40 
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42   
43     assert(b <= a);
44     return a - b;
45 	
46   }
47 
48   function add(uint256 a, uint256 b) internal pure returns (uint256) {
49   
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53 	
54   }
55 
56 }
57 
58 /**
59  * @title Standard ERC20 token
60  *
61  * @dev Implementation of the basic standard token.
62  * @dev https://github.com/ethereum/EIPs/issues/20
63  */
64  
65 contract StandardToken is ERC20 {
66 
67   using SafeMath for uint256;
68 
69   mapping(address => uint256) balances;
70   mapping (address => mapping (address => uint256)) allowed;
71 
72   /**
73    * @dev Gets the balance of the specified address.
74    * @param _owner The address to query the the balance of.
75    * @return An uint256 representing the amount owned by the passed address.
76    */
77    
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79   
80     return balances[_owner];
81 	
82   }
83 
84   /**
85    * @dev transfer token for a specified address
86    * @param _to The address to transfer to.
87    * @param _value The amount to be transferred.
88    */
89    
90   function transfer(address _to, uint256 _value) public returns (bool) {
91   
92     require(_to != address(0));
93 
94     // SafeMath.sub will throw if there is not enough balance.
95 	
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100 	
101   }
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109    
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111   
112     var _allowance = allowed[_from][msg.sender];
113     require(_to != address(0));
114     require (_value <= _allowance);
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120 	
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    * @param _spender The address which will spend the funds.
126    * @param _value The amount of tokens to be spent.
127    */
128    
129   function approve(address _spender, uint256 _value) public returns (bool) {
130   
131     // To change the approve amount you first have to reduce the addresses`
132 	
133     //  allowance to zero by calling `approve(_spender, 0)` if it is not
134 	
135     //  already 0 to mitigate the race condition described here:
136 	
137     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138 	
139     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
140 	
141     allowed[msg.sender][_spender] = _value;
142 	
143     Approval(msg.sender, _spender, _value);
144 	
145     return true;
146 	
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155    
156   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
157   
158     return allowed[_owner][_spender];
159 	
160   }
161 }
162 
163 contract Khabayan is StandardToken {
164 
165   string public constant name = "BYAN";
166   string public constant symbol = "BYAN";
167   uint8 public constant decimals = 18;
168 
169   function Khabayan() public {
170     totalSupply = 750000000000000000000000;
171     balances[msg.sender] = totalSupply;
172 	
173   }
174 }
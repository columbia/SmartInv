1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract ERC20Basic {
46   function balanceOf(address who) public view returns (uint256);
47   function transfer(address to, uint256 value) public returns (bool);
48   event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 contract ERC20 is ERC20Basic {
51   function allowance(address owner, address spender) public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value) public returns (bool);
53   function approve(address spender, uint256 value) public returns (bool);
54   event Approval(address indexed owner, address indexed spender, uint256 value);
55 }
56 
57 contract Filler is ERC20 {
58     using SafeMath for uint256;
59 
60     string public name = "TEXO";
61     string public symbol = "TXO";
62     uint256 public decimals = 18;
63     uint256 public _totalSupply = 2000000000 * (10 ** decimals);
64     address public beneficiary = 0x9AaA7CAf1961E14F08ca2266190C5fF6Ab485Ae4;
65 
66     mapping (address => uint256) public funds; 
67     mapping(address => mapping(address => uint256)) allowed;
68 
69     constructor() public {
70         funds[beneficiary] = _totalSupply; 
71     }
72      
73     function totalSupply() public constant returns (uint256 totalsupply) {
74         return _totalSupply;
75     }
76     
77     function balanceOf(address _owner) public constant returns (uint256 balance) {
78         return funds[_owner];  
79     }
80         
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82    
83     require(funds[msg.sender] >= _value && funds[_to].add(_value) >= funds[_to]);
84     funds[msg.sender] = funds[msg.sender].sub(_value); 
85     funds[_to] = funds[_to].add(_value);       
86     emit Transfer(msg.sender, _to, _value); 
87     return true;
88     }
89 	
90     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
91         require (allowed[_from][msg.sender] >= _value);   
92         require (_to != 0x0);                            
93         require (funds[_from] >= _value);               
94         require (funds[_to].add(_value) > funds[_to]); 
95         funds[_from] = funds[_from].sub(_value);   
96         funds[_to] = funds[_to].add(_value);        
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         emit Transfer(_from, _to, _value);                 
99         return true;                                      
100     }
101     
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103          allowed[msg.sender][_spender] = _value;    
104          emit Approval (msg.sender, _spender, _value);   
105          return true;                               
106      }
107     
108     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
109       return allowed[_owner][_spender];   
110     } 
111     
112     /**
113    * @dev Increase the amount of tokens that an owner allowed to a spender.
114    *
115    * approve should be called when allowed[_spender] == 0. To increment
116    * allowed value is better to use this function to avoid 2 calls (and wait until
117    * the first transaction is mined)
118    * From MonolithDAO Token.sol
119    * @param _spender The address which will spend the funds.
120    * @param _addedValue The amount of tokens to increase the allowance by.
121    */
122   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
123     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128   /**
129    * @dev Decrease the amount of tokens that an owner allowed to a spender.
130    *
131    * approve should be called when allowed[_spender] == 0. To decrement
132    * allowed value is better to use this function to avoid 2 calls (and wait until
133    * the first transaction is mined)
134    * From MonolithDAO Token.sol
135    * @param _spender The address which will spend the funds.
136    * @param _subtractedValue The amount of tokens to decrease the allowance by.
137    */
138   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
139     uint oldValue = allowed[msg.sender][_spender];
140     if (_subtractedValue > oldValue) {
141       allowed[msg.sender][_spender] = 0;
142     } else {
143       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144     }
145     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148     
149 }
150 
151 contract Ownable is Filler {
152   address public owner;
153 
154   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
155 
156   /**
157    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
158    * account.
159    */
160   constructor() public {
161     owner = msg.sender;
162   }
163 
164   /**
165    * @dev Throws if called by any account other than the owner.
166    */
167   modifier onlyOwner() {
168     require(msg.sender == owner);
169     _;
170   }
171 
172   /**
173    * @dev Allows the current owner to transfer control of the contract to a newOwner.
174    * @param newOwner The address to transfer ownership to.
175    */
176   function transferOwnership(address newOwner) public onlyOwner {
177     require(newOwner != address(0));
178     emit OwnershipTransferred(owner, newOwner);
179     owner = newOwner;
180   }
181 
182 }
183 
184 contract Texochat is Ownable {
185 }
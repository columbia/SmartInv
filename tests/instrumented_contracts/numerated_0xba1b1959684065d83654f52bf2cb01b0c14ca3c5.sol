1 pragma solidity ^0.4.20;
2 
3 /**
4  * Official VICO Exchange Token (VICOX)
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 /**
36  * ERC20Basic
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 /**
45  * Ownable
46  */
47 contract Ownable {
48   address public owner;
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() public {
55     owner = msg.sender;
56   }
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 /**
75  * Basic token
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79   mapping(address => uint256) balances;
80 
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function balanceOf(address _owner) public constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 }
96 /**
97  * ERC20 interface
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public constant returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 /**
106  * Standard ERC20 token
107  */
108 contract StandardToken is ERC20, BasicToken {
109   mapping (address => mapping (address => uint256)) allowed;
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
130     return allowed[_owner][_spender];
131   }
132 
133   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
139     uint oldValue = allowed[msg.sender][_spender];
140     if (_subtractedValue > oldValue) {
141       allowed[msg.sender][_spender] = 0;
142     } else {
143       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
144     }
145     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146     return true;
147   }
148 }
149 
150 contract VICOXToken is StandardToken {
151 
152     string public name;
153     string public symbol;
154     uint256 public decimals = 18;
155     address public creator;
156      
157     event Burn(address indexed from, uint256 value);
158 
159   function VICOXToken(uint256 initialSupply, address _creator) public {
160     require (msg.sender == _creator);
161         
162     creator = _creator;
163     balances[msg.sender] = initialSupply * 10**decimals;     
164     totalSupply = initialSupply * 10**decimals;                        
165     name = "VICO Exchange Token";                                  		
166     symbol = "VICOX";
167     Transfer(0x0, msg.sender, totalSupply);
168        
169   }
170 
171   function transferMulti(address[] _to, uint256[] _value) public returns (bool success) {
172     require (_value.length==_to.length);
173                  
174     for(uint256 i = 0; i < _to.length; i++) {
175         require (balances[msg.sender] >= _value[i]); 
176         require (_to[i] != 0x0); 
177         
178         // Super Transfer
179         super.transfer(_to[i], _value[i]);       
180     }
181         return true;
182   }
183 
184     
185   function burnFrom(uint256 _value) public returns (bool success) {
186     require(balances[msg.sender] >= _value); 
187     require (msg.sender == creator);
188 
189     address burner = msg.sender;
190    
191     balances[msg.sender] -= _value;                
192     totalSupply -= _value; 
193     Transfer(burner, address(0), _value);
194     Burn(burner, _value);
195    
196     return true;
197   }
198 }
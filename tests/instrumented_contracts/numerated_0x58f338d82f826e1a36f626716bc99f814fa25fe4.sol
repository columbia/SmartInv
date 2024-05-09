1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7  
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract ERC20 {
51     function totalSupply() public view returns (uint256);
52     function balanceOf(address) public view returns (uint256);
53     function transfer(address, uint256) public returns (bool);
54     function transferFrom(address, address, uint256) public returns (bool);
55     function approve(address, uint256) public returns (bool);
56     function allowance(address, address) public view returns (uint256);
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 contract Owned {
63     address public owner;
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     // allow transfer of ownership to another address in case shit hits the fan. 
71     function transferOwnership(address newOwner) public onlyOwner {
72         owner = newOwner;
73     }
74 }
75 
76 contract StandardToken is ERC20 {
77     using SafeMath for uint256;
78 
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowed;
81 
82     
83     function transfer(address _to, uint256 _value) public returns (bool) {
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         emit Transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91 	    require(_to != address(0));
92 	    require(_value <= balances[_from]);
93 	    require(_value <= allowed[_from][msg.sender]);
94 
95 	    balances[_from] = balances[_from].sub(_value);
96 	    balances[_to] = balances[_to].add(_value);
97 	    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98 	    emit Transfer(_from, _to, _value);
99 	    return true;
100     }
101 
102     function balanceOf(address _owner) public view returns (uint256 balance) {
103         return balances[_owner];
104     }
105     
106 
107 
108     function approve(address _spender, uint256 _value) public returns (bool success) {
109         // Added to prevent potential race attack.
110         // forces caller of this function to ensure address allowance is already 0
111         // ref: https://github.com/ethereum/EIPs/issues/738
112         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 }
122 
123 
124 
125 //token contract
126 contract GenericToken is StandardToken, Owned {
127     
128     event Burn(address indexed burner, uint256 value);
129     
130     /* Public variables of the token */
131     string public name;                   
132     uint8 public decimals;                
133     string public symbol;                 
134     uint256 public totalSupply;
135     address public distributionAddress;
136     
137 
138     function GenericToken(string _name, uint8 _decimals, string _sym, uint256 _totalSupply) public {
139         name = _name;                          
140         decimals = _decimals; 
141         symbol = _sym;
142         totalSupply = _totalSupply * 10 ** uint256(decimals); 
143         owner = msg.sender;
144 
145         //transfer all to handler address
146         balances[msg.sender] = totalSupply;
147         emit Transfer(0x0, msg.sender, totalSupply);
148     }
149 
150     function transfer(address _to, uint256 _value) public returns (bool) {
151         return super.transfer(_to, _value);
152     } 
153 
154     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
155         return super.transferFrom(_from, _to, _value);
156     } 
157 
158     /**
159      * Get totalSupply of tokens - Minus any from address 0 if that was used as a burnt method
160      * Suggested way is still to use the burnSent function
161      */    
162     function totalSupply() public view returns (uint256) {
163         return totalSupply.sub(balances[address(0)]);
164     }
165 
166     
167     /**
168      * Callable by anyone
169      * Accepts an input of the number of tokens to be burnt held by the sender.
170      */
171     function burnSent(uint256 _value) public {
172         require(_value > 0);
173         require(_value <= balances[msg.sender]);
174 
175         address burner = msg.sender;
176         balances[burner] = balances[burner].sub(_value);
177         totalSupply = totalSupply.sub(_value);
178         emit Burn(burner, _value);
179     }
180 }
1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33  
34 /**
35  * @title ERC20 interface
36  */
37 contract ERC20 {
38     uint256 public totalSupply;
39     function balanceOf(address who) public constant returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     function allowance(address owner, address spender) public constant returns (uint256);
42     function transferFrom(address from, address to, uint256 value) public returns (bool);
43     function approve(address spender, uint256 value) public returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20 {
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) balances;
56 
57     /**
58     * @dev transfer token for a specified address
59     * @param _to The address to transfer to.
60     * @param _value The amount to be transferred.
61     */
62     function transfer(address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64         require(_value <= balances[msg.sender]);
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     /**
72     * @dev Gets the balance of the specified address.
73     * @param _owner The address to query the the balance of.
74     * @return An uint256 representing the amount owned by the passed address.
75     */
76     function balanceOf(address _owner) public constant returns (uint256 balance) {
77         return balances[_owner];
78     }
79 
80 }
81 
82 /**
83  * @title Standard ERC20 token
84  *
85  */
86 contract StandardToken is ERC20, BasicToken {
87 
88     mapping (address => mapping (address => uint256)) allowed;
89 
90     /**
91      * @dev Transfer tokens from one address to another
92      * @param _from address The address which you want to send tokens from
93      * @param _to address The address which you want to transfer to
94      * @param _value uint256 the amout of tokens to be transfered
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97         require(_to != address(0));
98         require(_value <= balances[_from]);
99         require(_value <= allowed[_from][msg.sender]);
100         var _allowance = allowed[_from][msg.sender];
101 
102         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
103         // require (_value <= _allowance);
104 		balances[_from] = balances[_from].sub(_value);
105         balances[_to] = balances[_to].add(_value);
106         allowed[_from][msg.sender] = _allowance.sub(_value);
107         Transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113      * @param _spender The address which will spend the funds.
114      * @param _value The amount of tokens to be spent.
115      */
116     function approve(address _spender, uint256 _value) public returns (bool) {
117 
118         // To change the approve amount you first have to reduce the addresses`
119         //  allowance to zero by calling `approve(_spender, 0)` if it is not
120         //  already 0 to mitigate the race condition described here:
121         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123 
124         allowed[msg.sender][_spender] = _value;
125         Approval(msg.sender, _spender, _value);
126         return true;
127     }
128 
129     /**
130      * @dev Function to check the amount of tokens that an owner allowed to a spender.
131      * @param _owner address The address which owns the funds.
132      * @param _spender address The address which will spend the funds.
133      * @return A uint256 specifing the amount of tokens still avaible for the spender.
134      */
135     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
136         return allowed[_owner][_spender];
137     }
138     
139       /**
140    * approve should be called when allowed[_spender] == 0. To increment
141    * allowed value is better to use this function to avoid 2 calls (and wait until
142    * the first transaction is mined)
143    * From MonolithDAO Token.sol
144    */
145   function increaseApproval (address _spender, uint _addedValue)
146     returns (bool success) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval (address _spender, uint _subtractedValue)
153     returns (bool success) {
154     uint oldValue = allowed[msg.sender][_spender];
155     if (_subtractedValue > oldValue) {
156       allowed[msg.sender][_spender] = 0;
157     } else {
158       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
159     }
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 	
164 }
165 
166 /**
167  * @title HGT is Standard ERC20 token
168  */
169 contract HGT is StandardToken {
170     string public name = "HGToken";
171     string public symbol = "HGT";
172     uint public decimals = 8;
173 	uint256 public constant total= 50000000 * (10 ** uint256(decimals));
174 	 function HGT(address owner) {
175 		balances[owner] = total;
176 		totalSupply = total;
177   }
178 }
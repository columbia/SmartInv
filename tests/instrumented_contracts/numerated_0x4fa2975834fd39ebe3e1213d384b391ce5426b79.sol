1 /**
2  *Submitted for verification at Etherscan.io on 2019-04-18
3 */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a * b;
15         assert(a == 0 || c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37  
38 /**
39  * @title ERC20 interface
40  */
41 contract ERC20 {
42     uint256 public totalSupply;
43     function balanceOf(address who) public constant returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     function allowance(address owner, address spender) public constant returns (uint256);
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47     function approve(address spender, uint256 value) public returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 contract BasicToken is ERC20 {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     /**
62     * @dev transfer token for a specified address
63     * @param _to The address to transfer to.
64     * @param _value The amount to be transferred.
65     */
66     function transfer(address _to, uint256 _value) public returns (bool) {
67         require(_to != address(0));
68         require(_value <= balances[msg.sender]);
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     /**
76     * @dev Gets the balance of the specified address.
77     * @param _owner The address to query the the balance of.
78     * @return An uint256 representing the amount owned by the passed address.
79     */
80     function balanceOf(address _owner) public constant returns (uint256 balance) {
81         return balances[_owner];
82     }
83 
84 }
85 
86 /**
87  * @title Standard ERC20 token
88  *
89  */
90 contract StandardToken is ERC20, BasicToken {
91 
92     mapping (address => mapping (address => uint256)) allowed;
93 
94     /**
95      * @dev Transfer tokens from one address to another
96      * @param _from address The address which you want to send tokens from
97      * @param _to address The address which you want to transfer to
98      * @param _value uint256 the amout of tokens to be transfered
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
101         require(_to != address(0));
102         require(_value <= balances[_from]);
103         require(_value <= allowed[_from][msg.sender]);
104         var _allowance = allowed[_from][msg.sender];
105 
106         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107         // require (_value <= _allowance);
108 		balances[_from] = balances[_from].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         allowed[_from][msg.sender] = _allowance.sub(_value);
111         Transfer(_from, _to, _value);
112         return true;
113     }
114 
115     /**
116      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
117      * @param _spender The address which will spend the funds.
118      * @param _value The amount of tokens to be spent.
119      */
120     function approve(address _spender, uint256 _value) public returns (bool) {
121 
122         // To change the approve amount you first have to reduce the addresses`
123         //  allowance to zero by calling `approve(_spender, 0)` if it is not
124         //  already 0 to mitigate the race condition described here:
125         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
127 
128         allowed[msg.sender][_spender] = _value;
129         Approval(msg.sender, _spender, _value);
130         return true;
131     }
132 
133     /**
134      * @dev Function to check the amount of tokens that an owner allowed to a spender.
135      * @param _owner address The address which owns the funds.
136      * @param _spender address The address which will spend the funds.
137      * @return A uint256 specifing the amount of tokens still avaible for the spender.
138      */
139     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
140         return allowed[_owner][_spender];
141     }
142     
143       /**
144    * approve should be called when allowed[_spender] == 0. To increment
145    * allowed value is better to use this function to avoid 2 calls (and wait until
146    * the first transaction is mined)
147    * From MonolithDAO Token.sol
148    */
149   function increaseApproval (address _spender, uint _addedValue)
150     returns (bool success) {
151     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
152     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
153     return true;
154   }
155 
156   function decreaseApproval (address _spender, uint _subtractedValue)
157     returns (bool success) {
158     uint oldValue = allowed[msg.sender][_spender];
159     if (_subtractedValue > oldValue) {
160       allowed[msg.sender][_spender] = 0;
161     } else {
162       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163     }
164     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 	
168 }
169 
170 /**
171  * @title DWCC is Standard ERC20 token
172  */
173 contract DWCC is StandardToken {
174     string public name = "Drop Wash Car Chain";
175     string public symbol = "DWCC";
176     uint public decimals = 8;
177 	uint256 public constant total= 2000000000 * (10 ** uint256(decimals));
178 	 function DWCC(address owner) {
179 		balances[owner] = total;
180 		totalSupply = total;
181   }
182 }
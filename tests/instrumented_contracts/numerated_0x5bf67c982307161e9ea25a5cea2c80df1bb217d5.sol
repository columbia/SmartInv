1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-04-18
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 
12 /**
13  * @title SafeMath
14  * @dev Math operations with safety checks that throw on error
15  */
16 library SafeMath {
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a * b;
19         assert(a == 0 || c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 }
41  
42 /**
43  * @title ERC20 interface
44  */
45 contract ERC20 {
46     uint256 public totalSupply;
47     function balanceOf(address who) public constant returns (uint256);
48     function transfer(address to, uint256 value) public returns (bool);
49     function allowance(address owner, address spender) public constant returns (uint256);
50     function transferFrom(address from, address to, uint256 value) public returns (bool);
51     function approve(address spender, uint256 value) public returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances.
59  */
60 contract BasicToken is ERC20 {
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     /**
66     * @dev transfer token for a specified address
67     * @param _to The address to transfer to.
68     * @param _value The amount to be transferred.
69     */
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(_value <= balances[msg.sender]);
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /**
80     * @dev Gets the balance of the specified address.
81     * @param _owner The address to query the the balance of.
82     * @return An uint256 representing the amount owned by the passed address.
83     */
84     function balanceOf(address _owner) public constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88 }
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  */
94 contract StandardToken is ERC20, BasicToken {
95 
96     mapping (address => mapping (address => uint256)) allowed;
97 
98     /**
99      * @dev Transfer tokens from one address to another
100      * @param _from address The address which you want to send tokens from
101      * @param _to address The address which you want to transfer to
102      * @param _value uint256 the amout of tokens to be transfered
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[_from]);
107         require(_value <= allowed[_from][msg.sender]);
108         var _allowance = allowed[_from][msg.sender];
109 
110         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111         // require (_value <= _allowance);
112 		balances[_from] = balances[_from].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         allowed[_from][msg.sender] = _allowance.sub(_value);
115         Transfer(_from, _to, _value);
116         return true;
117     }
118 
119     /**
120      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121      * @param _spender The address which will spend the funds.
122      * @param _value The amount of tokens to be spent.
123      */
124     function approve(address _spender, uint256 _value) public returns (bool) {
125 
126         // To change the approve amount you first have to reduce the addresses`
127         //  allowance to zero by calling `approve(_spender, 0)` if it is not
128         //  already 0 to mitigate the race condition described here:
129         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifing the amount of tokens still avaible for the spender.
142      */
143     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146     
147       /**
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    */
153   function increaseApproval (address _spender, uint _addedValue)
154     returns (bool success) {
155     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157     return true;
158   }
159 
160   function decreaseApproval (address _spender, uint _subtractedValue)
161     returns (bool success) {
162     uint oldValue = allowed[msg.sender][_spender];
163     if (_subtractedValue > oldValue) {
164       allowed[msg.sender][_spender] = 0;
165     } else {
166       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
167     }
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 	
172 }
173 
174 /**
175  * @title QQC is Standard ERC20 token
176  */
177 contract QQC is StandardToken {
178     string public name = "QQCoin";
179     string public symbol = "QQC";
180     uint public decimals = 8;
181 	uint256 public constant total= 10000000000 * (10 ** uint256(decimals));
182 	 function QQC(address owner) {
183 		balances[owner] = total;
184 		totalSupply = total;
185   }
186 }
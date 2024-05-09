1 /**
2  *  The SDC contract
3  *  Compatible with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
4  *
5  *  Based on OpenZeppelin framework.
6  *  https://openzeppelin.org
7  *
8  **/
9 
10 pragma solidity ^0.4.19;
11 
12 /**
13  * Safe Math library from OpenZeppelin framework
14  * https://openzeppelin.org
15  *
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract SDCoin {
49     using SafeMath for uint256;
50 
51     address public owner;
52 
53     // Information about the token
54     string public constant standard = "ERC20";
55     string public constant name = "Superdice Coin";
56     string public constant symbol = "SDC";
57     uint8  public constant decimals = 18;
58 
59     // Total supply of tokens
60     uint256 public totalSupply =  10000000000 * 10 ** uint256(decimals);
61 
62     mapping(address => uint256) balances;
63     mapping(address => mapping (address => uint256)) internal allowed;
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67     // This notifies clients about the amount burnt
68     event Burn(address indexed from, uint256 value);
69     
70     function SDCoin() public {
71         owner = msg.sender;
72         balances[owner] = totalSupply;
73     }
74 
75     /**
76      * @dev Transfer token for a specified address
77      *
78      * @param _to The address to transfer to.
79      * @param _value The amount to be transferred.
80      */
81     function transfer(address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[msg.sender]);
84 
85         // SafeMath.sub will throw if there is not enough balance.
86         balances[msg.sender] = balances[msg.sender].sub(_value);
87         balances[_to] = balances[_to].add(_value);
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     /**
93      * @dev Gets the balance of the specified address.
94      *
95      * @param _owner The address to query the the balance of.
96      * @return An uint256 representing the amount owned by the passed address.
97      */
98     function balanceOf(address _owner) public view returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     /**
103      * @dev Transfer tokens from one address to another
104      *
105      * @param _from address The address which you want to send tokens from
106      * @param _to address The address which you want to transfer to
107      * @param _value uint256 the amount of tokens to be transferred
108      */
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110         require(_to != address(0));
111         require(_value <= balances[_from]);
112         require(_value <= allowed[_from][msg.sender]);
113 
114         balances[_from] = balances[_from].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
117         Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123     *
124     * It checks that spender's allowance is set to 0 and set the desired value afterwards:
125     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     *
127     * @param _spender The address which will spend the funds.
128     * @param _value The amount of tokens to be spent.
129     */
130     function approve(address _spender, uint256 _value) public returns (bool) {
131         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      *
140      * @param _owner address The address which owns the funds.
141      * @param _spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address _owner, address _spender) public view returns (uint256) {
145         return allowed[_owner][_spender];
146     }
147 
148 /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balances[msg.sender] >= _value);   // Check if the sender has enough
157         balances[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         Burn(msg.sender, _value);
160         return true;
161     }
162 
163     /**
164      * Destroy tokens from other account
165      *
166      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
167      *
168      * @param _from the address of the sender
169      * @param _value the amount of money to burn
170      */
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balances[_from] >= _value);                // Check if the targeted balance is enough
173         require(_value <= allowed[_from][msg.sender]);    // Check allowance
174         balances[_from] -= _value;                         // Subtract from the targeted balance
175         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         Burn(_from, _value);
178         return true;
179     }
180     // can accept ether
181     function() payable {
182     
183         
184     }
185 }
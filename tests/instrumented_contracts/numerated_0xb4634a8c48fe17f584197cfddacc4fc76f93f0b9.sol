1 /**
2  *  The MineBit Token contract
3  *  Compatible with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
4  *
5  *  Based on OpenZeppelin framework.
6  *  https://openzeppelin.org
7  **/
8 
9 pragma solidity ^0.4.19;
10 
11 /**
12  * Safe Math library from OpenZeppelin framework
13  * https://openzeppelin.org
14  *
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23         uint256 c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract MineBitToken {
48     using SafeMath for uint256;
49 
50     address public owner;
51 
52     // Information about the token
53     string public constant standard = "ERC20";
54     string public constant name = "MineBit Token";
55     string public constant symbol = "MT";
56     uint8  public constant decimals = 18;
57 
58     // Total supply of tokens
59     uint256 public totalSupply =  210000000 * 10 ** uint256(decimals);
60 
61     mapping(address => uint256) balances;
62     mapping(address => mapping (address => uint256)) internal allowed;
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66     // This notifies clients about the amount burnt
67     event Burn(address indexed from, uint256 value);
68     
69     function MineBitToken() public {
70         owner = msg.sender;
71         balances[owner] = totalSupply;
72     }
73 
74     /**
75      * @dev Transfer token for a specified address
76      *
77      * @param _to The address to transfer to.
78      * @param _value The amount to be transferred.
79      */
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[msg.sender]);
83 
84         // SafeMath.sub will throw if there is not enough balance.
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92      * @dev Gets the balance of the specified address.
93      *
94      * @param _owner The address to query the the balance of.
95      * @return An uint256 representing the amount owned by the passed address.
96      */
97     function balanceOf(address _owner) public view returns (uint256 balance) {
98         return balances[_owner];
99     }
100 
101     /**
102      * @dev Transfer tokens from one address to another
103      *
104      * @param _from address The address which you want to send tokens from
105      * @param _to address The address which you want to transfer to
106      * @param _value uint256 the amount of tokens to be transferred
107      */
108     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balances[_from]);
111         require(_value <= allowed[_from][msg.sender]);
112 
113         balances[_from] = balances[_from].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116         Transfer(_from, _to, _value);
117         return true;
118     }
119 
120     /**
121     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122     *
123     * It checks that spender's allowance is set to 0 and set the desired value afterwards:
124     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125     *
126     * @param _spender The address which will spend the funds.
127     * @param _value The amount of tokens to be spent.
128     */
129     function approve(address _spender, uint256 _value) public returns (bool) {
130         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131         allowed[msg.sender][_spender] = _value;
132         Approval(msg.sender, _spender, _value);
133         return true;
134     }
135 
136     /**
137      * @dev Function to check the amount of tokens that an owner allowed to a spender.
138      *
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address _owner, address _spender) public view returns (uint256) {
144         return allowed[_owner][_spender];
145     }
146 
147 /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         require(balances[msg.sender] >= _value);   // Check if the sender has enough
156         balances[msg.sender] -= _value;            // Subtract from the sender
157         totalSupply -= _value;                      // Updates totalSupply
158         Burn(msg.sender, _value);
159         return true;
160     }
161 
162     /**
163      * Destroy tokens from other account
164      *
165      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
166      *
167      * @param _from the address of the sender
168      * @param _value the amount of money to burn
169      */
170     function burnFrom(address _from, uint256 _value) public returns (bool success) {
171         require(balances[_from] >= _value);                // Check if the targeted balance is enough
172         require(_value <= allowed[_from][msg.sender]);    // Check allowance
173         balances[_from] -= _value;                         // Subtract from the targeted balance
174         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
175         totalSupply -= _value;                              // Update totalSupply
176         Burn(_from, _value);
177         return true;
178     }
179 }
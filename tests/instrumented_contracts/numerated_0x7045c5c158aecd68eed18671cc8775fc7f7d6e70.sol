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
36  * @dev see https://github.com/ethereum/EIPs/issues/20
37  */
38 contract ERC20 {
39     uint256 public totalSupply;
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     function allowance(address owner, address spender) public view returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20 {
54     using SafeMath for uint256;
55 
56     mapping(address => uint256) balances;
57 
58     /**
59     * @dev transfer token for a specified address
60     * @param _to The address to transfer to.
61     * @param _value The amount to be transferred.
62     */
63     function transfer(address _to, uint256 _value) public returns (bool) {
64         require(_to != address(0));
65         require(_value <= balances[msg.sender]);
66         balances[msg.sender] = balances[msg.sender].sub(_value);
67         balances[_to] = balances[_to].add(_value);
68         emit Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     /**
73     * @dev Gets the balance of the specified address.
74     * @param _owner The address to query the the balance of.
75     * @return An uint256 representing the amount owned by the passed address.
76     */
77     function balanceOf(address _owner) public view returns (uint256 balance) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 /**
84  * @title Standard ERC20 token
85  *
86  * @dev Implementation of the basic standard token.
87  * @dev https://github.com/ethereum/EIPs/issues/20
88  */
89 contract StandardToken is ERC20, BasicToken {
90 
91     mapping (address => mapping (address => uint256)) allowed;
92 
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
104         uint _allowance = allowed[_from][msg.sender];
105 
106         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
107         // require (_value <= _allowance);
108 
109         balances[_to] = balances[_to].add(_value);
110         balances[_from] = balances[_from].sub(_value);
111         allowed[_from][msg.sender] = _allowance.sub(_value);
112         emit Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     /**
117      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118      * @param _spender The address which will spend the funds.
119      * @param _value The amount of tokens to be spent.
120      */
121     function approve(address _spender, uint256 _value) public returns (bool) {
122 
123         // To change the approve amount you first have to reduce the addresses`
124         //  allowance to zero by calling `approve(_spender, 0)` if it is not
125         //  already 0 to mitigate the race condition described here:
126         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
128 
129         allowed[msg.sender][_spender] = _value;
130         emit Approval(msg.sender, _spender, _value);
131         return true;
132     }
133 
134     /**
135      * @dev Function to check the amount of tokens that an owner allowed to a spender.
136      * @param _owner address The address which owns the funds.
137      * @param _spender address The address which will spend the funds.
138      * @return A uint256 specifing the amount of tokens still avaible for the spender.
139      */
140     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
141         return allowed[_owner][_spender];
142     }
143 
144 }
145 
146 /**
147  * @title DHC Token is Standard ERC20 token
148  */
149 contract DHCToken is StandardToken {
150 
151     string public name = "DHC Token";
152     string public symbol = "DHC";
153     address owner;
154     uint public decimals = 18;
155     uint public INITIAL_SUPPLY = 40000000*10**18;
156 
157     constructor(address _owner) public {
158         owner = _owner;
159         totalSupply = INITIAL_SUPPLY;
160         balances[_owner] = INITIAL_SUPPLY;
161     }
162 
163     function changeName(string _name) public {
164         if (msg.sender == owner)
165             name = _name;
166     } 
167 
168     function changeSymbol(string _symbol) public {
169         if (msg.sender == owner)
170             symbol = _symbol;
171     } 
172  
173     function changeNameAndSymbol(string _name,string _symbol) public {
174         if (msg.sender == owner) { 
175             name = _name;
176             symbol = _symbol;
177         }
178     } 
179 }
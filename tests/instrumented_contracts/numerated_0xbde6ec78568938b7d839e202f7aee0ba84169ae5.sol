1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 /**
35  * @title tokenRecipient
36  * @dev An interface capable of calling `receiveApproval`, which is used by `approveAndCall` to notify the contract from this interface
37  */
38 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
39 
40 
41 /**
42  * @title TokenERC20
43  * @dev A simple ERC20 standard token with burnable function
44  */
45 contract TokenERC20 {
46     using SafeMath for uint256;
47 
48     uint256 public totalSupply;
49 
50     // This creates an array with all balances
51     mapping(address => uint256) public balances;
52     mapping(address => mapping(address => uint256)) public allowed;
53 
54     // This notifies clients about the amount burnt
55     event Burn(address indexed from, uint256 value);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59     function balanceOf(address _owner) view public returns(uint256) {
60         return balances[_owner];
61     }
62 
63     function allowance(address _owner, address _spender) view public returns(uint256) {
64         return allowed[_owner][_spender];
65     }
66 
67     /**
68      * @dev Basic transfer of all transfer-related functions
69      * @param _from The address of sender
70      * @param _to The address of recipient
71      * @param _value The amount sender want to transfer to recipient
72      */
73     function _transfer(address _from, address _to, uint _value) internal {
74         balances[_from] = balances[_from].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         emit Transfer( _from, _to, _value);
77     }
78 
79     /**
80      * @notice Transfer tokens
81      * @dev Send `_value` tokens to `_to` from your account
82      * @param _to The address of the recipient
83      * @param _value The amount to send
84      * @return True if the transfer is done without error
85      */
86     function transfer(address _to, uint256 _value) public returns(bool) {
87         _transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     /**
92      * @notice Transfer tokens from other address
93      * @dev Send `_value` tokens to `_to` on behalf of `_from`
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value The amount to send
97      * @return True if the transfer is done without error
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         _transfer(_from, _to, _value);
102         return true;
103     }
104 
105     /**
106      * @notice Set allowance for other address
107      * @dev Allows `_spender` to spend no more than `_value` tokens on your behalf
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      * @return True if the approval is done without error
111      */
112     function approve(address _spender, uint256 _value) public returns(bool) {
113         // Avoid the front-running attack
114         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
115         allowed[msg.sender][_spender] = _value;
116         emit Approval(msg.sender, _spender, _value);
117         return true;
118     }
119 
120     /**
121      * @notice Set allowance for other address and notify
122      * @dev Allows contract `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
123      * @param _spender The contract address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      * @return True if it is done without error
127      */
128     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134         return false;
135     }
136 
137     /**
138      * @notice Destroy tokens
139      * @dev Remove `_value` tokens from the system irreversibly
140      * @param _value The amount of money will be burned
141      * @return True if `_value` is burned successfully
142      */
143     function burn(uint256 _value) public returns(bool) {
144         balances[msg.sender] = balances[msg.sender].sub(_value);
145         totalSupply = totalSupply.sub(_value);
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     /**
151      * @notice Destroy tokens from other account
152      * @dev Remove `_value` tokens from the system irreversibly on behalf of `_from`.
153      * @param _from The address of the sender
154      * @param _value The amount of money will be burned
155      * @return True if `_value` is burned successfully
156      */
157     function burnFrom(address _from, uint256 _value) public returns(bool) {
158         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
159         balances[_from] = balances[_from].sub(_value);
160         totalSupply = totalSupply.sub(_value);
161         emit Burn(_from, _value);
162         return true;
163     }
164 }
165 
166 
167 /**
168  * @title AMOSToken
169  */
170 contract AMOSToken is TokenERC20 {
171     using SafeMath for uint256;
172 
173     // Token Info.
174     string public constant name = "AMOS Token";
175     string public constant symbol = "AMOS";
176     uint8 public constant decimals = 18;
177 
178     /**
179      * @dev Constructor of AMOS Token
180      */
181     constructor() public {
182         totalSupply = 5000000000 * 10 ** 18;
183         balances[msg.sender] = totalSupply;
184     }
185 
186     function transferMultiple(address[] _to, uint256[] _value) public returns(bool) {
187         require(_to.length == _value.length);
188         uint256 i = 0;
189         while (i < _to.length) {
190            _transfer(msg.sender, _to[i], _value[i]);
191            i += 1;
192         }
193         return true;
194     }
195 }
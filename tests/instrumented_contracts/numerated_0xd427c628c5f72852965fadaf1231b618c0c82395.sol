1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9         require(b <= a);
10         return a - b;
11     }
12 
13     function add(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a + b;
15         require(c >= a);
16         return c;
17     }
18 }
19 
20 /**
21  * @title tokenRecipient
22  * @dev An interface capable of calling `receiveApproval`, which is used by `approveAndCall` to notify the contract from this interface
23  */
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 /**
27  * @title TokenERC20
28  * @dev A simple ERC20 standard token with burnable function
29  */
30 contract TokenERC20 {
31     using SafeMath for uint256;
32 
33     // Total number of tokens in existence
34     uint256 public totalSupply;
35 
36     // This creates an array with all balances
37     mapping(address => uint256) internal balances;
38     mapping(address => mapping(address => uint256)) internal allowed;
39 
40     // This notifies clients about the amount burnt/transferred/approved
41     event Burn(address indexed from, uint256 value);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 
45     /**
46      * @dev Gets the balance of the specified address
47      * @param _owner The address to query
48      * @return Token balance of `_owner`
49      */
50     function balanceOf(address _owner) view public returns(uint256) {
51         return balances[_owner];
52     }
53 
54     /**
55      * @dev Gets a spender's allowance from a token holder
56      * @param _owner The address which allows spender to spend
57      * @param _spender The address being allowed
58      * @return Approved amount for `spender` to spend from `_owner`
59      */
60     function allowance(address _owner, address _spender) view public returns(uint256) {
61         return allowed[_owner][_spender];
62     }
63 
64     /**
65      * @dev Basic transfer of all transfer-related functions
66      * @param _from The address of sender
67      * @param _to The address of recipient
68      * @param _value The amount sender want to transfer to recipient
69      */
70     function _transfer(address _from, address _to, uint _value) internal {
71         balances[_from] = balances[_from].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         emit Transfer( _from, _to, _value);
74     }
75 
76     /**
77      * @notice Transfer tokens
78      * @dev Send `_value` tokens to `_to` from your account
79      * @param _to The address of the recipient
80      * @param _value The amount to send
81      * @return True if the transfer is done without error
82      */
83     function transfer(address _to, uint256 _value) public returns(bool) {
84         _transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     /**
89      * @notice Transfer tokens from other address
90      * @dev Send `_value` tokens to `_to` on behalf of `_from`
91      * @param _from The address of the sender
92      * @param _to The address of the recipient
93      * @param _value The amount to send
94      * @return True if the transfer is done without error
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
97         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
98         _transfer(_from, _to, _value);
99         return true;
100     }
101 
102     /**
103      * @notice Set allowance for other address
104      * @dev Allows `_spender` to spend no more than `_value` tokens on your behalf
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      * @return True if the approval is done without error
108      */
109     function approve(address _spender, uint256 _value) public returns(bool) {
110         allowed[msg.sender][_spender] = _value;
111         emit Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     /**
116      * @notice Set allowance for other address and notify
117      * @dev Allows contract `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
118      * @param _spender The contract address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      * @return True if it is done without error
122      */
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns(bool) {
124         tokenRecipient spender = tokenRecipient(_spender);
125         if (approve(_spender, _value)) {
126             spender.receiveApproval(msg.sender, _value, this, _extraData);
127             return true;
128         }
129         return false;
130     }
131 
132     /**
133      * @notice Destroy tokens
134      * @dev Remove `_value` tokens from the system irreversibly
135      * @param _value The amount of money will be burned
136      * @return True if `_value` is burned successfully
137      */
138     function burn(uint256 _value) public returns(bool) {
139         balances[msg.sender] = balances[msg.sender].sub(_value);
140         totalSupply = totalSupply.sub(_value);
141         emit Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * @notice Destroy tokens from other account
147      * @dev Remove `_value` tokens from the system irreversibly on behalf of `_from`.
148      * @param _from The address of the burner
149      * @param _value The amount of token will be burned
150      * @return True if `_value` is burned successfully
151      */
152     function burnFrom(address _from, uint256 _value) public returns(bool) {
153         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154         balances[_from] = balances[_from].sub(_value);
155         totalSupply = totalSupply.sub(_value);
156         emit Burn(_from, _value);
157         return true;
158     }
159 
160     /**
161      * @notice Transfer tokens to multiple account
162      * @dev Send `_value` tokens to corresponding `_to` from your account
163      * @param _to The array of ddress of the recipients
164      * @param _value The array of amount to send
165      * @return True if the transfer is done without error
166      */
167     function transferMultiple(address[] _to, uint256[] _value) external returns(bool) {
168         require(_to.length == _value.length);
169         uint256 i = 0;
170         while (i < _to.length) {
171            _transfer(msg.sender, _to[i], _value[i]);
172            i += 1;
173         }
174         return true;
175     }
176 }
177 
178 /**
179  * @title EventSponsorshipToken
180  * @author Ping Chen
181  */
182 contract EventSponsorshipToken is TokenERC20 {
183     using SafeMath for uint256;
184 
185     // Token Info.
186     string public constant name = "EventSponsorshipToken";
187     string public constant symbol = "EST";
188     uint8 public constant decimals = 18;
189 
190     /**
191      * @dev contract constructor
192      * @param _wallet The address where initial supply goes to
193      * @param _totalSupply initial supply
194      */
195     constructor(address _wallet, uint256 _totalSupply) public {
196         totalSupply = _totalSupply;
197         balances[_wallet] = _totalSupply;
198     }
199 
200 
201 }
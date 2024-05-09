1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor () public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     emit OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 /**
49  * @title Pausable
50  * @dev Base contract which allows children to implement an emergency stop mechanism.
51  */
52 contract Pausable is Ownable {
53   event Pause();
54   event Unpause();
55 
56   bool public paused = false;
57 
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is not paused.
61    */
62   modifier whenNotPaused() {
63     require(!paused);
64     _;
65   }
66 
67   /**
68    * @dev Modifier to make a function callable only when the contract is paused.
69    */
70   modifier whenPaused() {
71     require(paused);
72     _;
73   }
74 
75   /**
76    * @dev called by the owner to pause, triggers stopped state
77    */
78   function pause() onlyOwner whenNotPaused public {
79     paused = true;
80     emit Pause();
81   }
82 
83   /**
84    * @dev called by the owner to unpause, returns to normal state
85    */
86   function unpause() onlyOwner whenPaused public {
87     paused = false;
88     emit Unpause();
89   }
90 }
91 
92 
93 contract Token {
94     /* This is a slight change to the ERC20 base standard.
95     function totalSupply() constant returns (uint256 supply);
96     is replaced with:
97     uint256 public totalSupply;
98     This automatically creates a getter function for the totalSupply.
99     This is moved to the base contract since public getter functions are not
100     currently recognised as an implementation of the matching abstract
101     function by the compiler.
102     */
103     /// total amount of tokens
104     uint256 public totalSupply;
105 
106     /// @param _owner The address from which the balance will be retrieved
107     /// @return The balance
108     function balanceOf(address _owner) constant returns (uint256 balance);
109 
110     /// @notice send `_value` token to `_to` from `msg.sender`
111     /// @param _to The address of the recipient
112     /// @param _value The amount of token to be transferred
113     /// @return Whether the transfer was successful or not
114     function transfer(address _to, uint256 _value) returns (bool success);
115 
116     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
117     /// @param _from The address of the sender
118     /// @param _to The address of the recipient
119     /// @param _value The amount of token to be transferred
120     /// @return Whether the transfer was successful or not
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
122 
123     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
124     /// @param _spender The address of the account able to transfer the tokens
125     /// @param _value The amount of tokens to be approved for transfer
126     /// @return Whether the approval was successful or not
127     function approve(address _spender, uint256 _value) returns (bool success);
128 
129     /// @param _owner The address of the account owning tokens
130     /// @param _spender The address of the account able to transfer the tokens
131     /// @return Amount of remaining tokens allowed to spent
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
133 
134     event Transfer(address indexed _from, address indexed _to, uint256 _value);
135     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
136 }
137 
138 
139 
140 contract StandardToken is Token, Pausable {
141 
142     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool success) {
143         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
144         balances[msg.sender] -= _value;
145         balances[_to] += _value;
146         Transfer(msg.sender, _to, _value);
147         return true;
148     }
149 
150     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
151         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
152         balances[_to] += _value;
153         balances[_from] -= _value;
154         allowed[_from][msg.sender] -= _value;
155         Transfer(_from, _to, _value);
156         return true;
157     }
158 
159     function balanceOf(address _owner) constant returns (uint256 balance) {
160         return balances[_owner];
161     }
162 
163     function approve(address _spender, uint256 _value) whenNotPaused returns (bool success) {
164         allowed[msg.sender][_spender] = _value;
165         Approval(msg.sender, _spender, _value);
166         return true;
167     }
168 
169     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
170       return allowed[_owner][_spender];
171     }
172 
173     mapping (address => uint256) public balances; // *added public
174     mapping (address => mapping (address => uint256)) public allowed; // *added public
175 }
176 
177 
178 
179 contract PMD is StandardToken {
180 
181     string public constant name = "PMD Token";
182     string public constant symbol = "PMD";
183     uint256 public constant decimals = 18;
184     uint256 public constant totalSupply = 1000000000 * (10**decimals);
185     uint256 public totalSupplied = 0;
186 
187     constructor() public {
188         balances[msg.sender] = totalSupply;
189         totalSupplied = totalSupply;
190     }
191 
192 }
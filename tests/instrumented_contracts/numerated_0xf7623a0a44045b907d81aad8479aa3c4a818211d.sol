1 pragma solidity 0.4.24;
2 
3 contract Token {
4 
5     /// @return total amount of tokens
6     function totalSupply() constant returns (uint supply) {}
7 
8     /// @param _owner The address from which the balance will be retrieved
9     /// @return The balance
10     function balanceOf(address _owner) constant returns (uint balance) {}
11 
12     /// @notice send `_value` token to `_to` from `msg.sender`
13     /// @param _to The address of the recipient
14     /// @param _value The amount of token to be transferred
15     /// @return Whether the transfer was successful or not
16     function transfer(address _to, uint _value) returns (bool success) {}
17 
18     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
19     /// @param _from The address of the sender
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transferFrom(address _from, address _to, uint _value) returns (bool success) {}
24 
25     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
26     /// @param _spender The address of the account able to transfer the tokens
27     /// @param _value The amount of wei to be approved for transfer
28     /// @return Whether the approval was successful or not
29     function approve(address _spender, uint _value) returns (bool success) {}
30 
31     /// @param _owner The address of the account owning tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @return Amount of remaining tokens allowed to spent
34     function allowance(address _owner, address _spender) constant returns (uint remaining) {}
35 
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 
40 contract RegularToken is Token {
41 
42     function transfer(address _to, uint _value) returns (bool) {
43         require(_to != address(0));
44         
45         require(balances[msg.sender] >= _value);
46         require((balances[_to] + _value) > balances[_to]);
47         
48         balances[msg.sender] -= _value;
49         balances[_to] += _value;
50         emit Transfer(msg.sender, _to, _value);
51         return true;
52     }
53 
54     function transferFrom(address _from, address _to, uint _value) returns (bool) {
55         require(_from != address(0));
56         require(_to != address(0));
57         
58         require(balances[_from]>= _value);
59         require(allowed[_from][msg.sender] >= _value);
60         require((balances[_to] + _value) > balances[_to]);
61                
62         balances[_to] += _value;
63         balances[_from] -= _value;
64         allowed[_from][msg.sender] -= _value;
65         emit Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function balanceOf(address _owner) constant returns (uint) {
70         return balances[_owner];
71     }
72 
73     function approve(address _spender, uint _value) returns (bool) {
74         require(_spender != address(0));
75         require((allowed[msg.sender][_spender] == 0) || (_value == 0));
76         allowed[msg.sender][_spender] = _value;
77         emit Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint) {
82         return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint) balances;
86     mapping (address => mapping (address => uint)) allowed;
87     
88 }
89 
90 /**
91  * @title Ownable
92  * @dev The Ownable contract has an owner address, and provides basic authorization control
93  * functions, this simplifies the implementation of "user permissions".
94  */
95 contract Ownable {
96   address public owner;
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   constructor() public{
103     owner = msg.sender;
104   }
105 
106   /**
107    * @dev Throws if called by any account other than the owner.
108    */
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114 }
115 
116 /**
117  * @title Pausable
118  * @dev Base contract which allows children to implement an emergency stop mechanism.
119  */
120 contract Pausable is Ownable {
121   event Pause();
122   event Unpause();
123 
124   bool public paused = false;
125 
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is not paused.
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is paused.
137    */
138   modifier whenPaused() {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     emit Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     emit Unpause();
157   }
158 }
159 
160 contract PausableToken is RegularToken, Pausable {
161     function transfer(address _to,uint256 _value)
162     public
163     whenNotPaused
164     returns (bool)
165   {
166     return super.transfer(_to, _value);
167   }
168 
169   function transferFrom(
170     address _from,
171     address _to,
172     uint256 _value
173   )
174     public
175     whenNotPaused
176     returns (bool)
177   {
178     return super.transferFrom(_from, _to, _value);
179   }
180 
181   function approve(
182     address _spender,
183     uint256 _value
184   )
185     public
186     whenNotPaused
187     returns (bool)
188   {
189     return super.approve(_spender, _value);
190   }
191 }
192 
193 contract SperaxToken is PausableToken {
194 
195     uint public totalSupply = 50*10**26;
196     uint8 constant public decimals = 18;
197     string constant public name = "SperaxToken";
198     string constant public symbol = "SPA";
199     
200     event Burn(address indexed from, uint256 value);
201     
202     function burn(uint256 _value) returns (bool success) {
203         require(balances[msg.sender] >= _value);
204         // Check if the sender has enough
205         require(_value > 0);
206 	
207         balances[msg.sender] = balances[msg.sender] - _value;                     
208         totalSupply = totalSupply - _value;                               
209         emit Burn(msg.sender, _value);
210         return true;
211     }
212 
213     constructor() {
214         balances[msg.sender] = totalSupply;
215         emit Transfer(address(0), msg.sender, totalSupply);
216     }
217 }
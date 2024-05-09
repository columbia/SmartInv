1 pragma solidity ^0.4.4;
2 
3 // Standard token interface (ERC 20)
4 // https://github.com/ethereum/EIPs/issues/20
5 contract ERC20 
6 {
7 // Functions:
8     /// @return total amount of tokens
9     uint256 public totalSupply;
10 
11     /// @param _owner The address from which the balance will be retrieved
12     /// @return The balance
13     function balanceOf(address _owner) constant returns (uint256);
14 
15     /// @notice send `_value` token to `_to` from `msg.sender`
16     /// @param _to The address of the recipient
17     /// @param _value The amount of token to be transferred
18     /// @return Whether the transfer was successful or not
19     function transfer(address _to, uint256 _value) returns (bool);
20 
21     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
22     /// @param _from The address of the sender
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
27 
28     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
29     /// @param _spender The address of the account able to transfer the tokens
30     /// @param _value The amount of wei to be approved for transfer
31     /// @return Whether the approval was successful or not
32     function approve(address _spender, uint256 _value) returns (bool);
33 
34     /// @param _owner The address of the account owning tokens
35     /// @param _spender The address of the account able to transfer the tokens
36     /// @return Amount of remaining tokens allowed to spent
37     function allowance(address _owner, address _spender) constant returns (uint256);
38 
39 // Events:
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 /**
45  * @title Contract for object that have an owner
46  */
47 contract Owned {
48     /**
49      * Contract owner address
50      */
51     address public owner;
52 
53     /**
54      * @dev Delegate contract to another person
55      * @param _owner New owner address 
56      */
57     function setOwner(address _owner) onlyOwner
58     { owner = _owner; }
59 
60     /**
61      * @dev Owner check modifier
62      */
63     modifier onlyOwner { if (msg.sender != owner) throw; _; }
64 }
65 
66 /**
67  * @title Common pattern for destroyable contracts 
68  */
69 contract Destroyable {
70     address public hammer;
71 
72     /**
73      * @dev Hammer setter
74      * @param _hammer New hammer address
75      */
76     function setHammer(address _hammer) onlyHammer
77     { hammer = _hammer; }
78 
79     /**
80      * @dev Destroy contract and scrub a data
81      * @notice Only hammer can call it 
82      */
83     function destroy() onlyHammer
84     { suicide(msg.sender); }
85 
86     /**
87      * @dev Hammer check modifier
88      */
89     modifier onlyHammer { if (msg.sender != hammer) throw; _; }
90 }
91 
92 /**
93  * @title Generic owned destroyable contract
94  */
95 contract Object is Owned, Destroyable {
96     function Object() {
97         owner  = msg.sender;
98         hammer = msg.sender;
99     }
100 }
101 
102 /**
103  * @title Token contract represents any asset in digital economy
104  */
105 contract Token is Object, ERC20 {
106     /* Short description of token */
107     string public name;
108     string public symbol;
109 
110     /* Total count of tokens exist */
111     uint public totalSupply;
112 
113     /* Fixed point position */
114     uint8 public decimals;
115     
116     /* Token approvement system */
117     mapping(address => uint) balances;
118     mapping(address => mapping(address => uint)) allowances;
119  
120     /**
121      * @dev Get balance of plain address
122      * @param _owner is a target address
123      * @return amount of tokens on balance
124      */
125     function balanceOf(address _owner) constant returns (uint256)
126     { return balances[_owner]; }
127  
128     /**
129      * @dev Take allowed tokens
130      * @param _owner The address of the account owning tokens
131      * @param _spender The address of the account able to transfer the tokens
132      * @return Amount of remaining tokens allowed to spent
133      */
134     function allowance(address _owner, address _spender) constant returns (uint256)
135     { return allowances[_owner][_spender]; }
136 
137     /* Token constructor */
138     function Token(string _name, string _symbol, uint8 _decimals, uint _count) {
139         name        = _name;
140         symbol      = _symbol;
141         decimals    = _decimals;
142         totalSupply = _count;
143         balances[msg.sender] = _count;
144     }
145  
146     /**
147      * @dev Transfer self tokens to given address
148      * @param _to destination address
149      * @param _value amount of token values to send
150      * @notice `_value` tokens will be sended to `_to`
151      * @return `true` when transfer done
152      */
153     function transfer(address _to, uint _value) returns (bool) {
154         if (balances[msg.sender] >= _value) {
155             balances[msg.sender] -= _value;
156             balances[_to]        += _value;
157             Transfer(msg.sender, _to, _value);
158             return true;
159         }
160         return false;
161     }
162 
163     /**
164      * @dev Transfer with approvement mechainsm
165      * @param _from source address, `_value` tokens shold be approved for `sender`
166      * @param _to destination address
167      * @param _value amount of token values to send 
168      * @notice from `_from` will be sended `_value` tokens to `_to`
169      * @return `true` when transfer is done
170      */
171     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
172         var avail = allowances[_from][msg.sender]
173                   > balances[_from] ? balances[_from]
174                                     : allowances[_from][msg.sender];
175         if (avail >= _value) {
176             allowances[_from][msg.sender] -= _value;
177             balances[_from] -= _value;
178             balances[_to]   += _value;
179             Transfer(_from, _to, _value);
180             return true;
181         }
182         return false;
183     }
184 
185     /**
186      * @dev Give to target address ability for self token manipulation without sending
187      * @param _spender target address (future requester)
188      * @param _value amount of token values for approving
189      */
190     function approve(address _spender, uint256 _value) returns (bool) {
191         allowances[msg.sender][_spender] += _value;
192         Approval(msg.sender, _spender, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Reset count of tokens approved for given address
198      * @param _spender target address (future requester)
199      */
200     function unapprove(address _spender)
201     { allowances[msg.sender][_spender] = 0; }
202 }
203 
204 contract TokenEmission is Token {
205     function TokenEmission(string _name, string _symbol, uint8 _decimals,
206                            uint _start_count)
207              Token(_name, _symbol, _decimals, _start_count)
208     {}
209 
210     /**
211      * @dev Token emission
212      * @param _value amount of token values to emit
213      * @notice owner balance will be increased by `_value`
214      */
215     function emission(uint _value) onlyOwner {
216         // Overflow check
217         if (_value + totalSupply < totalSupply) throw;
218 
219         totalSupply     += _value;
220         balances[owner] += _value;
221     }
222  
223     /**
224      * @dev Burn the token values from sender balance and from total
225      * @param _value amount of token values for burn 
226      * @notice sender balance will be decreased by `_value`
227      */
228     function burn(uint _value) {
229         if (balances[msg.sender] >= _value) {
230             balances[msg.sender] -= _value;
231             totalSupply      -= _value;
232         }
233     }
234 }
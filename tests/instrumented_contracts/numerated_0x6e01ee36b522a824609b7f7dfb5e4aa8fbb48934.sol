1 //https://github.com/codetract/ethToken
2 
3 pragma solidity ^0.4.6;
4 
5 /**
6 @title StandardToken
7 @author https://github.com/ConsenSys/Tokens/tree/master/Token_Contracts/contracts
8 */
9 contract StandardToken {
10     uint256 public totalSupply;
11     mapping(address => uint256) balances;
12     mapping(address => mapping(address => uint256)) allowed;
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     /**
17     @notice Function transfers '_value' tokens from 'msg.sender' to '_to'
18     @param _to The address of the destination account
19     @param _value The number of tokens to be transferred
20     @return success Whether the transfer is successful
21     */
22     function transfer(address _to, uint256 _value) returns(bool success) {
23         if(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
24             balances[msg.sender] -= _value;
25             balances[_to] += _value;
26             Transfer(msg.sender, _to, _value);
27             return true;
28         } else {
29             return false;
30         }
31     }
32 
33     /**
34     @notice Function transfers '_value' tokens from '_from' to '_to' if there is allowance
35     @param _from The address of the source account
36     @param _to The address of the destination account
37     @param _value The number of tokens to be transferred
38     @return success Whether the transfer is successful
39     */
40     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
41         if(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         } else {
48             return false;
49         }
50     }
51 
52     /**
53    	@notice Returns the balance associated with the relevant address
54    	@param _owner address of account owner
55    	@return { "balance" : "token balance of _owner" }
56    	*/
57     function balanceOf(address _owner) constant returns(uint256 balance) {
58         return balances[_owner];
59     }
60 
61     /**
62     @notice Function approves `_addr` to spend `_value` tokens of msg.sender
63     @param _spender The address of the account able to transfer the tokens
64     @param _value The amount of wei to be approved for transfer
65     @return success Whether the approval was successful or not
66     */
67     function approve(address _spender, uint256 _value) returns(bool success) {
68         allowed[msg.sender][_spender] = _value;
69         Approval(msg.sender, _spender, _value);
70         return true;
71     }
72 
73     /**
74     @notice Returns the amount for _spender left approved by _owner
75     @param _owner The address of the account owning tokens
76     @param _spender The address of the account able to transfer the tokens
77     @return remaining Amount of remaining tokens allowed to spent
78     */
79     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
80         return allowed[_owner][_spender];
81     }
82 
83 }
84 
85 /**
86 @title HumanStandardToken
87 @author https://github.com/ConsenSys/Tokens/tree/master/Token_Contracts/contracts
88 */
89 contract HumanStandardToken is StandardToken {
90     string public name; //fancy name: eg Simon Bucks
91     uint8 public decimals; //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
92     string public symbol; //An identifier: eg SBX
93     string public version; //human 0.1 standard. Just an arbitrary versioning scheme.
94 }
95 
96 /**
97 @title EthToken
98 @author https://codetract.io
99 */
100 contract EthToken is HumanStandardToken {
101     /**
102     @notice Constructor function for the EthToken contract
103     @dev Contract to trade ether to tokens at 1 to 1
104     */
105     function EthToken() {
106         balances[msg.sender] = 0;
107         totalSupply = 0;
108         name = 'ETH Token';
109         decimals = 18;
110         symbol = 'Ξ';
111         version = '0.2';
112     }
113 
114     event LogCreateToken(address indexed _from, uint256 _value);
115     event LogRedeemToken(address indexed _from, uint256 _value);
116 
117     /**
118     @notice Creates ether tokens corresponding to the amount of ether received 'msg.value'. Updates account token balance
119     @return success Whether the transfer is successful
120     */
121     function createToken() payable returns(bool success) {
122         if(msg.value == 0) {
123             throw;
124         }
125         if((balances[msg.sender] + msg.value) > balances[msg.sender] && (totalSupply + msg.value) > totalSupply) {
126             totalSupply += msg.value;
127             balances[msg.sender] += msg.value;
128             LogCreateToken(msg.sender, msg.value);
129             return true;
130         } else {
131             throw;
132         }
133     }
134 
135     /**
136     @notice Converts token quantity defined by '_token' into ether and sends back to msg.sender
137     @param _tokens The number of tokens to be converted to ether
138     @return success Whether the transfer is successful
139     */
140     function redeemToken(uint256 _tokens) returns(bool success) {
141         if(this.balance < totalSupply) {
142             throw;
143         }
144         if(_tokens == 0) {
145             throw;
146         }
147         if(balances[msg.sender] >= _tokens && totalSupply >= _tokens) {
148             balances[msg.sender] -= _tokens;
149             totalSupply -= _tokens;
150             if(msg.sender.send(_tokens)) {
151                 LogRedeemToken(msg.sender, _tokens);
152                 return true;
153             } else {
154                 throw;
155             }
156         } else {
157             throw;
158         }
159     }
160 
161     function() payable {
162         createToken();
163     }
164 }
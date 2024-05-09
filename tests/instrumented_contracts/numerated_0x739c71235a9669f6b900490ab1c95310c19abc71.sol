1 pragma solidity ^0.4.6;
2 
3 contract StandardToken {
4 
5     /*
6      *  Data structures
7      */
8     mapping (address => uint256) balances;
9     mapping (address => mapping (address => uint256)) allowed;
10     uint256 public totalSupply;
11 
12     /*
13      *  Events
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18     /*
19      *  Read and write storage functions
20      */
21     /// @dev Transfers sender's tokens to a given address. Returns success.
22     /// @param _to Address of token receiver.
23     /// @param _value Number of tokens to transfer.
24     function transfer(address _to, uint256 _value) returns (bool success) {
25         if (balances[msg.sender] >= _value && _value > 0) {
26             balances[msg.sender] -= _value;
27             balances[_to] += _value;
28             Transfer(msg.sender, _to, _value);
29             return true;
30         }
31         else {
32             return false;
33         }
34     }
35 
36     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
37     /// @param _from Address from where tokens are withdrawn.
38     /// @param _to Address to where tokens are sent.
39     /// @param _value Number of tokens to transfer.
40     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
41         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
42             balances[_to] += _value;
43             balances[_from] -= _value;
44             allowed[_from][msg.sender] -= _value;
45             Transfer(_from, _to, _value);
46             return true;
47         }
48         else {
49             return false;
50         }
51     }
52 
53     /// @dev Returns number of tokens owned by given address.
54     /// @param _owner Address of token owner.
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner];
57     }
58 
59     /// @dev Sets approved amount of tokens for spender. Returns success.
60     /// @param _spender Address of allowed account.
61     /// @param _value Number of approved tokens.
62     function approve(address _spender, uint256 _value) returns (bool success) {
63         allowed[msg.sender][_spender] = _value;
64         Approval(msg.sender, _spender, _value);
65         return true;
66     }
67 
68     /*
69      * Read storage functions
70      */
71     /// @dev Returns number of allowed tokens for given address.
72     /// @param _owner Address of token owner.
73     /// @param _spender Address of token spender.
74     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
75       return allowed[_owner][_spender];
76     }
77 
78 }
79 
80 
81 /// @title Token contract - Implements Standard Token Interface for TokenFund.
82 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
83 contract TokenFund is StandardToken {
84 
85     /*
86      * External contracts
87      */
88     address public emissionContractAddress = 0x0;
89 
90     /*
91      * Token meta data
92      */
93     string constant public name = "TheToken Fund";
94     string constant public symbol = "TKN";
95     uint8 constant public decimals = 8;
96 
97     /*
98      * Storage
99      */
100     address public owner = 0x0;
101     bool public emissionEnabled = true;
102     bool transfersEnabled = true;
103 
104     /*
105      * Modifiers
106      */
107 
108     modifier isCrowdfundingContract() {
109         // Only emission address is allowed to proceed.
110         if (msg.sender != emissionContractAddress) {
111             throw;
112         }
113         _;
114     }
115 
116     modifier onlyOwner() {
117         // Only owner is allowed to do this action.
118         if (msg.sender != owner) {
119             throw;
120         }
121         _;
122     }
123 
124     /*
125      * Contract functions
126      */
127 
128      /// @dev TokenFund emission function.
129     /// @param _for Address of receiver.
130     /// @param tokenCount Number of tokens to issue.
131     function issueTokens(address _for, uint tokenCount)
132         external
133         isCrowdfundingContract
134         returns (bool)
135     {
136         if (emissionEnabled == false) {
137             throw;
138         }
139 
140         balances[_for] += tokenCount;
141         totalSupply += tokenCount;
142         return true;
143     }
144 
145     /// @dev Withdraws tokens for msg.sender.
146     /// @param tokenCount Number of tokens to withdraw.
147     function withdrawTokens(uint tokenCount)
148         public
149         returns (bool)
150     {
151         uint balance = balances[msg.sender];
152         if (balance < tokenCount) {
153             return false;
154         }
155         balances[msg.sender] -= tokenCount;
156         totalSupply -= tokenCount;
157         return true;
158     }
159 
160     /// @dev Function to change address that is allowed to do emission.
161     /// @param newAddress Address of new emission contract.
162     function changeEmissionContractAddress(address newAddress)
163         external
164         onlyOwner
165         returns (bool)
166     {
167         emissionContractAddress = newAddress;
168     }
169 
170     /// @dev Function that enables/disables transfers of token.
171     /// @param value True/False
172     function enableTransfers(bool value)
173         external
174         onlyOwner
175     {
176         transfersEnabled = value;
177     }
178 
179     /// @dev Function that enables/disables token emission.
180     /// @param value True/False
181     function enableEmission(bool value)
182         external
183         onlyOwner
184     {
185         emissionEnabled = value;
186     }
187 
188     /*
189      * Overriding ERC20 standard token functions to support transfer lock
190      */
191     function transfer(address _to, uint256 _value)
192         returns (bool success)
193     {
194         if (transfersEnabled == true) {
195             return super.transfer(_to, _value);
196         }
197         return false;
198     }
199 
200     function transferFrom(address _from, address _to, uint256 _value)
201         returns (bool success)
202     {
203         if (transfersEnabled == true) {
204             return super.transferFrom(_from, _to, _value);
205         }
206         return false;
207     }
208 
209 
210     /// @dev Contract constructor function sets initial token balances.
211     /// @param _owner Address of the owner of TokenFund.
212     function TokenFund(address _owner)
213     {
214         totalSupply = 0;
215         owner = _owner;
216     }
217 
218     function transferOwnership(address newOwner) onlyOwner {
219         owner = newOwner;
220     }
221 }
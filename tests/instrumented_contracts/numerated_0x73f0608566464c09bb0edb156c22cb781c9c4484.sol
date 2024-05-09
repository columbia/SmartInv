1 pragma solidity ^0.4.2;
2 
3 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 
6 contract AbstractToken {
7     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
8     function totalSupply() constant returns (uint256 supply) {}
9     function balanceOf(address owner) constant returns (uint256 balance);
10     function transfer(address to, uint256 value) returns (bool success);
11     function transferFrom(address from, address to, uint256 value) returns (bool success);
12     function approve(address spender, uint256 value) returns (bool success);
13     function allowance(address owner, address spender) constant returns (uint256 remaining);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17     event Issuance(address indexed to, uint256 value);
18 }
19 
20 
21 contract StandardToken is AbstractToken {
22 
23     /*
24      *  Data structures
25      */
26     mapping (address => uint256) balances;
27     mapping (address => mapping (address => uint256)) allowed;
28     uint256 public totalSupply;
29 
30     /*
31      *  Read and write storage functions
32      */
33     /// @dev Transfers sender's tokens to a given address. Returns success.
34     /// @param _to Address of token receiver.
35     /// @param _value Number of tokens to transfer.
36     function transfer(address _to, uint256 _value) returns (bool success) {
37         if (balances[msg.sender] >= _value && _value > 0) {
38             balances[msg.sender] -= _value;
39             balances[_to] += _value;
40             Transfer(msg.sender, _to, _value);
41             return true;
42         }
43         else {
44             return false;
45         }
46     }
47 
48     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
49     /// @param _from Address from where tokens are withdrawn.
50     /// @param _to Address to where tokens are sent.
51     /// @param _value Number of tokens to transfer.
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         }
60         else {
61             return false;
62         }
63     }
64 
65     /// @dev Returns number of tokens owned by given address.
66     /// @param _owner Address of token owner.
67     function balanceOf(address _owner) constant returns (uint256 balance) {
68         return balances[_owner];
69     }
70 
71     /// @dev Sets approved amount of tokens for spender. Returns success.
72     /// @param _spender Address of allowed account.
73     /// @param _value Number of approved tokens.
74     function approve(address _spender, uint256 _value) returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     /*
81      * Read storage functions
82      */
83     /// @dev Returns number of allowed tokens for given address.
84     /// @param _owner Address of token owner.
85     /// @param _spender Address of token spender.
86     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89 
90 }
91 
92 
93 /// @title Token contract - Implements Standard Token Interface with HumaniQ features.
94 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
95 contract HumaniqToken is StandardToken {
96 
97     /*
98      * External contracts
99      */
100     address public emissionContractAddress = 0x0;
101 
102     /*
103      * Token meta data
104      */
105     string constant public name = "HumaniQ";
106     string constant public symbol = "HMQ";
107     uint8 constant public decimals = 8;
108 
109     address public founder = 0x0;
110     bool locked = true;
111     /*
112      * Modifiers
113      */
114     modifier onlyFounder() {
115         // Only founder is allowed to do this action.
116         if (msg.sender != founder) {
117             throw;
118         }
119         _;
120     }
121 
122     modifier isCrowdfundingContract() {
123         // Only emission address is allowed to proceed.
124         if (msg.sender != emissionContractAddress) {
125             throw;
126         }
127         _;
128     }
129 
130     modifier unlocked() {
131         // Only when transferring coins is enabled.
132         if (locked == true) {
133             throw;
134         }
135         _;
136     }
137 
138     /*
139      * Contract functions
140      */
141 
142     /// @dev Crowdfunding contract issues new tokens for address. Returns success.
143     /// @param _for Address of receiver.
144     /// @param tokenCount Number of tokens to issue.
145     function issueTokens(address _for, uint tokenCount)
146         external
147         payable
148         isCrowdfundingContract
149         returns (bool)
150     {
151         if (tokenCount == 0) {
152             return false;
153         }
154         balances[_for] += tokenCount;
155         totalSupply += tokenCount;
156         Issuance(_for, tokenCount);
157         return true;
158     }
159 
160     function transfer(address _to, uint256 _value)
161         unlocked
162         returns (bool success)
163     {
164         return super.transfer(_to, _value);
165     }
166 
167     function transferFrom(address _from, address _to, uint256 _value)
168         unlocked
169         returns (bool success)
170     {
171         return super.transferFrom(_from, _to, _value);
172     }
173 
174     /// @dev Function to change address that is allowed to do emission.
175     /// @param newAddress Address of new emission contract.
176     function changeEmissionContractAddress(address newAddress)
177         external
178         onlyFounder
179         returns (bool)
180     {
181         emissionContractAddress = newAddress;
182     }
183 
184     /// @dev Function that locks/unlocks transfers of token.
185     /// @param value True/False
186     function lock(bool value)
187         external
188         onlyFounder
189     {
190         locked = value;
191     }
192 
193     /// @dev Contract constructor function sets initial token balances.
194     /// @param _founder Address of the founder of HumaniQ.
195     function HumaniqToken(address _founder)
196     {
197         totalSupply = 0;
198         founder = _founder;
199     }
200 }
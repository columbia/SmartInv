1 pragma solidity ^0.4.2;
2 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
3 
4 /// @title Abstract token contract - Functions to be implemented by token contracts.
5 contract Token {
6     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
7     function totalSupply() constant returns (uint256 supply) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 contract StandardToken is Token {
20 
21     /*
22      *  Data structures
23      */
24     mapping (address => uint256) balances;
25     mapping (address => mapping (address => uint256)) allowed;
26     uint256 public totalSupply;
27 
28     /*
29      *  Read and write storage functions
30      */
31     /// @dev Transfers sender's tokens to a given address. Returns success.
32     /// @param _to Address of token receiver.
33     /// @param _value Number of tokens to transfer.
34     function transfer(address _to, uint256 _value) returns (bool success) {
35         if (balances[msg.sender] >= _value && _value > 0) {
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             Transfer(msg.sender, _to, _value);
39             return true;
40         }
41         else {
42             return false;
43         }
44     }
45 
46     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
47     /// @param _from Address from where tokens are withdrawn.
48     /// @param _to Address to where tokens are sent.
49     /// @param _value Number of tokens to transfer.
50     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
51         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
52             balances[_to] += _value;
53             balances[_from] -= _value;
54             allowed[_from][msg.sender] -= _value;
55             Transfer(_from, _to, _value);
56             return true;
57         }
58         else {
59             return false;
60         }
61     }
62 
63     /// @dev Returns number of tokens owned by given address.
64     /// @param _owner Address of token owner.
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69     /// @dev Sets approved amount of tokens for spender. Returns success.
70     /// @param _spender Address of allowed account.
71     /// @param _value Number of approved tokens.
72     function approve(address _spender, uint256 _value) returns (bool success) {
73         allowed[msg.sender][_spender] = _value;
74         Approval(msg.sender, _spender, _value);
75         return true;
76     }
77 
78     /*
79      * Read storage functions
80      */
81     /// @dev Returns number of allowed tokens for given address.
82     /// @param _owner Address of token owner.
83     /// @param _spender Address of token spender.
84     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
85       return allowed[_owner][_spender];
86     }
87 
88 }
89 
90 
91 /// @title Token contract - Implements Standard Token Interface with HumaniQ features.
92 /// @author Evgeny Yurtaev - <evgeny@etherionlab.com>
93 contract HumaniqToken is StandardToken {
94 
95     /*
96      * External contracts
97      */
98     address public emissionContractAddress = 0x0;
99 
100     /*
101      * Token meta data
102      */
103     string constant public name = "HumaniQ";
104     string constant public symbol = "HMQ";
105     uint8 constant public decimals = 0;
106 
107     address public founder = 0x0;
108     bool locked = true;
109     /*
110      * Modifiers
111      */
112     modifier onlyFounder() {
113         // Only founder is allowed to do this action.
114         if (msg.sender != founder) {
115             throw;
116         }
117         _;
118     }
119 
120     modifier isCrowdfundingContract() {
121         // Only emission address is allowed to proceed.
122         if (msg.sender != emissionContractAddress) {
123             throw;
124         }
125         _;
126     }
127 
128     modifier unlocked() {
129         // Only when transferring coins is enabled.
130         if (locked == true) {
131             throw;
132         }
133         _;
134     }
135 
136     /*
137      * Contract functions
138      */
139 
140     /// @dev Crowdfunding contract issues new tokens for address. Returns success.
141     /// @param _for Address of receiver.
142     /// @param tokenCount Number of tokens to issue.
143     function issueTokens(address _for, uint tokenCount)
144         external
145         payable
146         isCrowdfundingContract
147         returns (bool)
148     {
149         if (tokenCount == 0) {
150             return false;
151         }
152         balances[_for] += tokenCount;
153         totalSupply += tokenCount;
154         return true;
155     }
156 
157     function transfer(address _to, uint256 _value)
158         unlocked
159         returns (bool success)
160     {
161         return super.transfer(_to, _value);
162     }
163 
164     function transferFrom(address _from, address _to, uint256 _value)
165         unlocked
166         returns (bool success)
167     {
168         return super.transferFrom(_from, _to, _value);
169     }
170 
171     /// @dev Function to change address that is allowed to do emission.
172     /// @param newAddress Address of new emission contract.
173     function changeEmissionContractAddress(address newAddress)
174         external
175         onlyFounder
176         returns (bool)
177     {
178         emissionContractAddress = newAddress;
179     }
180 
181     /// @dev Function that locks/unlocks transfers of token.
182     /// @param value True/False
183     function lock(bool value)
184         external
185         onlyFounder
186     {
187         locked = value;
188     }
189 
190     /// @dev Contract constructor function sets initial token balances.
191     /// @param _founder Address of the founder of HumaniQ.
192     function HumaniqToken(address _founder)
193     {
194         totalSupply = 0;
195         founder = _founder;
196     }
197 }
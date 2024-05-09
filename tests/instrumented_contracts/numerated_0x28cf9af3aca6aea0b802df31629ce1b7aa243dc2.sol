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
20 contract StandardToken is AbstractToken {
21 
22     /*
23      *  Data structures
24      */
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27     uint256 public totalSupply;
28 
29     /*
30      *  Read and write storage functions
31      */
32     /// @dev Transfers sender's tokens to a given address. Returns success.
33     /// @param _to Address of token receiver.
34     /// @param _value Number of tokens to transfer.
35     function transfer(address _to, uint256 _value) returns (bool success) {
36         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             Transfer(msg.sender, _to, _value);
40             return true;
41         }
42         else {
43             return false;
44         }
45     }
46 
47     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
48     /// @param _from Address from where tokens are withdrawn.
49     /// @param _to Address to where tokens are sent.
50     /// @param _value Number of tokens to transfer.
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         }
59         else {
60             return false;
61         }
62     }
63 
64     /// @dev Returns number of tokens owned by given address.
65     /// @param _owner Address of token owner.
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     /// @dev Sets approved amount of tokens for spender. Returns success.
71     /// @param _spender Address of allowed account.
72     /// @param _value Number of approved tokens.
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     /*
80      * Read storage functions
81      */
82     /// @dev Returns number of allowed tokens for given address.
83     /// @param _owner Address of token owner.
84     /// @param _spender Address of token spender.
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89 }
90 
91 /**
92  * Math operations with safety checks
93  */
94 contract SafeMath {
95   function mul(uint a, uint b) internal returns (uint) {
96     uint c = a * b;
97     assert(a == 0 || c / a == b);
98     return c;
99   }
100 
101   function div(uint a, uint b) internal returns (uint) {
102     assert(b > 0);
103     uint c = a / b;
104     assert(a == b * c + a % b);
105     return c;
106   }
107 
108   function sub(uint a, uint b) internal returns (uint) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   function add(uint a, uint b) internal returns (uint) {
114     uint c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 
119   function assert(bool assertion) internal {
120     if (!assertion) {
121       throw;
122     }
123   }
124 }
125 
126 
127 /// @title Token contract - Implements Standard Token Interface but adds Pyramid Scheme Support :)
128 /// @author Rishab Hegde - <contact@rishabhegde.com>
129 contract PonziCoin is StandardToken, SafeMath {
130 
131     /*
132      * Token meta data
133      */
134     string constant public name = "PonziCoin";
135     string constant public symbol = "SEC";
136     uint8 constant public decimals = 3;
137 
138     uint public buyPrice = 10 szabo;
139     uint public sellPrice = 2500000000000 wei;
140     uint public tierBudget = 100000;
141 
142     // Address of the founder of PonziCoin.
143     address public founder = 0x9AfD4F7aD03A03d306B41a4604Ea2928cFf78fd1;
144 
145     /*
146      * Contract functions
147      */
148     /// @dev Allows user to create tokens if token creation is still going
149     /// and cap was not reached. Returns token count.
150     function fund()
151       public
152       payable 
153       returns (bool)
154     {
155       uint tokenCount = msg.value / buyPrice;
156       if (tokenCount > tierBudget) {
157         tokenCount = tierBudget;
158       }
159       
160       uint investment = tokenCount * buyPrice;
161 
162       balances[msg.sender] += tokenCount;
163       Issuance(msg.sender, tokenCount);
164       totalSupply += tokenCount;
165       tierBudget -= tokenCount;
166 
167       if (tierBudget <= 0) {
168         tierBudget = 100000;
169         buyPrice *= 2;
170         sellPrice *= 2;
171       }
172       if (msg.value > investment) {
173         msg.sender.transfer(msg.value - investment);
174       }
175       return true;
176     }
177 
178     function withdraw(uint tokenCount)
179       public
180       returns (bool)
181     {
182       if (balances[msg.sender] >= tokenCount) {
183         uint withdrawal = tokenCount * sellPrice;
184         balances[msg.sender] -= tokenCount;
185         totalSupply -= tokenCount;
186         msg.sender.transfer(withdrawal);
187         return true;
188       } else {
189         return false;
190       }
191     }
192 
193     /// @dev Contract constructor function sets initial token balances.
194     function PonziCoin()
195     {   
196         // It's not a good scam unless it's pre-mined. No I'm not going to dump on you, don't worry. This isn't a scam (at least not entirely). If I feel like maintaining the website is too much I'll give the keys to someone else.
197         balances[founder] = 200000;
198         totalSupply += 200000;
199     }
200 }
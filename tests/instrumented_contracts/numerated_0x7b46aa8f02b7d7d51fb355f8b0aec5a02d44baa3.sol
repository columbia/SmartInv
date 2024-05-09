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
14     function checkPrice() public returns (uint256);
15     
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18     event Issuance(address indexed to, uint256 value);
19 }
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
37         if (_to != address(0) && balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
53       if (_to != address(0) && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
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
92 /**
93  * Math operations with safety checks
94  */
95 contract SafeMath {
96   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
97     uint256 c = a * b;
98     assert(a == 0 || c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 
122 /// @title Token contract - Implements Standard Token Interface
123 /// @author Rishab Hegde - <contact@rishabhegde.com>
124 contract TestCoin is StandardToken, SafeMath {
125 
126     /*
127      * Token meta data
128      */
129     string constant public name = "TestCoin";
130     string constant public symbol = "TEST234124";
131     uint8 constant public decimals = 3;
132 
133     uint public price = 50 szabo;
134     uint public priceUpdatedTime;
135 
136     address public feeAddress = 0x212fbd2077ab9681f0a6DE03ab15951B8D083E6c;
137 
138     /*
139      * Contract functions
140      */
141     /// @dev Allows user to create tokens if token creation is still going
142     /// and cap was not reached. Returns token count.
143     function fund()
144       public
145       payable 
146       returns (bool)
147     {
148       checkPrice();
149       
150       uint tokenCount = msg.value / price;
151       uint investment = tokenCount * price;
152 
153       balances[msg.sender] += tokenCount;
154       Issuance(msg.sender, tokenCount);
155       totalSupply += tokenCount;
156 
157       if (msg.value > investment) {
158         msg.sender.transfer(msg.value - investment);
159       }
160       return true;
161     }
162 
163     function withdraw(uint tokenCount)
164       public
165       returns (bool)
166     {
167       checkPrice();
168       if (balances[msg.sender] >= tokenCount) {
169         uint tokensValue = tokenCount * price;
170         balances[msg.sender] -= tokenCount;
171         totalSupply -= tokenCount;
172         uint fee = tokensValue / 5;
173         uint withdrawal = fee * 4;
174         feeAddress.transfer(fee);
175         msg.sender.transfer(withdrawal);
176         return true;
177       } else {
178         return false;
179       }
180     }
181     //each minute increase price by 2%
182     function checkPrice() public returns (uint256)
183     {
184       uint timeSinceLastUpdate = now - priceUpdatedTime;
185         if((now - timeSinceLastUpdate) > 1 minutes){
186           priceUpdatedTime = now;
187           price += price/50;
188         }
189         return price;
190     }
191     
192     /// @dev Contract constructor function sets initial token balances.
193     function TestCoin()
194     {   
195         priceUpdatedTime = now;
196     }
197 }
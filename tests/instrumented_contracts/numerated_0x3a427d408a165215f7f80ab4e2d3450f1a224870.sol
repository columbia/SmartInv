1 pragma solidity ^0.4.4;
2 
3 
4 library SafeMath {
5     
6   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal constant returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29   
30 }
31 
32 // Standard token interface (ERC 20)
33 // https://github.com/ethereum/EIPs/issues/20
34 contract ERC20 
35 {
36 // Functions:
37     /// @return total amount of tokens
38     uint256 public totalSupply;
39 
40     /// @param _owner The address from which the balance will be retrieved
41     /// @return The balance
42     function balanceOf(address _owner) constant returns (uint256);
43 
44     /// @notice send `_value` token to `_to` from `msg.sender`
45     /// @param _to The address of the recipient
46     /// @param _value The amount of token to be transferred
47     /// @return Whether the transfer was successful or not
48     function transfer(address _to, uint256 _value) returns (bool);
49 
50     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
51     /// @param _from The address of the sender
52     /// @param _to The address of the recipient
53     /// @param _value The amount of token to be transferred
54     /// @return Whether the transfer was successful or not
55     function transferFrom(address _from, address _to, uint256 _value) returns (bool);
56 
57     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
58     /// @param _spender The address of the account able to transfer the tokens
59     /// @param _value The amount of wei to be approved for transfer
60     /// @return Whether the approval was successful or not
61     function approve(address _spender, uint256 _value) returns (bool);
62 
63     /// @param _owner The address of the account owning tokens
64     /// @param _spender The address of the account able to transfer the tokens
65     /// @return Amount of remaining tokens allowed to spent
66     function allowance(address _owner, address _spender) constant returns (uint256);
67 
68 // Events:
69     event Transfer(address indexed _from, address indexed _to, uint256 _value);
70     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
71 }
72 
73 /**
74  * @title Contract for object that have an owner
75  */
76 contract Owned {
77     /**
78      * Contract owner address
79      */
80     address public owner;
81 
82     /**
83      * @dev Delegate contract to another person
84      * @param _owner New owner address 
85      */
86     function setOwner(address _owner) onlyOwner
87     { owner = _owner; }
88 
89     /**
90      * @dev Owner check modifier
91      */
92     modifier onlyOwner { if (msg.sender != owner) throw; _; }
93 }
94 
95 
96 contract ArbitrageCtCrowdsale is Owned {
97     event Print(string _name, uint _value);
98     
99     using SafeMath for uint;
100     
101     address public multisig = 0xe98bdde8edbfc6ff6bb8804077b6be9d4401a71d; 
102 
103     address public addressOfERC20Tocken = 0x1245ef80F4d9e02ED9425375e8F649B9221b31D8;
104     ERC20 public token;
105     
106     
107     uint public startICO = now; 
108     uint public endICO = 1515974400; //Mon, 15 Jan 2018 00:00:00 GMT
109     
110     uint public tokenETHAmount = 75000 * 100000000;
111    
112     function tokenBalance() constant returns (uint256) {
113         return token.balanceOf(address(this));
114     } 
115     
116     function ArbitrageCtCrowdsale(){//(address _addressOfERC20Tocken){
117         owner = msg.sender;
118         token = ERC20(addressOfERC20Tocken);
119         //token = ERC20(_addressOfERC20Tocken);
120     }
121     
122     //Адрес токена установлен при деплоее
123    /* function setAddressOfERC20Tocken(address _addressOfERC20Tocken) onlyOwner {
124         addressOfERC20Tocken =  _addressOfERC20Tocken;
125         token = ERC20(addressOfERC20Tocken);
126         
127     }*/
128     
129     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
130         return token.transfer(_to,  _value);
131     }
132     
133     function() payable {
134         doPurchase();
135     }
136 
137     function doPurchase() payable {
138         require(now >= startICO && now < endICO);
139 
140         require(msg.value >= 10000000000000000); // > 0.01 ETH
141         
142         uint sum = msg.value;
143         
144         uint tokensAmount;
145         
146         tokensAmount = sum.mul(tokenETHAmount).div(1000000000000000000);//.mul(token.decimals);
147 
148         
149         //Bonus
150         if(sum >= 100 * 1000000000000000000){
151            tokensAmount = tokensAmount.mul(110).div(100);
152         } else if(sum >= 50 * 1000000000000000000){
153            tokensAmount = tokensAmount.mul(109).div(100);
154         } else if(sum >= 30 * 1000000000000000000){
155            tokensAmount = tokensAmount.mul(108).div(100);
156         } else if(sum >= 20 * 1000000000000000000){
157            tokensAmount = tokensAmount.mul(107).div(100);
158         } else if(sum >= 10 * 1000000000000000000){
159            tokensAmount = tokensAmount.mul(106).div(100);
160         } else if(sum >= 7 * 1000000000000000000){
161            tokensAmount = tokensAmount.mul(105).div(100);
162         } else if(sum >= 5 * 1000000000000000000){
163            tokensAmount = tokensAmount.mul(104).div(100);
164         } else if(sum >= 3 * 1000000000000000000){
165            tokensAmount = tokensAmount.mul(103).div(100);
166         } else if(sum >= 2 * 1000000000000000000){
167            tokensAmount = tokensAmount.mul(102).div(100);
168         } else if(sum >= 1 * 1000000000000000000){
169            tokensAmount = tokensAmount.mul(101).div(100);
170         } else if(sum >=  500000000000000000){
171            tokensAmount = tokensAmount.mul(1005).div(1000);
172         }
173 
174         require(tokenBalance() > tokensAmount);
175         
176         require(token.transfer(msg.sender, tokensAmount));
177         multisig.transfer(msg.value);
178         
179         
180     }
181     
182     
183 }
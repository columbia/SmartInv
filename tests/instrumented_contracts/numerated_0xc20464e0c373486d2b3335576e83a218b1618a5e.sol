1 // Datarius tokensale smart contract.
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.15;
4 
5 /**
6  *   @title SafeMath
7  *   @dev Math operations with safety checks that throw on error
8  */
9 
10 library SafeMath {
11 
12   function mul(uint a, uint b) internal constant returns (uint) {
13     if (a == 0) {
14       return 0;
15     }
16     uint c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal constant returns(uint) {
22     assert(b > 0);
23     uint c = a / b;
24     assert(a == b * c + a % b);
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal constant returns(uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal constant returns(uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 /**
41  *   @title ERC20
42  *   @dev Standart ERC20 token interface
43  */
44 
45 contract ERC20 {
46     uint public totalSupply = 0;
47 
48     mapping(address => uint) balances;
49     mapping(address => mapping (address => uint)) allowed;
50 
51     function balanceOf(address _owner) constant returns (uint);
52     function transfer(address _to, uint _value) returns (bool);
53     function transferFrom(address _from, address _to, uint _value) returns (bool);
54     function approve(address _spender, uint _value) returns (bool);
55     function allowance(address _owner, address _spender) constant returns (uint);
56 
57     event Transfer(address indexed _from, address indexed _to, uint _value);
58     event Approval(address indexed _owner, address indexed _spender, uint _value);
59 
60 } 
61 
62 
63 /**
64  *   @title DatariusToken
65  *   @dev Datarius token contract
66  */
67 contract DatariusToken is ERC20 {
68     using SafeMath for uint;
69     string public name = "Datarius Credit";
70     string public symbol = "DTRC";
71     uint public decimals = 18;
72 
73     // Ico contract address
74     address public ico;
75     event Burn(address indexed from, uint value);
76     
77     // Tokens transfer ability status
78     bool public tokensAreFrozen = true;
79 
80     // Allows execution by the owner only
81     modifier icoOnly { 
82         require(msg.sender == ico); 
83         _; 
84     }
85 
86    /**
87     *   @dev Contract constructor function sets Ico address
88     *   @param _ico          ico address
89     */
90     function DatariusToken(address _ico) public {
91        ico = _ico;
92     }
93 
94    /**
95     *   @dev Function to mint tokens
96     *   @param _holder       beneficiary address the tokens will be issued to
97     *   @param _value        number of tokens to issue
98     */
99     function mintTokens(address _holder, uint _value) external icoOnly {
100        require(_value > 0);
101        balances[_holder] = balances[_holder].add(_value);
102        totalSupply = totalSupply.add(_value);
103        Transfer(0x0, _holder, _value);
104     }
105 
106 
107    /**
108     *   @dev Function to enable token transfers
109     */
110     function defrost() external icoOnly {
111        tokensAreFrozen = false;
112     }
113 
114 
115    /**
116     *   @dev Burn Tokens
117     *   @param _holder       token holder address which the tokens will be burnt
118     *   @param _value        number of tokens to burn
119     */
120     function burnTokens(address _holder, uint _value) external icoOnly {
121         require(balances[_holder] > 0);
122         totalSupply = totalSupply.sub(_value);
123         balances[_holder] = balances[_holder].sub(_value);
124         Burn(_holder, _value);
125     }
126 
127    /**
128     *   @dev Get balance of tokens holder
129     *   @param _holder        holder's address
130     *   @return               balance of investor
131     */
132     function balanceOf(address _holder) constant returns (uint) {
133          return balances[_holder];
134     }
135 
136    /**
137     *   @dev Send coins
138     *   throws on any error rather then return a false flag to minimize
139     *   user errors
140     *   @param _to           target address
141     *   @param _amount       transfer amount
142     *
143     *   @return true if the transfer was successful
144     */
145     function transfer(address _to, uint _amount) public returns (bool) {
146         require(!tokensAreFrozen);
147         balances[msg.sender] = balances[msg.sender].sub(_amount);
148         balances[_to] = balances[_to].add(_amount);
149         Transfer(msg.sender, _to, _amount);
150         return true;
151     }
152 
153    /**
154     *   @dev An account/contract attempts to get the coins
155     *   throws on any error rather then return a false flag to minimize user errors
156     *
157     *   @param _from         source address
158     *   @param _to           target address
159     *   @param _amount       transfer amount
160     *
161     *   @return true if the transfer was successful
162     */
163     function transferFrom(address _from, address _to, uint _amount) public returns (bool) {
164         require(!tokensAreFrozen);
165         balances[_from] = balances[_from].sub(_amount);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
167         balances[_to] = balances[_to].add(_amount);
168         Transfer(_from, _to, _amount);
169         return true;
170      }
171 
172 
173    /**
174     *   @dev Allows another account/contract to spend some tokens on its behalf
175     *   throws on any error rather then return a false flag to minimize user errors
176     *
177     *   also, to minimize the risk of the approve/transferFrom attack vector
178     *   approve has to be called twice in 2 separate transactions - once to
179     *   change the allowance to 0 and secondly to change it to the new allowance
180     *   value
181     *
182     *   @param _spender      approved address
183     *   @param _amount       allowance amount
184     *
185     *   @return true if the approval was successful
186     */
187     function approve(address _spender, uint _amount) public returns (bool) {
188         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
189         allowed[msg.sender][_spender] = _amount;
190         Approval(msg.sender, _spender, _amount);
191         return true;
192     }
193 
194    /**
195     *   @dev Function to check the amount of tokens that an owner allowed to a spender.
196     *
197     *   @param _owner        the address which owns the funds
198     *   @param _spender      the address which will spend the funds
199     *
200     *   @return              the amount of tokens still avaible for the spender
201     */
202     function allowance(address _owner, address _spender) constant returns (uint) {
203         return allowed[_owner][_spender];
204     }
205 }
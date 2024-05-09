1 pragma solidity ^0.4.11;
2 
3 // ==== DISCLAIMER ====
4 //
5 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
6 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
7 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
8 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
9 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
10 //
11 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
12 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
13 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
14 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
15 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
16 // ====
17 // all this file is based on code from open zepplin
18 // https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/token
19 // Standard ERC20 token Clickle.de
20 // @author Chainsulting.de - Blockchain Consulting 
21 // ==== DISCLAIMER ====
22 
23  // @title SafeMath
24  // @dev Math operations with safety checks that throw on error
25 
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
28     uint256 c = a * b;
29     assert(a == 0 || c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal constant returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal constant returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 
53  // @title ERC20Basic
54  // @dev Simpler version of ERC20 interface
55  // @dev see https://github.com/ethereum/EIPs/issues/179
56 
57 contract ERC20Basic {
58   uint256 public totalSupply;
59   function balanceOf(address who) public constant returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63  
64  // @title ERC20 interface
65  // @dev see https://github.com/ethereum/EIPs/issues/20
66 
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public constant returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73  
74  // @title Basic token
75  // @dev Basic version of StandardToken, with no allowances.
76  
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   
83   // @dev transfer token for a specified address
84   // @param _to The address to transfer to.
85   // @param _value The amount to be transferred.
86  
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   
99   // @dev Gets the balance of the specified address.
100   // @param _owner The address to query the the balance of.
101   // @return An uint256 representing the amount owned by the passed address.
102  
103   function balanceOf(address _owner) public constant returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109  // @title Standard ERC20 token
110  // @dev Implementation of the basic standard token.
111  // @dev https://github.com/ethereum/EIPs/issues/20
112  // @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
113 
114 contract StandardToken is ERC20, BasicToken {
115 
116   mapping (address => mapping (address => uint256)) internal allowed;
117 
118 
119   
120    // @dev Transfer tokens from one address to another
121    // @param _from address The address which you want to send tokens from
122    // @param _to address The address which you want to transfer to
123    // @param _value uint256 the amount of tokens to be transferred
124    
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
126     require(_to != address(0));
127     require(_value <= balances[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137    // @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
138    //
139    // Beware that changing an allowance with this method brings the risk that someone may use both the old
140    // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
141    // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
142    // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143    // @param _spender The address which will spend the funds.
144    // @param _value The amount of tokens to be spent.
145    
146   function approve(address _spender, uint256 _value) public returns (bool) {
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152  
153    // @dev Function to check the amount of tokens that an owner allowed to a spender.
154    // @param _owner address The address which owns the funds.
155    // @param _spender address The address which will spend the funds.
156    // @return A uint256 specifying the amount of tokens still available for the spender.
157   
158   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
159     return allowed[_owner][_spender];
160   }
161 
162 
163    // approve should be called when allowed[_spender] == 0. To increment
164    // allowed value is better to use this function to avoid 2 calls (and wait until
165    // the first transaction is mined)
166    // From MonolithDAO Token.sol
167 
168   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187  // @title CLICKLE Token
188  // @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
189  // Note they can later distribute these tokens as they wish using `transfer` and other
190  // StandardToken functions. 20.000.000 CLICK
191 
192 contract CLICKLEToken is StandardToken {
193 
194     string public name = "Clickle Token";
195     string public symbol = "CLICK";
196     uint public decimals = 8;
197     uint public INITIAL_SUPPLY = 2000000000000000; // Initial supply is 20,000,000 CLICK
198 
199     function CLICKLEToken() {
200         totalSupply = INITIAL_SUPPLY;
201         balances[msg.sender] = INITIAL_SUPPLY; // Give the creator all initial tokens
202     }
203 }
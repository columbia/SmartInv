1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of.
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) public constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 
75 contract StandardToken is ERC20, BasicToken {
76 
77   mapping (address => mapping (address => uint256)) internal allowed;
78 
79 
80   /**
81    * @dev Transfer tokens from one address to another
82    * @param _from address The address which you want to send tokens from
83    * @param _to address The address which you want to transfer to
84    * @param _value uint256 the amount of tokens to be transferred
85    */
86   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[_from]);
89     require(_value <= allowed[_from][msg.sender]);
90 
91     balances[_from] = balances[_from].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
94     Transfer(_from, _to, _value);
95     return true;
96   }
97 
98   /**
99    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
100    *
101    * Beware that changing an allowance with this method brings the risk that someone may use both the old
102    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
103    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
104    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
105    * @param _spender The address which will spend the funds.
106    * @param _value The amount of tokens to be spent.
107    */
108   function approve(address _spender, uint256 _value) public returns (bool) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Function to check the amount of tokens that an owner allowed to a spender.
116    * @param _owner address The address which owns the funds.
117    * @param _spender address The address which will spend the funds.
118    * @return A uint256 specifying the amount of tokens still available for the spender.
119    */
120   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
121     return allowed[_owner][_spender];
122   }
123 
124   /**
125    * approve should be called when allowed[_spender] == 0. To increment
126    * allowed value is better to use this function to avoid 2 calls (and wait until
127    * the first transaction is mined)
128    * From MonolithDAO Token.sol
129    */
130   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
131     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
132     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133     return true;
134   }
135 
136   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
137     uint oldValue = allowed[msg.sender][_spender];
138     if (_subtractedValue > oldValue) {
139       allowed[msg.sender][_spender] = 0;
140     } else {
141       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
142     }
143     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
144     return true;
145   }
146 
147 }
148 
149 contract SOUL is StandardToken {
150     using SafeMath for uint256;
151 
152     string public name = "SOUL COIN";
153     string public symbol = "SIN";
154     uint256 public decimals = 18;
155 
156     uint256 public totalSupply = 736303 * (uint256(10) ** decimals);
157     uint256 public totalRaised; // total ether raised (in wei)
158 
159     uint256 public startTimestamp; // timestamp after which ICO will start
160     uint256 public durationSeconds = 51 * 24 * 60 * 60; // 51 days
161 
162     uint256 public minCap; // the ICO ether goal (in wei)
163     uint256 public maxCap; // the ICO ether max cap (in wei)
164 
165     /**
166      * Address which will receive raised funds 
167      * and owns the total supply of tokens
168      */
169     address public fundsWallet;
170 
171     function SOUL() {
172         fundsWallet = 0x028fBDa1Fa8572A5F5753fdBdEC138De0569960d;
173         startTimestamp = 1509494400;
174         minCap = 555 ether;
175         maxCap = 666 ether;
176 
177         // initially assign all tokens to the fundsWallet
178         balances[fundsWallet] = totalSupply;
179         Transfer(0x0, fundsWallet, totalSupply);
180     }
181 
182     function() isIcoOpen payable {
183         totalRaised = totalRaised.add(msg.value);
184 
185         uint256 tokenAmount = calculateTokenAmount(msg.value);
186         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
187         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
188         Transfer(fundsWallet, msg.sender, tokenAmount);
189 
190         // immediately transfer ether to fundsWallet
191         fundsWallet.transfer(msg.value);
192     }
193 
194     function calculateTokenAmount(uint256 weiAmount) constant returns(uint256) {
195         // standard rate: 1 ETH : 666 SIN
196         uint256 tokenAmount = weiAmount.mul(666);
197         if (now <= startTimestamp + 12 days) {
198             // +66% bonus during first 12 days
199             return tokenAmount.mul(166).div(100);
200         } else {
201             return tokenAmount;
202         }
203     }
204 
205     function transfer(address _to, uint _value) isIcoFinished returns (bool) {
206         return super.transfer(_to, _value);
207     }
208 
209     function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) {
210         return super.transferFrom(_from, _to, _value);
211     }
212 
213     modifier isIcoOpen() {
214         require(now >= startTimestamp);
215         require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);
216         require(totalRaised <= maxCap);
217         _;
218     }
219 
220     modifier isIcoFinished() {
221         require(now >= startTimestamp);
222         require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));
223         _;
224     }
225 }
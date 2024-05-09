1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal constant returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public constant returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82 
83   /**
84    * @dev Transfer tokens from one address to another
85    * @param _from address The address which you want to send tokens from
86    * @param _to address The address which you want to transfer to
87    * @param _value uint256 the amount of tokens to be transferred
88    */
89   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[_from]);
92     require(_value <= allowed[_from][msg.sender]);
93 
94     balances[_from] = balances[_from].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98     return true;
99   }
100 
101   /**
102    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
103    *
104    * Beware that changing an allowance with this method brings the risk that someone may use both the old
105    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
106    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    * @param _spender The address which will spend the funds.
109    * @param _value The amount of tokens to be spent.
110    */
111   function approve(address _spender, uint256 _value) public returns (bool) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Function to check the amount of tokens that an owner allowed to a spender.
119    * @param _owner address The address which owns the funds.
120    * @param _spender address The address which will spend the funds.
121    * @return A uint256 specifying the amount of tokens still available for the spender.
122    */
123   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127   /**
128    * approve should be called when allowed[_spender] == 0. To increment
129    * allowed value is better to use this function to avoid 2 calls (and wait until
130    * the first transaction is mined)
131    * From MonolithDAO Token.sol
132    */
133   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
134     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
135     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
136     return true;
137   }
138 
139   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
140     uint oldValue = allowed[msg.sender][_spender];
141     if (_subtractedValue > oldValue) {
142       allowed[msg.sender][_spender] = 0;
143     } else {
144       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
145     }
146     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
147     return true;
148   }
149 
150 }
151 
152 contract HadaCoinIco is StandardToken {
153     using SafeMath for uint256;
154 
155     string public name = "HADACoin";
156     string public symbol = "HADA";
157     uint256 public decimals = 18;
158 
159     uint256 public totalSupply = 500000000 * (uint256(10) ** decimals);
160     uint256 public totalRaised; // total ether raised (in wei)
161 
162     uint256 public startTimestamp; // timestamp after which ICO will start
163     uint256 public durationSeconds = 60 * 60 * 24 * 31; // 31 Days
164 
165     uint256 public minCap; // the ICO ether goal (in wei)
166     uint256 public maxCap; // the ICO ether max cap (in wei)
167 
168     /**
169      * Address which will receive raised funds 
170      * and owns the total supply of tokens
171      */
172     address public fundsWallet;
173 
174     function HadaCoinIco(
175         address _fundsWallet,
176         uint256 _startTimestamp,
177         uint256 _minCap,
178         uint256 _maxCap) {
179         fundsWallet = _fundsWallet;
180         startTimestamp = _startTimestamp;
181         minCap = _minCap;
182         maxCap = _maxCap;
183 
184         // initially assign all tokens to the fundsWallet
185         balances[fundsWallet] = totalSupply;
186         Transfer(0x0, fundsWallet, totalSupply);
187     }
188 
189     function() isIcoOpen payable {
190         totalRaised = totalRaised.add(msg.value);
191 
192         uint256 tokenAmount = calculateTokenAmount(msg.value);
193         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
194         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
195         Transfer(fundsWallet, msg.sender, tokenAmount);
196 
197         // immediately transfer ether to fundsWallet
198         fundsWallet.transfer(msg.value);
199     }
200 
201     function calculateTokenAmount(uint256 weiAmount) constant returns(uint256) {
202         // standard rate: 1 ETH : 400 HADA
203         uint256 tokenAmount = weiAmount.mul(400);
204         if (now <= startTimestamp + 7 days) {
205             // +25% bonus during first week
206             return tokenAmount.mul(250).div(100);
207         } else
208         if (now >= startTimestamp + 7 days && now <= startTimestamp + 14 days) {
209             // +20% bonus during second week
210             return tokenAmount.mul(210).div(100);
211         } else
212         if (now >= startTimestamp + 14 days && now <= startTimestamp + 21 days) {
213             // +15% bonus during third week
214             return tokenAmount.mul(1725).div(1000);
215         } else 
216         if (now >= startTimestamp + 21 days && now <= startTimestamp + 28 days) {
217             // +10% bonus during fourth week
218             return tokenAmount.mul(1375).div(1000);
219         } else {
220             return tokenAmount;
221         }
222     }
223 
224     function transfer(address _to, uint _value) isIcoFinished returns (bool) {
225         return super.transfer(_to, _value);
226     }
227 
228     function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) {
229         return super.transferFrom(_from, _to, _value);
230     }
231 
232     modifier isIcoOpen() {
233         require(now >= startTimestamp);
234         require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);
235         require(totalRaised <= maxCap);
236         _;
237     }
238 
239     modifier isIcoFinished() {
240         require(now >= startTimestamp);
241         require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));
242         _;
243     }
244 }
245 
246 contract Factory {
247 
248     function createContract(
249         address _fundsWallet,
250         uint256 _startTimestamp,
251         uint256 _minCapEth,
252         uint256 _maxCapEth) returns(address created) 
253     {
254         return new HadaCoinIco(
255             _fundsWallet,
256             _startTimestamp,
257             _minCapEth * 1 ether,
258             _maxCapEth * 1 ether
259         );
260     }
261 }
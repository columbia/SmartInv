1 pragma solidity ^0.4.24;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 
52 /**
53  * @title ERC20Basic
54  * @dev Simpler version of ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/179
56  */
57 contract ERC20Basic {
58   function totalSupply() public view returns (uint256);
59   function balanceOf(address who) public view returns (uint256);
60   function transfer(address to, uint256 value) public returns (bool);
61   event Transfer(address indexed from, address indexed to, uint256 value);
62 }
63 
64 
65 /**
66  * @title ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender)
71     public view returns (uint256);
72 
73   function transferFrom(address from, address to, uint256 value)
74     public returns (bool);
75 
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(
78     address indexed owner,
79     address indexed spender,
80     uint256 value
81   );
82 }
83 
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances.
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   uint256 totalSupply_;
95 
96   /**
97   * @dev total number of tokens in existence
98   */
99   function totalSupply() public view returns (uint256) {
100     return totalSupply_;
101   }
102 
103   /**
104   * @dev transfer token for a specified address
105   * @param _to The address to transfer to.
106   * @param _value The amount to be transferred.
107   */
108   function transfer(address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[msg.sender]);
111 
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     emit Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256) {
124     return balances[_owner];
125   }
126 
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) internal allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amount of tokens to be transferred
146    */
147   function transferFrom(
148     address _from,
149     address _to,
150     uint256 _value
151   )
152     public
153     returns (bool)
154   {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
168    *
169    * Beware that changing an allowance with this method brings the risk that someone may use both the old
170    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
171    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
172    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) public returns (bool) {
177     allowed[msg.sender][_spender] = _value;
178     emit Approval(msg.sender, _spender, _value);
179     return true;
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(
210     address _spender,
211     uint _addedValue
212   )
213     public
214     returns (bool)
215   {
216     allowed[msg.sender][_spender] = (
217       allowed[msg.sender][_spender].add(_addedValue));
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(
233     address _spender,
234     uint _subtractedValue
235   )
236     public
237     returns (bool)
238   {
239     uint oldValue = allowed[msg.sender][_spender];
240     if (_subtractedValue > oldValue) {
241       allowed[msg.sender][_spender] = 0;
242     } else {
243       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
244     }
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249 }
250 
251 
252 contract EscobarcoinToken is StandardToken {
253     using SafeMath for uint256;
254 
255     string public name = "EscobarcoinToken";
256     string public symbol = "ESCO";
257     uint256 public decimals = 18;
258 
259     uint256 public totalSupply = 250000000 * (uint256(10) ** decimals);
260     //uint256 public rate = 9000; //rate per ether
261     uint256 public totalRaised; // total ether raised (in wei)
262 
263     uint256 public startTimestamp; // timestamp after which ICO will start
264     uint256 public durationSeconds = 4 * 7 * 24 * 60 * 60; // 4 weeks
265 
266     uint256 public minCap; // the ICO ether goal (in wei)
267     uint256 public maxCap; // the ICO ether max cap (in wei)
268 
269     /**
270      * Address which will receive raised funds 
271      * and owns the total supply of tokens
272      */
273     address public fundsWallet;
274 
275     function EscobarcoinToken() {
276         fundsWallet = 0x1EC478936a49278c8754021927a2ab0018594D40;
277         startTimestamp = 1526817600;
278         minCap = 1667 * (uint256(10) ** decimals);
279         maxCap = 16667 * (uint256(10) ** decimals);
280 
281         // initially assign all tokens to the fundsWallet
282         balances[fundsWallet] = totalSupply;
283         Transfer(0x0, fundsWallet, totalSupply);
284     }
285 
286     function() isIcoOpen payable {
287         totalRaised = totalRaised.add(msg.value);
288 
289         uint256 tokenAmount = calculateTokenAmount(msg.value);
290         balances[fundsWallet] = balances[fundsWallet].sub(tokenAmount);
291         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
292         Transfer(fundsWallet, msg.sender, tokenAmount);
293 
294         // immediately transfer ether to fundsWallet
295         fundsWallet.transfer(msg.value);
296     }
297 
298     function calculateTokenAmount(uint256 weiAmount) constant returns(uint256) {
299         // standard rate: 1 ETH : 9000 ESP
300         uint256 tokenAmount = weiAmount.mul(9000);
301         
302         if (now <= startTimestamp + 7 days) {
303             // +50% bonus during first week
304             return tokenAmount.mul(150).div(100);
305         } else if (now <= startTimestamp + 14 days) {
306             // +20% bonus during second week
307             return tokenAmount.mul(120).div(100);
308         } else if (now <= startTimestamp + 21 days) {
309             // +15% bonus during third week
310             return tokenAmount.mul(115).div(100);
311         } else if (now <= startTimestamp + 28 days) {
312             // +10% bonus during final week
313             return tokenAmount.mul(110).div(100);
314         } else {
315             // +10% bonus during final week
316             return tokenAmount.mul(110).div(100);
317         }
318     }
319 
320     function transfer(address _to, uint _value) isIcoFinished returns (bool) {
321         return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint _value) isIcoFinished returns (bool) {
325         return super.transferFrom(_from, _to, _value);
326     }
327 
328     modifier isIcoOpen() {
329         require(now >= startTimestamp);
330         require(now <= (startTimestamp + durationSeconds) || totalRaised < minCap);
331         require(totalRaised <= maxCap);
332         _;
333     }
334 
335     modifier isIcoFinished() {
336         require(now >= startTimestamp);
337         require(totalRaised >= maxCap || (now >= (startTimestamp + durationSeconds) && totalRaised >= minCap));
338         _;
339     }
340 }
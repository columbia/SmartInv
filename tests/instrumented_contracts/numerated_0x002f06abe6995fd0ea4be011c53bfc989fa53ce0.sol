1 pragma solidity 0.4.17;
2 
3 contract Ownable {
4     address public owner;
5 
6     /**
7      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
8      * account.
9      */
10     function Ownable() public {
11         owner = msg.sender;
12     }
13 
14     /**
15      * @dev Throws if called by any account other than the owner.
16      */
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22 }
23 
24 
25 contract TripCash is Ownable {
26 
27     uint256 public totalSupply = 5000000000 * 1 ether;
28 
29 
30     string public constant name = "TripCash";
31     string public constant symbol = "TASH";
32     uint8 public constant decimals = 18;
33 
34     mapping (address => uint256) public balances; //Addresses map
35     mapping (address => mapping(address => uint256)) public allowed;
36     mapping (address => bool) public notransfer;
37 
38 
39     uint256 public startPreICO = 1523840400; // preICO  start date
40     uint256 public endPreICO = 1528675199; // preICO  finish date
41     uint256 public startTime = 1529884800; // ICO  start date
42     uint256 public endTime = 1532303999; // ICO  finish date
43 
44 
45     address public constant ownerWallet = 0x9dA14C46f0182D850B12866AB0f3e397Fbd4FaC4; // Owner wallet address
46     address public constant teamWallet1 = 0xe82F49A648FADaafd468E65a13C050434a4C4a6f ; // Team wallet address
47     address public constant teamWallet2 = 0x16Eb7B7E232590787F1Fe3742acB1a1d0e43AF2A; // Team wallet address
48     address public constant fundWallet = 0x949844acF5C722707d02A037D074cabe7474e0CB; // Fund wallet address
49     address public constant frozenWallet2y = 0xAc77c90b37AFd80D2227f74971e7c3ad3e29D1fb; // For rest token frozen 2 year
50     address public constant frozenWallet4y = 0x265B8e89DAbA5Bdc330E55cA826a9f2e0EFf0870; // For rest token frozen 4 year
51 
52     uint256 public constant ownerPercent = 10; // Owner percent token rate
53     uint256 public constant teamPercent = 10; // Team percent token rate
54     uint256 public constant bountyPercent = 10; // Bounty percent token rate
55 
56     bool public transferAllowed = false;
57     bool public refundToken = false;
58 
59     /**
60      * Token constructor
61      *
62      **/
63     function TripCash() public {
64         balances[owner] = totalSupply;
65     }
66 
67     /**
68      *  Modifier for checking token transfer
69      */
70     modifier canTransferToken(address _from) {
71         if (_from != owner) {
72             require(transferAllowed);
73         }
74         
75         if (_from == teamWallet1) {
76             require(now >= endTime + 15552000);
77         }
78 
79         if (_from == teamWallet2) {
80             require(now >= endTime + 31536000);
81         }
82         
83         _;
84     }
85 
86     /**
87      *  Modifier for checking transfer allownes
88      */
89     modifier notAllowed(){
90         require(!transferAllowed);
91         _;
92     }
93 
94     /**
95      *  Modifier for checking ICO period
96      */
97     modifier saleIsOn() {
98         require((now > startTime && now < endTime)||(now > startPreICO && now < endPreICO));
99         _;
100     }
101 
102     /**
103      *  Modifier for checking refund allownes
104      */
105 
106     modifier canRefundToken() {
107         require(refundToken);
108         _;
109     }
110 
111     /**
112      * @dev Allows the current owner to transfer control of the contract to a newOwner.
113      * @param _newOwner The address to transfer ownership to.
114      */
115     function transferOwnership(address _newOwner) onlyOwner public {
116         require(_newOwner != address(0));
117         uint256 tokenValue = balances[owner];
118 
119         transfer(_newOwner, tokenValue);
120         owner = _newOwner;
121 
122         OwnershipTransferred(owner, _newOwner);
123 
124     }
125 
126     /**
127      *
128      *   Adding bonus tokens for bounty, team and owner needs. Should be used by DAPPs
129      */
130     function dappsBonusCalc(address _to, uint256 _value) onlyOwner saleIsOn() notAllowed public returns (bool) {
131 
132         require(_value != 0);
133         transfer(_to, _value);
134         notransfer[_to] = true;
135 
136         uint256 bountyTokenAmount = 0;
137         uint256 ownerTokenAmount = 0;
138         uint256 teamTokenAmount = 0;
139 
140         //calc bounty bonuses
141         bountyTokenAmount = _value * bountyPercent / 60;
142 
143         //calc owner bonuses
144         ownerTokenAmount = _value * ownerPercent / 60;
145 
146         //calc teamTokenAmount bonuses
147         teamTokenAmount = _value * teamPercent / 60;
148         
149         transfer(ownerWallet, ownerTokenAmount);
150         transfer(fundWallet, bountyTokenAmount);
151         transfer(teamWallet1, teamTokenAmount);
152         transfer(teamWallet2, teamTokenAmount);
153 
154         return true;
155     }
156 
157     /**
158      *
159      *   Return number of tokens for address
160      */
161     function balanceOf(address _owner) public view returns (uint256 balance) {
162         return balances[_owner];
163     }
164     /**
165      * @dev Transfer tokens from one address to another
166      * @param _to address The address which you want to transfer to
167      * @param _value uint256 the amount of tokens to be transferred
168      */
169     function transfer(address _to, uint256 _value) canTransferToken(msg.sender) public returns (bool){
170         require(_to != address(0));
171         require(balances[msg.sender] >= _value);
172         balances[msg.sender] = balances[msg.sender] - _value;
173         balances[_to] = balances[_to] + _value;
174         if (notransfer[msg.sender] == true) {
175             notransfer[msg.sender] = false;
176         }
177 
178         Transfer(msg.sender, _to, _value);
179         return true;
180     }
181 
182     /**
183      * @dev Transfer tokens from one address to another
184      * @param _from address The address which you want to send tokens from
185      * @param _to address The address which you want to transfer to
186      * @param _value uint256 the amount of tokens to be transferred
187      */
188     function transferFrom(address _from, address _to, uint256 _value) canTransferToken(_from) public returns (bool) {
189         require(_to != address(0));
190         require(_value <= balances[_from]);
191         require(_value <= allowed[_from][msg.sender]);
192 
193         balances[_from] = balances[_from] - _value;
194         balances[_to] = balances[_to] + _value;
195         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
196 
197         Transfer(_from, _to, _value);
198         return true;
199     }
200 
201     /**
202      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
203      *
204      * Beware that changing an allowance with this method brings the risk that someone may use both the old
205      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      * @param _spender The address which will spend the funds.
209      * @param _value The amount of tokens to be spent.
210      */
211     function approve(address _spender, uint256 _value) public returns (bool) {
212         allowed[msg.sender][_spender] = _value;
213         Approval(msg.sender, _spender, _value);
214         return true;
215     }
216 
217     /**
218      * approve should be called when allowed[_spender] == 0. To increment
219      * allowed value is better to use this function to avoid 2 calls (and wait until
220      * the first transaction is mined)
221      * From MonolithDAO Token.sol
222      */
223     function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
224         allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;
225         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226         return true;
227     }
228 
229     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
230         uint oldValue = allowed[msg.sender][_spender];
231         if (_subtractedValue > oldValue) {
232             allowed[msg.sender][_spender] = 0;
233         } else {
234             allowed[msg.sender][_spender] = oldValue - _subtractedValue;
235         }
236         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237         return true;
238     }
239 
240     /**
241      * @dev Function to check the amount of tokens that an owner allowed to a spender.
242      * @param _owner address The address which owns the funds.
243      * @param _spender address The address which will spend the funds.
244      * @return A uint256 specifying the amount of tokens still available for the spender.
245      */
246     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
247         return allowed[_owner][_spender];
248     }
249 
250     /**
251      * @dev function for rewarding token holders, who didn't transfer in 1 or 2 years
252      * @param _holder token holders address
253      */
254 
255     function rewarding(address _holder) public onlyOwner returns(uint){
256         if(notransfer[_holder]==true){
257             if(now >= endTime + 63072000){
258                 uint noTransfer2BonusYear = balances[_holder]*25 / 100;
259                 if (balances[fundWallet] >= noTransfer2BonusYear) {
260                     balances[fundWallet] = balances[fundWallet] - noTransfer2BonusYear;
261                     balances[_holder] = balances[_holder] + noTransfer2BonusYear;
262                     assert(balances[_holder] >= noTransfer2BonusYear);
263                     Transfer(fundWallet, _holder, noTransfer2BonusYear);
264                     notransfer[_holder]=false;
265                     return noTransfer2BonusYear;
266                 }
267             } else if (now >= endTime + 31536000) {
268                 uint noTransferBonusYear = balances[_holder]*15 / 100;
269                 if (balances[fundWallet] >= noTransferBonusYear) {
270                     balances[fundWallet] = balances[fundWallet] - noTransferBonusYear;
271                     balances[_holder] = balances[_holder] + noTransferBonusYear;
272                     assert(balances[_holder] >= noTransferBonusYear);
273                     Transfer(fundWallet, _holder, noTransferBonusYear);
274                     notransfer[_holder]=false;
275                     return noTransferBonusYear;
276                 }
277             }
278         }
279     }
280     
281     /**
282      * Unsold and undistributed tokens will be vested (50% for 2 years, 50% for 4 years) 
283      * to be allocated for the future development needs of the project; 
284      * in case of high unexpected volatility of the token, 
285      * part or all of the vested tokens can be burned to support the token's value.
286      * /
287     /**
288      * function for after ICO burning tokens which was not bought
289      * @param _value uint256 Amount of burning tokens
290      */
291     function burn(uint256 _value) onlyOwner public returns (bool){
292         require(_value > 0);
293         require(_value <= balances[msg.sender]);
294         // no need to require value <= totalSupply, since that would imply the
295         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
296 
297         address burner = msg.sender;
298         balances[burner] = balances[burner] - _value;
299         totalSupply = totalSupply - _value;
300         Burn(burner, _value);
301         return true;
302     }
303     
304     /**
305      *  Allownes refund
306      */
307     function changeRefundToken() public onlyOwner {
308         require(now >= endTime);
309         refundToken = true;
310     }
311     
312      /**
313      *  function for finishing ICO and allowed token transfer
314      */
315     function finishICO() public onlyOwner returns (bool) {
316         uint frozenBalance = balances[msg.sender]/2;
317         transfer(frozenWallet2y, frozenBalance);
318         transfer(frozenWallet4y, balances[msg.sender]);
319         transferAllowed = true;
320         return true;
321     }
322 
323     /**
324      * return investor tokens and burning
325      * 
326      */
327     function refund()  canRefundToken public returns (bool){
328         uint256 _value = balances[msg.sender];
329         balances[msg.sender] = 0;
330         totalSupply = totalSupply - _value;
331         Refund(msg.sender, _value);
332         return true;
333     }
334 
335     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
336     event Approval(address indexed owner, address indexed spender, uint256 value);
337     event Transfer(address indexed from, address indexed to, uint256 value);
338     event Burn(address indexed burner, uint256 value);
339     event Refund(address indexed refuner, uint256 value);
340 
341 }
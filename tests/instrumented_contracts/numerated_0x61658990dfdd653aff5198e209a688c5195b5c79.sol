1 pragma solidity ^0.4.24;
2 /*
3 * 1st Crypto Trader (DTH)
4 */
5 library SafeMath {
6  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7      if (a == 0) {
8          return 0;
9      }
10      uint256 c = a * b;
11      assert(c / a == b);
12      return c;
13  }
14 
15  function div(uint256 a, uint256 b) internal pure returns (uint256) {
16      // assert(b > 0); // Solidity automatically throws when dividing by 0
17      uint256 c = a / b;
18      // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19      return c;
20  }
21 
22  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23      assert(b <= a);
24      return a - b;
25  }
26 
27  function add(uint256 a, uint256 b) internal pure returns (uint256) {
28      uint256 c = a + b;
29      assert(c >= a);
30      return c;
31  }
32 }
33 
34 
35 contract CryptoTrader {
36  using SafeMath for uint256;
37  mapping(address => uint256) balances; // array with all balances
38  mapping (address => mapping (address => uint256)) internal allowed;
39  mapping (address => uint256) public ETHBalance; // array with spend ETH
40 
41  uint256 public totalSupply; // emitted tokens
42  address public contract_owner_address;
43 
44  event Transfer(address indexed from, address indexed to, uint256 value);
45  event Approval(address indexed owner, address indexed buyer, uint256 value);
46  event Burn(address indexed burner, uint256 value);
47 
48  string public constant name = "Digital Humanity Token";
49  string public constant symbol = "DHT";
50  uint8 public decimals = 0;
51  uint public start_sale = 1537952400; // start of presale Thu, 26 Sep 2018 09:00:00 GMT
52  uint public presalePeriod = 61; // presale period in days
53  address public affiliateAddress ;
54 
55  uint public maxAmountPresale_USD = 40000000; // 400,000 US dollars.
56  uint public soldAmount_USD = 0; // current tokens sale amount in US dollars
57 
58 
59  /* Initializes contract with initial supply tokens to the creator of the contract */
60  constructor (
61      uint256 initialSupply,
62      address _affiliateAddress
63  ) public {
64      totalSupply = initialSupply;
65      affiliateAddress = _affiliateAddress;
66      contract_owner_address = msg.sender;
67      balances[contract_owner_address] = getPercent(totalSupply,75); // tokens for selling
68      balances[affiliateAddress] = getPercent(totalSupply,25); //  affiliate 15% developers 10%
69  }
70 
71  /**
72  * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
73  *
74  * Beware that changing an allowance with this method brings the risk that someone may use both the old
75  * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
76  * race condition is to first reduce the buyer's allowance to 0 and set the desired value afterwards:
77  * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78  * @param _buyer The address which will spend the funds.
79  * @param _value The amount of tokens to be spent.
80  */
81  function approve(address _buyer, uint256 _value) public returns (bool) {
82      allowed[msg.sender][_buyer] = _value;
83      emit Approval(msg.sender, _buyer, _value);
84      return true;
85  }
86 
87  /**
88  * @dev Function to check the amount of tokens that an owner allowed to a buyer.
89  * @param _owner address The address which owns the funds.
90  * @param _buyer address The address which will spend the funds.
91  * @return A uint256 specifying the amount of tokens still available for the buyer.
92  */
93  function allowance(address _owner, address _buyer) public view returns (uint256) {
94      return allowed[_owner][_buyer];
95  }
96 
97  /**
98  * @dev Gets the balance of the specified address.
99  * @param _owner The address to query the the balance of.
100  * @return An uint256 representing the amount owned by the passed address.
101  */
102  function balanceOf(address _owner) public view returns (uint256 balance) {
103      return balances[_owner];
104  }
105 
106  /**
107  * @dev Transfer tokens from one address to another
108  * @param _from address The address which you want to send tokens from
109  * @param _to address The address which you want to transfer to
110  * @param _value uint256 the amount of tokens to be transferred
111  */
112  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
113      require(_to != address(0));
114      require(_value <= balances[_from]);
115      require(_value <= allowed[_from][msg.sender]);
116 
117      balances[_from] = balances[_from].sub(_value);
118      balances[_to] = balances[_to].add(_value);
119      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120      emit Transfer(_from, _to, _value);
121      return true;
122  }
123 
124  /**
125  * @dev transfer token for a specified address
126  * @param _to The address to transfer to.
127  * @param _value The amount to be transferred.
128  */
129  
130  function transfer(address _to, uint256 _value) public returns (bool) {
131      require(_to != address(0));
132      require(_value <= balances[msg.sender]);
133 
134      // SafeMath.sub will throw if there is not enough balance.
135      balances[msg.sender] = balances[msg.sender].sub(_value);
136      balances[_to] = balances[_to].add(_value);
137      emit Transfer(msg.sender, _to, _value);
138      return true;
139  }
140 
141  /**
142  * @dev sale token for a specified address
143  * @param _to The address to transfer to.
144  * @param _value The amount to be transferred.
145  * @param _eth_price spended eth for buying tokens.
146  * @param _usd_amount spended usd for buying tokens.
147  */
148  
149  function transferSale(address _to, uint256 _value, uint256 _eth_price, uint256 _usd_amount) public  returns (bool success) {
150      transfer(_to, _value);
151      ETHBalance[_to] = ETHBalance[_to].add(_eth_price);
152      soldAmount_USD += _usd_amount;
153      return true;
154  }
155 
156  /**
157  * @dev Burns a specific amount of tokens.
158  * @param _value The amount of token to be burned.
159  */
160  
161  function burn(uint256 _value) public {
162      require(_value <= balances[msg.sender]);
163      address burner = msg.sender;
164      balances[burner] = balances[burner].sub(_value);
165      totalSupply = totalSupply.sub(_value);
166      emit Burn(burner, _value);
167  }
168 
169  /**
170  * @dev Refund request.
171  * @param _to The address for refund.
172  */
173  
174  function refund(address _to) public payable returns(bool){
175      require(address(this).balance > 0);
176      uint256 _value = balances[_to];
177      uint256 ether_value = ETHBalance[_to];
178      require(now > start_sale + presalePeriod * 1 days && soldAmount_USD < maxAmountPresale_USD);
179      require(_value > 0);
180      require(ether_value > 0);
181      balances[_to] = balances[_to].sub(_value);
182      balances[contract_owner_address] = balances[contract_owner_address].add(_value);
183      ETHBalance[_to] = 0;
184      approve(_to, ether_value);
185      address(_to).transfer(ether_value);
186      return true;
187  }
188 
189  /**
190  * @dev Deposit contrac.
191  * @param _value The amount to be transferred.
192  */
193  
194  function depositContrac(uint256 _value) public payable returns(bool){
195      approve(address(this), _value);
196      return  address(this).send(_value);
197  }
198 
199  function getPercent(uint _value, uint _percent) internal pure returns(uint quotient){
200      uint _quotient = _value.mul(_percent).div(100);
201      return ( _quotient);
202  }
203 }
1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract CloverCoin {
33   using SafeMath for uint256;
34 
35   string public name = "CloverCoin";
36   string public symbol = "CVC";
37   uint public decimals = 18;
38   uint256 public totalSupply;
39   uint256 public commission;
40   uint256 public denominator;
41   address public cvcOwner;
42   mapping(address => uint256) balances;
43   mapping (address => mapping (address => uint256)) internal allowed;
44   
45   event Transfer(address indexed from, address indexed to, uint256 value);
46   event Approval(address indexed owner, address indexed spender, uint256 value);
47 
48   function CloverCoin(address _cvcOwner) public {
49     totalSupply = 10000000000e18;
50 
51     // CVC transfer fee rate
52     commission = 5; // numerator
53     denominator = 1000; // denominator
54     
55     cvcOwner = _cvcOwner;
56     balances[_cvcOwner] = totalSupply; // Specify initial ratio
57   }
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value.sub(_value.mul(commission).div(denominator)));
71     balances[cvcOwner] = balances[cvcOwner].add(_value.mul(commission).div(denominator));
72     Transfer(msg.sender, _to, _value.sub(_value.mul(commission).div(denominator)));
73     Transfer(msg.sender, cvcOwner, _value.mul(commission).div(denominator));
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of.
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public view returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86   /**
87    * @dev Transfer tokens from one address to another
88    * @param _from address The address which you want to send tokens from
89    * @param _to address The address which you want to transfer to
90    * @param _value uint256 the amount of tokens to be transferred
91    */
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96 
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value.sub(_value.mul(commission).div(denominator)));
99     balances[cvcOwner] = balances[cvcOwner].add(_value.mul(commission).div(denominator));
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     Transfer(_from, _to, _value.sub(_value.mul(commission).div(denominator)));
102     Transfer(_from, cvcOwner, _value.mul(commission).div(denominator));
103     return true;
104   }
105 
106   /**
107    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
108    *
109    * Beware that changing an allowance with this method brings the risk that someone may use both the old
110    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
111    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
112    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) public returns (bool) {
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Function to check the amount of tokens that an owner allowed to a spender.
124    * @param _owner address The address which owns the funds.
125    * @param _spender address The address which will spend the funds.
126    * @return A uint256 specifying the amount of tokens still available for the spender.
127    */
128   function allowance(address _owner, address _spender) public view returns (uint256) {
129     return allowed[_owner][_spender];
130   }
131 
132   /**
133    * @dev Increase the amount of tokens that an owner allowed to a spender.
134    *
135    * approve should be called when allowed[_spender] == 0. To increment
136    * allowed value is better to use this function to avoid 2 calls (and wait until
137    * the first transaction is mined)
138    * From MonolithDAO Token.sol
139    * @param _spender The address which will spend the funds.
140    * @param _addedValue The amount of tokens to increase the allowance by.
141    */
142   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
143     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
144     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
145     return true;
146   }
147 
148   /**
149    * @dev Decrease the amount of tokens that an owner allowed to a spender.
150    *
151    * approve should be called when allowed[_spender] == 0. To decrement
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _subtractedValue The amount of tokens to decrease the allowance by.
157    */
158   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
159     uint oldValue = allowed[msg.sender][_spender];
160     if (_subtractedValue > oldValue) {
161       allowed[msg.sender][_spender] = 0;
162     } else {
163       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
164     }
165     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 }
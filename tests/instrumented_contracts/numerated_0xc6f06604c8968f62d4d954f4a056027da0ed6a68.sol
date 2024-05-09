1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4   function sub(uint a, uint b) internal pure returns (uint) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint a, uint b) internal pure returns (uint) {
9     uint c = a + b;
10     assert(c >= a);
11     return c;
12   }
13 }
14 
15 contract ERC20Basic {
16   uint public totalSupply;
17   address public owner; //owner
18   function balanceOf(address who) constant public returns (uint);
19   function transfer(address to, uint value) public;
20   event Transfer(address indexed from, address indexed to, uint value);
21 }
22 
23 contract ERC20 is ERC20Basic {
24   function allowance(address owner, address spender) constant public returns (uint);
25   function transferFrom(address from, address to, uint value) public;
26   function approve(address spender, uint value) public;
27   event Approval(address indexed owner, address indexed spender, uint value);
28 }
29 
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint;
32   mapping(address => uint) balances;
33 
34   modifier onlyPayloadSize(uint size) {
35      assert(msg.data.length >= size + 4);
36      _;
37   }
38   /**
39   * @dev transfer token for a specified address
40   * @param _to The address to transfer to.
41   * @param _value The amount to be transferred.
42   */
43   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
44     balances[msg.sender] = balances[msg.sender].sub(_value);
45     if(_to == address(this)) {
46         balances[owner] = balances[owner].add(_value);
47         Transfer(msg.sender, owner, _value);
48     }
49     else {
50         balances[_to] = balances[_to].add(_value);
51         Transfer(msg.sender, _to, _value);
52     }
53   }
54   /**
55   * @dev Gets the balance of the specified address.
56   * @param _owner The address to query the the balance of. 
57   * @return An uint representing the amount owned by the passed address.
58   */
59   function balanceOf(address _owner) constant public returns (uint balance) {
60     return balances[_owner];
61   }
62 }
63 
64 contract StandardToken is BasicToken, ERC20 {
65   mapping (address => mapping (address => uint)) allowed;
66 
67   /**
68    * @dev Transfer tokens from one address to another
69    * @param _from address The address which you want to send tokens from
70    * @param _to address The address which you want to transfer to
71    * @param _value uint the amount of tokens to be transfered
72    */
73   function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
74     var _allowance = allowed[_from][msg.sender];
75     allowed[_from][msg.sender] = _allowance.sub(_value);
76     balances[_from] = balances[_from].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(_from, _to, _value);
79   }
80   /**
81    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
82    * @param _spender The address which will spend the funds.
83    * @param _value The amount of tokens to be spent.
84    */
85   function approve(address _spender, uint _value) public {
86     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87     assert(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));
88     allowed[msg.sender][_spender] = _value;
89     Approval(msg.sender, _spender, _value);
90   }
91   /**
92    * @dev Function to check the amount of tokens than an owner allowed to a spender.
93    * @param _owner address The address which owns the funds.
94    * @param _spender address The address which will spend the funds.
95    * @return A uint specifing the amount of tokens still avaible for the spender.
96    */
97   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
98     return allowed[_owner][_spender];
99   }
100 }
101 
102 /**
103  * @title SmartBillions contract
104  */
105 contract HodlReligion is StandardToken {
106 
107     // metadata
108     string public constant name = "HODL Religion Token";
109     string public constant symbol = "HODL"; // changed due to conflicts
110     uint public constant decimals = 18;
111     uint public minted = 0;
112 
113     modifier onlyOwner() {
114         assert(msg.sender == owner);
115         _;
116     }
117 
118     // constructor
119     function HodlReligion() public {
120         owner = msg.sender;
121         totalSupply = 200000000 * 10**18; // 100M
122     }
123 
124     /**
125      * @dev Send ether to buy tokens during ICO
126      * @dev or send less than 1 ether to contract to play
127      * @dev or send 0 to collect prize
128      */
129     function () payable external {
130         require(minted <= totalSupply);
131         if(msg.value > 0){
132             balances[msg.sender] += 10 ** 18; // 1 Token
133             minted += 10 ** 18;
134         }
135     }
136 
137     function getFund() external onlyOwner {
138         owner.transfer(this.balance);
139     }
140 
141 }
1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor()  public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 
88 contract HUBToken  is Ownable{
89     
90     using SafeMath for uint256;
91     
92     string public constant name = "HubiToken"; // solium-disable-line uppercase
93     string public constant symbol = "HUBTEST"; // solium-disable-line uppercase
94     uint8 public constant decimals = 18; // solium-disable-line uppercase
95     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
96 
97     mapping(address => uint256) balances;
98     
99     uint256 totalSupply_;
100 
101     /* This generates a public event on the blockchain that will notify clients */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 
106     /* This notifies clients about the amount burnt */
107     event Burn(address indexed burner, uint256 value);
108     
109     constructor()  public{
110         totalSupply_ = INITIAL_SUPPLY;
111         balances[msg.sender] = INITIAL_SUPPLY;
112         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
113     }
114 
115     /**
116     * @dev total number of tokens in existence
117     */
118     function totalSupply() public view returns (uint256) {
119         return totalSupply_;
120     }
121 
122     /**
123     * @dev transfer token for a specified address
124     * @param _to The address to transfer to.
125     * @param _value The amount to be transferred.
126     */
127     function transfer(address _to, uint256 _value) public returns (bool) {
128         require(_to != address(0));
129         require(_value <= balances[msg.sender]);
130 
131         balances[msg.sender] = balances[msg.sender].sub(_value);
132         balances[_to] = balances[_to].add(_value);
133         emit Transfer(msg.sender, _to, _value);
134         return true;
135     }
136 
137     /**
138     * @dev Gets the balance of the specified address.
139     * @param _owner The address to query the the balance of.
140     * @return An uint256 representing the amount owned by the passed address.
141     */
142     function balanceOf(address _owner) public view returns (uint256) {
143         return balances[_owner];
144     }
145 
146     /**
147     * @dev Burns a specific amount of tokens.
148     * @param _value The amount of token to be burned.
149     */
150     function burn(uint256 _value) public {
151         _burn(msg.sender, _value);
152     }
153 
154     function _burn(address _who, uint256 _value) internal {
155         require(_value > 0);
156         require(_value <= balances[_who]);
157         // no need to require value <= totalSupply, since that would imply the
158         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
159         balances[_who] = balances[_who].sub(_value);
160         totalSupply_ = totalSupply_.sub(_value);
161         emit Burn(_who, _value);
162         emit Transfer(_who, address(0), _value);
163     }
164 
165 }